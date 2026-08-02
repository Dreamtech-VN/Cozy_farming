"""Bóc biểu cảm chat (emoji) của GunPow ra dải sprite dùng cho web.

Trong client GunPow mỗi biểu cảm là một "armature" nhỏ ở
`resources/armatures/chat/faceNNN.*`:
  faceNNN.pkm / faceNNN_alpha.pkm   ảnh ETC1 chứa toàn bộ khung hình
  faceNNN.plist                     vị trí từng khung trong ảnh
  faceNNN.xml                       thứ tự phát + tốc độ (frameRate, dr)

Script gộp các khung theo đúng thứ tự phát thành MỘT dải ngang
(`public/assets/chat/emoji/eNN.png`) để web chạy bằng CSS
`animation: steps(n)` — không cần thư viện armature nào.

Dùng:
    python3 scripts/gp_chat_emoji.py <thư mục armatures/chat> [thư mục khác...] \
        --out public/assets/chat/emoji --ts src/data/emoji.ts

Thư mục đứng sau ghi đè thư mục đứng trước (bản resources_vn đè bản gốc).
"""
import argparse
import os
import plistlib
import re
import xml.etree.ElementTree as ET

from PIL import Image

from pkm_to_png import load_rgba

FRAME_PX = 72          # cỡ mỗi khung sau khi thu nhỏ (đủ nét cho bong bóng chat)


def _nums(s: str) -> list[int]:
    return [int(float(x)) for x in re.findall(r'-?\d+(?:\.\d+)?', s)]


def _tail_num(name: str) -> int:
    m = re.search(r'_(\d+)(?:\.png)?$', name)
    return int(m.group(1)) if m else 0


def read_frames(plist_path: str, tex: Image.Image) -> dict[str, Image.Image]:
    """Cắt mọi khung trong plist ra ảnh rời."""
    d = plistlib.load(open(plist_path, 'rb'))
    out = {}
    for k, v in d['frames'].items():
        x, y, w, h = _nums(v['frame'])
        rot = bool(v.get('rotated'))
        im = tex.crop((x, y, x + (h if rot else w), y + (w if rot else h)))
        if rot:
            im = im.rotate(-90, expand=True)
        out[k] = im
    return out


def anim_order(xml_path: str) -> tuple[list[int], float, str]:
    """(thứ tự khung, số giây một vòng, tên xương chính) đọc từ file xml."""
    root = ET.parse(xml_path).getroot()
    fps = float(root.get('frameRate') or 24)
    mov = root.find('./animations/animation/mov')
    if mov is None:
        return [], 1.0, ''
    # xương chính = xương có nhiều khung hình nhất (mấy xương phụ chỉ 1 hình)
    bones = list(mov.findall('b'))
    if not bones:
        return [], 1.0, ''
    main = max(bones, key=lambda b: len({f.get('dI') for f in b.findall('f')}))
    order, ticks = [], 0
    for f in main.findall('f'):
        di = int(f.get('dI') or 0)
        ticks += int(float(f.get('dr') or 1))
        if not order or order[-1] != di:
            order.append(di)
    total = float(mov.get('dr') or ticks or 1)
    return order, total / fps, main.get('name') or ''


def build_strip(face_dir: str, face: str) -> tuple[Image.Image, int, float, int, int]:
    tex = load_rgba(os.path.join(face_dir, f'{face}.pkm'))
    frames = read_frames(os.path.join(face_dir, f'{face}.plist'), tex)
    # khung của xương chính: tên có dạng <face>_parts-<gì đó>_<số>
    keys = sorted(frames, key=lambda k: _tail_num(k))
    numbered = [k for k in keys if re.search(r'_\d+\.png$', k)]
    if numbered:
        keys = numbered
    order, dur, _ = anim_order(os.path.join(face_dir, f'{face}.xml'))
    if order and max(order) < len(keys):
        keys = [keys[i] for i in order]

    imgs = [frames[k] for k in keys]
    bw = max(i.width for i in imgs)
    bh = max(i.height for i in imgs)
    k = FRAME_PX / max(bw, bh)
    fw, fh = max(1, round(bw * k)), max(1, round(bh * k))
    strip = Image.new('RGBA', (fw * len(imgs), fh), (0, 0, 0, 0))
    for i, im in enumerate(imgs):
        # mọi khung căn giữa (pivot trong xml đều bằng 0)
        im = im.resize((max(1, round(im.width * k)), max(1, round(im.height * k))), Image.LANCZOS)
        strip.paste(im, (i * fw + (fw - im.width) // 2, (fh - im.height) // 2), im)
    return strip, len(imgs), round(dur, 2), fw, fh


def main():
    ap = argparse.ArgumentParser(description='Bóc emoji chat GunPow ra dải sprite')
    ap.add_argument('src', nargs='+', help='thư mục armatures/chat (cái sau đè cái trước)')
    ap.add_argument('--out', default='public/assets/chat/emoji')
    ap.add_argument('--ts', default='src/data/emoji.ts')
    a = ap.parse_args()

    faces: dict[str, str] = {}          # faceNNN -> thư mục dùng
    for d in a.src:
        for f in os.listdir(d):
            if f.endswith('.plist') and f.startswith('face'):
                faces[f[:-6]] = d
    order = sorted(faces, key=lambda s: int(s[4:]))

    os.makedirs(a.out, exist_ok=True)
    rows = []
    for i, face in enumerate(order, 1):
        strip, n, dur, fw, fh = build_strip(faces[face], face)
        name = f'e{i:02d}'
        # 41 dải RGBA 72px là ~3.8MB, giảm còn 255 màu (vẫn giữ alpha) là ~0.7MB
        strip.quantize(colors=255, method=Image.FASTOCTREE).save(
            os.path.join(a.out, f'{name}.png'), optimize=True)
        rows.append((name, n, dur, fw, fh, face))
        print(f'{face} -> {name}.png  {n} khung {fw}x{fh}  {dur}s')

    if a.ts:
        with open(a.ts, 'w', encoding='utf8') as f:
            f.write('// ===== Emoji chat (bóc từ armature chat của GunPow) =====\n')
            f.write('// TỰ SINH bằng scripts/gp_chat_emoji.py — đừng sửa tay.\n')
            f.write('// Mỗi emoji là một dải ngang `frames` khung vuông, chạy bằng CSS steps().\n\n')
            f.write('export interface EmojiDef {\n  id: string;      // mã trong tin nhắn: [e01]\n'
                    '  frames: number;  // số khung trong dải\n  dur: number;     // giây một vòng\n'
                    '  w: number;       // cỡ một khung (px)\n  h: number;\n}\n\n')
            f.write('export const EMOJIS: EmojiDef[] = [\n')
            for name, n, dur, fw, fh, _ in rows:
                f.write(f"  {{ id: '{name}', frames: {n}, dur: {dur}, w: {fw}, h: {fh} }},\n")
            f.write('];\n\n')
            f.write('export const EMOJI_BY_ID: Record<string, EmojiDef> =\n'
                    '  Object.fromEntries(EMOJIS.map(e => [e.id, e]));\n\n')
            f.write("export const emojiUrl = (id: string) => `assets/chat/emoji/${id}.png`;\n\n")
            f.write('// [e01] trong tin nhắn -> emoji; tách chuỗi thành khúc chữ và khúc emoji\n')
            f.write('export const EMOJI_RE = /\\[(e\\d{2})\\]/g;\n')
        print('->', a.ts)


if __name__ == '__main__':
    main()
