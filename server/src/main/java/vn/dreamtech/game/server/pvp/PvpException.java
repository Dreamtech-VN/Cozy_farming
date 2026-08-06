package vn.dreamtech.game.server.pvp;

public final class PvpException extends RuntimeException {
    private final int status;

    public PvpException(int status, String message) {
        super(message);
        this.status = status;
    }

    public int status() {
        return status;
    }
}
