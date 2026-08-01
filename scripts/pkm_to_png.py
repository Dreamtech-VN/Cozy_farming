"""Giải ảnh .pkm (ETC1) của GunPow ra PNG có nền trong suốt.

Client GunPow nén ảnh bằng ETC1 — mỗi ảnh là một cặp file:
  ten.pkm          màu RGB
  ten_alpha.pkm    độ trong suốt (cũng ETC1, lấy kênh đỏ làm alpha)
PIL không đọc được PKM nên đây là decoder ETC1 viết tay.

Format PKM 1.0: 16 byte header
  0..5   'PKM 10'
  6..7   kiểu nén (0 = ETC1_RGB_NO_MIPMAPS)
  8..9   rộng đã bo lên bội số 4   (big-endian)
  10..11 cao đã bo lên bội số 4
  12..13 rộng thật
  14..15 cao thật
rồi tới dữ liệu: mỗi khối 4x4 pixel = 8 byte.

Dùng:
    python3 scripts/pkm_to_png.py <vào.pkm|thư mục> <ra.png|thư mục>

Tự tìm file `_alpha.pkm` đi kèm; không có thì xuất ảnh đục.
"""
import argparse
import os
import struct

from PIL import Image

# bảng modifier của ETC1: mỗi codeword 1 cặp (nhỏ, lớn), dùng cả dấu +/-
ETC1_MOD = [
    (2, 8), (5, 17), (9, 29), (13, 42),
    (18, 60), (24, 80), (33, 106), (47, 183),
]


def _clamp(v: int) -> int:
    return 0 if v < 0 else (255 if v > 255 else v)


def _ext5(v: int) -> int:
    """5 bit -> 8 bit (nhân bản 3 bit cao xuống dưới)."""
    return (v << 3) | (v >> 2)


def _ext4(v: int) -> int:
    return (v << 4) | v


def _s3(v: int) -> int:
    """3 bit có dấu (bù 2)."""
    return v - 8 if v >= 4 else v


def decode_etc1(data: bytes, w: int, h: int) -> bytearray:
    """Giải khối ETC1 ra mảng RGB (w*h*3). w, h là cỡ đã bo bội số 4."""
    out = bytearray(w * h * 3)
    bw, bh = w // 4, h // 4
    pos = 0
    for by in range(bh):
        for bx in range(bw):
            b0, b1, b2, b3, p0, p1, p2, p3 = data[pos:pos + 8]
            pos += 8
            diff = b3 & 0x02
            flip = b3 & 0x01
            if diff:
                r1 = _ext5(b0 >> 3)
                g1 = _ext5(b1 >> 3)
                bl1 = _ext5(b2 >> 3)
                r2 = _ext5(_clamp5((b0 >> 3) + _s3(b0 & 0x07)))
                g2 = _ext5(_clamp5((b1 >> 3) + _s3(b1 & 0x07)))
                bl2 = _ext5(_clamp5((b2 >> 3) + _s3(b2 & 0x07)))
            else:
                r1, g1, bl1 = _ext4(b0 >> 4), _ext4(b1 >> 4), _ext4(b2 >> 4)
                r2, g2, bl2 = _ext4(b0 & 15), _ext4(b1 & 15), _ext4(b2 & 15)
            cw1 = (b3 >> 5) & 0x07
            cw2 = (b3 >> 2) & 0x07

            msb = (p0 << 8) | p1
            lsb = (p2 << 8) | p3
            for x in range(4):
                for y in range(4):
                    i = x * 4 + y                       # ETC1 xếp theo CỘT
                    idx = (((msb >> i) & 1) << 1) | ((lsb >> i) & 1)
                    # nửa nào của khối -> dùng màu gốc + codeword tương ứng
                    second = (y >= 2) if flip else (x >= 2)
                    base = (r2, g2, bl2) if second else (r1, g1, bl1)
                    small, large = ETC1_MOD[cw2 if second else cw1]
                    m = (small, large, -small, -large)[idx]
                    px = (by * 4 + y) * w + (bx * 4 + x)
                    o = px * 3
                    out[o] = _clamp(base[0] + m)
                    out[o + 1] = _clamp(base[1] + m)
                    out[o + 2] = _clamp(base[2] + m)
    return out


def _clamp5(v: int) -> int:
    return 0 if v < 0 else (31 if v > 31 else v)


def read_pkm(path: str) -> Image.Image:
    with open(path, 'rb') as f:
        head = f.read(16)
        if head[:6] != b'PKM 10':
            raise ValueError(f'{path}: không phải PKM 1.0')
        ew, eh, ow, oh = struct.unpack('>HHHH', head[8:16])
        rgb = decode_etc1(f.read(), ew, eh)
    im = Image.frombytes('RGB', (ew, eh), bytes(rgb))
    return im.crop((0, 0, ow, oh))


def load_rgba(path: str) -> Image.Image:
    """Ảnh màu + file _alpha đi kèm (nếu có) -> RGBA."""
    color = read_pkm(path)
    ap = path[:-4] + '_alpha.pkm'
    if os.path.exists(ap):
        a = read_pkm(ap).convert('L')
        if a.size != color.size:
            a = a.resize(color.size, Image.NEAREST)
        out = color.convert('RGBA')
        out.putalpha(a)
        return out
    return color.convert('RGBA')


def main():
    ap = argparse.ArgumentParser(description='Giải ảnh .pkm (ETC1) của GunPow ra PNG')
    ap.add_argument('src', help='file .pkm hoặc thư mục')
    ap.add_argument('dst', help='file .png hoặc thư mục')
    ap.add_argument('--trim', action='store_true', help='cắt bỏ viền trong suốt')
    a = ap.parse_args()

    jobs = []
    if os.path.isdir(a.src):
        os.makedirs(a.dst, exist_ok=True)
        for f in sorted(os.listdir(a.src)):
            if f.endswith('.pkm') and not f.endswith('_alpha.pkm'):
                jobs.append((os.path.join(a.src, f), os.path.join(a.dst, f[:-4] + '.png')))
    else:
        os.makedirs(os.path.dirname(a.dst) or '.', exist_ok=True)
        jobs.append((a.src, a.dst))

    for src, dst in jobs:
        im = load_rgba(src)
        if a.trim and im.getbbox():
            im = im.crop(im.getbbox())
        im.save(dst)
        print(f'{os.path.basename(src)} -> {dst}  {im.size[0]}x{im.size[1]}')


if __name__ == '__main__':
    main()
