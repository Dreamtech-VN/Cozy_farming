#!/usr/bin/env python3
"""Dựng ảnh tư thế gốc (setup pose) của một bộ Spine trong Pack4.

Pack4 (Anime-Chibi / Tam-Quoc-Chibi) là skeleton Spine 3.x: file .json ghi cây
xương + slot + attachment, mỗi mảnh là một .png rời cùng thư mục. Đọc cây
xương, tính ma trận thế giới cho từng xương rồi vẽ các slot theo đúng thứ tự
là ra hình nhân vật đứng — không cần chạy runtime Spine.
"""
import json, math, os, sys
from PIL import Image
import numpy as np
from scipy import ndimage



def load_atlas(folder, name):
    """Đọc atlas libgdx (.atlas) + ảnh chung -> {tên vùng: ảnh đã cắt}.

    Pack thú cưng của GunPow gói mọi mảnh vào MỘT ảnh và mô tả vị trí trong
    file .atlas, khác Pack4 để ảnh rời. Vùng nào ghi rotate:true là đã xoay 90°
    khi đóng gói, cắt xong phải xoay lại.
    """
    ap = os.path.join(folder, name + '.atlas')
    if not os.path.exists(ap):
        return None
    raw = open(ap, 'rb').read()
    try:
        text = raw.decode('utf-8')
    except UnicodeDecodeError:
        # mấy pet ra sau bị mã hoá atlas bằng XOR khoá 10 byte lặp lại
        # (dò ra bằng cách so với atlas không mã hoá: khoá = cipher ^ plaintext)
        key = bytes([0xb2, 0xba, 0xa3, 0xbf, 0xbe, 0xb0, 0xbc, 0xba, 0xa4, 0xbd])
        text = bytes(c ^ key[i % len(key)] for i, c in enumerate(raw)).decode('utf-8', 'replace')
    lines = text.splitlines()
    page = None
    out = {}
    cur = None
    for ln in lines:
        if not ln.strip():
            continue
        if not ln.startswith(' ') and ':' not in ln:
            if ln.strip().endswith('.png'):
                pp = os.path.join(folder, ln.strip())
                page = Image.open(pp).convert('RGBA') if os.path.exists(pp) else None
                cur = None
            else:
                cur = {'name': ln.strip()}
                out[cur['name']] = cur
            continue
        if cur is None:
            continue
        k, _, v = ln.strip().partition(':')
        cur[k.strip()] = v.strip()
    regs = {}
    for nm, d in out.items():
        if 'xy' not in d or 'size' not in d or page is None:
            continue
        x, y = [int(v) for v in d['xy'].split(',')]
        w, h = [int(v) for v in d['size'].split(',')]
        rot = d.get('rotate', 'false') == 'true'
        if rot:
            im = page.crop((x, y, x + h, y + w)).transpose(Image.ROTATE_90)
        else:
            im = page.crop((x, y, x + w, y + h))
        regs[nm] = im
    return regs


def _val(fr, t, fields, default):
    """Nội suy tuyến tính giá trị của một timeline tại thời điểm t."""
    if not fr:
        return {f: default[i] for i, f in enumerate(fields)}
    fr = sorted(fr, key=lambda k: k.get('time', 0))
    if t <= fr[0].get('time', 0):
        a = b = fr[0]
        u = 0.0
    elif t >= fr[-1].get('time', 0):
        a = b = fr[-1]
        u = 0.0
    else:
        i = 0
        while i + 1 < len(fr) and fr[i + 1].get('time', 0) <= t:
            i += 1
        a, b = fr[i], fr[i + 1]
        t0, t1 = a.get('time', 0), b.get('time', 0)
        u = 0.0 if t1 <= t0 else (t - t0) / (t1 - t0)
        if a.get('curve') == 'stepped':
            u = 0.0
    out = {}
    for i, f in enumerate(fields):
        va = a.get(f, default[i])
        vb = b.get(f, default[i])
        out[f] = va + (vb - va) * u
    return out


def anim_len(data, anim_name):
    """Độ dài (giây) của một animation."""
    a = (data.get('animations') or {}).get(anim_name) or {}
    t = 0.0
    for tl in a.get('bones', {}).values():
        for fr in tl.values():
            t = max(t, max((f.get('time', 0) for f in fr), default=0))
    return t


