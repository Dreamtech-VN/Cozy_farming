package vn.dreamtech.myzoo.server.db;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public final class SchemaInit {
    public static void run(DataSource dataSource) {
        String[] ddl = {
                """
                CREATE TABLE IF NOT EXISTS players (
                  id INT AUTO_INCREMENT PRIMARY KEY,
                  guest_token VARCHAR(64) NOT NULL UNIQUE,
                  name VARCHAR(20) UNIQUE,
                  farm_xp INT NOT NULL DEFAULT 0,
                  zoo_xp INT NOT NULL DEFAULT 0,
                  created_at TIMESTAMP NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS wallets (
                  player_id INT NOT NULL,
                  currency VARCHAR(10) NOT NULL,
                  balance BIGINT NOT NULL DEFAULT 0,
                  PRIMARY KEY (player_id, currency)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS economy_ledger (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY,
                  player_id INT NOT NULL,
                  currency VARCHAR(10) NOT NULL,
                  amount BIGINT NOT NULL,
                  balance_after BIGINT NOT NULL,
                  reason VARCHAR(30) NOT NULL,
                  ref_type VARCHAR(20),
                  ref_id VARCHAR(40),
                  created_at TIMESTAMP NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS idempotency (
                  request_id VARCHAR(64) PRIMARY KEY,
                  player_id INT NOT NULL,
                  response TEXT NOT NULL,
                  created_at TIMESTAMP NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS farm_plots (
                  player_id INT NOT NULL,
                  plot_index INT NOT NULL,
                  crop_id VARCHAR(20),
                  planted_at TIMESTAMP,
                  ready_at TIMESTAMP,
                  PRIMARY KEY (player_id, plot_index)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS farm_inventory (
                  player_id INT NOT NULL,
                  food_id VARCHAR(20) NOT NULL,
                  quantity INT NOT NULL DEFAULT 0,
                  PRIMARY KEY (player_id, food_id)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS habitats (
                  id INT AUTO_INCREMENT PRIMARY KEY,
                  player_id INT NOT NULL,
                  type_id VARCHAR(20) NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS zoo_animals (
                  id INT AUTO_INCREMENT PRIMARY KEY,
                  player_id INT NOT NULL,
                  habitat_id INT NOT NULL,
                  species_id VARCHAR(20) NOT NULL,
                  last_fed_at TIMESTAMP
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS zoo_warehouse (
                  player_id INT NOT NULL,
                  food_id VARCHAR(20) NOT NULL,
                  quantity INT NOT NULL DEFAULT 0,
                  PRIMARY KEY (player_id, food_id)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS zoos (
                  player_id INT PRIMARY KEY,
                  is_open BOOLEAN NOT NULL DEFAULT FALSE,
                  last_collect_at TIMESTAMP
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS minigame_sessions (
                  id VARCHAR(36) PRIMARY KEY,
                  player_id INT NOT NULL,
                  seed BIGINT NOT NULL,
                  moves_allowed INT NOT NULL,
                  max_lines INT NOT NULL,
                  created_at TIMESTAMP NOT NULL,
                  finished BOOLEAN NOT NULL DEFAULT FALSE,
                  lines_made INT,
                  reward BIGINT
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS mission_progress (
                  player_id INT NOT NULL,
                  mission_id VARCHAR(30) NOT NULL,
                  day_key VARCHAR(10) NOT NULL,
                  progress INT NOT NULL DEFAULT 0,
                  claimed BOOLEAN NOT NULL DEFAULT FALSE,
                  PRIMARY KEY (player_id, mission_id, day_key)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS daily_checkin (
                  player_id INT NOT NULL,
                  day_key VARCHAR(10) NOT NULL,
                  streak INT NOT NULL,
                  PRIMARY KEY (player_id, day_key)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS accounts (
                  id INT AUTO_INCREMENT PRIMARY KEY,
                  username VARCHAR(32) NOT NULL UNIQUE,
                  password_hash VARCHAR(64) NOT NULL,
                  password_salt VARCHAR(32) NOT NULL,
                  banned BOOLEAN NOT NULL DEFAULT FALSE,
                  created_at TIMESTAMP NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS sessions (
                  token VARCHAR(64) PRIMARY KEY,
                  player_id INT NOT NULL,
                  created_at TIMESTAMP NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS friendships (
                  requester_id INT NOT NULL,
                  addressee_id INT NOT NULL,
                  status VARCHAR(10) NOT NULL,
                  created_at TIMESTAMP NOT NULL,
                  PRIMARY KEY (requester_id, addressee_id)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS friend_helps (
                  helper_id INT NOT NULL,
                  friend_id INT NOT NULL,
                  day_key VARCHAR(10) NOT NULL,
                  created_at TIMESTAMP NOT NULL,
                  PRIMARY KEY (helper_id, friend_id, day_key)
                )
                """,
        };
        try (Connection c = dataSource.getConnection(); Statement st = c.createStatement()) {
            for (String sql : ddl) {
                st.execute(sql);
            }
            addColumn(c, st, "players", "account_id", "INT");
            addColumn(c, st, "players", "server_id", "VARCHAR(20)");
            addColumn(c, st, "players", "avatar", "VARCHAR(40)");
        } catch (SQLException e) {
            throw new IllegalStateException("Không khởi tạo được schema: " + e.getMessage(), e);
        }
    }

    // ALTER ... ADD COLUMN IF NOT EXISTS không portable giữa H2/MySQL nên kiểm tra metadata trước.
    private static void addColumn(Connection c, Statement st, String table, String column, String type)
            throws SQLException {
        for (String candidate : new String[]{table, table.toUpperCase()}) {
            try (ResultSet rs = c.getMetaData().getColumns(null, null, candidate, null)) {
                while (rs.next()) {
                    if (column.equalsIgnoreCase(rs.getString("COLUMN_NAME"))) return;
                }
            }
        }
        st.execute("ALTER TABLE " + table + " ADD COLUMN " + column + " " + type);
    }

    private SchemaInit() {
    }
}
