package vn.dreamtech.myzoo.server.minigame;

import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;
import vn.dreamtech.myzoo.server.time.TimeSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Random;
import java.util.UUID;

public final class MinigameService {
    public static final int MOVES_ALLOWED = 20;
    public static final int MAX_LINES = 15;
    public static final long VANG_PER_LINE = 20;

    private final DataSource dataSource;
    private final EconomyService economy;
    private final PlayerService players;
    private final TimeSource time;
    private final Random random = new Random();

    public MinigameService(DataSource dataSource, EconomyService economy, PlayerService players, TimeSource time) {
        this.dataSource = dataSource;
        this.economy = economy;
        this.players = players;
        this.time = time;
    }

    public record Session(String sessionId, long seed, int movesAllowed, int maxLines, long vangPerLine) {
    }

    public record FinishResult(String sessionId, int linesCounted, long vangReward, long vangBalance,
                               boolean newlyFinished) {
    }

    public Session create(int playerId) {
        players.requirePlayer(playerId);
        String id = UUID.randomUUID().toString();
        long seed = random.nextLong();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO minigame_sessions (id, player_id, seed, moves_allowed, max_lines, created_at) VALUES (?, ?, ?, ?, ?, ?)")) {
            ps.setString(1, id);
            ps.setInt(2, playerId);
            ps.setLong(3, seed);
            ps.setInt(4, MOVES_ALLOWED);
            ps.setInt(5, MAX_LINES);
            ps.setTimestamp(6, new Timestamp(time.now()));
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi tạo phiên minigame: " + e.getMessage());
        }
        return new Session(id, seed, MOVES_ALLOWED, MAX_LINES, VANG_PER_LINE);
    }

    public FinishResult finish(int playerId, String sessionId, int linesMade) {
        players.requirePlayer(playerId);
        if (linesMade < 0) throw new ApiException(400, "linesMade không hợp lệ");
        SessionRow row = find(sessionId);
        if (row == null || row.playerId != playerId) throw new ApiException(404, "Không tìm thấy phiên minigame");
        if (row.finished) {
            return new FinishResult(sessionId, row.linesMade, row.reward,
                    economy.balances(playerId).get(EconomyService.VANG), false);
        }
        int counted = Math.min(linesMade, row.maxLines);
        long reward = counted * VANG_PER_LINE;
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE minigame_sessions SET finished = TRUE, lines_made = ?, reward = ? WHERE id = ? AND finished = FALSE")) {
            ps.setInt(1, counted);
            ps.setLong(2, reward);
            ps.setString(3, sessionId);
            if (ps.executeUpdate() == 0) {
                SessionRow done = find(sessionId);
                return new FinishResult(sessionId, done.linesMade, done.reward,
                        economy.balances(playerId).get(EconomyService.VANG), false);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi kết thúc minigame: " + e.getMessage());
        }
        long balance = reward > 0
                ? economy.earn(playerId, EconomyService.VANG, reward, "MINIGAME", "session", sessionId)
                : economy.balances(playerId).get(EconomyService.VANG);
        return new FinishResult(sessionId, counted, reward, balance, true);
    }

    private record SessionRow(int playerId, int maxLines, boolean finished, int linesMade, long reward) {
    }

    private SessionRow find(String sessionId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT player_id, max_lines, finished, lines_made, reward FROM minigame_sessions WHERE id = ?")) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return new SessionRow(rs.getInt("player_id"), rs.getInt("max_lines"),
                        rs.getBoolean("finished"), rs.getInt("lines_made"), rs.getLong("reward"));
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc phiên minigame: " + e.getMessage());
        }
    }
}
