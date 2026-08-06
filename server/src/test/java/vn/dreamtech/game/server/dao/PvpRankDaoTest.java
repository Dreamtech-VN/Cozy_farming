package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;

class PvpRankDaoTest {
    private PvpRankDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:pvp_rank_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE pvp_ranks (user_id INT NOT NULL PRIMARY KEY, rating INT NOT NULL DEFAULT 1000, wins INT NOT NULL DEFAULT 0, losses INT NOT NULL DEFAULT 0, draws INT NOT NULL DEFAULT 0)");
        }
        this.dao = new PvpRankDao(dataSource);
    }

    @Test
    void defaultsToBaseRating() throws SQLException {
        var r = dao.find(1);
        assertEquals(1000, r.rating());
        assertEquals(0, r.wins());
    }

    @Test
    void saveAndFind() throws SQLException {
        dao.save(new PvpRankDao.Rank(1, 1020, 1, 0, 0));
        var r = dao.find(1);
        assertEquals(1020, r.rating());
        assertEquals(1, r.wins());
    }

    @Test
    void topByRatingOrdersDescending() throws SQLException {
        dao.save(new PvpRankDao.Rank(1, 1000, 0, 0, 0));
        dao.save(new PvpRankDao.Rank(2, 1200, 0, 0, 0));
        dao.save(new PvpRankDao.Rank(3, 900, 0, 0, 0));
        var top = dao.topByRating(10);
        assertEquals(3, top.size());
        assertEquals(2, top.get(0).userId());
        assertEquals(1, top.get(1).userId());
        assertEquals(3, top.get(2).userId());
    }
}
