"""Bóc khung bong bóng chat của GunPow ra PNG rời.

Khung nằm trong atlas `resources/pack/chat/pack_chat_0.{pkm,plist}` của apk
GunPow (release Pack3) dưới tên `talk_XX.png`. Phần lớn khung là ẢNH ĐỘNG 2
khung hình: atlas để hai khung cách nhau (vd `talk_01` và `talk_13` là cùng một
mẫu, con mèo vẫy đuôi). Script cắt cả hai và lưu thành:

    public/assets/chat/bubble/<id>.png     khung 1
    public/assets/chat/bubble/<id>_b.png   khung 2 (chỉ khung động mới có)

Bảng tên + giá xem `src/data/bubbles.ts`.

Dùng:
    python3 scripts/gp_chat_bubbles.py <thư mục pack/chat> --out public/assets/chat/bubble
"""
import argparse
import os
import plistlib
import re

from PIL import Image

from pkm_to_png import load_rgba

# id trong game -> (khung 1, khung 2 hoặc None nếu là ảnh tĩnh)
PICK: dict[str, tuple[str, str | None]] = {
    # ---- khung trơn (tĩnh) ----
    'b_plain_beige': ('talk_10', None),
    'b_plain_green': ('talk_11', None),
    'b_plain_yellow': ('talk_12', None),
    # ---- thú cưng & hoa lá (động) ----
    'b_cat': ('talk_01', 'talk_13'),
    'b_snowman': ('talk_02', 'talk_14'),
    'b_snowflake': ('talk_03', 'talk_15'),
    'b_bunny': ('talk_04', 'talk_16'),
    'b_frog': ('talk_05', 'talk_17'),
    'b_kitten': ('talk_06', 'talk_18'),
    'b_violet': ('talk_07', 'talk_19'),
    'b_leaf': ('talk_08', 'talk_20'),
    'b_pinkcat': ('talk_34', 'talk_40'),
    'b_sakura_violet': ('talk_35', 'talk_41'),
    'b_chick': ('talk_36', 'talk_42'),
    'b_dolphin': ('talk_37', 'talk_43'),
    'b_dove': ('talk_38', 'talk_44'),
    'b_sakura_red': ('talk_39', 'talk_45'),
    # ---- khung cầu kỳ (động) ----
    'b_wood': ('talk_53', 'talk_54'),
    'b_angel': ('talk_56', 'talk_57'),
    'b_butterfly': ('talk_59', 'talk_60'),
    'b_forest': ('talk_62', 'talk_63'),
    'b_beach': ('talk_65', 'talk_66'),
    'b_ruby': ('talk_71', 'talk_72'),
    'b_royal': ('talk_74', 'talk_75'),
    'b_blossom': ('talk_77', 'talk_78'),
    # ---- hàng hiếm (khung to 170x70) ----
    'b_lotus': ('talk_80', 'talk_81'),
    'b_sword': ('talk_82', None),
    'b_deer': ('talk_83', None),
    'b_aurora': ('talk_84', None),
    'b_mountain': ('talk_87', None),
    'b_galaxy': ('talk_89', None),
    'b_phoenix': ('talk_90', None),
    'b_meteor': ('talk_91', None),
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

    def cut(key: str) -> Image.Image:
        v = frames[f'{key}.png']
        x, y, w, h = _nums(v['textureRect'])
        rot = bool(v.get('textureRotated'))
        im = tex.crop((x, y, x + (h if rot else w), y + (w if rot else h)))
        return im.rotate(-90, expand=True) if rot else im

    for name, (f1, f2) in PICK.items():
        for suffix, key in (('', f1), ('_b', f2)):
            if not key:
                continue
            im = cut(key)
            im.quantize(colors=255, method=Image.FASTOCTREE).save(
                os.path.join(a.out, f'{name}{suffix}.png'), optimize=True)
        print(f'{f1}{"+" + f2 if f2 else ""} -> {name}  {cut(f1).size}')


if __name__ == '__main__':
    main()
