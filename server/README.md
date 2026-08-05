# Cozy Farming — server Java

Viết lại từ đầu (không copy nguyên code), tham khảo kiến trúc server gốc của
Lttt (`avatar/*` trong Pack5 release — network/session, service theo module
Farm/Home/Park, model User/Npc/Map...) để mô phỏng lại đúng luồng nghiệp vụ,
nhưng dùng stack hiện đại hơn (Java 21, HTTP server chuẩn thay socket thô,
Gson thay json-simple, mysql-connector-j thay bản cũ).

## Quy trình: từng giai đoạn, xong mới sang giai đoạn kế

- [x] **Giai đoạn 1 — khung project**: Maven project biên dịch + chạy được,
      1 endpoint `/health` xác nhận server sống, có test JUnit xác nhận.
- [x] **Giai đoạn 2 — DB + DAO đầu tiên**: `DataSourceProvider` (HikariCP,
      đọc `DB_URL`/`DB_USER`/`DB_PASSWORD` từ biến môi trường, không hardcode
      tài khoản) + `ItemDao` khớp đúng schema thật bảng `items` trong
      `database/avatar_2x.sql` (Pack5) — bảng CHUNG cho tóc/áo/quần/kính/đồ
      cầm tay, lọc theo `zorder`+`gender`. Test bằng H2 nhúng (chế độ tương
      thích MySQL) vì môi trường build chưa có MySQL thật chạy sẵn — khi
      triển khai thật chỉ cần trỏ `DB_URL` sang MySQL thật, code DAO không
      đổi.
- [x] **Giai đoạn 3 — đăng ký/đăng nhập/quên mật khẩu**:
      `POST /api/register`, `POST /api/login`, `POST /api/forgot/request`,
      `POST /api/forgot/reset` — khớp đúng luồng 3 màn đã làm ở client
      (`src/ui/login.ts`). Mật khẩu băm THẬT bằng PBKDF2-HMAC-SHA256 có salt
      (`PasswordHasher`, khác hẳn hash tay djb2 phía client — đó chỉ để chặn
      gõ sai khi CHƯA có server). Quên mật khẩu dùng bảng phụ MỚI
      `password_resets` (không sửa bảng `users` thật) — mã 6 số, hạn 15
      phút, dùng 1 lần.
      ⚠️ **Chưa gửi email/SMS thật** — response `forgot/request` trả thẳng
      `devOnlyCode` để còn test được luồng; PHẢI thay bằng gửi email/SMS thật
      (dùng cột `gmail`/`phone` sẵn có) trước khi triển khai thật, xem TODO
      trong `ForgotPasswordRequestHandler`.
      Test: `AuthFlowTest` gọi HTTP thật (không mock) qua toàn bộ luồng đăng
      ký → sai mật khẩu bị chặn → quên mật khẩu → đặt lại → đăng nhập bằng
      mật khẩu mới, cộng 2 test biên (trùng tên, sai mã khôi phục).
- [ ] Các giai đoạn sau: nông trại (trồng/thu hoạch/vật nuôi/ao cá), tủ đồ,
      chat, đơn hàng... — mỗi module server khớp đúng 1 hệ thống client đã có.

## Chạy thử

```
cd server
mvn compile
mvn test
mvn -Dserver.port=8080 exec:java   # (thêm exec-plugin ở giai đoạn sau nếu cần)
# hoặc: mvn package && java -jar target/cozy-farming-server-0.1.0-SNAPSHOT.jar
```
