import Phaser from 'phaser';
import { S, save } from '@/core/save';
import { bus, EV } from '@/core/events';
import { ChibiSprite } from '@/gfx/ChibiSprite';
import { defaultLook, lookLayers } from '@/data/chibi';

// Scene xem trước nhân vật chibi khi tạo — điều khiển bằng panel DOM 'charcreate'
export class CharCreateScene extends Phaser.Scene {
  private preview?: ChibiSprite;
  private dirTimer = 0;

  constructor() { super('CharCreate'); }

  create() {
    const W = this.scale.width, H = this.scale.height;
    this.add.rectangle(0, 0, W, H, 0x2d4a1e).setOrigin(0);
    this.add.tileSprite(W * 0.3, H / 2 + 90, 320, 90, 'g_wood').setAlpha(0.9);
    if (!S.player.chibi) S.player.chibi = defaultLook(0);
    this.preview = new ChibiSprite(this, W * 0.3, H / 2 + 90, S.player.chibi);
    this.preview.setScale(2.4);
    this.preview.play('walk');

    bus.on(EV.APPEARANCE, this.refresh, this);
    bus.on('charcreate:done', this.finish, this);
    this.events.on('shutdown', () => {
      bus.off(EV.APPEARANCE, this.refresh, this);
      bus.off('charcreate:done', this.finish, this);
    });

    bus.emit(EV.OPEN_PANEL, { panel: 'charcreate' });
  }

  private refresh() {
    if (S.player.chibi) this.preview?.setLook(S.player.chibi);
    this.preview?.play('walk');
  }

  private finish() {
    // sở hữu sẵn các part đang mặc
    if (S.player.chibi) {
      for (const id of lookLayers(S.player.chibi)) {
        if (!S.chibiWardrobe.includes(id)) S.chibiWardrobe.push(id);
      }
    }
    save(true);
    this.scene.start('World');
  }

  update(_t: number, dt: number) {
    if (!this.preview) return;
    this.preview.tick(dt);
    this.dirTimer += dt;
    if (this.dirTimer > 1600) {
      this.dirTimer = 0;
      this.preview.setDir(this.preview.facingLeft ? 3 : 2);
    }
  }
}
