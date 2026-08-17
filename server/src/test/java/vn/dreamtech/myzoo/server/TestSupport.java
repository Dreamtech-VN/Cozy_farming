package vn.dreamtech.myzoo.server;

import org.h2.jdbcx.JdbcDataSource;
import vn.dreamtech.myzoo.server.db.SchemaInit;
import vn.dreamtech.myzoo.server.time.TimeSource;

import javax.sql.DataSource;
import java.util.concurrent.atomic.AtomicLong;

public final class TestSupport {
    private static final AtomicLong SEQ = new AtomicLong();

    public static DataSource newDb() {
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:myzoo_test_" + SEQ.incrementAndGet() + ";MODE=MySQL;DB_CLOSE_DELAY=-1");
        ds.setUser("sa");
        SchemaInit.run(ds);
        return ds;
    }

    public static final class FakeTime implements TimeSource {
        public long now = 1_700_000_000_000L;

        @Override
        public long now() {
            return now;
        }

        public void advance(long ms) {
            now += ms;
        }
    }

    private TestSupport() {
    }
}
