package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PlayerItemDaoTest {
    private PlayerItemDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:player_item_dao_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE player_items (user_id INT NOT NULL, item_id INT NOT NULL, quantity INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, item_id))");
        }
        this.dao = new PlayerItemDao(dataSource);
    }

    @Test
    void zeroByDefault() throws SQLException {
        assertEquals(0, dao.findQuantity(1, 5));
    }

    @Test
    void addQuantityAccumulates() throws SQLException {
        dao.addQuantity(1, 5, 3);
        dao.addQuantity(1, 5, 4);
        assertEquals(7, dao.findQuantity(1, 5));
    }

    @Test
    void listOwnedOnlyPositiveQuantities() throws SQLException {
        dao.addQuantity(1, 5, 3);
        dao.addQuantity(1, 6, 0);
        var owned = dao.listOwned(1);
        assertEquals(1, owned.size());
        assertEquals(5, owned.get(0).itemId());
        assertTrue(owned.get(0).quantity() == 3);
    }
}
