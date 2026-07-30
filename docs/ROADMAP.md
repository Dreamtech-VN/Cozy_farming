# Roadmap

## v0.1 (bản này) — Client offline hoàn chỉnh vòng lặp cốt lõi
Nông trại, chăn nuôi, câu cá, côn trùng, nhà ở, thời trang, minigame, nhiệm vụ, sưu tập, quà ngày, 9 khu vực. Save localStorage.

## v0.2 — Trau chuốt hình ảnh
- Map toạ độ tileset thật (tiles/town/interior/beach) thay nền procedural
- Nội thất dùng sprite `Interior.full/global.png`
- Mua pack côn trùng + nhạc nền + icon (xem ASSETS.md)
- Hiệu ứng chuyển cảnh, particle thu hoạch

## v0.3 — Online (cần server)
- Server Node.js (TypeScript, WebSocket) theo `SERVER_PROTOCOL.md`
- Tài khoản, sync save, chống hack (server authoritative về tiền/vật phẩm)
- Chat thật, bạn bè thật, ghé thăm nhà/nông trại nhau, tiệc multiplayer
- Bảng xếp hạng server, thư hệ thống, giao dịch/trao đổi vật phẩm an toàn
- Nạp thật (IAP Google/Apple + cổng thanh toán web)

## v0.4+ — Tính năng lớn (đã có chỗ trong thiết kế data)
- Guild/Bang hội + chat bang
- Marketplace / Auction House (chợ người chơi)
- Kết hôn/hẹn hò, nghề nghiệp (đầu bếp, bác sĩ...), crafting (đã có máy móc trong asset: butterchurn, mayomaker, cheese press...)
- Thú cưng AI (asset mèo/chó có sẵn trong Interior pack), xe cộ, căn hộ chung cư
- Nhà hàng/quán cà phê người chơi vận hành, Season Pass, nhà thông minh, voice chat
- Event minigame theo phiên bản (đua vịt, săn kho báu...)
