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

export default game;
