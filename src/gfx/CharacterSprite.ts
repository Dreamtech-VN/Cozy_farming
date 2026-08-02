import Phaser from 'phaser';
import type { Appearance } from '@/core/types';

// ===== Nhân vật nhiều lớp (asset Character v2 — lưới 32px) =====
// Sheet gộp: mỗi biến thể màu là 1 block 256px (8 cột); các hàng animation:
// walk 0-3 | jump 4-7 | pickup 8-11 | carry 12-15 | sword 16-19 | block 20-23
// hurt 24-27 | die 28 | pickaxe 29-32 | axe 33-36 | water 37-40 | hoe 41-44 | fishing 45-48
// Mỗi animation có 4 hàng theo hướng: 0 xuống, 1 lên, 2 trái, 3 phải.

export type Dir = 0 | 1 | 2 | 3;
export type AnimName = 'idle' | 'walk' | 'water' | 'hoe' | 'fishing' | 'pickup' | 'axe';

interface AnimDef { row: number; frames: number; fps: number; loop: boolean }
const ANIMS: Record<AnimName, AnimDef> = {
  idle:    { row: 0,  frames: 1, fps: 1,  loop: true },
  walk:    { row: 0,  frames: 8, fps: 10, loop: true },
  pickup:  { row: 8,  frames: 5, fps: 7,  loop: false },
  water:   { row: 37, frames: 2, fps: 3,  loop: false },
  hoe:     { row: 41, frames: 5, fps: 7,  loop: false },
  axe:     { row: 33, frames: 5, fps: 7,  loop: false },
  fishing: { row: 45, frames: 5, fps: 6,  loop: false }
};

interface Layer { sprite: Phaser.GameObjects.Sprite; cols: number; variant: number }

export class CharacterSprite extends Phaser.GameObjects.Container {
  private layers: Layer[] = [];
  private shadow: Phaser.GameObjects.Image;
  private emote?: Phaser.GameObjects.Sprite;
  dir: Dir = 0;
  private anim: AnimName = 'idle';
  private frame = 0;
  private acc = 0;
  private onDone?: () => void;

  constructor(scene: Phaser.Scene, x: number, y: number, appearance: Appearance) {
    super(scene, x, y);
    this.shadow = scene.add.image(0, 6, 'char_shadow').setAlpha(0.4);
    this.add(this.shadow);
    this.setAppearance(appearance);
    scene.add.existing(this);
  }

  setAppearance(a: Appearance) {
    for (const l of this.layers) l.sprite.destroy();
    this.layers = [];
    const add = (key: string, variant: number) => {
      if (!this.scene.textures.exists(key)) return;
      const tex = this.scene.textures.get(key).getSourceImage() as HTMLImageElement;
      const cols = Math.floor(tex.width / 32);
      const variants = Math.max(1, Math.floor(cols / 8));
      const sprite = this.scene.add.sprite(0, -8, key, 0);
      this.add(sprite);
      this.layers.push({ sprite, cols, variant: Math.min(variant, variants - 1) * 8 });
    };
    // thứ tự lớp theo info.txt: base -> eyes/blush -> clothes -> hair -> acc
    add(`char_base_${a.charIndex}`, 0);
    add('eyes_eyes', a.eyesColor);
    add(`clothes_${a.clothes}`, a.clothesColor);
    add(`hair_${a.hairStyle}`, a.hairColor);
    for (const acc of a.acc) add(`acc_${acc}`, a.hairColor);
    this.applyFrame();
  }

  play(anim: AnimName, onDone?: () => void) {
    if (this.anim === anim && ANIMS[anim].loop) return;
    this.anim = anim;
    this.frame = 0;
    this.acc = 0;
    this.onDone = onDone;
    this.applyFrame();
  }

  get current(): AnimName { return this.anim; }

  setDir(d: Dir) {
    if (this.dir !== d) { this.dir = d; this.applyFrame(); }
  }

  /** Biểu cảm động (xem ChibiSprite.showEmote — cùng cách dùng). */
  showEmote(key: string, frames: number, dur: number, size = 22) {
    this.emote?.destroy();
    const s = this.scene.add.sprite(0, -30, key, 0);
    s.setDisplaySize(size * (s.width / s.height), size);
    this.emote = s;
    this.add(s);
    if (frames > 1) {
      const anim = `${key}_play`;
      if (!this.scene.anims.exists(anim)) {
        this.scene.anims.create({
          key: anim, repeat: -1, frameRate: Math.max(1, frames / dur),
          frames: this.scene.anims.generateFrameNumbers(key, { start: 0, end: frames - 1 })
        });
      }
      s.play(anim);
    }
    this.scene.tweens.add({ targets: s, y: -34, duration: 200, yoyo: true, repeat: 3 });
    this.scene.time.delayedCall(2600, () => { this.emote?.destroy(); this.emote = undefined; });
  }

  tick(deltaMs: number) {
    const def = ANIMS[this.anim];
    if (def.frames <= 1) return;
    this.acc += deltaMs;
    const frameTime = 1000 / def.fps;
    while (this.acc >= frameTime) {
      this.acc -= frameTime;
      this.frame++;
      if (this.frame >= def.frames) {
        if (def.loop) this.frame = 0;
        else {
          this.frame = def.frames - 1;
          const cb = this.onDone;
          this.onDone = undefined;
          this.anim = 'idle';
          this.frame = 0;
          cb?.();
          break;
        }
      }
      this.applyFrame();
    }
  }

  private applyFrame() {
    const def = ANIMS[this.anim];
    const row = def.row + this.dir;
    for (const l of this.layers) {
      const idx = row * l.cols + l.variant + Math.min(this.frame, def.frames - 1);
      if (idx < (l.sprite.texture.frameTotal - 1)) l.sprite.setFrame(idx);
    }
  }
}
