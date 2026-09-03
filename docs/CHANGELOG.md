# Changelog

Theo *Update rule* trong Document Control: mọi thay đổi hệ thống phải cập nhật
tài liệu và changelog tương ứng.

## 0.1.16 — 2026-09-02

### Sửa lỗi
- **Card nhân vật nổi đè lên overlay trận Match-3.** `#hud` để `z-index: auto`
  nên các `z-index` bên trong card (chân dung, bảng) thoát ra stacking context
  gốc và vẽ lên trên cả overlay. Đã đặt `z-index` tường minh cho từng lớp giao
  diện: HUD và toolbar 5, panel 20, overlay 40, toast 50, báo mất kết nối 60,
  nhắc xoay ngang 70.
- **Mây bị mép trên khung nhìn cắt ngang** trông như một mảng trắng dán lên màn
  hình, lộ ra sau khi nâng camera. Mây giờ được giữ đủ thấp so với mép khung.

## 0.1.15 — 2026-09-02

### Thay đổi
- **Bỏ ký hiệu sáng tối khỏi chip** — chính con số giờ đã nói rõ đang là ban ngày
  hay ban đêm. Chip còn giờ + biểu tượng thời tiết, rộng 88px.
- Biểu tượng "trời quang" giờ biết đang là giai đoạn nào: ban đêm vẽ trăng và sao
  thay vì mặt trời. Nếu không, chip hiện mặt trời cạnh con số 22:27 và đọc ra
  mâu thuẫn với chính nó.
- Xoá hàm `phaseIcon` vì không còn nơi dùng.

## 0.1.14 — 2026-09-02

### Thay đổi
- **Chip giờ và thời tiết rút gọn** còn biểu tượng giai đoạn + đồng hồ + biểu
  tượng thời tiết (rộng 112px). Tên giai đoạn và tên thời tiết chuyển vào tooltip.
- Hai tên đó vẫn nằm trong DOM dưới dạng `.sr-only` chứ không `display: none`,
  để người dùng trình đọc màn hình không mất thông tin.

## 0.1.13 — 2026-09-02

### Thay đổi
- **Ví tiền lên trên minimap**, cùng cột phải. Cột phải giờ xếp dọc: ví, minimap,
  rồi dải khu + trạng thái thế giới. Cột trái chỉ còn card nhân vật.
- **Gộp giờ và thời tiết vào một chip**: biểu tượng giai đoạn, đồng hồ, tên giai
  đoạn, vạch ngăn, rồi biểu tượng và tên thời tiết. Cửa sổ thấp thì ẩn tên giai
  đoạn để chip không tràn.

## 0.1.12 — 2026-09-02

### Thêm mới
- **Giờ trong game, sáng tối và thời tiết** (doc 03 — weather/day-night flags).
  `data/content/maps.json` khai báo `world.day_cycle` (một ngày game dài 120 phút
  thật, bốn giai đoạn dawn/day/dusk/night) và `world.weather` (bốn kiểu thời tiết
  có trọng số, đổi mỗi 20 phút).
  - `GET /v1/world/clock?map_id=` trả giờ, giai đoạn và thời tiết của map.
  - Cả hai đều **suy ra xác định** từ thời gian thật và `map_id`, không lưu state:
    mọi người trong cùng khu thấy giống nhau, và không có gì lệch khi scale ngang.
  - Client hỏi lại server mỗi phút rồi tự chạy đồng hồ giữa hai lần hỏi.
- **Thế giới phản ánh trạng thái đó**: lớp phủ sắc theo giai đoạn (bình minh và
  hoàng hôn ám ấm, ban đêm ám xanh lạnh) và mưa/giông vẽ thành vệt rơi.
- Validator kiểm tra các giai đoạn phủ đúng 1440 phút, không hở không chồng, và
  trọng số thời tiết đều dương.

### Thay đổi
- **Bố cục HUD**: ví tiền chuyển sang cột trái, nằm dưới card nhân vật; cột phải
  lùi xuống một hàng nên minimap ngang tầm hàng ví; dưới minimap là một dải gồm
  nút chuyển khu, chip giờ + giai đoạn, và chip thời tiết.

## 0.1.11 — 2026-09-02

### Thay đổi
- **Camera đặt cao hơn**: nhân vật đứng ở ~76% chiều cao khung nhìn thay vì 66%.
  Ở mức cũ gần một phần ba màn hình phía dưới chỉ là nền đất trống, trong khi
  nhà cửa và cây phía trên bị cắt ngọn.

## 0.1.10 — 2026-09-02

