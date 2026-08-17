package vn.dreamtech.myzoo.server.chat;

import java.util.List;

// Sticker/GIF là DANH MỤC CỐ ĐỊNH do server duyệt, client chỉ gửi id.
// Không cho gửi URL ảnh tự do — đó là cách chặn ảnh bậy/scam triệt để nhất,
// vì server không bao giờ phát tán nội dung mà nó chưa duyệt.
public final class ChatCatalog {
    public record StickerDef(String id, String name) {
    }

    public static final List<StickerDef> STICKERS = List.of(
            new StickerDef("hi", "Xin chào"),
            new StickerDef("happy", "Vui vẻ"),
            new StickerDef("cry", "Khóc"),
            new StickerDef("angry", "Giận"),
            new StickerDef("thanks", "Cảm ơn"),
            new StickerDef("gg", "Chơi tốt"),
            new StickerDef("help", "Cứu với"),
            new StickerDef("love", "Thích"));

    public static final List<StickerDef> GIFS = List.of(
            new StickerDef("rabbit_dance", "Thỏ nhảy"),
            new StickerDef("panda_roll", "Gấu trúc lăn"),
            new StickerDef("harvest", "Thu hoạch"),
            new StickerDef("fireworks", "Pháo hoa"));

    public static boolean hasSticker(String id) {
        return STICKERS.stream().anyMatch(s -> s.id().equals(id));
    }

    public static boolean hasGif(String id) {
        return GIFS.stream().anyMatch(s -> s.id().equals(id));
    }

    private ChatCatalog() {
    }
}
