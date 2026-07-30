# Kiến trúc

## Nguyên tắc

1. **Data-driven:** mọi nội dung (cây, cá, vật nuôi, đồ, quest, shop, khu vực, vòng quay...) nằm trong `src/data/*` dưới dạng bảng khai báo. Thêm nội dung = thêm dòng data, không sửa logic → dễ ra phiên bản/sự kiện mới.
2. **State tập trung:** toàn bộ tiến trình người chơi là 1 object `GameState` (`src/core/types.ts`), lưu localStorage có version để migrate. Khi làm server, object này chính là payload sync.
3. **Event bus:** Phaser (canvas) và UI (DOM) nói chuyện qua `bus` (`src/core/events.ts`) — 2 thế giới không import lẫn nhau lung tung.
4. **Stat → Quest:** mọi hành động cộng `S.stats[key]`; nhiệm vụ/thành tựu chỉ khai báo `{stat, target}` và tự theo dõi. Muốn thêm nhiệm vụ kiểu mới chỉ cần 1 stat mới.

## Luồng

```
main.ts → Phaser.Game [Preload → CharCreate | World] + initUI()
World đọc ZONES[S.zone] → dựng nền, cổng, NPC, ruộng/chuồng/nước/côn trùng
Người chơi (CharacterSprite ghép lớp) → contextActions() → HUD hiện nút hành động
UI DOM: HUD, joystick ảo, cửa sổ (panel registry) — mở qua bus EV.OPEN_PANEL
```

## Nhân vật ghép lớp (asset Character v2)

- Mỗi sheet gộp: mỗi biến thể màu là block 256px ngang (8 cột × 32px), 49 hàng animation.
- Hàng: walk 0-3, jump 4-7, pickup 8-11, carry 12-15, sword 16-19, block 20-23, hurt 24-27, die 28, pickaxe 29-32, axe 33-36, water 37-40, hoe 41-44, fishing 45-48. Mỗi animation 4 hàng theo hướng (xuống/lên/trái/phải).
- Thứ tự lớp: base → mắt → quần áo → tóc → phụ kiện. `CharacterSprite.tick()` tự đồng bộ frame mọi lớp (số biến thể mỗi sheet đọc từ độ rộng texture, không hardcode).

## Vì sao chọn Phaser + TypeScript?

- 1 codebase → H5/Android/iOS/PC (Capacitor + Electron), cập nhật game = deploy web.
- TypeScript bắt lỗi khi compile, refactor an toàn — "dễ update, sửa lỗi" đúng yêu cầu.
- Phaser 3: engine 2D web phổ biến nhất, pixel-art tốt, tài liệu nhiều.

## Điểm mở rộng đã chừa sẵn

- `systems/social.ts` đang chạy chế độ offline (bạn NPC, chat bot) — thay bằng client WebSocket theo `docs/SERVER_PROTOCOL.md` là thành online, UI giữ nguyên.
- `panels.ts > topup`: chỗ nối IAP (Capacitor purchase plugin) / cổng thanh toán.
- `data/meta.ts > EVENTS`: sự kiện theo tháng, gắn shop/skin riêng từng event.
