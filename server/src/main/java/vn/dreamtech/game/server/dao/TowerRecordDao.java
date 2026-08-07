package vn.dreamtech.game.server.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Bảng {@code tower_records} — DDL:
 * <pre>
 * CREATE TABLE tower_records (
 *   user_id INT NOT NULL, tower_id INT NOT NULL, best_floor INT NOT NULL DEFAULT 0,
 *   PRIMARY KEY (user_id, tower_id)
 * );
 * </pre>
 * Tầng cao nhất từng đạt của 1 người chơi trong 1 tháp — phục vụ bảng xếp
 * hạng Tower (TODO ghi ở Giai đoạn 15), KHÔNG lưu lịch sử leo, chỉ giữ kỷ
 * lục tốt nhất.
 */
public final class TowerRecordDao {
    private final DataSource dataSource;

    public TowerRecordDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public record Record(int userId, int towerId, int bestFloor) {
    }

    /** Cập nhật kỷ lục NẾU {@code floorReached} cao hơn kỷ lục hiện có (no-op nếu không cải thiện). */
    public void updateBestFloorIfHigher(int userId, int towerId, int floorReached) throws SQLException {
        String selectSql = "SELECT best_floor FROM tower_records WHERE user_id = ? AND tower_id = ?";
        int current = 0;
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(selectSql)) {
            ps.setInt(1, userId);
            ps.setInt(2, towerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) current = rs.getInt("best_floor");
            }
        }
        if (floorReached <= current) return;
        String mergeSql = "MERGE INTO tower_records (user_id, tower_id, best_floor) KEY (user_id, tower_id) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(mergeSql)) {
            ps.setInt(1, userId);
            ps.setInt(2, towerId);
            ps.setInt(3, floorReached);
            ps.executeUpdate();
        }
    }

    public List<Record> listByTower(int towerId) throws SQLException {
        String sql = "SELECT user_id, tower_id, best_floor FROM tower_records WHERE tower_id = ? ORDER BY best_floor DESC";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, towerId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Record> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(new Record(rs.getInt("user_id"), rs.getInt("tower_id"), rs.getInt("best_floor")));
                }
                return list;
            }
        }
    }
}
