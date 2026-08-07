package vn.dreamtech.game.server.guild.boss;

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
import vn.dreamtech.game.server.dao.GuildBossAttemptDao;
import vn.dreamtech.game.server.dao.GuildBossContributionDao;
import vn.dreamtech.game.server.dao.GuildBossCycleDao;
import vn.dreamtech.game.server.dao.GuildDao;
import vn.dreamtech.game.server.dao.GuildMemberDao;
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
import static org.junit.jupiter.api.Assertions.assertTrue;

class GuildBossHttpFlowTest {
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
        ds.setURL("jdbc:h2:mem:guild_boss_http_flow_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
            st.execute("CREATE TABLE guild_boss_cycles (guild_id INT NOT NULL PRIMARY KEY, remaining_hp INT NOT NULL, cycle_started_at TIMESTAMP NOT NULL, cycle_ends_at TIMESTAMP NOT NULL)");
            st.execute("CREATE TABLE guild_boss_attempts (user_id INT NOT NULL PRIMARY KEY, cycle_started_at TIMESTAMP NOT NULL)");
            st.execute("CREATE TABLE guild_boss_contributions (guild_id INT NOT NULL, user_id INT NOT NULL, cycle_started_at TIMESTAMP NOT NULL, total_damage INT NOT NULL DEFAULT 0, PRIMARY KEY (guild_id, user_id, cycle_started_at))");
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
        GuildBossService guildBossService = new GuildBossService(guildMemberDao, new GuildBossCycleDao(dataSource),
                new GuildBossAttemptDao(dataSource), new GuildBossContributionDao(dataSource), battleService, levelDao, walletDao);

        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/api/guild/boss/attack", new AttackHandler(guildBossService));
        server.createContext("/api/guild/boss/report", new ReportBossResultHandler(guildBossService));
        server.createContext("/api/guild/boss/status", new BossStatusHandler(guildBossService));
        server.createContext("/api/guild/boss/attack-status", new AttackStatusHandler(guildBossService));
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
    void attackWithoutGuildRejected() throws Exception {
        int userId = newPlayer("Solo", 0);
        var res = post("/api/guild/boss/attack", new AttackHandler.Req(userId));
        assertEquals(404, res.statusCode());
    }

    @Test
    void attackStatusReflectsGuildMembership() throws Exception {
        int userId = newPlayer("Solo", 0);
        var res = get("/api/guild/boss/attack-status?userId=" + userId);
        assertEquals(200, res.statusCode());
        JsonObject body = gson.fromJson(res.body(), JsonObject.class);
        assertEquals(false, body.get("canAttack").getAsBoolean());
    }

    @Test
    void fullCycle_createGuildThenAttack() throws Exception {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        int guildId = guild.id();

        var attack = post("/api/guild/boss/attack", new AttackHandler.Req(leader));
        assertEquals(201, attack.statusCode());
        JsonObject battle = gson.fromJson(attack.body(), JsonObject.class);
        assertEquals("GUILD_BOSS", battle.get("mode").getAsString());

        var status = get("/api/guild/boss/status?guildId=" + guildId);
        assertEquals(200, status.statusCode());
        assertTrue(status.body().contains("\"remainingHp\":5000"));

        var reportOngoing = post("/api/guild/boss/report", new ReportBossResultHandler.Req(leader, battle.get("battleId").getAsString()));
        assertEquals(409, reportOngoing.statusCode());
    }
}
