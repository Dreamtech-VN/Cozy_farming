"""Cắt icon cần câu ra từ CHÍNH part cần câu đang dùng trong game.

Trước đây icon cần câu ở shop / thanh nông cụ lấy của Cozy Fishing Pack, còn
cái cần cầm trên tay lại là part Avatar — nhìn hai kiểu khác nhau, mua "cần câu
tre" mà icon lại là cái cần gỗ của pack khác.

Bản này lấy đúng 3 part cần của Lttt trong `public/assets/chibi/`:
  442 cần câu tre · 445 cần câu sắt · 446 cần câu VIP
mỗi part là strip 15 frame 64x96. Frame 0 là tư thế đứng — cắt riêng vùng cần
(bỏ phần tay/thân dính vào), xoay cho nằm chéo đẹp trong ô vuông, rồi ghép 3
bậc thành sheet `assets/fishing/rods.png` (3 ô 32x32) + `rod.png` (ô đầu).

Chạy: python3 scripts/make_rod_icons.py
"""
import os

from PIL import Image, ImageFilter

ROOT = os.path.join(os.path.dirname(__file__), '..')
SRC = os.path.join(ROOT, 'public', 'assets', 'chibi')
DST = os.path.join(ROOT, 'public', 'assets', 'fishing')

RODS = [442, 445, 446]     # tre / sắt / VIP
CELL = 32                  # cỡ ô icon xuất ra
FRAME_W, FRAME_H = 64, 96


def rod_art(part_id: int) -> Image.Image:
    """Lấy hình cái cần ở frame 0, trim sạch nền."""
    strip = Image.open(os.path.join(SRC, f'{part_id}.png')).convert('RGBA')
    fr = strip.crop((0, 0, FRAME_W, FRAME_H))
    bb = fr.getbbox()
    if not bb:
        raise SystemExit(f'part {part_id} rỗng')
    return fr.crop(bb)


def outline(im: Image.Image, color=(250, 244, 226, 235)) -> Image.Image:
    """Viền sáng 1px quanh cần — cần tre màu ô-liu rất tối, đặt trên nền kính
    xanh là gần như mất tăm nếu không có viền."""
    pad = 1
    big = Image.new('RGBA', (im.width + pad * 2, im.height + pad * 2), (0, 0, 0, 0))
    big.alpha_composite(im, (pad, pad))
    a = big.getchannel('A').point(lambda v: 255 if v > 60 else 0)
    grown = a.filter(ImageFilter.MaxFilter(3))
    ring = Image.new('RGBA', big.size, color)
    ring.putalpha(Image.eval(grown, lambda v: v).point(lambda v: v))
    out = Image.new('RGBA', big.size, (0, 0, 0, 0))
    out.alpha_composite(ring)
    out.alpha_composite(big)
    return out


def fit(im: Image.Image, box: int, pad: int = 3) -> Image.Image:
    """Phóng ảnh cho vừa ô vuông, giữ nét pixel, canh giữa."""
    avail = box - pad * 2
    k = max(1, min(avail // max(1, im.width), avail // max(1, im.height)))
    if im.width * k > avail or im.height * k > avail:
        k = 1
    big = im.resize((im.width * k, im.height * k), Image.NEAREST)
    if big.width > avail or big.height > avail:
        s = min(avail / big.width, avail / big.height)
        big = big.resize((max(1, round(big.width * s)), max(1, round(big.height * s))), Image.LANCZOS)
    out = Image.new('RGBA', (box, box), (0, 0, 0, 0))
    out.alpha_composite(big, ((box - big.width) // 2, (box - big.height) // 2))
    return out


def main():
    os.makedirs(DST, exist_ok=True)
    sheet = Image.new('RGBA', (CELL * len(RODS), CELL), (0, 0, 0, 0))
    for i, pid in enumerate(RODS):
        art = rod_art(pid)
        sheet.alpha_composite(fit(outline(art), CELL), (i * CELL, 0))
        print(f'part {pid}: {art.size[0]}x{art.size[1]} -> ô {i}')
    sheet.save(os.path.join(DST, 'rods.png'))
    sheet.crop((0, 0, CELL, CELL)).save(os.path.join(DST, 'rod.png'))
    print('->', os.path.join(DST, 'rods.png'), sheet.size)


if __name__ == '__main__':
    main()
