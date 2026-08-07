package vn.dreamtech.game.server.guild.war;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpServer;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.ChallengeAttemptDao;
import vn.dreamtech.game.server.dao.GuildDao;
import vn.dreamtech.game.server.dao.GuildMemberDao;
import vn.dreamtech.game.server.dao.GuildWarAttemptDao;
import vn.dreamtech.game.server.dao.GuildWarDao;
import vn.dreamtech.game.server.dao.LevelDao;
import vn.dreamtech.game.server.dao.TowerRecordDao;
import vn.dreamtech.game.server.dao.UserDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.guild.GuildService;
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

/** Test nối dây HTTP thật cho các endpoint /api/guild/war/* — logic chi tiết đã kiểm ở GuildWarServiceTest. */
class GuildWarHttpFlowTest {
    private HttpServer server;
    private int port;
    private UserDao userDao;
    private CharacterDao characterDao;
    private WalletDao walletDao;
    private GuildService guildService;
    private final Gson gson = new Gson();
    private final HttpClient http = HttpClient.newHttpClient();

    @BeforeEach
    void start() throws Exception {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:guild_war_http_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
            st.execute("CREATE TABLE guilds (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(30) NOT NULL UNIQUE, tag VARCHAR(6) NOT NULL UNIQUE, description VARCHAR(200), leader_user_id INT NOT NULL, created_at TIMESTAMP NOT NULL)");
            st.execute("CREATE TABLE guild_members (user_id INT NOT NULL PRIMARY KEY, guild_id INT NOT NULL, role VARCHAR(10) NOT NULL, joined_at TIMESTAMP NOT NULL)");
            st.execute("CREATE TABLE guild_wars (id VARCHAR(36) NOT NULL PRIMARY KEY, guild_a INT NOT NULL, guild_b INT NOT NULL, score_a INT NOT NULL DEFAULT 0, score_b INT NOT NULL DEFAULT 0, status VARCHAR(10) NOT NULL, started_at TIMESTAMP NOT NULL, ends_at TIMESTAMP NOT NULL, winner_guild_id INT)");
            st.execute("CREATE TABLE guild_war_attempts (user_id INT NOT NULL, war_id VARCHAR(36) NOT NULL, attempted_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, war_id))");
            st.execute("CREATE TABLE challenge_attempts (user_id INT NOT NULL, challenge_type VARCHAR(10) NOT NULL, last_completed_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, challenge_type))");
        }
        userDao = new UserDao(dataSource);
        characterDao = new CharacterDao(dataSource);
        walletDao = new WalletDao(dataSource);
        LevelDao levelDao = new LevelDao(dataSource);
        GuildDao guildDao = new GuildDao(dataSource);
        GuildMemberDao guildMemberDao = new GuildMemberDao(dataSource);
        BattleService battleService = new BattleService(levelDao, walletDao, new ChallengeAttemptDao(dataSource), new TowerRecordDao(dataSource));
        guildService = new GuildService(guildDao, guildMemberDao, characterDao, walletDao);
        GuildWarService guildWarService = new GuildWarService(guildDao, guildMemberDao, new GuildWarDao(dataSource),
                new GuildWarAttemptDao(dataSource), battleService);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/guild/war/declare", new DeclareWarHandler(guildWarService));
        server.createContext("/api/guild/war/attack", new AttackHandler(guildWarService));
        server.createContext("/api/guild/war/report", new ReportWarResultHandler(guildWarService));
        server.createContext("/api/guild/war/status", new WarStatusHandler(guildWarService));
        server.createContext("/api/guild/war/my", new MyWarHandler(guildWarService));
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
    void declareWithoutGuildRejected() throws Exception {
        int userId = newPlayer("Solo", 0);
        int target = newPlayer("TargetLeader", 20_000);
        var targetGuild = guildService.create(target, "Địch", "DC", null);

        var res = post("/api/guild/war/declare", new DeclareWarHandler.Req(userId, targetGuild.id()));
        assertEquals(404, res.statusCode());
    }

    @Test
    void attackWithoutActiveWarRejected() throws Exception {
        int leader = newPlayer("Leader", 20_000);
        guildService.create(leader, "Rồng Lửa", "RL", null);

        var res = post("/api/guild/war/attack", new AttackHandler.Req(leader));
        assertEquals(404, res.statusCode());
    }

    @Test
    void fullCycle_declareThenAttackThenStatus() throws Exception {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        int targetLeader = newPlayer("TargetLeader", 20_000);
        var targetGuild = guildService.create(targetLeader, "Địch", "DC", null);

        var declare = post("/api/guild/war/declare", new DeclareWarHandler.Req(leader, targetGuild.id()));
        assertEquals(201, declare.statusCode());
        JsonObject war = gson.fromJson(declare.body(), JsonObject.class);
        assertEquals("ONGOING", war.get("status").getAsString());

        var attack = post("/api/guild/war/attack", new AttackHandler.Req(leader));
        assertEquals(201, attack.statusCode());
        JsonObject battle = gson.fromJson(attack.body(), JsonObject.class);
        assertEquals("GUILD_WAR", battle.get("mode").getAsString());

        var status = get("/api/guild/war/status?guildId=" + guild.id());
        assertEquals(200, status.statusCode());

        var reportOngoing = post("/api/guild/war/report", new ReportWarResultHandler.Req(leader, battle.get("battleId").getAsString()));
        assertEquals(409, reportOngoing.statusCode());

        var my = get("/api/guild/war/my?userId=" + leader);
        assertEquals(200, my.statusCode());
    }
}
