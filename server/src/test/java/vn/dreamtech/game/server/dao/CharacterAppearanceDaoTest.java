package vn.dreamtech.game.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.game.server.model.CosmeticType;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

class CharacterAppearanceDaoTest {
    private CharacterAppearanceDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:appearance_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE character_appearance (
                  user_id INT NOT NULL PRIMARY KEY, eyes_id INT, avatar_id INT, avatar_frame_id INT,
                  title_id INT, emote_id INT, hat_id INT, shirt_id INT, pants_id INT, shoes_id INT,
                  pet_id INT, skin_id INT
                )
                """);
        }
        this.dao = new CharacterAppearanceDao(dataSource);
    }

    @Test
    void defaultsAllNull() throws SQLException {
        var appearance = dao.find(1);
        assertNull(appearance.hatId());
        assertNull(appearance.titleId());
    }

    @Test
    void equipSetsOnlyThatSlot() throws SQLException {
        dao.equip(1, CosmeticType.HAT, 50);
        dao.equip(1, CosmeticType.TITLE, 30);
        var appearance = dao.find(1);
        assertEquals(50, appearance.hatId());
        assertEquals(30, appearance.titleId());
        assertNull(appearance.petId());
    }

    @Test
    void equipNullUnequips() throws SQLException {
        dao.equip(1, CosmeticType.HAT, 50);
        dao.equip(1, CosmeticType.HAT, null);
        assertNull(dao.find(1).hatId());
    }
}
