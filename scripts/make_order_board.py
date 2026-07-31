"""Bảng đơn hàng ở nông trại — làm sạch chữ trên biển gỗ của repo Lttt.

Nguồn: assets/lttt/rank_sign.png (biển "BẢNG XẾP HẠNG" gốc Avatar). Biển chỉ
dùng vài màu phẳng: nét chữ là màu nâu đậm riêng, mặt biển là màu gỗ + vân sáng
+ vệt tối. Nét chữ còn kèm bóng đổ trùng màu với vân gỗ nên không tách được
bằng màu; cách chắc ăn là xoá hết nét nâu rồi trải phẳng đúng những hàng từng
có chữ (các hàng còn lại giữ nguyên vân). Tên bảng do game vẽ chữ đè lên
(giống nhãn "Nhà kho") nên không cần vẽ chữ vào ảnh.

Chạy: python3 scripts/make_order_board.py
"""
from PIL import Image

SRC = 'public/assets/lttt/rank_sign.png'
DST = 'public/assets/lttt/order_board.png'
INK = (107, 73, 0, 255)         # nét chữ
WOOD = (255, 203, 123, 255)     # gỗ nền mặt biển
PANEL = {WOOD, (255, 231, 193, 255), (221, 175, 119, 255)}   # gỗ + vân sáng + vệt tối

im = Image.open(SRC).convert('RGBA')
W, H = im.size
px = im.load()

text_rows = {y for y in range(H) for x in range(W) if px[x, y] == INK}
for y in range(H):
    for x in range(W):
        if px[x, y] == INK:
            px[x, y] = WOOD

for y in sorted({r for row in text_rows for r in (row - 1, row, row + 1)} & set(range(H))):
    for x in range(W):
        if px[x, y] in PANEL:
            px[x, y] = WOOD

im.save(DST)
print(f'{DST}  {im.size}  trải phẳng {len(text_rows)} hàng chữ')
