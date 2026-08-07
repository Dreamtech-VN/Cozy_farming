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

class TowerRecordDaoTest {
    private TowerRecordDao dao;

    @BeforeEach
    void setUp() throws SQLException {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:tower_record_test_" + System.nanoTime() + ";DB_CLOSE_DELAY=-1;MODE=MySQL");
        DataSource dataSource = ds;
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            st.execute("CREATE TABLE tower_records (user_id INT NOT NULL, tower_id INT NOT NULL, best_floor INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id, tower_id))");
        }
        this.dao = new TowerRecordDao(dataSource);
    }

    @Test
    void emptyByDefault() throws SQLException {
        assertTrue(dao.listByTower(1).isEmpty());
    }

    @Test
    void firstUpdateCreatesRecord() throws SQLException {
        dao.updateBestFloorIfHigher(1, 1, 5);
        var records = dao.listByTower(1);
        assertEquals(1, records.size());
        assertEquals(5, records.get(0).bestFloor());
    }

    @Test
    void higherFloorOverwritesRecord() throws SQLException {
        dao.updateBestFloorIfHigher(1, 1, 5);
        dao.updateBestFloorIfHigher(1, 1, 8);
        var records = dao.listByTower(1);
        assertEquals(1, records.size());
        assertEquals(8, records.get(0).bestFloor());
    }

    @Test
    void lowerFloorDoesNotOverwriteRecord() throws SQLException {
        dao.updateBestFloorIfHigher(1, 1, 8);
        dao.updateBestFloorIfHigher(1, 1, 3);
        var records = dao.listByTower(1);
        assertEquals(8, records.get(0).bestFloor());
    }

    @Test
    void recordsAreScopedPerTower() throws SQLException {
        dao.updateBestFloorIfHigher(1, 1, 5);
        dao.updateBestFloorIfHigher(1, 2, 9);
        assertEquals(5, dao.listByTower(1).get(0).bestFloor());
        assertEquals(9, dao.listByTower(2).get(0).bestFloor());
    }

    @Test
    void resetRecordSetsBestFloorToZero() throws SQLException {
        dao.updateBestFloorIfHigher(1, 1, 8);
        dao.resetRecord(1, 1);
        var records = dao.listByTower(1);
        assertEquals(1, records.size());
        assertEquals(0, records.get(0).bestFloor());
    }

    @Test
    void resetRecordOnUnknownUserIsNoop() throws SQLException {
        dao.resetRecord(99, 1);
        var records = dao.listByTower(1);
        assertEquals(1, records.size());
        assertEquals(0, records.get(0).bestFloor());
    }

    @Test
    void listByTowerOrdersDescendingByBestFloor() throws SQLException {
        dao.updateBestFloorIfHigher(1, 1, 3);
        dao.updateBestFloorIfHigher(2, 1, 10);
        dao.updateBestFloorIfHigher(3, 1, 6);
        var records = dao.listByTower(1);
        assertEquals(3, records.size());
        assertEquals(2, records.get(0).userId());
        assertEquals(3, records.get(1).userId());
        assertEquals(1, records.get(2).userId());
    }
}
