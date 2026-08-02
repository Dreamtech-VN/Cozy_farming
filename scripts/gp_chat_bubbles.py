"""Bóc khung bong bóng chat của GunPow ra PNG rời.

Khung nằm trong atlas `resources/pack/chat/pack_chat_0.{pkm,plist}` của apk
GunPow (release Pack3) dưới tên `talk_XX.png`. Script cắt đúng những khung
được liệt kê ở PICK rồi lưu thành `public/assets/chat/bubble/<id>.png`
(bảng giá + tên tiếng Việt xem `src/data/bubbles.ts`).

Dùng:
    python3 scripts/gp_chat_bubbles.py <thư mục pack/chat> --out public/assets/chat/bubble
"""
import argparse
import os
import plistlib
import re

from PIL import Image

from pkm_to_png import load_rgba

# talk_XX trong atlas -> id dùng trong game (xem src/data/bubbles.ts)
PICK = {
    'talk_10': 'b_plain_beige', 'talk_11': 'b_plain_green', 'talk_12': 'b_plain_yellow',
    'talk_01': 'b_cat', 'talk_02': 'b_snowman', 'talk_03': 'b_snowflake',
    'talk_04': 'b_bunny', 'talk_05': 'b_frog', 'talk_06': 'b_owl',
    'talk_07': 'b_violet', 'talk_08': 'b_leaf',
    'talk_34': 'b_pinkcat', 'talk_35': 'b_sakura_violet', 'talk_36': 'b_chick',
    'talk_37': 'b_dolphin', 'talk_38': 'b_bird', 'talk_39': 'b_sakura_red',
    'talk_53': 'b_wood', 'talk_56': 'b_angel', 'talk_59': 'b_butterfly',
    'talk_62': 'b_forest', 'talk_65': 'b_beach', 'talk_71': 'b_ruby',
    'talk_74': 'b_royal', 'talk_78': 'b_blossom',
    'talk_80': 'b_lotus', 'talk_82': 'b_sword', 'talk_84': 'b_aurora',
    'talk_89': 'b_galaxy', 'talk_90': 'b_phoenix', 'talk_91': 'b_meteor',
}


def _nums(s: str) -> list[int]:
    return [int(x) for x in re.findall(r'-?\d+', s)]


def main():
    ap = argparse.ArgumentParser(description='Bóc khung bong bóng chat GunPow')
    ap.add_argument('src', help='thư mục chứa pack_chat_0.pkm/.plist')
    ap.add_argument('--out', default='public/assets/chat/bubble')
    a = ap.parse_args()

    tex = load_rgba(os.path.join(a.src, 'pack_chat_0.pkm'))
    frames = plistlib.load(open(os.path.join(a.src, 'pack_chat_0.plist'), 'rb'))['frames']
    os.makedirs(a.out, exist_ok=True)
    for key, name in PICK.items():
        v = frames[f'{key}.png']
        x, y, w, h = _nums(v['textureRect'])
        rot = bool(v.get('textureRotated'))
        im = tex.crop((x, y, x + (h if rot else w), y + (w if rot else h)))
        if rot:
            im = im.rotate(-90, expand=True)
        im.quantize(colors=255, method=Image.FASTOCTREE).save(
            os.path.join(a.out, f'{name}.png'), optimize=True)
        print(f'{key} -> {name}.png  {im.size}')


if __name__ == '__main__':
    main()