def anim_pose_at(data, anim_name, t):
    """Tư thế của mọi xương tại thời điểm t trong animation."""
    a = (data.get('animations') or {}).get(anim_name) or {}
    out = {}
    for name, tl in a.get('bones', {}).items():
        d = {}
        r = _val(tl.get('rotate'), t, ('angle',), (0,))
        d['rotate.angle'] = r['angle']
        tr = _val(tl.get('translate'), t, ('x', 'y'), (0, 0))
        d['translate.x'], d['translate.y'] = tr['x'], tr['y']
        sc = _val(tl.get('scale'), t, ('x', 'y'), (1, 1))
        d['scale.x'], d['scale.y'] = sc['x'], sc['y']
        out[name] = d
    return out


def anim_pose(data, anim_name):
    """Giá trị khung hình ĐẦU TIÊN của một animation, theo từng xương.

    Nhiều bộ Spine để vũ khí / cánh tay đúng chỗ trong animation đứng yên chứ
    không phải ở tư thế gốc, nên dựng bằng tư thế gốc là thấy kiếm bay lơ lửng.
    Lấy khung 0 của animation đắp lên tư thế gốc thì mới đúng vị trí.
    """
    anims = data.get('animations') or {}
    a = anims.get(anim_name)
    if a is None:
        for k in ('holdon', 'idle', 'stand', 'wait'):
            if k in anims:
                a = anims[k]
                break
    if a is None and anims:
        a = anims[next(iter(anims))]
    out = {}
    for name, tl in (a or {}).get('bones', {}).items():
        d = {}
        for key, fields in (('rotate', ('angle',)), ('translate', ('x', 'y')),
                            ('scale', ('x', 'y'))):
            fr = tl.get(key)
            if not fr:
                continue
            f0 = min(fr, key=lambda k: k.get('time', 0))
            for f in fields:
                d[f'{key}.{f}'] = f0.get(f, 0 if key != 'scale' else 1)
        out[name] = d
    return out


def anim_slots(data, anim_name):
    """Slot nào dùng mảnh nào ở khung 0 của animation đứng.

    Một bộ thường có sẵn vài kiểu đầu / bàn tay trong cùng skin; animation mới
    là chỗ quyết định lấy cái nào. Không đọc timeline này thì các mảnh chồng
    lên nhau -> thừa mặt, thừa tay.
    """
    anims = data.get('animations') or {}
    a = anims.get(anim_name)
    if a is None:
        for k in ('holdon', 'idle', 'stand', 'wait'):
            if k in anims:
                a = anims[k]
                break
    if a is None and anims:
        a = anims[next(iter(anims))]
    out = {}
    for name, tl in (a or {}).get('slots', {}).items():
        fr = tl.get('attachment')
        if not fr:
            continue
        f0 = min(fr, key=lambda k: k.get('time', 0))
        out[name] = f0.get('name')          # None = ẩn slot
    return out



def _local_of(data):
    """Bảng khai báo xương theo tên, và danh sách con của mỗi xương."""
    by = {b['name']: b for b in data['bones']}
    return by


