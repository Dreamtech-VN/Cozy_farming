# MyZoo — Hướng dẫn dựng screen (client Unity)

Đặc tả từng screen: bố cục, dữ liệu lấy từ endpoint nào, mỗi nút bấm gọi API gì, xử lý lỗi/trạng thái.

👉 **Cần hướng dẫn thao tác cụ thể trong Unity** (tạo GameObject nào, gắn component gì, script dán vào đâu): xem **[UNITY_STEP_BY_STEP.md](UNITY_STEP_BY_STEP.md)**. Đọc kèm `SETUP_GUIDE.md` phần C cho BASE_URL và bảng endpoint.

Thiết kế chuẩn: **màn hình ngang 16:9, khung logic 960×540** (Canvas Scaler → Scale With Screen Size, Reference 960×540, Match 0.5). Client web mẫu tại `http://localhost:8080` là bản chạy được của đúng các screen này — làm giống nó trước, đẹp sau.

## Sơ đồ điều hướng

```
S01 SPLASH ─► S02 ĐĂNG NHẬP ─┬─► S03 ĐĂNG KÝ ─┐
                             ├─► chơi khách ───┤
                             └─► auto-login ───┤
                                               ▼
                              S06 CHỌN SERVER ─► S07 TẠO NHÂN VẬT
                                                       │
                                          S08 VÀO GAME (tải dữ liệu)
                                                       ▼
┌──────────────────────────────────────────────────────────────┐
│                    HUD (luôn hiển thị)                       │
│                     S09 SẢNH CHÍNH                           │
│   S10 FARM      S20 ZOO      S40 MINIGAME     S30 NHIỆM VỤ   │
│      │             │                                         │
│  P11 CHỌN CÂY  P21 QUẢN LÝ ZOO / P22 CHI TIẾT CHUỒNG         │
└──────────────────────────────────────────────────────────────┘
S = screen toàn màn · P = panel/popup đè lên screen
```

Người chơi cũ (đã có token trong PlayerPrefs) đi thẳng S01 → S08 → S09, bỏ qua S02/S06/S07.

Kiến trúc gợi ý: 1 scene duy nhất, mỗi screen là 1 GameObject bật/tắt (đơn giản, khỏi lo truyền state giữa scene). Panel là prefab đè lên, nền mờ đen 60%, bấm ngoài hoặc nút ✕ để đóng.

---

## S01 — SPLASH / KHUNG VÀO GAME

**Mục đích:** kiểm tra phiên bản, bảo trì, và tự đăng nhập nếu có token cũ.

**UI:** logo, thanh tiến trình, số phiên bản góc màn, chỗ trống cho banner bảo trì.

**Luồng:**
1. `GET /v1/config` (không cần token) → `{gameVersion, minClientVersion, maintenance, maintenanceMessage, serverTime}`.
   - `maintenance == true` → hiện `maintenanceMessage` + nút **Thử lại**, **dừng ở đây** (mọi API khác trả 503).
   - Phiên bản client < `minClientVersion` → hiện "Cần cập nhật" + nút ra store, dừng.
   - Lưu `serverTime` để tính chênh lệch đồng hồ: `offset = serverTime - thời gian máy`. Dùng offset này cho mọi đếm ngược trong game.
2. Có `sessionToken` trong PlayerPrefs → thử `GET /v1/me`:
   - 200 và `name != null` → nhảy thẳng **S08**.
   - 200 và `name == null` → **S06** (đăng ký giữa chừng lần trước).
   - 401 → token hết hạn, sang **S02**.
3. Không có token → **S02**.

Lỗi mạng → popup "Không kết nối được máy chủ" + **Thử lại** (chạy lại từ bước lỗi, đừng về đầu).

## S02 — ĐĂNG NHẬP

**UI:** logo · ô Tên đăng nhập · ô Mật khẩu (ẩn ký tự) · nút **Đăng nhập** · link **Đăng ký** → S03 · nút phụ **Chơi ngay (khách)**.

| Hành động | API | Xử lý kết quả |
|---|---|---|
| Đăng nhập | `POST /v1/auth/login {username, password}` | Trả `{accountId, playerId, username, sessionToken, name, serverId, needsCharacter}` |
| Chơi khách | `POST /v1/auth/guest {guestToken?}` | Trả `{playerId, guestToken, sessionToken, isNew, name, serverId}` |

