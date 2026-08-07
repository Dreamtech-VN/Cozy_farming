package vn.dreamtech.game.server.guild.boss;

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
import vn.dreamtech.game.server.dao.GuildBossAttemptDao;
import vn.dreamtech.game.server.dao.GuildBossContributionDao;
import vn.dreamtech.game.server.dao.GuildBossCycleDao;
import vn.dreamtech.game.server.dao.GuildDao;
import vn.dreamtech.game.server.dao.GuildMemberDao;
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
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;

/** Test GuildBossService trực tiếp (không HTTP — nối dây HTTP đã kiểm ở các *FlowTest khác trong dự án). */
class GuildBossServiceTest {
    private GuildBossService guildBossService;
    private GuildService guildService;
    private BattleService battleService;
    private UserDao userDao;
    private CharacterDao characterDao;
    private WalletDao walletDao;
    private GuildBossContributionDao contributionDao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:guild_boss_service_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
        GuildBossCycleDao cycleDao = new GuildBossCycleDao(dataSource);
        GuildBossAttemptDao attemptDao = new GuildBossAttemptDao(dataSource);
        contributionDao = new GuildBossContributionDao(dataSource);
        battleService = new BattleService(levelDao, walletDao, new ChallengeAttemptDao(dataSource), new TowerRecordDao(dataSource));
        guildService = new GuildService(guildDao, guildMemberDao, characterDao, walletDao);
        guildBossService = new GuildBossService(guildMemberDao, cycleDao, attemptDao, contributionDao, battleService, levelDao, walletDao);
    }

    private int newPlayer(String name, long gold) throws SQLException {
        int userId = userDao.createGuest("tok-" + name + "-" + System.nanoTime()).id();
        characterDao.create(new Character(userId, name, 0, 1, 1, 1));
        if (gold > 0) walletDao.addGold(userId, gold);
        return userId;
    }

    @Test
    void attackWithoutGuildRejected() throws SQLException {
        int userId = newPlayer("Solo", 0);
        var e = assertThrows(GuildException.class, () -> guildBossService.attack(userId));
        assertEquals(404, e.status());
    }

    @Test
    void attackStatusWithoutGuildFalse() throws SQLException {
        int userId = newPlayer("Solo", 0);
        var status = guildBossService.attackStatus(userId);
        assertFalse(status.canAttack());
    }

    @Test
    void attackStartsGuildBossBattle() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        guildService.create(leader, "Rồng Lửa", "RL", null);

        BattleStateView view = guildBossService.attack(leader);
        assertEquals(BattleStatus.ONGOING, view.status());
        assertEquals(vn.dreamtech.game.server.battle.BattleMode.GUILD_BOSS, view.mode());
        assertEquals(GuildBossConstants.PERSONAL_ENGAGE_HP, view.enemyHp());
    }

    @Test
    void secondAttackSameCycleRejected() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        guildService.create(leader, "Rồng Lửa", "RL", null);
        guildBossService.attack(leader);

        var e = assertThrows(GuildException.class, () -> guildBossService.attack(leader));
        assertEquals(409, e.status());
    }

    @Test
    void statusReturnsFullPoolInitially() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);

        var status = guildBossService.status(guild.id());
        assertEquals(GuildBossConstants.POOL_HP, status.remainingHp());
        assertEquals(GuildBossConstants.POOL_HP, status.poolMaxHp());
    }

    @Test
    void reportBeforeBattleEndsRejected() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        guildService.create(leader, "Rồng Lửa", "RL", null);
        BattleStateView view = guildBossService.attack(leader);

        var e = assertThrows(GuildException.class, () -> guildBossService.report(leader, view.battleId()));
        assertEquals(409, e.status());
    }

    @Test
    void reportByWrongUserRejected() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        guildService.create(leader, "Rồng Lửa", "RL", null);
        BattleStateView view = guildBossService.attack(leader);
        int other = newPlayer("Other", 0);

        var e = assertThrows(GuildException.class, () -> guildBossService.report(other, view.battleId()));
        assertEquals(403, e.status());
    }

    @Test
    void fullCycle_fightToEndThenReportAppliesDamageAndReward() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        BattleStateView view = guildBossService.attack(leader);
        String battleId = view.battleId();
        long goldBeforeReport = walletDao.find(leader).gold();

        int guard = 0;
        while (guard++ < 2000) {
            BattleStateView state = battleService.getState(battleId);
            if (state.status() != BattleStatus.ONGOING) break;
            int[] swap = findAnyMatchingSwap(state.board());
            if (swap == null) break;
            battleService.swap(battleId, swap[0], swap[1], swap[2], swap[3]);
        }

        BattleStateView finalState = battleService.getState(battleId);
        var report = guildBossService.report(leader, battleId);
        assertEquals(finalState.totalDamageDealt(), report.damageApplied());
        assertEquals(GuildBossConstants.POOL_HP - report.damageApplied(), report.remainingHp());

        var status = guildBossService.status(guild.id());
        assertEquals(report.remainingHp(), status.remainingHp());

        if (report.damageApplied() > 0) {
            assertEquals(goldBeforeReport + GuildBossConstants.REWARD_GOLD, walletDao.find(leader).gold());
        }

        // báo cáo lại cùng battleId lần 2 -> bị chặn
        var e = assertThrows(GuildException.class, () -> guildBossService.report(leader, battleId));
        assertEquals(409, e.status());
    }

    @Test
    void leaderboardEmptyInitially() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);

        var leaderboard = guildBossService.leaderboard(guild.id());
        assertEquals(0, leaderboard.size());
    }

    @Test
    void leaderboardOrderedByDamageDescending() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        int member = newPlayer("Member", 0);
        guildService.join(member, guild.id());

        var status = guildBossService.status(guild.id());
        contributionDao.addDamage(guild.id(), leader, status.cycleStartedAt(), 100);
        contributionDao.addDamage(guild.id(), member, status.cycleStartedAt(), 250);

        var leaderboard = guildBossService.leaderboard(guild.id());
        assertEquals(2, leaderboard.size());
        assertEquals(1, leaderboard.get(0).rank());
        assertEquals(member, leaderboard.get(0).userId());
        assertEquals(250, leaderboard.get(0).totalDamage());
        assertEquals(2, leaderboard.get(1).rank());
        assertEquals(leader, leaderboard.get(1).userId());
    }

    @Test
    void reportAddsToLeaderboard() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        BattleStateView view = guildBossService.attack(leader);
        String battleId = view.battleId();

        int guard = 0;
        while (guard++ < 2000) {
            BattleStateView state = battleService.getState(battleId);
            if (state.status() != BattleStatus.ONGOING) break;
            int[] swap = findAnyMatchingSwap(state.board());
            if (swap == null) break;
            battleService.swap(battleId, swap[0], swap[1], swap[2], swap[3]);
        }
        var report = guildBossService.report(leader, battleId);

        var leaderboard = guildBossService.leaderboard(guild.id());
        if (report.damageApplied() > 0) {
            assertEquals(1, leaderboard.size());
            assertEquals(leader, leaderboard.get(0).userId());
            assertEquals(report.damageApplied(), leaderboard.get(0).totalDamage());
        } else {
            assertEquals(0, leaderboard.size());
        }
    }

    @Test
    void adminForceResetStartsFreshCycleWithFullHp() throws SQLException {
        int leader = newPlayer("Leader", 20_000);
        var guild = guildService.create(leader, "Rồng Lửa", "RL", null);
        BattleStateView view = guildBossService.attack(leader);
        String battleId = view.battleId();

        int guard = 0;
        while (guard++ < 2000) {
            BattleStateView state = battleService.getState(battleId);
            if (state.status() != BattleStatus.ONGOING) break;
            int[] swap = findAnyMatchingSwap(state.board());
            if (swap == null) break;
            battleService.swap(battleId, swap[0], swap[1], swap[2], swap[3]);
        }
        var report = guildBossService.report(leader, battleId);
        if (report.damageApplied() > 0) {
            assertEquals(GuildBossConstants.POOL_HP - report.damageApplied(), guildBossService.status(guild.id()).remainingHp());
        }

        var reset = guildBossService.adminForceReset(guild.id());
        assertEquals(GuildBossConstants.POOL_HP, reset.remainingHp());

        // chu kỳ mới -> người vừa đánh xong được đánh lại ngay
        BattleStateView again = guildBossService.attack(leader);
        assertEquals(BattleStatus.ONGOING, again.status());
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
