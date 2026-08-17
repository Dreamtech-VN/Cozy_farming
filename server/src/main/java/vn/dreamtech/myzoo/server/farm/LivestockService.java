package vn.dreamtech.myzoo.server.farm;

import vn.dreamtech.myzoo.server.catalog.Catalog;
import vn.dreamtech.myzoo.server.economy.EconomyService;
import vn.dreamtech.myzoo.server.http.ApiException;
import vn.dreamtech.myzoo.server.player.PlayerService;
import vn.dreamtech.myzoo.server.time.TimeSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

// Chăn nuôi (spec §6.4). Không chạy timer mỗi giây — chỉ lưu next_product_at rồi so với giờ hiện tại.
public final class LivestockService {
    public static final int MAX_ANIMALS = 8;

    public static final String HUNGRY = "HUNGRY";     // chưa cho ăn, chưa đếm giờ
    public static final String GROWING = "GROWING";   // đã ăn, đang chờ ra sản phẩm
    public static final String READY = "READY";       // có sản phẩm chờ thu

    private final DataSource dataSource;
    private final EconomyService economy;
    private final PlayerService players;
    private final FarmService farm;
    private final TimeSource time;

    public LivestockService(DataSource dataSource, EconomyService economy, PlayerService players,
                            FarmService farm, TimeSource time) {
        this.dataSource = dataSource;
        this.economy = economy;
        this.players = players;
        this.farm = farm;
        this.time = time;
    }

    public record AnimalView(long id, String speciesId, String name, String state, long readyAt,
                             String foodId, int foodQty, String productId, int productQty) {
    }

    public record BarnView(List<AnimalView> animals, int maxAnimals, List<FarmService.ItemStack> storage) {
    }

    public record BuyResult(long id, String speciesId, long vangBalance, List<AnimalView> animals) {
    }

    public record FeedResult(int fedCount, List<AnimalView> animals, List<FarmService.ItemStack> storage) {
    }

    public record CollectResult(String productId, int quantity, List<AnimalView> animals,
                                List<FarmService.ItemStack> storage) {
    }

    public BarnView view(int playerId) {
        players.requirePlayer(playerId);
        return new BarnView(animals(playerId), MAX_ANIMALS, farm.storage(playerId));
    }

