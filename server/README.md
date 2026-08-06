# Game server — dự án mới

Server Java cho game mới (client Unity/C#). Bắt đầu lại từ đầu sau khi dừng
dự án nông trại cũ (Cozy Farming) — xem lịch sử git nếu cần tham khảo code
cũ.

## Quy trình: từng giai đoạn, xong mới sang giai đoạn kế

- [x] **Giai đoạn 1 — khung project**: Maven project biên dịch + chạy được,
      `DataSourceProvider` (HikariCP, đọc `DB_URL`/`DB_USER`/`DB_PASSWORD`
      từ biến môi trường, không hardcode tài khoản), 1 endpoint `/health`
      xác nhận server sống, có test JUnit xác nhận.
- [ ] **Giai đoạn 2 (tiếp theo) — tài khoản**: đăng ký/đăng nhập bằng
      username-password, đăng nhập khách (guest), quên mật khẩu. Liên kết
      tài khoản: guest nâng cấp lên tài khoản thường, tài khoản thường liên
      kết mạng xã hội (Google/Apple) — khung xác thực Google/Apple dựng sẵn
      với placeholder client ID/secret (chưa có credentials thật), điền sau
      khi có.
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
