package vn.dreamtech.game.server.event;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.dao.EventBoardDao;
import vn.dreamtech.game.server.item.ItemException;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class EventBoardServiceTest {
    private EventBoardService service;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:event_board_service_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
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
        service = new EventBoardService(new EventBoardDao(dataSource));
    }

    @Test
    void createRejectsBlankTitle() {
        var e = assertThrows(ItemException.class, () -> service.create("", "d", 1000L, 2000L));
        assertEquals(400, e.status());
    }

    @Test
    void createRejectsEndBeforeStart() {
        var e = assertThrows(ItemException.class, () -> service.create("A", "d", 2000L, 1000L));
        assertEquals(400, e.status());
    }

    @Test
    void createThenAppearsOnBoard() {
        long now = System.currentTimeMillis();
        service.create("Lễ hội", "d", now - 1000, now + 100_000);
        var board = service.board();
        assertEquals(1, board.size());
        assertEquals("Lễ hội", board.get(0).title());
    }

    @Test
    void updateNonexistentRejected() {
        var e = assertThrows(ItemException.class, () -> service.update(999, "A", "d", 1000L, 2000L, true));
        assertEquals(404, e.status());
    }

    @Test
    void deleteRemovesFromBoard() {
        long now = System.currentTimeMillis();
        var event = service.create("Tạm", "d", now - 1000, now + 100_000);
        service.delete(event.id());
        assertTrue(service.board().isEmpty());
    }

    @Test
    void deactivatedEventNotOnBoard() {
        long now = System.currentTimeMillis();
        var event = service.create("Tắt", "d", now - 1000, now + 100_000);
        service.update(event.id(), "Tắt", "d", now - 1000, now + 100_000, false);
        assertTrue(service.board().isEmpty());
    }

    @Test
    void listAllIncludesInactive() {
        long now = System.currentTimeMillis();
        var event = service.create("Tắt", "d", now - 1000, now + 100_000);
        service.update(event.id(), "Tắt", "d", now - 1000, now + 100_000, false);
        assertEquals(1, service.listAll().size());
        assertFalse(service.board().size() == service.listAll().size());
    }
}
