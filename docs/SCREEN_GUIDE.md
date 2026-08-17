# MyZoo — Hướng dẫn dựng screen (client Unity)

Tài liệu cho người dựng UI/scene trong Unity. Mỗi screen ghi rõ: bố cục, dữ liệu lấy từ endpoint nào, mỗi nút bấm gọi API gì, và xử lý lỗi/trạng thái. Đọc kèm `docs/SETUP_GUIDE.md` phần C (BASE_URL, 3 quy ước API, bảng endpoint, `MyZooApi.cs`).

Thiết kế chuẩn: **màn hình ngang 16:9, khung logic 960×540** (Canvas Scaler → Scale With Screen Size, Reference 960×540, Match 0.5). Client web mẫu tại `http://localhost:8080` là bản chạy được của đúng các screen này — làm giống nó trước, đẹp sau.

## Sơ đồ điều hướng

```
S00 BOOT ──► S01 ĐẶT TÊN (chỉ khi name null)
   │
   ▼
┌─────────────────────────────────────────────┐
│           HUD (luôn hiển thị)               │
│  S10 FARM ◄──tab──► S20 ZOO   S40 MINIGAME  │
│     │                  │                    │
│  P11 CHỌN CÂY      P21 QUẢN LÝ ZOO          │
│                    P22 CHI TIẾT CHUỒNG      │
│  S30 NHIỆM VỤ + ĐIỂM DANH (nút trên HUD)    │
└─────────────────────────────────────────────┘
S = screen toàn màn · P = panel/popup đè lên screen
```

Kiến trúc gợi ý: 1 scene duy nhất, mỗi screen là 1 GameObject bật/tắt (đơn giản, khỏi lo truyền state giữa scene). Panel là prefab đè lên, nền mờ đen 60%, bấm ngoài hoặc nút ✕ để đóng.

---

## S00 — BOOT / LOADING

**Nhiệm vụ:** lo hết phần mạng trước khi người chơi thấy game.

Thứ tự (coroutine tuần tự):
1. `POST /v1/auth/guest` với token trong PlayerPrefs (nếu có) → lưu lại `guestToken`.
2. `GET /v1/catalog` → cache vào 1 object sống suốt phiên (giá cây, thú, chuồng, level yêu cầu — **mọi số liệu hiển thị lấy từ đây, không hardcode**).
3. `GET /v1/me`, `GET /v1/farm`, `GET /v1/zoo` (chạy song song được).
4. `me.name == null` → sang **S01**; ngược lại → **S10 FARM**.

**UI:** logo + thanh tiến trình + dòng trạng thái ("Đang kết nối..."). Lỗi mạng → popup "Không kết nối được máy chủ" + nút **Thử lại** (chạy lại từ bước lỗi, đừng quay về đầu).

## S01 — ĐẶT TÊN

- 1 InputField (2-20 ký tự — validate độ dài ở client cho đỡ gọi phí, server vẫn kiểm lại) + nút **Bắt đầu**.
- `POST /v1/players/name {name}` → thành công sang S10; lỗi 409 hiện "Tên đã có người dùng" ngay dưới ô nhập, không đóng screen.

## HUD — thanh trên cùng, hiển thị ở mọi screen chính

```
┌──────────────────────────────────────────────────────────────┐
│ [Tên]  [🪙 Vàng] [💎 KC] [🌾 Lv farm] [🦁 Lv zoo]   [Nhiệm vụ] │
│                                    [Farm] [Zoo] [Minigame]   │
└──────────────────────────────────────────────────────────────┘
```

- Dữ liệu từ `GET /v1/me`. **Mọi response mutation đều trả sẵn số dư mới** (`vangBalance`...) — cập nhật HUD từ đó, không cần gọi lại `/v1/me` sau mỗi hành động.
- Nút **Nhiệm vụ** có chấm đỏ khi tồn tại mission `progress >= target && !claimed` (kiểm tra từ lần poll gần nhất).
- Số tiền đổi thì tween/nhấp nháy nhẹ cho người chơi nhận ra.

## S10 — FARM (screen mặc định)

```
┌────────┬───────────────────────────────────┐
│ nhân   │   lưới 48 ô đất = 8 cột × 6 hàng  │
│ vật    │   (mỗi ô ~92×74 trong khung 960)  │
│ chibi  │                                   │
├────────┤                                   │
│ kho    │                                   │
│ nông   │                                   │
│ sản    │                                   │
└────────┴───────────────────────────────────┘
```

**Dữ liệu:** `GET /v1/farm` → `plots[48]` + `storage{}`.