def solve_ik(data, locals_, order, ik_list, pose):
    """Giải IK 2 xương (Spine) cho chân/tay.

    Pack này dùng IK cho hai chân (target tên jiao_*). Không giải thì bàn chân
    nằm sai chỗ vì animation chỉ dời xương đích chứ không xoay đùi/cẳng.
    Trả về dict {tên xương: góc xoay cục bộ mới}.
    """
    fix = {}
    for c in sorted(ik_list, key=lambda k: k.get('order', 0)):
        chain = c.get('bones') or []
        if len(chain) != 2:
            continue
        pname, cname = chain
        world = world_bones(data, pose, fix)
        if pname not in world or cname not in world or c['target'] not in world:
            continue
        pb, cb = locals_[pname], locals_[cname]
        pw, cw, tw = world[pname], world[cname], world[c['target']]
        # đưa đích về hệ của xương cha (gốc của xương đùi)
        ppname = pb.get('parent')
        ppw = world.get(ppname, [1, 0, 0, 1, 0, 0])
        det = ppw[0] * ppw[3] - ppw[2] * ppw[1]
        if abs(det) < 1e-8:
            continue
        dx, dy = tw[4] - ppw[4], tw[5] - ppw[5]
        tx = (dx * ppw[3] - dy * ppw[2]) / det
        ty = (dy * ppw[0] - dx * ppw[1]) / det
        ox, oy = pb.get('x', 0), pb.get('y', 0)
        tx -= ox; ty -= oy
        l1 = abs(pb.get('length', 0)) * math.hypot(pw[0], pw[1]) / max(1e-6, math.hypot(ppw[0], ppw[1]))
        l1 = abs(pb.get('length', 0))
        l2 = abs(cb.get('length', 0))
        if l1 <= 0 or l2 <= 0:
            continue
        dist = math.hypot(tx, ty)
        dist = max(1e-4, min(dist, l1 + l2 - 1e-4))
        # định lý cosin
        cosang = (dist * dist + l1 * l1 - l2 * l2) / (2 * dist * l1)
        cosang = max(-1.0, min(1.0, cosang))
        a = math.degrees(math.atan2(ty, tx))
        bend = 1 if c.get('bendPositive', True) else -1
        a1 = a - math.degrees(math.acos(cosang)) * bend
        cos2 = (l1 * l1 + l2 * l2 - dist * dist) / (2 * l1 * l2)
        cos2 = max(-1.0, min(1.0, cos2))
        a2 = (180 - math.degrees(math.acos(cos2))) * bend
        fix[pname] = a1 - pb.get('rotation', 0) - pose.get(pname, {}).get('rotate.angle', 0)
        fix[cname] = a2 - cb.get('rotation', 0) - pose.get(cname, {}).get('rotate.angle', 0)
    return fix


def anim_ik(data, anim_name, ik_list):
    """bendPositive ở khung 0 của animation đứng."""
    anims = data.get('animations') or {}
    a = anims.get(anim_name)
    if a is None:
        for k in ('holdon', 'idle', 'stand', 'wait'):
            if k in anims:
                a = anims[k]
                break
    if a is None and anims:
        a = anims[next(iter(anims))]
    tl = (a or {}).get('ik', {})
    out = []
    for c in ik_list:
        c = dict(c)
        fr = tl.get(c['name'])
        if fr:
            f0 = min(fr, key=lambda k: k.get('time', 0))
            if 'bendPositive' in f0:
                c['bendPositive'] = f0['bendPositive']
        out.append(c)
    return out


def world_bones(data, pose=None, extra_rot=None):
    """Ma trận [a, b, c, d, tx, ty] của từng xương."""
    pose = pose or {}
    extra_rot = extra_rot or {}
    out = {}
    for b in data['bones']:
        p = pose.get(b['name'], {})
        rot = math.radians(b.get('rotation', 0) + p.get('rotate.angle', 0)
                           + extra_rot.get(b['name'], 0))
        sx = b.get('scaleX', 1) * p.get('scale.x', 1)
        sy = b.get('scaleY', 1) * p.get('scale.y', 1)
        x = b.get('x', 0) + p.get('translate.x', 0)
        y = b.get('y', 0) + p.get('translate.y', 0)
        la = math.cos(rot) * sx
        lb = math.sin(rot) * sx
        lc = -math.sin(rot) * sy
        ld = math.cos(rot) * sy
        pm = out.get(b.get('parent'))
        if pm is None:
            out[b['name']] = [la, lb, lc, ld, x, y]
        else:
            pa, pb, pc, pd, ptx, pty = pm
            out[b['name']] = [
                pa * la + pc * lb, pb * la + pd * lb,
                pa * lc + pc * ld, pb * lc + pd * ld,
                pa * x + pc * y + ptx, pb * x + pd * y + pty
            ]
    return out


def region_of(skins, slot_name, att_name):
    """Attachment 'region' của slot trong skin default."""
    if isinstance(skins, dict):
        sk = skins.get('default', {})
    else:
        sk = next((s['attachments'] for s in skins if s.get('name') == 'default'), {})
    return (sk.get(slot_name) or {}).get(att_name)



