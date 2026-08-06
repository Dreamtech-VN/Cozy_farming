# Game server — dự án mới

Server Java cho game mới (client Unity/C#). Bắt đầu lại từ đầu sau khi dừng
dự án nông trại cũ (Cozy Farming) — xem lịch sử git nếu cần tham khảo code
cũ.

## Quy trình: từng giai đoạn, xong mới sang giai đoạn kế

- [x] **Giai đoạn 1 — khung project**: Maven project biên dịch + chạy được,
      `DataSourceProvider` (HikariCP, đọc `DB_URL`/`DB_USER`/`DB_PASSWORD`
      từ biến môi trường, không hardcode tài khoản), 1 endpoint `/health`
      xác nhận server sống, có test JUnit xác nhận.
- [x] **Giai đoạn 2 — tài khoản**: 1 bảng `users` duy nhất cho MỌI cách đăng
      nhập — 1 user id xuyên suốt, các cột định danh (`username`,
      `guest_token`, `google_id`, `apple_id`) đều nullable, thêm dần khi liên
      kết chứ không tạo bản ghi mới.
      - `POST /api/auth/register` {username, password} — tài khoản thường.
      - `POST /api/auth/login` {username, password}.
      - `POST /api/auth/guest` {guestToken?} — không gửi token (hoặc gửi
        token lạ) thì tạo khách mới, trả token để client tự lưu; gửi đúng
        token cũ thì vào lại ĐÚNG tài khoản đó (không tạo mới).
      - `POST /api/auth/forgot/{request,reset}` — mã 6 số, hạn 15 phút.
        ⚠️ CHƯA gửi email/SMS thật, trả `devOnlyCode` để test.
      - `POST /api/auth/link/upgrade` {userId, username, password} — khách
        nâng cấp lên tài khoản thường, GIỮ NGUYÊN user id (không mất tiến
        trình). Chặn nếu user không phải khách thuần (409) hoặc username
        trùng (409).
      - `POST /api/auth/social/{google,apple}` {idToken} — đăng nhập THẲNG
        bằng mạng xã hội: đã liên kết thì vào lại đúng tài khoản, chưa từng
        liên kết thì tạo tài khoản MỚI (chỉ có mạng xã hội, chưa có
        username/password).
      - `POST /api/auth/link/{google,apple}` {userId, idToken} — gắn thêm
        mạng xã hội vào tài khoản ĐANG đăng nhập (thường dùng khi đã đăng
        nhập bằng username/password). Chặn nếu id đó đã gắn cho user khác
        (409) — không tự gộp 2 tài khoản.
      - **Khung xác thực OAuth** (`auth/oauth/`): `GoogleTokenVerifier` xác
        thực THẬT qua endpoint `tokeninfo` chính chủ Google (không phải
        placeholder) — cần biến môi trường `GOOGLE_CLIENT_ID` (OAuth client
        ID thật từ Google Cloud Console) để so khớp `aud`. `AppleTokenVerifier`
        CHƯA xong thật (Apple ID token cần verify chữ ký JWT qua JWKS, chưa
        thêm thư viện JWT) — chủ động báo lỗi 401 thay vì tin token gửi lên
        (không chấp nhận kiểu "placeholder tin tưởng luôn" vì đó là lỗ hổng
        bảo mật thật), TODO thêm thư viện JWT (vd. nimbus-jose-jwt) khi làm
        thật.
      Test: `PasswordHasherTest`, `UserDaoTest` (đơn vị); `AuthFlowTest`
      (luồng HTTP thật: đăng ký→đăng nhập→quên mật khẩu→đặt lại→đăng nhập
      lại; khách tạo mới rồi vào lại đúng tài khoản bằng token cũ; nâng cấp
      khách giữ nguyên user id rồi đăng nhập được bằng mật khẩu; đăng nhập
      mạng xã hội tạo mới rồi vào lại đúng tài khoản; liên kết mạng xã hội
      vào tài khoản thường rồi bị chặn khi gắn trùng cho tài khoản khác).
- [x] **Giai đoạn 3 — tạo nhân vật**: 1 user 1 nhân vật (bảng `characters`,
      PK trên `user_id`). Trang phục chỉ 3 ô cơ bản (tóc/áo/quần) — CHƯA có
      bảng vật phẩm thật cho game mới này, id trang phục tạm là số nguyên tự
      do, TODO ràng buộc theo catalog thật khi có hệ vật phẩm.
      - `POST /api/character/create` {userId, name, gender, hairId, topId,
        bottomId} — tên 2-20 ký tự, giới tính 0/1, chặn nếu user đã có nhân
        vật (409) hoặc tên trùng người khác (409, kiểm tra toàn server chứ
        không riêng theo user), 404 nếu user không tồn tại.
      - `GET /api/character?userId=` — 404 nếu chưa tạo (client dựa vào đó
        để biết đưa sang màn tạo nhân vật hay vào thẳng sảnh).
      - `POST /api/character/outfit` {userId, hairId, topId, bottomId} — đổi
        trang phục sau khi đã tạo, 404 nếu chưa có nhân vật.
      Test: `CharacterDaoTest` (đơn vị); `CharacterFlowTest` (luồng HTTP
      thật: chưa tạo trả 404, user không tồn tại bị chặn, tên/giới tính
      không hợp lệ bị chặn, tạo 2 lần bị chặn, tên trùng người khác bị chặn,
      đổi trang phục sau khi tạo).
- [x] **Giai đoạn 4 — sảnh**: Sảnh = màn hình chính sau khi đăng nhập + tạo
      nhân vật, mọi người đứng chung 1 world, thấy được nhân vật/vị trí của
      nhau. ⚠️ Làm bằng REST POLLING (bảng `lobby_presence`), KHÔNG phải
      WebSocket — server hiện tại chỉ có `com.sun.net.httpserver` thuần,
      chưa thêm dependency WebSocket. Polling đủ dùng cho sảnh tĩnh (đứng
      nói chuyện/chọn menu), TODO nâng cấp WebSocket nếu cần đồng bộ di
      chuyển mượt hơn sau này.
      - `POST /api/lobby/heartbeat` {userId, x, y} — client gọi định kỳ
        (khuyến nghị mỗi 1-2 giây) để báo còn hoạt động + cập nhật vị trí.
        404 nếu chưa tạo nhân vật (sảnh chỉ hiện người có nhân vật).
      - `GET /api/lobby/players` — danh sách người ĐANG hoạt động (heartbeat
        trong 15 giây gần nhất), JOIN với `characters` để trả kèm
        tên/giới tính/trang phục cho client vẽ được, không chỉ toạ độ trần.
      - `POST /api/lobby/leave` {userId} — thoát chủ động, gỡ khỏi danh sách
        ngay thay vì chờ hết hạn 15 giây.
      Test: `PresenceDaoTest` (đơn vị, heartbeat/hết hạn/ghi đè vị trí/gỡ
      khỏi danh sách); `LobbyFlowTest` (luồng HTTP thật: chưa có nhân vật bị
      chặn, sảnh trống mặc định, heartbeat hiện đúng tên+vị trí, thoát gỡ
      khỏi danh sách ngay).
- [ ] Các giai đoạn sau: chat, cài đặt trong game
      (graphics/audio/controls/gameplay/notifications/language/privacy &
      social/account/support/about).

## Chạy thử

```
cd server
mvn compile
mvn test
mvn -Dserver.port=8080 exec:java
# hoặc: mvn package && java -jar target/game-server-0.1.0-SNAPSHOT.jar
```
