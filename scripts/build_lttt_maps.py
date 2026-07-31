"""Ghép nền TẤT CẢ map Avatar (Lttt) từ imageMap trong APK client.

APK client (client/android/Avatar-PGaming.apk trong repo Lttt) chứa đủ các mảnh
ảnh của từng map, khác với bản unity chỉ có mảnh đầu tiên. Ghép theo thứ tự số,
canh mép **dưới**; file tên chữ (vd daydien0/1/2 của map 10 = dây điện) là lớp
phủ riêng nên bỏ qua.

Bảng dưới là danh tính thật của từng map — đọc ra bằng cách ghép rồi nhìn ảnh,
đối chiếu với `T.nameRegion` trong client java (8 khu: Khu nhà ở, Khu sinh thái,
Sân bay, Khu giải trí, Khu mua sắm, Công viên, Khu ngoại ô, Nông trại).
"""
from PIL import Image
import os

APK = os.environ.get(
    'APK_ASSETS',
    '/tmp/claude-0/-home-user-Cozy-farming/b40e10a2-4a20-5fd7-b845-31972e4262c8/scratchpad/apk/assets'
) + '/hd/imageMap'
DST = os.path.join(os.path.dirname(__file__), '..', 'public', 'assets', 'lttt', 'maps')

# map Avatar -> (tên file, số tile ngang, số tile dọc, ghi chú)
MAPS = [
    ('25', 'farmbg',   127, 33, 'Nông trại (bếp, kho, sân rào, hồ cá vẽ sẵn)'),
    ('26', 'farmgate',  82, 29, 'Khu Nông Trại (biển FARM, cửa hàng)'),
    ('14', '14',        63, 28, 'Bãi biển (kè đá, tiệm câu)'),
    ('15', '15',        63, 24, 'Hồ câu'),
    ('4',  '4',         57, 32, 'Công viên'),
    ('22', '22',       150, 29, 'Khu nhà ở (dãy nhà 2-3 tầng)'),
    ('24', '24',       132, 32, 'Khu mua sắm (Mỹ Viện, Gift, ATM, thú cưng, Premium, trang sức, Shop)'),
    ('10', '10',       126, 32, 'Khu giải trí (ATM, GAME, nhà hàng, PetRacing)'),
    # nội thất
    ('101', '101',      60, 33, 'Trường học (sàn gỗ, kệ sách, quầy sách vở)'),
    ('58',  '58',       36, 33, 'Tiệm thời trang (giá treo quần áo)'),
    ('59',  '59',       36, 33, 'Tiệm quà / trang sức (quầy vàng)'),
    ('104', '104',      54, 33, 'Mỹ viện (gương lớn, quầy trang điểm)'),
    ('105', '105',      42, 33, 'Tiệm thú cưng (tường vân chân thú, lồng thú)'),
]


def compose(mid):
    d = os.path.join(APK, mid)
    fs = sorted((f for f in os.listdir(d) if f.split('.')[0].isdigit()),
                key=lambda f: int(f.split('.')[0]))
    ims = [Image.open(os.path.join(d, f)).convert('RGBA') for f in fs]
    H = max(i.height for i in ims)
    out = Image.new('RGBA', (sum(i.width for i in ims), H), (0, 0, 0, 0))
    x = 0
    for i in ims:
        out.alpha_composite(i, (x, H - i.height))   # các mảnh canh mép dưới
        x += i.width
    return out


def fit(im, w, h):
    """Đưa về đúng cỡ zone: thiếu thì kéo dài pixel mép, thừa thì cắt."""
    out = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    out.alpha_composite(im.crop((0, 0, min(w, im.width), min(h, im.height))), (0, 0))
    if im.width < w:
        col = out.crop((im.width - 1, 0, im.width, h))
        for x in range(im.width, w):
            out.paste(col, (x, 0))
    if im.height < h:
        row = out.crop((0, im.height - 1, w, im.height))
        for y in range(im.height, h):
            out.paste(row, (0, y))
    return out


if __name__ == '__main__':
    for mid, name, tw, th, note in MAPS:
        raw = compose(mid)
        out = fit(raw, tw * 16, th * 16)
        out.save(os.path.join(DST, f'{name}.png'))
        print(f'{mid:>4} -> {name}.png  ghép {raw.size} -> {out.size}  ({tw}x{th} tile)  {note}')
