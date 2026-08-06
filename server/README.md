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
- [x] **Giai đoạn 8 — kho nông trại + túi đồ**: `GET /api/inventory/farmstore?userId=&kind=`
      (`kind` bỏ trống -> trả cả 4 ngăn), `GET /api/inventory/bag?userId=` —
      `FarmStoreDao` quản bảng MỚI `farm_store` khớp ĐÚNG `FarmStore` client
      (`src/systems/farmstore.ts`): 4 ngăn riêng `seeds`/`produce`/`fert`/`fish`,
      mỗi ngăn là map id -> số lượng, xóa hẳn dòng khi về 0 (khớp `addTo()`
      client). `BagDao` quản bảng MỚI `bag_items` khớp `S.inventory` client
      (đồ dùng/quà/nguyên liệu KHÔNG thuộc kho nông trại, ví dụ `feed`,
      `animal_med`). Nối thật vào nông trại + vật nuôi:
      - `PlantHandler` trừ 1 hạt giống thật (`farm_store` ngăn `seeds`) trước
        khi gieo, 409 nếu không đủ.
      - `HarvestHandler` cộng thẳng nông sản vào ngăn `produce`.
      - `FeedAnimalHandler` trừ 1 item `feed` trong túi đồ trước khi cho ăn,
        409 nếu hết.
      - `CollectAnimalHandler` cộng sản phẩm (trứng/sữa/thịt/len) vào CHUNG
        ngăn `produce` (khớp `addTo('produce', ...)` trong `livestock.ts` —
        client gộp sản phẩm vật nuôi với nông sản, không tách riêng).
      ⚠️ Chưa nối kho vào mua hạt giống/thức ăn ở tiệm (hệ shop/mua bằng ví
      chưa lên server ngoài vật nuôi) — TODO giai đoạn sau.
      Test: `FarmStoreDaoTest`, `BagDaoTest`, `FarmStoreHandlerTest`,
      `BagHandlerTest` (đơn vị); `FarmFlowTest`/`LivestockFlowTest` cập nhật
      xác nhận đúng số hạt giống bị trừ lúc trồng và số thức ăn bị trừ lúc
      cho ăn.
- [x] **Giai đoạn 9 — ao cá**: `GET /api/fishpond?userId=`,
      `POST /api/fishpond/{stock,feed,net}` — `FishPondService` chép ĐÚNG
      công thức trong `src/systems/fishfarm.ts`: cá đói giống hệt ngưỡng vật
      nuôi trên cạn (chưa từng cho ăn hoặc quá 4 giờ), và "lớn" (`isGrown`)
      chỉ đúng khi VỪA đủ tuổi VỪA không đói — đủ tuổi mà đói vẫn không vớt
      được (test riêng `oldEnoughButHungryIsNotGrown` xác nhận đúng nhánh
      này). `FryCatalog` 3 loại cá giống (`ca_ro`/`ca_chep`/`ca_tram`) chép
      nguyên từ `FRIES` client — Pack5 không có bảng cá thật (`FishFarm` kế
      thừa `AnimalDan` trong Lttt gốc, dùng chung pipeline với vật nuôi, không
      có dữ liệu loài cá riêng), nên giữ nguyên catalog client tự đặt, chỉ
      port công thức. Bảng MỚI `pond_fish`. Nối thật:
      - `StockFryHandler` kiểm tra sức chứa ao (`POND_CAP` = 6) rồi trừ xu
        thật qua `WalletDao`.
      - `FeedFishHandler` dùng CHUNG item `feed` trong túi đồ với vật nuôi
        trên cạn (không bịa thức ăn cá riêng, khớp comment gốc trong
        `fishfarm.ts`).
      - `NetFishHandler` cộng cá thu được vào CHUNG ngăn `produce` của kho
        nông trại với id `fish_<loại>` (khớp `addTo('produce', 'fish_'+id, qty)`).
      Kho nông trại (`farm_store`) và túi đồ (`bag_items`) tiếp tục tách biệt
      hoàn toàn như giai đoạn 8 — không gộp 2 hệ này lại.
      Test: `PondFishDaoTest`, `FishPondServiceTest` (đơn vị, có ca đủ tuổi
      nhưng đói để xác nhận không vớt được), `FishPondFlowTest` (luồng HTTP
      thật: thả cá trừ xu đúng, cho ăn trừ đúng 1 feed, ao đầy bị chặn).