- **Lưu ngay 2 thứ vào PlayerPrefs:** `sessionToken` (dùng cho mọi request) và `guestToken` nếu chơi khách (credential thiết bị, dùng để tự vào lại và để nâng cấp tài khoản sau này).
- Đi tiếp: `needsCharacter == true` (hoặc `name == null`) → **S06**; ngược lại → **S08**.
- Lỗi: `401` "Sai tên đăng nhập hoặc mật khẩu" hiện dưới ô mật khẩu; `403` = tài khoản bị khoá, hiện popup.
- Nút Đăng nhập disable trong lúc chờ response.

## S03 — ĐĂNG KÝ

**UI:** ô Tên đăng nhập · Mật khẩu · Nhập lại mật khẩu · checkbox điều khoản · nút **Tạo tài khoản** · link quay lại S02.

`POST /v1/auth/register {username, password, guestToken?}`

- **Quan trọng — giữ tiến độ chơi khách:** nếu người chơi đang chơi khách và bấm đăng ký, **gửi kèm `guestToken`** đang có trong PlayerPrefs. Server gắn tài khoản vào đúng nhân vật đó, giữ nguyên Vàng/nông trại/sở thú. Không gửi thì tạo nhân vật mới toanh (mất tiến độ khách).
- Validate ở client cho nhanh, server vẫn kiểm lại: tên đăng nhập 4-32 ký tự `a-z 0-9 _` (server tự hạ chữ thường), mật khẩu 6-64 ký tự, 2 ô mật khẩu phải khớp (client tự kiểm).
- Lỗi: `409` "Tên đăng nhập đã tồn tại" hoặc "Tài khoản này đã đăng ký rồi" (khách đã liên kết trước đó); `400` kèm thông báo cụ thể.
- Thành công → lưu `sessionToken` → `needsCharacter` quyết định đi **S06** hay **S08**.

**Đổi mật khẩu** (đặt trong Cài đặt, thay cho quên-mật-khẩu vì chưa có email/OTP): `POST /v1/auth/password {password, newPassword}`, cần token. Sai mật khẩu cũ → 401.

**Đăng xuất:** `POST /v1/auth/logout` → xoá `sessionToken` khỏi PlayerPrefs, về S02. Lưu ý `guestToken` vẫn còn giá trị (vào lại được bằng thiết bị) — muốn "thoát hẳn" thì xoá cả hai.

## S06 — CHỌN SERVER

`GET /v1/servers` → `{servers: [{id, name, region, status, population, recommended}]}`

**UI:** tab khu vực (`region`) · list thẻ server: tên, chấm trạng thái, mức tải, huy hiệu "Đề xuất" khi `recommended`.

| `status` | Hiển thị | Bấm được? |
|---|---|---|
| `ONLINE` | chấm xanh | ✅ |
| `FULL` | chấm vàng "Đầy" | ❌ |
| `MAINTENANCE` | chấm xám "Bảo trì" | ❌ |
| `LOCKED` | ổ khoá | ❌ |

`population`: `SMOOTH` (mượt) / `BUSY` (đông) — chỉ để hiển thị.

Chọn server → `POST /v1/servers/select {serverId}` → trả profile đã cập nhật. Lỗi `404` server không tồn tại, `409` server không nhận người chơi. Sau đó: `name == null` → **S07**, ngược lại → **S08**.

## S07 — TẠO NHÂN VẬT

**UI:** khung xem trước nhân vật (giữa) · nút mũi tên đổi ngoại hình trái/phải · ô nhập tên · nút 🎲 random tên · nút **Vào game**.

`POST /v1/players {name, avatar}`

- `avatar` là **chuỗi id ngoại hình** do client tự quy ước (`farmer_1`, `farmer_2`, `keeper_1`...), server chỉ lưu và trả lại — bạn tự do thêm ngoại hình mà không cần đụng server. Bỏ trống → server mặc định `farmer_1`.
- Luật tên (server kiểm, client nên kiểm trước cho mượt): 2-20 ký tự; chỉ chữ (có dấu tiếng Việt được), số, dấu cách, gạch dưới; không chứa từ cấm (`admin`, `gm `, `quantri`, `moderator`); không trùng tên người khác.
- Lỗi: `400` kèm lý do cụ thể hiện ngay dưới ô tên; `409` "Tên đã có người dùng" → gợi ý tên khác, **đừng đóng screen**.
- Thành công → **S08**.

## S08 — KHUNG TẢI DỮ LIỆU (VÀO GAME)

