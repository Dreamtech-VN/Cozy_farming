"""Giải mã data map gốc của Lttt để lấy ĐÚNG lưới đi được + cổng + trạm buýt.

Toàn bộ map của Avatar nằm trong `client/java/resources/a.clazz` — một FilePack
(xem `avt/FilePack.java`): 1 byte số file, rồi mỗi file là [1 byte độ dài tên]
[tên][2 byte độ dài data], cuối cùng là toàn bộ data nối lại. Tên và data đều bị
XOR với khoá "NguyenVanMinh".

Mỗi file tên "<index>" là lưới ô của map `index`, đọc theo `LoadMap.setMap`:
  wMap = số byte / Hmap        (Hmap tra theo bảng switch trong LoadMap.load)
  ô (c, r) = byte thứ r*wMap + c, giá trị là MÃ Ô

Mã ô -> `type[]` (LoadMap.setMap), rồi đi được hay không theo LoadMap.findPath:
  đi được  <=> type == 80 || type == 51 || setTypeJoint(type)
Một số mã còn là mốc chức năng:
  139         = TRẠM XE BUÝT   (LoadMap: `Bus.posBusStop = ...`)
  130..138, 153, 140 = cửa vào / điểm dịch chuyển (đều gọi `setPopup` -> nhãn "vào")

Ảnh nền `imageMap/<index>/*.png` ghép ngang, **các mảnh chồng nhau 2px**
(`paintCreateMap`: `num += img.w - 2`), và ghép xong thì **đáy ảnh trùng đáy
lưới** (`drawImage(..., Hmap * w * hd - img.h)`), với w = 24 và hd = 2 nên mỗi ô
lưới = 48px trên ảnh.

Chạy: python3 scripts/decode_lttt_maps.py <a.clazz> <thư mục imageMap> [ra.json]
"""
import json
import os
import struct
import sys

KEY = b'NguyenVanMinh'
TILE = 48           # 1 ô lưới Lttt = 24 (w) * 2 (hd) px trên ảnh HD

# Hmap theo switch trong LoadMap.load của client unity (bản mới nhất)
HMAP_SPECIAL = {25: 7, 21: 7, 9: 8, 60: 5, 61: 5, 65: 5, 18: 10, 17: 6,
                107: 16, 19: 13, 10: 9}
HMAP_11 = {20, 57, 58, 59, 62, 63, 64, 100, 101, 103, 104, 108, 109}

BUS_STOP = 139      # ô trạm xe buýt (LoadMap đặt Bus.posBusStop ở đây)
WAIT_SPOT = 152     # dải ô ngay trên trạm = chỗ đứng chờ xe
DOOR_CODES = set(range(130, 139)) | {140, 153}
# Mã >= 127 (trừ trạm/chỗ chờ) là MẶT TIỀN công trình: mỗi dải ô cùng mã là một
# cửa vào, client gắn popup "vào" lên giữa dải đó (LoadMap.setPopup).
FRONT_MIN = 127


def hmap_of(typemap: int) -> int:
    if typemap in HMAP_SPECIAL:
        return HMAP_SPECIAL[typemap]
    if typemap in HMAP_11:
        return 11
    return 8


def unpack(path: str) -> dict[str, bytes]:
    data = open(path, 'rb').read()

    def dec(b: bytes) -> bytes:
        return bytes(c ^ KEY[i % len(KEY)] for i, c in enumerate(b))

    p = 0
    n = data[p]
    p += 1
    entries = []
    for _ in range(n):
        ln = data[p]
        p += 1
        name = dec(data[p:p + ln]).decode('latin1')
        p += ln
        flen = struct.unpack('>H', data[p:p + 2])[0]
        p += 2
        entries.append((name, flen))
    body = dec(data[p:])
    out, off = {}, 0
    for name, flen in entries:
        out[name] = body[off:off + flen]
        off += flen
    return out


def type_of(code: int) -> int:
    """Mã ô -> type, chép nguyên nhánh mặc định của LoadMap.setMap."""
    if code == 255:
        return 88
    if 120 <= code <= 123 or 114 <= code <= 119:
        t = 80
    elif code in (67, 85):
        t = 92
    elif 20 <= code <= 23:
        t = 79
    elif code < 7:
        t = 80
    else:
        t = 88
    if 44 <= code <= 55:
        t = 80
    if code == 62:
        t = 56
    if code in (111, 112):
        t = 80
    return t


