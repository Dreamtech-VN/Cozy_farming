// Client PC (desktop): cài devDependency `electron` rồi chạy `npm run electron`.
//
// KHÔNG mở thẳng bằng file:// được: bản build là ES module + CSS nên Chromium
// coi origin là `null` rồi chặn hết vì CORS (mở ra thấy màn hình đen). Cách
// chuẩn là tự đăng ký giao thức riêng `app://` trỏ vào thư mục dist — lúc đó
// trang có origin đàng hoàng nên module, CSS và fetch (màn chờ tải tài nguyên)
// chạy bình thường.
const { app, BrowserWindow, protocol, net } = require('electron');
const path = require('path');
const { pathToFileURL } = require('url');

const DIST = path.join(__dirname, '..', 'dist');

protocol.registerSchemesAsPrivileged([{
  scheme: 'app',
  privileges: { standard: true, secure: true, supportFetchAPI: true, stream: true }
}]);

function createWindow() {
  const win = new BrowserWindow({
    width: 1280,
    height: 760,
    minWidth: 960,
    minHeight: 600,
    autoHideMenuBar: true,
    backgroundColor: '#1a2b12',
    webPreferences: { contextIsolation: true }
  });
  win.loadURL('app://local/index.html');
}

app.whenReady().then(() => {
  protocol.handle('app', req => {
    // app://local/<đường dẫn> -> dist/<đường dẫn>, chặn không cho trèo ra ngoài dist
    const rel = decodeURIComponent(new URL(req.url).pathname);
    const file = path.normalize(path.join(DIST, rel));
    if (!file.startsWith(DIST)) return new Response('', { status: 403 });
    return net.fetch(pathToFileURL(file).toString());
  });
  createWindow();
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});
