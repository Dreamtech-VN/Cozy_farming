"""Vẽ icon chat kiểu 2D (bo mượt, có khối) cho hợp với asset vẽ tay của Lttt.

Bản trước vẽ theo lưới pixel 16px rồi phóng NEAREST nên cạnh răng cưa, đứng
cạnh map/nhân vật vẽ tay của Avatar nhìn lệch hẳn. Bản này vẽ ở độ phân giải
cao rồi thu nhỏ bằng LANCZOS: bong bóng bo tròn + đuôi tam giác bo góc, tô
gradient vàng-kem của HUD, viền tối mềm, bắt sáng góc trên-trái và bóng đổ nhẹ
ở đáy — cùng ngôn ngữ hình với icon Avatar.

Chạy: python3 scripts/make_chat_icon.py
"""
import os

from PIL import Image, ImageDraw, ImageFilter

DST = os.path.join(os.path.dirname(__file__), '..',
                   'public', 'assets', 'ui', 'pack', 'icon_chat.png')

SS = 8              # vẽ lớn gấp 8 rồi thu nhỏ cho mượt
OUT = 64            # cỡ icon xuất ra

TOP = (255, 236, 156)      # đỉnh bong bóng
BOTTOM = (240, 163, 24)    # đáy bong bóng
OUTLINE = (92, 58, 12)
DOT = (108, 68, 8)


def bubble_mask(w: int, h: int) -> Image.Image:
    """Mặt nạ bong bóng: thân bo tròn + đuôi chỉ xuống trái."""
    m = Image.new('L', (w, h), 0)
    d = ImageDraw.Draw(m)
    body_h = int(h * 0.76)
    r = int(min(w, body_h) * 0.34)
    d.rounded_rectangle([0, 0, w - 1, body_h], radius=r, fill=255)
    # đuôi: tam giác mềm ở mép dưới bên trái
    x0 = int(w * 0.20)
    d.polygon([(x0, body_h - r // 2), (x0 + int(w * 0.20), body_h - r // 2),
               (int(w * 0.12), h - 1)], fill=255)
    return m.filter(ImageFilter.GaussianBlur(SS * 0.35)).point(
        lambda v: 255 if v > 128 else 0)


def main():
    w = h = OUT * SS
    mask = bubble_mask(w, h)

    # thân: gradient dọc
    grad = Image.new('RGB', (1, h))
    gp = grad.load()
    for y in range(h):
        t = min(1.0, y / (h * 0.78))
        gp[0, y] = tuple(round(TOP[i] + (BOTTOM[i] - TOP[i]) * t) for i in range(3))
    body = grad.resize((w, h)).convert('RGBA')
    body.putalpha(mask)

    # viền tối mềm nằm dưới thân
    grown = mask.filter(ImageFilter.MaxFilter(SS * 2 + 1)).filter(
        ImageFilter.GaussianBlur(SS * 0.9))
    edge = Image.new('RGBA', (w, h), (*OUTLINE, 255))
    edge.putalpha(grown.point(lambda v: min(255, int(v * 1.15))))

    canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    canvas.alpha_composite(edge)
    canvas.alpha_composite(body)

    # 3 chấm thoại
    d = ImageDraw.Draw(canvas)
    cy = int(h * 0.40)
    rr = int(w * 0.045)
    for i in (-1, 0, 1):
        cx = w // 2 + i * int(w * 0.19)
        d.ellipse([cx - rr, cy - rr, cx + rr, cy + rr], fill=(*DOT, 255))

    # bắt sáng mềm góc trên-trái
    gloss = Image.new('L', (w, h), 0)
    ImageDraw.Draw(gloss).ellipse([int(w * 0.08), int(h * 0.06),
                                   int(w * 0.56), int(h * 0.34)], fill=150)
    gloss = gloss.filter(ImageFilter.GaussianBlur(SS * 3))
    gloss = Image.eval(gloss, lambda v: v)
    light = Image.new('RGBA', (w, h), (255, 255, 255, 0))
    from PIL import ImageChops
    light.putalpha(ImageChops.multiply(gloss, mask))
    canvas.alpha_composite(light)

    canvas = canvas.resize((OUT, OUT), Image.LANCZOS)
    canvas = canvas.crop(canvas.getbbox())
    canvas.save(DST)
    print(f'{DST}  {canvas.size}')


if __name__ == '__main__':
    main()