JOINT = {-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 21,
         24, 25, 51, 52, 53, 56, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 95, 96,
         110, 111, 112}


def walkable(code: int) -> bool:
    t = type_of(code)
    return t == 80 or t == 51 or t in JOINT


def runs(grid, wm, hm, pred, by_code=False):
    """Gom các ô liền nhau theo hàng thành dải [x, y, dài, mã]."""
    out = []
    for r in range(hm):
        c = 0
        while c < wm:
            v = grid[r][c]
            if not pred(v):
                c += 1
                continue
            c2 = c
            while c2 + 1 < wm and grid[r][c2 + 1] == v:
                c2 += 1
            out.append([c, r, c2 - c + 1, v] if by_code else [c, r, c2 - c + 1])
            c = c2 + 1
    return out


def image_size(mapdir: str, index: int):
    from PIL import Image
    d = os.path.join(mapdir, str(index))
    if not os.path.isdir(d):
        return None
    fs = sorted((x for x in os.listdir(d) if x.split('.')[0].isdigit()),
                key=lambda x: int(x.split('.')[0]))
    ims = [Image.open(os.path.join(d, x)) for x in fs]
    if not ims:
        return None
    ov = 2 if len(ims) > 1 else 0
    return (sum(i.width for i in ims) - ov * (len(ims) - 1),
            max(i.height for i in ims), len(ims))


def decode(files: dict[str, bytes], mapdir: str) -> dict:
    out = {}
    for name, raw in files.items():
        if not name.isdigit():
            continue
        index = int(name)
        img = image_size(mapdir, index)
        if not img:
            continue
        imgw, imgh, _n = img
        hm = hmap_of(index - 1)
        wm = round(imgw / TILE)
        # map nào lưới không khớp ảnh (nông trại dùng màn riêng, map đua xe đổi
        # cỡ ô) thì bỏ qua, đừng đoán bừa
        if wm <= 0 or len(raw) != wm * hm:
            continue
        grid = [[raw[r * wm + c] for c in range(wm)] for r in range(hm)]
        mask = [''.join('.' if walkable(grid[r][c]) else '#' for c in range(wm))
                for r in range(hm)]
        doors = [[c, r] for r in range(hm) for c in range(wm)
                 if grid[r][c] in DOOR_CODES]
        bus = runs(grid, wm, hm, lambda v: v == BUS_STOP)
        wait = runs(grid, wm, hm, lambda v: v == WAIT_SPOT)
        fronts = runs(grid, wm, hm,
                      lambda v: v >= FRONT_MIN and v not in (BUS_STOP, WAIT_SPOT, 255),
                      by_code=True)
        out[str(index)] = {
            'w': wm, 'h': hm, 'tile': TILE,
            'img': [imgw, imgh],
            # ảnh cao hơn lưới: phần dư là cảnh vẽ phía trên, lưới nằm ở đáy ảnh
            'gridTopPx': imgh - hm * TILE,
            'walk': mask, 'doors': doors,
            'busStop': bus, 'wait': wait, 'fronts': fronts,
        }
    return out


if __name__ == '__main__':
    clazz = sys.argv[1] if len(sys.argv) > 1 else 'a.clazz'
    mapdir = sys.argv[2] if len(sys.argv) > 2 else 'imageMap'
    dst = sys.argv[3] if len(sys.argv) > 3 else os.path.join(
        os.path.dirname(__file__), '..', 'src', 'data', 'lttt-maps.json')
    res = decode(unpack(clazz), mapdir)
    json.dump(res, open(dst, 'w'), ensure_ascii=False, indent=0)
    print(f'{len(res)} map -> {dst}')
    for k, v in sorted(res.items(), key=lambda kv: int(kv[0])):
        print(f"  map {k:>4}  {v['w']}x{v['h']} ô  ảnh {v['img'][0]}x{v['img'][1]}"
              f"  lưới y0={v['gridTopPx']}  mặt tiền {len(v['fronts'])}"
              f"  buýt {len(v['busStop'])}  chỗ chờ {len(v['wait'])}")
