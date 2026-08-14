# MyZoo Mobile — Android & iOS

Hai app native mỏng bọc client HTML5 của game trong WebView, khoá **màn hình ngang**, ẩn thanh hệ thống, giữ guest token qua localStorage. Toàn bộ gameplay vẫn do server quyết định nên client mobile không cần cập nhật khi đổi số liệu game.

Trước tiên chạy server (xem README gốc), rồi trỏ app vào địa chỉ server.

## Android (`mobile/android`)

Yêu cầu: Android Studio (hoặc Android SDK + Gradle 8.7+).

1. Mở thư mục `mobile/android` bằng Android Studio (nó tự tạo Gradle wrapper nếu thiếu).
2. Sửa `SERVER_URL` trong `app/build.gradle.kts`:
   - Emulator: giữ `http://10.0.2.2:8080` (chính là localhost máy dev).
   - Máy thật cùng Wi-Fi: `http://<IP-máy-dev>:8080`.
   - Production: `https://...` và bỏ `android:usesCleartextTraffic="true"` trong Manifest.
3. Run ▶ trên emulator/máy thật (minSdk 24, target 34).

Từ dòng lệnh: `gradle :app:assembleDebug` → APK tại `app/build/outputs/apk/debug/`.

## iOS (`mobile/ios`)

Yêu cầu: macOS + Xcode 15+.

Cách 1 — XcodeGen (khuyên dùng):
```bash
brew install xcodegen
cd mobile/ios && xcodegen generate && open MyZoo.xcodeproj
```

Cách 2 — thủ công: tạo project **iOS App (SwiftUI)** mới tên `MyZoo`, xoá file mẫu, kéo 3 file trong `MyZoo/` vào target, chọn `Info.plist` này làm Info.plist của target.

Sửa `AppConfig.serverURL` trong `MyZooApp.swift`:
- Simulator: giữ `http://localhost:8080`.
- Máy thật cùng Wi-Fi: `http://<IP-máy-dev>:8080`.
- Production: `https://...` và bỏ `NSAllowsArbitraryLoads` trong `Info.plist`.

## Ghi chú

- Cả 2 app chưa build được trong môi trường CI hiện tại (không có Android SDK/Xcode) — cần build trên máy dev.
- Muốn đóng gói offline-first sau này: copy thư mục `client/` vào assets của app và chỉ gọi API qua mạng; hiện tại tải cả trang từ server cho đơn giản và luôn đồng bộ phiên bản.
