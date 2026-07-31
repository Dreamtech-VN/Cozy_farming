"""Tách nền cho logo game (Sunny Town) -> assets/ui/logo.png.

File gốc là ảnh nền trắng (hoặc nền caro đã bị "dí" thành pixel), nên phải
loang từ mép vào để xoá nền mà vẫn giữ mấy nét trắng nằm trong lòng chữ.
"""
from PIL import Image, ImageFilter
import numpy as np
from collections import deque
import sys

SRC = sys.argv[1] if len(sys.argv) > 1 else \
    '/root/.claude/uploads/b40e10a2-4a20-5fd7-b845-31972e4262c8/fe2dc1a9-D81DFE1D5B9B42F082DCD6D812562D3F.png'
OUT = 'public/assets/ui/logo.png'

im = Image.open(SRC).convert('RGBA')
a = np.array(im)
H, W = a.shape[:2]
rgb = a[..., :3].astype(np.int16)

# "nền" = gần trắng hoặc xám nhạt (ô caro), không lẫn với vàng/xanh của logo
sat = rgb.max(axis=2) - rgb.min(axis=2)
bgish = (rgb.min(axis=2) > 205) & (sat < 26)

seen = np.zeros((H, W), bool)
q = deque()
for x in range(W):
    for y in (0, H - 1):
        if bgish[y, x] and not seen[y, x]:
            seen[y, x] = True; q.append((y, x))
for y in range(H):
    for x in (0, W - 1):
        if bgish[y, x] and not seen[y, x]:
            seen[y, x] = True; q.append((y, x))
while q:
    y, x = q.popleft()
    for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        ny, nx = y + dy, x + dx
        if 0 <= ny < H and 0 <= nx < W and not seen[ny, nx] and bgish[ny, nx]:
            seen[ny, nx] = True; q.append((ny, nx))

al = np.where(seen, 0, 255).astype(np.uint8)
al = np.array(Image.fromarray(al).filter(ImageFilter.GaussianBlur(0.8)))
a[..., 3] = al
im = Image.fromarray(a, 'RGBA')
bb = im.getbbox()
if bb:
    im = im.crop(bb)
im.thumbnail((512, 512), Image.LANCZOS)
im.save(OUT)
print('logo', im.size)
