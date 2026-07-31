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
LOGO = 'public/assets/ui/logo.png'
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

# Biển gốc chỉ 88x94 nên logo dán vào bị bé và nhoè. Phóng nearest x2 (giữ
# nguyên nét pixel của biển) rồi mới dán logo ở độ phân giải gấp đôi -> chữ
# Sunny Town rõ hẳn; trong game vẽ ở nửa scale nên kích thước vẫn như cũ.
SCALE = 2
im = im.resize((W * SCALE, H * SCALE), Image.NEAREST)
W, H = im.size
px = im.load()

panel = [(x, y) for y in range(H) for x in range(W) if px[x, y] in PANEL]
x0, x1 = min(x for x, _ in panel), max(x for x, _ in panel)
y0, y1 = min(y for _, y in panel), max(y for _, y in panel)
pw, ph = (x1 - x0 + 1) - 10 * SCALE, (y1 - y0 + 1) - 10 * SCALE      # chừa lề
logo = Image.open(LOGO).convert('RGBA')
k = min(pw / logo.width, ph / logo.height)
logo = logo.resize((max(1, round(logo.width * k)), max(1, round(logo.height * k))), Image.LANCZOS)
im.alpha_composite(logo, ((x0 + x1 + 1 - logo.width) // 2, (y0 + y1 + 1 - logo.height) // 2))

im.save(DST)
print(f'{DST}  {im.size}  trải phẳng {len(text_rows)} hàng chữ, logo {logo.size}')
