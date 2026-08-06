package vn.dreamtech.game.server.battle.dungeon;

import vn.dreamtech.game.server.battle.EnemyDef;
import vn.dreamtech.game.server.battle.FloorSource;

import java.util.List;

/**
 * 1 dungeon gồm nhiều tầng CỐ ĐỊNH ({@code floors}, đánh liên tiếp không hồi
 * đầy máu giữa các tầng — xem {@code BattleSession#advanceFloor}). Thưởng
 * ({@code rewardExp}/{@code rewardGold}) chỉ phát khi qua tầng CUỐI (các
 * tầng giữa trả về 0/0 ở {@link #floorEnemy}, khớp với cách
 * {@code BattleService} chỉ cộng thưởng khi vượt qua tầng cuối).
 */
public record DungeonDef(int id, String name, List<FloorDef> floors, int rewardExp, int rewardGold) implements FloorSource {
    @Override
    public EnemyDef floorEnemy(int floorIndex) {
        FloorDef floor = floors.get(floorIndex);
        boolean lastFloor = floorIndex == floors.size() - 1;
        return new EnemyDef() {
            @Override
            public String name() {
                return DungeonDef.this.name() + " - Tầng " + (floorIndex + 1);
            }

            @Override
            public int enemyHp() {
                return floor.enemyHp();
            }

            @Override
            public int enemyCounterDamage() {
                return floor.enemyCounterDamage();
            }

            @Override
            public int rewardExp() {
                return lastFloor ? DungeonDef.this.rewardExp() : 0;
            }

            @Override
            public int rewardGold() {
                return lastFloor ? DungeonDef.this.rewardGold() : 0;
            }
        };
    }

    @Override
    public boolean hasNextFloor(int floorIndex) {
        return floorIndex + 1 < floors.size();
    }

    @Override
    public int totalFloors() {
        return floors.size();
    }
}
