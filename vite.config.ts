import { defineConfig } from 'vite';
import { fileURLToPath, URL } from 'node:url';

export default defineConfig({
  // Web (GitHub Pages) chạy ở /Cozy_farming/, còn bản đóng gói app (Electron
  // mở bằng file://, Capacitor mở ở gốc localhost) phải dùng đường dẫn tương
  // đối — nên `npm run build:app` truyền --base=./ đè lên dòng này.
  base: '/Cozy_farming/',

  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },

  server: {
    host: true,
    port: 5173
  },

  build: {
    target: 'es2020',
    chunkSizeWarningLimit: 2000,
    assetsInlineLimit: 0
  }
});
