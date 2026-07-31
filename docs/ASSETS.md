# Asset

Nguồn: các pack đã mua trên itch.io (license thương mại), tải từ
[Release "Pack"](https://github.com/thanhtinz/Cozy_farming/releases/tag/Pack).

## Đang dùng (đã copy vào `public/assets/`)

| Pack | Dùng cho |
|---|---|
| `Character.v.2.2` | Nhân vật ghép lớp 32px: 8 base, 15 tóc (14 màu), 17 bộ đồ (10 màu), 15 phụ kiện, mắt, emote, bóng. Sheet gộp 49 hàng animation (walk/jump/pickup/carry/hoe/water/fishing...) |
| `full.version` (Cozy Farm) | crops_all (cây trồng 16px), seeds, tools, tiles, toàn bộ animals (gà/bò/heo/cừu/thỏ/dê...) |
| `fishing_full` | fish_all (100 ô cá 16px), inv_items, forage, tile bãi biển |
| `Interior.full` | global (nội thất — sẽ map chi tiết), pets (mèo/chó), aquarium gif |
| `town.full` | tiles + buildings thành phố (sẽ map chi tiết) |
| `nature.full` | cây/bụi/quả tự nhiên |
| `Cozy_UI_Pack_doboui` | Khung/nút/nhãn chung + **nguyên bộ giao diện tủ đồ, túi đồ và đơn hàng** (`assets/ui/inv/`, xem `scripts/import_dobo_inventory.py`) |

## Sprite đã cắt sẵn từ pack (scripts cắt bằng PIL, đã kiểm tra bằng mắt)

- `assets/buildings/` — nhà town pack Cozy. **Không map nào còn dùng**: nhà cửa và nền map đều lấy của repo Lttt (`assets/lttt/`). Giữ file lại phòng khi cần.
- `assets/deco/` — cây tán tròn ×2, thông, ghế đá, đèn đường ×2, bù nhìn, thùng gỗ, chậu hoa, bụi cây (từ tiles.png)
- `assets/interior/` — giường ×2, sofa, ghế, bàn, kệ, bếp, lò sưởi, TV, chậu cây, bình hoa, gấu bông, thảm, cây thông Noel, hồ cá ×2 (từ Interior pack)

## Chỗ còn vẽ tạm bằng code (procedural)

- Nền đất/cỏ/cát/nước (tile đơn sắc có hoa văn, palette khớp pack) — autotile thật sẽ map ở v0.2.
- Chuồng gia súc, đàn piano, đèn cây trong nhà, tranh treo tường.

## SuperRetroRanch Premium (release Pack2) — `assets/pack2/`

Pack pixel 16px do chủ dự án cung cấp (release `Pack2` của repo). Trong pack có
tileset hàng rào, nhà cửa, vật nuôi, cây trồng, nước autotile, UI và **nhạc/âm thanh**.

Đang dùng:
- `tiles/fence_01_16x16.png` -> `assets/pack2/fence.png`, ghép sẵn thành
  `assets/pack2/pen.png` (chuồng rào 12x8 ô, 4 góc + cổng giữa cạnh dưới)
- `crops/*/growth_basic/*.png` -> `assets/pack2/crops/<cây>.png`: cây trồng lớn
  dần có animation. Frame cuối của pack là cây héo nên game chỉ dùng tới frame
  n-2. Bảng ánh xạ ở `CROP_ANIM` trong `src/data/crops.ts`
- `tiles/water_0*_16x16_5frames.png` -> `assets/pack2/water/` (chưa dùng, hồ đang
  chạy hiệu ứng gợn/lấp lánh bằng tile nước Avatar)

- `crops/*/icon/*.png` -> `assets/pack2/icons/`: icon nông sản trong túi. Icon gốc
  có viền trắng nên phải xoá viền trắng (flood fill từ mép) rồi mới chuyển style
  chibi, để đồng bộ với các icon còn lại
- `tiles/ground_01_16x16.png` -> `assets/pack2/path.png`: autotile 3x3 đường đất
  (đã xoá phần cỏ), dùng cho đường đi trong nông trại và bờ hồ
- `tiles/water_0*_16x16_5frames.png` -> `assets/pack2/water/`: mặt nước động 5 frame

Vật nuôi vẫn giữ bộ cũ (pack không có gà/cừu). Nhạc nền và ambient của pack
**đã tích hợp** — xem mục "Âm thanh" bên dưới.

## Icon vật phẩm nông trại kiểu chibi (`assets/farm/chibi/`)

Nguồn: icon 16px cắt sẵn ở `assets/farm/it/` (một sheet duy nhất) và 5 icon
Cloverframe ở `assets/farm/cf/`. Sinh ra bản chibi bằng script PIL:

1. phóng nearest x3 (x2 với icon 32px) để giữ pixel vuông
2. tăng độ rực 1.2 / tương phản 1.1
3. giãn alpha (MaxFilter) rồi tô viền tối `#261a14` dày 2-3 px
4. phủ vệt sáng bo tròn ở góc trên-trái, mask theo phần đặc của hình
5. trim viền trong suốt

Bộ chibi này là bộ đang dùng trong game; hai thư mục `it/` và `cf/` giữ lại
làm bản gốc để chạy lại script khi cần.

`chibi/meat.png` (thịt heo thu từ chuồng) cắt từ `assets/farm/items.png` — sheet
16px 10 cột, ô hàng 3 cột 6 (miếng ba chỉ) — rồi chạy đúng 5 bước trên.

Icon nông sản trong túi/kho ưu tiên bộ chibi này (bảng `IT_CROP` trong
`src/data/crops.ts`); cây nào bộ chibi không có mới lấy icon pack2
(`assets/pack2/icons/`), vì icon pack2 vẽ theo kiểu cây non nên trông lệch
so với trứng/sữa/thịt.

### Giao diện tủ đồ / túi đồ / đơn hàng (`assets/ui/inv/`)

Cắt bằng `scripts/import_dobo_inventory.py` từ Cozy UI Pack (dobo_ui) — pack có
sẵn nguyên bộ Inventory nên không tự dựng lại bằng CSS nữa:

- `modal.png`, `player.png`, `card.png`, `chip_bar.png`, `name_label.png`: các
  tấm nền (khung lưới, bảng nhân vật, thẻ chi tiết, dải chip, nhãn tên)
- `slot.png` / `slot_sel.png`: ô vật phẩm thường / đang chọn — dùng chung cho
  tủ đồ, túi đồ và ô hàng trên bảng đơn
- `eq_empty.png` + `eq_<loại>.png`: ô trang bị, bản `eq_*` đã có sẵn icon mờ
  từng loại nên ô trống khỏi cần vẽ chữ
- `tab_on/off.png`, `ic_*.png`: tab và icon loại trang bị
- `note.png` / `note_pink.png` (khách ghé trại) / `check.png`: tờ giấy và dấu
  tích cho bảng đơn hàng
- `cur_pill.png` + `cur_coin/cur_gem/cur_plus.png`: thanh xu/ngọc trên HUD

## Cloverframe Cozy Farm Starter Pack (`assets/farm/cf/`)

20 icon 32x32 (nông sản, trứng/sữa/phô mai/bánh/mật ong, túi hạt, bình tưới, cuốc, liềm, rìu).

Đang dùng cho: icon nông sản trong túi (cà rốt, củ cải, cà chua, bí đỏ, ngô, dâu,
khoai tây, bắp cải), túi hạt giống, trứng, sữa, thức ăn gia súc (bó lúa mì),
và 4 nông cụ cuốc / bình tưới / liềm (giỏ thu hoạch) / rìu.

Giấy phép Cloverframe Studio v1.0: **được** dùng trong game thương mại và sửa đổi;
**không được** bán lại / phát tán file gốc hoặc file đã sửa dưới dạng file rời,
không đóng gói lại thành pack khác, không dùng để train AI.
Lưu ý: repo này công khai nên file gốc nằm trong repo có thể bị coi là "phát tán file rời" —
nếu muốn chặt chẽ, nên chuyển pack sang repo riêng tư hoặc build asset đã gộp sheet.

## Icon nông cụ chibi (`assets/chibi/tools/`)

- `hoe/basket/rod/net.png`: icon item gốc Avatar (res.rar repo Lttt, hd/item
  11326 / 7077 / 10131 / 10855) — **chỉ dùng dev/test, thay khi phát hành**.
- `can.png` (bình tưới), `axe.png`, `shovel.png`: tự vẽ theo cùng style (dùng thoải mái).

## Asset từ repo Lttt (`assets/lttt/`)

Lấy từ https://github.com/thanhtinz/Lttt (client/unity/Assets/Resources/hd):
world map (`minimap.png`), ô ruộng `cell0-7` + biển `buyLand`.

### Nền map nông trại + cổng nông trại (`assets/lttt/maps/`)

Bản unity trong repo chỉ kèm **mảnh đầu tiên** của mỗi imagemap, còn bản APK
(`client/android/Avatar-PGaming.apk`, giải nén ra `assets/hd/imageMap/<id>/*.png`)
có đủ các mảnh. Ghép các mảnh theo thứ tự số, canh mép **dưới**:

Script ghép tất cả: **`scripts/build_lttt_maps.py`** (đặt `APK_ASSETS` trỏ tới
thư mục assets đã giải nén rồi chạy). Bảng dưới là danh tính thật của từng map,
đọc ra bằng cách ghép rồi nhìn ảnh, đối chiếu `T.nameRegion` trong client java
(8 khu: *Khu nhà ở, Khu sinh thái, Sân bay, Khu giải trí, Khu mua sắm, Công
viên, Khu ngoại ô, Nông trại*):

| Map | Mảnh | Cỡ đã ghép | Zone trong game | Trong ảnh có sẵn |
|-----|------|-----------|-----------------|------------------|
| 25  | 6 | 2030x520 | `farm` Nông trại | bếp, kho, sân rào, hồ cá |
| 26  | 3 | 1302x466 | `farm_gate` Khu Nông Trại | biển FARM, cửa hàng |
| 22  | 4 | 2406x473 | `town` **Khu nhà ở** | 8 căn nhà 2-3 tầng |
| 24  | 4 | 2118x516 | `mall` **Khu mua sắm** | Mỹ Viện, Gift, ATM, tiệm thú cưng, Premium, trang sức, Shop |
| 10  | 3 | 2022x511 | `gamecenter` **Khu giải trí** | ATM, GAME (2 máy thùng), toà nhà lớn, xe bói, VÒNG QUAY, Pet Racing |
| 4   | 2 | 912x517  | `park` Công viên | hồ, ghế đá |
| 15  | 2 | 1008x384 | `pond` Hồ câu | hồ lớn |
| 14  | 3 | 1008x448 | `beach` Bãi biển | kè đá, tiệm câu |
| 58  | 1 | 576x526  | `fashion_shop` Tiệm thời trang | giá treo quần áo + cô bán hàng |
| 59  | 1 | 576x526  | `gift_shop` Tiệm quà | quầy vàng + cô bán hàng |
| 104 | 2 | 864x528  | `salon_shop` Mỹ Viện | gương lớn, quầy trang điểm |
| 105 | 1 | 672x528  | `pet_shop` Tiệm thú cưng | tường vân chân thú, lồng thú |
| 101 | 2 | 960x528  | `school` Trường học | kệ sách, quầy sách vở |

*Sân bay* và *Khu ngoại ô* chưa dựng — bộ imageMap trong APK không có nền hai khu này.

⚠️ Map 10 còn kèm `daydien0/1/2.png` (dây điện) — đó là **lớp phủ riêng**, không
nằm trong dải nền; ghép nền chỉ lấy các mảnh đánh số.

Công trình vẽ sẵn trong ảnh nền không có sprite riêng nên không tự bấm được:
bảng `DRAWN_SPOTS` trong `WorldScene` khai toạ độ px của từng cái (ATM, Premium,
tiệm trang sức, vòng quay, Pet Racing, quầy các tiệm) để bấm vào là mở bảng
tương ứng. Cửa vào tiệm khai bằng `portals` (khung bấm trùm mặt tiền); cửa ra
của map nội thất khai thêm `spot: 'door'` để khung bấm chỉ bằng ô cửa.

Ghép mảnh xong kéo dài pixel mép cho khớp đúng số tile của zone.
(`scripts/build_farm_maps.py` là bản cũ chỉ ghép 2 map nông trại, giữ lại làm
tham chiếu; dùng `build_lttt_maps.py` cho toàn bộ.)

Hai map nông trại đã vẽ sẵn **sân rào nuôi thú, hồ cá, đường đất và hàng rào**, nên
code chỉ khai báo toạ độ để logic (ruộng, chuồng, câu cá) bám theo — không còn
cảnh đường đi/nhà/ruộng đè lên nhau.

Map 25 còn vẽ sẵn cả **nhà bếp (biển "NHÀ BẾP") và nhà kho**, nên dùng nguyên
map — không xoá đi rồi đắp sprite pack khác lên nữa (script `clean_farm_map.py`
làm việc đó đã bỏ). `KITCHEN_POS` / `WAREHOUSE_POS` trong `WorldScene` chỉ trỏ
đúng vị trí hai căn vẽ sẵn để hiện nút khi đi tới gần.

### Đèn đường, cửa hàng, đống đất (`scripts/fix_avatar_assets.py`)

- `hd/iconmenu/chat0.png` → `assets/ui/pack/icon_chat.png`
  (`scripts/cut_chat_icon.py`): bong bóng thoại. Ảnh gốc là cả cái nút (khung
  bo góc xám + nền trắng) nên loang từ mép vào xoá hết vùng xám-trắng, chỉ giữ
  bong bóng. Trước đây icon "chat" bị gán nhầm sang hình phong thư có mặt mèo
  của Cozy UI Pack — đó là icon thư, không phải chat.
- `hd/home/845.png` → `assets/lttt/lamp_hd.png`: đèn đường. Trong game mỗi cột
  đèn kèm 2 lớp `glow` (blend ADD) sáng dần theo `darkness()` — trời càng tối
  đèn càng sáng, ban ngày tắt hẳn.
- `hd/home/831.png` → `assets/lttt/bld/shop_av.png`: cửa hàng "CỬA HÀNG" gốc
  (hiện chưa đặt ở map nào — map cổng đã bỏ, nông trại mua hạt qua NPC Cô Mai).
- `assets/lttt/trough.png` / `trough_full.png`: máng thức ăn. Bản cắt cũ lấy
  dư sang ô bên dưới nên dính thêm một đống cỏ khô rời — cắt lại còn 51x32,
  đúng cái máng (bản `_full` đã có cỏ nằm trong máng).
- `assets/lttt/order_board.png` (`scripts/make_order_board.py`): bảng đơn hàng
  ngoài sân nông trại. Lấy biển "BẢNG XẾP HẠNG" (`assets/lttt/rank_sign.png`)
  rồi xoá chữ: nét chữ là một màu nâu riêng nên xoá theo màu, còn bóng đổ của
  chữ trùng màu vân gỗ nên trải phẳng đúng những hàng từng có chữ. Tên bảng do
  game vẽ đè (giống nhãn "Nhà kho") nên không vẽ chữ vào ảnh.
- Nhà bếp / nhà kho trong nông trại dùng thẳng `assets/lttt/bld/kitchen.png` và
  `warehouse.png` của repo Lttt (nhà bếp có sẵn biển "NHÀ BẾP"), thay cho bản
  pack Cozy trước đây. Nông trại không còn nhà riêng — cửa nhà riêng ở căn nhà
  trắng trong Thị trấn.
- `assets/lttt/bld/atm.png` (`scripts/import_atm_rods.py`): **buồng ATM thật của
  Avatar**, cắt từ map 10 (dãy phố Game Center có sẵn buồng hai máy, biển xanh
  chữ "ATM") rồi loang từ mép xoá cỏ nền. Trước đây tưởng Lttt không có ATM nên
  mượn tạm ki-ốt `hd/home/1036.png` — bỏ bản đó đi. Buồng vẽ sẵn trong map 10
  cũng được đăng ký thành điểm bấm được ở khu Game Center.
- `assets/farm/mound.png`: đống đất để đào xẻng — trước vẽ bằng graphics nên
  trông như cục bùn, nay vẽ lại thành gò đất tơi có cục, sỏi và cỏ, kèm một
  đốm sáng nhấp nháy trong game cho biết đào được.

### Nền trời (`assets/lttt/sky/`)

Lấy từ `assets/hd/bgHD` trong APK: `may10.png` → `sky.png` (trời + mây),
`10.png` → `hills.png` (hàng cây xa), `20.png` → `fields.png` (đồng ruộng, để
dành). Phần trên map nền vốn trong suốt, nay lấp bằng 2 lớp này (depth -130 /
-129) rồi **nhuộm màu theo giờ trong game** (`WorldScene.tintSky`): hửng sáng
→ trưa trong veo → hoàng hôn ngả vàng → đêm xanh thẫm. Mây trôi chậm bằng
tween `tilePositionX`.

### Nhà pack Cozy bản HD (`assets/buildings/hd/`)

`scripts/hd_buildings.py` phóng 2x sprite nhà pack Cozy rồi làm mềm cạnh, đắp
viền tối và bóng đổ để khớp với map nền vẽ tay (bản pixel 1x phóng NEAREST
trông rất lệch style). Trong game dùng key `bldhd_<tên>` ở scale 1.

### Xe cộ

**Xe buýt** dùng asset gốc Avatar: `assets/hd/home/839.png` trong APK (234x194,
xe khách xanh có hành khách trong cửa sổ) — lật ngang cho quay phải như mấy xe
còn lại rồi lưu thành `assets/vehicles/bus.png`. Ảnh gốc kiểu J2ME **không có
alpha thật**: bóng dưới gầm xe vẽ bằng lưới caro pixel `#494949`, phóng to lên
trông như bị rỗ — `scripts/fix_avatar_assets.py` dò đúng lưới đó rồi đổi thành
bóng mờ liền. Vì là ảnh HD nên
`WorldScene.vehScale()` quy nó về cùng chiều cao với sprite xe pack pixel.
Tên file lấy từ `Bus.java` trong client java (`FilePack.getImage("839")` ở pack
`/home.av`); thư mục `hd/home` là bản HD đã giải nén sẵn của pack đó.

`scripts/recut_vehicles.py` — trong `assets/town/buildings_all.png` mỗi mẫu xe
được vẽ 2 lần dính liền thành khối 160px; bản cắt cũ lấy 66–78px nên lẹm mất
đầu xe. Nay cắt đúng nửa 80px rồi trim theo bbox (thêm được `camper_green`).

`scripts/reskin_shelter.py` vẽ lại tấm biển trong nhà chờ xe buýt
(`assets/lttt/shelter.png`) — ảnh gốc là poster logo của game khác, nay thay
bằng poster mang **logo Sunny Town** trên nền trời + dải cỏ.

## Logo game (`assets/ui/logo.png`)

`scripts/make_logo.py` tách nền cho file logo do chủ dự án cung cấp: loang từ
mép ảnh vào để xoá nền trắng/ô caro mà vẫn giữ mấy nét trắng nằm trong lòng
chữ, rồi trim + thu về 512px. Dùng ở:

- màn hình đăng nhập / chọn máy chủ (`.lg-brand`, nổi phía trên khung, có
  hiệu ứng nhấp nhô nhẹ) — thay cho 2 dòng chữ vẽ bằng Phaser trước đây
- tấm biển trong nhà chờ xe buýt
⚠️ **Lưu ý bản quyền:** bộ này trông giống resource của game Avatar (TeaMobi) gốc —
nếu đúng vậy thì chỉ nên dùng để dev/test; bản phát hành thương mại cần thay bằng
asset tự vẽ hoặc có quyền sử dụng.

## Ghi chú trạm xe buýt

Sprite `assets/deco/busstop.png` hiện ghép từ ghế đá của tileset + khung/mái vẽ tay
(môi trường dev chặn mạng ngoài nên chưa tải được asset online). Có asset CC0 phù hợp:
"Sprite City Series 1 – Bus Station" trên OpenGameArt
(https://opengameart.org/content/sprite-city-series-1-bus-station) — tải về thay file là xong.

## Nhân vật chibi (hiện hành)

Nhân vật đã chuyển sang **hệ paperdoll chibi Avatar**: 345 part (tóc/áo/quần/mũ/kính/cánh
+ thân + mắt) giải nén từ `res.rar` trong repo Lttt, mỗi part là strip 15 frame 64x96
(`public/assets/chibi/`), metadata tên + giá gốc trong `src/data/chibi-parts.json`.
Format được dịch ngược từ client (AvatarData.cs) + bảng `items` trong SQL server.
⚠️ Cùng lưu ý bản quyền như các asset Lttt khác — dev/test OK, thương mại phải thay.
Bộ nhân vật pixel Cozy (Character v2) vẫn còn trong repo nhưng không dùng nữa.

## Cần câu (`assets/fishing/`)

Ba bậc cần trong game lấy đúng theo bảng `items` của server Lttt: **cần câu tre**
(442) · **cần câu sắt** (445) · **cần câu VIP** (446), `zorder` 70 = đồ cầm tay.

- **Hình cầm trên tay** dùng thẳng part chibi Avatar `assets/chibi/442|445|446.png`
  — mua cần là part vào luôn tủ quần áo (tab "Đồ cầm tay") và nhân vật cầm cần
  thật khi chọn ô cần câu, không còn dán icon lên tay.
- **Icon shop / thanh nông cụ** lấy từ Cozy Fishing Asset Pack (shubibubi),
  `Fish Forage Items/inv_items.png` — lưới 16x16, 9 cột: ô (0,4) gỗ nâu = tre,
  (0,3) xanh = sắt, (5,2) đỏ-vàng = VIP → gộp thành `assets/fishing/rods.png`
  (48x16) + `rod.png` (ô đầu, dùng khi chưa biết bậc). Part Avatar gốc chỉ là
  cái cần mảnh dính vào tay, thu nhỏ xuống làm icon thì không đọc ra hình gì.

Script: `scripts/import_atm_rods.py` (cắt cả buồng ATM lẫn icon cần).

## Ảnh đại diện (`assets/avatar/`)

35 ảnh đại diện mèo/thú từ pack **"Cute Avatars Game Asset Pack"** của
[craftpix.net](https://craftpix.net/file-licenses/) (bản Freebies). Nguồn 257×257,
đã resize về 128×128 + quantize 128 màu (~4KB/ảnh, tổng ~139KB thay vì ~690KB).
Danh sách trong `src/data/avatars.ts`, đánh số `01.png`…`35.png`.
⚠️ License craftpix Freebies: dùng được trong game thương mại nhưng **không được
bán lại / phát hành lại chính file asset**. Đọc kỹ link trên trước khi phát hành.

Người chơi còn có thể **tự tải ảnh lên** làm đại diện: ảnh được cắt vuông ở giữa,
thu về 128×128 rồi lưu dạng data URL JPEG (~8KB) ngay trong save — xem
`squareThumb()` trong `src/ui/kit.ts`. Không có server nên ảnh chỉ nằm ở máy người chơi.

## Âm thanh (`assets/sfx/`, `assets/bgm/`)

**Nhạc nền dùng cả hai pack.** Pack2 (SuperRetroRanch) có 8 file .wav trong
`musics/` (3 theme + 5 ambient, ~119MB chưa nén); dùng 5 file, chuyển sang .ogg
(`ffmpeg -c:a libvorbis -q:a 3`) còn ~3.7MB:

| Game | Nguồn | Dài |
|---|---|---|
| `bgm/p2_field` | Pack2 `music_themes/field` | 84s |
| `bgm/p2_town` | Pack2 `music_themes/town` | 74s |
| `bgm/p2_village` | Pack2 `music_themes/village` | 70s |
| `bgm/p2_night` | Pack2 `ambients/night` | 30s |
| `bgm/p2_rain` | Pack2 `ambients/rain` | 30s |

Chia khu: Nông trại `p2_field` · Thành phố `p2_town` · Công viên/Bãi biển
`p2_village` · Hồ câu `pond` (Lttt) · Trong nhà/Trường `house` (Lttt) ·
Mall/Game center `shop` (Lttt). `p2_night` / `p2_rain` phát chồng lên nhạc nền
(âm lượng 0.18) khi trời tối hoặc mưa, ở trong nhà thì tắt — xem `setAmbient()`.

Pack1 (`full version`, 445 file) **không có file âm thanh nào**, và cũng không có
icon nông cụ — `farming/tools.png` của pack đó là kệ gỗ/bình sữa, không phải
nông cụ cầm tay.

Pack2 **không có hiệu ứng** (không có tiếng bấm/thu hoạch/tưới nước), nên hiệu
ứng lấy từ repo Lttt
(`client/unity/Assets/Resources/sound/`, 96 file .ogg), chọn ra 16 file hợp game:

| Game | File gốc Lttt |
|---|---|
| `sfx/click` | `snd_effect_touch` |
| `sfx/coin` | `snd_effect_earned_money` |
| `sfx/buy` | `snd_effect_buy` |
| `sfx/plant` | `snd_effect_dao_dat` (cuốc đất) |
| `sfx/water` | `snd_effect_tuoi_nuoc` |
| `sfx/harvest` | `snd_effect_thu_hoach` |
| `sfx/fish`, `splash` | `snd_effect_fish`, `snd_effect_fishing_reel` |
| `sfx/chicken|cow|pig|dog` | `snd_effect_*` cùng tên |
| `bgm/town|house|shop|pond` | `snd_bg_city|house|shop|fishing` |

Tổng ~620KB. `src/core/audio.ts` tải sẵn hiệu ứng sau cú chạm đầu tiên (chính sách
autoplay của trình duyệt), nhạc nền đổi theo khu qua `bgmForZone()`. Nếu file lỗi
hoặc chưa tải xong thì tự lùi về tiếng beep tổng hợp WebAudio như trước.
⚠️ Cùng lưu ý bản quyền như các asset Lttt khác — dev/test OK, thương mại phải thay.

## Nhân vật cho map HD (nên mua)

Nhân vật Character v2 (32px pixel) hơi nhỏ so với map nền HD kiểu Avatar — hiện game
tự phóng 1.6× ở các map nền ảnh. Muốn đẹp hẳn nên mua 1 pack nhân vật to hơn
(license thương mại, tìm trên itch.io):

1. **Sunnyside World** (danieldiggle) — nhân vật 32×64 HD, nhiều animation farm (cuốc/tưới/câu), phong cách rất gần map Avatar.
2. **Cute Fantasy RPG** (Kenmi) — nhân vật + farm, nét mềm, dễ khớp.
3. **Modern Interiors/Exteriors + Characters** (LimeZu) — bộ nhân vật 32×64 khổng lồ, nhiều trang phục, giá rẻ.

Mua xong gửi mình sheet — cấu trúc `CharacterSprite` đã tách lớp sẵn, thay bộ render là xong.

## Cần mua thêm (đề xuất, ưu tiên từ trên xuống)

1. **Pack côn trùng** (bướm/bọ pixel 16px) — hiện đang vẽ tạm bằng code. Gợi ý tìm: "pixel insects pack" trên itch.
2. **Pack nhạc nền + SFX cozy/farm** — hiện dùng âm thanh tổng hợp WebAudio (beep). Gợi ý: "cozy farm music pack", "RPG SFX pack".
3. **Pack icon vật phẩm** (trứng, sữa, quà, tiền...) — hiện dùng emoji. Gợi ý: cùng tác giả shubibubi có icon pack, hoặc "pixel item icons 16x16".
4. **Pack hiệu ứng** (lấp lánh, level up, mưa tuyết) — tăng cảm giác "game xịn".
5. (Sau này, khi làm cánh/thú cưng/xe) pack tương ứng theo roadmap.
