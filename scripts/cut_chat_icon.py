"""Cắt icon bong bóng chat từ nút chat gốc của repo Lttt.

`hd/iconmenu/chat0.png` là cả một cái nút: khung bo góc xám + nền trắng, bên
trong mới là bong bóng thoại xanh. Game dùng nút kính riêng nên chỉ cần bong
bóng: xoá mọi vùng màu nhạt/xám nối liền với mép ảnh (khung + nền), giữ lại
phần bong bóng ở giữa rồi trim viền trong suốt.

Chạy: python3 scripts/cut_chat_icon.py <thư mục hd/iconmenu>
"""
import os
import sys
from collections import deque

from PIL import Image

SRC = sys.argv[1] if len(sys.argv) > 1 else 'iconmenu'
DST = 'public/assets/ui/pack/icon_chat.png'

im = Image.open(os.path.join(SRC, 'chat0.png')).convert('RGBA')
W, H = im.size
px = im.load()


def framey(p):
    """Pixel thuộc khung/nền: trong suốt, hoặc xám-trắng (3 kênh sát nhau)."""
    r, g, b, a = p
    if a < 20:
        return True
    return max(r, g, b) - min(r, g, b) < 26


# loang từ mép ảnh vào, xoá hết phần khung + nền quanh bong bóng
seen = [[False] * W for _ in range(H)]
q = deque()
for x in range(W):
    for y in (0, H - 1):
        q.append((x, y))
for y in range(H):
    for x in (0, W - 1):
        q.append((x, y))
while q:
    x, y = q.popleft()
    if not (0 <= x < W and 0 <= y < H) or seen[y][x]:
        continue
    if not framey(px[x, y]):
        continue
    seen[y][x] = True
    px[x, y] = (0, 0, 0, 0)
    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        q.append((x + dx, y + dy))

im = im.crop(im.getbbox())
im.save(DST)
print(f'{DST}  {im.size}')
