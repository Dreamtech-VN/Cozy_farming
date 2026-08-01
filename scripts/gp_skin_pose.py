#!/usr/bin/env python3
"""Dựng tư thế đứng của skin GunPow từ armature XML + plist.

Mỗi skin trong apk là một bộ xương DragonBones 2.2: file .xml ghi tư thế gốc
(bind pose) của từng xương — vị trí x/y, góc kX, tỉ lệ cX/cY, thứ tự z và tên
mảnh ảnh; file .plist ghi ô cắt của từng mảnh trong sheet .png. Ghép lại theo
đúng thứ tự z là ra hình nhân vật đứng.
"""
import re, sys, os, math
import xml.etree.ElementTree as ET
from PIL import Image


def load_plists(folder):
    """Trả về {tên mảnh: (ảnh sheet, x, y, w, h, xoay)}."""
    out = {}
    for f in os.listdir(folder):
        if not f.endswith('.plist'):
            continue
        png = os.path.join(folder, f[:-6] + '.png')
        if not os.path.exists(png):
            continue
        sheet = Image.open(png).convert('RGBA')
        txt = open(os.path.join(folder, f), encoding='utf-8', errors='ignore').read()
        for m in re.finditer(
                r'<key>([^<]+)\.png</key>\s*<dict>(.*?)</dict>', txt, re.S):
            name, body = m.group(1), m.group(2)
            fr = re.search(r'<key>frame</key>\s*<string>\{\{(-?\d+),(-?\d+)\},\{(\d+),(\d+)\}\}', body)
            if not fr:
                continue
            rot = '<key>rotated</key>\n        <true' in body or '<true/>' in (
                re.search(r'<key>rotated</key>\s*<(\w+)/>', body).group(0)
                if re.search(r'<key>rotated</key>\s*<(\w+)/>', body) else '')
            x, y, w, h = (int(v) for v in fr.groups())
            out[name] = (sheet, x, y, w, h, rot)
    return out


def part(parts, name):
    p = parts.get(name)
    if not p:
        return None
    sheet, x, y, w, h, rot = p
    if rot:
        im = sheet.crop((x, y, x + h, y + w)).transpose(Image.ROTATE_270)
    else:
        im = sheet.crop((x, y, x + w, y + h))
    return im


def compose(folder, xml_name, scale=1.0):
    tree = ET.parse(os.path.join(folder, xml_name))
    arm = tree.find('.//armature')
    parts = load_plists(folder)
    bones = []
    for b in arm.findall('b'):
        d = b.find('d')
        if d is None:
            continue
        bones.append({
            'z': int(b.get('z', 0)),
            'x': float(b.get('x', 0)), 'y': float(b.get('y', 0)),
            'k': float(b.get('kX', 0)),
            'cx': float(b.get('cX', 1)), 'cy': float(b.get('cY', 1)),
            'px': float(b.get('pX', 0)), 'py': float(b.get('pY', 0)),
            'dname': d.get('name'), 'dpx': float(d.get('pX', 0)), 'dpy': float(d.get('pY', 0))
        })
    bones.sort(key=lambda b: b['z'])

    PAD = 400
    canvas = Image.new('RGBA', (PAD * 2, PAD * 2), (0, 0, 0, 0))
    for b in bones:
        im = part(parts, b['dname'])
        if im is None:
            continue
        if abs(b['cx']) != 1 or abs(b['cy']) != 1:
            im = im.resize((max(1, int(im.width * abs(b['cx']))),
                            max(1, int(im.height * abs(b['cy'])))), Image.LANCZOS)
        if b['cx'] < 0:
            im = im.transpose(Image.FLIP_LEFT_RIGHT)
        if b['cy'] < 0:
            im = im.transpose(Image.FLIP_TOP_BOTTOM)
        # toạ độ cocos là y hướng LÊN, ảnh là y hướng XUỐNG -> lật dấu y và góc
        ang = -b['k']
        rad = math.radians(ang)
        dx, dy = b['dpx'], -b['dpy']
        rx = dx * math.cos(rad) - dy * math.sin(rad)
        ry = dx * math.sin(rad) + dy * math.cos(rad)
        if ang % 360:
            im = im.rotate(-ang, resample=Image.BICUBIC, expand=True)
        cx = PAD + b['x'] + rx
        cy = PAD - b['y'] + ry
        canvas.alpha_composite(im, (int(round(cx - im.width / 2)),
                                    int(round(cy - im.height / 2))))
    bb = canvas.getbbox()
    if bb:
        canvas = canvas.crop(bb)
    if scale != 1.0:
        canvas = canvas.resize((max(1, int(canvas.width * scale)),
                                max(1, int(canvas.height * scale))), Image.LANCZOS)
    return canvas


if __name__ == '__main__':
    folder, xml_name, out = sys.argv[1], sys.argv[2], sys.argv[3]
    im = compose(folder, xml_name)
    im.save(out)
    print(out, im.size)
