import Phaser from 'phaser';
import { HAIR_STYLES, CLOTHES, ACCESSORIES } from '@/data/clothing';
import { ANIMAL_LIST } from '@/data/animals';
import { hasSave, load, S } from '@/core/save';
import { CHIBI_PARTS, defaultLook, lookLayers, G_MALE, G_FEMALE } from '@/data/chibi';
import { RES } from '@/core/res';
import { GAME_VERSION, resFresh, markResLoaded } from '@/core/version';
import { showLoginFlow } from '@/ui/login';
import { ChibiSprite } from '@/gfx/ChibiSprite';

export class PreloadScene extends Phaser.Scene {
  private mascots: ChibiSprite[] = [];

  constructor() { super('Preload'); }

  preload() {
    this.buildTitleScreen();

    // ---- Nhân vật (32px) ----
    for (let i = 1; i <= 8; i++) {
      this.load.spritesheet(`char_base_${i - 1}`, `assets/char/base/char${i}.png`, { frameWidth: 32, frameHeight: 32 });
    }
    for (const h of HAIR_STYLES) this.load.spritesheet(`hair_${h.id}`, `assets/char/hair/${h.id}.png`, { frameWidth: 32, frameHeight: 32 });
    for (const c of CLOTHES) this.load.spritesheet(`clothes_${c.id}`, `assets/char/clothes/${c.id}.png`, { frameWidth: 32, frameHeight: 32 });
    for (const a of ACCESSORIES) this.load.spritesheet(`acc_${a.id}`, `assets/char/acc/${a.id}.png`, { frameWidth: 32, frameHeight: 32 });
    this.load.spritesheet('eyes_eyes', 'assets/char/eyes/eyes.png', { frameWidth: 32, frameHeight: 32 });
    this.load.spritesheet('emoticons', 'assets/char/emoticons.png', { frameWidth: 16, frameHeight: 16 });
    this.load.image('char_shadow', 'assets/char/shadow.png');

    // ---- Nông trại ----
    this.load.spritesheet('crops', 'assets/farm/crops_all.png', { frameWidth: 16, frameHeight: 16 });
    this.load.spritesheet('seeds', 'assets/farm/seeds.png', { frameWidth: 16, frameHeight: 16 });
    this.load.spritesheet('tools', 'assets/farm/tools.png', { frameWidth: 16, frameHeight: 16 });
    this.load.spritesheet('items16', 'assets/farm/items.png', { frameWidth: 16, frameHeight: 16 });
    this.load.spritesheet('pond_deco', 'assets/farm/pond_deco.png', { frameWidth: 16, frameHeight: 16 });
    this.load.image('fx_heart', 'assets/animals/heart.png');
    this.load.image('fx_star', 'assets/ui/pack/icon_level.png');
    this.load.image('fx_drop', 'assets/ui/act/tool_can.png');
    this.load.image('av_water', 'assets/farm/av_water.png');
    this.load.image('av_water_spark', 'assets/farm/av_water_spark.png');

    // ---- Vật nuôi ----
    for (const a of ANIMAL_LIST) {
      this.load.spritesheet(`animal_${a.id}`, `assets/animals/${a.sheet}`, { frameWidth: a.frameW, frameHeight: a.frameH });
    }

    // ---- Cá / thiên nhiên ----
    this.load.spritesheet('fish', 'assets/fishing/fish_all.png', { frameWidth: 16, frameHeight: 16 });
    this.load.spritesheet('nature', 'assets/nature/global.png', { frameWidth: 16, frameHeight: 16 });

    // ---- Nhà cửa (town + beach) ----
    for (const b of ['pub', 'cinema', 'school', 'cafe', 'inn', 'library', 'greenhouse', 'arcade', 'supam', 'shop', 'beachbar', 'fishshop',
      'farm_house', 'farm_store', 'farm_market', 'farm_barn', 'farm_coop']) {
      this.load.image(`bld_${b}`, `assets/buildings/${b}.png`);
    }
    // ---- Decor ngoài trời (cắt từ tileset) ----
    for (const d of ['tree_round', 'tree_round2', 'tree_pine', 'tree_khe', 'bench', 'lamp_green', 'lamp_black', 'scarecrow', 'barrel', 'flower_pot', 'bush', 'busstop']) {
      this.load.image(`deco_${d}`, `assets/deco/${d}.png`);
    }
    // ---- Nhân vật chibi Avatar: strip 15 frame 64x96 mỗi part ----
    for (const id of Object.keys(CHIBI_PARTS)) {
      this.load.spritesheet(`chibi_${id}`, `assets/chibi/${id}.png`, { frameWidth: 64, frameHeight: 96 });
    }

    // ---- Nền map Avatar (repo Lttt) ----
    for (const m of ['4', '10', '15', '22', '24', '101', 'farmbg']) {
      this.load.image(`bg_${m}`, `assets/lttt/maps/${m}.png`);
    }
    // ---- Decor Avatar (repo Lttt) ----
    for (const d of ['shelter', 'house_white', 'rank_sign', 'lamp_hd', 'icecream', 'love_tree']) {
      this.load.image(`lt_${d}`, `assets/lttt/${d}.png`);
    }
    // ---- Nhà + cây + hồ HD Avatar cho nông trại ----
    for (const b of ['kitchen', 'store', 'warehouse', 'tree', 'doghouse', 'barn', 'petshop', 'petbed']) {
      this.load.image(`lt_${b}`, `assets/lttt/bld/${b}.png`);
    }
    this.load.image('lt_pond', 'assets/lttt/pond.png');
    this.load.spritesheet('avdog', 'assets/farm/avdog.png', { frameWidth: 46, frameHeight: 38 });
    this.load.spritesheet('avcat', 'assets/farm/avcat.png', { frameWidth: 40, frameHeight: 32 });
    this.load.spritesheet('avparrot', 'assets/farm/avparrot.png', { frameWidth: 34, frameHeight: 42 });
    // ---- Ô ruộng kiểu Avatar (repo Lttt) ----
    for (let i = 0; i < 8; i++) this.load.image(`fcell${i}`, `assets/lttt/farm/cell${i}.png`);
    this.load.image('buyland', 'assets/lttt/farm/buyLand.png');

    // ---- Xe cộ ----
    for (const v of ['bus', 'truck_orange', 'camper_pink', 'camper_yellow', 'truck_bee', 'truck_gift']) {
      this.load.image(`veh_${v}`, `assets/vehicles/${v}.png`);
    }
    // ---- Nội thất (cắt từ Interior pack) ----
    for (const f of ['furn_bed', 'furn_bed_pink', 'furn_couch', 'furn_chair', 'furn_table', 'furn_shelf', 'furn_kitchen', 'furn_fireplace', 'furn_tv', 'deco_plant', 'deco_vase', 'deco_bear', 'deco_rug', 'deco_xmas_tree', 'aquarium_small', 'aquarium_big']) {
      this.load.image(`fs_${f}`, `assets/interior/${f}.png`);
    }
  }

