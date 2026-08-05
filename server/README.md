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
- [x] **Giai đoạn 4 — tủ đồ trang bị**: `GET /api/items?zorder=&gender=` —
      dùng lại `ItemDao` sẵn có, chuyển việc lọc tóc/áo/quần/kính/đồ cầm tay
      từ client sang server (`registerList()` trong `chibi.ts` phía client
      sẽ gọi API này thay vì tự lọc, ở đợt nối client sau).
- [x] **Giai đoạn 5 — nông trại (cuốc/trồng/tưới/thu hoạch)**:
      `GET /api/farm/plots`, `POST /api/farm/{till,plant,water,harvest}` —
      `FarmService` chép ĐÚNG công thức `growth()`/`healthOf()` trong
      `farming.ts` (chưa tưới chỉ lớn tối đa 30%, khô mỗi giờ mất 8 điểm sức
      khỏe), server tự tính chín/sản lượng theo mốc thời gian lưu DB — không
      tin số liệu client gửi lên (chặn sửa giờ máy/code JS để thu hoạch sớm).
      `CropCatalog` chép số liệu cân bằng từ `crops.ts` (18 cây, TODO sinh tự
      động thay vì chép tay ở giai đoạn sau). Bảng MỚI `farm_plots` (không có
      trong schema thật gốc — server Lttt gốc lưu đất theo file save nhị
      phân riêng, không phải bảng SQL).
      ⚠️ CHƯA nối kho/inventory (hệ kho chưa lên server) — trồng chưa trừ hạt
      giống thật, thu hoạch trả số lượng trong response để client tự cộng
      kho tạm, và CHƯA áp dụng thưởng công cụ (bình tưới/cuốc/giỏ cấp cao) vì
      hệ công cụ cũng chưa lên server — cả hai để giai đoạn sau khi tủ
      đồ/kho được đưa lên server đầy đủ.
      Test: `FarmFlowTest` chạy trọn luồng cuốc → trồng → tưới → (thu hoạch
      quá sớm bị chặn) → xem danh sách ô đất qua HTTP thật.
- [x] **Giai đoạn 6 — vật nuôi**: `GET /api/livestock?userId=`,
      `POST /api/livestock/{buy,feed,collect,sell}` — `AnimalService` chép
      đúng công thức trong `livestock.ts` (giai đoạn lớn theo Lttt thật,
      sức khoẻ/bệnh là ước lượng — xem chú thích trong `livestock.ts`). Bảng
      MỚI `animals` (server gốc lưu trong file save nhị phân, không phải
      bảng SQL). Vật nuôi mới mua đã ĐÓI NGAY (`fedAt=0`, khớp đúng
      `buyAnimal()` client — phải cho ăn liền, không phải "no sẵn").
      ⚠️ CHƯA nối ví/kho/chuồng thật (trừ xu lúc mua, trừ item `feed` lúc
      cho ăn, cộng sản phẩm vào kho lúc thu, kiểm tra sức chứa chuồng) — 3
      hệ đó chưa lên server, TODO trong code.
      Test: `LivestockFlowTest` chạy trọn luồng mua → cho ăn lần đầu (thành
      công) → cho ăn lại ngay (bị chặn, 409) → xem danh sách (chưa lớn nên
      chưa có sản phẩm dù không đói) → thu hoạch sớm (bị chặn) → bán (hoàn
      đúng 50% giá).
- [x] **Giai đoạn 7 — ví xu/kim cương**: `GET /api/wallet?userId=` —
      `WalletDao` quản bảng MỚI `wallets` (`user_id, coins, gems`), tách biệt
      hẳn với cột `vnd`/`tongnap` thật trong bảng `users` (đó là tiền nạp
      thật/IAP, còn `coins`/`gems` ở đây là xu/kim cương trong game — hai hệ
      khác nhau, không gộp). User mới truy vấn lần đầu tự được cấp
      `STARTING_COINS = 500` (khớp số dư khởi điểm hợp lý cho nhân vật mới).
      Nối thật vào vật nuôi: `BuyAnimalHandler` giờ trừ xu thật qua
      `walletDao.spendCoins()` trước khi tạo vật nuôi (402 nếu không đủ xu),
      `SellAnimalHandler` cộng thẳng 50% giá hoàn vào ví qua
      `walletDao.addCoins()`. Tách `QueryParam.intParam()` dùng chung (trước
      đó `FarmPlotsHandler`/`AnimalsHandler` mỗi cái có bản riêng trùng lặp).
      ⚠️ CHƯA nối ví vào nông trại (mua hạt giống/công cụ chưa trừ xu) — TODO
      giai đoạn kho/inventory.
      Test: `WalletDaoTest`, `WalletHandlerTest` (đơn vị), và
      `LivestockFlowTest` cập nhật để xác nhận đúng số xu bị trừ lúc mua
      (500 → 200 với gà giá 300) và được cộng lúc bán (200 → 350 với hoàn
      150), cùng loại vật nuôi không hợp lệ không bị trừ xu.
- [ ] Các giai đoạn sau: ao cá, kho/inventory, chat, đơn hàng... — mỗi module
      server khớp đúng 1 hệ thống client đã có.

## Chạy thử

```
cd server
mvn compile
mvn test
mvn -Dserver.port=8080 exec:java   # (thêm exec-plugin ở giai đoạn sau nếu cần)
# hoặc: mvn package && java -jar target/cozy-farming-server-0.1.0-SNAPSHOT.jar
```
