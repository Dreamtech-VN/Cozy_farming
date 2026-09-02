# Changelog

Theo *Update rule* trong Document Control: mọi thay đổi hệ thống phải cập nhật
tài liệu và changelog tương ứng.

## 0.1.0 — 2026-09-02

Baseline hiện thực đầu tiên theo bộ tài liệu 00–24.

### Thêm mới
- **Tài liệu**: chuyển 25 tài liệu thiết kế từ `.docx` sang Markdown trong `docs/`,
  giữ bản gốc trong `docs/source/`; thêm `docs/ARCHITECTURE.md` ánh xạ tài liệu → mã nguồn.
- **Content pipeline** (doc 18): `data/content/` với 12 crop, 32 item, 18 cosmetic,
  5 map, 5 màn Match-3, 9 quest, 3 shop; validator bắt duplicate ID, reference gãy,
  giá trị ngoài khoảng, circular prerequisite và localization gap.
- **Localization** (doc 23): `locales/vi.json`, `locales/en.json` — 129 key, phủ đủ cả hai.
- **Database** (doc 14): 18 bảng + migration runner.
- **API** (doc 15): 38 route `/v1/*` — auth, player, world, farm, match-3, quest,
  shop, social, moderation, liveops, analytics.
- **Realtime** (doc 16): WebSocket tự hiện thực, map instance, presence, xác thực
  chuyển động phía server, chat theo map.
- **Farming** (doc 06): trạng thái cây tính từ timestamp server nên offline progress đúng.
- **Match-3** (doc 07): engine server-authoritative với cascade, 4 loại special tile,
  chống board bí, PvE có enemy HP và phản đòn.
- **Economy** (doc 09/10): ví nhiều loại tiền, transaction nguyên tử, idempotency key, audit log.
- **Client** (doc 03/04/05/12): thế giới 2D side-view, avatar theo layer, HUD,
  panel nhiệm vụ/túi đồ/nông trại/bạn bè/chat/nhân vật, điều khiển cảm ứng.
- **QA** (doc 20): 70 test cho auth, farming, economy/shop, quest, social, match-3, realtime, content.
- **DevOps** (doc 21): CI lint + validate + test + smoke, Dockerfile, systemd unit, script deploy.

### Chưa có trong bản này
- Match-3 PvP (doc 07) — cờ `match3_pvp` đang tắt trong `data/content/liveops.json`.
- Housing, pet, crafting, trading (doc 02) — đã có cờ tính năng, chưa hiện thực.
- Thanh toán thật (doc 10) — luồng shop đã có transaction và idempotency nhưng
  chưa nối store receipt validation.
