"""Dựng bản HD của nhà pack Cozy cho khớp với map nền vẽ tay.

Map nông trại là tranh vẽ mềm, còn sprite pack Cozy là pixel-art 1x nên phóng
to bằng NEAREST trông rất "răng cưa", lệch style. Ở đây phóng 2x rồi:
  - làm mềm cạnh (LANCZOS + khử răng cưa nhẹ)
  - đắp viền tối mảnh quanh silhouette cho khối rõ như tranh
  - thêm bóng đổ mềm dưới chân nhà
"""
from PIL import Image, ImageFilter, ImageChops
import numpy as np
import os

SRC = 'public/assets/buildings/'
DST = 'public/assets/buildings/hd/'
NAMES = ['farm_house', 'farm_barn', 'farm_market', 'farm_coop', 'farm_store']
SCALE = 2

os.makedirs(DST, exist_ok=True)

for n in NAMES:
    im = Image.open(SRC + n + '.png').convert('RGBA')
    bb = im.getbbox()
    if bb:
        im = im.crop(bb)
    w, h = im.width * SCALE, im.height * SCALE
    # phóng to mềm: NEAREST giữ màu + LANCZOS làm mượt, trộn 50/50
    hard = im.resize((w, h), Image.NEAREST)
    soft = im.resize((w, h), Image.LANCZOS)
    big = Image.blend(hard, soft, 0.55)

    a = big.split()[3].point(lambda v: 255 if v > 110 else 0)
    a = a.filter(ImageFilter.GaussianBlur(0.6)).point(lambda v: 255 if v > 90 else 0)
    big.putalpha(a)

    # viền tối mảnh theo silhouette
    grown = a.filter(ImageFilter.MaxFilter(3))
    edge = ImageChops.subtract(grown, a)
    outline = Image.new('RGBA', (w, h), (58, 40, 30, 0))
    outline.putalpha(edge.point(lambda v: int(v * 0.55)))

    # bóng đổ mềm dưới chân
    pad = 10
    out = Image.new('RGBA', (w + pad * 2, h + pad * 2), (0, 0, 0, 0))
    sh = Image.new('RGBA', out.size, (0, 0, 0, 0))
    sd = np.zeros((out.height, out.width), np.uint8)
    cy, cx = h + pad - 5, out.width // 2
    ry, rx = 9, int(w * 0.42)
    yy, xx = np.mgrid[0:out.height, 0:out.width]
    m = ((xx - cx) / rx) ** 2 + ((yy - cy) / ry) ** 2
    sd[m < 1] = 90
    sh.putalpha(Image.fromarray(sd).filter(ImageFilter.GaussianBlur(4)))
    out.alpha_composite(sh)
    out.alpha_composite(outline, (pad, pad))
    out.alpha_composite(big, (pad, pad))
    out.save(DST + n + '.png')
    print(n, out.size)
