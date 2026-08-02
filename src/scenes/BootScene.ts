import Phaser from 'phaser';
import { RES } from '@/core/res';

// Màn hình đầu tiên: intro studio Dreamtech, đồng thời tải trước ảnh nền màn hình chính.
// Theo đúng 12 bước storyboard: hạt sáng tụ lại -> ghép chữ "d" -> "reamtech" chạy ra ->
// "studio" gõ từng chữ -> viền + shine quét -> hoàn thiện -> pixel tỏa ra -> mờ dần.
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
    this.add.rectangle(0, 0, W, H, 0x07050f).setOrigin(0);
    this.makeSparkTexture();

    const cx = W / 2, cy = H / 2;
    const PURPLE = 0x9775fa, BLUE = 0x4dabf7, WHITE = 0xffffff;

    // ---- bước 1-2: hạt sáng xuất hiện rải rác rồi xoáy tụ vào tâm ----
    const N = 46;
    const sparks: Phaser.GameObjects.Image[] = [];
    for (let i = 0; i < N; i++) {
      const ang = Math.random() * Math.PI * 2;
      const rad = 60 * RES + Math.random() * (Math.min(W, H) * 0.42);
      const sp = this.add.image(cx + Math.cos(ang) * rad, cy + Math.sin(ang) * rad, 'spark')
        .setTint(Math.random() < 0.5 ? PURPLE : BLUE)
        .setAlpha(0).setScale(0.4 + Math.random() * 0.8);
      sparks.push(sp);
      this.tweens.add({ targets: sp, alpha: 1, duration: 260, delay: Math.random() * 300, ease: 'sine.out' });
    }
    // xoáy + tụ về tâm (0.4s -> 0.8s)
    this.time.delayedCall(380, () => {
      for (const sp of sparks) {
        const dx = sp.x - cx, dy = sp.y - cy;
        const midAng = Math.atan2(dy, dx) + 1.1;
        const midR = Math.hypot(dx, dy) * 0.45;
        this.tweens.chain({
          targets: sp,
          tweens: [
            { x: cx + Math.cos(midAng) * midR, y: cy + Math.sin(midAng) * midR, duration: 220, ease: 'sine.inOut' },
            { x: cx, y: cy, scale: 0, alpha: 0, duration: 200, ease: 'sine.in' }
          ]
        });
      }
    });

    // ---- bước 3-4: ghép thành chữ "d", nảy nhẹ ----
    const dTxt = this.add.text(cx, cy, 'd', {
      fontFamily: 'Verdana, Arial, sans-serif', fontSize: `${96 * RES}px`, fontStyle: 'bold', color: '#b197fc'
    }).setOrigin(0.5).setScale(0).setAlpha(0)
      .setShadow(0, 0, '#9775fa', 18, true, true);
    const nameGroupX = cx; // trục để "reamtech" chạy ra từ "d"

    this.time.delayedCall(760, () => {
      dTxt.setAlpha(1);
      this.tweens.add({
        targets: dTxt, scale: 1, duration: 260, ease: 'back.out(2)',
        onComplete: () => this.tweens.add({ targets: dTxt, scale: { from: 1, to: 1.12 }, yoyo: true, duration: 180, ease: 'sine.inOut' })
      });
    });

    // ---- bước 5: "reamtech" chạy ra từ chữ "d" (mask reveal trái->phải) ----
    const fullName = this.add.text(cx, cy, 'dreamtech', {
      fontFamily: 'Verdana, Arial, sans-serif', fontSize: `${96 * RES}px`, fontStyle: 'bold', color: '#ffffff'
    }).setOrigin(0.5).setAlpha(0);
    const nameW = fullName.width, nameH = fullName.height;
    const maskG = this.make.graphics({});
    fullName.setMask(maskG.createGeometryMask());
    const drawNameMask = (w: number) => {
      maskG.clear();
      maskG.fillStyle(0xffffff);
      maskG.fillRect(fullName.x - nameW / 2, fullName.y - nameH, Math.max(0, w), nameH * 2);
    };
    drawNameMask(0);

    this.time.delayedCall(1580, () => {
      dTxt.setVisible(false);
      fullName.setAlpha(1);
      this.tweens.addCounter({
        from: 0, to: nameW, duration: 620, ease: 'sine.out',
        onUpdate: (t) => drawNameMask(t.getValue() ?? 0)
      });
      this.cameras.main.flash(120, 151, 117, 250, false);
    });

    // ---- bước 6: "studio" gõ từng chữ bên dưới ----
    const studioFull = 'studio';
    const studioTxt = this.add.text(cx, cy + nameH * 0.72, '', {
      fontFamily: 'Verdana, Arial, sans-serif', fontSize: `${26 * RES}px`, color: '#e7ecff', letterSpacing: 10
    }).setOrigin(0.5).setAlpha(0);

    this.time.delayedCall(2380, () => {
      studioTxt.setAlpha(1);
      let i = 0;
      const typer = this.time.addEvent({
        delay: 90, repeat: studioFull.length - 1,
        callback: () => { i++; studioTxt.setText(studioFull.slice(0, i)).setOrigin(0.5); }
      });
    });

    // ---- bước 7: viền + 2 chấm trang trí hai bên "studio" ----
    const decoL = this.add.circle(0, 0, 4 * RES, 0x9775fa).setAlpha(0);
    const decoR = this.add.circle(0, 0, 4 * RES, 0x4dabf7).setAlpha(0);
    const lineL = this.add.rectangle(0, 0, 46 * RES, 2, 0x9775fa).setAlpha(0);
    const lineR = this.add.rectangle(0, 0, 46 * RES, 2, 0x4dabf7).setAlpha(0);
    this.time.delayedCall(3000, () => {
      const sw = studioTxt.displayWidth || 90 * RES;
      const y = studioTxt.y;
      decoL.setPosition(cx - sw / 2 - 34 * RES, y); decoR.setPosition(cx + sw / 2 + 34 * RES, y);
      lineL.setPosition(cx - sw / 2 - 12 * RES, y); lineR.setPosition(cx + sw / 2 + 12 * RES, y);
      for (const o of [decoL, decoR, lineL, lineR]) this.tweens.add({ targets: o, alpha: 1, duration: 260 });
    });

    // ---- bước 8: hiệu ứng shine quét ngang qua toàn logo ----
    const shine = this.add.rectangle(cx - nameW, cy - nameH, 40 * RES, nameH * 2.4, WHITE, 0.55)
      .setAngle(20).setBlendMode(Phaser.BlendModes.ADD).setAlpha(0);
    this.time.delayedCall(3400, () => {
      shine.setAlpha(1);
      this.tweens.add({
        targets: shine, x: cx + nameW, duration: 380, ease: 'sine.inOut',
        onComplete: () => shine.setAlpha(0)
      });
    });

    // ---- bước 9: logo hoàn thiện, tỏa sáng nhẹ ----
    this.time.delayedCall(3820, () => {
      this.tweens.add({ targets: [fullName, studioTxt], alpha: { from: 1, to: 1 } });
      fullName.setShadow(0, 0, '#9775fa', 22, true, true);
    });

    // ---- bước 10-11: pixel tỏa ra rồi cả logo mờ dần ----
    this.time.delayedCall(4200, () => {
      for (let i = 0; i < 30; i++) {
        const px = this.add.image(cx + (Math.random() - 0.5) * nameW, cy + (Math.random() - 0.5) * nameH, 'spark')
          .setTint(Math.random() < 0.5 ? PURPLE : BLUE).setScale(0.3 + Math.random() * 0.5);
        const ang = Math.random() * Math.PI * 2, dist = 60 * RES + Math.random() * 120 * RES;
        this.tweens.add({
          targets: px, x: px.x + Math.cos(ang) * dist, y: px.y + Math.sin(ang) * dist,
          alpha: 0, duration: 500 + Math.random() * 200, ease: 'sine.out'
        });
      }
      this.tweens.add({
        targets: [fullName, studioTxt, decoL, decoR, lineL, lineR], alpha: 0, duration: 400, delay: 200, ease: 'sine.in'
      });
    });

    // ---- bước 12: màn hình tối, kết thúc intro ----
    this.cameras.main.fadeIn(300, 7, 5, 15);
    this.time.delayedCall(5100, () => { this.minTimeDone = true; this.tryNext(); });
  }

  private makeSparkTexture() {
    if (this.textures.exists('spark')) return;
    const g = this.add.graphics();
    g.fillStyle(0xffffff, 1);
    g.fillCircle(6, 6, 6);
    g.generateTexture('spark', 12, 12);
    g.destroy();
  }

  private tryNext() {
    if (!this.ready || !this.minTimeDone) return;
    this.cameras.main.fadeOut(350, 7, 5, 15);
    this.cameras.main.once('camerafadeoutcomplete', () => this.scene.start('Preload'));
  }
}
