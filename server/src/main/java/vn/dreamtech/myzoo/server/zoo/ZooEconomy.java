package vn.dreamtech.myzoo.server.zoo;

// Công thức xếp hạng và doanh thu sở thú (spec §29.17–29.20). Tách thành hàm thuần để cân bằng số liệu
// và viết test mà không cần DB.
public final class ZooEconomy {
    // Trần điểm từng phần, cộng lại đúng 100.
    public static final int MAX_APPEAL_SCORE = 40;
    public static final int MAX_CARE_SCORE = 25;
    public static final int MAX_DECOR_SCORE = 15;
    public static final int MAX_VARIETY_SCORE = 20;

    public static final int BASE_CAPACITY = 40;
    public static final int CAPACITY_PER_ZOO_LEVEL = 20;
    public static final int CAPACITY_PER_HABITAT = 15;

    public static final double VISITORS_PER_APPEAL = 2.0;
    public static final double VANG_PER_VISITOR = 5.0;
    public static final double MAINTENANCE_PER_HABITAT_PER_HOUR = 6.0;

    public record Report(int rating, double stars, int capacity, int visitorsPerHour,
                         long grossPerHour, long maintenancePerHour, long netPerHour) {
    }

    // 0–100. Chỉ tính thú đã được cho ăn: bỏ đói thì hạng tụt, đúng tinh thần "chăm mới có khách".
    public static int rating(int fedAppeal, double foodCoverage, int fedDecorAppeal, int distinctFedSpecies) {
        double appeal = Math.min(MAX_APPEAL_SCORE, fedAppeal / 2.0);
        double care = MAX_CARE_SCORE * clamp01(foodCoverage);
        double decor = Math.min(MAX_DECOR_SCORE, fedDecorAppeal);
        double variety = Math.min(MAX_VARIETY_SCORE, distinctFedSpecies * 4.0);
        return (int) Math.round(appeal + care + decor + variety);
    }

    // Hiển thị 1.0–5.0 sao cho người chơi dễ hiểu hơn con số 0–100.
    public static double stars(int rating) {
        return Math.round((1.0 + 4.0 * clamp01(rating / 100.0)) * 10) / 10.0;
    }

    public static int capacity(int zooLevel, int habitatCount) {
        return BASE_CAPACITY + zooLevel * CAPACITY_PER_ZOO_LEVEL + habitatCount * CAPACITY_PER_HABITAT;
    }

    // Thú hấp dẫn kéo khách tới, nhưng cổng vào chỉ chứa được ngần ấy người.
    public static int visitorsPerHour(int totalAppeal, int capacity) {
        return (int) Math.min(capacity, Math.floor(totalAppeal * VISITORS_PER_APPEAL));
    }

    // Hạng cao thì khách tiêu nhiều hơn: nhân từ 0.7 tới 1.3.
    public static double spendMultiplier(int rating) {
        return 0.7 + 0.6 * clamp01(rating / 100.0);
    }

    public static long grossPerHour(int visitorsPerHour, int rating) {
        return (long) Math.floor(visitorsPerHour * VANG_PER_VISITOR * spendMultiplier(rating));
    }

    public static long maintenancePerHour(int habitatCount) {
        return (long) Math.floor(habitatCount * MAINTENANCE_PER_HABITAT_PER_HOUR);
    }

    public static Report report(int fedAppeal, double foodCoverage, int fedDecorAppeal, int distinctFedSpecies,
                                int zooLevel, int habitatCount) {
        int rating = rating(fedAppeal, foodCoverage, fedDecorAppeal, distinctFedSpecies);
        int capacity = capacity(zooLevel, habitatCount);
        int visitors = visitorsPerHour(fedAppeal, capacity);
        long gross = grossPerHour(visitors, rating);
        long maintenance = maintenancePerHour(habitatCount);
        return new Report(rating, stars(rating), capacity, visitors, gross, maintenance,
                Math.max(0, gross - maintenance));
    }

    private static double clamp01(double value) {
        return Math.max(0, Math.min(1, value));
    }

    private ZooEconomy() {
    }
}
