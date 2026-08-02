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
import json
import os
import plistlib
import re

import numpy as np
from PIL import Image, ImageFilter

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
    # ---- khung lễ hội / còn lại trong atlas (bán bằng xu) ----
    'b_tet_open': ('talk_hb_1', None),
    'b_tet_tiger': ('talk_hb_2', None),
    'b_tet_star': ('talk_hb_3', None),
    'b_tet_rich': ('talk_hb_5', None),
    'b_tet_blessing': ('talk_hb_6', None),
    'b_tet_dragon': ('talk_hb_7', None),
    'b_tet_gold': ('talk_hb_8', None),
    'b_ink': ('talk_85', None),
    'b_lantern': ('talk_96', None),
    'b_soccer': ('talk_102', None),
    'b_plain_frame': ('talk_xz', None),
}


def _nums(s: str) -> list[int]:
    return [int(x) for x in re.findall(r'-?\d+', s)]


def auto_slice(im: Image.Image, band: int = 4) -> list[int]:
    """Lát cắt 9 ô cho một khung: [trên, phải, dưới, trái].

    Hoa văn của khung (con mèo, cụm hoa, mũi nhọn) trải gần hết CHIỀU CAO ảnh.
    Cắt lát mỏng thì hoa văn rơi vào dải cạnh rồi bị kéo giãn theo chiều cao
    bong bóng — nhìn méo hẳn. Nên chiều dọc chỉ chừa đúng một dải mỏng ở chỗ
    ảnh ít đổi nhất (ruột khung) để co giãn, hoa văn nằm trọn trong 4 góc.

    Chiều ngang thì ngược lại: hoa văn nằm ở hai ĐẦU nên chỉ cần lát vừa phải
    (~29% bề ngang), chừa ruột rộng để bong bóng dài ra mà không phình viền.
    """
    a = np.asarray(im.convert('RGBA')).astype(float)
    h, w, _ = a.shape
    dy = np.abs(np.diff(a, axis=0)).mean(axis=(1, 2))
    lo, hi = int(h * 0.30), int(h * 0.70)
    y = lo + int(np.argmin(dy[lo:hi]))
    side = round(w * 0.29)
    return [max(2, y - band // 2), side, max(2, h - (y + band // 2)), side]


def main():
    ap = argparse.ArgumentParser(description='Bóc khung bong bóng chat GunPow')
    ap.add_argument('src', help='thư mục chứa pack_chat_0.pkm/.plist')
    ap.add_argument('--out', default='public/assets/chat/bubble')
    ap.add_argument('--slices', default='src/data/bubble-slices.json')
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

    slices: dict[str, list[int]] = {}
    for name, (f1, f2) in PICK.items():
        for suffix, key in (('', f1), ('_b', f2)):
            if not key:
                continue
            # Ảnh gốc chỉ 139x65 mà màn điện thoại DPR 2-3 nên trình duyệt phóng
            # to lên -> khung nhìn mờ. Xuất sẵn bản 2x (LANCZOS + nét lại) cho đủ
            # điểm ảnh; cỡ hiển thị không đổi vì lát cắt trong bubbles.ts cũng x2.
            im = cut(key)
            im = im.resize((im.width * 2, im.height * 2), Image.LANCZOS)
            im = im.filter(ImageFilter.UnsharpMask(radius=1.2, percent=60, threshold=2))
            im.quantize(colors=255, method=Image.FASTOCTREE).save(
                os.path.join(a.out, f'{name}{suffix}.png'), optimize=True)
            if not suffix:
                slices[name] = auto_slice(im)
        print(f'{f1}{"+" + f2 if f2 else ""} -> {name}  {cut(f1).size} (xuất 2x)  lát {slices[name]}')

    if a.slices:
        with open(a.slices, 'w', encoding='utf8') as f:
            json.dump(slices, f, indent=0, sort_keys=True)
        print('->', a.slices)


if __name__ == '__main__':
    main()
