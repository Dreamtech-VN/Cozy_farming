package vn.dreamtech.cozyfarming.server.dao;

import vn.dreamtech.cozyfarming.server.model.Wallet;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Bảng THÊM MỚI {@code wallets} (ví xu/kim cương trong game — tách khỏi cột
 * {@code vnd}/{@code tongnap} thật trong bảng {@code users}, xem
 * {@link Wallet}). DDL:
 * <pre>
 * CREATE TABLE wallets (
 *   user_id INT NOT NULL PRIMARY KEY, coins BIGINT NOT NULL DEFAULT 500, gems BIGINT NOT NULL DEFAULT 0
 * );
 * </pre>
 * 500 xu khởi điểm khớp {@code defaultState()} phía client.
 */
public final class WalletDao {
    private static final long STARTING_COINS = 500;
    private final DataSource dataSource;

    public WalletDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public Wallet find(int userId) throws SQLException {
        String sql = "SELECT coins, gems FROM wallets WHERE user_id = ?";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return new Wallet(userId, rs.getLong("coins"), rs.getLong("gems"));
            }
        }
        // chưa có ví -> tạo ví khởi điểm (lần đầu người chơi thao tác gì đó cần ví)
        Wallet fresh = new Wallet(userId, STARTING_COINS, 0);
        save(fresh);
        return fresh;
    }

    public void save(Wallet w) throws SQLException {
        String sql = "MERGE INTO wallets (user_id, coins, gems) KEY (user_id) VALUES (?, ?, ?)";
        try (Connection c = dataSource.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, w.userId());
            ps.setLong(2, w.coins());
            ps.setLong(3, w.gems());
            ps.executeUpdate();
        }
    }

    /** Trừ xu nếu đủ, trả false nếu không đủ (không trừ). */
    public boolean spendCoins(int userId, long amount) throws SQLException {
        Wallet w = find(userId);
        if (w.coins() < amount) return false;
        save(new Wallet(userId, w.coins() - amount, w.gems()));
        return true;
    }

    public void addCoins(int userId, long amount) throws SQLException {
        Wallet w = find(userId);
        save(new Wallet(userId, w.coins() + amount, w.gems()));
    }
}
