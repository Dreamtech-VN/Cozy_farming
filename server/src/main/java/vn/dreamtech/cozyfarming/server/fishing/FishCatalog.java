package vn.dreamtech.cozyfarming.server.fishing;

import java.util.List;

/**
 * Chép NGUYÊN mảng {@code idFish}/{@code weights} thật trong
 * {@code Fish.java} (Lttt gốc): 7 loài cá trọng số 80 mỗi loài, RIÊNG
 * "cá mập" (id 457) trọng số 1 — cực hiếm, thưởng 500.000 xu (khớp cột
 * {@code coin} thật của item 457 trong {@code avatar_2x.sql}). 5 giá trị id
 * âm còn lại trong mảng gốc (-444,-449,-450,-451,-452) không có trong bảng
 * {@code items} thật — đó là "trượt" (không câu được gì), gộp chung thành
 * {@link #MISS_WEIGHT}.
 */
public final class FishCatalog {
    public static final List<FishDef> FISHES = List.of(
            new FishDef(454, 80, 100),      // cá chim
            new FishDef(455, 80, 110),      // cá đuối
            new FishDef(456, 80, 120),      // cá ngựa
            new FishDef(457, 1, 500_000),   // cá mập — cực hiếm
            new FishDef(2130, 80, 1000),    // cá hề
            new FishDef(2131, 80, 1500),    // cá đuôi gai
            new FishDef(2132, 80, 2000)     // cá thiên thần
    );

    /** Tổng trọng số 5 kết quả "trượt" thật (80 x 5 = 400), khớp đúng tổng trọng số gốc. */
    public static final int MISS_WEIGHT = 400;

    /** id item thật của cá mập — câu được thì thưởng thêm mảnh ghép {@link #SHARK_BONUS_ITEM_ID}. */
    public static final int SHARK_FISH_ID = 457;
    public static final String SHARK_BONUS_ITEM_ID = "6822";

    /** id item mồi câu thật ("trứng kiến") — trừ trong túi đồ mỗi lần quăng câu. */
    public static final String BAIT_ITEM_ID = "448";

    private FishCatalog() {
    }
}
