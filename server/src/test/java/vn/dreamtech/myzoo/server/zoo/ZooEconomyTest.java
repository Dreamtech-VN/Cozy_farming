package vn.dreamtech.myzoo.server.zoo;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ZooEconomyTest {
    @Test
    void ratingIsZeroWhenNothingIsFed() {
        assertEquals(0, ZooEconomy.rating(0, 0, 0, 0));
        assertEquals(1.0, ZooEconomy.stars(0), 0.01);
    }

    @Test
    void ratingCapsAtOneHundredAndFiveStars() {
        int rating = ZooEconomy.rating(500, 1.0, 100, 20);
        assertEquals(100, rating, "mọi thành phần đều chạm trần thì đúng 100");
        assertEquals(5.0, ZooEconomy.stars(rating), 0.01);
    }

    @Test
    void eachComponentContributesItsShare() {
        // Chỉ chăm thú đầy đủ, không có gì khác: đúng phần điểm chăm sóc.
        assertEquals(ZooEconomy.MAX_CARE_SCORE, ZooEconomy.rating(0, 1.0, 0, 0));
        // Chỉ trang trí.
        assertEquals(ZooEconomy.MAX_DECOR_SCORE, ZooEconomy.rating(0, 0, 99, 0));
        // Đa dạng loài: mỗi loài 4 điểm, tối đa 5 loài.
        assertEquals(8, ZooEconomy.rating(0, 0, 0, 2));
        assertEquals(ZooEconomy.MAX_VARIETY_SCORE, ZooEconomy.rating(0, 0, 0, 9));
        // Độ hấp dẫn: 2 điểm hấp dẫn ăn 1 điểm hạng, trần 40.
        assertEquals(20, ZooEconomy.rating(40, 0, 0, 0));
        assertEquals(ZooEconomy.MAX_APPEAL_SCORE, ZooEconomy.rating(200, 0, 0, 0));
    }

    @Test
    void starvingAnimalsDropTheRating() {
        int fed = ZooEconomy.rating(40, 1.0, 5, 3);
        int halfStarved = ZooEconomy.rating(40, 0.5, 5, 3);
        assertTrue(halfStarved < fed, "bỏ đói một nửa thì hạng phải tụt");
    }

    @Test
    void capacityGrowsWithLevelAndHabitats() {
        assertEquals(ZooEconomy.BASE_CAPACITY + 20 + 15, ZooEconomy.capacity(1, 1));
        assertEquals(ZooEconomy.BASE_CAPACITY + 100 + 60, ZooEconomy.capacity(5, 4));
    }

    // Đây là điểm mấu chốt của spec §29.20: nhồi thêm thú không tăng doanh thu nếu cổng đã chật.
    @Test
    void visitorsAreCappedByCapacity() {
        assertEquals(10, ZooEconomy.visitorsPerHour(5, 75));
        assertEquals(75, ZooEconomy.visitorsPerHour(500, 75), "quá tải thì dừng ở sức chứa");
        assertEquals(0, ZooEconomy.visitorsPerHour(0, 75));
    }

    @Test
    void higherRatingMakesVisitorsSpendMore() {
        assertEquals(0.7, ZooEconomy.spendMultiplier(0), 0.001);
        assertEquals(1.3, ZooEconomy.spendMultiplier(100), 0.001);
        assertTrue(ZooEconomy.grossPerHour(50, 100) > ZooEconomy.grossPerHour(50, 20));
    }

    @Test
    void maintenanceScalesWithHabitatsAndCanEatThinProfits() {
        assertEquals(0, ZooEconomy.maintenancePerHour(0));
        assertEquals(24, ZooEconomy.maintenancePerHour(4));

        // Nhiều chuồng rỗng thì lỗ, nhưng không âm tiền của người chơi.
        var report = ZooEconomy.report(0, 0, 0, 0, 1, 6);
        assertEquals(0, report.visitorsPerHour());
        assertEquals(0, report.grossPerHour());
        assertEquals(36, report.maintenancePerHour());
        assertEquals(0, report.netPerHour(), "lỗ thì về 0 chứ không trừ tiền người chơi");
    }

    @Test
    void smallStarterZooStillTurnsAProfit() {
        // 1 chuồng, 1 con thỏ (hấp dẫn 5), cho ăn đủ, Zoo cấp 1.
        var report = ZooEconomy.report(5, 1.0, 0, 1, 1, 1);
        assertEquals(75, report.capacity());
        assertEquals(10, report.visitorsPerHour());
        assertTrue(report.netPerHour() > 0, "sở thú mới mở vẫn phải có lãi, không thì người chơi nản");
        assertEquals(report.grossPerHour() - report.maintenancePerHour(), report.netPerHour());
    }

    @Test
    void wellRunZooEarnsMoreThanNeglectedOneOfSameSize() {
        var cared = ZooEconomy.report(60, 1.0, 12, 4, 3, 3);
        var neglected = ZooEconomy.report(60, 0.2, 12, 4, 3, 3);
        assertTrue(cared.netPerHour() > neglected.netPerHour());
        assertTrue(cared.stars() > neglected.stars());
    }
}
