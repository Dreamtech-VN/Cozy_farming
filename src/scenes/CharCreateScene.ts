import Phaser from 'phaser';
import { showLoading } from '@/ui/loading';
import { setHudVisible } from '@/ui/UIManager';
import { S, save } from '@/core/save';
import { bus, EV } from '@/core/events';
import { ChibiSprite } from '@/gfx/ChibiSprite';
import { defaultLook, lookLayers } from '@/data/chibi';
import { RES } from '@/core/res';

// Scene xem trước nhân vật chibi khi tạo — điều khiển bằng panel DOM 'charcreate'
export class CharCreateScene extends Phaser.Scene {
  private preview?: ChibiSprite;
  private dirTimer = 0;
  private userTurned = false;

  constructor() { super('CharCreate'); }

  create() {
    const W = this.scale.width, H = this.scale.height;
    // nền phẳng một màu (không dùng ảnh) cho nổi khung tạo nhân vật
    this.add.rectangle(0, 0, W, H, 0x3b6d8c).setOrigin(0);
    // Bảng chọn (DOM .cc-panel) bó gọn bố cục trong 900px rồi tự căn giữa trên
    // màn rộng/vuông (tablet) — nhân vật xem trước phải neo theo ĐÚNG khung
    // 900px đó (không phải theo W thật) để hai bên không bị dạt xa nhau.
    const CAP = 900;
    const marginL = Math.max(0, (W - CAP) / 2);
    const effW = Math.min(W, CAP);
    const glow = this.add.circle(marginL + effW * 0.3, H * 0.52, Math.max(effW, H) * 0.42, 0x5a9ab5, 0.45);
    this.tweens.add({ targets: glow, scale: 1.06, duration: 5200, yoyo: true, repeat: -1, ease: 'sine.inout' });

    // bục đứng cho nhân vật xem trước
    const px = marginL + effW * 0.3, py = H / 2 + 96 * RES;
    const g = this.add.graphics();
    g.fillStyle(0x000000, 0.35); g.fillEllipse(px, py + 8 * RES, 190 * RES, 46 * RES);
    g.fillStyle(0xffd43b, 0.25); g.fillEllipse(px, py + 6 * RES, 160 * RES, 36 * RES);
    this.add.text(px, py + 40 * RES, 'Nhân vật của bạn', {
      fontFamily: 'sans-serif', fontSize: `${15 * RES}px`, color: '#e0f0ff', fontStyle: 'bold'
    }).setOrigin(0.5).setShadow(0, 2, '#1a3a55', 4);
    setHudVisible(false);
    this.cameras.main.fadeIn(300, 10, 18, 32);
    if (!S.player.chibi) S.player.chibi = defaultLook(1);
    this.preview = new ChibiSprite(this, px, py - 6 * RES, S.player.chibi);
    this.preview.setScale(2.4 * RES);
    this.preview.play('walk');

    bus.on(EV.APPEARANCE, this.refresh, this);
    bus.on('charcreate:done', this.finish, this);
    bus.on('charcreate:turn', this.turn, this);
    this.events.on('shutdown', () => {
      bus.off(EV.APPEARANCE, this.refresh, this);
      bus.off('charcreate:done', this.finish, this);
      bus.off('charcreate:turn', this.turn, this);
    });

    bus.emit(EV.OPEN_PANEL, { panel: 'charcreate' });
  }

  private refresh() {
    if (S.player.chibi) this.preview?.setLook(S.player.chibi);
    this.preview?.play('walk');
  }

  // nút xoay trên panel DOM -> lật nhân vật xem trước
  private turn(left: boolean) {
    this.userTurned = true;            // người chơi tự xoay -> thôi tự đảo hướng
    this.preview?.setDir(left ? 2 : 3);
  }

  private finish() {
    // sở hữu sẵn các part đang mặc
    if (S.player.chibi) {
      for (const id of lookLayers(S.player.chibi)) {
        if (!S.chibiWardrobe.includes(id)) S.chibiWardrobe.push(id);
      }
    }
    save(true);
    showLoading();
    this.scene.start('World');
  }

  update(_t: number, dt: number) {
    if (!this.preview) return;
    this.preview.tick(dt);
    if (this.userTurned) return;
    this.dirTimer += dt;
    if (this.dirTimer > 1600) {
      this.dirTimer = 0;
      this.preview.setDir(this.preview.facingLeft ? 3 : 2);
    }
  }
}
