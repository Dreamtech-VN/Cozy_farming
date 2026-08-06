# Ghi chú thiết kế client Unity (chưa bắt đầu làm)

Server Java đang được làm trước (xem `server/README.md`), Unity client làm
sau khi server xong hẳn. File này chỉ ghi lại các quyết định thiết kế người
dùng đã chốt cho client Unity, để không quên khi tới lúc làm — KHÔNG áp dụng
ngược lại cho client Phaser/TS hiện có (client đó đã dừng sửa hẳn).

## Cấu trúc map

- **Chỉ nông trại là map riêng.** Các khu vực/tính năng khác (tiệm, nhà bếp,
  ao cá, nhà ở, thời trang...) KHÔNG tách thành nhiều map riêng như bản
  Phaser hiện tại (9 khu vực, phải đi xe buýt qua lại) — gộp chung vào 1 map
  chính duy nhất.
- Nghĩa là chỉ có 2 "map" tổng cộng: map chính (mọi tiệm/nhà/tính năng ngoài
  nông trại) + map nông trại riêng.
