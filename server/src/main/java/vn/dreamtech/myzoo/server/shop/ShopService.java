package vn.dreamtech.myzoo.server.shop;

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
import java.util.ArrayList;
import java.util.List;

public final class ShopService {
    private final DataSource dataSource;
    private final EconomyService economy;
    private final PlayerService players;
    private final FarmService farm;
    private final TimeSource time;

    public ShopService(DataSource dataSource, EconomyService economy, PlayerService players,
                       FarmService farm, TimeSource time) {
        this.dataSource = dataSource;
        this.economy = economy;
        this.players = players;
        this.farm = farm;
        this.time = time;
    }

    public record InventoryEntry(String itemId, String name, String description, String type, int quantity) {
    }

    public record PurchaseResult(String itemId, int quantity, String currency, long spent,
                                 long vangBalance, long kcBalance, List<InventoryEntry> inventory) {
    }

    public record UseResult(String itemId, String effect, int remaining,
                            List<FarmService.ItemStack> farmStorage, List<InventoryEntry> inventory) {
    }

    public record TopupResult(String packId, long kcAdded, long kcBalance) {
    }

    public PurchaseResult purchase(int playerId, String itemId, int quantity) {
        players.requirePlayer(playerId);
        if (quantity <= 0 || quantity > 99) throw new ApiException(400, "Số lượng phải từ 1-99");
        ShopCatalog.ItemDef item = ShopCatalog.item(itemId)
                .orElseThrow(() -> new ApiException(404, "Không có món này trong cửa hàng"));

        long total = item.price() * quantity;
        String currency = "KC".equals(item.currency()) ? EconomyService.KIM_CUONG : EconomyService.VANG;
        economy.spend(playerId, currency, total, "SHOP_BUY", "item", itemId);
        addItem(playerId, itemId, quantity);

        var balances = economy.balances(playerId);
        return new PurchaseResult(itemId, quantity, item.currency(), total,
                balances.get(EconomyService.VANG), balances.get(EconomyService.KIM_CUONG), inventory(playerId));
    }

    public UseResult use(int playerId, String itemId, Integer plotIndex) {
        players.requirePlayer(playerId);
        ShopCatalog.ItemDef item = ShopCatalog.item(itemId)
                .orElseThrow(() -> new ApiException(404, "Không có vật phẩm này"));
        consumeItem(playerId, itemId);

        String effect;
        try {
            if (ShopCatalog.TYPE_FOOD.equals(item.type())) {
                try (Connection c = dataSource.getConnection()) {
                    FarmService.addToInventory(c, "farm_inventory", playerId, item.param(), item.value());
                } catch (SQLException e) {
                    throw new ApiException(500, "Lỗi thêm vào kho: " + e.getMessage());
                }
                effect = "Đã thêm " + item.value() + " " + item.param() + " vào kho nông trại";
            } else if (ShopCatalog.TYPE_GROW_BOOST.equals(item.type())) {
                if (plotIndex == null) throw new ApiException(400, "Cần chọn ô đất để dùng");
                farm.boostGrow(playerId, plotIndex);
                effect = "Ô " + (plotIndex + 1) + " đã chín ngay";
            } else {
                throw new ApiException(500, "Loại vật phẩm chưa hỗ trợ");
            }
        } catch (RuntimeException e) {
            addItem(playerId, itemId, 1);   // dùng thất bại thì trả lại vật phẩm
            throw e;
        }
        return new UseResult(itemId, effect, quantityOf(playerId, itemId), farm.storage(playerId), inventory(playerId));
    }

    // Nạp Kim Cương giả lập: chưa nối cổng thanh toán, nhưng vẫn ghi sổ cái như giao dịch thật.
    public TopupResult topup(int playerId, String packId) {
        players.requirePlayer(playerId);
        ShopCatalog.KcPack pack = ShopCatalog.pack(packId)
                .orElseThrow(() -> new ApiException(404, "Không có gói nạp này"));
        long balance = economy.earn(playerId, EconomyService.KIM_CUONG, pack.kcAmount(),
                "TOPUP_MOCK", "pack", packId);
        return new TopupResult(packId, pack.kcAmount(), balance);
    }

    public List<InventoryEntry> inventory(int playerId) {
        List<InventoryEntry> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT item_id, quantity FROM player_items WHERE player_id = ? AND quantity > 0 ORDER BY item_id")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String itemId = rs.getString("item_id");
                    var def = ShopCatalog.item(itemId).orElse(null);
                    out.add(new InventoryEntry(itemId,
                            def != null ? def.name() : itemId,
                            def != null ? def.description() : "",
                            def != null ? def.type() : "",
                            rs.getInt("quantity")));
                }
            }
            return out;
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc kho đồ: " + e.getMessage());
        }
    }

    int quantityOf(int playerId, String itemId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT quantity FROM player_items WHERE player_id = ? AND item_id = ?")) {
            ps.setInt(1, playerId);
            ps.setString(2, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("quantity") : 0;
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc vật phẩm: " + e.getMessage());
        }
    }

    private void addItem(int playerId, String itemId, int quantity) {
        try (Connection c = dataSource.getConnection()) {
            int updated;
            try (PreparedStatement upd = c.prepareStatement(
                    "UPDATE player_items SET quantity = quantity + ? WHERE player_id = ? AND item_id = ?")) {
                upd.setInt(1, quantity);
                upd.setInt(2, playerId);
                upd.setString(3, itemId);
                updated = upd.executeUpdate();
            }
            if (updated == 0) {
                try (PreparedStatement ins = c.prepareStatement(
                        "INSERT INTO player_items (player_id, item_id, quantity) VALUES (?, ?, ?)")) {
                    ins.setInt(1, playerId);
                    ins.setString(2, itemId);
                    ins.setInt(3, quantity);
                    ins.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi thêm vật phẩm: " + e.getMessage());
        }
    }

    // Trừ có điều kiện: hết hàng thì không có dòng nào bị đổi, tránh dùng lố khi bấm nhanh.
    private void consumeItem(int playerId, String itemId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE player_items SET quantity = quantity - 1 WHERE player_id = ? AND item_id = ? AND quantity > 0")) {
            ps.setInt(1, playerId);
            ps.setString(2, itemId);
            if (ps.executeUpdate() == 0) throw new ApiException(409, "Bạn không có vật phẩm này");
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi dùng vật phẩm: " + e.getMessage());
        }
    }
}
