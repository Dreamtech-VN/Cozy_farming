"""Vẽ icon chat riêng cho game, hợp với style icon còn lại.

Bản cũ cắt từ nút chat của Lttt (`hd/iconMenu/chat0.png`): bong bóng xanh dương
viền bạc, đứng cạnh mấy icon vàng-kem của HUD nhìn rất lạc. Icon này vẽ lại theo
đúng ngôn ngữ hình của bộ icon trong game:

  - khối pixel vuông vắn, vẽ ở lưới 16px rồi phóng NEAREST lên 64px
  - tô 2 tông (sáng ở trên, đậm ở dưới) + vệt sáng góc trên-trái
  - viền tối `#26261a` dày 1 pixel-gốc, bo góc
  - màu kem-vàng của HUD (`#ffe066` -> `#f0a318`) cho ăn với nút Menu/Biểu cảm

Chạy: python3 scripts/make_chat_icon.py
"""
import os

from PIL import Image

DST = os.path.join(os.path.dirname(__file__), '..',
                   'public', 'assets', 'ui', 'pack', 'icon_chat.png')

N = 16          # lưới gốc
SCALE = 4       # 16 -> 64px

OUTLINE = (38, 30, 18, 255)
LIGHT = (255, 233, 138, 255)     # nửa trên bong bóng
DARK = (240, 163, 24, 255)       # nửa dưới
GLOSS = (255, 253, 232, 255)     # vệt sáng
DOT = (74, 48, 5, 255)           # 3 chấm thoại

# 16x16: . trong suốt · o viền · L sáng · D đậm · G vệt sáng · P chấm
ART = [
    '................',
    '...oooooooooo...',
    '..oLLLLLLLLLLo..',
    '.oLLLLLLLLLLLLo.',
    'oLGGLLLLLLLLLLLo',
    'oLGGLLLLLLLLLLLo',
    'oLLLLLLLLLLLLLLo',
    'oLLLLLPLLPLLPLLo',
    'oDDDDDPDDPDDPDDo',
    'oDDDDDDDDDDDDDDo',
    'oDDDDDDDDDDDDDDo',
    '.oDDDDDDDDDDDDo.',
    '..oDDDDDDDDDDo..',
    '..oDDDoooooooo..',
    '...oDoo.........',
    '....o...........',
]

COLORS = {'o': OUTLINE, 'L': LIGHT, 'D': DARK, 'G': GLOSS, 'P': DOT}


def main():
    im = Image.new('RGBA', (N, N), (0, 0, 0, 0))
    px = im.load()
    for y, row in enumerate(ART):
        for x, ch in enumerate(row):
            if ch in COLORS:
                px[x, y] = COLORS[ch]
    im = im.resize((N * SCALE, N * SCALE), Image.NEAREST)
    im = im.crop(im.getbbox())
    im.save(DST)
    print(f'{DST}  {im.size}')


if __name__ == '__main__':
    main()
