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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

public final class FarmService {
    public static final int PLOT_COUNT = 48;

    private final DataSource dataSource;
    private final EconomyService economy;
    private final PlayerService players;
    private final TimeSource time;
    private final Random random = new Random();

    public FarmService(DataSource dataSource, EconomyService economy, PlayerService players, TimeSource time) {
        this.dataSource = dataSource;
        this.economy = economy;
        this.players = players;
        this.time = time;
    }

    public record PlotView(int plotIndex, String state, String cropId, Long plantedAt, Long readyAt) {
    }

    // Kho trả về dạng mảng (không phải map khoá động) để client engine đọc bằng JSON parser có sẵn.
    public record ItemStack(String foodId, int quantity) {
    }

    public record FarmView(List<PlotView> plots, List<ItemStack> storage) {
    }

    public record PlantResult(int plotIndex, String cropId, long readyAt, long vangBalance) {
    }

    public record HarvestResult(int plotIndex, String cropId, int yield, int xp) {
    }

    public record SellResult(String foodId, int quantity, long vangEarned, long vangBalance) {
    }

    public FarmView view(int playerId) {
        players.requirePlayer(playerId);
        long now = time.now();
        Map<Integer, PlotView> planted = new LinkedHashMap<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT plot_index, crop_id, planted_at, ready_at FROM farm_plots WHERE player_id = ? AND crop_id IS NOT NULL")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    long readyAt = rs.getTimestamp("ready_at").getTime();
                    planted.put(rs.getInt("plot_index"), new PlotView(
                            rs.getInt("plot_index"),
                            now >= readyAt ? "READY" : "GROWING",
                            rs.getString("crop_id"),
                            rs.getTimestamp("planted_at").getTime(),
                            readyAt));
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc nông trại: " + e.getMessage());
        }
        List<PlotView> plots = new ArrayList<>();
        for (int i = 0; i < PLOT_COUNT; i++) {
            plots.add(planted.getOrDefault(i, new PlotView(i, "EMPTY", null, null, null)));
        }
        return new FarmView(plots, storage(playerId));
    }

    public PlantResult plant(int playerId, int plotIndex, String cropId) {
        players.requirePlayer(playerId);
        if (plotIndex < 0 || plotIndex >= PLOT_COUNT) throw new ApiException(400, "Ô đất không hợp lệ");
        Catalog.CropDef crop = Catalog.crop(cropId)
                .orElseThrow(() -> new ApiException(404, "Không có loại cây này"));
        if (players.profile(playerId).farmLevel() < crop.minFarmLevel()) {
            throw new ApiException(403, "Cần Nông trại level " + crop.minFarmLevel() + " để trồng " + crop.name());
        }
        if (findCrop(playerId, plotIndex) != null) throw new ApiException(409, "Ô đất đang có cây");

        long balance = economy.spend(playerId, EconomyService.VANG, crop.seedCost(), "SEED", "plot", cropId);
        long now = time.now();
        long readyAt = now + crop.growthSeconds() * 1000L;
        try (Connection c = dataSource.getConnection()) {
            int updated;
            try (PreparedStatement upd = c.prepareStatement(
                    "UPDATE farm_plots SET crop_id = ?, planted_at = ?, ready_at = ? WHERE player_id = ? AND plot_index = ?")) {
                upd.setString(1, cropId);
                upd.setTimestamp(2, new Timestamp(now));
                upd.setTimestamp(3, new Timestamp(readyAt));
                upd.setInt(4, playerId);
                upd.setInt(5, plotIndex);
                updated = upd.executeUpdate();
            }
            if (updated == 0) {
                try (PreparedStatement ins = c.prepareStatement(
                        "INSERT INTO farm_plots (player_id, plot_index, crop_id, planted_at, ready_at) VALUES (?, ?, ?, ?, ?)")) {
                    ins.setInt(1, playerId);
                    ins.setInt(2, plotIndex);
                    ins.setString(3, cropId);
                    ins.setTimestamp(4, new Timestamp(now));
                    ins.setTimestamp(5, new Timestamp(readyAt));
                    ins.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi trồng cây: " + e.getMessage());
        }
        return new PlantResult(plotIndex, cropId, readyAt, balance);
    }

    public HarvestResult harvest(int playerId, int plotIndex) {
        players.requirePlayer(playerId);
        PlotRow row = findCrop(playerId, plotIndex);
        if (row == null) throw new ApiException(409, "Ô đất trống");
        if (time.now() < row.readyAt) throw new ApiException(409, "Cây chưa chín");
        Catalog.CropDef crop = Catalog.crop(row.cropId).orElseThrow();

        int yield = crop.yieldMin() + random.nextInt(crop.yieldMax() - crop.yieldMin() + 1);
        try (Connection c = dataSource.getConnection()) {
            try (PreparedStatement clear = c.prepareStatement(
                    "UPDATE farm_plots SET crop_id = NULL, planted_at = NULL, ready_at = NULL WHERE player_id = ? AND plot_index = ?")) {
                clear.setInt(1, playerId);
                clear.setInt(2, plotIndex);
                clear.executeUpdate();
            }
            addToInventory(c, "farm_inventory", playerId, row.cropId, yield);
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi thu hoạch: " + e.getMessage());
        }
        players.addFarmXp(playerId, crop.xp());
        return new HarvestResult(plotIndex, row.cropId, yield, crop.xp());
    }

    public SellResult sell(int playerId, String foodId, int quantity) {
        players.requirePlayer(playerId);
        if (quantity <= 0) throw new ApiException(400, "Số lượng phải > 0");
        long unitPrice = Catalog.sellPrice(foodId)
                .orElseThrow(() -> new ApiException(404, "Không bán được loại này"));
        try (Connection c = dataSource.getConnection()) {
            addToInventory(c, "farm_inventory", playerId, foodId, -quantity);
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi bán nông sản: " + e.getMessage());
        }
        long earned = unitPrice * quantity;
        long balance = economy.earn(playerId, EconomyService.VANG, earned, "SELL_PRODUCE", "food", foodId);
        return new SellResult(foodId, quantity, earned, balance);
    }

    // Dùng vật phẩm tăng tốc: kéo ready_at về hiện tại. Chỉ áp dụng cho ô đang lớn.
    public void boostGrow(int playerId, int plotIndex) {
        players.requirePlayer(playerId);
        PlotRow row = findCrop(playerId, plotIndex);
        if (row == null) throw new ApiException(409, "Ô đất trống");
        if (time.now() >= row.readyAt) throw new ApiException(409, "Cây đã chín rồi");
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE farm_plots SET ready_at = ? WHERE player_id = ? AND plot_index = ?")) {
            ps.setTimestamp(1, new Timestamp(time.now()));
            ps.setInt(2, playerId);
            ps.setInt(3, plotIndex);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi giục cây: " + e.getMessage());
        }
    }

    public List<ItemStack> storage(int playerId) {
        return readInventory("farm_inventory", playerId);
    }

    // Dùng chung cho farm_inventory lẫn zoo_warehouse (cùng shape bảng).
    public static void addToInventory(Connection c, String table, int playerId, String foodId, int delta) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(
                "SELECT quantity FROM " + table + " WHERE player_id = ? AND food_id = ? FOR UPDATE")) {
            ps.setInt(1, playerId);
            ps.setString(2, foodId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int after = rs.getInt("quantity") + delta;
                    if (after < 0) throw new ApiException(409, "Không đủ hàng trong kho");
                    try (PreparedStatement upd = c.prepareStatement(
                            "UPDATE " + table + " SET quantity = ? WHERE player_id = ? AND food_id = ?")) {
                        upd.setInt(1, after);
                        upd.setInt(2, playerId);
                        upd.setString(3, foodId);
                        upd.executeUpdate();
                    }
                    return;
                }
            }
        }
        if (delta < 0) throw new ApiException(409, "Không đủ hàng trong kho");
        try (PreparedStatement ins = c.prepareStatement(
                "INSERT INTO " + table + " (player_id, food_id, quantity) VALUES (?, ?, ?)")) {
            ins.setInt(1, playerId);
            ins.setString(2, foodId);
            ins.setInt(3, delta);
            ins.executeUpdate();
        }
    }

    public List<ItemStack> readInventory(String table, int playerId) {
        List<ItemStack> out = new ArrayList<>();
        readInventoryMap(table, playerId).forEach((foodId, qty) -> out.add(new ItemStack(foodId, qty)));
        return out;
    }

    public Map<String, Integer> readInventoryMap(String table, int playerId) {
        Map<String, Integer> out = new LinkedHashMap<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT food_id, quantity FROM " + table + " WHERE player_id = ? AND quantity > 0")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.put(rs.getString("food_id"), rs.getInt("quantity"));
                }
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc kho: " + e.getMessage());
        }
    }

    private record PlotRow(String cropId, long readyAt) {
    }

    private PlotRow findCrop(int playerId, int plotIndex) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT crop_id, ready_at FROM farm_plots WHERE player_id = ? AND plot_index = ? AND crop_id IS NOT NULL")) {
            ps.setInt(1, playerId);
            ps.setInt(2, plotIndex);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return new PlotRow(rs.getString("crop_id"), rs.getTimestamp("ready_at").getTime());
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc ô đất: " + e.getMessage());
        }
    }
}
