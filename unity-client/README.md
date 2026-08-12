# Cozy Farming — Unity client

Dựng theo đúng `server/UNITY_INTEGRATION.md` (kế hoạch có sẵn của team).
Không dùng bất kỳ asset nào từ `assets/gunpow-mobi/` (asset của game
GunPow Mobi thuộc bên khác, chỉ giữ làm tài liệu tham khảo).

**Lưu ý quan trọng:** môi trường soạn code này không có Unity Editor cài
sẵn, nên phần script C# dưới đây viết tay theo đúng API thật của server
(đã verify bằng cách chạy server thật + curl, xem lịch sử session), nhưng
**chưa được build/test trong Unity**. Mở project lần đầu, Unity có thể báo
vài lỗi nhỏ cần sửa (thường là thiếu package hoặc thiếu reference Inspector
— xem mục "Việc còn lại phải làm trong Editor" bên dưới).

Cũng đã phát hiện và sửa 2 chỗ `UNITY_INTEGRATION.md` (viết trước khi có
đợt sửa bug bảo mật battle engine gần đây) bị lệch so với server hiện tại:
1. `swap`/`ultimate` giờ **bắt buộc** có `userId` trong body (server trả
   403 nếu thiếu hoặc sai chủ trận) — code trong `BattleService.cs` ở đây
   đã gửi đúng, tài liệu gốc cũng đã được cập nhật theo.
2. Mục 4 của tài liệu mô tả `UserResponse` với field `id/username/googleId/
   appleId/displayName` — không khớp response thật của
   `POST /api/auth/guest` (thực tế trả `{userId, guestToken, isNew}`, xem
   `GuestLoginHandler.java`). Client ở đây dùng đúng `GuestLoginResponse`
   khớp response thật; `RegisterHandler`/`LoginHandler` lại trả
   `{userId, username}` — cũng khác — nếu làm thêm màn đăng ký/đăng nhập
   bằng mật khẩu thì tạo response model riêng cho đúng, đừng copy nguyên
   `UserResponse` trong tài liệu.

## Cấu trúc đã có

```
Assets/Scripts/
  Network/ApiClient.cs, ApiException.cs   — lớp gọi HTTP dùng chung (đúng bản trong UNITY_INTEGRATION.md)
  Auth/Session.cs                         — userId/guestToken/battleId dùng chung cả phiên chơi
  Auth/AuthModels.cs, AuthService.cs      — đăng nhập khách, tự lưu/nạp guestToken qua PlayerPrefs
  Character/CharacterModels.cs, OutfitAssets.cs, CharacterService.cs
                                           — tạo nhân vật (Giai đoạn 3), bảng ánh xạ trang phục tự quy ước
  Battle/BattleStateView.cs               — model khớp BattleStateView bên server
  Battle/BattleService.cs                 — start/swap/ultimate/state (đều gửi kèm userId)
  Battle/BattleEvents.cs                  — event tĩnh để HUD nghe cập nhật trạng thái trận
  Battle/BattleHud.cs                     — thanh HP/mana + nút chiêu cuối + text trạng thái
  Battle/Engine/BoardRenderer.cs          — vẽ bàn cờ 8x8, bắt click đổi ô
  Battle/Engine/BoardTile.cs              — gắn vào tilePrefab để nhận click (cần Collider2D)
  Bootstrap/GameBootstrap.cs              — nối cả luồng: đăng nhập -> chọn màn -> vào trận
Packages/manifest.json                    — Newtonsoft Json + package UI/2D cần thiết
ProjectSettings/ProjectVersion.txt        — ghim bản Unity 2022.3 LTS (đổi nếu bạn dùng bản khác)
```

Đây là 1 lát cắt dọc (vertical slice) đủ chạy: đăng nhập khách → danh sách
màn Story → đấu match-3 (swap + ultimate) → thắng/thua. **Chưa làm**: tạo
nhân vật (script có sẵn, chưa nối UI), Lobby/Chat, Cosmetic, Guild, PvP —
tài liệu `UNITY_INTEGRATION.md` mục 6, 8, 9, 10 đã có sẵn code mẫu tương
tự, nối theo đúng pattern `XxxService.cs` gọi `ApiClient` như các module
trên.

## Mở project

1. Cài Unity Hub + Unity **2022.3 LTS** (hoặc sửa `ProjectSettings/
   ProjectVersion.txt` sang bản bạn có sẵn).
2. Unity Hub → "Add" → chọn thư mục `unity-client/` → mở bằng đúng bản
   Editor. Unity sẽ tự sinh nốt các file `ProjectSettings/*.asset` còn
   thiếu (bình thường, không phải lỗi).
3. Đợi Package Manager tải xong Newtonsoft Json (theo `manifest.json`,
   không cần cài tay qua mục 1 của `UNITY_INTEGRATION.md` nữa).
4. Chạy server (xem `server/SETUP.md`), đảm bảo nghe ở `localhost:8080`
   (đúng mặc định trong `ApiClient.BaseUrl`).

## Việc còn lại phải làm trong Editor (không hand-author được từ ngoài)

File scene `.unity` cố tình KHÔNG tạo sẵn — tự tay ghép GUID/fileID khi
không có Editor để kiểm chứng rất dễ hỏng cả file. Tạo scene mới trong
Unity rồi ghép theo cấu trúc:

```
GameBootstrap (empty GameObject, gắn script GameBootstrap.cs)
Canvas (UI)
  LevelSelectPanel
    LevelListContent (Vertical Layout Group, kéo vào ô "Level List Content")
    LevelButtonPrefab (Button + Text con, kéo vào ô "Level Button Prefab")
  BattlePanel
    BoardRoot (Transform trống, kéo vào BoardRenderer.boardRoot)
    HUD (gắn BattleHud.cs, kéo 3 Slider + 1 Button + 1 Text tương ứng)
StatusText (kéo vào ô "Status Text" của GameBootstrap)
```

`tilePrefab` (kéo vào `BoardRenderer.tilePrefab`) cần: `SpriteRenderer` +
`BoxCollider2D` (để `BoardTile.OnMouseDown` bắt được click) + `Sprite
Sort Point`/kích thước tuỳ ý. `gemSprites[0..5]` là 6 sprite bất kỳ bạn
tự có quyền dùng — server không quy định gem màu gì ứng số nào, chỉ cần
nhất quán.

## Vì sao chưa dùng art thật

Không có art nào của Cozy Farming sẵn có trong repo lúc viết bản này —
`gemSprites`/`tilePrefab`/sprite trang phục ở `OutfitAssets` đều để trống,
tự điền khi có art thật (không lấy từ `assets/gunpow-mobi/`, xem đầu file
này).
