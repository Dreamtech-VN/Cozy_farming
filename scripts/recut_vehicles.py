"""Cắt lại sprite xe từ tileset town (bản cũ cắt lẹm mất đầu xe).

Trong sheet mỗi mẫu xe được vẽ 2 lần dính liền nhau thành 1 khối 160px,
nên cứ lấy đúng nửa trái 80px rồi trim theo bbox của chính nó.
"""
from PIL import Image

SHEET = 'public/assets/town/buildings_all.png'
OUT = 'public/assets/vehicles/'
UNIT = 80

# (tên file, x khối, y trên, y dưới)
CARS = [
    ('camper_green', 0, 526, 576),
    ('camper_pink', 240, 526, 576),
    ('camper_yellow', 480, 526, 576),
    ('truck_orange', 0, 584, 640),
    ('truck_bee', 240, 584, 640),
    ('truck_gift', 480, 584, 640),
]

sh = Image.open(SHEET).convert('RGBA')
for name, x0, y0, y1 in CARS:
    im = sh.crop((x0, y0, x0 + UNIT, y1))
    bb = im.getbbox()
    if bb:
        im = im.crop(bb)
    im.save(OUT + name + '.png')
    print(name, im.size)
