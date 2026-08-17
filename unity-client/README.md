# MyZoo — Client Unity (đã dựng sẵn)

Toàn bộ scene, prefab và script đã viết sẵn. Bạn **không phải kéo thả gì** — chỉ mở, bấm 1 menu, rồi ráp asset vào.

## Chạy lần đầu (5 phút)

1. **Bật server** (xem `docs/SETUP_GUIDE.md` phần A):
   ```bash
   cd server && mvn package
   cd .. && java -jar server/target/myzoo-server-0.1.0-SNAPSHOT.jar
   ```
2. **Tạo project Unity**: Unity Hub → New Project → **2D (Built-in Render Pipeline)** → tên tuỳ ý. Unity 6 LTS hoặc 2022.3 LTS đều được.
3. **Đóng Unity**, copy thư mục **`Assets`** trong `unity-client/` vào thư mục project vừa tạo (đè lên `Assets` rỗng của nó).
4. **Mở lại project**, đợi Unity biên dịch xong (vòng xoay góc phải dưới).
5. Trên thanh menu chọn **MyZoo → Dựng scene**. Console báo `dựng scene xong` là được.
6. Bấm **Play** — Splash → Login. Bấm **Chơi ngay** → chọn máy chủ → tạo nhân vật → vào sảnh.

Nếu server chạy ở máy khác, chọn GameObject **App** trong Hierarchy → sửa ô **Base Url** (Android Emulator dùng `http://10.0.2.2:8080`).

## Menu MyZoo

| Menu | Làm gì |
|---|---|
| **Dựng scene** | Tạo lại `Assets/Scenes/Main.unity` + toàn bộ prefab, wire sẵn mọi tham chiếu. Chạy lại bất cứ lúc nào — **sẽ ghi đè scene**, nên asset đã ráp vào scene sẽ mất; ráp asset vào **prefab** thì giữ được |
| **Cấu hình Player Settings** | Khoá màn hình ngang, cho phép gọi HTTP khi dev |

## Ráp asset vào — chỗ nào ráp cái gì

Mọi thứ hiện là hình vuông màu. Bỏ sprite của bạn vào `Assets/Sprites/` rồi gán theo bảng:

| Ráp vào đâu | Ô cần gán | Ghi chú |
|---|---|---|
| `Assets/Prefabs/PlotCell.prefab` | Image **Crop** | Ô đất. Sửa prefab là cả 48 ô đổi theo |
| GameObject **S10_Farm** → script `FarmScreen` | mảng **Crop Sprites** | **Tên sprite phải trùng id**: `wheat`, `corn`, `carrot`, `lettuce`, `potato`, `grass`, `bamboo`, `berry`. Thêm ô **Sprout Sprite** cho cây non |
| GameObject **S20_Zoo** → script `ZooScreen` | mảng **Animal Sprites** | Tên trùng id: `rabbit`, `sheep`, `monkey`, `giraffe`, `elephant`, `panda` |
| GameObject **S40_Minigame** → script `MinigameScreen` | mảng **Fruit Sprites** | Đúng 5 sprite. Bỏ trống thì dùng 5 màu |
| GameObject **S07_CharacterCreate** → script `CharacterCreateScreen` | mảng **Looks** | Mỗi phần tử: `id` (chuỗi server lưu) + `sprite`. Thêm bao nhiêu ngoại hình cũng được, server không cần biết |
| `Assets/Prefabs/HabitatCard.prefab`, `ServerCard.prefab`, `Row.prefab` | Image nền | Đổi khung viền, màu nền |
| **S01_Splash**, các screen | Image **Bg**, **Logo** | Nền từng màn |

**Import sprite pixel-art**: chọn file → Inspector → **Filter Mode = Point (no filter)**, **Compression = None** → Apply. Không làm bước này thì hình bị mờ.

Bộ sprite tạm của dự án nằm ở `client/assets/sprites.png` (kèm toạ độ trong `sprites.json`) nếu bạn muốn dùng trước khi có asset riêng.

## Cây scene sau khi dựng

```
Canvas
├── Screens
│   ├── S01_Splash · S02_Login · S03_Register
│   ├── S06_ServerSelect · S07_CharacterCreate · S08_Loading
│   ├── S09_Lobby
│   └── S10_Farm · S20_Zoo · S30_Missions · S40_Minigame
├── HUD          (tên, Vàng, KC, level, nút về sảnh)
└── Toast        (thông báo đáy màn)
App              (Api + App + ScreenManager)
EventSystem · Main Camera
```

## Sửa gì thì sửa ở đâu

- **Bố cục, kích thước, vị trí**: sửa trực tiếp trong Scene (nhớ: chạy lại "Dựng scene" sẽ mất).
- **Logic màn hình**: `Assets/Scripts/Screens/*.cs`.
- **Gọi API**: `Assets/Scripts/Api.cs` — đã tự gắn token và `requestId` idempotent.
- **Số liệu game** (giá cây, thời gian lớn, giá thú): **không nằm ở client**. Sửa ở server `Catalog.java`, client tự lấy qua `/v1/catalog`.

## Lỗi hay gặp

| Hiện tượng | Cách xử lý |
|---|---|
| Menu **MyZoo** không hiện | Còn lỗi đỏ trong Console → Unity chưa biên dịch xong. Sửa hết lỗi rồi menu tự hiện |
| Console: `Không kết nối được máy chủ` | Server chưa chạy, hoặc Base Url sai (emulator phải dùng `10.0.2.2`) |
| Bấm Play màn hình đen | Chưa chạy **MyZoo → Dựng scene**, hoặc đang mở scene khác — mở `Assets/Scenes/Main.unity` |
| Chữ Việt bị ô vuông | Font mặc định thiếu glyph — thay bằng font Việt trong các component Text |
| Text bị mờ/vỡ khi phóng to | Tăng `Font Size` rồi giảm `Scale`, đừng phóng to Text |
