package vn.dreamtech.myzoo.server.social;

import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.farm.FarmService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;
import vn.dreamtech.myzoo.server.time.TimeSource;
import vn.dreamtech.myzoo.server.zoo.ZooService;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;

public final class SocialService {
    public static final int MAX_FRIENDS = 50;
    public static final int MAX_HELP_PER_DAY = 10;
    public static final long HELP_REWARD_VANG = 60;

    private final DataSource dataSource;
    private final EconomyService economy;
    private final PlayerService players;
    private final FarmService farm;
    private final ZooService zoo;
    private final TimeSource time;

    public SocialService(DataSource dataSource, EconomyService economy, PlayerService players,
                         FarmService farm, ZooService zoo, TimeSource time) {
        this.dataSource = dataSource;
        this.economy = economy;
        this.players = players;
        this.farm = farm;
        this.zoo = zoo;
        this.time = time;
    }

    public record FriendView(int playerId, String name, String avatar, int farmLevel, int zooLevel, int zooAppeal) {
    }

    public record FriendsView(List<FriendView> friends, List<FriendView> incoming, List<FriendView> outgoing,
                              int helpsLeftToday) {
    }

    public record VisitView(int playerId, String name, String avatar, int farmLevel, int zooLevel,
                            List<FarmService.PlotView> plots, List<ZooService.HabitatView> habitats,
                            int totalAppeal, boolean isOpen, boolean canHelp) {
    }

    public record HelpResult(int friendId, long vangEarned, long vangBalance, int helpsLeftToday) {
    }

    public record RankRow(int rank, int playerId, String name, int zooLevel, int farmLevel, int score) {
    }

