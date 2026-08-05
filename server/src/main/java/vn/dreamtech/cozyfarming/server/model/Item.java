package vn.dreamtech.cozyfarming.server.model;

/**
 * Khớp đúng bảng {@code items} thật (avatar_2x.sql) — bảng CHUNG cho mọi thứ
 * mặc được (tóc/áo/quần/kính/đồ cầm tay), không phải bảng riêng cho nông
 * trại/thú nuôi. {@code zorder} quyết định loại: 10=quần, 20=áo, 40=mắt,
 * 50=tóc, 60=mũ, 70=đồ cầm tay (xem {@code chibi.ts} phía client — cùng quy
 * ước z đã dùng để dựng nhân vật chibi).
 */
public record Item(
        int id,
        int coin,
        int gold,
        int type,
        int icon,
        String name,
        int sell,
        int expiredDay,
        int zorder,
        int gender,
        int level,
        String animationJson
) {
}
