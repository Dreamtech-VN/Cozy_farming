# MyZoo 🐰🌾

Game nông trại + sở thú 2D chibi, màn hình ngang, xây theo **MyZoo Remake Technical Spec v1.6** (trích xuất tại `docs/SPEC-extracted.txt`).

Vòng lặp cốt lõi: **Trồng trọt → Thu hoạch thức ăn → Chuyển sang Zoo → Cho thú ăn → Mở cửa đón khách → Thu Vàng → Tái đầu tư.**

## Kiến trúc

- **Server**: Java 21, `com.sun.net.httpserver` + Gson + HikariCP. Server-authoritative: client chỉ gửi ý định, server kiểm tra mọi giá tiền/thời gian.
  - Sổ cái kinh tế bất biến (`economy_ledger`) cho mọi thay đổi số dư.
  - Idempotency key: retry cùng `requestId` trả đúng response cũ, không chạy lại giao dịch.
  - Thời gian đánh giá lười (lazy): cây chín theo `ready_at`, doanh thu zoo tích lũy khi mở cửa (trần 8h), thú "no" trong 4h sau khi ăn.
- **DB**: H2 file (mặc định, không cần cài gì) hoặc MySQL qua biến môi trường `DB_URL`, `DB_USER`, `DB_PASSWORD`. Schema tự tạo khi khởi động.
- **Client web**: HTML5 Canvas thuần (không cần build), 960×540 landscape, do chính server phục vụ.
- **Asset 2D**: sprite pixel-art chibi **gốc của dự án** (không dùng asset bên thứ ba), sinh từ `tools/gen_sprites.py` ra `client/assets/sprites.png` + atlas JSON. Muốn sửa/thêm sprite: sửa lưới ký tự trong script rồi chạy lại `python3 tools/gen_sprites.py`.
- **Client Unity** (Android/iOS): do team tự dựng — xem `docs/SETUP_GUIDE.md` và `docs/SCREEN_GUIDE.md`.

> 📖 **Tài liệu:**
> - **[docs/SETUP_GUIDE.md](docs/SETUP_GUIDE.md)** — setup server local bằng VSCode, deploy VPS, build client Unity + kết nối API
> - **[docs/SCREEN_GUIDE.md](docs/SCREEN_GUIDE.md)** — dựng từng screen trong Unity: bố cục, nút nào gọi API nào, xử lý lỗi

## Chạy game

```bash
cd server && mvn package
cd .. && java -jar server/target/myzoo-server-0.1.0-SNAPSHOT.jar
# Mở http://localhost:8080
```

Biến môi trường: `SERVER_PORT` (mặc định 8080), `CLIENT_DIR` (mặc định `client`), `DB_URL`/`DB_USER`/`DB_PASSWORD` (mặc định H2 file `./myzoo-data`).

## API chính (`/v1`)

| Endpoint | Mô tả |
|---|---|
| `POST /v1/auth/guest` | Đăng nhập khách (tạo mới hoặc theo `guestToken`), tặng 1000 Vàng khởi đầu |
| `GET /v1/me` · `POST /v1/players/name` | Hồ sơ, ví, level; đặt tên |
| `GET /v1/catalog` | Danh mục cây trồng / loài thú / loại chuồng |
| `GET /v1/farm` · `POST /v1/farm/plant` · `POST /v1/farm/harvest` | 48 ô đất, trồng & thu hoạch |
| `GET /v1/zoo` · `POST /v1/zoo/habitats` · `POST /v1/zoo/animals` | Xây chuồng, mua thú |
| `POST /v1/zoo/deliver` · `POST /v1/zoo/feed` | Chuyển thức ăn từ farm, cho thú ăn |
| `POST /v1/zoo/open` · `/close` · `/collect` | Mở/đóng cửa, thu doanh thu khách tham quan |
| `POST /v1/minigames/session` · `/finish` | Minigame ghép trái cây, thưởng theo hàng (server chặn trần) |

Mọi request sau đăng nhập cần header `X-Guest-Token`. Mọi POST thay đổi dữ liệu nhận `requestId` để idempotent.

## Test

```bash
cd server && mvn test
```
