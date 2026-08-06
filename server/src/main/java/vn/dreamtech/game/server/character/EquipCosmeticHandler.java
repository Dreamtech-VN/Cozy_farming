package vn.dreamtech.game.server.character;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import vn.dreamtech.game.server.dao.CharacterAppearanceDao;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.PlayerCosmeticDao;
import vn.dreamtech.game.server.http.JsonHttp;
import vn.dreamtech.game.server.model.CosmeticDef;
import vn.dreamtech.game.server.model.CosmeticType;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /api/character/appearance/equip {userId, slot, itemId} — trang bị 1
 * vật phẩm làm đẹp vào 1 ô ({@code slot} là tên {@link CosmeticType}, vd
 * "HAT", "AVATAR_FRAME"...). {@code itemId} null hoặc 0 = tháo ra (về mặc
 * định). Phải sở hữu vật phẩm và vật phẩm phải đúng loại ô mới trang bị được.
 */
public final class EquipCosmeticHandler implements HttpHandler {
    private final CharacterDao characterDao;
    private final CharacterAppearanceDao appearanceDao;
    private final PlayerCosmeticDao playerCosmeticDao;

    public EquipCosmeticHandler(CharacterDao characterDao, CharacterAppearanceDao appearanceDao, PlayerCosmeticDao playerCosmeticDao) {
        this.characterDao = characterDao;
        this.appearanceDao = appearanceDao;
        this.playerCosmeticDao = playerCosmeticDao;
    }

    record Req(int userId, String slot, Integer itemId) {
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
            JsonHttp.writeError(exchange, 405, "Chỉ nhận POST");
            return;
        }
        Req req = JsonHttp.readBody(exchange, Req.class);
        CosmeticType slot;
        try {
            slot = CosmeticType.valueOf(req.slot() == null ? "" : req.slot().toUpperCase());
        } catch (IllegalArgumentException e) {
            JsonHttp.writeError(exchange, 400, "Ô trang bị không hợp lệ");
            return;
        }
        try {
            if (characterDao.findByUserId(req.userId()).isEmpty()) {
                JsonHttp.writeError(exchange, 404, "Chưa tạo nhân vật");
                return;
            }
            Integer itemId = (req.itemId() != null && req.itemId() == 0) ? null : req.itemId();
            if (itemId != null) {
                CosmeticDef def = CosmeticCatalog.find(itemId).orElse(null);
                if (def == null || def.type() != slot) {
                    JsonHttp.writeError(exchange, 400, "Vật phẩm không khớp ô trang bị");
                    return;
                }
                if (!playerCosmeticDao.isOwned(req.userId(), itemId)) {
                    JsonHttp.writeError(exchange, 403, "Chưa sở hữu vật phẩm này");
                    return;
                }
            }
            appearanceDao.equip(req.userId(), slot, itemId);
            JsonHttp.write(exchange, 200, appearanceDao.find(req.userId()));
        } catch (SQLException e) {
            JsonHttp.writeError(exchange, 500, "Lỗi trang bị: " + e.getMessage());
        }
    }
}
