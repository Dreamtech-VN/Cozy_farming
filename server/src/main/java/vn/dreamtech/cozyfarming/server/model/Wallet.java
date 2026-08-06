package vn.dreamtech.cozyfarming.server.model;

/**
 * Ví xu/kim cương trong game — KHÁC với cột {@code vnd}/{@code tongnap} thật
 * trong bảng {@code users} (đó là tiền nạp thật/IAP, dành cho giai đoạn tích
 * hợp thanh toán sau này). {@code coins} khớp {@code S.wallet.coins} (xu
 * thường, kiếm được khi chơi), {@code gems} khớp ruby/kim cương phía client.
 */
public record Wallet(int userId, long coins, long gems) {
}
