package vn.dreamtech.game.server.battle.engine;

import java.util.List;

public record CascadeResult(List<ChainStep> steps) {
    public boolean matched() {
        return !steps.isEmpty();
    }

    public int chainLevels() {
        return steps.size();
    }
}
