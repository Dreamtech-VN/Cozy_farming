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

## Chỗ đang vẽ tạm bằng code (procedural)

- Nền đất/cỏ/cát/nước, cây to, chuồng, nhà — palette khớp pack, sẽ thay dần bằng tile thật khi map toạ độ tileset.
- Nội thất trong nhà đang vẽ khối màu + icon (data đã đủ, chỉ cần map sprite `Interior.full/global.png`).

## Cần mua thêm (đề xuất, ưu tiên từ trên xuống)

1. **Pack côn trùng** (bướm/bọ pixel 16px) — hiện đang vẽ tạm bằng code. Gợi ý tìm: "pixel insects pack" trên itch.
2. **Pack nhạc nền + SFX cozy/farm** — hiện dùng âm thanh tổng hợp WebAudio (beep). Gợi ý: "cozy farm music pack", "RPG SFX pack".
3. **Pack icon vật phẩm** (trứng, sữa, quà, tiền...) — hiện dùng emoji. Gợi ý: cùng tác giả shubibubi có icon pack, hoặc "pixel item icons 16x16".
4. **Pack hiệu ứng** (lấp lánh, level up, mưa tuyết) — tăng cảm giác "game xịn".
5. (Sau này, khi làm cánh/thú cưng/xe) pack tương ứng theo roadmap.
