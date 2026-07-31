import Phaser from 'phaser';
import { RES } from '@/core/res';

// Màn hình đầu tiên: logo studio, đồng thời tải trước ảnh nền màn hình chính
export class BootScene extends Phaser.Scene {
  private ready = false;
  private minTimeDone = false;

  constructor() { super('Boot'); }

  preload() {
    this.load.image('title_bg', 'assets/ui/title_bg.jpg');   // key art Sunny Town (đã có logo + nhân vật)
    this.load.image('age12', 'assets/ui/age12.png');   // nhãn 12+ gốc Avatar, cần sẵn ở màn title
    this.load.on('complete', () => { this.ready = true; this.tryNext(); });
  }

  create() {
    const W = this.scale.width, H = this.scale.height;
    this.add.rectangle(0, 0, W, H, 0x070b06).setOrigin(0);

    // logo studio vẽ thủ công: mầm cây trong vòng tròn + chữ
    const cx = W / 2, cy = H / 2 - 30 * RES;
    const g = this.add.graphics();
    g.fillStyle(0x1d3316); g.fillCircle(cx, cy, 46 * RES);
    g.lineStyle(3 * RES, 0x8ce99a); g.strokeCircle(cx, cy, 46 * RES);
    // thân mầm
    g.lineStyle(4 * RES, 0x8ce99a);
    g.beginPath(); g.moveTo(cx, cy + 24 * RES); g.lineTo(cx, cy - 6 * RES); g.strokePath();
    // 2 lá
    g.fillStyle(0x69db7c);
    g.fillEllipse(cx - 12 * RES, cy - 12 * RES, 22 * RES, 12 * RES);
    g.fillEllipse(cx + 12 * RES, cy - 16 * RES, 22 * RES, 12 * RES);

    this.add.text(cx, cy + 78 * RES, 'TINZ GAMES', {
      fontFamily: 'Verdana, sans-serif', fontSize: `${26 * RES}px`, color: '#e9fac8', fontStyle: 'bold'
    }).setOrigin(0.5);
    this.add.text(cx, cy + 104 * RES, 'S T U D I O', {
      fontFamily: 'Verdana, sans-serif', fontSize: `${11 * RES}px`, color: '#8a9b7a'
    }).setOrigin(0.5);

    // fade vào rồi giữ tối thiểu 1.8s
    this.cameras.main.fadeIn(500, 7, 11, 6);
    this.time.delayedCall(1800, () => { this.minTimeDone = true; this.tryNext(); });
  }

  private tryNext() {
    if (!this.ready || !this.minTimeDone) return;
    this.cameras.main.fadeOut(350, 7, 11, 6);
    this.cameras.main.once('camerafadeoutcomplete', () => this.scene.start('Preload'));
  }
}
