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
import java.util.List;
import java.util.Random;
import java.util.UUID;

public final class MinigameService {
    // Mỗi loại game khai báo luật riêng; server luôn kẹp điểm theo maxScore nên client không tự thưởng được.
    public record GameDef(String id, String name, int movesAllowed, int maxScore, long vangPerScore) {
    }

    public static final List<GameDef> GAMES = List.of(
            new GameDef("MATCH3", "Ghép trái cây", 20, 15, 20),
            new GameDef("MEMORY", "Lật hình đôi", 30, 8, 40));

    public static GameDef game(String id) {
        return GAMES.stream().filter(g -> g.id().equals(id)).findFirst()
                .orElseThrow(() -> new ApiException(404, "Không có minigame này"));
    }

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

    public record Session(String sessionId, String gameType, long seed, int movesAllowed, int maxScore,
                          long vangPerScore) {
    }

    public record FinishResult(String sessionId, String gameType, int scoreCounted, long vangReward,
                               long vangBalance, boolean newlyFinished) {
    }

    public Session create(int playerId, String gameType) {
        players.requirePlayer(playerId);
        GameDef def = game(gameType == null ? "MATCH3" : gameType);
        String id = UUID.randomUUID().toString();
        long seed = random.nextLong();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO minigame_sessions (id, player_id, seed, moves_allowed, max_lines, game_type, created_at) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?)")) {
            ps.setString(1, id);
            ps.setInt(2, playerId);
            ps.setLong(3, seed);
            ps.setInt(4, def.movesAllowed());
            ps.setInt(5, def.maxScore());
            ps.setString(6, def.id());
            ps.setTimestamp(7, new Timestamp(time.now()));
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi tạo phiên minigame: " + e.getMessage());
        }
        return new Session(id, def.id(), seed, def.movesAllowed(), def.maxScore(), def.vangPerScore());
    }

    public FinishResult finish(int playerId, String sessionId, int score) {
        players.requirePlayer(playerId);
        if (score < 0) throw new ApiException(400, "Điểm không hợp lệ");
        SessionRow row = find(sessionId);
        if (row == null || row.playerId != playerId) throw new ApiException(404, "Không tìm thấy phiên minigame");
        GameDef def = game(row.gameType);
        if (row.finished) {
            return new FinishResult(sessionId, def.id(), row.linesMade, row.reward,
                    economy.balances(playerId).get(EconomyService.VANG), false);
        }
        int counted = Math.min(score, row.maxLines);
        long reward = counted * def.vangPerScore();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE minigame_sessions SET finished = TRUE, lines_made = ?, reward = ? WHERE id = ? AND finished = FALSE")) {
            ps.setInt(1, counted);
            ps.setLong(2, reward);
            ps.setString(3, sessionId);
            if (ps.executeUpdate() == 0) {
                SessionRow done = find(sessionId);
                return new FinishResult(sessionId, def.id(), done.linesMade, done.reward,
                        economy.balances(playerId).get(EconomyService.VANG), false);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi kết thúc minigame: " + e.getMessage());
        }
        long balance = reward > 0
                ? economy.earn(playerId, EconomyService.VANG, reward, "MINIGAME", "session", sessionId)
                : economy.balances(playerId).get(EconomyService.VANG);
        return new FinishResult(sessionId, def.id(), counted, reward, balance, true);
    }

    private record SessionRow(int playerId, int maxLines, boolean finished, int linesMade, long reward,
                              String gameType) {
    }

    private SessionRow find(String sessionId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT player_id, max_lines, finished, lines_made, reward, game_type FROM minigame_sessions WHERE id = ?")) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                String type = rs.getString("game_type");
                return new SessionRow(rs.getInt("player_id"), rs.getInt("max_lines"),
                        rs.getBoolean("finished"), rs.getInt("lines_made"), rs.getLong("reward"),
                        type == null ? "MATCH3" : type);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc phiên minigame: " + e.getMessage());
        }
    }
}
