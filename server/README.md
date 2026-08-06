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
- [ ] Các giai đoạn sau: tạo nhân vật (giới tính/tên/trang phục), sảnh, chat,
      cài đặt trong game (graphics/audio/controls/gameplay/notifications/
      language/privacy & social/account/support/about).

## Chạy thử

```
cd server
mvn compile
mvn test
mvn -Dserver.port=8080 exec:java
# hoặc: mvn package && java -jar target/game-server-0.1.0-SNAPSHOT.jar
```
