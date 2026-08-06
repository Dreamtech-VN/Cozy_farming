package vn.dreamtech.game.server.worldboss;

public final class WorldBossException extends RuntimeException {
    private final int status;

    public WorldBossException(int status, String message) {
        super(message);
        this.status = status;
    }

    public int status() {
        return status;
    }
}
