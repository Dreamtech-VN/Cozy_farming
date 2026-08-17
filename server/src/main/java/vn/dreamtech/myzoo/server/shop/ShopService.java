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
    private final IapVerifier verifier;

    public ShopService(DataSource dataSource, EconomyService economy, PlayerService players,
                       FarmService farm, TimeSource time) {
        this(dataSource, economy, players, farm, time, new IapVerifier());
    }

    public ShopService(DataSource dataSource, EconomyService economy, PlayerService players,
                       FarmService farm, TimeSource time, IapVerifier verifier) {
        this.verifier = verifier;
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

    // Nạp giả lập cho lúc phát triển. Mặc định TẮT — trước đây endpoint này mở cho mọi người,
    // nghĩa là ai cũng tự cộng được Kim Cương nếu server chạy thật.
    public TopupResult topup(int playerId, String packId) {
        players.requirePlayer(playerId);
        if (!verifier.mockAllowed()) {
            throw new ApiException(503, "Nạp giả lập đang tắt — dùng /v1/shop/purchase-verify");
        }
        ShopCatalog.KcPack pack = ShopCatalog.pack(packId)
                .orElseThrow(() -> new ApiException(404, "Không có gói nạp này"));
        long balance = economy.earn(playerId, EconomyService.KIM_CUONG, pack.kcAmount(),
                "TOPUP_MOCK", "pack", packId);
        return new TopupResult(packId, pack.kcAmount(), balance);
    }

    public record OrderResult(long orderId, String provider, String productId, long kcAdded,
                              long kcBalance, boolean alreadyGranted) {
    }

    public record OrderRow(long id, int playerId, String provider, String productId,
                           String externalTransactionId, String status, long kcAmount, long priceVnd,
                           long createdAt) {
    }

    // Luồng đúng theo spec §27.14: client mua ở store rồi gửi biên nhận lên, server hỏi lại store,
    // ghi đơn hàng, cộng Kim Cương, ghi sổ cái. Client không bao giờ tự khai số tiền.
    public OrderResult verifyAndGrant(int playerId, String provider, String packId, String receipt) {
        players.requirePlayer(playerId);
        ShopCatalog.KcPack pack = ShopCatalog.pack(packId)
                .orElseThrow(() -> new ApiException(404, "Không có gói nạp này"));

        var verified = verifier.verify(provider, packId, receipt);

        // Khoá duy nhất trên mã giao dịch: gửi lại cùng một biên nhận không bao giờ cộng tiền lần hai.
        Long existingId = findOrderId(verified.externalTransactionId());
        if (existingId != null) {
            return new OrderResult(existingId, verified.provider(), packId, 0,
                    economy.balances(playerId).get(EconomyService.KIM_CUONG), true);
        }

        long orderId;
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO premium_orders (player_id, provider, product_id, external_transaction_id, "
                        + "status, kc_amount, price_vnd, created_at) VALUES (?, ?, ?, ?, 'PENDING', ?, ?, ?)",
                java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, playerId);
            ps.setString(2, verified.provider());
            ps.setString(3, packId);
            ps.setString(4, verified.externalTransactionId());
            ps.setLong(5, pack.kcAmount());
            ps.setLong(6, pack.priceVnd());
            ps.setTimestamp(7, new java.sql.Timestamp(time.now()));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                orderId = keys.next() ? keys.getLong(1) : 0;
            }
        } catch (SQLException e) {
            // Hai request song song cùng biên nhận: cái thua cuộc đọc lại đơn của cái thắng.
            Long winner = findOrderId(verified.externalTransactionId());
            if (winner != null) {
                return new OrderResult(winner, verified.provider(), packId, 0,
                        economy.balances(playerId).get(EconomyService.KIM_CUONG), true);
            }
            throw new ApiException(500, "Lỗi ghi đơn hàng: " + e.getMessage());
        }

        long balance = economy.earn(playerId, EconomyService.KIM_CUONG, pack.kcAmount(),
                "IAP", "order", String.valueOf(orderId));
        markGranted(orderId);
        return new OrderResult(orderId, verified.provider(), packId, pack.kcAmount(), balance, false);
    }

    public List<OrderRow> orders(int playerId, int limit) {
        int size = limit <= 0 || limit > 100 ? 30 : limit;
        List<OrderRow> out = new ArrayList<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT id, player_id, provider, product_id, external_transaction_id, status, kc_amount, "
                        + "price_vnd, created_at FROM premium_orders WHERE player_id = ? ORDER BY id DESC LIMIT ?")) {
            ps.setInt(1, playerId);
            ps.setInt(2, size);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(new OrderRow(rs.getLong("id"), rs.getInt("player_id"), rs.getString("provider"),
                            rs.getString("product_id"), rs.getString("external_transaction_id"),
                            rs.getString("status"), rs.getLong("kc_amount"), rs.getLong("price_vnd"),
                            rs.getTimestamp("created_at").getTime()));
                }
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc lịch sử nạp: " + e.getMessage());
        }
        return out;
    }

    private Long findOrderId(String externalTransactionId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT id FROM premium_orders WHERE external_transaction_id = ?")) {
            ps.setString(1, externalTransactionId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong("id") : null;
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi tra đơn hàng: " + e.getMessage());
        }
    }

    private void markGranted(long orderId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE premium_orders SET status = 'GRANTED' WHERE id = ?")) {
            ps.setLong(1, orderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi cập nhật đơn hàng: " + e.getMessage());
        }
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
