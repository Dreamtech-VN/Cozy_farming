package vn.dreamtech.game.server.battle.tower;

import vn.dreamtech.game.server.battle.EnemyDef;
import vn.dreamtech.game.server.battle.FloorSource;

/**
 * Tháp leo tầng — địch mạnh dần theo công thức tuyến tính thay vì danh sách
 * tầng cố định như Dungeon. Có mốc {@code maxFloors} (không thật sự vô hạn,
 * đơn giản hoá cho MVP — TODO: leo mãi/leaderboard theo tầng cao nhất khi
 * có hệ leaderboard thật). KHÁC Dungeon: mỗi tầng qua đều được thưởng ngay
 * ({@code rewardExpPerFloor}/{@code rewardGoldPerFloor}), không đợi tới
 * tầng cuối — phù hợp với việc không đảm bảo người chơi lên được tới đỉnh.
 */
public record TowerDef(
        int id,
        String name,
        int startEnemyHp,
        int hpStepPerFloor,
        int startCounterDamage,
        int counterStepPerFloor,
        int maxFloors,
        int rewardExpPerFloor,
        int rewardGoldPerFloor
) implements FloorSource {
    @Override
    public EnemyDef floorEnemy(int floorIndex) {
        return new EnemyDef() {
            @Override
            public String name() {
                return TowerDef.this.name() + " - Tầng " + (floorIndex + 1);
            }

            @Override
            public int enemyHp() {
                return startEnemyHp + hpStepPerFloor * floorIndex;
            }

            @Override
            public int enemyCounterDamage() {
                return startCounterDamage + counterStepPerFloor * floorIndex;
            }

            @Override
            public int rewardExp() {
                return rewardExpPerFloor;
            }

            @Override
            public int rewardGold() {
                return rewardGoldPerFloor;
            }
        };
    }

    @Override
    public boolean hasNextFloor(int floorIndex) {
        return floorIndex + 1 < maxFloors;
    }

    @Override
    public int totalFloors() {
        return maxFloors;
    }
}
