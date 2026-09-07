-- Điểm danh hằng ngày (lịch thưởng theo KHOẢNG THỜI GIAN cố định).
-- Đây là mắt xích còn thiếu của nhịp một phiên chơi: vào game là có việc để
-- nhận, và là nguồn ngọc lặp lại duy nhất đủ lớn để cân với bồn tiêu.

CREATE TABLE daily_rewards (
  character_id   TEXT PRIMARY KEY REFERENCES characters (id) ON DELETE CASCADE,
  -- Số thứ tự NGÀY (không phải timestamp) để so sánh "hôm nay / hôm qua" khỏi
  -- phải xử lý giờ giấc ở mỗi câu truy vấn.
  last_claim_day INTEGER NOT NULL,
  streak         INTEGER NOT NULL DEFAULT 1,
  total_claims   INTEGER NOT NULL DEFAULT 1
);
