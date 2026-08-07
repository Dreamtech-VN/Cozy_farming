package vn.dreamtech.game.server.dao;

import vn.dreamtech.game.server.model.Wallet;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Bảng {@code wallets} — DDL:
 * <pre>
 * CREATE TABLE wallets (
 *   user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0
 * );
 * </pre>
 * Chưa từng lưu thì trả về 0/0 (khớp cách {@code UserSettingsDao}/{@code
 * LevelDao} đã làm) — người chơi mới KHÔNG được cấp sẵn vàng/kim cương
 * (khác dự án nông trại cũ có {@code STARTING_COINS}), vì game này chưa có
 * nguồn kiếm tiền nào (battle/quest) để cân bằng số khởi điểm hợp lý.
 */
public final class WalletDao {
    private final DataSource dataSource;

    public WalletDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public Wallet find(int userId) throws SQLException {
        String sql = "SELECT gold, diamond FROM wallets WHERE user_id = ?";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Wallet.defaultsFor(userId);
                return new Wallet(userId, rs.getLong("gold"), rs.getLong("diamond"));
            }
        }
    }

    private void save(Wallet w) throws SQLException {
        String sql = "MERGE INTO wallets (user_id, gold, diamond) KEY (user_id) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, w.userId());
            ps.setLong(2, w.gold());
            ps.setLong(3, w.diamond());
            ps.executeUpdate();
        }
    }

    public void addGold(int userId, long amount) throws SQLException {
        Wallet w = find(userId);
        save(new Wallet(userId, w.gold() + amount, w.diamond()));
    }

    public boolean spendGold(int userId, long amount) throws SQLException {
        Wallet w = find(userId);
        if (w.gold() < amount) return false;
        save(new Wallet(userId, w.gold() - amount, w.diamond()));
        return true;
    }

    public void addDiamond(int userId, long amount) throws SQLException {
        Wallet w = find(userId);
        save(new Wallet(userId, w.gold(), w.diamond() + amount));
    }

    public boolean spendDiamond(int userId, long amount) throws SQLException {
        Wallet w = find(userId);
        if (w.diamond() < amount) return false;
        save(new Wallet(userId, w.gold(), w.diamond() - amount));
        return true;
    }

    /**
     * Admin cộng/trừ TUỲ Ý (delta âm = trừ) — khác {@code spendGold}/{@code
     * spendDiamond} (chặn nếu không đủ), admin luôn được phép trừ, chỉ
     * chặn xuống ÂM (kẹp về 0) chứ không chặn thao tác.
     */
    public Wallet adjustGold(int userId, long delta) throws SQLException {
        Wallet w = find(userId);
        Wallet updated = new Wallet(userId, Math.max(0, w.gold() + delta), w.diamond());
        save(updated);
        return updated;
    }

    public Wallet adjustDiamond(int userId, long delta) throws SQLException {
        Wallet w = find(userId);
        Wallet updated = new Wallet(userId, w.gold(), Math.max(0, w.diamond() + delta));
        save(updated);
        return updated;
    }
}
