import Phaser from 'phaser';
import { BootScene } from './scenes/BootScene';
import { PreloadScene } from './scenes/PreloadScene';
import { CharCreateScene } from './scenes/CharCreateScene';
import { WorldScene } from './scenes/WorldScene';
import { initUI } from './ui/UIManager';
import { startBgm, preloadSfx } from './core/audio';
import { RES } from './core/res';

// Game màn hình ngang, EXPAND để phủ hết màn hình (không viền đen trên mobile)
const game = new Phaser.Game({
  type: Phaser.AUTO,
  parent: 'game-root',
  backgroundColor: '#1a2b12',
  pixelArt: true,
  roundPixels: true,
  scale: {
    mode: Phaser.Scale.EXPAND,
    autoCenter: Phaser.Scale.CENTER_BOTH,
    width: 960 * RES,
    height: 540 * RES
  },
  physics: { default: 'arcade' },
  // 2 ngón: joystick ảo (DOM) giữ trong khi tay kia chạm world/hotbar vẫn ăn
  input: { activePointers: 2 },
  scene: [BootScene, PreloadScene, CharCreateScene, WorldScene]
});

initUI(game);

// Khóa màn hình ngang trên mobile (H5); bản Capacitor đã khóa trong config
try {
  const so = screen.orientation as ScreenOrientation & { lock?: (o: string) => Promise<void> };
  so.lock?.('landscape').catch(() => { /* trình duyệt không cho phép thì thôi */ });
} catch { /* ignore */ }

// Nhạc nền + hiệu ứng bật sau tương tác đầu tiên (chính sách autoplay)
window.addEventListener('pointerdown', () => { void preloadSfx(); startBgm(); }, { once: true });

// Vào chế độ toàn màn hình khi chơi trên mobile H5
document.addEventListener('dblclick', () => {
  if (!document.fullscreenElement) document.documentElement.requestFullscreen?.().catch(() => {});
});

// ---- Chặn zoom + ép canvas fit đúng khi xoay màn hình ----
// touch-action:none (ui.css) chặn được đa số, nhưng Safari còn bắn riêng
// gesturestart/gesturechange khi 2 ngón chụm/xoè -> chặn thêm ở đây, không
// thì trang bị phóng to/thu nhỏ và canvas EXPAND lệch cỡ theo layout viewport.
document.addEventListener('gesturestart', (e) => e.preventDefault());
document.addEventListener('gesturechange', (e) => e.preventDefault());
// chụm 2 ngón trên một số Android vẫn lọt qua touch-action -> chặn luôn ở
// mức touchmove khi có từ 2 điểm chạm trở lên.
document.addEventListener('touchmove', (e) => { if (e.touches.length > 1) e.preventDefault(); }, { passive: false });

// Sau khi xoay màn hình, innerWidth/innerHeight của trình duyệt có độ trễ
// (đọc ra kích thước CŨ trong vài trăm ms đầu) nên EXPAND tính sai cỡ canvas
// một nhịp rồi mới đúng -> chủ động refresh vài lần sau khi xoay/resize để
// canvas luôn khớp kích thước thật, không bị kẹt cỡ cũ.
function refreshScale() {
  for (const t of [0, 120, 320, 600]) setTimeout(() => game.scale.refresh(), t);
}
window.addEventListener('orientationchange', refreshScale);
window.visualViewport?.addEventListener('resize', refreshScale);

export default game;
