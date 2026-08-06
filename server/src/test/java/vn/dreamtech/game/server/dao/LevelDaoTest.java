package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.model.LevelInfo;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;

class LevelDaoTest {
    private LevelDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:level_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE character_levels (user_id INT NOT NULL PRIMARY KEY, level INT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)");
        }
        this.dao = new LevelDao(dataSource);
    }

    @Test
    void findReturnsLevel1WhenNeverSaved() throws SQLException {
        var info = dao.find(1);
        assertEquals(1, info.level());
        assertEquals(0, info.exp());
    }

    @Test
    void saveThenFindRoundTrips() throws SQLException {
        dao.save(new LevelInfo(1, 5, 40));
        var found = dao.find(1);
        assertEquals(5, found.level());
        assertEquals(40, found.exp());
    }
}