- [x] **Giai đoạn 10 — tiệm (mua/bán bằng ví)**: `POST /api/shop/{buy,sell}`
      {userId, itemId, qty} — `ShopService` định giá + định tuyến kho, chép
      ĐÚNG `storeSlotOf()` (`src/core/save.ts`) và `produceSell()`
      (`src/ui/panels.ts`), thứ tự nhánh giữ y hệt client. Giá hạt giống lấy
      thẳng từ `CropCatalog` (không chép 2 lần), giá vật phẩm chung
      (phân bón/thức ăn/thuốc thú y/quà/vé quay/công cụ/mồi câu/đồ ăn) từ
      `ShopCatalog` — chép nguyên từ `items.ts`. `FoodCatalog` (chỉ giá bán,
      9 món) chép từ `foods.ts` để bán đúng giá vật phẩm kho dạng
      `food_<tên món>` — hệ nấu ăn đầy đủ (nguyên liệu/thời gian nấu) CHƯA
      lên server, TODO giai đoạn "nhà bếp" sau, bảng này giữ sẵn tránh 2
      nguồn số liệu lệch nhau.
      ⚠️ Quirk THẬT chép nguyên từ client: `food_cake`/`food_juice` mua ở
      tiệm có giá trong `items.ts` nhưng KHÔNG bán lại được từ kho (id bắt
      đầu `food_` luôn tra qua `FoodCatalog`, không có "cake"/"juice" trong
      đó -> sellPrice 0) — test `boughtFoodCakeIsNotSellableFromKho` xác
      nhận đúng quirk này, KHÔNG "sửa" lại cho hợp lý.
      2 nhánh định tuyến KHÔNG có bên client (`resolveSlot` cho id cây trồng
      trần như `carrot` và id sản phẩm ao `fish_ca_ro`) — client không cần vì
      UI kho đã biết sẵn đang ở tab nào, còn API 1-itemId ở đây phải tự suy,
      xem comment trong `ShopService`.
      Test: `ShopServiceTest` (đơn vị, định giá + định tuyến), `ShopFlowTest`
      (luồng HTTP thật: mua hạt giống trừ đúng xu + vào đúng ngăn kho, bán
      nông sản cộng đúng xu, mua vật phẩm không cho phép mua bị chặn, bán
      thiếu số lượng bị chặn).
- [x] **Giai đoạn 11 — nhà bếp (nấu ăn)**: `GET /api/cooking?userId=`,
      `POST /api/cooking/{start,collect,cancel}` — chép ĐÚNG
      `src/systems/cooking.ts`: mỗi user chỉ nấu 1 món/lượt (`cooking_state`
      bảng MỚI, 1 dòng/user), bận bếp thì chặn món khác (409). `FoodCatalog`
      chuyển từ package `shop` (chỉ có giá bán, đặt tạm ở giai đoạn 10) sang
      package `cooking` riêng, giờ có ĐẦY ĐỦ công thức (nguyên liệu, thời
      gian nấu, exp) chép từ `FOODS` trong `src/data/foods.ts` — `ShopService`
      cập nhật theo import mới, không đổi hành vi bán.
      - `StartCookHandler` trừ nguyên liệu thật từ ngăn "produce" của kho
        nông trại TRƯỚC khi nấu, thiếu nguyên liệu (kiểm tra đủ hết TRƯỚC khi
        trừ bất kỳ nguyên liệu nào, tránh trừ dở dang) hoặc bếp đang bận đều
        409.
      - `CollectCookHandler` chặn lấy món khi chưa chín (409), chín rồi cộng
        vào ngăn "produce" với id `food_<tên món>` (khớp
        `addTo('produce', 'food_'+id, 1)` — đây chính là loại id mà
        `ShopService`/`FoodCatalog` giai đoạn 10 đã định giá bán sẵn).
      - `CancelCookHandler` hủy nấu (chín hay chưa đều được), trả lại đúng
        số nguyên liệu đã trừ vào kho.
      Test: `CookingServiceTest` (đơn vị, công thức còn giờ/đã chín),
      `CookingStateDaoTest` (đơn vị, mỗi user 1 dòng, ghi đè khi nấu món
      mới), `CookingFlowTest` (luồng HTTP thật: thiếu nguyên liệu bị chặn,
      trừ đúng nguyên liệu lúc bắt đầu, bận bếp chặn món 2, chưa chín chặn
      lấy, hủy trả đúng nguyên liệu).
- [ ] Các giai đoạn sau: chat, đơn hàng... — mỗi module server khớp đúng 1
      hệ thống client đã có.

## Chạy thử

```
cd server
mvn compile
mvn test
mvn -Dserver.port=8080 exec:java   # (thêm exec-plugin ở giai đoạn sau nếu cần)
# hoặc: mvn package && java -jar target/cozy-farming-server-0.1.0-SNAPSHOT.jar
```
