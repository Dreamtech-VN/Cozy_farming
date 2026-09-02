# Changelog

Theo *Update rule* trong Document Control: mọi thay đổi hệ thống phải cập nhật
tài liệu và changelog tương ứng.

## 0.1.6 — 2026-09-02

### Thay đổi
- **Khung minimap theo bản UI được duyệt**: khung gỗ hai lớp bo góc, gờ sáng phía
  trong, dây lá kèm hoa trắng ở hai góc đối nhau (trên-trái và dưới-phải).
- Nội dung minimap vẽ nền đục theo bảng màu của map (trời chuyển sắc, mặt đất có
  vệt sáng mép cỏ, chấm NPC/người chơi có viền). Trước đó nền để trong suốt nên
  lộ màu khung ra sau và bản đồ trông đục.
- `.hud-right` nới khoảng cách vì dây lá góc dưới tràn ra ngoài khung ~15px và
  đè lên nút chuyển khu.

## 0.1.5 — 2026-09-02

### Thay đổi
- **Card nhân vật bám sát bản UI hơn**: viền gỗ hai tông có vệt sáng, bảng giấy
  cao hơn và có vân, tên to hơn, dây lá kéo dài hết chiều ngang, sao cấp độ lớn hơn.
- **Vẽ lại UI chuyển khu**: thay `<select>` bằng nút gỗ hiện khu hiện tại và sĩ số,
  bấm vào mở lưới 20 khu — mỗi ô có số người, thanh mức đông (xanh/vàng/đỏ), khu
  đầy bị khoá, khu đang đứng được đánh dấu. Dropdown cũ không nhét vừa những
  thông tin này vào một dòng `<option>`.
- Ở map riêng (nông trại), nút khu hiện "riêng · chỉ mình bạn" và bị khoá.
- Sĩ số trên nút khu làm mới mỗi 15 giây thay vì chỉ đọc một lần lúc vào map.

## 0.1.4 — 2026-09-02

### Thay đổi
- **Vẽ lại cụm thông tin nhân vật theo bản UI được duyệt**: khung gỗ nâu, nền
  giấy kem, chân dung tròn viền gỗ trên nền trời, dây lá trang trí cạnh tên,
  badge sao vàng mang cấp độ, thanh XP xanh trên rãnh gỗ.
- Cụm thông tin nhân vật trở lại **góc trên trái**; minimap và dropdown chuyển khu
  dời sang **góc trên phải**. Tiền tệ vẫn ở giữa.
- Chân dung lấy cả phần vai thay vì cắt ngay dưới cằm; khuôn mặt avatar thêm
  miệng và má hồng vì chân dung phóng khá to.
- Số XP bỏ dấu phân cách ngàn: "529 / 9016" thay vì "529 / 9.016" — dạng cũ dễ bị
  đọc nhầm thành số thập phân.

### Sửa lỗi
- Style `.pill` / `.dot` bị xoá nhầm khi thay khối CSS, làm hai ô tiền tệ ở giữa
  HUD mất khung và mất chấm màu.

## 0.1.3 — 2026-09-02

### Thêm mới
- **Khu (channel) cho map public** (doc 03 — public map chia thành nhiều instance,
  doc 16 — player capacity mỗi instance). `data/content/maps.json` khai báo
  `world.channel_count` (hiện là 20); `POST /v1/maps/{id}/enter` nhận `channel`,
  `GET /v1/maps/{id}/channels` trả sĩ số từng khu. Map private (nông trại) bỏ qua khu.
- **`GET /v1/world/atlas`**: đồ hình thế giới — mỗi map là một node, mỗi portal là
  một cạnh — phục vụ bản đồ thành phố.
- **Minimap ở góc trên trái**: sơ đồ khu vực hiện tại với mặt đất, bệ đứng, portal,
  NPC, người chơi khác và vị trí của bạn. Bấm vào mở popup bản đồ khu vực (có nhãn
  đầy đủ) kèm nút **Bản đồ thành phố** hiện toàn bộ map và các cổng nối.
- **Dropdown chuyển khu** ngay dưới minimap, 1–20, kèm sĩ số từng khu.

### Thay đổi
- HUD chia lại ba cụm: trái là minimap + chọn khu, **giữa là tiền tệ (chỉ xu và
  ngọc)**, phải là thông tin nhân vật.
- Năng lượng không còn trên HUD; chuyển xuống panel chọn màn Match-3 — nơi thực
  sự tiêu nó.

## 0.1.2 — 2026-09-02

### Thay đổi
- **Vẽ lại góc thông tin nhân vật.** Thay ba pill rời (tên / level / map) bằng một
  player card gồm: chân dung avatar hình tròn vẽ từ chính cosmetic đang mặc,
  badge level, nickname và thanh tiến độ XP tới cấp kế tiếp. Bấm vào card mở
  thẳng panel Nhân vật.
- Chân dung dùng lại `drawAvatar` của thế giới (`drawAvatarPortrait`), nên thay
  đồ là chân dung đổi theo — không phải duy trì hai bộ hình.
- `client/src/core/progression.js`: công thức level lấy tham số từ `/v1/content`,
  chỉ dùng để hiển thị; server vẫn quyết định cấp độ thật.

### Sửa lỗi
- Các pill tiền tệ ở góc phải HUD bị kéo cao bằng cả cụm thông tin nhân vật bên
  trái (`#hud` thiếu `align-items: flex-start`).

## 0.1.1 — 2026-09-02

### Thay đổi
- **Client hướng màn hình ngang.** Camera lấy khoảng 900px chiều rộng thế giới,
  HUD gom về một hàng, toolbar canh giữa đáy màn hình.
- **Bỏ nút điều khiển cảm ứng.** Điều khiển hoàn toàn bằng bàn phím
  (←/→ hoặc A/D di chuyển, Space/↑/W nhảy, E/Enter tương tác). Màn hình dọc trên
  thiết bị cảm ứng hiện thông báo xoay máy.
- Cảnh vật nền được làm mờ nhẹ để nhân vật và NPC nổi rõ phía trước; nền đất có
  thêm vệt cỏ vì màn hình ngang để lộ nhiều mặt đất hơn.

> Khác doc 12, mục *Responsive* ("MVP ưu tiên mobile portrait"): bản này hướng
> màn hình ngang theo yêu cầu sản xuất. Layout vẫn dùng đơn vị tương đối nên
> quay lại portrait không phải viết lại. Nếu cần chơi trên điện thoại thì phải
> bổ sung lại lớp điều khiển cảm ứng.

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
