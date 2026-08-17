package vn.dreamtech.myzoo.server.gacha;

import vn.dreamtech.myzoo.server.catalog.CosmeticCatalog;
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
import java.util.HashSet;
import java.util.List;
import java.util.Set;

// Sở hữu và mặc đồ ngoại hình. Tách khỏi GachaService vì gacha chỉ là một trong các nguồn cấp đồ.
public final class CosmeticService {
    private final DataSource dataSource;
    private final PlayerService players;
    private final TimeSource time;

    public CosmeticService(DataSource dataSource, PlayerService players, TimeSource time) {
        this.dataSource = dataSource;
        this.players = players;
        this.time = time;
    }

    public record CosmeticView(String id, String name, String kind, String tier, boolean owned, boolean equipped) {
    }

    public record EquipResult(String cosmeticId, String kind, String avatar, String zooSkin) {
    }

    public List<CosmeticView> list(int playerId) {
        players.requirePlayer(playerId);
        Set<String> owned = ownedIds(playerId);
        Equipped equipped = equipped(playerId);
        List<CosmeticView> out = new ArrayList<>();
        for (var def : CosmeticCatalog.COSMETICS) {
            boolean isOn = def.id().equals(equipped.avatar) || def.id().equals(equipped.zooSkin);
            out.add(new CosmeticView(def.id(), def.name(), def.kind(), def.tier(), owned.contains(def.id()), isOn));
        }
        return out;
    }

    public Set<String> ownedIds(int playerId) {
        Set<String> out = new HashSet<>();
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT cosmetic_id FROM owned_cosmetics WHERE player_id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(rs.getString("cosmetic_id"));
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc đồ ngoại hình: " + e.getMessage());
        }
        return out;
    }

    // Trả về true nếu đây là món mới; false nghĩa là đã có (người gọi quy ra mảnh).
    public boolean grant(int playerId, String cosmeticId, String source) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO owned_cosmetics (player_id, cosmetic_id, source, acquired_at) VALUES (?, ?, ?, ?)")) {
            ps.setInt(1, playerId);
            ps.setString(2, cosmeticId);
            ps.setString(3, source);
            ps.setTimestamp(4, new Timestamp(time.now()));
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            // Đụng khoá chính = đã sở hữu từ trước. Dựa vào ràng buộc DB thay vì đọc-rồi-ghi để khỏi đua.
            return false;
        }
    }

    public EquipResult equip(int playerId, String cosmeticId) {
        players.requirePlayer(playerId);
        var def = CosmeticCatalog.cosmetic(cosmeticId)
                .orElseThrow(() -> new ApiException(404, "Không có món ngoại hình này"));
        if (!ownedIds(playerId).contains(cosmeticId)) {
            throw new ApiException(403, "Bạn chưa sở hữu món này");
        }
        String column = CosmeticCatalog.AVATAR.equals(def.kind()) ? "avatar" : "equipped_skin";
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "UPDATE players SET " + column + " = ? WHERE id = ?")) {
            ps.setString(1, cosmeticId);
            ps.setInt(2, playerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi mặc đồ: " + e.getMessage());
        }
        Equipped now = equipped(playerId);
        return new EquipResult(cosmeticId, def.kind(), now.avatar, now.zooSkin);
    }

    // Ngoại hình gốc ai cũng dùng được, chỉ đồ từ gacha mới cần kiểm tra sở hữu.
    public void requireWearable(int playerId, String avatarId) {
        if (avatarId == null || avatarId.isBlank() || CosmeticCatalog.isStarterAvatar(avatarId)) return;
        if (!ownedIds(playerId).contains(avatarId)) throw new ApiException(403, "Bạn chưa sở hữu ngoại hình này");
    }

    private Equipped equipped(int playerId) {
        try (Connection c = dataSource.getConnection(); PreparedStatement ps = c.prepareStatement(
                "SELECT avatar, equipped_skin FROM players WHERE id = ?")) {
            ps.setInt(1, playerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return new Equipped(null, null);
                return new Equipped(rs.getString("avatar"), rs.getString("equipped_skin"));
            }
        } catch (SQLException e) {
            throw new ApiException(500, "Lỗi đọc đồ đang mặc: " + e.getMessage());
        }
    }

    private record Equipped(String avatar, String zooSkin) {
    }
}
