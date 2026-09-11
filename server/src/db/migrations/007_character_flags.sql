-- Cờ theo nhân vật: một kho khoá/giá trị nhỏ cho những mốc không đáng có bảng riêng.
--
-- Cái đầu tiên dùng nó là tiến trình hướng dẫn người mới. Mốc ấy có đúng MỘT
-- con số cho mỗi nhân vật; dựng hẳn một bảng `onboarding` với khoá chính, chỉ
-- mục và migration riêng là nặng tay hơn thứ nó chứa. Sau này thành tựu, cờ đã
-- xem lần đầu, đã bấm nút gì rồi đều về đây được.
--
-- Giá trị để TEXT chứ không INTEGER: bước hướng dẫn là một cái tên (`move`,
-- `harvest`), không phải số thứ tự. Đánh số thì chèn thêm một bước vào giữa là
-- mọi người chơi đang dở nhảy sang bước khác.
CREATE TABLE character_flags (
  character_id TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  key          TEXT NOT NULL,
  value        TEXT NOT NULL,
  updated_at   INTEGER NOT NULL,
  PRIMARY KEY (character_id, key)
);
