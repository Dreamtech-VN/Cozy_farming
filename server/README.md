# Cozy Farming — server Java

Viết lại từ đầu (không copy nguyên code), tham khảo kiến trúc server gốc của
Lttt (`avatar/*` trong Pack5 release — network/session, service theo module
Farm/Home/Park, model User/Npc/Map...) để mô phỏng lại đúng luồng nghiệp vụ,
nhưng dùng stack hiện đại hơn (Java 21, HTTP server chuẩn thay socket thô,
Gson thay json-simple, mysql-connector-j thay bản cũ).

## Quy trình: từng giai đoạn, xong mới sang giai đoạn kế

- [x] **Giai đoạn 1 — khung project**: Maven project biên dịch + chạy được,
      1 endpoint `/health` xác nhận server sống, có test JUnit xác nhận.
- [ ] **Giai đoạn 2**: kết nối DB thật (HikariCP + MySQL, dùng lại schema từ
      `database/avatar_2x.sql` trong Pack5 — bảng `items`, `farmitems`...) +
      lớp DAO đầu tiên.
- [ ] **Giai đoạn 3**: API đăng ký/đăng nhập/quên mật khẩu — khớp đúng luồng
      3 màn đã làm ở client (`src/ui/login.ts`), thay `localStorage` bằng gọi
      API thật.
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
