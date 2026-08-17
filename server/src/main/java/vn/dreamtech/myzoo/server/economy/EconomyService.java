package vn.dreamtech.myzoo.server.economy;

import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.time.TimeSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public final class EconomyService {
    public static final String VANG = "VANG";
    public static final String KIM_CUONG = "KC";

    private final DataSource dataSource;
    private final TimeSource time;

    public EconomyService(DataSource dataSource, TimeSource time) {
        this.dataSource = dataSource;
        this.time = time;
    }

    public Map<String, Long> balances(int playerId) {
        String sql = "SELECT currency, balance FROM wallets WHERE player_id = ?";
        Map<String, Long> out = new LinkedHashMap<>();
        out.put(VANG, 0L);
        out.put(KIM_CUONG, 0L);
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.put(rs.getString("currency"), rs.getLong("balance"));
                }
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc ví: " + e.getMessage());
        }
    }

    public record LedgerEntry(long id, String currency, long amount, long balanceAfter,
                              String reason, String refType, String refId, long createdAt) {
    }

    // Lịch sử tiền vào/ra. Phân trang bằng cursor = id nhỏ nhất đã lấy, không dùng OFFSET
    // để trang sau không bị lệch khi có giao dịch mới chen vào.
    public static int pageSize(int requested) {
        return requested <= 0 || requested > 100 ? 30 : requested;
    }

    public List<LedgerEntry> history(int playerId, Long cursor, int limit) {
        int size = pageSize(limit);
        String sql = "SELECT id, currency, amount, balance_after, reason, ref_type, ref_id, created_at "
                + "FROM economy_ledger WHERE player_id = ?" + (cursor == null ? "" : " AND id < ?")
                + " ORDER BY id DESC LIMIT ?";
        List<LedgerEntry> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            int index = 1;
            ps.setInt(index++, playerId);
            if (cursor != null) ps.setLong(index++, cursor);
            ps.setInt(index, size);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(new LedgerEntry(rs.getLong("id"), rs.getString("currency"), rs.getLong("amount"),
                            rs.getLong("balance_after"), rs.getString("reason"), rs.getString("ref_type"),
                            rs.getString("ref_id"), rs.getTimestamp("created_at").getTime()));
                }
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc lịch sử giao dịch: " + e.getMessage());
        }
    }

    public long earn(int playerId, String currency, long amount, String reason, String refType, String refId) {
        if (amount < 0) throw new ApiException(500, "amount phải >= 0");
        return apply(playerId, currency, amount, reason, refType, refId);
    }

    // Trừ tiền, 402 nếu không đủ — khoá dòng ví trong 1 transaction (spec §27.16).
    public long spend(int playerId, String currency, long amount, String reason, String refType, String refId) {
        if (amount < 0) throw new ApiException(500, "amount phải >= 0");
        return apply(playerId, currency, -amount, reason, refType, refId);
    }

    private long apply(int playerId, String currency, long delta, String reason, String refType, String refId) {
        try (Connection c = dataSource.getConnection()) {
            c.setAutoCommit(false);
            try {
                long balance;
                try (PreparedStatement ps = c.prepareStatement(
                        "SELECT balance FROM wallets WHERE player_id = ? AND currency = ? FOR UPDATE")) {
                    ps.setInt(1, playerId);
                    ps.setString(2, currency);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            balance = rs.getLong("balance");
                        } else {
                            balance = 0;
                            try (PreparedStatement ins = c.prepareStatement(
                                    "INSERT INTO wallets (player_id, currency, balance) VALUES (?, ?, 0)")) {
                                ins.setInt(1, playerId);
                                ins.setString(2, currency);
                                ins.executeUpdate();
                            }
                        }
                    }
                }
                long after = balance + delta;
                if (after < 0) {
                    c.rollback();
                    throw new ApiException(402, "Không đủ " + (VANG.equals(currency) ? "Vàng" : "Kim Cương"));
                }
                try (PreparedStatement upd = c.prepareStatement(
                        "UPDATE wallets SET balance = ? WHERE player_id = ? AND currency = ?")) {
                    upd.setLong(1, after);
                    upd.setInt(2, playerId);
                    upd.setString(3, currency);
                    upd.executeUpdate();
                }
                try (PreparedStatement ledger = c.prepareStatement(
                        "INSERT INTO economy_ledger (player_id, currency, amount, balance_after, reason, ref_type, ref_id, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
                    ledger.setInt(1, playerId);
                    ledger.setString(2, currency);
                    ledger.setLong(3, delta);
                    ledger.setLong(4, after);
                    ledger.setString(5, reason);
                    ledger.setString(6, refType);
                    ledger.setString(7, refId);
                    ledger.setTimestamp(8, new Timestamp(time.now()));
                    ledger.executeUpdate();
                }
                c.commit();
                return after;
            } catch (SQLException e) {
                c.rollback();
                throw new ApiException(500, "Lỗi giao dịch ví: " + e.getMessage());
            } finally {
                c.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi kết nối ví: " + e.getMessage());
        }
    }
}
