"""Cắt bong bóng chat từ nút chat gốc của repo Lttt.

`hd/iconMenu/chat0.png` (73x73) là cả một cái nút: nền trắng bo góc + viền xám,
bên trong mới là bong bóng thoại xanh CÓ viền bạc và cái đuôi chỉ xuống trái.
Game dùng nút kính riêng nên chỉ cần bong bóng.

Bản cắt cũ loang từ mép vào rồi xoá theo "màu nhạt/xám" nên ăn luôn viền bạc và
một phần đuôi bong bóng -> nhìn lem nhem. Bản này bám theo phần XANH: dựng mặt
nạ pixel xanh, nở ra vài pixel để ôm trọn viền bạc + đuôi, rồi xoá tất cả những
gì nằm ngoài mặt nạ đó.

Chạy: python3 scripts/cut_chat_icon.py <thư mục hd/iconMenu>
"""
import os
import sys

from PIL import Image, ImageFilter

SRC = sys.argv[1] if len(sys.argv) > 1 else 'iconMenu'
DST = os.path.join(os.path.dirname(__file__), '..',
                   'public', 'assets', 'ui', 'pack', 'icon_chat.png')
GROW = 3          # số pixel nở ra để ôm viền bạc quanh bong bóng


def main():
    im = Image.open(os.path.join(SRC, 'chat0.png')).convert('RGBA')
    w, h = im.size
    px = im.load()

    # 1. mặt nạ phần xanh của bong bóng
    mask = Image.new('L', (w, h), 0)
    mp = mask.load()
    for y in range(h):
        for x in range(w):
            r, _g, b, a = px[x, y]
            if a > 40 and b > 120 and b > r + 30:
                mp[x, y] = 255

    # 2. nở mặt nạ ra để lấy cả viền bạc + đuôi
    mask = mask.filter(ImageFilter.MaxFilter(GROW * 2 + 1))

    # 3. ngoài mặt nạ thì xoá sạch (nền trắng + khung nút)
    mp = mask.load()
    for y in range(h):
        for x in range(w):
            if not mp[x, y]:
                px[x, y] = (0, 0, 0, 0)

    im = im.crop(im.getbbox())
    im.save(DST)
    print(f'{DST}  {im.size}')


if __name__ == '__main__':
    main()
