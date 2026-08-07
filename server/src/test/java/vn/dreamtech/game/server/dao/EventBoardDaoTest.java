package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class EventBoardDaoTest {
    private EventBoardDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:event_board_dao_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE event_board (
                  id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(100) NOT NULL, description VARCHAR(1000),
                  start_at TIMESTAMP NOT NULL, end_at TIMESTAMP NOT NULL, active BOOLEAN NOT NULL DEFAULT TRUE,
                  created_at TIMESTAMP NOT NULL
                )
                """);
        }
        this.dao = new EventBoardDao(dataSource);
    }

    @Test
    void createAndFind() throws SQLException {
        var event = dao.create("Lễ hội mùa hè", "Mô tả", 1000L, 5000L);
        var found = dao.find(event.id()).orElseThrow();
        assertEquals("Lễ hội mùa hè", found.title());
        assertTrue(found.active());
    }

    @Test
    void findActiveExcludesEnded() throws SQLException {
        dao.create("Đã qua", null, 1000L, 2000L);
        dao.create("Đang diễn ra", null, 1000L, 9000L);
        var active = dao.findActive(3000L);
        assertEquals(1, active.size());
        assertEquals("Đang diễn ra", active.get(0).title());
    }

    @Test
    void findActiveExcludesInactive() throws SQLException {
        var event = dao.create("Tắt", null, 1000L, 9000L);
        dao.update(event.id(), "Tắt", null, 1000L, 9000L, false);
        assertTrue(dao.findActive(3000L).isEmpty());
    }

    @Test
    void deleteRemoves() throws SQLException {
        var event = dao.create("X", null, 1000L, 2000L);
        dao.delete(event.id());
        assertTrue(dao.find(event.id()).isEmpty());
    }

    @Test
    void findAllIncludesInactiveAndEnded() throws SQLException {
        dao.create("A", null, 1000L, 2000L);
        var b = dao.create("B", null, 1000L, 2000L);
        dao.update(b.id(), "B", null, 1000L, 2000L, false);
        assertEquals(2, dao.findAll().size());
        assertFalse(dao.findActive(3000L).size() == 2);
    }
}
