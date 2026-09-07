# Override: HUD và popup trong game

> Theo cơ chế của hệ thiết kế: file này **đè lên** `MASTER.md` cho phần giao
> diện trong game. Chỗ nào không nói tới thì vẫn theo MASTER.

## Vì sao chệch khỏi MASTER

MASTER sinh ra cho hạng mục *Casual Puzzle Game* nên đề xuất bảng màu **hồng
tươi + tím** (`#EC4899` / `#8B5CF6`) trên nền hồng nhạt. Bảng đó không dùng được
ở đây vì màu của game **đã bị art quyết định trước**, không phải ngược lại:

- Popup dùng asset gỗ/giấy của Cozy UI Pack (bản mua) — nền gỗ nâu cam `#c78060`.
- Thế giới dùng tileset pixel tự sinh với bảng màu cỏ/đất/gỗ trong
  `tools/art/palette.mjs`.

Đặt nút hồng tươi lên nền gỗ vừa chỏi vừa không đạt tương phản. Nên phần **cấu
trúc** của MASTER được giữ (tên token ngữ nghĩa, bậc khoảng cách, bậc bóng, nhịp
chuyển động, checklist), còn **màu** lấy từ art.

## Bảng màu thực dùng

| Vai trò | Giá trị | Ghi chú |
| --- | --- | --- |
| Nền popup | `#c78060` (ảnh gỗ 9-slice) | từ asset, không phải mã màu |
| Chữ trên gỗ | `#331e11` | đo được **5.01:1**, đạt ngưỡng 4.5:1 |
| Chữ phụ trên gỗ | `#6b4a2d` | dùng cho dòng mô tả |
| Nhấn chính (CTA) | gradient kem `#fff6d6 → #ffe09a`, chữ `#6b4415` | tab đang chọn, nút gửi |
| Nhấn phụ | vàng `#f5cf6a` | tên người gửi, số cấp |
| Xác nhận / thành công | `#9ee06f → #56a02d` | nút nhận thưởng |
| Cảnh báo / xoá | `#f0483f` | chấm đỏ báo việc |
| Tấm HUD | `rgba(96,84,72,.52)` kính mờ, chữ trắng | nổi trên mọi nền cảnh |

## Giữ nguyên theo MASTER

- **Phong cách Claymorphism**: bo góc 16–24px, bóng kép trong + ngoài, nhấn nút
  nảy nhẹ `cubic-bezier(.34,1.56,.64,1)` trong 150ms.
- **Bậc khoảng cách và bo góc** khai báo thành token ở `:root` của
  `client/styles.css`.
- **Checklist trước khi giao**: đã chạy, xem `docs/CHANGELOG.md` 0.7.1.

## Chệch về typography

MASTER đề xuất **Varela Round + Nunito Sans**. Đã đổi thành **Baloo 2 + Nunito**
vì một lý do bắt buộc: game viết bằng tiếng Việt, mà cặp font đầu tiên do bảng
tra gợi ý cho hạng mục "gaming" (**Fredoka**) **không có subset vietnamese** —
mọi chữ có dấu sẽ rơi về font hệ thống. Baloo 2 nằm trong cặp "Kids/Education —
educational games" của chính bảng tra và có đủ tiếng Việt.

Font **tự host** trong `client/assets/fonts/` (SIL OFL 1.1) chứ không nhúng link
`fonts.googleapis.com`: game phải chạy được khi không có mạng ngoài, và mỗi lần
tải chữ là một request kèm IP người chơi gửi sang bên thứ ba.
