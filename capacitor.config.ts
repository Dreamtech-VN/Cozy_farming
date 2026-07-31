import type { CapacitorConfig } from '@capacitor/cli';

// Đóng gói Android/iOS: cài @capacitor/core @capacitor/cli @capacitor/android @capacitor/ios
// rồi chạy: npm run cap:add:android / npm run cap:add:ios
const config: CapacitorConfig = {
  appId: 'com.cozyfarming.game',
  appName: 'Sunny Town',
  webDir: 'dist',
  backgroundColor: '#1a2b12',
  android: { allowMixedContent: false },
  ios: { contentInset: 'never' },
  server: { androidScheme: 'https' },
  plugins: {
    ScreenOrientation: { orientation: 'landscape' },
    StatusBar: { overlaysWebView: true }
  }
};

export default config;
