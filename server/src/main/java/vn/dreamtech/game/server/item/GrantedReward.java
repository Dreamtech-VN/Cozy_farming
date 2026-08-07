package vn.dreamtech.game.server.item;

/** Kết quả sau khi 1 {@link RewardEntry} đã được cấp phát thật (trả về cho client hiện thông báo nhận thưởng). */
public record GrantedReward(int itemId, String itemName, ItemCategory category, int quantity) {
}
