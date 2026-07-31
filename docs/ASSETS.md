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
| `Cozy_UI_Pack_doboui` | Chưa dùng (UI hiện tại là DOM/CSS — nhẹ và dễ sửa hơn) |

## Sprite đã cắt sẵn từ pack (scripts cắt bằng PIL, đã kiểm tra bằng mắt)

- `assets/buildings/` — 10 nhà town (pub, cinema, school, cafe, inn, library, greenhouse, arcade, SUPAM, shop) + beachbar, fishshop (fishing pack)
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

| Map | Mảnh | Cỡ sau khi ghép | Dùng cho |
|-----|------|-----------------|----------|
| 25  | 6    | 2030x520        | `farmbg.png` — Nông trại |
| 26  | 3    | 1302x466        | `farmgate.png` — Cổng Nông trại |

Script ghép: `scripts/build_farm_maps.py` (sửa biến `APK` trỏ tới thư mục đã
giải nén rồi chạy) — ghép mảnh xong kéo dài pixel mép cho khớp cỡ zone
(2032x528 và 1312x464).

Hai map này đã vẽ sẵn **sân rào nuôi thú, hồ cá, đường đất và hàng rào**, nên
code chỉ khai báo toạ độ để logic (ruộng, chuồng, câu cá) bám theo — không còn
cảnh đường đi/nhà/ruộng đè lên nhau.

`scripts/clean_farm_map.py` chạy tiếp sau đó để **xoá hết cây (kể cả mấy khúc
gỗ đã chặt) và các căn nhà vẽ sẵn**, trả lại hàng rào + thảm cỏ bằng cách lát
gương một đoạn viền sạch lấy ngay trong chính map. Nhà bếp / nhà kho / cửa hàng
sau đó dựng lại bằng sprite **pack Cozy** (`assets/buildings/farm_house`,
`farm_barn`, `farm_market`) khai báo trong `ZONE_DECOR`, kèm tên treo phía trên
— thay cho mốc cổng nhấp nháy (map nền đã có cổng/nhà, cứ đi tới là hiện nút).

### Đèn đường, cửa hàng, đống đất (`scripts/fix_avatar_assets.py`)

- `hd/home/845.png` → `assets/lttt/lamp_hd.png`: đèn đường. Trong game mỗi cột
  đèn kèm 2 lớp `glow` (blend ADD) sáng dần theo `darkness()` — trời càng tối
  đèn càng sáng, ban ngày tắt hẳn.
- `hd/home/831.png` → `assets/lttt/bld/shop_av.png`: cửa hàng "CỬA HÀNG" gốc,
  dùng cho map cổng (bản pack Cozy nhìn lệch style với nền vẽ tay).
- `assets/lttt/trough.png` / `trough_full.png`: máng thức ăn. Bản cắt cũ lấy
  dư sang ô bên dưới nên dính thêm một đống cỏ khô rời — cắt lại còn 51x32,
  đúng cái máng (bản `_full` đã có cỏ nằm trong máng).
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