### Thay đổi
- **Dựng lại bố cục cụm thông tin nhân vật.** Badge cấp chuyển lên gác vào viền
  chân dung; tên đứng riêng một dòng, thanh XP và số nằm dòng dưới. Bản trước xếp
  sao, thanh và số cùng một hàng nên ba thứ tranh chỗ, không có điểm nhìn.
- **Chất kính làm lại**: nền là gradient tối rất nhẹ ở trên đậm dần xuống dưới
  thay cho một lớp phủ đục đều; ánh sáng dội gom về mép trên thay cho vệt chéo
  phủ cả mặt; bóng kép (một bóng tiếp xúc sát + một bóng toả rộng) để khung nổi
  khỏi nền thay vì như dán lên màn hình.
- **Xu và ngọc vẽ thành hai vật thể khác chất** — xu tròn có highlight và vành
  sáng, ngọc cắt `clip-path` nhiều mặt — thay cho hai chấm tròn chỉ khác màu.
- **Nhãn tên khu vực** thành chip nhỏ nằm trong khung minimap; biển treo dưới đáy
  ở bản trước làm khối bị lệch và đè lên nút chuyển khu.
- Rãnh thanh XP dùng nền sáng mờ thay vì nền tối đặc — nền tối làm thanh trông
  rỗng khi tiến độ còn ít.

## 0.1.9 — 2026-09-02

### Thay đổi
- **HUD chuyển sang chất kính mờ (frosted glass)**: khung thông tin nhân vật,
  khung minimap, biển tên khu vực, nút chuyển khu, pill tiền tệ và toolbar dùng
  chung bộ token `--glass-*` — nền mờ `backdrop-filter`, viền sáng mảnh, vệt sáng
  chéo và bóng đổ mềm.
- Lớp kính pha tối và chữ sáng: nền game sáng (trời xanh, cỏ), kính sáng kèm chữ
  tối sẽ mất tương phản khi khung đứng trên nền cỏ.
- Badge sao vàng giữ nguyên làm điểm nhấn đục trên nền kính.
- Bỏ toàn bộ trang trí dây lá và bảng màu gỗ/giấy — chúng chọi với chất kính.

### Ghi chú kỹ thuật
Không đặt `filter` trên phần tử cha của một mặt kính: `filter` vô hiệu hoá
`backdrop-filter` của con, kính sẽ mất khả năng nhìn xuyên nền. Bóng đổ vì thế
nằm ở từng mảnh kính bằng `box-shadow`.

## 0.1.8 — 2026-09-02

### Thay đổi
- **Khung minimap vẽ lại hoàn toàn bằng CSS**, bỏ hai file SVG asset của 0.1.7.
  Vân gỗ là ba lớp gradient chồng nhau (hai lớp sọc lặp lệch góc và lệch chu kỳ
  để không thành ca-rô, cộng một lớp khối màu); gờ vát và bóng đổ bằng `box-shadow`.
- **Dây lá góc cũng vẽ bằng CSS**: thân dây là hình tròn chỉ tô hai cạnh (thành
  một cung ôm góc), thêm hai nhánh chạy dọc cạnh khung và một tua cuốn; lá bo hai
  góc đối nhau với gân giữa bằng gradient; hoa là sáu lớp radial-gradient
  (năm cánh và một nhuỵ). Góc dưới-phải dùng lại cùng bộ class, xoay 180°.

### Ghi chú
Mọi chi tiết trang trí phải nằm trong dải chữ L của khung — phần tử có cả `top`
và `left` vượt quá bề dày khung sẽ đè lên lòng bản đồ.

## 0.1.7 — 2026-09-02

### Thêm mới
- **`client/assets/ui/frame-wood.svg`**: asset khung gỗ dùng qua CSS `border-image`
  (9-slice). Vân gỗ bằng `feTurbulence` cộng các đường đồng tâm, gờ vát sáng ngoài
  và tối trong, góc bo. Co giãn ở mọi kích thước mà không méo góc.
- **`client/assets/ui/vine-corner.svg`**: cụm dây lá cho góc khung — thân dây có
  tua cuốn, lá có gân giữa, một hoa lớn và một hoa nhỏ lệch nhịp. Góc dưới-phải
  dùng lại chính file này, xoay 180° bằng CSS.

### Thay đổi
- Khung minimap chuyển từ xếp chồng `box-shadow` sang dùng hai asset trên.
- Tên khu vực thành biển gỗ nhỏ gác lên cạnh dưới khung, thay cho dải tối phủ
  ngang bản đồ (dải đó che mất phần đất phía dưới).

### Ghi chú
Phiên làm việc này không có công cụ sinh ảnh AI. Asset được dựng bằng SVG viết
tay; khoảng cách còn lại so với bản UI tham chiếu là chất liệu vẽ tay, cần hoạ sĩ.

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
