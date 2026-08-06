package vn.dreamtech.game.server.battle;

/** Lỗi nghiệp vụ trong trận đấu — {@code status} là mã HTTP tương ứng, để handler map thẳng ra response. */
public final class BattleException extends RuntimeException {
    private final int status;

    public BattleException(int status, String message) {
        super(message);
        this.status = status;
    }

    public int status() {
        return status;
    }
}
