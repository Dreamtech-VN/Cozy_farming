# 2D Social MMO — Farming + Social + Match-3

Hiện thực theo bộ tài liệu thiết kế trong [`docs/`](docs/): thế giới 2D side-view
nhiều map, avatar tuỳ biến theo layer, nông trại, Match-3 PvE và các hệ thống
social — server authoritative, content data-driven.

Tài liệu là source of truth: [`docs/00_Documentation_Index.md`](docs/00_Documentation_Index.md).
Ánh xạ tài liệu → mã nguồn: [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

## Chạy thử

Chỉ cần Node.js 22.5 trở lên. Không có dependency nào cần cài.

```bash
node server/src/index.js        # hoặc: npm start
```

Mở http://localhost:8080, bấm **Tạo tài khoản** là vào game.

Game chơi ở **màn hình ngang**, điều khiển bằng bàn phím:

| Phím | Việc |
| --- | --- |
| `←` `→` hoặc `A` `D` | Di chuyển |
| `Space`, `↑`, `W` | Nhảy |
| `E` hoặc `Enter` | Nói chuyện NPC, đi qua portal, tương tác |

HUD: góc trái là thông tin nhân vật (chân dung, tên, cấp, thanh XP — bấm vào mở
panel Nhân vật); giữa là xu và ngọc; phải là minimap (bấm để mở bản đồ khu vực,
trong đó có nút mở bản đồ thành phố) và dropdown chuyển khu 1–20.

Muốn có sẵn dữ liệu để xem:

```bash
npm run seed                    # tạo demo_farmer / demo_player / demo_social, mật khẩu demo-password-1
```

## Lệnh thường dùng

| Lệnh | Việc |
| --- | --- |
| `npm start` | Chạy server (HTTP + WebSocket + phục vụ client tĩnh) |
| `npm run dev` | Chạy với `--watch` và log mức debug |
| `npm test` | 70 test: unit, integration API, realtime, content |
| `npm run validate:content` | Validate content pipeline (doc 18) |
| `npm run lint` | Kiểm tra cú pháp, import gãy, quy ước mã nguồn |
| `npm run check` | Chạy cả ba bước trên — dùng trước khi push |
| `npm run docs:import <thư-mục>` | Chuyển tài liệu `.docx` mới thành Markdown trong `docs/` |

## Cấu trúc

```
docs/          25 tài liệu thiết kế (Markdown) + bản gốc .docx trong docs/source/
data/content/  content data-driven: crop, item, cosmetic, map, match-3, quest, shop, economy, liveops
locales/       chuỗi hiển thị theo key (vi, en)
server/src/    http/ realtime/ domain/ db/ content/ lib/
client/        client HTML5 canvas, ESM thuần, không cần bước build
               (assets/ chứa asset giao diện — xem client/assets/ATTRIBUTION.md)
tests/         test theo critical test cases của doc 20
tools/         validator content, lint, seed dev, chuyển đổi tài liệu
ops/           Dockerfile, systemd unit, script deploy
```

## Vòng lặp game hiện có

Đăng nhập → vào thế giới → chạy trong map 2D, gặp NPC và người chơi khác → nhận
nhiệm vụ → về nông trại gieo hạt → chờ (server tính theo thời gian thật, tắt game
vẫn lớn) → thu hoạch → bán hoặc nộp nhiệm vụ → chơi Match-3 lấy thưởng → lên cấp,
mở thêm ô đất, mua cosmetic → chat và kết bạn → quay lại.

Đây đúng là vòng lặp mà doc 01 đặt ra làm tiêu chí thành công của MVP.

## Trạng thái so với roadmap (doc 24)

- **Phase 1 — Prototype**: xong. Di chuyển 2D, load map, avatar theo layer, farm, Match-3.
- **Phase 2 — MVP**: phần lớn đã có. Thành phố, nông trại, social cơ bản, chat/friend,
  Match-3 PvE, inventory, quest, economy, analytics.
- **Chưa làm**: Match-3 PvP, housing, pet, crafting, trading, thanh toán thật.
  Các tính năng này đã có sẵn feature flag trong `data/content/liveops.json`.

## Ghi chú kỹ thuật

Client hướng màn hình ngang và không có nút điều khiển cảm ứng — khác với mục
*Responsive* của doc 12 (ưu tiên mobile portrait). Layout vẫn dùng đơn vị tương
đối nên quay lại portrait không phải viết lại, nhưng muốn chơi được trên điện
thoại thì phải bổ sung lại lớp điều khiển cảm ứng.


Server không dùng package ngoài nào: HTTP từ `node:http`, database từ
`node:sqlite`, WebSocket tự hiện thực theo RFC 6455, test bằng `node:test`.
Các điểm cần thay khi scale (Postgres, Redis, tách realtime service) đã được cô
lập sẵn — xem [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

Trước khi deploy staging/production phải đặt `TOKEN_SECRET` (xem `.env.example`);
server sẽ từ chối khởi động ở `NODE_ENV=production` nếu vẫn dùng secret mặc định.
