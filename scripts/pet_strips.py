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
HEIGHT = 96
BIG = (0, 0, 1800, 1800)   # cả khung vẽ, cắt nhỏ hơn là thú bị xén mất


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
    k = height / (y1 - y0)
    w = max(1, round((x1 - x0) * k))
    out = Image.new('RGBA', (w * frames, height))
    for i, im in enumerate(raws):
        out.paste(im.crop((x0, y0, x1, y1)).resize((w, height), Image.LANCZOS), (i * w, 0))
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
