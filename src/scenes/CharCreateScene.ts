import Phaser from 'phaser';
import { S, save } from '@/core/save';
import { bus, EV } from '@/core/events';
import { CharacterSprite } from '@/gfx/CharacterSprite';

// Scene xem trước nhân vật khi tạo — điều khiển bằng panel DOM 'charcreate'
export class CharCreateScene extends Phaser.Scene {
  private preview?: CharacterSprite;
  private dirTimer = 0;

  constructor() { super('CharCreate'); }

  create() {
    const W = this.scale.width, H = this.scale.height;
    this.add.rectangle(0, 0, W, H, 0x2d4a1e).setOrigin(0);
    // sàn gỗ sân khấu
    this.add.tileSprite(W * 0.3, H / 2 + 60, 260, 120, 'g_wood').setAlpha(0.9);
    this.preview = new CharacterSprite(this, W * 0.3, H / 2 + 10, S.player.appearance);
    this.preview.setScale(4);
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
    this.preview?.setAppearance(S.player.appearance);
    this.preview?.play('walk');
  }

  private finish() {
    save(true);
    this.scene.start('World');
  }

  update(_t: number, dt: number) {
    if (!this.preview) return;
    this.preview.tick(dt);
    this.dirTimer += dt;
    if (this.dirTimer > 1600) {
      this.dirTimer = 0;
      this.preview.setDir(((this.preview.dir + (Math.random() < 0.5 ? 1 : 3)) % 4) as 0 | 1 | 2 | 3);
    }
  }
}
