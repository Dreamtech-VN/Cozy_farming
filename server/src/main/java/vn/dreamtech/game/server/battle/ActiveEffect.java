package vn.dreamtech.game.server.battle;

/** {@code remainingSwaps} là số lượt CÒN LẠI kể từ lượt kế tiếp (áp dụng xong lượt hiện tại thì giảm dần). */
public record ActiveEffect(BuffType type, int remainingSwaps) {
    public ActiveEffect tick() {
        return new ActiveEffect(type, remainingSwaps - 1);
    }

    public boolean expired() {
        return remainingSwaps <= 0;
    }
}
