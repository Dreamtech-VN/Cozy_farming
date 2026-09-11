-- Kho: chỗ chứa thứ hai, giữ phần vượt sức chứa của túi.
--
-- Có nó vì `addItemRaw` đang làm một việc rất tệ mà không ai thấy: quá
-- `stack_max` thì nó cắt phăng phần thừa đi (`Math.min(next, stack_max)`).
-- Thu hoạch vào một chồng đã đầy là mất trắng số dôi ra, không báo, không ghi
-- vào đâu cả. Từ nay phần dôi chảy vào kho.
--
-- Tách bảng riêng chứ không thêm cột `where` vào `inventories`: hai chỗ chứa có
-- luật khác nhau (kho chứa nhiều hơn, nhưng không dùng thẳng được), mà mọi câu
-- truy vấn túi đồ đang có đều ngầm hiểu "bảng này là túi". Thêm cột thì phải rà
-- lại từng câu, quên một câu là vật phẩm trong kho hiện lẫn vào túi.
CREATE TABLE character_storage (
  character_id TEXT NOT NULL REFERENCES characters (id) ON DELETE CASCADE,
  item_id      TEXT NOT NULL,
  quantity     INTEGER NOT NULL DEFAULT 0,
  updated_at   INTEGER NOT NULL,
  PRIMARY KEY (character_id, item_id)
);
