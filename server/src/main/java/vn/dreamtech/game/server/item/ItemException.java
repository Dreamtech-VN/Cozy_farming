package vn.dreamtech.game.server.item;

/**
 * Dùng chung cho TOÀN BỘ hệ item/thư/giftcode/sự kiện/admin (giống cách
 * {@code GuildException} được tái dùng ở {@code guild.boss}/{@code
 * guild.war}) — các tính năng này đều xoay quanh "kho item" nên gộp 1
 * exception thay vì tạo riêng từng cái.
 */
public final class ItemException extends RuntimeException {
    private final int status;

    public ItemException(int status, String message) {
        super(message);
        this.status = status;
    }

    public int status() {
        return status;
    }
}
