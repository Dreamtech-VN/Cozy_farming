package vn.dreamtech.myzoo.server.chat;

import vn.dreamtech.myzoo.server.http.ApiException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

// Lưu file ghi âm ra đĩa, DB chỉ giữ metadata. Đổi VOICE_DIR để trỏ sang ổ khác/NFS khi lên production.
public final class ChatVoiceStore {
    public static final int MAX_BYTES = 200 * 1024;
    public static final int MAX_DURATION_MS = 30_000;

    private static Path dir() {
        Path path = Path.of(System.getenv().getOrDefault("VOICE_DIR", "myzoo-voice"));
        try {
            Files.createDirectories(path);
        } catch (IOException e) {
            throw new ApiException(500, "Không tạo được thư mục ghi âm: " + e.getMessage());
        }
        return path;
    }

    public static String write(byte[] data) {
        String voiceId = UUID.randomUUID().toString();
        try {
            Files.write(dir().resolve(voiceId + ".bin"), data);
            return voiceId;
        } catch (IOException e) {
            throw new ApiException(500, "Lỗi lưu ghi âm: " + e.getMessage());
        }
    }

    public static byte[] read(String voiceId) {
        // Chặn path traversal: chỉ chấp nhận UUID.
        if (voiceId == null || !voiceId.matches("[0-9a-fA-F-]{36}")) {
            throw new ApiException(400, "voiceId không hợp lệ");
        }
        Path file = dir().resolve(voiceId + ".bin");
        try {
            if (!Files.exists(file)) throw new ApiException(404, "Không tìm thấy đoạn ghi âm");
            return Files.readAllBytes(file);
        } catch (IOException e) {
            throw new ApiException(500, "Lỗi đọc ghi âm: " + e.getMessage());
        }
    }

    private ChatVoiceStore() {
    }
}
