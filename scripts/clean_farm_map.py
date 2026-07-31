"""Dọn nền nông trại: bỏ sạch cây (kể cả mấy khúc gỗ đã chặt) và 2 căn nhà gốc.

Nhà bếp / nhà kho sau đó được đặt lại bằng sprite của pack Cozy trong code
(ZONE_DECOR.farm), nên ở đây chỉ cần xoá phần vẽ sẵn đi và trả lại hàng rào +
thảm cỏ. Dải hàng rào sạch (không cây, không nhà) được lấy ngay trong chính
map rồi lát gương ra nên không lệch màu.

Chạy sau scripts/build_farm_maps.py.
"""
from PIL import Image
import numpy as np

MAP = 'public/assets/lttt/maps/farmbg.png'
im = Image.open(MAP).convert('RGBA')
W, H = im.size

FENCE_BOTTOM = 184           # mép dưới dải hàng rào viền trên
DONOR = (846, 1010)          # đoạn hàng rào + cỏ sạch dùng làm mẫu (không dính tán cây)
BLD = (425, 790)             # bề ngang 2 căn nhà vẽ sẵn
BLD_BOTTOM = 252


def mirror_tile(patch, w, h):
    out = Image.new('RGBA', (w, h))
    fx = patch.transpose(Image.FLIP_LEFT_RIGHT)
    for i, x in enumerate(range(0, w, patch.width)):
        out.paste(fx if i % 2 else patch, (x, 0))
    return out.crop((0, 0, w, h))


# 1. thay cả dải viền trên -> mất hết cây + khúc gỗ đã chặt
band = im.crop((DONOR[0], 0, DONOR[1], FENCE_BOTTOM))
im.paste(mirror_tile(band, W, FENCE_BOTTOM), (0, 0))

# 2. xoá thân 2 căn nhà, trả lại thảm cỏ (mép dưới hoà dần cho khỏi lộ)
gw, gh = BLD[1] - BLD[0], BLD_BOTTOM - FENCE_BOTTOM
grass = mirror_tile(im.crop((DONOR[0], FENCE_BOTTOM, DONOR[1], BLD_BOTTOM)), gw, gh)
FEA = 14
a = np.ones((gh, gw), np.float32)
ramp = np.linspace(1, 0, FEA, dtype=np.float32)
a[-FEA:, :] *= ramp[:, None]
a[:, :FEA] *= ramp[::-1][None, :]
a[:, -FEA:] *= ramp[None, :]
grass.putalpha(Image.fromarray((a * 255).astype(np.uint8)))
im.alpha_composite(grass, (BLD[0], FENCE_BOTTOM))

im.save(MAP)
print('cleaned', im.size)

# ---------------- map cổng: bỏ cây + khúc gỗ, bỏ căn cửa hàng gốc ----------------
GATE = 'public/assets/lttt/maps/farmgate.png'
gm = Image.open(GATE).convert('RGBA')
GW = gm.width
G_BOTTOM = 178                # mép dưới dải hàng rào
G_DONOR = (876, 986)          # đoạn hàng rào sạch (không cây, không trụ cổng)
# giữ lại đúng biển "FARM" (x 350..505), phần còn lại trả về hàng rào trơn
gband = gm.crop((G_DONOR[0], 0, G_DONOR[1], G_BOTTOM))
gm.paste(mirror_tile(gband, 350, G_BOTTOM), (0, 0))
gm.paste(mirror_tile(gband, GW - 505, G_BOTTOM), (505, 0))
gm.save(GATE)
print('gate cleaned', gm.size)
