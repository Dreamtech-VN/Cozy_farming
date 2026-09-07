# Phạm vi một game farming/social — đối chiếu với bản đang có

Tài liệu này trả lời câu hỏi "một con game thể loại này gồm những màn nào, tính
năng lớn nhỏ nào", rồi đối chiếu thẳng với repo để thấy chỗ nào đã có, chỗ nào
mới là khung, chỗ nào chưa động tới.

Cách đọc cột **Trạng thái**: ✅ chạy được và có test · 🟡 có nhưng còn sơ · ⬜ chưa có.

---

## 1. Các màn (scene) của một game hoàn chỉnh

Một game live-service thể loại này có nhiều màn hơn người ta tưởng. Nhóm theo
vòng đời một phiên chơi:

### Trước khi vào thế giới

| Màn | Vai trò | Trạng thái |
| --- | --- | --- |
| Splash / tải tài nguyên | Che thời gian tải, hiện logo, kiểm tra phiên bản | ⬜ |
| Đăng nhập / đăng ký | Vào tài khoản | ✅ `client/src/scenes/login.js` |
| Chọn server | Nhiều cụm server | 🟡 có API và UI, mới một server |
| Tạo nhân vật | Chọn ngoại hình, đặt tên | ✅ cùng file login |
| Màn hình chính (lobby) | Điểm xuất phát, tin tức, nút vào game | ⬜ vào thẳng thế giới |
| Onboarding / hướng dẫn | Dạy điều khiển và vòng lặp cốt lõi | ⬜ |

### Trong thế giới

| Màn | Vai trò | Trạng thái |
| --- | --- | --- |
| Map công cộng | Nơi gặp người khác | ✅ 5 map, chia khu 1–20 |
| Nông trại riêng | Không gian sở hữu, gieo/thu hoạch | ✅ `map_player_farm` |
| Nhà riêng / nội thất | Trang trí, khoe với bạn | ⬜ |
| Nhà bạn bè | Sang thăm, tương tác | ⬜ |
| Màn Match-3 | Vòng lặp phụ, tiêu energy | ✅ engine server-side, 5 màn |
| Câu cá / đào mỏ / nấu ăn | Vòng lặp phụ khác | ⬜ |
| Dungeon / boss theo mùa | Nội dung đỉnh của một mùa | ⬜ |
| Sự kiện thế giới | Map tạm thời theo dịp | 🟡 có khung liveops, chưa có map |

### Giao diện chồng lên thế giới

| Màn | Trạng thái |
| --- | --- |
| Túi đồ, Nhiệm vụ, Nông trại, Bản đồ, Cửa hàng, Bạn bè, Nhân vật, Thư, Cài đặt | ✅ |
| Bộ sưu tập / thành tựu | ⬜ |
| Xếp hạng | ⬜ |
| Nhật ký / sổ tay cây trồng | ⬜ |
| Hòm đồ chung (kho) | ⬜ |
| Chợ giữa người chơi | ⬜ |

---

## 2. Tính năng lớn

Tính năng lớn là thứ định hình cả game — thiếu một cái là thể loại đổi hẳn.

| Tính năng | Nội dung | Trạng thái |
| --- | --- | --- |
| Vòng lặp nông trại | Gieo → chờ → thu → bán → mở rộng | ✅ có timestamp server-side |
| Kinh tế | Nhiều loại tiền, nguồn thu và nguồn tiêu cân nhau | ✅ giao dịch nguyên tử, idempotent |
| Tiến trình nhân vật | Cấp, XP, mở khoá theo cấp | ✅ |
| Nhiệm vụ | Cốt truyện, phụ, hằng ngày, hằng tuần | ✅ 9 nhiệm vụ mẫu |
| Xã hội | Bạn bè, chat, chặn, báo cáo | ✅ |
| Vòng lặp phụ (Match-3) | Tiêu energy, đổi thưởng | ✅ |
| Tuỳ biến ngoại hình | Trang phục thay đổi hình nhân vật | ✅ |
| Hòm thư | Kênh gửi quà và thông báo | ✅ |
| Live-ops | Mùa, sự kiện, cờ tính năng | 🟡 có cấu hình, chưa có nội dung mùa |
| Kiếm tiền | Gói nạp, vật phẩm trả phí | ⬜ |
| Nhà riêng và nội thất | Không gian sở hữu thứ hai | ⬜ |
| Thú nuôi / vật nuôi | Nguồn thu thụ động, gắn bó cảm xúc | ⬜ |
| Chợ giữa người chơi | Kinh tế do người chơi định giá | ⬜ |
| Hội / bang | Nhóm dài hạn, mục tiêu chung | ⬜ |

---

## 3. Tính năng nhỏ — thứ làm nên cảm giác "game thật"

Đây là nhóm dễ bị bỏ qua nhất, và cũng là nhóm khiến bản hiện tại còn giống một
bản demo kỹ thuật hơn là một game.

