package vn.dreamtech.myzoo.server.chat;

import java.text.Normalizer;
import java.util.List;
import java.util.regex.Pattern;

// Lọc nội dung chat. Tách riêng khỏi ChatService để test được từng luật mà không cần DB.
public final class ChatModeration {
    public static final int MAX_LENGTH = 200;

    public enum Verdict { OK, MASKED, REJECTED }

    public record Result(Verdict verdict, String text, String reason) {
        public boolean rejected() {
            return verdict == Verdict.REJECTED;
        }
    }

    // Từ chặn thẳng: gửi là bị từ chối + tính 1 lần vi phạm.
    private static final List<String> BLOCKED = List.of(
            "dm", "dcm", "vcl", "cc", "loz", "dkm", "dmm",
            "sex", "porn", "khieudam", "phimsex", "gaidam");

    // Từ nhẹ hơn: che bằng dấu sao, tin vẫn gửi được.
    private static final List<String> MASKED = List.of(
            "ngu", "oc cho", "docho", "khùng", "dienkhung");

    // Rao bán / lừa đảo: chặn thẳng vì đây là nguồn scam phổ biến nhất trong game.
    private static final List<String> SCAM = List.of(
            "banacc", "muaacc", "bannick", "muanick", "napthe", "chietkhau",
            "zalo", "telegram", "facebook.com", "fb.com", "hackgame", "modgame",
            "freekc", "freevang", "tanggiatri");

    private static final Pattern LINK = Pattern.compile(
            "(https?://|www\\.|\\b[a-z0-9-]+\\.(com|net|vn|org|xyz|top|info|shop|link|me|io)\\b)",
            Pattern.CASE_INSENSITIVE);

    // Số điện thoại VN viết liền hoặc cách nhau bằng dấu — thường dùng để dụ giao dịch ngoài game.
    private static final Pattern PHONE = Pattern.compile("(0|\\+84)[\\s.\\-]?\\d[\\s.\\-]?\\d[\\s.\\-]?\\d"
            + "[\\s.\\-]?\\d[\\s.\\-]?\\d[\\s.\\-]?\\d[\\s.\\-]?\\d[\\s.\\-]?\\d[\\s.\\-]?\\d");

    public static Result check(String raw) {
        String text = raw == null ? "" : raw.trim();
        if (text.isEmpty()) return new Result(Verdict.REJECTED, "", "Tin nhắn trống");
        if (text.length() > MAX_LENGTH) {
            return new Result(Verdict.REJECTED, text, "Tin nhắn tối đa " + MAX_LENGTH + " ký tự");
        }
        if (text.chars().filter(Character::isLetterOrDigit).count() == 0 && text.codePointCount(0, text.length()) > 30) {
            return new Result(Verdict.REJECTED, text, "Tin nhắn không hợp lệ");
        }

        String normalized = normalize(text);

        if (LINK.matcher(text).find()) {
            return new Result(Verdict.REJECTED, text, "Không được gửi đường link");
        }
        if (PHONE.matcher(text).find()) {
            return new Result(Verdict.REJECTED, text, "Không được gửi số điện thoại");
        }
        for (String bad : SCAM) {
            if (normalized.contains(bad)) {
                return new Result(Verdict.REJECTED, text, "Nội dung mua bán/lừa đảo không được phép");
            }
        }
        for (String bad : BLOCKED) {
            if (containsWord(text, bad)) {
                return new Result(Verdict.REJECTED, text, "Tin nhắn chứa từ ngữ không phù hợp");
            }
        }

        String masked = text;
        boolean changed = false;
        for (String soft : MASKED) {
            String replaced = maskWord(masked, soft);
            if (!replaced.equals(masked)) {
                masked = replaced;
                changed = true;
            }
        }
        return changed ? new Result(Verdict.MASKED, masked, "Đã che từ không phù hợp")
                       : new Result(Verdict.OK, text, null);
    }

    // Bỏ dấu tiếng Việt, hạ chữ thường, bỏ ký tự chèn giữa (v.d "d.m", "n g u") để không lách được bộ lọc.
    static String normalize(String text) {
        String lower = Normalizer.normalize(text.toLowerCase(), Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .replace('đ', 'd');
        return lower.replaceAll("[^a-z0-9]", "");
    }

    // So khớp theo từ, không phải theo chuỗi con: nếu quét thẳng trên chuỗi đã gộp thì "admin" dính "dm",
    // "nguoi" dính "ngu". Vẫn bắt được kiểu lách "d.m" hay "n g u" nhờ gộp các token dài 1 ký tự đứng liền nhau.
    private static boolean containsWord(String text, String word) {
        StringBuilder run = new StringBuilder();
        for (String token : text.split("[^\\p{L}\\p{N}]+")) {
            String piece = normalize(token);
            if (piece.isEmpty()) continue;
            if (piece.equals(word)) return true;
            if (piece.length() == 1) {
                run.append(piece);
                if (run.toString().contains(word)) return true;
            } else {
                run.setLength(0);
            }
        }
        // Từ dài thì quét cả câu vẫn an toàn (không có từ thường nào chứa "phimsex", "khieudam"...).
        return word.length() >= 5 && normalize(text).contains(word);
    }

    // Che đúng từ đứng riêng. \p{M} trong lookahead để "ngủ" (n g u + dấu) không bị tính là "ngu".
    private static String maskWord(String text, String word) {
        String pattern = "(?i)(?<![\\p{L}\\p{N}])" + Pattern.quote(word) + "(?![\\p{L}\\p{N}\\p{M}])";
        return text.replaceAll(pattern, "*".repeat(word.length()));
    }

    private ChatModeration() {
    }
}
