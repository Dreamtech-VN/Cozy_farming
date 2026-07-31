"""Thay tấm quảng cáo trong nhà chờ xe buýt (asset gốc là logo của game khác)
bằng poster mang logo Sunny Town.
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
    d.line([(0, y), (w, y)], fill=(int(168 + 60 * t), int(214 + 30 * t), int(244 - 8 * t)))
# mặt trời góc phải
d.ellipse([w - 34, 5, w - 12, 27], fill=(255, 236, 168))
d.ellipse([w - 31, 8, w - 15, 24], fill=(255, 248, 214))
# dải cỏ mỏng dưới chân biển
d.ellipse([-40, h - 20, w // 2 + 30, h + 26], fill=(140, 206, 104))
d.ellipse([w // 2 - 40, h - 17, w + 50, h + 30], fill=(122, 194, 88))
d.rectangle([0, h - 9, w, h], fill=(150, 212, 112))

# logo game giữa tấm biển
logo = Image.open('public/assets/ui/logo.png').convert('RGBA')
k = min((w - 22) / logo.width, (h - 10) / logo.height)
logo = logo.resize((max(1, int(logo.width * k)), max(1, int(logo.height * k))), Image.LANCZOS)
poster.alpha_composite(logo, ((w - logo.width) // 2, (h - logo.height) // 2 - 3))

sh.paste(poster, (PANEL[0], PANEL[1]))
sh.save(SRC)
print('shelter poster ->', poster.size)
