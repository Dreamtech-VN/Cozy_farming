package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.model.Character;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class CharacterDaoTest {
    private CharacterDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:characters_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE characters (
                  user_id INT NOT NULL PRIMARY KEY, name VARCHAR(20) NOT NULL UNIQUE, gender TINYINT NOT NULL,
                  hair_id INT NOT NULL, top_id INT NOT NULL, bottom_id INT NOT NULL, created_at TIMESTAMP NOT NULL
                )
                """);
        }
        this.dao = new CharacterDao(dataSource);
    }

    @Test
    void createThenFindByUserId() throws SQLException {
        dao.create(new Character(1, "Alice", 1, 3, 5, 7));
        var found = dao.findByUserId(1);
        assertTrue(found.isPresent());
        assertEquals("Alice", found.get().name());
        assertEquals(1, found.get().gender());
    }

    @Test
    void nameTakenDetectsExistingName() throws SQLException {
        dao.create(new Character(1, "Alice", 0, 1, 1, 1));
        assertTrue(dao.nameTaken("Alice"));
        assertFalse(dao.nameTaken("Bob"));
    }

    @Test
    void updateOutfitChangesOnlyOutfitFields() throws SQLException {
        dao.create(new Character(1, "Alice", 0, 1, 1, 1));
        dao.updateOutfit(1, 9, 8, 7);
        var found = dao.findByUserId(1).orElseThrow();
        assertEquals(9, found.hairId());
        assertEquals(8, found.topId());
        assertEquals(7, found.bottomId());
        assertEquals("Alice", found.name());
    }
}
