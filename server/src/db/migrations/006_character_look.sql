-- Ngoại hình nhân vật: mảnh art người chơi chọn ở màn tạo nhân vật.
--
-- Lưu JSON một cột chứ không tách bảng: đây là một bộ ba tên sprite cộng chỉ
-- số tông da, luôn đọc và ghi cả cụm, không truy vấn theo từng phần bao giờ.
-- Khác `character_equipment` — bảng đó dành cho cosmetic có thể đổi, mua bán và
-- cất tủ, còn cái này là hình dáng gốc chọn một lần lúc tạo.
ALTER TABLE characters ADD COLUMN appearance TEXT;
