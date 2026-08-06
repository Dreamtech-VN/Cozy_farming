package vn.dreamtech.game.server.battle;

/** Dữ liệu địch tối thiểu để khởi tạo 1 trận — chung cho Story lẫn Daily/Weekly Challenge. */
public interface EnemyDef {
    String name();

    int enemyHp();

    int enemyCounterDamage();

    int rewardExp();

    int rewardGold();
}
