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

/** Test DAO tình bạn bằng H2 nhúng — trọng tâm: chuẩn hoá thứ tự (a,b) không phụ thuộc ai gọi trước. */
class FriendshipDaoTest {
    private FriendshipDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:friendship_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE friendships (
                  user_id_a INT NOT NULL, user_id_b INT NOT NULL, intimacy_points INT NOT NULL DEFAULT 0,
                  last_gift_at TIMESTAMP, created_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id_a, user_id_b)
                )
                """);
        }
        this.dao = new FriendshipDao(dataSource);
    }

    @Test
    void createThenAreFriendsRegardlessOfArgOrder() throws SQLException {
        dao.create(5, 2, System.currentTimeMillis());
        assertTrue(dao.areFriends(5, 2));
        assertTrue(dao.areFriends(2, 5));
    }

    @Test
    void listFriendIdsWorksBothDirections() throws SQLException {
        dao.create(1, 2, System.currentTimeMillis());
        dao.create(3, 1, System.currentTimeMillis());
        var friendsOf1 = dao.listFriendIds(1);
        assertEquals(2, friendsOf1.size());
        assertTrue(friendsOf1.contains(2));
        assertTrue(friendsOf1.contains(3));
    }

    @Test
    void addIntimacyAccumulatesRegardlessOfArgOrder() throws SQLException {
        dao.create(1, 2, System.currentTimeMillis());
        dao.addIntimacy(1, 2, 10, System.currentTimeMillis());
        dao.addIntimacy(2, 1, 5, System.currentTimeMillis());
        assertEquals(15, dao.find(1, 2).orElseThrow().intimacyPoints());
    }

    @Test
    void spendIntimacyDeducts() throws SQLException {
        dao.create(1, 2, System.currentTimeMillis());
        dao.addIntimacy(1, 2, 100, System.currentTimeMillis());
        dao.spendIntimacy(1, 2, 40);
        assertEquals(60, dao.find(1, 2).orElseThrow().intimacyPoints());
    }

    @Test
    void removeDropsFriendship() throws SQLException {
        dao.create(1, 2, System.currentTimeMillis());
        dao.remove(2, 1);
        assertFalse(dao.areFriends(1, 2));
    }
}
