package vn.dreamtech.cozyfarming.server.fishing;

import java.security.SecureRandom;
import java.util.Optional;

/** Chép ĐÚNG thuật toán {@code Fish.getRandomFishID()} thật — trừ dần trọng số ngẫu nhiên tới khi về âm. */
public final class FishingService {
    private static final SecureRandom RANDOM = new SecureRandom();

    /** Rỗng nghĩa là trượt (không câu được gì). */
    public static Optional<FishDef> rollCatch() {
        int total = FishCatalog.FISHES.stream().mapToInt(FishDef::weight).sum() + FishCatalog.MISS_WEIGHT;
        int roll = RANDOM.nextInt(total);
        for (FishDef def : FishCatalog.FISHES) {
            roll -= def.weight();
            if (roll < 0) return Optional.of(def);
        }
        return Optional.empty();
    }

    private FishingService() {
    }
}