**UI:** artwork toàn màn · thanh tiến trình · dòng mẹo chơi đổi mỗi vài giây.

Chỉ cần **2 lời gọi**:
1. `GET /v1/catalog` → cache suốt phiên (giá cây/thú/chuồng, thời gian lớn, level yêu cầu). **Mọi số liệu hiển thị lấy từ đây, không hardcode trong client.**
2. `GET /v1/world/snapshot` → gói gọn `{me, farm, zoo, missions}` trong 1 request — dùng cái này thay vì gọi lẻ 4 endpoint lúc khởi động.

Nạp xong → **S09**. Lỗi giữa chừng → nút Thử lại chạy lại đúng bước hỏng.

## S09 — SẢNH CHÍNH

Màn điều hướng trung tâm sau khi vào game. **Không cần gọi API riêng** — dữ liệu đã có từ snapshot.

```
┌──────────────────────────────────────────────┐
│ HUD: tên · 🪙 · 💎 · Lv farm · Lv zoo · ⚙️     │
├──────────────────────────────────────────────┤
│                                              │
│   [🌾 NÔNG TRẠI]        [🦁 SỞ THÚ]           │
│                                              │
│   [🎮 MINIGAME]         [📋 NHIỆM VỤ •]       │
│                                              │
│   nhân vật chibi đứng giữa sảnh              │
├──────────────────────────────────────────────┤
│  [Điểm danh]  [Cài đặt]                      │
└──────────────────────────────────────────────┘
```

- 4 nút lớn dẫn sang S10 / S20 / S40 / S30.
- **Chấm đỏ** trên nút Nông trại khi có ô `state == "READY"`; trên nút Sở thú khi `pendingVang > 0` hoặc có thú `fed == false`; trên Nhiệm vụ khi có mission `progress >= target && !claimed`. Tất cả tính từ snapshot, không cần API riêng.
- Nút **Điểm danh** nổi bật nếu hôm nay chưa nhận (thử `POST /v1/daily/checkin`, gặp 409 thì coi như đã nhận — hoặc nhớ ngày nhận gần nhất ở client cho đỡ gọi).
- Vào lại app sau khi minimize → gọi lại `GET /v1/world/snapshot` rồi refresh sảnh.

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
- Quay lại app sau khi minimize (`OnApplicationFocus`) → gọi `GET /v1/world/snapshot` refresh một lần.

**Xử lý lỗi thống nhất (1 hàm dùng chung):**
| Mã | Xử lý |
|---|---|
| 401 | token hết hạn → xoá `sessionToken`, về **S02** (còn `guestToken` thì thử đăng nhập khách trước) |
| 402 / 403 / 409 | toast field `error` (server trả sẵn tiếng Việt), refresh dữ liệu screen hiện tại |
| 5xx / timeout | toast "Mất kết nối" + **retry cùng body** (giữ nguyên `requestId` — an toàn tuyệt đối, xem SETUP_GUIDE C3) |

**Bấm nút gọi API:** disable nút tới khi có response (chặn double-tap). Idempotency bảo vệ tiền bạc rồi, nhưng disable vẫn cần cho UX.

**Sprite tạm:** `client/assets/sprites.png` + toạ độ trong `sprites.json` — import Filter = Point, Compression = None. Mapping tên sprite: `crop_<cropId>`, `animal_<speciesId>`, `fruit_*` (minigame), `icon_coin/gem/heart/hungry`, `tile_*`, `char_farmer/keeper`, `sprout`, `plant_mid` — id khớp thẳng với id trong catalog.

## Thứ tự dựng khuyên dùng (mỗi bước ra được bản chơi thử)

1. **S01 + S02 (nút "Chơi ngay") + S08 + S09 + HUD** — đường ngắn nhất để vào được sảnh; thông API là xong nửa việc
2. **S10 Farm + P11** (trồng → đợi → thu hoạch → thấy Vàng/kho đổi)
3. **Kho + nút bán** (khép vòng tiền đầu tiên)
4. **S20 Zoo + P21/P22** (xây → mua thú → chuyển thức ăn → cho ăn → mở cửa → thu tiền)
5. **S03 đăng ký + S06 chọn server + S07 tạo nhân vật** — làm sau cùng trong nhóm bắt buộc, vì chơi khách đã đủ để test toàn bộ gameplay
6. **S30 Nhiệm vụ + điểm danh**, **S40 Minigame**
7. Polish: tween, âm thanh, hiệu ứng bay số, chấm đỏ
