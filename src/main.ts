import Phaser from 'phaser';
import { PreloadScene } from './scenes/PreloadScene';
import { CharCreateScene } from './scenes/CharCreateScene';
import { WorldScene } from './scenes/WorldScene';
import { initUI } from './ui/UIManager';
import { startBgm } from './core/audio';

// Game màn hình ngang 960x540, scale FIT toàn màn hình
const game = new Phaser.Game({
  type: Phaser.AUTO,
  parent: 'game-root',
  backgroundColor: '#1a2b12',
  pixelArt: true,
  roundPixels: true,
  scale: {
    mode: Phaser.Scale.FIT,
    autoCenter: Phaser.Scale.CENTER_BOTH,
    width: 960,
    height: 540
  },
  physics: { default: 'arcade' },
  scene: [PreloadScene, CharCreateScene, WorldScene]
});

initUI(game);

// Khóa màn hình ngang trên mobile (H5); bản Capacitor đã khóa trong config
try {
  const so = screen.orientation as ScreenOrientation & { lock?: (o: string) => Promise<void> };
  so.lock?.('landscape').catch(() => { /* trình duyệt không cho phép thì thôi */ });
} catch { /* ignore */ }

// Nhạc nền bật sau tương tác đầu tiên (chính sách autoplay)
window.addEventListener('pointerdown', () => startBgm(), { once: true });

// Vào chế độ toàn màn hình khi chơi trên mobile H5
document.addEventListener('dblclick', () => {
  if (!document.fullscreenElement) document.documentElement.requestFullscreen?.().catch(() => {});
});

export default game;