  create() {
    this.makeGroundTextures();
    this.makeMiscTextures();
    markResLoaded();

    const hasChar = hasSave() && load();
    if (hasChar) {
      // save cũ chưa có nhân vật chibi -> gán bộ mặc định theo giới tính
      // (save cũ hơn nữa lưu gender chibi = 0 theo quy ước sai -> đổi lại cho đúng data Avatar: 1 nam, 2 nữ)
      if (!S.player.chibi || (S.player.chibi.gender !== 1 && S.player.chibi.gender !== 2)) {
        S.player.chibi = defaultLook(S.player.gender === 'female' ? 2 : 1);
        for (const id of lookLayers(S.player.chibi)) {
          if (!S.chibiWardrobe.includes(id)) S.chibiWardrobe.push(id);
        }
      }
    }

    // linh vật 2 bên phải màn hình (như key art GunPow)
    const W = this.scale.width, H = this.scale.height;
    const boy = new ChibiSprite(this, W * 0.86, H * 0.9, defaultLook(G_MALE));
    boy.setScale(2.4 * RES); boy.play('idle'); boy.setDir(3);
    const girl = new ChibiSprite(this, W * 0.72, H * 0.94, defaultLook(G_FEMALE));
    girl.setScale(2.8 * RES); girl.play('idle');
    this.mascots = [boy, girl];

    // khung đăng nhập -> chọn máy chủ -> Bắt đầu
    showLoginFlow(() => this.scene.start(hasChar ? 'World' : 'CharCreate'));
  }

