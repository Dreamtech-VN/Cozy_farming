package vn.dreamtech.cozyfarming.server.dao;

import org.h2.jdbcx.JdbcDataSource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import vn.dreamtech.cozyfarming.server.model.Item;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Test DAO bằng H2 nhúng (mô phỏng schema thật `items` từ avatar_2x.sql) —
 * chưa có server MySQL thật trong môi trường này. Khi triển khai thật, đổi
 * DataSource sang {@link vn.dreamtech.cozyfarming.server.db.DataSourceProvider}.
 */
class ItemDaoTest {
    private DataSource dataSource;
    private ItemDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:items_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        this.dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("""
                CREATE TABLE items (
                  id INT NOT NULL PRIMARY KEY,
                  coin INT NOT NULL,
                  gold SMALLINT NOT NULL,
                  type SMALLINT NOT NULL,
                  icon SMALLINT NOT NULL,
                  name VARCHAR(200),
                  sell TINYINT,
                  expired_day TINYINT NOT NULL DEFAULT 0,
                  zorder TINYINT,
                  gender TINYINT,
                  level TINYINT,
                  animation CLOB DEFAULT '[]'
                )
                """);
            // dữ liệu thật lấy từ avatar_2x.sql: id 1=tóc nam "dựng đứng", 2=áo nam "sơ mi", 3=quần nam "short"
            st.execute("INSERT INTO items VALUES (1, 10000, -1, -1, 1, 'dựng đứng', 2, 0, 50, 1, 0, '[]')");
            st.execute("INSERT INTO items VALUES (2, 1000, -1, -1, 327, 'sơ mi', 1, 0, 20, 1, 0, '[]')");
            st.execute("INSERT INTO items VALUES (3, 1000, -1, -1, 328, 'short', 1, 0, 10, 1, 0, '[]')");
            st.execute("INSERT INTO items VALUES (21, 8000, -1, -1, 40, 'búp bê', 1, 0, 50, 2, 0, '[]')");
        }
        this.dao = new ItemDao(dataSource);
    }

    @Test
    void findByIdReturnsItem() throws SQLException {
        Optional<Item> item = dao.findById(1);
        assertTrue(item.isPresent());
        assertEquals("dựng đứng", item.get().name());
        assertEquals(50, item.get().zorder());
    }

    @Test
    void findByIdMissingReturnsEmpty() throws SQLException {
        assertTrue(dao.findById(9999).isEmpty());
    }

    @Test
    void findByZorderAndGenderFiltersCorrectly() throws SQLException {
        // tóc (zorder 50) nam: chỉ lấy id=1, không lấy id=21 (nữ)
        List<Item> hairMale = dao.findByZorderAndGender(50, 1);
        assertEquals(1, hairMale.size());
        assertEquals(1, hairMale.get(0).id());
    }
}