**Mỗi ô đất có 3 trạng thái** (đọc từ `plot.state`):
| Trạng thái | Hiển thị | Bấm vào |
|---|---|---|
| `EMPTY` | đất trống | mở **P11 chọn cây** |
| `GROWING` | mầm/cây nhỏ + progress bar + đếm ngược | tooltip "còn X phút" |
| `READY` | cây trưởng thành + hiệu ứng lấp lánh | `POST /v1/farm/harvest {plotIndex}` |

- Đếm ngược tính client: `readyAt - nowMs` (epoch millis server). Về 0 → tự đổi hình sang READY, **không cần gọi server để đổi hình** — nhưng thu hoạch thì server là trọng tài (409 "Cây chưa chín" nếu đồng hồ máy lệch → cứ hiện message đó).
- Thu hoạch thành công: response có `yield, xp` → bay số "+2 🌾 +5 XP" lên từ ô đất, cộng vào kho hiển thị.
- **Kho nông sản** (từ `storage`): mỗi loại 1 dòng icon + số lượng + nút **Bán** → `POST /v1/farm/sell {foodId, quantity}` (cho chọn số lượng bằng slider hoặc bán hết). Giá bán lấy `catalog.crops[].sellPrice`.

### P11 — Panel chọn cây

- List từ `catalog.crops`: icon, tên, giá hạt (`seedCost`), thời gian (`growthSeconds`), XP.
- Cây có `minFarmLevel > me.farmLevel`: hiện mờ + khoá "Cần Farm Lv X" (số liệu có sẵn, khỏi gọi thử).
- Bấm trồng → `POST /v1/farm/plant {plotIndex, cropId}` → đóng panel, ô đổi sang GROWING. Lỗi 402 → toast "Không đủ Vàng".

## S20 — ZOO

```
┌────────┬───────────────────────────────────┐
│ nhân   │  thẻ chuồng (3 cột, mỗi thẻ       │
│ vật +  │  ~236×130): tên, sức chứa,        │
│ trạng  │  thú + mặt no/đói                 │
│ thái   │                                   │
│ zoo    │  [+ Xây chuồng]                   │
├────────┤                                   │
│ kho zoo│                                   │
└────────┴───────────────────────────────────┘
```

**Dữ liệu:** `GET /v1/zoo` → `habitats[]`, `warehouse{}`, `isOpen`, `foodCoverage`, `totalAppeal`, `pendingVang`.

- **Cột trái:** trạng thái 🟢 mở / 🔴 đóng, độ hấp dẫn, % thú no, và **tiền chờ thu `pendingVang`** — số này server tính sẵn, chỉ hiển thị.
- **Thẻ chuồng:** tên + `(số thú/capacity)`; mỗi thú 1 sprite + badge 😋 no / 🍽️ đói (từ `animal.fed`). Bấm thẻ → **P22**.
- **Nút hành động chính** (góc phải dưới, đổi theo trạng thái):
  - Zoo đóng: **"Mở cửa"** → `POST /v1/zoo/open` (409 "Cần ít nhất 1 con thú" nếu chưa có thú).
  - Zoo mở: **"Thu 🪙X"** → `POST /v1/zoo/collect` và **"Đóng cửa"** → `POST /v1/zoo/close` (close tự thu tiền trước, response có `vangEarned`).

### P21 — Panel quản lý zoo (bấm nút "+ Xây chuồng" hoặc vùng trống)

- **Xây chuồng:** list `catalog.habitatTypes` (giá, sức chứa, khoá theo `minZooLevel`) → `POST /v1/zoo/habitats {typeId}`.
- **Chuyển thức ăn:** list kho nông sản farm + nút chuyển → `POST /v1/zoo/deliver {foodId, quantity}`. Ghi chú cho người chơi: thú chỉ ăn được đồ trong **kho zoo**, phải chuyển từ farm sang.

### P22 — Panel chi tiết chuồng

- Header: tên chuồng, `x/y` thú.
- Nút **"Cho cả chuồng ăn"** → `POST /v1/zoo/feed {habitatId}` — server tự chọn thức ăn hợp khẩu phần từng con từ kho zoo; response `animalsFed` → toast "Đã cho X con ăn". 409 = không con nào đói hoặc hết thức ăn phù hợp.
- **Mua thú:** list `catalog.species` — icon, tên, độ hiếm `[R/SR/SSR]`, hấp dẫn (`appeal`), **khẩu phần** (`diet` — icon các loại cây nó ăn), giá, khoá theo `minZooLevel` → `POST /v1/zoo/animals {habitatId, speciesId}`. 409 "Chuồng đã đầy".

