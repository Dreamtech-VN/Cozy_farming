#!/usr/bin/env python3
"""Cắt trạm ATM trong imageMap Lttt + gom icon cần câu.

- ATM: map 10 của Avatar (Lttt) là dãy phố có sẵn buồng ATM hai máy, biển xanh
  chữ "ATM". Cắt nguyên buồng ra dùng cho khu Nông Trại (trước đây phải mượn
  tạm ki-ốt hd/home/1036.png vì tưởng Lttt không có ATM).
- Cần câu: hình cầm tay của 3 cần Lttt (item 442/445/446) đã có sẵn trong
  assets/chibi/, nhưng chỉ là cái cần mảnh dính vào tay — làm icon shop thì
  không đọc được. Icon lấy từ Cozy Fishing Asset Pack (shubibubi).

Chạy: python3 scripts/import_atm_rods.py <thư-mục-scratchpad>
"""
import sys
import os
from PIL import Image

SCRATCH = sys.argv[1] if len(sys.argv) > 1 else '.'
OUT = os.path.join(os.path.dirname(__file__), '..', 'public', 'assets')


def compose_map(map_id: str) -> Image.Image:
    """Ghép các mảnh imageMap (căn đáy) như client Avatar vẽ.

    Chỉ lấy các mảnh đánh số; file tên chữ (daydien0/1/2 = dây điện) là lớp phủ
    riêng, không nằm trong dải nền.
    """
    d = os.path.join(SCRATCH, 'apk', 'assets', 'hd', 'imageMap', map_id)
    files = sorted((f for f in os.listdir(d) if f.split('.')[0].isdigit()),
                   key=lambda f: int(f.split('.')[0]))
    ims = [Image.open(os.path.join(d, f)).convert('RGBA') for f in files]
    w = sum(i.width for i in ims)
    h = max(i.height for i in ims)
    out = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    x = 0
    for im in ims:
        out.paste(im, (x, h - im.height), im)
        x += im.width
    return out


def strip_grass(im: Image.Image) -> Image.Image:
    """Xoá cỏ nền quanh công trình: loang từ mép ảnh qua các điểm ngả xanh lá."""
    im = im.convert('RGBA')
    px = im.load()
    w, h = im.size

    def grassy(x, y):
        r, g, b, a = px[x, y]
        return a > 0 and g > r + 18 and g > b + 18

    stack = [(x, y) for x in range(w) for y in (0, h - 1)]
    stack += [(x, y) for y in range(h) for x in (0, w - 1)]
    seen = set()
    while stack:
        x, y = stack.pop()
        if (x, y) in seen or not (0 <= x < w and 0 <= y < h):
            continue
        seen.add((x, y))
        if not grassy(x, y):
            continue
        px[x, y] = (0, 0, 0, 0)
        stack += [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
    return im


def cut_atm():
    m10 = compose_map('10')
    # buồng ATM: mái xanh bắt đầu y=109, chân buồng y=221, hai máy x=47..194
    atm = strip_grass(m10.crop((48, 108, 194, 220)))
    p = os.path.join(OUT, 'lttt', 'bld', 'atm.png')
    atm.save(p)
    print('ATM', atm.size, '->', p)


# 3 cần câu Lttt <-> ô icon trong inv_items.png (lưới 16x16, 9 cột)
ROD_CELLS = [(0, 4), (0, 3), (5, 2)]   # tre (gỗ nâu) | sắt (xanh) | VIP (đỏ-vàng)


def cut_rods():
    src = os.path.join(SCRATCH, 'fishzip', 'fishing_full',
                       'Fish Forage Items', 'inv_items.png')
    sheet = Image.open(src).convert('RGBA')
    out = Image.new('RGBA', (16 * len(ROD_CELLS), 16), (0, 0, 0, 0))
    for i, (c, r) in enumerate(ROD_CELLS):
        out.paste(sheet.crop((c * 16, r * 16, c * 16 + 16, r * 16 + 16)), (i * 16, 0))
    p = os.path.join(OUT, 'fishing', 'rods.png')
    out.save(p)
    print('RODS', out.size, '->', p)
    # icon cần câu chung (túi đồ / thanh nông cụ khi chưa biết bậc)
    p1 = os.path.join(OUT, 'fishing', 'rod.png')
    out.crop((0, 0, 16, 16)).save(p1)
    print('ROD', '->', p1)


if __name__ == '__main__':
    cut_atm()
    cut_rods()