    // ---------- Kết bạn ----------
    public void sendRequest(int playerId, String friendName) {
        int friendId = findByName(friendName);
        if (friendId == playerId) throw new ApiException(400, "Không thể tự kết bạn với mình");
        String status = statusBetween(playerId, friendId);
        if ("ACCEPTED".equals(status)) throw new ApiException(409, "Hai người đã là bạn");
        if (status != null) throw new ApiException(409, "Đã có lời mời đang chờ");
        if (countFriends(playerId) >= MAX_FRIENDS) throw new ApiException(409, "Danh sách bạn đã đầy");

        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO friendships (requester_id, addressee_id, status, created_at) VALUES (?, ?, 'PENDING', ?)")) {
            ps.setInt(1, playerId);
            ps.setInt(2, friendId);
            ps.setTimestamp(3, new Timestamp(time.now()));
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi gửi lời mời: " + e.getMessage());
        }
    }

    public void accept(int playerId, int requesterId) {
        if (countFriends(playerId) >= MAX_FRIENDS) throw new ApiException(409, "Danh sách bạn đã đầy");
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE friendships SET status = 'ACCEPTED' WHERE requester_id = ? AND addressee_id = ? AND status = 'PENDING'")) {
            ps.setInt(1, requesterId);
            ps.setInt(2, playerId);
            if (ps.executeUpdate() == 0) throw new ApiException(404, "Không có lời mời này");
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi chấp nhận: " + e.getMessage());
        }
    }

    // Dùng chung cho từ chối lời mời và huỷ kết bạn.
    public void remove(int playerId, int otherId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "DELETE FROM friendships WHERE (requester_id = ? AND addressee_id = ?) OR (requester_id = ? AND addressee_id = ?)")) {
            ps.setInt(1, playerId);
            ps.setInt(2, otherId);
            ps.setInt(3, otherId);
            ps.setInt(4, playerId);
            if (ps.executeUpdate() == 0) throw new ApiException(404, "Không có quan hệ bạn bè này");
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi xoá bạn: " + e.getMessage());
        }
    }

    public FriendsView view(int playerId) {
        players.requirePlayer(playerId);
        return new FriendsView(
                query("SELECT CASE WHEN requester_id = ? THEN addressee_id ELSE requester_id END AS other "
                    + "FROM friendships WHERE status = 'ACCEPTED' AND (requester_id = ? OR addressee_id = ?)",
                        playerId, playerId, playerId),
                query("SELECT requester_id AS other FROM friendships WHERE addressee_id = ? AND status = 'PENDING'",
                        playerId),
                query("SELECT addressee_id AS other FROM friendships WHERE requester_id = ? AND status = 'PENDING'",
                        playerId),
                MAX_HELP_PER_DAY - helpsToday(playerId));
    }

    // ---------- Thăm vườn ----------
    public VisitView visit(int playerId, int friendId) {
        players.requirePlayer(playerId);
        if (playerId != friendId && !"ACCEPTED".equals(statusBetween(playerId, friendId))) {
            throw new ApiException(403, "Chỉ thăm được nông trại của bạn bè");
        }
        var profile = players.profile(friendId);
        var farmView = farm.view(friendId);
        var zooView = zoo.view(friendId);
        boolean canHelp = playerId != friendId && !helpedToday(playerId, friendId)
                && helpsToday(playerId) < MAX_HELP_PER_DAY;
        return new VisitView(friendId, profile.name(), profile.avatar(), profile.farmLevel(), profile.zooLevel(),
                farmView.plots(), zooView.habitats(), zooView.totalAppeal(), zooView.isOpen(), canHelp);
    }

    // Giúp bạn: mỗi ngày giúp mỗi người 1 lần, tổng có trần — chống cày thưởng.
    public HelpResult help(int playerId, int friendId) {
        players.requirePlayer(playerId);
        if (playerId == friendId) throw new ApiException(400, "Không thể tự giúp mình");
        if (!"ACCEPTED".equals(statusBetween(playerId, friendId))) throw new ApiException(403, "Chưa phải bạn bè");
        if (helpedToday(playerId, friendId)) throw new ApiException(409, "Hôm nay đã giúp người này rồi");
        if (helpsToday(playerId) >= MAX_HELP_PER_DAY) throw new ApiException(409, "Hết lượt giúp hôm nay");

        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO friend_helps (helper_id, friend_id, day_key, created_at) VALUES (?, ?, ?, ?)")) {
            ps.setInt(1, playerId);
            ps.setInt(2, friendId);
            ps.setString(3, today());
            ps.setTimestamp(4, new Timestamp(time.now()));
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(409, "Hôm nay đã giúp người này rồi");
        }

        long balance = economy.earn(playerId, EconomyService.VANG, HELP_REWARD_VANG,
                "FRIEND_HELP", "player", String.valueOf(friendId));
        // Người được giúp cũng có quà nhỏ để việc giúp có ý nghĩa hai chiều.
        economy.earn(friendId, EconomyService.VANG, HELP_REWARD_VANG / 2,
                "FRIEND_HELPED", "player", String.valueOf(playerId));
        return new HelpResult(friendId, HELP_REWARD_VANG, balance, MAX_HELP_PER_DAY - helpsToday(playerId));
    }

    // ---------- Bảng xếp hạng ----------
    public List<RankRow> leaderboard(String type, int limit) {
        String column = switch (type == null ? "zoo" : type) {
            case "farm" -> "farm_xp";
            case "zoo" -> "zoo_xp";
            default -> throw new ApiException(400, "Loại bảng xếp hạng không hợp lệ");
        };
        int size = limit <= 0 || limit > 100 ? 20 : limit;
        List<RankRow> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT id, name, farm_xp, zoo_xp FROM players WHERE name IS NOT NULL ORDER BY " + column + " DESC, id ASC LIMIT ?")) {
            ps.setInt(1, size);
            try (ResultSet rs = ps.executeQuery()) {
                int rank = 0;
                while (rs.next()) {
                    int farmXp = rs.getInt("farm_xp");
                    int zooXp = rs.getInt("zoo_xp");
                    out.add(new RankRow(++rank, rs.getInt("id"), rs.getString("name"),
                            PlayerService.levelFor(zooXp), PlayerService.levelFor(farmXp),
                            "farm_xp".equals(column) ? farmXp : zooXp));
                }
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc bảng xếp hạng: " + e.getMessage());
        }
    }

    // ---------- Helper ----------
    String today() {
        return LocalDate.ofInstant(Instant.ofEpochMilli(time.now()), ZoneOffset.UTC).toString();
    }

    int findByName(String name) {
        String trimmed = name == null ? "" : name.trim();
        if (trimmed.isEmpty()) throw new ApiException(400, "Cần tên người chơi");
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT id FROM players WHERE name = ?")) {
            ps.setString(1, trimmed);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new ApiException(404, "Không tìm thấy người chơi tên này");
                return rs.getInt("id");
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi tìm người chơi: " + e.getMessage());
        }
    }

    String statusBetween(int a, int b) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT status FROM friendships WHERE (requester_id = ? AND addressee_id = ?) OR (requester_id = ? AND addressee_id = ?)")) {
            ps.setInt(1, a);
            ps.setInt(2, b);
            ps.setInt(3, b);
            ps.setInt(4, a);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("status") : null;
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc quan hệ: " + e.getMessage());
        }
    }

    int countFriends(int playerId) {
        return query("SELECT CASE WHEN requester_id = ? THEN addressee_id ELSE requester_id END AS other "
                   + "FROM friendships WHERE status = 'ACCEPTED' AND (requester_id = ? OR addressee_id = ?)",
                playerId, playerId, playerId).size();
    }

    int helpsToday(int playerId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT COUNT(*) FROM friend_helps WHERE helper_id = ? AND day_key = ?")) {
            ps.setInt(1, playerId);
            ps.setString(2, today());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đếm lượt giúp: " + e.getMessage());
        }
    }

    boolean helpedToday(int playerId, int friendId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT 1 FROM friend_helps WHERE helper_id = ? AND friend_id = ? AND day_key = ?")) {
            ps.setInt(1, playerId);
            ps.setInt(2, friendId);
            ps.setString(3, today());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi kiểm tra lượt giúp: " + e.getMessage());
        }
    }

    private List<FriendView> query(String sql, int... params) {
        List<Integer> ids = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) ps.setInt(i + 1, params[i]);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ids.add(rs.getInt("other"));
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc danh sách bạn: " + e.getMessage());
        }
        List<FriendView> out = new ArrayList<>();
        for (int id : ids) {
            var profile = players.profile(id);
            out.add(new FriendView(id, profile.name(), profile.avatar(),
                    profile.farmLevel(), profile.zooLevel(), zoo.view(id).totalAppeal()));
        }
        return out;
    }
}