## S30 — NHIỆM VỤ + ĐIỂM DANH (panel toàn màn hoặc drawer)

**Dữ liệu:** `GET /v1/missions` — 6 nhiệm vụ ngày, reset 0h UTC.

- Mỗi dòng: tên, progress bar `progress/target`, thưởng 🪙, và nút theo trạng thái:
  - `progress < target` → nút mờ
  - đủ → nút **"Nhận"** sáng → `POST /v1/missions/claim {missionId}`
  - `claimed` → tick ✓
- Tab/khối **Điểm danh**: nút to `POST /v1/daily/checkin` → hiện `streak` (chuỗi ngày) + thưởng; 409 = hôm nay nhận rồi → hiện trạng thái "Mai quay lại nhé" (đừng hiện lỗi đỏ).
- Tiến độ nhiệm vụ do **server tự ghi** sau mỗi hành động — client không gửi gì thêm, chỉ refresh list khi mở panel.

## S40 — MINIGAME GHÉP TRÁI CÂY

**Vào game:** `POST /v1/minigames/session` → `{sessionId, seed, movesAllowed, maxLines, vangPerLine}`.

- **Sinh bàn 6×6 từ `seed`** bằng PRNG xác định — bắt buộc, để server tái lập ván chơi khi cần. Client web dùng mulberry32 (xem hàm trong `client/app.js`); C# viết lại y hệt phép toán (dùng `uint`).
- 5 loại trái cây. Chọn 2 ô kề nhau để hoán đổi; ăn khi có ≥3 thẳng hàng; không ăn thì hoán trả lại và **vẫn trừ lượt**; ô ăn xong rơi xuống, sinh ô mới **từ cùng PRNG**.
- HUD ván: lượt còn lại (từ `movesAllowed` đếm xuống), số hàng đã ăn, thưởng dự kiến `hàng × vangPerLine`.
- Hết lượt hoặc bấm **"Kết thúc"** → `POST /v1/minigames/finish {sessionId, linesMade}` → popup kết quả `vangReward`. Server kẹp thưởng ≤ `maxLines × vangPerLine`; gửi lại lần 2 cùng session không được thưởng thêm.
- Thoát ngang (tắt app): không sao — session bỏ dở không tốn gì; lần sau tạo session mới.

---

## Quy tắc chung cho mọi screen

**Refresh dữ liệu:**
- Response của mọi mutation đã chứa dữ liệu mới (số dư, kho, trạng thái) → cập nhật UI ngay từ response, **không** gọi GET lại.
- Poll nền `GET /v1/farm` + `/v1/zoo` mỗi 10-15 giây (cây chín, tiền zoo tích) — chỉ khi đang ở screen tương ứng cho đỡ tốn.
- Quay lại app sau khi minimize (`OnApplicationFocus`) → refresh cả me/farm/zoo ngay.

**Xử lý lỗi thống nhất (1 hàm dùng chung):**
| Mã | Xử lý |
|---|---|
| 401 | token hỏng → xoá PlayerPrefs, về S00 login lại |
| 402 / 403 / 409 | toast field `error` (server trả sẵn tiếng Việt), refresh dữ liệu screen hiện tại |
| 5xx / timeout | toast "Mất kết nối" + **retry cùng body** (giữ nguyên `requestId` — an toàn tuyệt đối, xem SETUP_GUIDE C3) |

**Bấm nút gọi API:** disable nút tới khi có response (chặn double-tap). Idempotency bảo vệ tiền bạc rồi, nhưng disable vẫn cần cho UX.

**Sprite tạm:** `client/assets/sprites.png` + toạ độ trong `sprites.json` — import Filter = Point, Compression = None. Mapping tên sprite: `crop_<cropId>`, `animal_<speciesId>`, `fruit_*` (minigame), `icon_coin/gem/heart/hungry`, `tile_*`, `char_farmer/keeper`, `sprout`, `plant_mid` — id khớp thẳng với id trong catalog.

## Thứ tự dựng khuyên dùng (mỗi bước ra được bản chơi thử)

1. S00 Boot + HUD (login, hiện được tên + Vàng) — thông API là xong nửa việc
2. S10 Farm + P11 (trồng → đợi → thu hoạch → thấy Vàng/kho đổi)
3. Kho + nút bán (khép vòng tiền đầu tiên)
4. S20 Zoo + P21/P22 (xây → mua thú → chuyển thức ăn → cho ăn → mở cửa → thu tiền)
5. S30 Nhiệm vụ + điểm danh
6. S40 Minigame
7. Polish: tween, âm thanh, hiệu ứng bay số, chấm đỏ nhiệm vụ
