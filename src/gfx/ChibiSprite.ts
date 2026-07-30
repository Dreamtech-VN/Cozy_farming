import Phaser from 'phaser';
import { lookLayers, type ChibiLook } from '@/data/chibi';

// ===== Nhân vật chibi kiểu Avatar =====
// Strip 15 frame 64x96/part, neo chân (32,88). Hướng: mặc định nhìn phải,
// đi trái lật gương (Avatar chỉ có 2 hướng), lên/xuống dùng chung.

export type ChibiAnim = 'idle' | 'walk' | 'work' | 'sit' | 'lie';

interface AnimDef { frames: number[]; fps: number; loop: boolean }
const ANIMS: Record<ChibiAnim, AnimDef> = {
  idle: { frames: [0, 0, 0, 0, 0, 0, 0, 1], fps: 2.2, loop: true }, // thỉnh thoảng chớp mắt
  walk: { frames: [0, 2], fps: 6, loop: true },
  work: { frames: [3, 0, 3, 0, 3], fps: 5, loop: false },           // cúi làm việc
  sit:  { frames: [4], fps: 1, loop: true },
  lie:  { frames: [5], fps: 1, loop: true }
};

export class ChibiSprite extends Phaser.GameObjects.Container {
  private layers: Phaser.GameObjects.Sprite[] = [];
  private shadowObj: Phaser.GameObjects.Ellipse;
  private emote?: Phaser.GameObjects.Sprite;
  private anim: ChibiAnim = 'idle';
  private fi = 0;
  private acc = 0;
  private onDone?: () => void;
  facingLeft = false;

  constructor(scene: Phaser.Scene, x: number, y: number, look: ChibiLook) {
    super(scene, x, y);
    this.shadowObj = scene.add.ellipse(0, -2, 34, 10, 0x000000, 0.25);
    this.add(this.shadowObj);
    this.setLook(look);
    scene.add.existing(this);
  }

  setLook(look: ChibiLook) {
    for (const l of this.layers) l.destroy();
    this.layers = [];
    for (const id of lookLayers(look)) {
      const key = `chibi_${id}`;
      if (!this.scene.textures.exists(key)) continue;
      // neo chân: frame cao 96, chân ở y=88 -> origin (0.5, 88/96)
      const s = this.scene.add.sprite(0, 0, key, 0).setOrigin(0.5, 88 / 96);
      this.add(s);
      this.layers.push(s);
    }
    this.applyFrame();
  }

  // nhận cả tên animation cũ của CharacterSprite (hoe/water/pickup/axe/fishing)
  play(anim: string, onDone?: () => void) {
    const alias: Record<string, ChibiAnim> = {
      hoe: 'work', water: 'work', pickup: 'work', axe: 'work', fishing: 'sit',
      idle: 'idle', walk: 'walk', work: 'work', sit: 'sit', lie: 'lie'
    };
    const a = alias[anim] ?? 'idle';
    // các pose không loop phải gọi callback dù bị lặp lại
    if (this.anim === a && ANIMS[a].loop) { onDone?.(); return; }
    this.anim = a; this.fi = 0; this.acc = 0; this.onDone = onDone;
    this.applyFrame();
  }

  get current(): ChibiAnim { return this.anim; }

  // giữ API tương thích CharacterSprite: 0 xuống 1 lên 2 trái 3 phải
  setDir(d: 0 | 1 | 2 | 3) {
    if (d === 2) this.facingLeft = true;
    if (d === 3) this.facingLeft = false;
    for (const l of this.layers) l.setFlipX(this.facingLeft);
  }
  get dir(): 0 | 1 | 2 | 3 { return this.facingLeft ? 2 : 3; }

  showEmote(index: number) {
    this.emote?.destroy();
    this.emote = this.scene.add.sprite(0, -104, 'emoticons', index).setScale(2);
    this.add(this.emote);
    this.scene.tweens.add({ targets: this.emote, y: -110, duration: 200, yoyo: true, repeat: 3 });
    this.scene.time.delayedCall(2000, () => { this.emote?.destroy(); this.emote = undefined; });
  }

  tick(deltaMs: number) {
    const def = ANIMS[this.anim];
    if (def.frames.length <= 1 && def.loop) return;
    this.acc += deltaMs;
    const ft = 1000 / def.fps;
    while (this.acc >= ft) {
      this.acc -= ft;
      this.fi++;
      if (this.fi >= def.frames.length) {
        if (def.loop) this.fi = 0;
        else {
          const cb = this.onDone; this.onDone = undefined;
          this.anim = 'idle'; this.fi = 0;
          cb?.();
          break;
        }
      }
      this.applyFrame();
    }
  }

  private applyFrame() {
    const f = ANIMS[this.anim].frames[Math.min(this.fi, ANIMS[this.anim].frames.length - 1)];
    for (const l of this.layers) {
      if (f < l.texture.frameTotal - 1) l.setFrame(f);
      l.setFlipX(this.facingLeft);
    }
  }
}
