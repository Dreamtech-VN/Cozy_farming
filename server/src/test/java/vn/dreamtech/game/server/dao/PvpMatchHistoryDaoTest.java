package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PvpMatchHistoryDaoTest {
    private PvpMatchHistoryDao dao;
    private DataSource dataSource;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:pvp_match_history_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE pvp_match_history (match_id VARCHAR(36) NOT NULL PRIMARY KEY, player_a INT NOT NULL, player_b INT NOT NULL, score_a INT NOT NULL, score_b INT NOT NULL, winner_user_id INT, resolved_at TIMESTAMP NOT NULL)");
        }
        this.dao = new PvpMatchHistoryDao(dataSource);
    }

    @Test
    void recordsMatchWithWinner() throws SQLException {
        dao.record("m1", 1, 2, 100, 50, 1);
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM pvp_match_history WHERE match_id = 'm1'")) {
            assertTrue(rs.next());
            assertEquals(1, rs.getInt("winner_user_id"));
            assertFalse(rs.wasNull());
        }
    }

    @Test
    void recordsDrawWithNullWinner() throws SQLException {
        dao.record("m2", 1, 2, 80, 80, null);
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM pvp_match_history WHERE match_id = 'm2'")) {
            assertTrue(rs.next());
            rs.getInt("winner_user_id");
            assertTrue(rs.wasNull());
        }
    }
}
