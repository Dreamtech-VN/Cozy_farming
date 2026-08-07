package vn.dreamtech.game.server.guild.war;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.battle.BattleService;
import vn.dreamtech.game.server.battle.BattleStateView;
import vn.dreamtech.game.server.battle.BattleStatus;
import vn.dreamtech.game.server.battle.engine.MatchFinder;
import vn.dreamtech.game.server.battle.engine.TileBoard;
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
import vn.dreamtech.game.server.guild.GuildException;
import vn.dreamtech.game.server.guild.GuildService;
import vn.dreamtech.game.server.model.Character;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Test GuildWarService trực tiếp (không HTTP). */
class GuildWarServiceTest {
    private GuildWarService guildWarService;
    private GuildService guildService;
    private BattleService battleService;
    private UserDao userDao;
    private CharacterDao characterDao;
    private WalletDao walletDao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:guild_war_service_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
        GuildWarDao warDao = new GuildWarDao(dataSource);
        GuildWarAttemptDao attemptDao = new GuildWarAttemptDao(dataSource);
        battleService = new BattleService(levelDao, walletDao, new ChallengeAttemptDao(dataSource), new TowerRecordDao(dataSource));
        guildService = new GuildService(guildDao, guildMemberDao, characterDao, walletDao);
        guildWarService = new GuildWarService(guildDao, guildMemberDao, warDao, attemptDao, battleService);
    }

    private int newPlayer(String name, long gold) throws SQLException {
        int userId = userDao.createGuest("tok-" + name + "-" + System.nanoTime()).id();
        characterDao.create(new Character(userId, name, 0, 1, 1, 1));
        if (gold > 0) walletDao.addGold(userId, gold);
        return userId;
    }

    @Test
    void declareWithoutGuildRejected() throws SQLException {
        int userId = newPlayer("Solo", 0);
        int target = newPlayer("TargetLeader", 20_000);
        var targetGuild = guildService.create(target, "Địch", "DC", null);

        var e = assertThrows(GuildException.class, () -> guildWarService.declare(userId, targetGuild.id()));
        assertEquals(404, e.status());
    }

    @Test
    void memberCannotDeclareOnlyLeaderOrOfficer() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        int member = newPlayer("Member", 0);
        guildService.join(member, guild.id());
        int targetLeader = newPlayer("TargetLeader", 20_000);
        var targetGuild = guildService.create(targetLeader, "Địch", "DC", null);

        var e = assertThrows(GuildException.class, () -> guildWarService.declare(member, targetGuild.id()));
        assertEquals(403, e.status());
    }

    @Test
    void declareCreatesOngoingWar() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        int targetLeader = newPlayer("TargetLeader", 20_000);
        var targetGuild = guildService.create(targetLeader, "Địch", "DC", null);

        var war = guildWarService.declare(leader, targetGuild.id());
        assertEquals("ONGOING", war.status());
        assertEquals(guild.id(), war.guildA());
        assertEquals(targetGuild.id(), war.guildB());
        assertEquals(0, war.scoreA());
        assertEquals(0, war.scoreB());
    }

    @Test
    void declareAgainstSelfRejected() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);

        var e = assertThrows(GuildException.class, () -> guildWarService.declare(leader, guild.id()));
        assertEquals(400, e.status());
    }

    @Test
    void declareWhileAlreadyAtWarRejected() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        int targetLeader = newPlayer("TargetLeader", 20_000);
        var targetGuild = guildService.create(targetLeader, "Địch", "DC", null);
        guildWarService.declare(leader, targetGuild.id());

        int thirdLeader = newPlayer("ThirdLeader", 20_000);
        var thirdGuild = guildService.create(thirdLeader, "Băng Giá", "BG", null);
        var e = assertThrows(GuildException.class, () -> guildWarService.declare(leader, thirdGuild.id()));
        assertEquals(409, e.status());
    }

    @Test
    void attackWithoutActiveWarRejected() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        guildService.create(leader, "Rồng Lửa", "RL", null);

        var e = assertThrows(GuildException.class, () -> guildWarService.attack(leader));
        assertEquals(404, e.status());
    }

    @Test
    void attackStartsGuildWarBattle() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        int targetLeader = newPlayer("TargetLeader", 20_000);
        var targetGuild = guildService.create(targetLeader, "Địch", "DC", null);
        guildWarService.declare(leader, targetGuild.id());

        BattleStateView view = guildWarService.attack(leader);
        assertEquals(BattleStatus.ONGOING, view.status());
        assertEquals(vn.dreamtech.game.server.battle.BattleMode.GUILD_WAR, view.mode());
        assertEquals(GuildWarConstants.PERSONAL_ENGAGE_HP, view.enemyHp());
    }

    @Test
    void secondAttackSameWarRejected() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        guildService.create(leader, "Rồng Lửa", "RL", null);
        int targetLeader = newPlayer("TargetLeader", 20_000);
        var targetGuild = guildService.create(targetLeader, "Địch", "DC", null);
        guildWarService.declare(leader, targetGuild.id());
        guildWarService.attack(leader);

        var e = assertThrows(GuildException.class, () -> guildWarService.attack(leader));
        assertEquals(409, e.status());
    }

    @Test
    void reportBeforeBattleEndsRejected() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        guildService.create(leader, "Rồng Lửa", "RL", null);
        int targetLeader = newPlayer("TargetLeader", 20_000);
        var targetGuild = guildService.create(targetLeader, "Địch", "DC", null);
        guildWarService.declare(leader, targetGuild.id());
        BattleStateView view = guildWarService.attack(leader);

        var e = assertThrows(GuildException.class, () -> guildWarService.report(leader, view.battleId()));
        assertEquals(409, e.status());
    }

    @Test
    void fullCycle_fightToEndThenReportAppliesDamageToOwnGuildScore() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        int targetLeader = newPlayer("TargetLeader", 20_000);
        var targetGuild = guildService.create(targetLeader, "Địch", "DC", null);
        guildWarService.declare(leader, targetGuild.id());
        BattleStateView view = guildWarService.attack(leader);
        String battleId = view.battleId();

        int guard = 0;
        while (guard++ < 2000) {
            BattleStateView state = battleService.getState(battleId);
            if (state.status() != BattleStatus.ONGOING) break;
            int[] swap = findAnyMatchingSwap(state.board());
            if (swap == null) break;
            battleService.swap(battleId, swap[0], swap[1], swap[2], swap[3]);
        }

        BattleStateView finalState = battleService.getState(battleId);
        var war = guildWarService.report(leader, battleId);
        assertEquals(finalState.totalDamageDealt(), war.scoreA());
        assertEquals(0, war.scoreB());

        var status = guildWarService.status(guild.id());
        assertEquals(war.scoreA(), status.scoreA());

        var e = assertThrows(GuildException.class, () -> guildWarService.report(leader, battleId));
        assertEquals(409, e.status());
    }

    @Test
    void statusWithoutAnyWarRejected() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);

        var e = assertThrows(GuildException.class, () -> guildWarService.status(guild.id()));
        assertEquals(404, e.status());
    }

    @Test
    void myWarReturnsGuildWarStatus() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        int targetLeader = newPlayer("TargetLeader", 20_000);
        var targetGuild = guildService.create(targetLeader, "Địch", "DC", null);
        guildWarService.declare(leader, targetGuild.id());

        var war = guildWarService.myWar(leader);
        assertEquals(guild.id(), war.guildA());
        assertTrue("ONGOING".equals(war.status()));
    }

    @Test
    void adminForceEndResolvesOngoingWarByCurrentScore() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        int targetLeader = newPlayer("TargetLeader", 20_000);
        var targetGuild = guildService.create(targetLeader, "Địch", "DC", null);
        var declared = guildWarService.declare(leader, targetGuild.id());

        var ended = guildWarService.adminForceEnd(declared.warId());
        assertEquals("RESOLVED", ended.status());
        assertEquals(null, ended.winnerGuildId());

        var e = assertThrows(GuildException.class, () -> guildWarService.adminForceEnd(declared.warId()));
        assertEquals(409, e.status());
    }

    @Test
    void adminForceEndPicksHigherScoreAsWinner() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        int targetLeader = newPlayer("TargetLeader", 20_000);
        var targetGuild = guildService.create(targetLeader, "Địch", "DC", null);
        guildWarService.declare(leader, targetGuild.id());
        BattleStateView view = guildWarService.attack(leader);
        String battleId = view.battleId();

        int guard = 0;
        while (guard++ < 2000) {
            BattleStateView state = battleService.getState(battleId);
            if (state.status() != BattleStatus.ONGOING) break;
            int[] swap = findAnyMatchingSwap(state.board());
            if (swap == null) break;
            battleService.swap(battleId, swap[0], swap[1], swap[2], swap[3]);
        }
        var reported = guildWarService.report(leader, battleId);

        var ended = guildWarService.adminForceEnd(reported.warId());
        assertEquals("RESOLVED", ended.status());
        if (reported.scoreA() > reported.scoreB()) {
            assertEquals(guild.id(), ended.winnerGuildId());
        } else if (reported.scoreA() < reported.scoreB()) {
            assertEquals(targetGuild.id(), ended.winnerGuildId());
        }
    }

    @Test
    void adminForceEndUnknownWarRejected() {
        var e = assertThrows(GuildException.class, () -> guildWarService.adminForceEnd("no-such-war"));
        assertEquals(404, e.status());
    }

    private static int[] findAnyMatchingSwap(int[][] grid) {
        int rows = grid.length, cols = grid[0].length;
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                if (c + 1 < cols && wouldMatch(grid, r, c, r, c + 1)) return new int[]{r, c, r, c + 1};
                if (r + 1 < rows && wouldMatch(grid, r, c, r + 1, c)) return new int[]{r, c, r + 1, c};
            }
        }
        return null;
    }

    private static boolean wouldMatch(int[][] grid, int r1, int c1, int r2, int c2) {
        TileBoard board = new TileBoard(grid.length, grid[0].length);
        for (int r = 0; r < grid.length; r++) for (int c = 0; c < grid[0].length; c++) board.set(r, c, grid[r][c]);
        board.swapCells(r1, c1, r2, c2);
        return !MatchFinder.find(board).isEmpty();
    }
}
