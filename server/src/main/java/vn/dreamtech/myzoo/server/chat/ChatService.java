package vn.dreamtech.myzoo.server.chat;

import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;
import vn.dreamtech.myzoo.server.time.TimeSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public final class ChatService {
    public static final String WORLD = "WORLD";
    public static final String PRIVATE = "PRIVATE";
    public static final String SYSTEM = "SYSTEM";

    public static final String TYPE_TEXT = "TEXT";
    public static final String TYPE_STICKER = "STICKER";
    public static final String TYPE_GIF = "GIF";
    public static final String TYPE_VOICE = "VOICE";

    // Chống spam: tối thiểu 1s giữa 2 tin, tối đa 5 tin trong 10s, không lặp lại y hệt trong 30s.
    public static final long MIN_GAP_MS = 1000;
    public static final long WINDOW_MS = 10_000;
    public static final int MAX_IN_WINDOW = 5;
    public static final long DUPLICATE_WINDOW_MS = 30_000;

    // Tự động cấm chat khi vi phạm liên tiếp — không cần admin ngồi canh.
    public static final int AUTO_MUTE_VIOLATIONS = 3;
    public static final long VIOLATION_WINDOW_MS = 10 * 60 * 1000;
    public static final long AUTO_MUTE_MS = 15 * 60 * 1000;

    private final DataSource dataSource;
    private final PlayerService players;
    private final TimeSource time;

    public ChatService(DataSource dataSource, PlayerService players, TimeSource time) {
        this.dataSource = dataSource;
        this.players = players;
        this.time = time;
    }

    public record MessageView(long id, String channel, int senderId, String senderName, Integer targetId,
                              String type, String text, String refId, long createdAt, boolean deleted) {
    }

    public record SendResult(long id, String channel, String type, String text, String refId,
                             long createdAt, String notice) {
    }

    public record BanInfo(boolean banned, long until, String reason) {
    }

    public record RelationView(List<Integer> muted, List<Integer> blocked) {
    }

    // ---------- Gửi tin ----------
    public SendResult send(int playerId, String channel, Integer targetId, String type, String text, String refId) {
        players.requirePlayer(playerId);
        String ch = channel == null ? WORLD : channel.toUpperCase();
        if (!WORLD.equals(ch) && !PRIVATE.equals(ch)) throw new ApiException(400, "Kênh chat không hợp lệ");

        BanInfo ban = banInfo(playerId);
        if (ban.banned()) {
            throw new ApiException(403, "Bạn đang bị cấm chat đến " + formatUntil(ban.until())
                    + (ban.reason() == null ? "" : " (" + ban.reason() + ")"));
        }

        if (PRIVATE.equals(ch)) {
            if (targetId == null) throw new ApiException(400, "Cần targetId cho tin nhắn riêng");
            if (targetId == playerId) throw new ApiException(400, "Không thể nhắn cho chính mình");
            players.requirePlayer(targetId);
            if (relation(targetId, playerId, "BLOCK")) {
                throw new ApiException(403, "Người này đã chặn tin nhắn của bạn");
            }
        }

        String kind = type == null ? TYPE_TEXT : type.toUpperCase();
        String storedText = null;
        String storedRef = null;
        String notice = null;

        switch (kind) {
            case TYPE_TEXT -> {
                var result = ChatModeration.check(text);
                if (result.rejected()) {
                    int strikes = recordViolation(playerId, result.reason());
                    String extra = strikes >= AUTO_MUTE_VIOLATIONS ? " Bạn bị cấm chat 15 phút do vi phạm nhiều lần." : "";
                    throw new ApiException(422, result.reason() + "." + extra);
                }
                storedText = result.text();
                if (result.verdict() == ChatModeration.Verdict.MASKED) notice = result.reason();
            }
            case TYPE_STICKER -> {
                if (!ChatCatalog.hasSticker(refId)) throw new ApiException(404, "Sticker không hợp lệ");
                storedRef = refId;
            }
            case TYPE_GIF -> {
                if (!ChatCatalog.hasGif(refId)) throw new ApiException(404, "GIF không hợp lệ");
                storedRef = refId;
            }
            case TYPE_VOICE -> {
                if (refId == null || refId.isBlank()) throw new ApiException(400, "Cần voiceId");
                if (!ownsVoice(playerId, refId)) throw new ApiException(403, "Không dùng được đoạn ghi âm này");
                storedRef = refId;
            }
            default -> throw new ApiException(400, "Loại tin nhắn không hỗ trợ");
        }

        checkRateLimit(playerId, kind, storedText, storedRef);
        long id = insert(ch, playerId, targetId, kind, storedText, storedRef);
        return new SendResult(id, ch, kind, storedText, storedRef, time.now(), notice);
    }

    // Tin hệ thống: server tự phát, không qua kiểm duyệt vì không do người chơi nhập.
    public long system(String text) {
        return insert(SYSTEM, 0, null, TYPE_TEXT, text, null);
    }

    // ---------- Đọc tin ----------
    public List<MessageView> world(int playerId, Long sinceId, int limit) {
        players.requirePlayer(playerId);
        return read(playerId,
                "SELECT m.id, m.channel, m.sender_id, m.target_id, m.type, m.text, m.ref_id, m.created_at, m.deleted, "
                        + "p.name AS sender_name FROM chat_messages m LEFT JOIN players p ON p.id = m.sender_id "
                        + "WHERE m.channel IN ('WORLD','SYSTEM') AND m.id > ? ORDER BY m.id DESC LIMIT ?",
                sinceId, limit, null);
    }

    public List<MessageView> conversation(int playerId, int otherId, Long sinceId, int limit) {
        players.requirePlayer(playerId);
        players.requirePlayer(otherId);
        return read(playerId,
                "SELECT m.id, m.channel, m.sender_id, m.target_id, m.type, m.text, m.ref_id, m.created_at, m.deleted, "
                        + "p.name AS sender_name FROM chat_messages m LEFT JOIN players p ON p.id = m.sender_id "
                        + "WHERE m.channel = 'PRIVATE' AND m.id > ? "
                        + "AND ((m.sender_id = ? AND m.target_id = ?) OR (m.sender_id = ? AND m.target_id = ?)) "
                        + "ORDER BY m.id DESC LIMIT ?",
                sinceId, limit, new int[]{playerId, otherId, otherId, playerId});
    }

    private List<MessageView> read(int playerId, String sql, Long sinceId, int limit, int[] extraParams) {
        int size = limit <= 0 || limit > 100 ? 50 : limit;
        List<Integer> hidden = hiddenSenders(playerId);
        List<MessageView> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            int index = 1;
            ps.setLong(index++, sinceId == null ? 0 : sinceId);
            if (extraParams != null) for (int p : extraParams) ps.setInt(index++, p);
            ps.setInt(index, size);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int senderId = rs.getInt("sender_id");
                    if (hidden.contains(senderId)) continue;   // ẩn tin của người đã mute/block
                    boolean deleted = rs.getBoolean("deleted");
                    out.add(new MessageView(
                            rs.getLong("id"), rs.getString("channel"), senderId,
                            senderId == 0 ? "Hệ thống" : rs.getString("sender_name"),
                            rs.getObject("target_id") == null ? null : rs.getInt("target_id"),
                            rs.getString("type"),
                            deleted ? "(tin nhắn đã bị xoá)" : rs.getString("text"),
                            deleted ? null : rs.getString("ref_id"),
                            rs.getTimestamp("created_at").getTime(), deleted));
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc tin nhắn: " + e.getMessage());
        }
        java.util.Collections.reverse(out);   // trả về theo thứ tự thời gian tăng dần cho client
        return out;
    }

    // ---------- Người chơi tự quản lý ----------
    public void setRelation(int playerId, int targetId, String mode) {
        if (playerId == targetId) throw new ApiException(400, "Không thể tự chặn mình");
        players.requirePlayer(targetId);
        String kind = mode == null ? "" : mode.toUpperCase();
        if (!kind.equals("MUTE") && !kind.equals("BLOCK") && !kind.equals("NONE")) {
            throw new ApiException(400, "mode phải là MUTE, BLOCK hoặc NONE");
        }
        try (Connection c = dataSource.getConnection()) {
            try (PreparedStatement del = c.prepareStatement(
                    "DELETE FROM chat_relations WHERE player_id = ? AND target_id = ?")) {
                del.setInt(1, playerId);
                del.setInt(2, targetId);
                del.executeUpdate();
            }
            if (kind.equals("NONE")) return;
            try (PreparedStatement ins = c.prepareStatement(
                    "INSERT INTO chat_relations (player_id, target_id, mode, created_at) VALUES (?, ?, ?, ?)")) {
                ins.setInt(1, playerId);
                ins.setInt(2, targetId);
                ins.setString(3, kind);
                ins.setTimestamp(4, new Timestamp(time.now()));
                ins.executeUpdate();
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi cập nhật danh sách chặn: " + e.getMessage());
        }
    }

    public RelationView relations(int playerId) {
        List<Integer> muted = new ArrayList<>();
        List<Integer> blocked = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT target_id, mode FROM chat_relations WHERE player_id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    if ("BLOCK".equals(rs.getString("mode"))) blocked.add(rs.getInt("target_id"));
                    else muted.add(rs.getInt("target_id"));
                }
            }
            return new RelationView(muted, blocked);
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc danh sách chặn: " + e.getMessage());
        }
    }

    public void report(int playerId, long messageId, String reason) {
        players.requirePlayer(playerId);
        if (!messageExists(messageId)) throw new ApiException(404, "Không tìm thấy tin nhắn");
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO chat_reports (message_id, reporter_id, reason, created_at, handled) "
                        + "VALUES (?, ?, ?, ?, FALSE)")) {
            ps.setLong(1, messageId);
            ps.setInt(2, playerId);
            ps.setString(3, reason == null ? "" : reason.substring(0, Math.min(200, reason.length())));
            ps.setTimestamp(4, new Timestamp(time.now()));
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(409, "Bạn đã báo cáo tin nhắn này rồi");
        }
    }

    // ---------- Admin ----------
    public void deleteMessage(long messageId, int adminId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE chat_messages SET deleted = TRUE, deleted_by = ? WHERE id = ? AND deleted = FALSE")) {
            ps.setInt(1, adminId);
            ps.setLong(2, messageId);
            if (ps.executeUpdate() == 0) throw new ApiException(404, "Không tìm thấy tin nhắn hoặc đã xoá");
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi xoá tin nhắn: " + e.getMessage());
        }
    }

    public BanInfo banChat(int playerId, long minutes, String reason) {
        players.requirePlayer(playerId);
        long until = time.now() + minutes * 60_000L;
        upsertBan(playerId, until, reason);
        return new BanInfo(minutes > 0, until, reason);
    }

    public void unbanChat(int playerId) {
        upsertBan(playerId, 0, null);
    }

    public List<MessageView> adminLog(String channel, Long sinceId, int limit) {
        int size = limit <= 0 || limit > 200 ? 100 : limit;
        String filter = channel == null || channel.isBlank() ? "" : " AND m.channel = ?";
        List<MessageView> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT m.id, m.channel, m.sender_id, m.target_id, m.type, m.text, m.ref_id, m.created_at, m.deleted, "
                        + "p.name AS sender_name FROM chat_messages m LEFT JOIN players p ON p.id = m.sender_id "
                        + "WHERE m.id > ?" + filter + " ORDER BY m.id DESC LIMIT ?")) {
            int index = 1;
            ps.setLong(index++, sinceId == null ? 0 : sinceId);
            if (!filter.isEmpty()) ps.setString(index++, channel.toUpperCase());
            ps.setInt(index, size);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int senderId = rs.getInt("sender_id");
                    out.add(new MessageView(rs.getLong("id"), rs.getString("channel"), senderId,
                            senderId == 0 ? "Hệ thống" : rs.getString("sender_name"),
                            rs.getObject("target_id") == null ? null : rs.getInt("target_id"),
                            rs.getString("type"), rs.getString("text"), rs.getString("ref_id"),
                            rs.getTimestamp("created_at").getTime(), rs.getBoolean("deleted")));
                }
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc log chat: " + e.getMessage());
        }
    }

    public record ReportRow(long id, long messageId, int reporterId, String reason, long createdAt,
                            String messageText, int senderId, String senderName) {
    }

    public List<ReportRow> reports(int limit) {
        int size = limit <= 0 || limit > 200 ? 50 : limit;
        List<ReportRow> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT r.id, r.message_id, r.reporter_id, r.reason, r.created_at, m.text, m.sender_id, p.name "
                        + "FROM chat_reports r JOIN chat_messages m ON m.id = r.message_id "
                        + "LEFT JOIN players p ON p.id = m.sender_id "
                        + "WHERE r.handled = FALSE ORDER BY r.id DESC LIMIT ?")) {
            ps.setInt(1, size);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(new ReportRow(rs.getLong(1), rs.getLong(2), rs.getInt(3), rs.getString(4),
                            rs.getTimestamp(5).getTime(), rs.getString(6), rs.getInt(7), rs.getString(8)));
                }
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc báo cáo: " + e.getMessage());
        }
    }

    public BanInfo banInfo(int playerId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT banned_until, reason FROM chat_bans WHERE player_id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return new BanInfo(false, 0, null);
                long until = rs.getTimestamp("banned_until").getTime();
                return new BanInfo(until > time.now(), until, rs.getString("reason"));
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc trạng thái cấm chat: " + e.getMessage());
        }
    }

    // ---------- Ghi âm ----------
    public record VoiceMeta(String voiceId, int durationMs, int bytes) {
    }

    public VoiceMeta saveVoice(int playerId, byte[] data, int durationMs) {
        players.requirePlayer(playerId);
        if (data == null || data.length == 0) throw new ApiException(400, "Không có dữ liệu ghi âm");
        if (data.length > ChatVoiceStore.MAX_BYTES) {
            throw new ApiException(413, "Đoạn ghi âm quá lớn (tối đa " + (ChatVoiceStore.MAX_BYTES / 1024) + " KB)");
        }
        if (durationMs <= 0 || durationMs > ChatVoiceStore.MAX_DURATION_MS) {
            throw new ApiException(400, "Ghi âm tối đa " + (ChatVoiceStore.MAX_DURATION_MS / 1000) + " giây");
        }
        if (banInfo(playerId).banned()) throw new ApiException(403, "Bạn đang bị cấm chat");

        String voiceId = ChatVoiceStore.write(data);
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO chat_voices (voice_id, player_id, duration_ms, bytes, created_at) VALUES (?, ?, ?, ?, ?)")) {
            ps.setString(1, voiceId);
            ps.setInt(2, playerId);
            ps.setInt(3, durationMs);
            ps.setInt(4, data.length);
            ps.setTimestamp(5, new Timestamp(time.now()));
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi lưu ghi âm: " + e.getMessage());
        }
        return new VoiceMeta(voiceId, durationMs, data.length);
    }

    // Chỉ cho tải khi đoạn ghi âm đã gắn vào tin nhắn mà người xin có quyền đọc.
    public byte[] readVoice(int playerId, String voiceId) {
        boolean allowed = false;
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT channel, sender_id, target_id, deleted FROM chat_messages WHERE type = 'VOICE' AND ref_id = ?")) {
            ps.setString(1, voiceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    if (rs.getBoolean("deleted")) continue;
                    String channel = rs.getString("channel");
                    int senderId = rs.getInt("sender_id");
                    Object target = rs.getObject("target_id");
                    if (WORLD.equals(channel)) allowed = true;
                    else if (senderId == playerId || (target != null && ((Number) target).intValue() == playerId)) {
                        allowed = true;
                    }
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc ghi âm: " + e.getMessage());
        }
        if (!allowed) throw new ApiException(403, "Không có quyền nghe đoạn ghi âm này");
        return ChatVoiceStore.read(voiceId);
    }

    // ---------- Nội bộ ----------
    private void checkRateLimit(int playerId, String type, String text, String refId) {
        long now = time.now();
        try (Connection c = dataSource.getConnection()) {
            try (PreparedStatement ps = c.prepareStatement(
                    "SELECT created_at, type, text, ref_id FROM chat_messages "
                            + "WHERE sender_id = ? ORDER BY id DESC LIMIT ?")) {
                ps.setInt(1, playerId);
                ps.setInt(2, MAX_IN_WINDOW + 1);
                try (ResultSet rs = ps.executeQuery()) {
                    int inWindow = 0;
                    boolean first = true;
                    while (rs.next()) {
                        long at = rs.getTimestamp("created_at").getTime();
                        if (first) {
                            if (now - at < MIN_GAP_MS) throw new ApiException(429, "Gửi chậm thôi nào!");
                            first = false;
                        }
                        if (now - at <= WINDOW_MS) inWindow++;
                        if (now - at <= DUPLICATE_WINDOW_MS && sameContent(rs, type, text, refId)) {
                            throw new ApiException(429, "Đừng gửi lặp lại cùng một tin nhắn");
                        }
                    }
                    if (inWindow >= MAX_IN_WINDOW) {
                        throw new ApiException(429, "Bạn gửi quá nhanh, nghỉ vài giây nhé");
                    }
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi kiểm tra tốc độ gửi: " + e.getMessage());
        }
    }

    private static boolean sameContent(ResultSet rs, String type, String text, String refId) throws SQLException {
        if (!type.equals(rs.getString("type"))) return false;
        if (text != null) return text.equals(rs.getString("text"));
        return refId != null && refId.equals(rs.getString("ref_id"));
    }

    private long insert(String channel, int senderId, Integer targetId, String type, String text, String refId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO chat_messages (channel, sender_id, target_id, type, text, ref_id, created_at, deleted) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, FALSE)", Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, channel);
            ps.setInt(2, senderId);
            if (targetId == null) ps.setNull(3, java.sql.Types.INTEGER); else ps.setInt(3, targetId);
            ps.setString(4, type);
            ps.setString(5, text);
            ps.setString(6, refId);
            ps.setTimestamp(7, new Timestamp(time.now()));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                long id = keys.getLong(1);
                wakeWaiters(id);
                return id;
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi gửi tin nhắn: " + e.getMessage());
        }
    }

    // ---------- Long-poll ----------
    // Client treo một request tới 25 giây thay vì hỏi lại mỗi 3 giây: tin tới là hiện ngay và
    // số request giảm gần 10 lần. Chạy được vì HTTP server dùng virtual thread (xem Main).
    public static final int MAX_WAIT_MS = 25_000;

    private final Object waitLock = new Object();
    private volatile long lastMessageId;

    private void wakeWaiters(long id) {
        synchronized (waitLock) {
            if (id > lastMessageId) lastMessageId = id;
            waitLock.notifyAll();
        }
    }

    // Chờ tới khi có tin mới hơn sinceId hoặc hết giờ. Chỉ so id nên rẻ; việc lọc quyền vẫn do
    // world()/conversation() làm sau đó như thường.
    public void awaitNewMessage(long sinceId, int waitMs) {
        // Dùng đồng hồ thật chứ không phải TimeSource: đây là chờ ngoài đời, không phải thời gian trong game.
        long deadline = System.currentTimeMillis() + Math.min(MAX_WAIT_MS, Math.max(0, waitMs));
        synchronized (waitLock) {
            if (lastMessageId == 0) lastMessageId = maxMessageId();
            while (lastMessageId <= sinceId) {
                long remaining = deadline - System.currentTimeMillis();
                if (remaining <= 0) return;
                try {
                    waitLock.wait(remaining);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    return;
                }
            }
        }
    }

    private long maxMessageId() {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT COALESCE(MAX(id), 0) FROM chat_messages")) {
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0;
            }
        } catch (SQLException e) {
            return 0;
        }
    }

    // Ghi vi phạm; đủ ngưỡng trong cửa sổ thời gian thì tự cấm chat.
    int recordViolation(int playerId, String reason) {
        long now = time.now();
        try (Connection c = dataSource.getConnection()) {
            try (PreparedStatement ins = c.prepareStatement(
                    "INSERT INTO chat_violations (player_id, reason, created_at) VALUES (?, ?, ?)")) {
                ins.setInt(1, playerId);
                ins.setString(2, reason);
                ins.setTimestamp(3, new Timestamp(now));
                ins.executeUpdate();
            }
            int count;
            try (PreparedStatement ps = c.prepareStatement(
                    "SELECT COUNT(*) FROM chat_violations WHERE player_id = ? AND created_at > ?")) {
                ps.setInt(1, playerId);
                ps.setTimestamp(2, new Timestamp(now - VIOLATION_WINDOW_MS));
                try (ResultSet rs = ps.executeQuery()) {
                    rs.next();
                    count = rs.getInt(1);
                }
            }
            if (count >= AUTO_MUTE_VIOLATIONS) {
                upsertBan(playerId, now + AUTO_MUTE_MS, "Tự động: vi phạm nội dung nhiều lần");
            }
            return count;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi ghi vi phạm: " + e.getMessage());
        }
    }

    private void upsertBan(int playerId, long until, String reason) {
        try (Connection c = dataSource.getConnection()) {
            int updated;
            try (PreparedStatement upd = c.prepareStatement(
                    "UPDATE chat_bans SET banned_until = ?, reason = ? WHERE player_id = ?")) {
                upd.setTimestamp(1, new Timestamp(until));
                upd.setString(2, reason);
                upd.setInt(3, playerId);
                updated = upd.executeUpdate();
            }
            if (updated == 0) {
                try (PreparedStatement ins = c.prepareStatement(
                        "INSERT INTO chat_bans (player_id, banned_until, reason) VALUES (?, ?, ?)")) {
                    ins.setInt(1, playerId);
                    ins.setTimestamp(2, new Timestamp(until));
                    ins.setString(3, reason);
                    ins.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi cấm chat: " + e.getMessage());
        }
    }

    private List<Integer> hiddenSenders(int playerId) {
        List<Integer> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT target_id FROM chat_relations WHERE player_id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(rs.getInt("target_id"));
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc danh sách ẩn: " + e.getMessage());
        }
    }

    private boolean relation(int playerId, int targetId, String mode) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT 1 FROM chat_relations WHERE player_id = ? AND target_id = ? AND mode = ?")) {
            ps.setInt(1, playerId);
            ps.setInt(2, targetId);
            ps.setString(3, mode);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc quan hệ chat: " + e.getMessage());
        }
    }

    private boolean messageExists(long messageId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT 1 FROM chat_messages WHERE id = ?")) {
            ps.setLong(1, messageId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc tin nhắn: " + e.getMessage());
        }
    }

    private boolean ownsVoice(int playerId, String voiceId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT 1 FROM chat_voices WHERE voice_id = ? AND player_id = ?")) {
            ps.setString(1, voiceId);
            ps.setInt(2, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc ghi âm: " + e.getMessage());
        }
    }

    private static String formatUntil(long until) {
        return java.time.Instant.ofEpochMilli(until).toString();
    }
}