  update(_t: number, dt: number) {
    for (const m of this.mascots) m.tick(dt);
  }

  // Nền title: ảnh map + logo game + badge 12+ + thanh tải tài nguyên (chỉ khi bản mới)
  private buildTitleScreen() {
    const W = this.scale.width, H = this.scale.height;

    const bg = this.add.image(W / 2, H / 2, 'title_bg');
    const cover = Math.max(W / bg.width, H / bg.height) * 1.05;
    bg.setScale(cover);
    this.tweens.add({ targets: bg, scale: cover * 1.06, duration: 9000, yoyo: true, repeat: -1, ease: 'sine.inout' });
    this.add.rectangle(0, 0, W, H, 0x0a1220, 0.28).setOrigin(0);

    // logo game (góc trái trên như GunPow)
    const lx = W * 0.17, ly = H * 0.14;
    const t1 = this.add.text(lx, ly, 'COZY', {
      fontFamily: 'Verdana, sans-serif', fontSize: `${40 * RES}px`, fontStyle: 'bold',
      color: '#ffd43b', stroke: '#7a4a1f', strokeThickness: 7 * RES
    }).setOrigin(0.5).setAngle(-4).setShadow(0, 4 * RES, '#00000088', 6 * RES);
    const t2 = this.add.text(lx + 14 * RES, ly + 40 * RES, 'FARMING', {
      fontFamily: 'Verdana, sans-serif', fontSize: `${30 * RES}px`, fontStyle: 'bold',
      color: '#8ce99a', stroke: '#1f5c2c', strokeThickness: 6 * RES
    }).setOrigin(0.5).setAngle(-4).setShadow(0, 4 * RES, '#00000088', 6 * RES);
    this.tweens.add({ targets: [t1, t2], y: `+=${5 * RES}`, duration: 2200, yoyo: true, repeat: -1, ease: 'sine.inout' });

    // badge 12+ và cảnh báo sức khỏe
    const bx = W * 0.06, by = H * 0.38;
    const g = this.add.graphics();
    g.fillStyle(0xc9a227); g.fillCircle(bx, by, 17 * RES);
    g.lineStyle(2 * RES, 0xfff3bf); g.strokeCircle(bx, by, 17 * RES);
    this.add.text(bx, by, '12+', { fontFamily: 'Verdana', fontSize: `${11 * RES}px`, fontStyle: 'bold', color: '#3d2c05' }).setOrigin(0.5);
    this.add.text(bx + 24 * RES, by, 'Chơi quá 180 phút một ngày\nsẽ ảnh hưởng xấu đến sức khỏe', {
      fontFamily: 'sans-serif', fontSize: `${9 * RES}px`, color: '#e8e8e8', backgroundColor: '#00000066', padding: { x: 6 * RES, y: 4 * RES }
    }).setOrigin(0, 0.5);

    this.add.text(10 * RES, H - 16 * RES, `v${GAME_VERSION}`, { fontFamily: 'monospace', fontSize: `${10 * RES}px`, color: '#ffffffaa' });

    // thanh tải: người mới / sau update thấy thanh to có %, còn lại chỉ 1 dòng nhỏ
    if (!resFresh()) {
      const barW = 440 * RES, barY = H * 0.86;
      const barBg = this.add.rectangle(W / 2, barY, barW + 8 * RES, 24 * RES, 0x0e1a08, 0.85).setStrokeStyle(2 * RES, 0x8ce99a);
      const bar = this.add.rectangle(W / 2 - barW / 2, barY, 4, 14 * RES, 0x8ce99a).setOrigin(0, 0.5);
      const lbl = this.add.text(W / 2, barY - 24 * RES, 'Đang tải tài nguyên... 0%', {
        fontFamily: 'sans-serif', fontSize: `${13 * RES}px`, color: '#fff'
      }).setOrigin(0.5).setShadow(0, 2, '#000', 3);
      this.load.on('progress', (v: number) => {
        bar.width = 4 + (barW - 4) * v;
        lbl.setText(`Đang tải tài nguyên... ${Math.round(v * 100)}%`);
      });
      this.load.on('complete', () => { bar.destroy(); lbl.destroy(); barBg.destroy(); });
    } else {
      const lbl = this.add.text(W / 2, H * 0.86, 'Đang kiểm tra tài nguyên...', {
        fontFamily: 'sans-serif', fontSize: `${11 * RES}px`, color: '#ffffffcc'
      }).setOrigin(0.5).setShadow(0, 2, '#000', 3);
      this.load.on('complete', () => lbl.destroy());
    }
  }