def mesh_world_points(reg, bones, m):
    """Toạ độ thế giới của các đỉnh mesh ở tư thế gốc.

    Mesh không gán trọng số: vertices là [x, y, ...] trong hệ của xương slot.
    Mesh có trọng số: mỗi đỉnh là [số xương, (id xương, x, y, trọng số) * n].
    """
    v = reg['vertices']
    n_uv = len(reg['uvs']) // 2
    pts = []
    if len(v) == n_uv * 2:                       # không trọng số
        a, b, c, d, tx, ty = m
        for i in range(n_uv):
            x, y = v[i * 2], v[i * 2 + 1]
            pts.append((a * x + c * y + tx, b * x + d * y + ty))
        return pts
    order = [bn['name'] for bn in bones['_order']]
    i = 0
    while len(pts) < n_uv:
        cnt = int(v[i]); i += 1
        wx = wy = 0.0
        for _ in range(cnt):
            bi, bx, by, w = int(v[i]), v[i + 1], v[i + 2], v[i + 3]
            i += 4
            a, b, c, d, tx, ty = bones[order[bi]]
            wx += (a * bx + c * by + tx) * w
            wy += (b * bx + d * by + ty) * w
        pts.append((wx, wy))
    return pts


def draw_mesh(canvas, im, reg, pts, PAD):
    """Dán texture lên mesh bằng cách biến đổi affine từng tam giác."""
    from PIL import ImageDraw
    uvs = reg['uvs']
    tris = reg['triangles']
    src = [(uvs[i * 2] * im.width, uvs[i * 2 + 1] * im.height) for i in range(len(uvs) // 2)]
    dst = [(PAD + x, PAD - y) for x, y in pts]
    for t in range(0, len(tris), 3):
        i0, i1, i2 = tris[t], tris[t + 1], tris[t + 2]
        d0, d1, d2 = dst[i0], dst[i1], dst[i2]
        s0, s1, s2 = src[i0], src[i1], src[i2]
        xs = [p[0] for p in (d0, d1, d2)]
        ys = [p[1] for p in (d0, d1, d2)]
        x0, y0 = int(math.floor(min(xs))), int(math.floor(min(ys)))
        w = int(math.ceil(max(xs))) - x0 + 1
        h = int(math.ceil(max(ys))) - y0 + 1
        if w <= 0 or h <= 0 or w > 4000 or h > 4000:
            continue
        # giải hệ để có affine (đích -> nguồn)
        ax, ay = d1[0] - d0[0], d1[1] - d0[1]
        bx, by = d2[0] - d0[0], d2[1] - d0[1]
        det = ax * by - bx * ay
        if abs(det) < 1e-6:
            continue
        ux, uy = s1[0] - s0[0], s1[1] - s0[1]
        vx, vy = s2[0] - s0[0], s2[1] - s0[1]
        a = (ux * by - vx * ay) / det
        b = (vx * ax - ux * bx) / det
        c = (uy * by - vy * ay) / det
        d = (vy * ax - uy * bx) / det
        e = s0[0] - a * d0[0] - b * d0[1]
        f = s0[1] - c * d0[0] - d * d0[1]
        piece = im.transform((w, h), Image.AFFINE,
                             (a, b, a * x0 + b * y0 + e, c, d, c * x0 + d * y0 + f),
                             resample=Image.BILINEAR)
        mask = Image.new('L', (w, h), 0)
        ImageDraw.Draw(mask).polygon([(d0[0] - x0, d0[1] - y0), (d1[0] - x0, d1[1] - y0),
                                      (d2[0] - x0, d2[1] - y0)], fill=255)
        mask = Image.composite(piece.split()[3], Image.new('L', (w, h), 0), mask)
        canvas.paste(piece, (x0, y0), mask)


def drop_floaters(canvas, keep_ratio=0.15, gap_px=2.5):
    """Xoá mảnh nhỏ rời khỏi khối chính (đo bằng liên thông trên kênh alpha).

    Vài bộ xương (đuôi/tai nhiều khớp) có phần trang trí chỉ nằm đúng chỗ nhờ
    animation khác (vd 'attack') còn ở 'wait' vẫn giữ vị trí bind-pose gốc —
    trôi lơ lửng cách hẳn thân chính vài pixel. Mảnh nào nhỏ (< keep_ratio lần
    khối lớn nhất) VÀ cách khối lớn nhất hơn gap_px thì coi là lỗi, xoá đi.
    Mảnh lớn (cánh, đuôi dài...) hoặc mảnh chạm/gần sát thân đều được giữ.
    """
    bbox = canvas.getbbox()
    if not bbox:
        return canvas
    crop = canvas.crop(bbox)
    arr = np.array(crop)
    mask = arr[:, :, 3] > 20
    labeled, n = ndimage.label(mask, structure=np.ones((3, 3), dtype=int))
    if n <= 1:
        return canvas
    sizes = ndimage.sum(mask, labeled, index=range(1, n + 1))
    main_label = int(np.argmax(sizes)) + 1
    main_mask = labeled == main_label
    main_size = sizes[main_label - 1]
    dist_to_main = ndimage.distance_transform_edt(~main_mask)
    changed = False
    for lbl in range(1, n + 1):
        if lbl == main_label:
            continue
        comp_mask = labeled == lbl
        ratio = sizes[lbl - 1] / main_size
        gap = float(dist_to_main[comp_mask].min())
        if ratio < keep_ratio and gap > gap_px:
            arr[comp_mask, 3] = 0
            changed = True
    if not changed:
        return canvas
    out = Image.new('RGBA', canvas.size, (0, 0, 0, 0))
    out.paste(Image.fromarray(arr, 'RGBA'), (bbox[0], bbox[1]))
    return out


def compose(folder, name, max_h=None, anim='holdon', at=None, pad_box=None):
    data = json.load(open(os.path.join(folder, name + '.json'), encoding='utf-8'))
    atlas = load_atlas(folder, name)
    pose = anim_pose_at(data, anim, at) if at is not None else anim_pose(data, anim)
    iks = anim_ik(data, anim, data.get('ik') or [])
    fix = solve_ik(data, _local_of(data), None, iks, pose) if iks else {}
    bones = world_bones(data, pose, fix)
    slot_att = anim_slots(data, anim)
    bones['_order'] = data['bones']
    PAD = 900
    canvas = Image.new('RGBA', (PAD * 2, PAD * 2), (0, 0, 0, 0))
    for slot in data['slots']:
        att = slot_att[slot['name']] if slot['name'] in slot_att else slot.get('attachment')
        if not att:
            continue
        reg = region_of(data['skins'], slot['name'], att) or {}
        kind = reg.get('type', 'region')
        if kind not in ('region', 'mesh', 'weightedmesh', 'skinnedmesh'):
            continue          # bỏ clipping / boundingbox
        path = reg.get('path', att)
        # ảnh mảnh nằm cạnh json, vài bộ lại để trong thư mục con images/
        im = None
        if atlas and path in atlas:
            im = atlas[path]
        else:
            f = os.path.join(folder, path + '.png')
            if not os.path.exists(f):
                f = os.path.join(folder, 'images', path + '.png')
            if not os.path.exists(f):
                continue
            im = Image.open(f).convert('RGBA')
        m = bones.get(slot['bone'])
        if not m:
            continue
        if kind != 'region':
            pts = mesh_world_points(reg, bones, m)
            draw_mesh(canvas, im, reg, pts, PAD)
            continue
        a, b, c, d, tx, ty = m
        rx, ry = reg.get('x', 0), reg.get('y', 0)
        wx = a * rx + c * ry + tx
        wy = b * rx + d * ry + ty
        # góc + tỉ lệ tổng = của xương cộng của attachment
        bone_rot = math.degrees(math.atan2(b, a))
        rot = bone_rot + reg.get('rotation', 0)
        sx = math.hypot(a, b) * reg.get('scaleX', 1)
        sy = math.hypot(c, d) * reg.get('scaleY', 1)
        w = max(1, int(round(reg.get('width', im.width) * sx)))
        h = max(1, int(round(reg.get('height', im.height) * sy)))
        if (w, h) != im.size:
            im = im.resize((w, h), Image.LANCZOS)
        if rot % 360:
            im = im.rotate(rot, resample=Image.BICUBIC, expand=True)
        canvas.alpha_composite(im, (int(round(PAD + wx - im.width / 2)),
                                    int(round(PAD - wy - im.height / 2))))
    canvas = drop_floaters(canvas)
    bb = pad_box or canvas.getbbox()
    if bb:
        canvas = canvas.crop(bb)
    if pad_box:
        return canvas
    if max_h and canvas.height > max_h:
        k = max_h / canvas.height
        canvas = canvas.resize((max(1, int(canvas.width * k)), max_h), Image.LANCZOS)
    return canvas


if __name__ == '__main__':
    folder, name, out = sys.argv[1], sys.argv[2], sys.argv[3]
    mh = int(sys.argv[4]) if len(sys.argv) > 4 else None
    im = compose(folder, name, mh)
    im.save(out)
    print(out, im.size)
