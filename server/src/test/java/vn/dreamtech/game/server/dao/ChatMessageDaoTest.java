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

class ChatMessageDaoTest {
    private ChatMessageDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:chat_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE chat_messages (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, sender_name VARCHAR(20) NOT NULL,
                  text VARCHAR(500) NOT NULL, created_at TIMESTAMP NOT NULL
                )
                """);
        }
        this.dao = new ChatMessageDao(dataSource);
    }

    @Test
    void sendThenFindSinceZeroReturnsAll() throws SQLException {
        dao.send(1, "Alice", "chào", System.currentTimeMillis());
        dao.send(1, "Alice", "khoẻ không", System.currentTimeMillis());
        var all = dao.findSince(0, 50);
        assertEquals(2, all.size());
        assertEquals("chào", all.get(0).text());
    }

    @Test
    void findSinceExcludesAlreadySeenMessages() throws SQLException {
        var first = dao.send(1, "Alice", "1", System.currentTimeMillis());
        dao.send(1, "Alice", "2", System.currentTimeMillis());
        var onlyNew = dao.findSince(first.id(), 50);
        assertEquals(1, onlyNew.size());
        assertEquals("2", onlyNew.get(0).text());
    }

    @Test
    void findSinceRespectsLimit() throws SQLException {
        for (int i = 0; i < 10; i++) dao.send(1, "Alice", "msg" + i, System.currentTimeMillis());
        var limited = dao.findSince(0, 3);
        assertEquals(3, limited.size());
        assertTrue(limited.get(0).text().equals("msg0"));
    }
}
