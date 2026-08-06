package vn.dreamtech.game.server.battle;

import java.util.List;

public record BattleStateView(
        String battleId,
        BattleMode mode,
        Integer levelId,
        BattleStatus status,
        int[][] board,
        int playerHp,
        int playerHpMax,
        int enemyHp,
        int enemyHpMax,
        int mana,
        int manaMax,
        int comboCount,
        List<BuffType> activeEffects,
        boolean matched,
        boolean critical,
        int chainLevels,
        int damageDealt,
        int manaGained,
        boolean enemyCountered,
        int enemyCounterDamage,
        boolean rewardGranted,
        int rewardExp,
        int rewardGold
) {
}
