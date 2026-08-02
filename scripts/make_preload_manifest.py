"""Lập danh sách tài nguyên để tải hết ngay ở màn chờ đầu game.

Game vốn tải lắt nhắt: Phaser nạp sprite của cảnh, còn ảnh DOM (emoji, khung
chat, skin, icon...) đợi mở bảng nào mới tải bảng đó — vào game hay bị khựng
hoặc thấy ảnh nhảy vào sau. Script quét `public/assets`, bỏ mấy file chỉ dùng
làm NGUỒN cắt (sheet gốc, ảnh chưa chuyển style) rồi ghi ra
`src/data/preload-manifest.json` dạng [đường dẫn, số byte] để màn chờ tải sạch
một lượt và hiện đúng phần trăm theo dung lượng.

Dùng:
    python3 scripts/make_preload_manifest.py
"""
import json
import os

ROOT = 'public/assets'
OUT = 'src/data/preload-manifest.json'

# Chỉ là nguồn để chạy script cắt, game không bao giờ mở tới
SKIP_DIRS = {
    'assets/farm/it',        # sheet 16px gốc -> đã sinh ra farm/chibi
    'assets/farm/cf',        # icon Cloverframe gốc -> đã sinh ra farm/chibi
    'assets/interior',       # global.png là sheet gốc; file đã cắt nằm cùng thư mục
}
SKIP_FILES = {
    'assets/interior/global.png',
    'assets/nature/global.png',   # Phaser tự nạp dạng spritesheet, khỏi tải hai lần
}
SKIP_EXT = {'.txt', '.md', '.json5'}
# Ảnh trong thư mục bị bỏ ở trên nhưng game VẪN dùng
KEEP = {
    'assets/interior/furn_bed.png', 'assets/interior/furn_bed_pink.png',
    'assets/interior/furn_couch.png', 'assets/interior/furn_chair.png',
    'assets/interior/furn_table.png', 'assets/interior/furn_shelf.png',
    'assets/interior/furn_kitchen.png', 'assets/interior/furn_fireplace.png',
    'assets/interior/furn_tv.png', 'assets/interior/deco_plant.png',
    'assets/interior/deco_vase.png', 'assets/interior/deco_bear.png',
    'assets/interior/deco_rug.png', 'assets/interior/deco_xmas_tree.png',
    'assets/interior/aquarium_small.png', 'assets/interior/aquarium_big.png',
    'assets/interior/pets.png', 'assets/interior/cat.png', 'assets/interior/yorkie.png',
}


def main():
    rows = []
    for dirpath, dirnames, files in os.walk(ROOT):
        dirnames.sort()
        rel_dir = os.path.relpath(dirpath, 'public').replace(os.sep, '/')
        for f in sorted(files):
            rel = f'{rel_dir}/{f}'
            if os.path.splitext(f)[1].lower() in SKIP_EXT:
                continue
            if rel in KEEP:
                pass
            elif rel in SKIP_FILES or rel_dir in SKIP_DIRS:
                continue
            rows.append([rel, os.path.getsize(os.path.join(dirpath, f))])

    total = sum(r[1] for r in rows)
    with open(OUT, 'w', encoding='utf8') as f:
        json.dump(rows, f, separators=(',', ':'))
    print(f'{len(rows)} file, {total / 1024 / 1024:.1f}MB -> {OUT}')


if __name__ == '__main__':
    main()
