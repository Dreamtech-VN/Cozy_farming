# Lộ trình MyZoo — đối chiếu với spec v1.6

Cập nhật cuối mỗi đợt. Mục đích: nhìn một chỗ là biết còn thiếu gì so với spec, và cái gì
**không phải việc code** nhưng vẫn chặn ngày ra mắt.

## Trạng thái theo chương spec

| Chương spec | Nội dung | Trạng thái |
|---|---|---|
| §5 Player | Đăng nhập khách/tài khoản, chọn server, tạo nhân vật, level Farm/Zoo | Xong |
| §6 Farm | 48 ô, 8 loại cây, trạng thái cây, kho nông sản | Xong |
| §6.4 Livestock | 5 loài, đói/sản phẩm tính lười, nối vào chế biến | Xong ở Đợt 7 |
| §7 Zoo | Chuồng, 6 loài thú, cho ăn theo cửa sổ đói, mở cửa, doanh thu | Xong |
| §7.4 Visitor simulation | Khách tham quan, sức chứa, xếp hạng sở thú | **Chưa — Đợt 8** |
| §8 Mini-game | Match-3 + Lật hình, server sinh seed và chấm điểm | Xong |
| §9 Economy | 2 loại tiền tách bạch, sổ cái, idempotency | Xong |
| §10 Social | Bạn bè, thăm vườn, giúp bạn, bảng xếp hạng | Xong |
| §11 Missions | Ngày + tuần + sự kiện, định nghĩa nằm trong DB | Xong ở Đợt 7 |
| §12 Database | Bảng lõi + ràng buộc | Xong |
| §13 REST API | ~80 endpoint | Xong |
| §14 Realtime | `WSS /v1/realtime` | **Chưa — Đợt 9** (client đang poll) |
| §15 Unity client | Toàn bộ màn hình dựng bằng `SceneBuilder` | Xong |
| §16 Art | Asset gốc | **Chưa — không phải việc code** |
| §17 Security | Rate limit, chống cheat, server giữ quyền quyết định | Xong ở Đợt 5 |
| §19 QA | Ma trận kiểm thử | **Chưa** |
| §21 LiveOps | Công cụ GM | Một phần — có endpoint admin, chưa có giao diện, **Đợt 10** |
| §26.15 Settings | Màn cài đặt, cập nhật bắt buộc, thông báo bảo trì | Xong ở Đợt 5 |
| §27.8 Gacha | Banner, tỉ lệ công khai, pity, trùng → mảnh, lịch sử quay | Xong ở Đợt 6 |
| §27.13 Wallet | Số dư + lịch sử thu chi | Xong ở Đợt 5 |
| §27.14 IAP | Nạp tiền thật, xác thực hoá đơn | **Chưa — Đợt 10** (đang là `TOPUP_MOCK`) |
| §27.21 Analytics | Sự kiện đo lường | **Chưa — Đợt 10** |
| §29 Farm→Zoo loop | Chế biến, kho, cho ăn, doanh thu | Xong |
| §29.23 Chợ khẩn cấp | Mua thức ăn giá cao khi kho cạn | **Chưa — Đợt 8** |
| §30 Long-term | Thời tiết/mùa, guild, giao dịch, câu cá, thú cưng, danh hiệu... | Spec ghi rõ **post-MVP** — chưa đụng |

Tiêu chí MVP ở §22.1 đã đạt, trừ dòng "thế giới 2D đi lại được" — hiện game là giao diện màn hình.

## Các đợt

| Đợt | Nội dung | PR | Trạng thái |
|---|---|---|---|
| 1 | Bạn bè, thăm vườn, giúp bạn, bảng xếp hạng | #73 | Xong |
| 2 | Hộp thư, giftcode, thành tựu, bộ sưu tập | #74 | Xong |
| 3 | Cửa hàng, Kim Cương, kho đồ | #75 | Xong |
| 4 | Chế biến, trang trí, minigame thứ hai | #76 | Xong |
| — | Chat thế giới/riêng/hệ thống + kiểm duyệt | #77 | Xong |
| 5 | Ví + lịch sử giao dịch, màn Cài đặt, rate limit toàn API | #78 | Xong |
| 6 | Gacha + hệ ngoại hình (pool chỉ có đồ cosmetic) | #79 | Xong |
| 7 | Nhiệm vụ tuần/sự kiện dữ liệu hoá + chăn nuôi | — | Đang làm |
| 8 | Xếp hạng sở thú, sức chứa khách, chợ thức ăn khẩn cấp | — | Chưa |
| 9 | Realtime (hoặc long-poll) + thông báo cục bộ | — | Chưa |
| 10 | IAP thật, trang GM, analytics | — | Chưa |

## Không phải việc code nhưng vẫn chặn ngày ra mắt

- **Asset gốc**: spec §16.1 cấm dùng asset bên thứ ba. Hiện toàn hình vuông màu — chỗ ráp sprite đã
  chừa sẵn, xem bảng trong `unity-client/README.md`.
- **Âm thanh, nhạc nền**: chưa có file nào. Màn Cài đặt đã có sẵn thanh chỉnh âm lượng.
- **Cân bằng số liệu**: giá cây, thời gian lớn, doanh thu sở thú đang là số đặt tạm.
- **Kiểm thử trên máy thật** theo ma trận QA §19.
- **Hạ tầng production**: HTTPS + MySQL. Đã có hướng dẫn ở `docs/SETUP_GUIDE.md`, chưa dựng thật.
- **Pháp lý**: chính sách riêng tư, giới hạn độ tuổi, và **công bố tỉ lệ gacha** — bắt buộc theo quy
  định của Apple/Google và luật ở nhiều nước. Bảng tỉ lệ đã làm trong Đợt 6, xem được ngay trong
  màn quay số; phần chính sách riêng tư và giới hạn độ tuổi thì vẫn còn thiếu.

## Rủi ro đã biết

- **Maven chạy offline**: thư viện mới chỉ dùng được nếu đã có trong cache. Ảnh hưởng trực tiếp tới
  lựa chọn WebSocket ở Đợt 9 — phải kiểm tra trước khi cam kết làm theo spec §14.
- **IAP cần tài khoản nhà phát triển thật** mới test được đầu-cuối. Đây là lý do Đợt 10 để cuối.
- **Voice chat không tự lọc nội dung được**. Sticker/GIF an toàn theo cấu trúc vì server chỉ phát nội
  dung trong danh mục duyệt sẵn, nhưng ghi âm thì chỉ có report + admin nghe lại. Mở voice trên máy
  chủ công khai thì cần người trực.
- **Rate limit đếm trong bộ nhớ**: chạy nhiều tiến trình thì mỗi tiến trình đếm riêng. Đủ cho quy mô
  hiện tại; khi scale ngang phải chuyển sang bộ đếm dùng chung.
