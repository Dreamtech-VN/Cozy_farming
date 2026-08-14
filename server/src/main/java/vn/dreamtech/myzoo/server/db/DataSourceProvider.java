package vn.dreamtech.myzoo.server.db;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;

public final class DataSourceProvider {
    // Mặc định H2 file-based để chạy ngay không cần cài DB; production đặt DB_URL trỏ MySQL/PostgreSQL.
    public static DataSource create() {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(env("DB_URL", "jdbc:h2:file:./myzoo-data;MODE=MySQL;DB_CLOSE_DELAY=-1"));
        config.setUsername(env("DB_USER", "sa"));
        config.setPassword(env("DB_PASSWORD", ""));
        config.setMaximumPoolSize(Integer.parseInt(env("DB_POOL_SIZE", "10")));
        return new HikariDataSource(config);
    }

    private static String env(String key, String fallback) {
        String value = System.getenv(key);
        return value == null || value.isBlank() ? fallback : value;
    }

    private DataSourceProvider() {
    }
}