    public BuyResult buy(int playerId, String speciesId) {
        players.requirePlayer(playerId);
        Catalog.LivestockDef def = Catalog.livestock(speciesId)
                .orElseThrow(() -> new ApiException(404, "Không có vật nuôi này"));
        if (players.profile(playerId).farmLevel() < def.minFarmLevel()) {
            throw new ApiException(403, "Cần Nông trại cấp " + def.minFarmLevel());
        }
        if (count(playerId) >= MAX_ANIMALS) {
            throw new ApiException(409, "Chuồng đã đầy (tối đa " + MAX_ANIMALS + " con)");
        }

        long balance = economy.spend(playerId, EconomyService.VANG, def.cost(), "BUY_LIVESTOCK",
                "livestock", speciesId);
        long id;
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO livestock (player_id, species_id, created_at) VALUES (?, ?, ?)",
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, playerId);
            ps.setString(2, speciesId);
            ps.setTimestamp(3, new Timestamp(time.now()));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                id = keys.next() ? keys.getLong(1) : 0;
            }
        } catch (SQLException e) {
            economy.earn(playerId, EconomyService.VANG, def.cost(), "BUY_LIVESTOCK_REFUND", "livestock", speciesId);
            throw new ApiException(500, "Lỗi mua vật nuôi: " + e.getMessage());
        }
        return new BuyResult(id, speciesId, balance, animals(playerId));
    }

    // Cho ăn tất cả con đang đói mà kho đủ thức ăn — bấm một nút thay vì từng con.
    public FeedResult feedAll(int playerId) {
        players.requirePlayer(playerId);
        long now = time.now();
        int fed = 0;
        try (Connection c = dataSource.getConnection()) {
            c.setAutoCommit(false);
            try {
                List<Row> rows = readRows(c, playerId);
                var storage = farm.readInventoryMap("farm_inventory", playerId);
                for (Row row : rows) {
                    if (!HUNGRY.equals(stateOf(row, now))) continue;
                    Catalog.LivestockDef def = Catalog.livestock(row.speciesId).orElse(null);
                    if (def == null) continue;
                    if (storage.getOrDefault(def.foodId(), 0) < def.foodQty()) continue;

                    FarmService.addToInventory(c, "farm_inventory", playerId, def.foodId(), -def.foodQty());
                    storage.merge(def.foodId(), -def.foodQty(), Integer::sum);
                    try (PreparedStatement upd = c.prepareStatement(
                            "UPDATE livestock SET last_fed_at = ?, next_product_at = ? WHERE id = ?")) {
                        upd.setTimestamp(1, new Timestamp(now));
                        upd.setTimestamp(2, new Timestamp(now + def.productSeconds() * 1000L));
                        upd.setLong(3, row.id);
                        upd.executeUpdate();
                    }
                    fed++;
                }
                c.commit();
            } catch (RuntimeException | SQLException e) {
                c.rollback();
                if (e instanceof ApiException api) throw api;
                throw new ApiException(500, "Lỗi cho ăn: " + e.getMessage());
            } finally {
                c.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi kết nối khi cho ăn: " + e.getMessage());
        }
        if (fed == 0) throw new ApiException(409, "Không có con nào đang đói hoặc kho hết thức ăn");
        return new FeedResult(fed, animals(playerId), farm.storage(playerId));
    }

    public CollectResult collect(int playerId, long animalId) {
        players.requirePlayer(playerId);
        long now = time.now();
        Row row = findRow(playerId, animalId);
        if (row == null) throw new ApiException(404, "Không tìm thấy vật nuôi");
        if (!READY.equals(stateOf(row, now))) throw new ApiException(409, "Chưa có sản phẩm để thu");
        Catalog.LivestockDef def = Catalog.livestock(row.speciesId)
                .orElseThrow(() -> new ApiException(404, "Không có vật nuôi này"));

        try (Connection c = dataSource.getConnection()) {
            c.setAutoCommit(false);
            try {
                // Điều kiện next_product_at chưa đổi: hai request song song thì chỉ một cái thu được.
                int updated;
                try (PreparedStatement upd = c.prepareStatement(
                        "UPDATE livestock SET next_product_at = NULL WHERE id = ? AND next_product_at = ?")) {
                    upd.setLong(1, animalId);
                    upd.setTimestamp(2, new Timestamp(row.nextProductAt));
                    updated = upd.executeUpdate();
                }
                if (updated == 0) throw new ApiException(409, "Sản phẩm đã được thu");
                FarmService.addToInventory(c, "farm_inventory", playerId, def.productId(), def.productQty());
                c.commit();
            } catch (RuntimeException | SQLException e) {
                c.rollback();
                if (e instanceof ApiException api) throw api;
                throw new ApiException(500, "Lỗi thu sản phẩm: " + e.getMessage());
            } finally {
                c.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi kết nối khi thu: " + e.getMessage());
        }
        return new CollectResult(def.productId(), def.productQty(), animals(playerId), farm.storage(playerId));
    }

    public List<AnimalView> animals(int playerId) {
        long now = time.now();
        List<AnimalView> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection()) {
            for (Row row : readRows(c, playerId)) {
                Catalog.LivestockDef def = Catalog.livestock(row.speciesId).orElse(null);
                if (def == null) continue;
                out.add(new AnimalView(row.id, row.speciesId, def.name(), stateOf(row, now),
                        row.nextProductAt == null ? 0 : row.nextProductAt,
                        def.foodId(), def.foodQty(), def.productId(), def.productQty()));
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc chuồng trại: " + e.getMessage());
        }
        return out;
    }

    static String stateOf(Row row, long now) {
        if (row.nextProductAt == null) return HUNGRY;
        return row.nextProductAt <= now ? READY : GROWING;
    }

    private int count(int playerId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT COUNT(*) FROM livestock WHERE player_id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đếm vật nuôi: " + e.getMessage());
        }
    }

    private List<Row> readRows(Connection c, int playerId) throws SQLException {
        List<Row> out = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(
                "SELECT id, species_id, next_product_at FROM livestock WHERE player_id = ? ORDER BY id")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Timestamp next = rs.getTimestamp("next_product_at");
                    out.add(new Row(rs.getLong("id"), rs.getString("species_id"),
                            next == null ? null : next.getTime()));
                }
            }
        }
        return out;
    }

    private Row findRow(int playerId, long animalId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT id, species_id, next_product_at FROM livestock WHERE id = ? AND player_id = ?")) {
            ps.setLong(1, animalId);
            ps.setInt(2, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                Timestamp next = rs.getTimestamp("next_product_at");
                return new Row(rs.getLong("id"), rs.getString("species_id"),
                        next == null ? null : next.getTime());
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc vật nuôi: " + e.getMessage());
        }
    }

    record Row(long id, String speciesId, Long nextProductAt) {
    }
}
