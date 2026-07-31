"""Ghép nền map nông trại + map cổng nông trại từ imageMap gốc của Avatar.

APK client (client/android/Avatar-PGaming.apk trong repo Lttt) chứa đủ các
mảnh ảnh của từng map, khác với bản unity chỉ có mảnh đầu tiên:
  - imageMap/25 (6 mảnh -> 2030x520): NÔNG TRẠI. Có sẵn nhà bếp, nhà kho,
    sân rào nuôi thú, hồ cá, đường đất và hàng rào/bụi cây bao quanh.
  - imageMap/26 (3 mảnh -> 1302x466): CỔNG NÔNG TRẠI. Biển "FARM", cửa hàng,
    thảm cỏ và con đường đất chạy ngang mép dưới.
"""
from PIL import Image
import os

APK = '/tmp/claude-0/-home-user-Cozy-farming/b40e10a2-4a20-5fd7-b845-31972e4262c8/scratchpad/apk/assets/hd/imageMap'
DST = 'public/assets/lttt/maps'


def compose(mid):
    d = os.path.join(APK, mid)
    fs = sorted((f for f in os.listdir(d) if f[0].isdigit()), key=lambda f: int(f.split('.')[0]))
    ims = [Image.open(os.path.join(d, f)).convert('RGBA') for f in fs]
    H = max(i.height for i in ims)
    out = Image.new('RGBA', (sum(i.width for i in ims), H), (0, 0, 0, 0))
    x = 0
    for i in ims:
        out.alpha_composite(i, (x, H - i.height))   # các mảnh canh mép dưới
        x += i.width
    return out


def fit(im, w, h):
    """Đưa về đúng cỡ map: thiếu thì kéo dài pixel mép, thừa thì cắt."""
    out = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    out.alpha_composite(im.crop((0, 0, min(w, im.width), min(h, im.height))), (0, 0))
    if im.width < w:
        col = out.crop((im.width - 1, 0, im.width, h))
        for x in range(im.width, w, 1):
            out.paste(col, (x, 0))
    if im.height < h:
        row = out.crop((0, im.height - 1, w, im.height))
        for y in range(im.height, h, 1):
            out.paste(row, (0, y))
    return out


farm = fit(compose('25'), 2032, 528)     # 127 x 33 tile
farm.save(os.path.join(DST, 'farmbg.png'))
print('farmbg', farm.size)

gate = fit(compose('26'), 1312, 464)     # 82 x 29 tile
gate.save(os.path.join(DST, 'farmgate.png'))
print('farmgate', gate.size)
