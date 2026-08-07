package vn.dreamtech.game.server.item;

/** 1 dòng phần thưởng — trỏ tới "kho item" ({@code ItemDao}) qua id thay vì định nghĩa lại phần thưởng mỗi nơi. */
public record RewardEntry(int itemId, int quantity) {
}
