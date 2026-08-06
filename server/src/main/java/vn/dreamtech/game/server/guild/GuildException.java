package vn.dreamtech.game.server.guild;

public final class GuildException extends RuntimeException {
    private final int status;

    public GuildException(int status, String message) {
        super(message);
        this.status = status;
    }

    public int status() {
        return status;
    }
}
