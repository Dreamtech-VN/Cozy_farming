package vn.dreamtech.game.server.db;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;

/** Tạo connection pool MySQL — đọc cấu hình từ biến môi trường, không hardcode tài khoản. */
public final class DataSourceProvider {
    public static DataSource create() {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(env("DB_URL", "jdbc:mysql://localhost:3306/game"));
        config.setUsername(env("DB_USER", "root"));
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
