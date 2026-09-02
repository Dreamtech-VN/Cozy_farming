# Kiến trúc & bản đồ tài liệu → mã nguồn

Tài liệu thiết kế (`docs/00`–`docs/24`) là source of truth. File này chỉ nói mỗi
tài liệu được hiện thực ở đâu, để khi sửa code biết phải cập nhật tài liệu nào
(và ngược lại — theo *Update rule* trong mọi Document Control).

## Sơ đồ tổng thể

```
client/ (HTML5 canvas, ESM thuần)
   │  REST /v1/*            WebSocket /ws
   ▼                             ▼
server/src/http/  ──────►  server/src/realtime/
   │                             │
   └──────────► server/src/domain/ ◄────────┘
                      │
       ┌──────────────┼───────────────┐
       ▼              ▼               ▼
 server/src/db/  server/src/content/  server/src/lib/
   (SQLite)       (data/ + locales/)   (token, rng, rate limit)
```

Nguyên tắc xuyên suốt (doc 13, doc 22): **server authoritative**. Client không
bao giờ tự quyết định currency, inventory, tiến độ quest, kết quả trận đấu hay
mốc thời gian; nó chỉ gửi ý định và hiển thị kết quả server trả về.

## Tài liệu → mã nguồn

| Tài liệu | Hiện thực chính |
| --- | --- |
| 01 Project Vision, 02 Master GDD | Vòng lặp lõi nối bởi `client/src/main.js` + domain layer |
| 03 World Design | `data/content/maps.json` (kèm `world.channel_count`), `server/src/realtime/world.js`, `client/src/render/world.js`, `client/src/ui/minimap.js` |
| 04 Character Design | `data/content/avatar_items.json`, `client/src/render/avatar.js`, bảng `character_equipment` / `character_wardrobe` |
| 05 Art Bible | `client/src/render/*` (vẽ theo layer, prop modular, palette theo map) |
| 06 Farming Design | `data/content/crops.json`, `server/src/domain/farm.js` |
| 07 Match-3 Design | `data/content/match3_levels.json`, `server/src/domain/match3_engine.js`, `server/src/domain/match3.js`, `client/src/scenes/match3.js` |
| 08 Social System | `server/src/domain/social.js`, `client/src/ui/panels.js` |
| 09 Economy Design | `data/content/economy.json`, `server/src/domain/economy.js` |
| 10 Monetization | `server/src/domain/shop.js` (idempotency + audit; IAP thật chưa nối) |
| 11 Quest & Content | `data/content/quests.json`, `server/src/domain/quest.js` |
| 12 UX/UI Design | `client/index.html`, `client/styles.css`, `client/src/ui/*` — hướng màn hình ngang, điều khiển bàn phím (xem ghi chú dưới) |
| 13 Technical Design | `server/src/app.js` và cấu trúc thư mục nói chung |
| 14 Database Design | `server/src/db/migrations/001_init.sql`, `server/src/db/index.js` |
| 15 API Specification | `server/src/http/routes.js` |
| 16 Multiplayer & Networking | `server/src/realtime/ws.js`, `server/src/realtime/world.js`, `client/src/net/realtime.js` |
| 17 LiveOps | `data/content/liveops.json`, route `/v1/liveops/config` |
| 18 Content Pipeline | `server/src/content/validate.js`, `tools/validate-content.mjs` |
| 19 Analytics | `server/src/domain/analytics.js`, bảng `analytics_events` |
| 20 QA & Testing | `tests/*.test.js` |
| 21 DevOps | `.github/workflows/ci.yml`, `ops/` |
| 22 Security & Anti-cheat | `server/src/lib/token.js`, `server/src/lib/ratelimit.js`, validate trong từng domain |
| 23 Localization | `locales/*.json`, `client/src/core/i18n.js` |
| 24 Production Roadmap | `docs/24_Production_Roadmap.md` — trạng thái hiện tại ở README |

## Những quyết định kỹ thuật đáng chú ý

**Zero dependency.** Server không dùng package ngoài: HTTP từ `node:http`,
database từ `node:sqlite`, WebSocket tự hiện thực theo RFC 6455
(`server/src/realtime/ws.js`), test bằng `node:test`. Đổi lại là ít bề mặt tấn
công chuỗi cung ứng và CI chạy được offline. Khi cần scale ngang thì các điểm
thay thế đã được cô lập sẵn: `db/index.js` (đổi sang Postgres),
`lib/ratelimit.js` (đổi sang Redis), `realtime/world.js` (tách thành service riêng).

**Transaction tái nhập.** `db/index.js#transaction` dùng SAVEPOINT cho lần gọi
lồng nhau, vì domain layer thường xuyên gọi chồng (ví dụ `farm.plant` gọi
`economy.applyChange`) và cả hai đều cần tính nguyên tử.

**Idempotency.** Mọi thay đổi tài nguyên đi qua `economy.applyChange`, có
`idempotency_key` lưu trong bảng `transactions`. Client retry mạng không bao giờ
nhân đôi phần thưởng — đây là ràng buộc trong doc 10 và doc 22, và có test riêng.

**Khu (channel).** Map public được chia thành `world.channel_count` khu cùng nội
dung nhưng khác danh sách người chơi — instance id là `<map_id>:ch<N>`. Map
`instance_policy: "owner"` (nông trại, nhà) bỏ qua khu, instance thuộc về chủ sở
hữu. Sĩ số từng khu lấy trực tiếp từ bộ nhớ của `realtime/world.js`; khi tách
realtime thành nhiều tiến trình thì số này phải lấy từ registry dùng chung.

**Board Match-3 nằm ở server.** Client chỉ gửi `{from, to}`; server tự resolve
cascade và trả về các bước để phát animation. Mỗi trận lưu `seed` nên dựng lại
được y hệt khi cần audit.

**Màn hình ngang, không có điều khiển cảm ứng.** Khác mục *Responsive* của doc 12
(ưu tiên mobile portrait): client dựng cho màn hình ngang và điều khiển bằng bàn
phím. `WorldRenderer#scale` lấy khoảng 900px chiều rộng thế giới làm mốc, chặn
dưới bởi ràng buộc chiều cao để khung nhìn không cao hơn map quá nhiều. Muốn hỗ
trợ điện thoại thì phải thêm lại lớp điều khiển cảm ứng — layout CSS vẫn dùng đơn
vị tương đối nên không phải viết lại.

**Content không nằm trong database.** Item, crop, map, quest, shop, event đều là
JSON trong `data/content` và được validate lúc khởi động; content sai reference
thì server từ chối chạy.
