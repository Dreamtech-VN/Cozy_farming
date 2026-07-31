import Phaser from 'phaser';
import { lookLayers, FACE, type ChibiLook, type FaceKey } from '@/data/chibi';

// ===== Nhân vật chibi kiểu Avatar =====
// Strip 15 frame 64x96/part, neo chân (32,88). Hướng: mặc định nhìn phải,
// đi trái lật gương (Avatar chỉ có 2 hướng), lên/xuống dùng chung.

export type ChibiAnim = 'idle' | 'walk' | 'work' | 'till' | 'water' | 'pick'
  | 'sit' | 'lie' | 'reach' | 'pat' | 'strike' | 'cheer';

interface AnimDef { frames: number[]; fps: number; loop: boolean }
const ANIMS: Record<ChibiAnim, AnimDef> = {
  idle: { frames: [0, 0, 0, 0, 0, 0, 0, 1], fps: 2.2, loop: true }, // thỉnh thoảng chớp mắt
  walk: { frames: [0, 2], fps: 6, loop: true },
  work: { frames: [3, 0, 3, 0, 3], fps: 5, loop: false },           // cúi làm việc
  // Sprite Avatar KHÔNG có animation nông trại riêng (15 frame chỉ là tư thế
  // đứng/ngồi/nằm + các kiểu đưa tay), nên 3 việc đồng áng được dựng lại từ
  // các frame sẵn có cho khác nhau ra, thay vì dùng chung một kiểu cúi.
  till:  { frames: [11, 3, 11, 3, 0], fps: 4.5, loop: false },      // giơ cuốc rồi bổ xuống
  water: { frames: [7, 7, 6, 7, 0], fps: 3.5, loop: false },        // chìa bình ra tưới
  pick:  { frames: [3, 3, 6, 0], fps: 4, loop: false },             // cúi nhặt rồi đứng lên
  sit:  { frames: [4], fps: 1, loop: true },
  lie:  { frames: [5], fps: 1, loop: true },
  // tư thế tương tác — sprite Avatar chỉ có các kiểu đưa/cầm tay,
  // nên hành động chủ yếu diễn bằng chuyển động (xem WorldScene.playPlayerAct)
  reach:   { frames: [7, 7, 7, 0], fps: 2.6, loop: false },   // vươn tay tới (hôn / ôm)
  pat:     { frames: [6, 6, 6, 0], fps: 2.6, loop: false },   // đưa tay thấp (vỗ vai)
  strike:  { frames: [2, 2, 0], fps: 6, loop: false },        // lao tới (đá)
  cheer:   { frames: [11, 0, 11, 0], fps: 4, loop: false }    // giơ tay (vui / phản ứng)
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

  private look?: ChibiLook;
  private faceTimer?: Phaser.Time.TimerEvent;

  // đổi biểu cảm (mắt) trong `ms` mili-giây rồi trả về mắt gốc; ms<=0 = giữ tới khi gọi lại
  setFace(key: FaceKey, ms = 0) {
    if (!this.look) return;
    this.faceTimer?.remove();
    const eyes = FACE[key];
    this.applyLook({ ...this.look, eyes }, false);
    if (ms > 0) this.faceTimer = this.scene.time.delayedCall(ms, () => this.resetFace());
  }

  resetFace() {
    this.faceTimer?.remove();
    if (this.look) this.applyLook(this.look, false);
  }

  setLook(look: ChibiLook) {
    this.look = look;
    this.applyLook(look, true);
  }

  // ===== Nông cụ đang cầm hiện trên tay =====
  private toolImg?: Phaser.GameObjects.Image;
  private toolKey = '';

  setTool(key: string) {
    if (this.toolKey === key) return;
    this.toolKey = key;
    this.toolImg?.destroy();
    this.toolImg = undefined;
    if (!key || !this.scene.textures.exists(key)) return;
    // đặt ngang tầm tay, hơi lệch sang phải; lật theo hướng nhân vật
    const img = this.scene.add.image(9, -26, key).setOrigin(0.5).setScale(0.34);
    this.add(img);
    img.setFlipX(this.facingLeft);
    if (this.facingLeft) img.x = -9;
    this.toolImg = img;
  }

  private applyLook(look: ChibiLook, _store: boolean) {
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
    // đổi đồ dựng lại toàn bộ layer -> gắn lại nông cụ đang cầm
    if (this.toolKey) { const k = this.toolKey; this.toolKey = ''; this.setTool(k); }
    this.applyFrame();
  }

  // nhận cả tên animation cũ của CharacterSprite (hoe/water/pickup/axe/fishing)
  play(anim: string, onDone?: () => void) {
    const alias: Record<string, ChibiAnim> = {
      hoe: 'till', water: 'water', pickup: 'pick', axe: 'till', fishing: 'sit',
      idle: 'idle', walk: 'walk', work: 'work', sit: 'sit', lie: 'lie',
      till: 'till', pick: 'pick',
      reach: 'reach', pat: 'pat', strike: 'strike', cheer: 'cheer'
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
    if (this.toolImg) {
      this.toolImg.setFlipX(this.facingLeft);
      this.toolImg.x = this.facingLeft ? -9 : 9;
    }
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
