package vn.dreamtech.myzoo.server.zoo;

import vn.dreamtech.myzoo.server.catalog.Catalog;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.farm.FarmService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;
import vn.dreamtech.myzoo.server.time.TimeSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public final class ZooService {
    // Thú no trong 4 giờ sau khi ăn; doanh thu chỉ tích tối đa 8 giờ (spec: lazy offline aggregate).
    public static final long FED_WINDOW_MS = 4 * 60 * 60 * 1000L;
    public static final long MAX_ACCRUAL_MS = 8 * 60 * 60 * 1000L;
    public static final double VANG_PER_APPEAL_PER_HOUR = 10.0;

    private final DataSource dataSource;
    private final EconomyService economy;
    private final FarmService farm;
    private final PlayerService players;
    private final TimeSource time;

    public ZooService(DataSource dataSource, EconomyService economy, FarmService farm, PlayerService players, TimeSource time) {
        this.dataSource = dataSource;
        this.economy = economy;
        this.farm = farm;
        this.players = players;
        this.time = time;
    }

    public record AnimalView(int id, String speciesId, String name, int habitatId, boolean fed, int appeal, String rarity) {
    }

    public record DecorView(String decorId, String name, int appealBonus) {
    }

    public record HabitatView(int id, String typeId, String name, int capacity, List<AnimalView> animals,
                              List<DecorView> decors, int decorAppeal) {
    }

    public record ZooView(List<HabitatView> habitats, List<FarmService.ItemStack> warehouse, boolean isOpen,
                           double foodCoverage, int totalAppeal, long pendingVang) {
    }

    public record BuyResult(int id, long vangBalance) {
    }

    public record DeliverResult(String foodId, int quantity, List<FarmService.ItemStack> farmStorage,
                                List<FarmService.ItemStack> warehouse) {
    }

    public record FeedResult(int habitatId, int animalsFed, List<FarmService.ItemStack> warehouse) {
    }

    public record CollectResult(long vangEarned, int zooXp, long vangBalance) {
    }

    public ZooView view(int playerId) {
        players.requirePlayer(playerId);
        long now = time.now();
        List<HabitatView> habitats = loadHabitats(playerId, now);
        Stats stats = statsOf(habitats);
        ZooRow zoo = zooRow(playerId);
        long pending = zoo.isOpen ? accruedVang(playerId, zoo, stats, now) : 0;
        return new ZooView(habitats, farm.readInventory("zoo_warehouse", playerId), zoo.isOpen,
                stats.coverage, stats.totalAppeal, pending);
    }

    // Bảng điều khiển sở thú (spec §29.18): cho người chơi thấy vì sao doanh thu cao hay thấp.
    public ZooEconomy.Report report(int playerId) {
        players.requirePlayer(playerId);
        Stats stats = statsOf(loadHabitats(playerId, time.now()));
        return ZooEconomy.report(stats.totalAppeal, stats.coverage, stats.decorAppeal, stats.distinctSpecies,
                players.profile(playerId).zooLevel(), stats.habitatCount);
    }

    // Gom số liệu một lần rồi dùng chung cho view, report và thu tiền — tránh ba nơi tính lệch nhau.
    private Stats statsOf(List<HabitatView> habitats) {
        int totalAnimals = 0;
        int fedAnimals = 0;
        int totalAppeal = 0;
        int decorAppeal = 0;
        var species = new java.util.HashSet<String>();
        for (HabitatView h : habitats) {
            boolean anyFed = false;
            for (AnimalView a : h.animals()) {
                totalAnimals++;
                if (a.fed()) {
                    fedAnimals++;
                    anyFed = true;
                    totalAppeal += a.appeal();
                    species.add(a.speciesId());
                }
            }
            if (anyFed) {
                totalAppeal += h.decorAppeal();
                decorAppeal += h.decorAppeal();
            }
        }
        double coverage = totalAnimals == 0 ? 0 : (double) fedAnimals / totalAnimals;
        return new Stats(totalAppeal, coverage, decorAppeal, species.size(), habitats.size());
    }

    private record Stats(int totalAppeal, double coverage, int decorAppeal, int distinctSpecies, int habitatCount) {
    }

    // Trang trí: cộng độ hấp dẫn cho chuồng, nhưng chỉ tính khi chuồng có thú đã được cho ăn —
    // trang trí là để tăng thêm, không thay thế việc chăm thú.
    public BuyResult buyDecor(int playerId, int habitatId, String decorId) {
        players.requirePlayer(playerId);
        Catalog.DecorDef decor = Catalog.decor(decorId)
                .orElseThrow(() -> new ApiException(404, "Không có món trang trí này"));
        if (players.profile(playerId).zooLevel() < decor.minZooLevel()) {
            throw new ApiException(403, "Cần Sở thú level " + decor.minZooLevel() + " để mua " + decor.name());
        }
        habitatRow(playerId, habitatId);
        if (decorsOf(habitatId).stream().anyMatch(d -> d.decorId().equals(decorId))) {
            throw new ApiException(409, "Chuồng này đã có " + decor.name());
        }
        long balance = economy.spend(playerId, EconomyService.VANG, decor.cost(), "BUY_DECOR", "decor", decorId);
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO habitat_decors (habitat_id, decor_id, created_at) VALUES (?, ?, ?)")) {
            ps.setInt(1, habitatId);
            ps.setString(2, decorId);
            ps.setTimestamp(3, new Timestamp(time.now()));
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(409, "Chuồng này đã có " + decor.name());
        }
        return new BuyResult(habitatId, balance);
    }

    List<DecorView> decorsOf(int habitatId) {
        List<DecorView> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT decor_id FROM habitat_decors WHERE habitat_id = ? ORDER BY decor_id")) {
            ps.setInt(1, habitatId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Catalog.decor(rs.getString("decor_id")).ifPresent(
                            d -> out.add(new DecorView(d.id(), d.name(), d.appealBonus())));
                }
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc trang trí: " + e.getMessage());
        }
    }

    public BuyResult buyHabitat(int playerId, String typeId) {
        players.requirePlayer(playerId);
        Catalog.HabitatTypeDef type = Catalog.habitatType(typeId)
                .orElseThrow(() -> new ApiException(404, "Không có loại chuồng này"));
        if (players.profile(playerId).zooLevel() < type.minZooLevel()) {
            throw new ApiException(403, "Cần Sở thú level " + type.minZooLevel() + " để xây " + type.name());
        }
        long balance = economy.spend(playerId, EconomyService.VANG, type.cost(), "BUILD_HABITAT", "habitat", typeId);
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO habitats (player_id, type_id) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, playerId);
            ps.setString(2, typeId);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return new BuyResult(keys.getInt(1), balance);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi xây chuồng: " + e.getMessage());
        }
    }

    public BuyResult buyAnimal(int playerId, int habitatId, String speciesId) {
        players.requirePlayer(playerId);
        Catalog.SpeciesDef species = Catalog.species(speciesId)
                .orElseThrow(() -> new ApiException(404, "Không có loài này"));
        if (players.profile(playerId).zooLevel() < species.minZooLevel()) {
            throw new ApiException(403, "Cần Sở thú level " + species.minZooLevel() + " để mua " + species.name());
        }
        HabitatRow habitat = habitatRow(playerId, habitatId);
        Catalog.HabitatTypeDef type = Catalog.habitatType(habitat.typeId).orElseThrow();
        if (countAnimals(habitatId) >= type.capacity()) {
            throw new ApiException(409, "Chuồng đã đầy");
        }
        long balance = economy.spend(playerId, EconomyService.VANG, species.cost(), "BUY_ANIMAL", "species", speciesId);
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO zoo_animals (player_id, habitat_id, species_id, last_fed_at) VALUES (?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, playerId);
            ps.setInt(2, habitatId);
            ps.setString(3, speciesId);
            ps.setTimestamp(4, new Timestamp(time.now()));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return new BuyResult(keys.getInt(1), balance);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi mua thú: " + e.getMessage());
        }
    }

    public DeliverResult deliver(int playerId, String foodId, int quantity) {
        players.requirePlayer(playerId);
        if (quantity <= 0) throw new ApiException(400, "Số lượng phải > 0");
        if (Catalog.crop(foodId).isEmpty()) throw new ApiException(404, "Không có loại thức ăn này");
        try (Connection c = dataSource.getConnection()) {
            c.setAutoCommit(false);
            try {
                FarmService.addToInventory(c, "farm_inventory", playerId, foodId, -quantity);
                FarmService.addToInventory(c, "zoo_warehouse", playerId, foodId, quantity);
                c.commit();
            } catch (ApiException | SQLException e) {
                c.rollback();
                if (e instanceof ApiException api) throw api;
                throw new ApiException(500, "Lỗi chuyển kho: " + e.getMessage());
            } finally {
                c.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi kết nối kho: " + e.getMessage());
        }
        return new DeliverResult(foodId, quantity, farm.storage(playerId), farm.readInventory("zoo_warehouse", playerId));
    }

    // Cho cả chuồng ăn: mỗi con đói tiêu 1 đơn vị food hợp khẩu phần từ kho Zoo.
    public FeedResult feed(int playerId, int habitatId) {
        players.requirePlayer(playerId);
        habitatRow(playerId, habitatId);
        long now = time.now();
        int fedCount = 0;
        try (Connection c = dataSource.getConnection()) {
            c.setAutoCommit(false);
            try {
                List<int[]> hungry = new ArrayList<>();
                List<String> speciesIds = new ArrayList<>();
                try (PreparedStatement ps = c.prepareStatement(
                        "SELECT id, species_id, last_fed_at FROM zoo_animals WHERE player_id = ? AND habitat_id = ?")) {
                    ps.setInt(1, playerId);
                    ps.setInt(2, habitatId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Timestamp lastFed = rs.getTimestamp("last_fed_at");
                            boolean fed = lastFed != null && now - lastFed.getTime() < FED_WINDOW_MS;
                            if (!fed) {
                                hungry.add(new int[]{rs.getInt("id")});
                                speciesIds.add(rs.getString("species_id"));
                            }
                        }
                    }
                }
                Map<String, Integer> warehouse = farm.readInventoryMap("zoo_warehouse", playerId);
                for (int i = 0; i < hungry.size(); i++) {
                    Catalog.SpeciesDef species = Catalog.species(speciesIds.get(i)).orElseThrow();
                    String usable = null;
                    for (String foodId : species.diet()) {
                        if (warehouse.getOrDefault(foodId, 0) > 0) {
                            usable = foodId;
                            break;
                        }
                    }
                    if (usable == null) continue;
                    FarmService.addToInventory(c, "zoo_warehouse", playerId, usable, -1);
                    warehouse.merge(usable, -1, Integer::sum);
                    try (PreparedStatement upd = c.prepareStatement(
                            "UPDATE zoo_animals SET last_fed_at = ? WHERE id = ?")) {
                        upd.setTimestamp(1, new Timestamp(now));
                        upd.setInt(2, hungry.get(i)[0]);
                        upd.executeUpdate();
                    }
                    fedCount++;
                }
                c.commit();
            } catch (ApiException | SQLException e) {
                c.rollback();
                if (e instanceof ApiException api) throw api;
                throw new ApiException(500, "Lỗi cho ăn: " + e.getMessage());
            } finally {
                c.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi kết nối: " + e.getMessage());
        }
        if (fedCount == 0) throw new ApiException(409, "Không có thú đói hoặc kho Zoo hết thức ăn phù hợp");
        return new FeedResult(habitatId, fedCount, farm.readInventory("zoo_warehouse", playerId));
    }

    // Chợ thức ăn khẩn cấp (spec §29.23): mua thẳng vào kho Zoo, giá cao hơn tự trồng để nông trại
    // vẫn là con đường chính — nhưng người chơi không bao giờ kẹt cứng vì hết thức ăn.
    public static final long EMERGENCY_PRICE_MULTIPLIER = 3;
    public static final int EMERGENCY_MAX_QUANTITY = 50;

    public record MarketItem(String foodId, String name, long price) {
    }

    public record MarketResult(String foodId, int quantity, long spent, long vangBalance,
                               List<FarmService.ItemStack> warehouse) {
    }

    public static long emergencyPrice(String foodId) {
        return Catalog.sellPrice(foodId).orElseThrow(() -> new ApiException(404, "Không bán loại này"))
                * EMERGENCY_PRICE_MULTIPLIER;
    }

    // Chỉ bán thứ thú ăn được, không bán thành phẩm chế biến.
    public List<MarketItem> market() {
        List<MarketItem> out = new ArrayList<>();
        for (Catalog.CropDef crop : Catalog.CROPS) {
            boolean eaten = Catalog.SPECIES.stream().anyMatch(s -> s.diet().contains(crop.id()));
            if (eaten) out.add(new MarketItem(crop.id(), crop.name(), emergencyPrice(crop.id())));
        }
        return out;
    }

    public MarketResult buyEmergencyFood(int playerId, String foodId, int quantity) {
        players.requirePlayer(playerId);
        if (quantity <= 0 || quantity > EMERGENCY_MAX_QUANTITY) {
            throw new ApiException(400, "Số lượng phải từ 1 đến " + EMERGENCY_MAX_QUANTITY);
        }
        if (market().stream().noneMatch(m -> m.foodId().equals(foodId))) {
            throw new ApiException(404, "Chợ không bán loại này");
        }
        long total = emergencyPrice(foodId) * quantity;
        long balance = economy.spend(playerId, EconomyService.VANG, total, "EMERGENCY_FOOD", "food", foodId);
        try (Connection c = dataSource.getConnection()) {
            FarmService.addToInventory(c, "zoo_warehouse", playerId, foodId, quantity);
        } catch (SQLException e) {
            economy.earn(playerId, EconomyService.VANG, total, "EMERGENCY_FOOD_REFUND", "food", foodId);
            throw new ApiException(500, "Lỗi thêm vào kho Zoo: " + e.getMessage());
        }
        return new MarketResult(foodId, quantity, total, balance,
                farm.readInventory("zoo_warehouse", playerId));
    }

    public void open(int playerId) {
        players.requirePlayer(playerId);
        ZooRow zoo = zooRow(playerId);
        if (zoo.isOpen) throw new ApiException(409, "Zoo đang mở rồi");
        if (loadHabitats(playerId, time.now()).stream().allMatch(h -> h.animals().isEmpty())) {
            throw new ApiException(409, "Cần ít nhất 1 con thú trước khi mở cửa");
        }
        saveZoo(playerId, true, time.now());
    }

    public CollectResult close(int playerId) {
        CollectResult collected = collect(playerId);
        saveZoo(playerId, false, time.now());
        return collected;
    }

    public CollectResult collect(int playerId) {
        players.requirePlayer(playerId);
        ZooRow zoo = zooRow(playerId);
        if (!zoo.isOpen) throw new ApiException(409, "Zoo chưa mở cửa");
        long now = time.now();
        Stats stats = statsOf(loadHabitats(playerId, now));
        long earned = accruedVang(playerId, zoo, stats, now);
        saveZoo(playerId, true, now);
        long balance = earned > 0
                ? economy.earn(playerId, EconomyService.VANG, earned, "ZOO_REVENUE", "zoo", String.valueOf(playerId))
                : economy.balances(playerId).get(EconomyService.VANG);
        int xp = (int) Math.min(200, earned / 20);
        if (xp > 0) players.addZooXp(playerId, xp);
        return new CollectResult(earned, xp, balance);
    }

    // Doanh thu = số khách × chi tiêu (tuỳ hạng) − chi phí vận hành, tính theo giờ đã trôi qua.
    private long accruedVang(int playerId, ZooRow zoo, Stats stats, long now) {
        if (zoo.lastCollectAt == null) return 0;
        long elapsed = Math.min(MAX_ACCRUAL_MS, Math.max(0, now - zoo.lastCollectAt));
        double hours = elapsed / 3_600_000.0;
        var report = ZooEconomy.report(stats.totalAppeal, stats.coverage, stats.decorAppeal,
                stats.distinctSpecies, players.profile(playerId).zooLevel(), stats.habitatCount);
        return (long) Math.floor(report.netPerHour() * hours);
    }

    private List<HabitatView> loadHabitats(int playerId, long now) {
        List<HabitatView> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection()) {
            try (PreparedStatement ps = c.prepareStatement(
                    "SELECT id, type_id FROM habitats WHERE player_id = ? ORDER BY id")) {
                ps.setInt(1, playerId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Catalog.HabitatTypeDef type = Catalog.habitatType(rs.getString("type_id")).orElseThrow();
                        int habitatId = rs.getInt("id");
                        List<DecorView> decors = decorsOf(habitatId);
                        int decorAppeal = decors.stream().mapToInt(DecorView::appealBonus).sum();
                        out.add(new HabitatView(habitatId, type.id(), type.name(), type.capacity(),
                                new ArrayList<>(), decors, decorAppeal));
                    }
                }
            }
            try (PreparedStatement ps = c.prepareStatement(
                    "SELECT id, habitat_id, species_id, last_fed_at FROM zoo_animals WHERE player_id = ? ORDER BY id")) {
                ps.setInt(1, playerId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int habitatId = rs.getInt("habitat_id");
                        Catalog.SpeciesDef species = Catalog.species(rs.getString("species_id")).orElseThrow();
                        Timestamp lastFed = rs.getTimestamp("last_fed_at");
                        boolean fed = lastFed != null && now - lastFed.getTime() < FED_WINDOW_MS;
                        AnimalView view = new AnimalView(rs.getInt("id"), species.id(), species.name(), habitatId,
                                fed, species.appeal(), species.rarity());
                        out.stream().filter(h -> h.id() == habitatId).findFirst()
                                .ifPresent(h -> h.animals().add(view));
                    }
                }
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc zoo: " + e.getMessage());
        }
    }

    private record ZooRow(boolean isOpen, Long lastCollectAt) {
    }

    private ZooRow zooRow(int playerId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT is_open, last_collect_at FROM zoos WHERE player_id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return new ZooRow(false, null);
                Timestamp last = rs.getTimestamp("last_collect_at");
                return new ZooRow(rs.getBoolean("is_open"), last == null ? null : last.getTime());
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc trạng thái zoo: " + e.getMessage());
        }
    }

    private void saveZoo(int playerId, boolean isOpen, long lastCollectAt) {
        try (Connection c = dataSource.getConnection()) {
            int updated;
            try (PreparedStatement upd = c.prepareStatement(
                    "UPDATE zoos SET is_open = ?, last_collect_at = ? WHERE player_id = ?")) {
                upd.setBoolean(1, isOpen);
                upd.setTimestamp(2, new Timestamp(lastCollectAt));
                upd.setInt(3, playerId);
                updated = upd.executeUpdate();
            }
            if (updated == 0) {
                try (PreparedStatement ins = c.prepareStatement(
                        "INSERT INTO zoos (player_id, is_open, last_collect_at) VALUES (?, ?, ?)")) {
                    ins.setInt(1, playerId);
                    ins.setBoolean(2, isOpen);
                    ins.setTimestamp(3, new Timestamp(lastCollectAt));
                    ins.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi lưu trạng thái zoo: " + e.getMessage());
        }
    }

    private record HabitatRow(String typeId) {
    }

    private HabitatRow habitatRow(int playerId, int habitatId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT type_id FROM habitats WHERE id = ? AND player_id = ?")) {
            ps.setInt(1, habitatId);
            ps.setInt(2, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new ApiException(404, "Không tìm thấy chuồng");
                return new HabitatRow(rs.getString("type_id"));
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc chuồng: " + e.getMessage());
        }
    }

    private int countAnimals(int habitatId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT COUNT(*) FROM zoo_animals WHERE habitat_id = ?")) {
            ps.setInt(1, habitatId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đếm thú: " + e.getMessage());
        }
    }
}
