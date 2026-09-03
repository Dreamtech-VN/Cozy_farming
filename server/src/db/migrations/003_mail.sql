-- Doc 08 — hòm thư: thư hệ thống, thư sự kiện, thư kèm quà.

CREATE TABLE mails (
  id           TEXT PRIMARY KEY,
  character_id TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  -- Khoá của thư hệ thống trong content; NULL cho thư gửi riêng. Dùng để không
  -- gửi trùng một thư hệ thống hai lần cho cùng một người.
  source_key   TEXT,
  subject      TEXT NOT NULL,
  body         TEXT NOT NULL,
  -- Quà đính kèm, đúng khuôn của economy.applyChange. '{}' nghĩa là thư suông.
  attachments  TEXT NOT NULL DEFAULT '{}',
  read_at      INTEGER,
  claimed_at   INTEGER,
  created_at   INTEGER NOT NULL,
  expires_at   INTEGER
);

CREATE UNIQUE INDEX idx_mails_source ON mails (character_id, source_key) WHERE source_key IS NOT NULL;
CREATE INDEX idx_mails_character ON mails (character_id, created_at DESC);

-- Sổ ghi đã gửi, TÁCH khỏi hòm thư: xoá thư trong hòm không được làm thư hệ
-- thống tự gửi lại ở lần mở hòm thư sau.
CREATE TABLE mail_deliveries (
  character_id TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  source_key   TEXT NOT NULL,
  delivered_at INTEGER NOT NULL,
  PRIMARY KEY (character_id, source_key)
);