  // Nền đất vẽ procedural 16px (palette khớp asset pack)
  private makeGroundTextures() {
    const mk = (key: string, base: number, speckle: number, density = 6) => {
      if (this.textures.exists(key)) return;
      const g = this.add.graphics();
      g.fillStyle(base); g.fillRect(0, 0, 32, 32);
      g.fillStyle(speckle);
      // hoa văn ổn định (pseudo-random cố định)
      let seed = key.length * 7 + 13;
      const rnd = () => (seed = (seed * 9301 + 49297) % 233280) / 233280;
      for (let i = 0; i < density; i++) {
        g.fillRect(Math.floor(rnd() * 30), Math.floor(rnd() * 30), 2, 1);
      }
      g.generateTexture(key, 32, 32);
      g.destroy();
    };
    mk('g_grass', 0x71aa34, 0x5c8a2a, 8);
    mk('g_grass_dark', 0x5c8a2a, 0x4a7022, 6);
    mk('g_sand', 0xe8d5a3, 0xd9c184, 8);
    mk('g_wood', 0xa9714b, 0x8d5a3a, 4);
    mk('g_stone', 0xb5bdb0, 0x9aa596, 6);
    mk('g_soil', 0x8a5a33, 0x6f4626, 6);
    mk('g_soil_wet', 0x5f3d20, 0x4c3019, 6);
    mk('g_water', 0x4aa5d9, 0x3c8fc4, 5);
    mk('g_path', 0xcfad84, 0xb8946a, 5);
  }

  private makeMiscTextures() {
    const g = this.add.graphics();
    // bướm (2 cánh)
    g.clear(); g.fillStyle(0xffffff);
    g.fillEllipse(5, 6, 8, 10); g.fillEllipse(13, 6, 8, 10);
    g.fillStyle(0x333333); g.fillRect(8, 2, 2, 10);
    g.generateTexture('butterfly', 18, 14);
    // bọ
    g.clear(); g.fillStyle(0xffffff);
    g.fillEllipse(6, 6, 10, 8);
    g.fillStyle(0x222222); g.fillRect(5, 1, 2, 2);
    g.generateTexture('bug', 12, 12);
    // phao câu
    g.clear(); g.fillStyle(0xfa5252); g.fillCircle(4, 4, 4);
    g.fillStyle(0xffffff); g.fillCircle(4, 3, 2);
    g.generateTexture('bobber', 8, 8);
    // chấm sáng (đèn đêm / đom đóm)
    g.clear(); g.fillStyle(0xfff3bf, 1); g.fillCircle(8, 8, 8);
    g.generateTexture('glow', 16, 16);
    // giọt mưa
    g.clear(); g.fillStyle(0xa5d8ff); g.fillRect(0, 0, 2, 8);
    g.generateTexture('raindrop', 2, 8);
    // ô chọn
    g.clear(); g.lineStyle(2, 0xffd43b); g.strokeRect(1, 1, 30, 30);
    g.generateTexture('sel', 32, 32);
    // đống đất (xẻng đào)
    g.clear();
    g.fillStyle(0x8a5a33); g.fillEllipse(11, 12, 20, 10);
    g.fillStyle(0x6f4626); g.fillEllipse(11, 10, 16, 8);
    g.fillStyle(0xa9714b); g.fillRect(6, 6, 3, 2); g.fillRect(13, 8, 2, 2);
    g.generateTexture('mound', 22, 16);
    g.destroy();
  }
}
