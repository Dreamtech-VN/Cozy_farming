package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.item.RewardEntry;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class MailDaoTest {
    private MailDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:mail_dao_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE mails (
                  id VARCHAR(36) NOT NULL PRIMARY KEY, user_id INT NOT NULL, title VARCHAR(100) NOT NULL,
                  body VARCHAR(1000), rewards VARCHAR(2000) NOT NULL, source VARCHAR(20) NOT NULL,
                  created_at TIMESTAMP NOT NULL, expires_at TIMESTAMP, read_at TIMESTAMP, claimed_at TIMESTAMP
                )
                """);
        }
        this.dao = new MailDao(dataSource);
    }

    @Test
    void createAndFind() throws SQLException {
        var mail = dao.create(1, "Chào mừng", "Cảm ơn đã chơi", List.of(new RewardEntry(1, 100)), "ADMIN", 1000L, null);
        var found = dao.find(mail.id());
        assertTrue(found.isPresent());
        assertEquals("Chào mừng", found.get().title());
        assertEquals(1, found.get().rewards().size());
        assertEquals(100, found.get().rewards().get(0).quantity());
        assertNull(found.get().readAt());
        assertNull(found.get().claimedAt());
    }

    @Test
    void listByUserOrderedByCreatedAtDesc() throws SQLException {
        dao.create(1, "Cũ", null, List.of(), "ADMIN", 1000L, null);
        dao.create(1, "Mới", null, List.of(), "ADMIN", 2000L, null);
        var list = dao.listByUser(1);
        assertEquals(2, list.size());
        assertEquals("Mới", list.get(0).title());
    }

    @Test
    void listByUserExcludesOtherUsers() throws SQLException {
        dao.create(1, "Của 1", null, List.of(), "ADMIN", 1000L, null);
        dao.create(2, "Của 2", null, List.of(), "ADMIN", 1000L, null);
        assertEquals(1, dao.listByUser(1).size());
    }

    @Test
    void markReadSetsTimestampOnlyOnce() throws SQLException {
        var mail = dao.create(1, "Thư", null, List.of(), "ADMIN", 1000L, null);
        dao.markRead(mail.id(), 5000L);
        var found = dao.find(mail.id()).orElseThrow();
        assertEquals(5000L, found.readAt());

        dao.markRead(mail.id(), 9999L);
        var foundAgain = dao.find(mail.id()).orElseThrow();
        assertEquals(5000L, foundAgain.readAt());
    }

    @Test
    void markClaimedSetsTimestamp() throws SQLException {
        var mail = dao.create(1, "Thư", null, List.of(), "ADMIN", 1000L, null);
        dao.markClaimed(mail.id(), 8000L);
        assertEquals(8000L, dao.find(mail.id()).orElseThrow().claimedAt());
    }

    @Test
    void expiresAtPersistedWhenSet() throws SQLException {
        var mail = dao.create(1, "Thư có hạn", null, List.of(), "GIFTCODE", 1000L, 2000L);
        assertNotNull(dao.find(mail.id()).orElseThrow().expiresAt());
        assertEquals(2000L, dao.find(mail.id()).orElseThrow().expiresAt());
    }
}
