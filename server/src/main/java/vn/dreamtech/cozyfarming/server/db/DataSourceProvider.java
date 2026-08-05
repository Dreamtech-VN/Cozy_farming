package vn.dreamtech.cozyfarming.server.db;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;

/**
 * Tạo connection pool tới MySQL thật. Đọc cấu hình từ biến môi trường (không
 * hardcode tài khoản/mật khẩu trong code) — khớp cách server gốc Lttt tách
 * `database.properties` riêng, nhưng ở đây dùng env var cho hợp với triển
 * khai container/CI hiện đại hơn.
 *
 * Biến môi trường: DB_URL (mặc định jdbc:mysql://localhost:3306/cozy_farming),
 * DB_USER (mặc định root), DB_PASSWORD (mặc định rỗng).
 */
public final class DataSourceProvider {

    public static DataSource create() {
        HikariConfig cfg = new HikariConfig();
        cfg.setJdbcUrl(env("DB_URL", "jdbc:mysql://localhost:3306/cozy_farming"));
        cfg.setUsername(env("DB_USER", "root"));
        cfg.setPassword(env("DB_PASSWORD", ""));
        cfg.setMaximumPoolSize(Integer.parseInt(env("DB_POOL_SIZE", "10")));
        cfg.setPoolName("cozy-farming-pool");
        return new HikariDataSource(cfg);
    }

    private static String env(String key, String fallback) {
        String v = System.getenv(key);
        return (v == null || v.isBlank()) ? fallback : v;
    }

    private DataSourceProvider() {
    }
}
