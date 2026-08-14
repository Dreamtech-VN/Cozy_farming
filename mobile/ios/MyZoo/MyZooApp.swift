import SwiftUI

@main
struct MyZooApp: App {
    var body: some Scene {
        WindowGroup {
            GameWebView(url: AppConfig.serverURL)
                .ignoresSafeArea()
                .statusBarHidden(true)
                .persistentSystemOverlays(.hidden)
        }
    }
}

enum AppConfig {
    // Đổi thành địa chỉ server thật khi phát hành. localhost dùng cho iOS Simulator.
    static let serverURL = URL(string: "http://localhost:8080")!
}
