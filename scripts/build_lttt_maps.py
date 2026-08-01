"""Ghép nền map Avatar (Lttt) từ imageMap trong APK client — ĐÚNG cách client vẽ.

`LoadMap.paintCreateMap` (client unity):

    for i in slices:
        g.drawImage(img[i], x - 1 + num, Hmap * w * hd - img[i].h)
        num += img[i].w - 2

nên các mảnh **chồng nhau 2px** (không phải nối sát nhau như bản ghép cũ), và
ghép xong thì **đáy ảnh trùng đáy lưới ô** của map. Với w = 24, hd = 2 thì mỗi ô
lưới = 48px trên ảnh HD.

Ảnh xuất ra giữ NGUYÊN cỡ gốc (không kéo/cắt cho tròn tile 16px nữa) để toạ độ
trong game khớp 1:1 với data map giải ra từ `a.clazz`
(xem `scripts/decode_lttt_maps.py`).

Chạy: python3 scripts/build_lttt_maps.py [thư mục assets đã giải nén của APK]
"""
import os
import sys

from PIL import Image

APK = (sys.argv[1] if len(sys.argv) > 1 else os.environ.get(
    'APK_ASSETS',
    '/tmp/claude-0/-home-user-Cozy-farming/b40e10a2-4a20-5fd7-b845-31972e4262c8/scratchpad/apk/assets'
)) + '/hd/imageMap'
DST = os.path.join(os.path.dirname(__file__), '..', 'public', 'assets', 'lttt', 'maps')

OVERLAP = 2      # mảnh nối nhau chồng 2px, theo paintCreateMap

# map Avatar -> tên file trong game (danh tính đọc ra từ ảnh, đối chiếu
# T.nameRegion trong client java — xem docs/ASSETS.md)
MAPS = [
    ('25', 'farmbg',   'Nông trại (bếp, kho, sân rào, hồ cá vẽ sẵn)'),
    ('26', 'farmgate', 'Khu Nông Trại (biển FARM, cửa hàng)'),
    ('14', '14',       'Bãi biển (kè đá, tiệm câu)'),
    ('15', '15',       'Hồ câu'),
    ('4',  '4',        'Công viên'),
    ('22', '22',       'Khu nhà ở (dãy nhà 2-3 tầng)'),
    ('24', '24',       'Khu mua sắm (Mỹ Viện, Gift, ATM, thú cưng, Premium, trang sức, Shop)'),
    ('10', '10',       'Khu giải trí (ATM, GAME, nhà hàng, vòng quay, PetRacing)'),
    ('101', '101',     'Trường học (sàn gỗ, kệ sách, quầy sách vở)'),
    ('58',  '58',      'Tiệm thời trang (giá treo quần áo)'),
    ('59',  '59',      'Tiệm quà / trang sức (quầy vàng)'),
    ('104', '104',     'Mỹ viện (gương lớn, quầy trang điểm)'),
    ('105', '105',     'Tiệm thú cưng (tường vân chân thú, lồng thú)'),
]


def compose(mid: str) -> Image.Image:
    d = os.path.join(APK, mid)
    fs = sorted((f for f in os.listdir(d) if f.split('.')[0].isdigit()),
                key=lambda f: int(f.split('.')[0]))
    ims = [Image.open(os.path.join(d, f)).convert('RGBA') for f in fs]
    ov = OVERLAP if len(ims) > 1 else 0
    w = sum(i.width for i in ims) - ov * (len(ims) - 1)
    h = max(i.height for i in ims)
    out = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    x = 0
    for im in ims:
        out.alpha_composite(im, (x, h - im.height))   # các mảnh canh mép dưới
        x += im.width - ov
    return out


if __name__ == '__main__':
    for mid, name, note in MAPS:
        out = compose(mid)
        out.save(os.path.join(DST, f'{name}.png'))
        print(f'{mid:>4} -> {name}.png  {out.size[0]}x{out.size[1]}px '
              f'({out.size[0] / 16:.2f}x{out.size[1] / 16:.2f} tile 16px)  {note}')
