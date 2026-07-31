"""Lấy bộ giao diện tủ đồ / túi đồ / đơn hàng trong Cozy UI Pack (dobo_ui) vào game.

Pack có sẵn nguyên bộ tủ đồ: khung modal, tấm nền phần nhân vật, ô trang bị
(có cả bản mờ làm ô trống theo từng loại), ô vật phẩm thường/đang chọn, tab và
đường kẻ. Trước đây game chỉ dùng vài mảnh chung (slot/frame/label) rồi tự
dựng phần còn lại bằng CSS.

Nguồn: thư mục Cozy_UI_Pack_doboui giải nén từ file pack chủ dự án gửi.
Chạy: python3 scripts/import_dobo_inventory.py <đường dẫn Cozy_UI_Pack_doboui>
"""
import os
import sys
from PIL import Image

SRC = sys.argv[1] if len(sys.argv) > 1 else 'Cozy_UI_Pack_doboui'
DST = 'public/assets/ui/inv'
MAX = 128           # ảnh gốc tới 1722px, game hiển thị nhỏ nên thu lại cho nhẹ

# tên đích -> đường dẫn trong pack
FILES = {
    'modal':      'Inventory/InventoryModal.png',
    'player':     'Inventory/inventoryPlayerSection.png',
    'sep':        'Inventory/CozySeparator.png',
    'slot':       'Inventory/ItemSlots/ItemSlotsDefault/ItemSlot1.png',
    'slot_sel':   'Inventory/ItemSlots/ItemSlotsSelected/ItemSlotSelected1.png',
    'eq_empty':   'Inventory/EquipmentSlots/EquipmenSlotDefault.png',
    'eq_hat':     'Inventory/EquipmentSlots/EquipmenSlotFlat5.png',
    'eq_glasses': 'Inventory/EquipmentSlots/EquipmenSlotFlat3.png',
    'eq_shirt':   'Inventory/EquipmentSlots/EquipmenSlotFlat6.png',
    'eq_pants':   'Inventory/EquipmentSlots/EquipmenSlotFlat4.png',
    'eq_skin':    'Inventory/EquipmentSlots/EquipmenSlotFlat7.png',
    'tab_on':     'Inventory/InventoryTabs/InventoryTabShort3.png',
    'tab_off':    'Inventory/InventoryTabs/InventoryTabShort2.png',
    # ---- bảng đơn hàng: tờ giấy ghim + dấu tích của pack ----
    'note':       'Containers/NoteContainers/Note1.png',
    'note_pink':  'Containers/NoteContainers/Note2.png',
    'note_wide':  'Containers/NoteContainers/NoteContainer1.png',
    'quest':      'QuestTemporalPrefab/QuestPrefab.png',
    'check':      'QuestTemporalPrefab/CozyCheck.png',
    'card':       'Cards/CardRegular/CardRegular1_cream.png',
    # ---- icon loại trang bị cho dải chip trên tủ đồ ----
    'ic_hat':     'Icons/IconsDefault/64px/IconsDefault52_64px.png',
    'ic_glasses': 'Icons/IconsDefault/64px/IconsDefault47_64px.png',
    'ic_shirt':   'Icons/IconsDefault/64px/IconsDefault27_64px.png',
    'ic_pants':   'Icons/IconsDefault/64px/IconsDefault53_64px.png',
    'ic_skin':    'Icons/IconsDefault/64px/IconsDefault46_64px.png',
    'ic_level':   'Icons/IconsDefault/64px/IconsDefault41_64px.png',
    'chip_bar':   'Containers/Containers/Container1.png',
    'name_label': 'Labels/Label10.png',
}
# ảnh khung to giữ nét hơn: cho phép cạnh dài tới 512
BIG = {'modal', 'player', 'sep', 'note', 'note_pink', 'note_wide', 'quest', 'card', 'chip_bar', 'name_label'}

os.makedirs(DST, exist_ok=True)
for name, rel in FILES.items():
    im = Image.open(os.path.join(SRC, rel)).convert('RGBA')
    lim = 512 if name in BIG else MAX
    if max(im.size) > lim:
        k = lim / max(im.size)
        im = im.resize((round(im.width * k), round(im.height * k)), Image.LANCZOS)
    out = os.path.join(DST, f'{name}.png')
    im.save(out)
    print(f'{out}  {im.size}')
