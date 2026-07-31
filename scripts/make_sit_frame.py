"""Dựng thêm frame "ngồi ghế" cho toàn bộ part chibi Avatar.

Bộ sprite gốc chỉ có 15 frame và không có tư thế ngồi ghế (frame 4 là ngồi
bệt/quỳ). Nhìn chính diện, người ngồi khác người đứng chủ yếu ở chỗ **đùi bị
thu ngắn lại** (nhìn từ trước nên đùi gần như bị che), thân người vì thế tụt
xuống. Nên frame ngồi ở đây dựng từ frame 0:

  - phần từ hông trở lên: giữ nguyên, đẩy xuống SQUASH px
  - phần chân: nén chiều cao từ LEG_H xuống (LEG_H - SQUASH)

Làm đồng loạt cho mọi part nên các lớp vẫn khớp nhau. Frame mới nằm ở index 15,
sheet rộng ra 960 -> 1024 px.
"""
from PIL import Image
import os

DIR = 'public/assets/chibi'
FW, FH = 64, 96
FOOT = 88          # neo chân trong frame
HIP = 62           # ranh giới hông/chân
LEG_H = FOOT - HIP  # 26
SQUASH = 12        # rút ngắn chân bấy nhiêu px -> chân còn 14px

n = 0
for f in sorted(os.listdir(DIR)):
    if not f.endswith('.png'):
        continue
    p = os.path.join(DIR, f)
    im = Image.open(p).convert('RGBA')
    if im.height != FH:
        continue
    frames = im.width // FW
    if frames >= 16:                       # đã dựng rồi thì thôi
        continue
    base = im.crop((0, 0, FW, FH))         # frame 0 = đứng yên

    sit = Image.new('RGBA', (FW, FH), (0, 0, 0, 0))
    # thân trên tụt xuống
    sit.alpha_composite(base.crop((0, 0, FW, HIP)), (0, SQUASH))
    # chân nén lại
    legs = base.crop((0, HIP, FW, FOOT))
    legs = legs.resize((FW, LEG_H - SQUASH), Image.NEAREST)
    sit.alpha_composite(legs, (0, HIP + SQUASH))
    # phần dưới bàn chân (bóng/đế) giữ nguyên
    sit.alpha_composite(base.crop((0, FOOT, FW, FH)), (0, FOOT))

    out = Image.new('RGBA', ((frames + 1) * FW, FH), (0, 0, 0, 0))
    out.alpha_composite(im, (0, 0))
    out.alpha_composite(sit, (frames * FW, 0))
    out.save(p)
    n += 1

print('đã thêm frame ngồi ghế cho', n, 'part')
