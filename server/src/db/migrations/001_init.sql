-- Doc 14 — Database Design.
-- Nguyên tắc: content tĩnh (item, crop, map, quest, shop, event) nằm trong data/content
-- và KHÔNG lưu trong database; database chỉ giữ state động của người chơi.
-- Player là root entity; character, inventory, farm, social, progression nối bằng ID bất biến.

CREATE TABLE users (
  id            TEXT PRIMARY KEY,
  username      TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  status        TEXT NOT NULL DEFAULT 'active',   -- active | suspended | banned
  created_at    INTEGER NOT NULL,
  last_login_at INTEGER
);
CREATE INDEX idx_users_username ON users (username);

CREATE TABLE sessions (
  id           TEXT PRIMARY KEY,
  user_id      TEXT NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  refresh_hash TEXT NOT NULL UNIQUE,
  device       TEXT,
  created_at   INTEGER NOT NULL,
  expires_at   INTEGER NOT NULL,
  revoked_at   INTEGER
);
CREATE INDEX idx_sessions_user ON sessions (user_id);

CREATE TABLE characters (
  id          TEXT PRIMARY KEY,
  user_id     TEXT NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  nickname    TEXT NOT NULL UNIQUE,
  body_type   TEXT NOT NULL DEFAULT 'a',
  level       INTEGER NOT NULL DEFAULT 1,
  xp          INTEGER NOT NULL DEFAULT 0,
  last_map_id TEXT NOT NULL,
  last_x      REAL NOT NULL,
  last_y      REAL NOT NULL,
  created_at  INTEGER NOT NULL,
  updated_at  INTEGER NOT NULL
);
CREATE INDEX idx_characters_user ON characters (user_id);

-- Cosmetic đang mặc: một dòng cho mỗi slot (doc 04).
CREATE TABLE character_equipment (
  character_id   TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  slot           TEXT NOT NULL,
  avatar_item_id TEXT NOT NULL,
  PRIMARY KEY (character_id, slot)
);

-- Tủ đồ: cosmetic đã sở hữu.
CREATE TABLE character_wardrobe (
  character_id   TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  avatar_item_id TEXT NOT NULL,
  acquired_at    INTEGER NOT NULL,
  PRIMARY KEY (character_id, avatar_item_id)
);

CREATE TABLE inventories (
  character_id TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  item_id      TEXT NOT NULL,
  quantity     INTEGER NOT NULL CHECK (quantity >= 0),
  updated_at   INTEGER NOT NULL,
  PRIMARY KEY (character_id, item_id)
);
CREATE INDEX idx_inventories_item ON inventories (character_id, item_id);

CREATE TABLE wallets (
  character_id TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  currency_id  TEXT NOT NULL,
  amount       INTEGER NOT NULL CHECK (amount >= 0),
  updated_at   INTEGER NOT NULL,
  PRIMARY KEY (character_id, currency_id)
);

CREATE TABLE farms (
  id           TEXT PRIMARY KEY,
  character_id TEXT NOT NULL UNIQUE REFERENCES characters (id) ON DELETE CASCADE,
  level        INTEGER NOT NULL DEFAULT 1,
  xp           INTEGER NOT NULL DEFAULT 0,
  plot_count   INTEGER NOT NULL,
  created_at   INTEGER NOT NULL,
  updated_at   INTEGER NOT NULL
);

-- state: empty | prepared | seeded | growing | mature | withered (doc 06)
CREATE TABLE farm_plots (
  id         TEXT PRIMARY KEY,
  farm_id    TEXT NOT NULL REFERENCES farms (id) ON DELETE CASCADE,
  slot_index INTEGER NOT NULL,
  state      TEXT NOT NULL DEFAULT 'empty',
  crop_id    TEXT,
  planted_at INTEGER,
  ready_at   INTEGER,
  updated_at INTEGER NOT NULL,
  UNIQUE (farm_id, slot_index)
);
CREATE INDEX idx_farm_plots_farm ON farm_plots (farm_id);