| Nhóm | Chi tiết | Trạng thái |
| --- | --- | --- |
| Phản hồi | Hiệu ứng khi thu hoạch, số bay lên khi nhận tiền, rung nhẹ khi lên cấp | ⬜ |
| Âm thanh | Nhạc nền theo map, tiếng bước chân, tiếng thu hoạch, tiếng UI | 🟡 có bus và âm lượng, chưa có file |
| Hoạt ảnh nhân vật | Đi, nhảy, làm việc, ngồi | 🟡 có đi/nhảy, chưa có làm việc |
| Ngày đêm và thời tiết | Đổi tông màu, mưa, hiệu ứng | ✅ suy ra xác định từ map + lát thời gian |
| NPC có lịch sinh hoạt | Di chuyển theo giờ, đổi lời thoại | ⬜ đứng yên |
| Điểm nhấn trong map | Mốc để định hướng, chỗ ngồi, chỗ chụp ảnh | 🟡 mới có prop rải đều |
| Đăng nhập hằng ngày | Thưởng chuỗi ngày | ✅ chu kỳ 7 ngày, có test |
| Nhiệm vụ tân thủ 7 ngày | Dẫn người chơi qua tuần đầu | ⬜ |
| Chỉ dẫn nhiệm vụ | Mũi tên hoặc đường dẫn tới mục tiêu | ⬜ |
| Bảng thành tựu | Mốc dài hạn | ⬜ |

---

## 4. Nhịp một phiên chơi (theo skill level-design)

Skill `level-design` nói: nhịp phải là **răng cưa** — căng rồi nghỉ, không phẳng
lì. Áp vào game farming, "căng" không phải chiến đấu mà là **việc phải quyết
định**; "nghỉ" là lúc chờ cây lớn và đi lang thang.

```
Vào game      → nhận thưởng, đọc thư            nghỉ    0.1
Nông trại     → thu hoạch, quyết định gieo gì   căng    0.5
Làng          → bán hàng, nhận nhiệm vụ         vừa     0.3
Match-3       → chơi vài màn tiêu energy        căng    0.7
Xã hội        → chat, thăm bạn                  nghỉ    0.2
Sự kiện ngày  → mục tiêu ngắn có hạn            căng    0.8
Thoát         → hẹn giờ cây chín lần sau        nghỉ    0.1
```

Từ 0.9.0 bậc đầu tiên đã có thật: **điểm danh hằng ngày** tự mở khi vào game.
Còn thiếu bậc **"sự kiện ngày"** — mục tiêu ngắn có hạn trong ngày.

---

## 5. Cổng mở khoá (gating)

Cũng theo `level-design`: mọi cổng phải **mở được bằng thứ lấy được trước cổng**,
không thì người chơi kẹt cứng.

| Cổng | Điều kiện | Lấy ở đâu | Hợp lệ? |
| --- | --- | --- | --- |
| Rừng (`map_forest`) | Cấp 3 | XP từ nông trại và nhiệm vụ đầu | ✅ |
| Màn Match-3 số 5 | Cấp 9 | XP tích luỹ | ✅ |
| Mở rộng nông trại | Xu | Bán nông sản | ✅ |
| Trang phục trong shop | Xu / ngọc | Điểm danh 35/tuần + quest tuần 10/tuần | ✅ |

**Đính chính bản trước.** Tôi từng ghi "ngọc chưa có nguồn lặp lại" — sai: quest
tuần vẫn cho 10 ngọc mỗi tuần. Nhưng con số đó quá nhỏ nên kết luận thì đúng.
Cân lại bằng bảng nguồn/bồn:

| | Trước 0.9.0 | Sau |
| --- | --- | --- |
| Nguồn ngọc lặp lại | 10/tuần (quest tuần) | 45/tuần (+35 từ điểm danh) |
| Bồn ngọc | tới 525/tuần (bữa ăn hồi energy 15 ngọc × 5 lượt/ngày) | như cũ |
| Kết luận | lệch ~50 lần → người chơi đói tài nguyên | 3 bữa/tuần, bữa ăn thành tiện ích chứ không phải tường chắn |

---

## 6. Đề nghị thứ tự làm tiếp

Xếp theo *đổi cảm giác chơi trên mỗi giờ công*, không theo độ khó:

1. **Phản hồi khi hành động** — số bay lên, hiệu ứng thu hoạch, tiếng động.
   Rẻ nhất mà đổi cảm giác nhiều nhất.
2. ~~Thưởng đăng nhập hằng ngày~~ — **xong ở 0.9.0**. Còn lại: nhiệm vụ tân thủ
   7 ngày.
3. ~~Nguồn ngọc lặp lại~~ — **xong ở 0.9.0**, xem bảng cân ở mục 5.
4. **Sprite nhân vật vẽ theo cùng bộ pixel** — hiện nhân vật vẫn là hình vector,
   lệch hẳn với thế giới đã chuyển sang pixel.
5. **NPC có lịch sinh hoạt** — làng có nhịp sống thay vì mấy hình đứng yên.
6. **Nhà riêng và nội thất** — không gian sở hữu thứ hai, kéo dài vòng đời.
