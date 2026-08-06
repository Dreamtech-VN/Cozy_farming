package vn.dreamtech.cozyfarming.server.fishing;

/**
 * Cá câu được (rod fishing) — khớp NGUYÊN {@code Fish.getRandomFishID()} và
 * bảng {@code items} thật trong {@code avatar_2x.sql} của Lttt (server gốc
 * {@code ParkService.java}), KHÔNG phải số liệu client Phaser tự bịa (client
 * cũ dùng hệ zone/cần câu/mồi phân cấp — không có thật trong Lttt gốc).
 * {@code coin} là số xu được cộng thẳng khi câu được — Lttt gốc TỰ BÁN NGAY
 * con cá câu được (xem {@code AvatarService.sellFish()}), không giữ trong túi.
 */
public record FishDef(int itemId, int weight, int coin) {
}
