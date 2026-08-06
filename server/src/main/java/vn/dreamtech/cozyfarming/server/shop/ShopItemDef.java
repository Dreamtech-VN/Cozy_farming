package vn.dreamtech.cozyfarming.server.shop;

/** {@code buyPrice} = -1 nghĩa là không mua được (chỉ bán), khớp việc thiếu field {@code buy} trong items.ts client. */
public record ShopItemDef(String id, int buyPrice, int sellPrice) {
}
