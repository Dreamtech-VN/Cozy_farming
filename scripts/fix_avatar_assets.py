"""Lấy thêm vài asset gốc Avatar (hd/home trong APK) và vá bóng đổ kiểu J2ME.

- 839 xe buýt: ảnh gốc không có kênh alpha thật, bóng dưới gầm xe được vẽ bằng
  lưới caro pixel đen -> phóng to lên trông như bị rỗ. Đổi thành bóng mờ thật.
- 831 cửa hàng, 845 đèn đường: copy nguyên bản.
- mound: đống đất để đào (trước vẽ bằng graphics, trông như cục bùn) -> vẽ lại
  cho ra hình đất tơi có sỏi và cỏ.
"""
from PIL import Image, ImageDraw, ImageFilter
import numpy as np
import os

APK = '/tmp/claude-0/-home-user-Cozy-farming/b40e10a2-4a20-5fd7-b845-31972e4262c8/scratchpad/apk/assets/hd/home'
DITHER = (73, 73, 73)


def undither_shadow(im):
    """Lưới caro màu 73,73,73 -> mảng bóng mờ liền."""
    a = np.array(im)
    r, g, b, al = a[..., 0], a[..., 1], a[..., 2], a[..., 3]
    mask = (r == DITHER[0]) & (g == DITHER[1]) & (b == DITHER[2]) & (al == 255)
    if not mask.any():
        return im
    # ô trống xen kẽ quanh pixel caro cũng thuộc vùng bóng
    m = Image.fromarray((mask * 255).astype(np.uint8))
    region = np.array(m.filter(ImageFilter.MaxFilter(3))) > 0
    region &= (al == 0) | mask                      # không đụng vào thân xe
    a[mask] = 0                                     # xoá pixel caro
    sh = np.zeros(al.shape, np.uint8)
    sh[region] = 110
    sh = np.array(Image.fromarray(sh).filter(ImageFilter.GaussianBlur(2)))
    out = np.array(Image.fromarray(a, 'RGBA'))
    put = (out[..., 3] == 0) & (sh > 0)
    out[put] = np.stack([np.full(sh.shape, 40), np.full(sh.shape, 32),
                         np.full(sh.shape, 26), sh], -1)[put]
    return Image.fromarray(out, 'RGBA')


def crop_trim(path):
    im = Image.open(path).convert('RGBA')
    bb = im.getbbox()
    return im.crop(bb) if bb else im


# ---- xe buýt ----
bus = undither_shadow(Image.open(os.path.join(APK, '839.png')).convert('RGBA'))
bb = bus.getbbox()
bus = bus.crop(bb).transpose(Image.FLIP_LEFT_RIGHT)   # quay phải như mấy xe khác
bus.save('public/assets/vehicles/bus.png')
print('bus', bus.size)

# ---- cửa hàng + đèn đường ----
crop_trim(os.path.join(APK, '831.png')).save('public/assets/lttt/bld/shop_av.png')
crop_trim(os.path.join(APK, '845.png')).save('public/assets/lttt/lamp_hd.png')
print('shop_av / lamp_hd ok')

# ---- đống đất để đào ----
W, H = 48, 28
m = Image.new('RGBA', (W, H), (0, 0, 0, 0))
d = ImageDraw.Draw(m)
d.ellipse([3, H - 10, W - 4, H - 1], fill=(0, 0, 0, 40))               # bóng
# gò đất thấp, mép lởm chởm cho ra "đất mới xới"
d.ellipse([5, 13, W - 6, H - 3], fill=(112, 78, 48, 255))
for x, y, rx, ry in [(13, 14, 7, 5), (24, 11, 9, 6), (35, 14, 7, 5), (30, 15, 6, 5)]:
    d.ellipse([x - rx, y - ry, x + rx, y + ry], fill=(134, 96, 60, 255))
for x, y, rx, ry in [(20, 12, 6, 4), (31, 13, 5, 3)]:
    d.ellipse([x - rx, y - ry, x + rx, y + ry], fill=(158, 118, 76, 255))
# cục đất vụn
for x, y, r in [(11, 20, 2), (19, 22, 2), (28, 20, 2), (37, 21, 2), (24, 17, 2)]:
    d.ellipse([x - r, y - r, x + r, y + r], fill=(88, 60, 38, 255))
# vụn đất văng ra hai bên
for x, y in [(3, H - 4), (7, H - 3), (W - 4, H - 4), (W - 8, H - 3)]:
    d.point((x, y), fill=(104, 72, 46, 255))
# cỏ mọc quanh chân
for x in (6, 40):
    d.line([(x, H - 3), (x - 1, H - 9)], fill=(96, 166, 74, 255), width=2)
    d.line([(x + 2, H - 3), (x + 4, H - 8)], fill=(120, 190, 92, 255), width=2)
m.save('public/assets/farm/mound.png')
print('mound', m.size)

# ---- máng thức ăn: bản cắt cũ dính thêm đống cỏ khô của ô bên dưới ----
for n in ('trough', 'trough_full'):
    f = 'public/assets/lttt/%s.png' % n
    t = Image.open(f).convert('RGBA')
    if t.height > 32:                     # chỉ cắt 1 lần, chạy lại không hỏng
        t.crop((0, 0, t.width, 32)).save(f)
        print(n, '->', (t.width, 32))

# ---- mặt trước băng ghế nhà chờ (vẽ đè lên người ngồi cho ra tư thế ngồi ghế) ----
sh_full = Image.open('public/assets/lttt/shelter.png').convert('RGBA')
sh_full.crop((0, 106, sh_full.width, sh_full.height)).save('public/assets/lttt/shelter_bench.png')
print('shelter_bench', (sh_full.width, sh_full.height - 106))
