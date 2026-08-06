package vn.dreamtech.game.server.battle;

/** Nguồn địch nhiều tầng cho trận đấu 1-battleId-nhiều-tầng (Dungeon, Tower...). */
public interface FloorSource {
    EnemyDef floorEnemy(int floorIndex);

    boolean hasNextFloor(int floorIndex);

    int totalFloors();
}
