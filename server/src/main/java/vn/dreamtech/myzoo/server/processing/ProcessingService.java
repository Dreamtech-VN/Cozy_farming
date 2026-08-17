package vn.dreamtech.myzoo.server.processing;

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
import java.util.Optional;

// Chế biến nông sản (spec: "sell OR process"): nguyên liệu -> thành phẩm bán giá cao hơn.
// Cùng cơ chế thời gian lười như trồng cây: ghi ready_at, không có tiến trình chạy nền.
public final class ProcessingService {
    public static final int MAX_SLOTS = 3;

    public record RecipeDef(String id, String name, String inputFoodId, int inputQty,
                            String outputFoodId, int outputQty, int seconds, int minFarmLevel) {
    }

    public static final List<RecipeDef> RECIPES = List.of(
            new RecipeDef("flour", "Bột mì", "wheat", 3, "flour", 1, 120, 1),
            new RecipeDef("bread", "Bánh mì", "flour", 2, "bread", 1, 240, 2),
            new RecipeDef("carrot_cake", "Bánh cà rốt", "carrot", 4, "carrot_cake", 1, 300, 3),
            new RecipeDef("berry_jam", "Mứt dâu", "berry", 3, "berry_jam", 1, 360, 4),
            // Khép vòng chăn nuôi → chế biến theo spec §6.5: Sữa → Phô mai, Trứng → Bánh.
            new RecipeDef("cheese", "Phô mai", "milk", 3, "cheese", 1, 480, 3),
            new RecipeDef("cake", "Bánh kem", "egg", 4, "cake", 1, 540, 4));

    public static Optional<RecipeDef> recipe(String id) {
        return RECIPES.stream().filter(r -> r.id().equals(id)).findFirst();
    }

    private final DataSource dataSource;
    private final PlayerService players;
    private final FarmService farm;
    private final TimeSource time;

    public ProcessingService(DataSource dataSource, PlayerService players, FarmService farm, TimeSource time) {
        this.dataSource = dataSource;
        this.players = players;
        this.farm = farm;
        this.time = time;
    }

    public record SlotView(long id, String recipeId, String name, String outputFoodId, int outputQty,
                           long startedAt, long readyAt, boolean ready) {
    }

    public record ProcessingView(List<SlotView> slots, int maxSlots, List<FarmService.ItemStack> storage) {
    }

    public record StartResult(long slotId, String recipeId, long readyAt, List<FarmService.ItemStack> storage) {
    }

    public record CollectResult(long slotId, String outputFoodId, int quantity, List<FarmService.ItemStack> storage) {
    }

    public ProcessingView view(int playerId) {
        players.requirePlayer(playerId);
        return new ProcessingView(slots(playerId), MAX_SLOTS, farm.storage(playerId));
    }

    public StartResult start(int playerId, String recipeId) {
        players.requirePlayer(playerId);
        RecipeDef recipe = recipe(recipeId)
                .orElseThrow(() -> new ApiException(404, "Không có công thức này"));
        if (players.profile(playerId).farmLevel() < recipe.minFarmLevel()) {
            throw new ApiException(403, "Cần Nông trại level " + recipe.minFarmLevel() + " để chế biến " + recipe.name());
        }
        if (slots(playerId).size() >= MAX_SLOTS) {
            throw new ApiException(409, "Hết chỗ chế biến, thu thành phẩm trước đã");
        }

        long now = time.now();
        long readyAt = now + recipe.seconds() * 1000L;
        long slotId;
        try (Connection c = dataSource.getConnection()) {
            c.setAutoCommit(false);
            try {
                FarmService.addToInventory(c, "farm_inventory", playerId, recipe.inputFoodId(), -recipe.inputQty());
                try (PreparedStatement ps = c.prepareStatement(
                        "INSERT INTO processing_slots (player_id, recipe_id, started_at, ready_at, collected) "
                                + "VALUES (?, ?, ?, ?, FALSE)", Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, playerId);
                    ps.setString(2, recipeId);
                    ps.setTimestamp(3, new Timestamp(now));
                    ps.setTimestamp(4, new Timestamp(readyAt));
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        keys.next();
                        slotId = keys.getLong(1);
                    }
                }
                c.commit();
            } catch (ApiException | SQLException e) {
                c.rollback();
                if (e instanceof ApiException api) throw api;
                throw new ApiException(500, "Lỗi bắt đầu chế biến: " + e.getMessage());
            } finally {
                c.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi kết nối chế biến: " + e.getMessage());
        }
        return new StartResult(slotId, recipeId, readyAt, farm.storage(playerId));
    }

    public CollectResult collect(int playerId, long slotId) {
        players.requirePlayer(playerId);
        SlotView slot = slots(playerId).stream().filter(s -> s.id() == slotId).findFirst()
                .orElseThrow(() -> new ApiException(404, "Không có mẻ chế biến này"));
        if (!slot.ready()) throw new ApiException(409, "Chưa chế biến xong");

        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE processing_slots SET collected = TRUE WHERE id = ? AND player_id = ? AND collected = FALSE")) {
            ps.setLong(1, slotId);
            ps.setInt(2, playerId);
            if (ps.executeUpdate() == 0) throw new ApiException(409, "Mẻ này đã thu rồi");
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi thu thành phẩm: " + e.getMessage());
        }

        try (Connection c = dataSource.getConnection()) {
            FarmService.addToInventory(c, "farm_inventory", playerId, slot.outputFoodId(), slot.outputQty());
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi thêm thành phẩm: " + e.getMessage());
        }
        return new CollectResult(slotId, slot.outputFoodId(), slot.outputQty(), farm.storage(playerId));
    }

    List<SlotView> slots(int playerId) {
        long now = time.now();
        List<SlotView> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT id, recipe_id, started_at, ready_at FROM processing_slots "
                        + "WHERE player_id = ? AND collected = FALSE ORDER BY id")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecipeDef def = recipe(rs.getString("recipe_id")).orElse(null);
                    if (def == null) continue;
                    long readyAt = rs.getTimestamp("ready_at").getTime();
                    out.add(new SlotView(rs.getLong("id"), def.id(), def.name(), def.outputFoodId(), def.outputQty(),
                            rs.getTimestamp("started_at").getTime(), readyAt, now >= readyAt));
                }
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc chế biến: " + e.getMessage());
        }
    }
}
