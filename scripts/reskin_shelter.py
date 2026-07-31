"""Thay tấm quảng cáo trong nhà chờ xe buýt (asset gốc là logo của game khác)
bằng một tấm poster nông trại tự dựng từ sprite pack Cozy.
"""
from PIL import Image, ImageDraw

SRC = 'public/assets/lttt/shelter.png'
PANEL = (16, 30, 216, 100)          # khung tấm biển bên trong nhà chờ

sh = Image.open(SRC).convert('RGBA')
w, h = PANEL[2] - PANEL[0], PANEL[3] - PANEL[1]
poster = Image.new('RGBA', (w, h), (0, 0, 0, 0))
d = ImageDraw.Draw(poster)

# trời chuyển sắc
for y in range(h):
    t = y / h
    d.line([(0, y), (w, y)], fill=(int(150 + 70 * t), int(205 + 35 * t), int(240 - 10 * t)))
# mặt trời
d.ellipse([w - 34, 5, w - 12, 27], fill=(255, 232, 150))
d.ellipse([w - 31, 8, w - 15, 24], fill=(255, 246, 200))
# đồi cỏ
d.ellipse([-30, h - 40, w // 2 + 20, h + 30], fill=(126, 200, 92))
d.ellipse([w // 2 - 30, h - 34, w + 40, h + 34], fill=(108, 186, 78))
d.rectangle([0, h - 16, w, h], fill=(140, 208, 100))
# luống đất
for i in range(5):
    y0 = h - 14 + i * 3
    d.line([(6 + i * 2, y0), (w - 6 - i * 2, y0)], fill=(176, 146, 96))


def paste_fit(name, box_h, pos):
    im = Image.open(name).convert('RGBA')
    bb = im.getbbox()
    if bb:
        im = im.crop(bb)
    k = box_h / im.height
    im = im.resize((max(1, int(im.width * k)), box_h), Image.NEAREST)
    poster.alpha_composite(im, pos)


# hàng rào trắng chạy ngang chân đồi
d.line([(0, h - 20), (w, h - 20)], fill=(246, 244, 232), width=2)
for x in range(4, w, 13):
    d.line([(x, h - 26), (x, h - 15)], fill=(246, 244, 232), width=2)

paste_fit('public/assets/buildings/farm_house.png', 42, (16, h - 56))
paste_fit('public/assets/buildings/farm_barn.png', 32, (w - 62, h - 46))

sh.paste(poster, (PANEL[0], PANEL[1]))
sh.save(SRC)
print('shelter poster ->', poster.size)
