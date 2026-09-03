-- Doc 22 — liên kết tài khoản mạng xã hội và lịch sử đổi giftcode.

-- Một user có tối đa một liên kết cho mỗi provider, và một tài khoản mạng xã hội
-- chỉ gắn được vào một user.
CREATE TABLE user_identities (
  user_id          TEXT NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  provider         TEXT NOT NULL,           -- google | facebook | apple
  provider_user_id TEXT NOT NULL,
  linked_at        INTEGER NOT NULL,
  PRIMARY KEY (user_id, provider),
  UNIQUE (provider, provider_user_id)
);

-- Mỗi user đổi mỗi mã đúng một lần; tổng lượt đổi đếm bằng COUNT trên bảng này
-- nên không cần cột đếm dễ lệch.
CREATE TABLE giftcode_redemptions (
  code          TEXT NOT NULL,
  user_id       TEXT NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  character_id  TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  redeemed_at   INTEGER NOT NULL,
  PRIMARY KEY (code, user_id)
);
CREATE INDEX idx_giftcode_redemptions_code ON giftcode_redemptions (code);
