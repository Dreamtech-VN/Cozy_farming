package vn.dreamtech.game.server.character;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.CharacterAppearanceDao;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.PlayerCosmeticDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.model.Character;

import javax.sql.DataSource;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test trọn luồng trang bị vật phẩm làm đẹp (mắt/avatar/khung/danh hiệu/biểu cảm/trang bị) qua HTTP thật, DB H2 nhúng. */
class AppearanceFlowTest {
    private HttpServer server;
    private int port;
    private int userId;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:appearance_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE users (
                  id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) UNIQUE, password_hash VARCHAR(255),
                  guest_token VARCHAR(64) UNIQUE, google_id VARCHAR(128) UNIQUE, apple_id VARCHAR(128) UNIQUE,
                  display_name VARCHAR(50), created_at TIMESTAMP NOT NULL
                )
                """);
            st.execute("""
                CREATE TABLE characters (
                  user_id INT NOT NULL PRIMARY KEY, name VARCHAR(20) NOT NULL UNIQUE, gender TINYINT NOT NULL,
                  hair_id INT NOT NULL, top_id INT NOT NULL, bottom_id INT NOT NULL, created_at TIMESTAMP NOT NULL
                )
                """);
            st.execute("""
                CREATE TABLE player_cosmetics (
                  user_id INT NOT NULL, item_id INT NOT NULL, unlocked_at TIMESTAMP NOT NULL,
                  PRIMARY KEY (user_id, item_id)
                )
                """);
            st.execute("""
                CREATE TABLE character_appearance (
                  user_id INT NOT NULL PRIMARY KEY, eyes_id INT, avatar_id INT, avatar_frame_id INT,
                  title_id INT, emote_id INT, hat_id INT, shirt_id INT, pants_id INT, shoes_id INT,
                  pet_id INT, skin_id INT
                )
                """);
        }
        UserDao userDao = new UserDao(dataSource);
        CharacterDao characterDao = new CharacterDao(dataSource);
        PlayerCosmeticDao playerCosmeticDao = new PlayerCosmeticDao(dataSource);
        CharacterAppearanceDao appearanceDao = new CharacterAppearanceDao(dataSource);
        userId = userDao.createGuest("tok-1").id();
        characterDao.create(new Character(userId, "Alice", 1, 1, 1, 1));

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/cosmetics/catalog", new CosmeticCatalogHandler());
        server.createContext("/api/cosmetics/owned", new OwnedCosmeticsHandler(playerCosmeticDao));
        server.createContext("/api/cosmetics/unlock", new UnlockCosmeticHandler(playerCosmeticDao));
        server.createContext("/api/character/appearance/equip", new EquipCosmeticHandler(characterDao, appearanceDao, playerCosmeticDao));
        server.createContext("/api/character/appearance", new GetAppearanceHandler(appearanceDao));
        server.setExecutor(null);
        server.start();
        port = server.getAddress().getPort();
    }

    @AfterEach
    void stop() {
        server.stop(0);
    }

    private HttpResponse<String> post(String path, Object body) throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + path))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(gson.toJson(body)))
                .build();
        return http.send(req, HttpResponse.BodyHandlers.ofString());
    }

    private HttpResponse<String> get(String path) throws Exception {
        var req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + path)).GET().build();
        return http.send(req, HttpResponse.BodyHandlers.ofString());
    }

    @Test
    void catalogListsItems() throws Exception {
        var res = get("/api/cosmetics/catalog");
        assertEquals(200, res.statusCode());
        assertTrue(res.body().contains("hat_crown"));
    }

    @Test
    void equipWithoutOwningRejected() throws Exception {
        var res = post("/api/character/appearance/equip", new EquipCosmeticHandler.Req(userId, "HAT", 50));
        assertEquals(403, res.statusCode());
    }

    @Test
    void equipWrongSlotRejected() throws Exception {
        post("/api/cosmetics/unlock", new UnlockCosmeticHandler.Req(userId, 50)); // hat_crown
        var res = post("/api/character/appearance/equip", new EquipCosmeticHandler.Req(userId, "SHOES", 50));
        assertEquals(400, res.statusCode());
    }

    @Test
    void invalidSlotNameRejected() throws Exception {
        var res = post("/api/character/appearance/equip", new EquipCosmeticHandler.Req(userId, "NOT_A_SLOT", 50));
        assertEquals(400, res.statusCode());
    }

    @Test
    void fullCycle_unlockEquipUnequip() throws Exception {
        var unlock = post("/api/cosmetics/unlock", new UnlockCosmeticHandler.Req(userId, 51)); // hat_crown
        assertEquals(200, unlock.statusCode());

        var owned = get("/api/cosmetics/owned?userId=" + userId);
        assertTrue(owned.body().contains("51"));

        var equip = post("/api/character/appearance/equip", new EquipCosmeticHandler.Req(userId, "HAT", 51));
        assertEquals(200, equip.statusCode());
        JsonObject equipped = gson.fromJson(equip.body(), JsonObject.class);
        assertEquals(51, equipped.get("hatId").getAsInt());

        var get = get("/api/character/appearance?userId=" + userId);
        JsonObject appearance = gson.fromJson(get.body(), JsonObject.class);
        assertEquals(51, appearance.get("hatId").getAsInt());

        var unequip = post("/api/character/appearance/equip", new EquipCosmeticHandler.Req(userId, "HAT", 0));
        assertEquals(200, unequip.statusCode());
        JsonObject afterUnequip = gson.fromJson(unequip.body(), JsonObject.class);
        assertTrue(afterUnequip.get("hatId") == null || afterUnequip.get("hatId").isJsonNull());
    }

    @Test
    void equipWithoutCharacterRejected() throws Exception {
        var res = post("/api/character/appearance/equip", new EquipCosmeticHandler.Req(99999, "HAT", 51));
        assertEquals(404, res.statusCode());
    }
}
