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

Vật nuôi vẫn giữ bộ cũ (pack không có gà/cừu). Nhạc nền và ambient trong pack
chưa tích hợp.

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
