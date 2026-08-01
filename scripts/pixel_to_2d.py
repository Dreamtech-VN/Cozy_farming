"""Chuyển asset PIXEL-ART sang style 2D vẽ tay cho hợp với asset Lttt.

Game đang trộn hai phong cách: map/nhân vật lấy của Avatar (Lttt) là tranh vẽ
tay, bo mượt, có bóng đổ; còn cây trồng / vật phẩm / nhà cửa lấy từ pack pixel
16px thì cạnh răng cưa, bảng màu phẳng. Đặt cạnh nhau nhìn rất chỏi.

Tool này làm mượt ảnh pixel theo hướng "2D vẽ tay":

  1. **Phóng to bằng nội suy theo cạnh** — phóng NEAREST lên `up`x rồi làm mượt
     bằng median + gaussian nhẹ: giữ hình khối nhưng bỏ bậc thang của pixel.
  2. **Bo alpha** — làm mượt riêng kênh alpha rồi cắt ngưỡng, để viền ngoài
     thành đường cong chứ không phải bậc thang.
  3. **Viền tối mềm** — nở alpha ra vài pixel, tô màu viền, làm mờ rồi đặt dưới
     hình (giống nét viền bút của tranh vẽ tay).
  4. **Đổ bóng trong** — nhân một lớp gradient tối ở nửa dưới cho có khối.
  5. **Bắt sáng** — vệt sáng mềm ở góc trên-trái.
  6. Thu về `scale` lần cỡ gốc bằng LANCZOS rồi trim viền trong suốt.

Dùng:
    python3 scripts/pixel_to_2d.py <vào.png|thư mục> <ra.png|thư mục> [--scale 2]
                                   [--up 8] [--outline 2] [--soft 1.2] [--no-shade]

Ví dụ — chuyển cả bộ icon nông sản pixel sang 2D cỡ gấp đôi:
    python3 scripts/pixel_to_2d.py public/assets/pack2/icons out/icons2d --scale 2
"""
import argparse
import os

from PIL import Image, ImageChops, ImageDraw, ImageFilter


def pixel_to_2d(im: Image.Image, scale: float = 2.0, up: int = 8,
                outline: int = 1, soft: float = 1.2,
                shade: bool = True, outline_color=(38, 26, 20)) -> Image.Image:
    im = im.convert('RGBA')
    if im.getbbox():
        im = im.crop(im.getbbox())
    w0, h0 = im.size

    # 1. phóng NEAREST rồi làm mượt -> mất bậc thang, giữ hình khối
    big = im.resize((w0 * up, h0 * up), Image.NEAREST)
    rgb = big.convert('RGB')
    rgb = rgb.filter(ImageFilter.MedianFilter(max(3, (up // 2) * 2 + 1)))
    rgb = rgb.filter(ImageFilter.GaussianBlur(up * soft / 4))

    # 2. bo alpha: làm mượt rồi cắt ngưỡng cho mép thành đường cong
    alpha = big.getchannel('A').filter(ImageFilter.GaussianBlur(up * soft / 3))
    alpha = alpha.point(lambda v: 255 if v >= 128 else 0)
    alpha = alpha.filter(ImageFilter.GaussianBlur(up / 6))

    body = Image.merge('RGBA', (*rgb.split(), alpha))

    # 3. viền tối mềm đặt dưới hình
    pad = outline * up
    canvas = Image.new('RGBA', (body.width + pad * 2, body.height + pad * 2), (0, 0, 0, 0))
    grown = Image.new('L', canvas.size, 0)
    grown.paste(alpha, (pad, pad))
    grown = grown.filter(ImageFilter.MaxFilter(pad * 2 + 1)).filter(
        ImageFilter.GaussianBlur(pad * 0.8))
    edge = Image.new('RGBA', canvas.size, (*outline_color, 255))
    edge.putalpha(grown.point(lambda v: min(220, int(v * 0.95))))
    canvas.alpha_composite(edge)
    canvas.alpha_composite(body, (pad, pad))

    if shade:
        # 4. tối dần xuống đáy cho có khối
        grad = Image.new('L', canvas.size, 255)
        gd = ImageDraw.Draw(grad)
        for y in range(canvas.height):
            t = y / max(1, canvas.height - 1)
            gd.line([(0, y), (canvas.width, y)], fill=int(255 - 34 * t * t))
        rgb2 = ImageChops.multiply(canvas.convert('RGB'),
                                   Image.merge('RGB', (grad, grad, grad)))
        canvas = Image.merge('RGBA', (*rgb2.split(), canvas.getchannel('A')))

        # 5. bắt sáng mềm góc trên-trái
        gloss = Image.new('L', canvas.size, 0)
        ImageDraw.Draw(gloss).ellipse(
            [-canvas.width * 0.25, -canvas.height * 0.4,
             canvas.width * 0.72, canvas.height * 0.42], fill=64)
        gloss = gloss.filter(ImageFilter.GaussianBlur(canvas.width / 12))
        gloss = ImageChops.multiply(gloss, canvas.getchannel('A'))
        light = Image.new('RGBA', canvas.size, (255, 255, 255, 0))
        light.putalpha(gloss)
        canvas.alpha_composite(light)

    # 6. thu về cỡ đích
    out_w = max(1, round(w0 * scale))
    out_h = max(1, round(h0 * scale))
    canvas = canvas.resize((out_w + outline * 2, out_h + outline * 2), Image.LANCZOS)
    return canvas.crop(canvas.getbbox() or (0, 0, canvas.width, canvas.height))


def main():
    ap = argparse.ArgumentParser(description='Chuyển pixel-art sang style 2D vẽ tay')
    ap.add_argument('src', help='file .png hoặc thư mục')
    ap.add_argument('dst', help='file .png hoặc thư mục')
    ap.add_argument('--scale', type=float, default=2.0, help='cỡ ra so với ảnh gốc (mặc định 2)')
    ap.add_argument('--up', type=int, default=8, help='hệ số phóng khi làm mượt (mặc định 8)')
    ap.add_argument('--outline', type=int, default=1, help='độ dày viền tối, px ảnh gốc')
    ap.add_argument('--soft', type=float, default=1.2, help='độ mượt (1 = vừa, >1 mềm hơn)')
    ap.add_argument('--no-shade', action='store_true', help='không đổ bóng / bắt sáng')
    a = ap.parse_args()

    jobs = []
    if os.path.isdir(a.src):
        os.makedirs(a.dst, exist_ok=True)
        for f in sorted(os.listdir(a.src)):
            if f.lower().endswith('.png'):
                jobs.append((os.path.join(a.src, f), os.path.join(a.dst, f)))
    else:
        os.makedirs(os.path.dirname(a.dst) or '.', exist_ok=True)
        jobs.append((a.src, a.dst))

    for src, dst in jobs:
        out = pixel_to_2d(Image.open(src), a.scale, a.up, a.outline, a.soft,
                          not a.no_shade)
        out.save(dst)
        print(f'{src} -> {dst}  {out.size[0]}x{out.size[1]}')


if __name__ == '__main__':
    main()
