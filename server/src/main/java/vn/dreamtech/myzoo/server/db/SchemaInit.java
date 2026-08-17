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
                """
                CREATE TABLE IF NOT EXISTS mails (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY,
                  player_id INT NOT NULL,
                  title VARCHAR(120) NOT NULL,
                  body VARCHAR(500),
                  reward_vang BIGINT NOT NULL DEFAULT 0,
                  reward_kc BIGINT NOT NULL DEFAULT 0,
                  reward_food_id VARCHAR(20),
                  reward_food_qty INT NOT NULL DEFAULT 0,
                  claimed BOOLEAN NOT NULL DEFAULT FALSE,
                  created_at TIMESTAMP NOT NULL,
                  expires_at TIMESTAMP NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS giftcodes (
                  code VARCHAR(32) PRIMARY KEY,
                  reward_vang BIGINT NOT NULL DEFAULT 0,
                  reward_kc BIGINT NOT NULL DEFAULT 0,
                  reward_food_id VARCHAR(20),
                  reward_food_qty INT NOT NULL DEFAULT 0,
                  max_uses INT NOT NULL,
                  used_count INT NOT NULL DEFAULT 0,
                  expires_at TIMESTAMP NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS giftcode_uses (
                  code VARCHAR(32) NOT NULL,
                  player_id INT NOT NULL,
                  created_at TIMESTAMP NOT NULL,
                  PRIMARY KEY (code, player_id)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS achievement_counters (
                  player_id INT NOT NULL,
                  counter_type VARCHAR(20) NOT NULL,
                  counter INT NOT NULL DEFAULT 0,
                  PRIMARY KEY (player_id, counter_type)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS achievement_claims (
                  player_id INT NOT NULL,
                  achievement_id VARCHAR(30) NOT NULL,
                  created_at TIMESTAMP NOT NULL,
                  PRIMARY KEY (player_id, achievement_id)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS species_collection (
                  player_id INT NOT NULL,
                  species_id VARCHAR(20) NOT NULL,
                  first_owned_at TIMESTAMP NOT NULL,
                  PRIMARY KEY (player_id, species_id)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS player_items (
                  player_id INT NOT NULL,
                  item_id VARCHAR(30) NOT NULL,
                  quantity INT NOT NULL DEFAULT 0,
                  PRIMARY KEY (player_id, item_id)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS processing_slots (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY,
                  player_id INT NOT NULL,
                  recipe_id VARCHAR(30) NOT NULL,
                  started_at TIMESTAMP NOT NULL,
                  ready_at TIMESTAMP NOT NULL,
                  collected BOOLEAN NOT NULL DEFAULT FALSE
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS habitat_decors (
                  habitat_id INT NOT NULL,
                  decor_id VARCHAR(20) NOT NULL,
                  created_at TIMESTAMP NOT NULL,
                  PRIMARY KEY (habitat_id, decor_id)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS chat_messages (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY,
                  channel VARCHAR(10) NOT NULL,
                  sender_id INT NOT NULL,
                  target_id INT,
                  type VARCHAR(10) NOT NULL,
                  text VARCHAR(300),
                  ref_id VARCHAR(40),
                  created_at TIMESTAMP NOT NULL,
                  deleted BOOLEAN NOT NULL DEFAULT FALSE,
                  deleted_by INT
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS chat_relations (
                  player_id INT NOT NULL,
                  target_id INT NOT NULL,
                  mode VARCHAR(10) NOT NULL,
                  created_at TIMESTAMP NOT NULL,
                  PRIMARY KEY (player_id, target_id)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS chat_reports (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY,
                  message_id BIGINT NOT NULL,
                  reporter_id INT NOT NULL,
                  reason VARCHAR(200),
                  created_at TIMESTAMP NOT NULL,
                  handled BOOLEAN NOT NULL DEFAULT FALSE,
                  UNIQUE (message_id, reporter_id)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS chat_bans (
                  player_id INT PRIMARY KEY,
                  banned_until TIMESTAMP NOT NULL,
                  reason VARCHAR(200)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS chat_violations (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY,
                  player_id INT NOT NULL,
                  reason VARCHAR(200),
                  created_at TIMESTAMP NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS chat_voices (
                  voice_id VARCHAR(40) PRIMARY KEY,
                  player_id INT NOT NULL,
                  duration_ms INT NOT NULL,
                  bytes INT NOT NULL,
                  created_at TIMESTAMP NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS gacha_banners (
                  id VARCHAR(40) PRIMARY KEY,
                  name VARCHAR(60) NOT NULL,
                  version INT NOT NULL DEFAULT 1,
                  cost_single INT NOT NULL,
                  cost_ten INT NOT NULL,
                  pity_threshold INT NOT NULL,
                  start_at TIMESTAMP,
                  end_at TIMESTAMP
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS gacha_pools (
                  banner_id VARCHAR(40) NOT NULL,
                  tier VARCHAR(5) NOT NULL,
                  weight INT NOT NULL,
                  PRIMARY KEY (banner_id, tier)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS gacha_pity (
                  player_id INT NOT NULL,
                  banner_id VARCHAR(40) NOT NULL,
                  counter INT NOT NULL DEFAULT 0,
                  PRIMARY KEY (player_id, banner_id)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS gacha_pulls (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY,
                  player_id INT NOT NULL,
                  banner_id VARCHAR(40) NOT NULL,
                  cosmetic_id VARCHAR(40) NOT NULL,
                  tier VARCHAR(5) NOT NULL,
                  duplicate BOOLEAN NOT NULL DEFAULT FALSE,
                  fragments INT NOT NULL DEFAULT 0,
                  pity_before INT NOT NULL,
                  pity_after INT NOT NULL,
                  created_at TIMESTAMP NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS owned_cosmetics (
                  player_id INT NOT NULL,
                  cosmetic_id VARCHAR(40) NOT NULL,
                  source VARCHAR(20) NOT NULL,
                  acquired_at TIMESTAMP NOT NULL,
                  PRIMARY KEY (player_id, cosmetic_id)
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS premium_orders (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY,
                  player_id INT NOT NULL,
                  provider VARCHAR(20) NOT NULL,
                  product_id VARCHAR(60) NOT NULL,
                  external_transaction_id VARCHAR(160) NOT NULL UNIQUE,
                  status VARCHAR(20) NOT NULL,
                  kc_amount BIGINT NOT NULL,
                  price_vnd BIGINT NOT NULL,
                  created_at TIMESTAMP NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS analytics_events (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY,
                  player_id INT,
                  event VARCHAR(40) NOT NULL,
                  props VARCHAR(500),
                  day_key VARCHAR(10) NOT NULL,
                  created_at TIMESTAMP NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS mission_defs (
                  id VARCHAR(40) PRIMARY KEY,
                  name VARCHAR(80) NOT NULL,
                  type VARCHAR(20) NOT NULL,
                  target INT NOT NULL,
                  reward_vang BIGINT NOT NULL DEFAULT 0,
                  reward_kc BIGINT NOT NULL DEFAULT 0,
                  scope VARCHAR(10) NOT NULL DEFAULT 'DAILY',
                  event_id VARCHAR(40),
                  active_from TIMESTAMP,
                  active_to TIMESTAMP,
                  sort_order INT NOT NULL DEFAULT 0
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS livestock (
                  id BIGINT AUTO_INCREMENT PRIMARY KEY,
                  player_id INT NOT NULL,
                  species_id VARCHAR(20) NOT NULL,
                  last_fed_at TIMESTAMP,
                  next_product_at TIMESTAMP,
                  created_at TIMESTAMP NOT NULL
                )
                """,
                """
                CREATE TABLE IF NOT EXISTS gacha_fragments (
                  player_id INT PRIMARY KEY,
                  amount INT NOT NULL DEFAULT 0
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
            addColumn(c, st, "players", "equipped_skin", "VARCHAR(40)");
            addColumn(c, st, "minigame_sessions", "game_type", "VARCHAR(20)");
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
