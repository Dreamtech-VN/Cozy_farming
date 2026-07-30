# 🌾 Cozy Farming

Game nông trại phong cách cozy (tham khảo Avatar TeaMobi, Stardew Valley, Harvest Town) — **một codebase chạy 4 nền tảng**: H5 (trình duyệt), PC, Android, iOS.

- **Ngôn ngữ / engine:** TypeScript + [Phaser 3](https://phaser.io) + Vite — dễ code, dễ sửa lỗi, cập nhật nóng qua web, cộng đồng lớn.
- **Màn hình ngang (landscape)**, điều khiển cảm ứng: joystick ảo + nút hành động theo ngữ cảnh; PC dùng WASD/phím mũi tên + E/Space.
- **Asset:** pack mua trên itch.io (được phép thương mại) — xem `docs/ASSETS.md`.

## Chạy thử (H5)

```bash
npm install
npm run dev        # mở http://localhost:5173 (điện thoại cùng mạng LAN vào được luôn)
npm run build      # build production vào dist/
```

## Đóng gói các nền tảng

| Nền tảng | Cách làm |
|---|---|
| **H5 / Web** | `npm run build` → deploy thư mục `dist/` lên hosting bất kỳ |
| **Android** | `npm i @capacitor/core @capacitor/cli @capacitor/android` → `npm run cap:add:android` → mở Android Studio build APK/AAB |
| **iOS** | `npm i @capacitor/core @capacitor/cli @capacitor/ios` → `npm run cap:add:ios` → mở Xcode |
| **PC (exe)** | `npm i -D electron` → `npm run electron` (đóng gói bằng electron-builder khi phát hành) |

## Tính năng đã có (v0.1 — chơi offline, save localStorage)

- **Nhân vật:** tạo nhân vật, giới tính, 8 kiểu ngoại hình, 15 kiểu tóc × 14 màu, 17 bộ đồ × 10 màu, 15 phụ kiện (mũ/kính/mặt nạ/khuyên/râu), màu mắt, biểu cảm (emote), hồ sơ, danh hiệu
- **Nông trại:** mua đất, cuốc, trồng 14 loại cây, tưới, bón phân, thu hoạch, bán
- **Chăn nuôi:** chuồng 3 cấp, gà/bò/heo/cừu, cho ăn, thu sản phẩm, bán
- **Câu cá:** 3 cấp cần, 30 loài cá 4 độ hiếm, bãi biển + hồ câu, sưu tập, nuôi cá trong hồ tại nhà
- **Côn trùng:** vợt, bắt bướm/bọ ngoài đồng, sưu tập, bán
- **Nhà ở:** mua nhà, nâng cấp 3 cấp, giấy dán tường/sàn, 22 nội thất + tranh treo + hồ cá, mở tiệc
- **Mini game:** cờ caro (AI), cờ tướng (AI), oẳn tù tì, Game Center
- **Xã hội:** kết bạn, chat công khai/khu vực/riêng, tặng quà, chặn, báo cáo, bảng xếp hạng, thư
- **Nhiệm vụ:** chuỗi tân thủ 8 bước, 3 nhiệm vụ ngày, 10 thành tựu, 12 danh hiệu
- **Kinh tế:** Xu + Ruby, shop NPC (hạt giống, bách hóa, tiệm câu, thời trang, quà, nhà đất), nạp (demo)
- **Mỗi ngày:** quà đăng nhập chuỗi 7 ngày, điểm danh tháng, vòng quay may mắn, sự kiện theo mùa (Tết, Noel, Halloween, Trung Thu…)
- **Thế giới:** 9 khu vực (nông trại, thành phố, bãi biển, công viên, trường học, hồ câu, Game Center, khu mua sắm, nhà riêng), ngày/đêm, thời tiết mưa/nắng, 4 mùa

## Cấu trúc source

```
src/
  core/      # save/load, event bus, types, âm thanh, input ảo
  data/      # TOÀN BỘ số liệu game: cây trồng, cá, vật nuôi, shop, quest, zone...
  systems/   # logic: farming, livestock, fishing, quests, social, housing, time, meta
  gfx/       # CharacterSprite — nhân vật ghép lớp (base/mắt/đồ/tóc/phụ kiện)
  scenes/    # Phaser: Preload, CharCreate, World (mọi khu vực dùng chung 1 scene)
  ui/        # UI DOM phủ trên canvas: HUD, joystick, mọi panel, minigames
```

Thêm nội dung mới (cây, cá, đồ...) chỉ cần thêm 1 dòng data trong `src/data/` — không đụng logic.

Xem thêm: `docs/ARCHITECTURE.md`, `docs/ASSETS.md`, `docs/ROADMAP.md`, `docs/SERVER_PROTOCOL.md`.
