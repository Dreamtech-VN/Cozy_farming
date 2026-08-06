package vn.dreamtech.game.server.guild;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.GuildDao;
import vn.dreamtech.game.server.dao.GuildMemberDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.WalletDao;
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

/** Test trọn luồng guild qua HTTP thật, DB H2 nhúng. */
class GuildFlowTest {
    private HttpServer server;
    private int port;
    private UserDao userDao;
    private CharacterDao characterDao;
    private WalletDao walletDao;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:guild_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
            st.execute("CREATE TABLE wallets (user_id INT NOT NULL PRIMARY KEY, gold BIGINT NOT NULL DEFAULT 0, diamond BIGINT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE guilds (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(30) NOT NULL UNIQUE, tag VARCHAR(6) NOT NULL UNIQUE, description VARCHAR(200), leader_user_id INT NOT NULL, created_at TIMESTAMP NOT NULL)");
            st.execute("CREATE TABLE guild_members (user_id INT NOT NULL PRIMARY KEY, guild_id INT NOT NULL, role VARCHAR(10) NOT NULL, joined_at TIMESTAMP NOT NULL)");
        }
        userDao = new UserDao(dataSource);
        characterDao = new CharacterDao(dataSource);
        walletDao = new WalletDao(dataSource);
        GuildDao guildDao = new GuildDao(dataSource);
        GuildMemberDao guildMemberDao = new GuildMemberDao(dataSource);
        GuildService guildService = new GuildService(guildDao, guildMemberDao, characterDao, walletDao);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/guild/create", new CreateGuildHandler(guildService));
        server.createContext("/api/guild/join", new JoinGuildHandler(guildService));
        server.createContext("/api/guild/leave", new LeaveGuildHandler(guildService));
        server.createContext("/api/guild/kick", new KickMemberHandler(guildService));
        server.createContext("/api/guild/role", new ChangeRoleHandler(guildService));
        server.createContext("/api/guild/transfer-leader", new TransferLeaderHandler(guildService));
        server.createContext("/api/guild/disband", new DisbandGuildHandler(guildService));
        server.createContext("/api/guild/list", new GuildListHandler(guildService));
        server.createContext("/api/guild/info", new GuildInfoHandler(guildService));
        server.createContext("/api/guild/my", new MyGuildHandler(guildService));
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

    private int newPlayer(String name, long gold) throws SQLException {
        int userId = userDao.createGuest("tok-" + name + "-" + System.nanoTime()).id();
        characterDao.create(new Character(userId, name, 0, 1, 1, 1));
        if (gold > 0) walletDao.addGold(userId, gold);
        return userId;
    }

    @Test
    void createWithoutCharacterRejected() throws Exception {
        int userId = userDao.createGuest("tok-nochar").id();
        var res = post("/api/guild/create", new CreateGuildHandler.Req(userId, "Rồng Lửa", "RL", "desc"));
        assertEquals(404, res.statusCode());
    }

    @Test
    void createWithoutEnoughGoldRejected() throws Exception {
        int userId = newPlayer("Poor", 0);
        var res = post("/api/guild/create", new CreateGuildHandler.Req(userId, "Rồng Lửa", "RL", "desc"));
        assertEquals(402, res.statusCode());
    }

    @Test
    void createDeductsGoldAndMakesLeader() throws Exception {
        int userId = newPlayer("Leader1", 20_000);
        var res = post("/api/guild/create", new CreateGuildHandler.Req(userId, "Rồng Lửa", "RL", "desc"));
        assertEquals(201, res.statusCode());

        var wallet = walletDao.find(userId);
        assertEquals(10_000, wallet.gold());

        var my = get("/api/guild/my?userId=" + userId);
        assertEquals(200, my.statusCode());
        JsonObject body = gson.fromJson(my.body(), JsonObject.class);
        assertEquals("Rồng Lửa", body.get("name").getAsString());
    }

    @Test
    void duplicateNameAndTagRejected() throws Exception {
        int u1 = newPlayer("Leader1", 20_000);
        post("/api/guild/create", new CreateGuildHandler.Req(u1, "Rồng Lửa", "RL", null));

        int u2 = newPlayer("Leader2", 20_000);
        var sameName = post("/api/guild/create", new CreateGuildHandler.Req(u2, "Rồng Lửa", "XX", null));
        assertEquals(409, sameName.statusCode());

        int u3 = newPlayer("Leader3", 20_000);
        var sameTag = post("/api/guild/create", new CreateGuildHandler.Req(u3, "Khác", "RL", null));
        assertEquals(409, sameTag.statusCode());
    }

    @Test
    void fullCycle_joinLeaveKickTransferDisband() throws Exception {
        int leader = newPlayer("Leader", 20_000);
        var create = post("/api/guild/create", new CreateGuildHandler.Req(leader, "Rồng Lửa", "RL", "desc"));
        JsonObject guild = gson.fromJson(create.body(), JsonObject.class);
        int guildId = guild.get("id").getAsInt();

        int member = newPlayer("Member", 0);
        var join = post("/api/guild/join", new JoinGuildHandler.Req(member, guildId));
        assertEquals(200, join.statusCode());

        // đã trong guild rồi, join lại bị chặn
        var joinAgain = post("/api/guild/join", new JoinGuildHandler.Req(member, guildId));
        assertEquals(409, joinAgain.statusCode());

        var info = get("/api/guild/info?guildId=" + guildId);
        JsonObject infoBody = gson.fromJson(info.body(), JsonObject.class);
        assertEquals(2, infoBody.get("memberCount").getAsInt());

        // hội trưởng rời khi còn thành viên khác -> bị chặn
        var leaderLeaveTooSoon = post("/api/guild/leave", new LeaveGuildHandler.Req(leader));
        assertEquals(409, leaderLeaveTooSoon.statusCode());

        // thành viên thường không đuổi được ai
        int member2 = newPlayer("Member2", 0);
        post("/api/guild/join", new JoinGuildHandler.Req(member2, guildId));
        var memberKickFails = post("/api/guild/kick", new KickMemberHandler.Req(member, member2));
        assertEquals(403, memberKickFails.statusCode());

        // hội trưởng đuổi được thành viên
        var kick = post("/api/guild/kick", new KickMemberHandler.Req(leader, member2));
        assertEquals(200, kick.statusCode());

        // không đuổi được hội trưởng
        var kickLeaderFails = post("/api/guild/kick", new KickMemberHandler.Req(leader, leader));
        assertTrue(kickLeaderFails.statusCode() == 400 || kickLeaderFails.statusCode() == 403);

        // đổi cấp bậc: thăng member lên OFFICER
        var promote = post("/api/guild/role", new ChangeRoleHandler.Req(leader, member, "OFFICER"));
        assertEquals(200, promote.statusCode());

        // chuyển quyền hội trưởng
        var transfer = post("/api/guild/transfer-leader", new TransferLeaderHandler.Req(leader, member));
        assertEquals(200, transfer.statusCode());

        // hội trưởng cũ giờ chỉ là OFFICER, không giải tán được nữa
        var oldLeaderDisbandFails = post("/api/guild/disband", new DisbandGuildHandler.Req(leader));
        assertEquals(403, oldLeaderDisbandFails.statusCode());

        // hội trưởng cũ giờ rời được luôn (không còn là leader)
        var oldLeaderLeaves = post("/api/guild/leave", new LeaveGuildHandler.Req(leader));
        assertEquals(200, oldLeaderLeaves.statusCode());

        // hội trưởng mới giải tán guild
        var disband = post("/api/guild/disband", new DisbandGuildHandler.Req(member));
        assertEquals(200, disband.statusCode());

        var infoAfterDisband = get("/api/guild/info?guildId=" + guildId);
        assertEquals(404, infoAfterDisband.statusCode());
    }

    @Test
    void soleLeaderLeavingDisbandsGuild() throws Exception {
        int leader = newPlayer("Solo", 20_000);
        var create = post("/api/guild/create", new CreateGuildHandler.Req(leader, "Đơn Độc", "DD", null));
        JsonObject guild = gson.fromJson(create.body(), JsonObject.class);
        int guildId = guild.get("id").getAsInt();

        var leave = post("/api/guild/leave", new LeaveGuildHandler.Req(leader));
        assertEquals(200, leave.statusCode());

        var info = get("/api/guild/info?guildId=" + guildId);
        assertEquals(404, info.statusCode());
    }

    @Test
    void listReturnsGuildsWithMemberCount() throws Exception {
        int leader = newPlayer("Leader", 20_000);
        post("/api/guild/create", new CreateGuildHandler.Req(leader, "Rồng Lửa", "RL", null));

        var list = get("/api/guild/list");
        assertEquals(200, list.statusCode());
        assertTrue(list.body().contains("Rồng Lửa"));
        assertTrue(list.body().contains("\"memberCount\":1"));
    }
}
