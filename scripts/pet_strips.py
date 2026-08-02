#!/usr/bin/env python3
"""Nướng thú cưng GunPow (Spine + atlas) thành dải sprite 4 khung.

Mỗi thú trong apk là một skeleton Spine: pet_XXXX.json mô tả xương, .atlas mô
tả vị trí từng mảnh trong ảnh chung, .pkm là ảnh (đã giải mã sang .png sẵn).
Lấy 4 khung đều nhau trong animation 'wait' — thú đứng thở/vẫy đuôi.
"""
import json, os, sys, glob
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from spine_pose import compose, anim_len

FRAMES = 4
HEIGHT = 110        # chiều cao khung ảnh
BODY = 78            # chiều cao THÂN thú trong khung — mọi con cao bằng nhau
FOOT_PAD = 5         # chừa dưới chân vài pixel
BIG = (0, 0, 1800, 1800)   # cả khung vẽ, cắt nhỏ hơn là thú bị xén mất


def body_box(im):
    """Khung của phần THÂN, bỏ qua cánh/đuôi dài thò ra hai bên.

    Chỉ soi dải cột giữa (40% bề ngang quanh trọng tâm) nên con nào cánh dang
    rộng hay đuôi dài cũng không kéo dài khung — đo được thân thú thật, giống
    cách p4_strips.py chuẩn hoá chiều cao skin.
    """
    a = im.split()[3]
    w, h = im.size
    px = a.load()
    cols = [x for x in range(w) if any(px[x, y] > 60 for y in range(0, h, 2))]
    if not cols:
        return im.getbbox()
    cx = sum(cols) / len(cols)
    half = max(6, int(w * 0.20))
    x0, x1 = max(0, int(cx - half)), min(w, int(cx + half))
    rows = [y for y in range(h) if any(px[x, y] > 60 for x in range(x0, x1))]
    if not rows:
        return im.getbbox()
    return (x0, rows[0], x1, rows[-1] + 1)


def strip(folder, name, frames=FRAMES, height=HEIGHT, anim='wait'):
    data = json.load(open(os.path.join(folder, name + '.json'), encoding='utf-8'))
    if anim not in (data.get('animations') or {}):
        anim = next(iter(data.get('animations') or {'wait': None}))
    dur = anim_len(data, anim)
    raws = [compose(folder, name, None, anim,
                    at=(dur * i / frames if dur else None), pad_box=BIG)
            for i in range(frames)]
    boxes = [im.getbbox() for im in raws if im.getbbox()]
    if not boxes:
        raise ValueError('rỗng')
    x0 = min(b[0] for b in boxes); y0 = min(b[1] for b in boxes)
    x1 = max(b[2] for b in boxes); y1 = max(b[3] for b in boxes)

    # tỉ lệ tính theo chiều cao THÂN của khung đầu -> mọi con cao bằng nhau
    bb = body_box(raws[0])
    k = BODY / max(1, bb[3] - bb[1])
    foot = bb[3]                     # đáy thân (chỗ chạm đất)
    cx = (bb[0] + bb[2]) / 2         # trục dọc thân

    full_w = max(x1 - x0, 1)
    w = max(1, round(full_w * k))
    out = Image.new('RGBA', (w * frames, height))
    for i, im in enumerate(raws):
        sc = im.resize((max(1, round(im.width * k)), max(1, round(im.height * k))), Image.LANCZOS)
        # chân chạm đáy khung, thân nằm giữa theo chiều ngang
        ox = round(w / 2 - cx * k)
        oy = round(height - FOOT_PAD - foot * k)
        out.paste(sc, (i * w + ox, oy), sc)
    return out, w


if __name__ == '__main__':
    src, dst, out_json = sys.argv[1], sys.argv[2], sys.argv[3]
    os.makedirs(dst, exist_ok=True)
    idx = {}
    for j in sorted(glob.glob(f'{src}/*.json')):
        name = os.path.basename(j)[:-5]
        try:
            im, w = strip(os.path.dirname(j), name)
        except Exception as e:
            print('lỗi', name, e)
            continue
        sid = name.replace('pet_', '')
        im.save(f'{dst}/{sid}.webp', 'WEBP', quality=88, method=6)
        idx[sid] = [w, HEIGHT, FRAMES]
    json.dump(idx, open(out_json, 'w'), indent=0, sort_keys=True)
    print('xong', len(idx), 'thú')
