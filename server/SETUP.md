# Hướng dẫn cài đặt & chạy server (cho người mới hoàn toàn)

Hướng dẫn này giả sử bạn CHƯA từng cài Java/Maven/MySQL bao giờ. Làm theo
đúng thứ tự từ trên xuống.

## 1. Cài những thứ cần thiết

### Java 21
Server viết bằng Java 21, bắt buộc phải có bản 21 trở lên (bản cũ hơn sẽ
báo lỗi biên dịch).

- Tải tại: https://adoptium.net/ (chọn bản **Temurin 21**, đúng hệ điều
  hành của bạn — Windows/Mac/Linux).
- Cài xong, mở terminal (Windows: Command Prompt hoặc PowerShell; Mac:
  Terminal) gõ:
  ```
  java -version
  ```
  Phải thấy dòng có số `21` (ví dụ `openjdk version "21.0.x"`). Nếu báo
  "not found"/"không tìm thấy lệnh", cài lại và nhớ tick chọn "Add to
  PATH" lúc cài.

### Maven
Dùng để build project.

- Windows: tải tại https://maven.apache.org/download.cgi (chọn file
  `.zip`), giải nén ra 1 thư mục (ví dụ `C:\maven`), rồi thêm
  `C:\maven\bin` vào biến môi trường `PATH` (tìm "Edit environment
  variables" trong Start Menu).
- Mac (dùng Homebrew): `brew install maven`
- Linux (Ubuntu/Debian): `sudo apt install maven`

Kiểm tra:
```
mvn -version
```

### MySQL
Server cần MySQL để lưu dữ liệu (tài khoản, nhân vật, guild...).

- Tải MySQL Community Server: https://dev.mysql.com/downloads/mysql/
- Lúc cài, nó sẽ hỏi đặt mật khẩu cho user `root` — nhớ đặt cái gì đó dễ
  nhớ (hoặc để trống nếu bản cài cho phép, chỉ nên làm vậy lúc dev ở máy
  cá nhân, KHÔNG làm vậy khi đưa lên server thật).
- Cài xong, mở MySQL command line (hoặc dùng công cụ như MySQL Workbench,
  DBeaver, HeidiSQL — cái nào quen thì dùng) và tạo database:
  ```sql
  CREATE DATABASE game CHARACTER SET utf8mb4;
  ```

### Tạo bảng (schema)
Project này chưa có sẵn 1 file schema.sql duy nhất — mỗi bảng được ghi
chú DDL (câu lệnh `CREATE TABLE`) ngay trong Javadoc của file DAO tương
ứng (thư mục `src/main/java/vn/dreamtech/game/server/dao/`). Cách nhanh
nhất để lấy đủ toàn bộ DDL:

1. Mở từng file `*Dao.java` trong thư mục `dao/`, copy đoạn `CREATE
   TABLE ... ;` trong comment ở đầu file.
2. Dán tất cả vào 1 file `.sql`, chạy lần lượt trên database `game` vừa
   tạo (theo đúng thứ tự bảng không phụ thuộc bảng khác trước — thường
   thứ tự tên file cũng gần đúng thứ tự này).

> Đây là việc chỉ cần làm 1 lần lúc setup máy dev/server thật. Trong lúc
> chạy `mvn test`, các bảng test tự tạo bằng H2 (DB giả lập trong bộ nhớ,
> không cần MySQL) — vậy nên `mvn test` chạy được ngay cả khi chưa có
> MySQL. Chỉ khi CHẠY THẬT server (`start.sh`/`start.bat`/`mvn exec:java`)
> mới cần MySQL đã có sẵn bảng.

## 2. Tải code về

```
git clone https://github.com/Dreamtech-VN/Cozy_farming.git
cd Cozy_farming/server
```

## 3. Build & chạy thử test (không cần MySQL)

```
mvn test
```

Nếu thấy dòng cuối `BUILD SUCCESS` và không có `FAILURE` — vậy là môi
trường Java/Maven đã ổn.

## 4. Cấu hình kết nối MySQL

Server đọc thông tin kết nối DB từ **biến môi trường** (không hardcode
trong code, để tránh lộ mật khẩu khi đưa code lên GitHub):

| Biến môi trường | Mặc định nếu không đặt | Ý nghĩa |
|---|---|---|
| `DB_URL` | `jdbc:mysql://localhost:3306/game` | Địa chỉ + tên database |
| `DB_USER` | `root` | Tài khoản MySQL |
| `DB_PASSWORD` | (rỗng) | Mật khẩu MySQL |
| `DB_POOL_SIZE` | `10` | Số kết nối tối đa (không cần đổi lúc dev) |
| `SERVER_PORT` | `8080` | Cổng HTTP server lắng nghe |

Nếu MySQL cài local với user `root` không mật khẩu ở cổng mặc định
3306, KHÔNG CẦN đặt gì thêm — cứ chạy thẳng theo bước 5. Nếu khác (mật
khẩu riêng, DB ở máy khác...), đặt biến môi trường trước khi chạy, ví dụ
trên Mac/Linux:
```
export DB_PASSWORD="mat_khau_cua_ban"
```
Windows (PowerShell):
```
$env:DB_PASSWORD="mat_khau_cua_ban"
```

## 5. Chạy server

Cách dễ nhất — dùng script có sẵn (tự build file `.jar` nếu chưa có,
tự chạy):

- **Windows**: bấm đúp file `start.bat` trong thư mục `server/` (hoặc mở
  Command Prompt, `cd` vào `server/`, gõ `start.bat`).
- **Mac/Linux**: mở Terminal, `cd` vào `server/`, gõ `./start.sh`.

Thấy dòng log cuối kiểu:
```
Game server đang chạy ở cổng 8080
```
là server đã chạy thành công. Mở trình duyệt vào
`http://localhost:8080/health` — thấy phản hồi (không phải lỗi kết nối)
là server đang sống bình thường.

Cách khác (không dùng script, chạy tay):
```
mvn package
java -jar target/game-server-0.1.0-SNAPSHOT.jar
```

## 6. Test thử 1 API bằng tay (không cần Unity)

Dùng `curl` (có sẵn trên Mac/Linux, Windows 10+ cũng có sẵn) hoặc công cụ
như Postman/Insomnia. Ví dụ đăng nhập khách (guest):
```
curl -X POST http://localhost:8080/api/auth/guest -H "Content-Type: application/json" -d "{}"
```
Sẽ nhận về JSON có `guestToken` — lưu lại token này, lần sau gửi lên
đúng token đó (`{"guestToken":"xxx"}`) để vào lại đúng tài khoản đó thay
vì tạo tài khoản khách mới.

## 7. Các lỗi thường gặp

| Lỗi | Nguyên nhân | Cách sửa |
|---|---|---|
| `Communications link failure` / `Connection refused` lúc chạy server | MySQL chưa chạy, hoặc sai `DB_URL`/cổng | Kiểm tra MySQL đã start chưa (Windows: Services, tìm "MySQL"; Mac/Linux: `mysql.server status` hoặc `systemctl status mysql`) |
| `Access denied for user 'root'@'localhost'` | Sai `DB_USER`/`DB_PASSWORD` | Đặt lại biến môi trường đúng mật khẩu đã đặt lúc cài MySQL |
| `Unknown database 'game'` | Chưa tạo database | Chạy lại `CREATE DATABASE game CHARACTER SET utf8mb4;` |
| `Table 'game.users' doesn't exist` (hoặc bảng khác) | Chưa chạy DDL tạo bảng | Xem lại mục "Tạo bảng (schema)" ở trên |
| `mvn: command not found` | Maven chưa cài đúng/chưa vào PATH | Cài lại Maven, kiểm tra `mvn -version` |
| Cổng 8080 đã bị chiếm | Có chương trình khác đang dùng cổng 8080 | Đặt `SERVER_PORT` sang cổng khác, ví dụ `8081` |

## 8. Đọc tiếp

- `README.md` (cùng thư mục) — nhật ký từng giai đoạn đã làm, danh sách
  ĐẦY ĐỦ mọi endpoint API kèm giải thích thiết kế.
- `UNITY_INTEGRATION.md` — hướng dẫn nối client Unity vào server này.
