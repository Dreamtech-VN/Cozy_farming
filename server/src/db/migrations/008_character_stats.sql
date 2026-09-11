-- Số liệu tích luỹ CẢ ĐỜI nhân vật: đã thu hoạch bao nhiêu, thắng bao nhiêu trận.
--
-- Khác `quest_progress` ở chỗ nó KHÔNG reset theo chu kỳ và không gắn với một
-- nhiệm vụ nào. Thành tựu và bảng xếp hạng đều đọc từ đây, nên hai tính năng ấy
-- không phải tự đếm lấy — mà nếu tự đếm thì kiểu gì cũng có lúc hai bảng ra hai
-- con số khác nhau cho cùng một việc.
--
-- Chỉ mục theo (key, value) để xếp hạng không phải quét cả bảng rồi sắp lại.
CREATE TABLE character_stats (
  character_id TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  key          TEXT NOT NULL,
  value        INTEGER NOT NULL DEFAULT 0,
  updated_at   INTEGER NOT NULL,
  PRIMARY KEY (character_id, key)
);
CREATE INDEX idx_stats_rank ON character_stats (key, value DESC);
