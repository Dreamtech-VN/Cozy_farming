#!/usr/bin/env python3
"""Nướng animation đứng của skin Pack4 thành dải sprite 6 khung.

Skin Pack4 là skeleton Spine thật (có khớp) chứ không phải ảnh chết, nên thay
vì lấy 1 khung tĩnh thì lấy 6 khung đều nhau trong animation 'holdon' rồi xếp
ngang thành dải. Mọi khung cắt theo CÙNG một khung hình bao để lúc chạy không
bị giật nhảy.
"""
import json, os, sys, glob
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from spine_pose import compose, anim_len

FRAMES = 6
HEIGHT = 200
BIG = (0, 0, 1800, 1800)


def strip(folder, name, frames=FRAMES, height=HEIGHT):
    data = json.load(open(os.path.join(folder, name + '.json'), encoding='utf-8'))
    dur = anim_len(data, 'holdon')
    raws = [compose(folder, name, None, 'holdon',
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
    src, dst, keep_json = sys.argv[1], sys.argv[2], sys.argv[3]
    keep = set(json.load(open(keep_json)))
    os.makedirs(dst, exist_ok=True)
    idx = {}
    for j in sorted(glob.glob(f'{src}/**/*.json', recursive=True)):
        name = os.path.basename(j)[:-5]
        sid = name.replace('sbody_', '')
        if sid not in keep:
            continue
        try:
            im, w = strip(os.path.dirname(j), name)
        except Exception as e:
            print('lỗi', sid, e)
            continue
        im.save(f'{dst}/{sid}.webp', 'WEBP', quality=82, method=6)
        idx[sid] = [w, HEIGHT, FRAMES]
    json.dump(idx, open('src/data/skins-p4.json', 'w'), indent=0, sort_keys=True)
    print('xong', len(idx), 'bộ')