-- state: active | completed | claimed
CREATE TABLE quest_progress (
  character_id TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  quest_id     TEXT NOT NULL,
  state        TEXT NOT NULL DEFAULT 'active',
  progress     TEXT NOT NULL DEFAULT '{}',
  period_key   TEXT NOT NULL DEFAULT '',     -- ngày/tuần cho quest daily & weekly
  started_at   INTEGER NOT NULL,
  completed_at INTEGER,
  claimed_at   INTEGER,
  PRIMARY KEY (character_id, quest_id, period_key)
);

-- Board Match-3 do server sở hữu hoàn toàn (doc 07, doc 22).
CREATE TABLE matches (
  id           TEXT PRIMARY KEY,
  character_id TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  level_id     TEXT NOT NULL,
  mode         TEXT NOT NULL DEFAULT 'pve',
  seed         INTEGER NOT NULL,
  state        TEXT NOT NULL DEFAULT 'active',  -- active | won | lost | abandoned
  board        TEXT NOT NULL,
  moves_left   INTEGER NOT NULL,
  enemy_hp     INTEGER NOT NULL,
  turn         INTEGER NOT NULL DEFAULT 0,
  score        INTEGER NOT NULL DEFAULT 0,
  created_at   INTEGER NOT NULL,
  updated_at   INTEGER NOT NULL
);
CREATE INDEX idx_matches_character ON matches (character_id, created_at);

CREATE TABLE match_results (
  id           TEXT PRIMARY KEY,
  match_id     TEXT NOT NULL REFERENCES matches (id) ON DELETE CASCADE,
  character_id TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  level_id     TEXT NOT NULL,
  result       TEXT NOT NULL,
  score        INTEGER NOT NULL,
  turns_used   INTEGER NOT NULL,
  rewards      TEXT NOT NULL,
  first_clear  INTEGER NOT NULL DEFAULT 0,
  created_at   INTEGER NOT NULL
);
CREATE INDEX idx_match_results_character ON match_results (character_id, created_at);

-- state: pending | accepted | blocked
CREATE TABLE friends (
  id                  TEXT PRIMARY KEY,
  character_id        TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  friend_character_id TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  state               TEXT NOT NULL,
  created_at          INTEGER NOT NULL,
  updated_at          INTEGER NOT NULL,
  UNIQUE (character_id, friend_character_id)
);
CREATE INDEX idx_friends_pair ON friends (character_id, friend_character_id);

-- channel: world | map | private
CREATE TABLE messages (
  id           TEXT PRIMARY KEY,
  channel      TEXT NOT NULL,
  scope_id     TEXT,
  sender_id    TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  recipient_id TEXT REFERENCES characters (id) ON DELETE CASCADE,
  body         TEXT NOT NULL,
  created_at   INTEGER NOT NULL
);
CREATE INDEX idx_messages_conversation ON messages (channel, scope_id, created_at);
CREATE INDEX idx_messages_recipient ON messages (recipient_id, created_at);

-- Mọi thay đổi currency/item đều đi qua đây (doc 10 & 22 — idempotency + audit).
CREATE TABLE transactions (
  id              TEXT PRIMARY KEY,
  character_id    TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  kind            TEXT NOT NULL,
  idempotency_key TEXT,
  payload         TEXT NOT NULL,
  status          TEXT NOT NULL DEFAULT 'committed',
  created_at      INTEGER NOT NULL,
  UNIQUE (character_id, idempotency_key)
);
CREATE INDEX idx_transactions_character ON transactions (character_id, created_at);

CREATE TABLE analytics_events (
  id           TEXT PRIMARY KEY,
  character_id TEXT,
  event_name   TEXT NOT NULL,
  payload      TEXT NOT NULL,
  created_at   INTEGER NOT NULL
);
CREATE INDEX idx_analytics_name ON analytics_events (event_name, created_at);

CREATE TABLE moderation_reports (
  id          TEXT PRIMARY KEY,
  reporter_id TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  target_id   TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  reason      TEXT NOT NULL,
  detail      TEXT,
  status      TEXT NOT NULL DEFAULT 'open',
  created_at  INTEGER NOT NULL
);

CREATE TABLE admin_audit (
  id         TEXT PRIMARY KEY,
  actor      TEXT NOT NULL,
  action     TEXT NOT NULL,
  payload    TEXT NOT NULL,
  created_at INTEGER NOT NULL
);
