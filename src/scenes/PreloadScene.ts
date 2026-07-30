import Phaser from 'phaser';
import { HAIR_STYLES, CLOTHES, ACCESSORIES } from '@/data/clothing';
import { ANIMAL_LIST } from '@/data/animals';
import { hasSave, load, S } from '@/core/save';
import { CHIBI_PARTS, defaultLook, lookLayers } from '@/data/chibi';

export class PreloadScene extends Phaser.Scene {
  constructor() { super('Preload'); }

  preload() {
    const W = this.scale.width, H = this.scale.height;
    this.add.rectangle(W / 2, H / 2, W, H, 0x1a2b12);
    this.add.text(W / 2, H / 2 - 40, 'COZY FARMING', { fontFamily: 'monospace', fontSize: '42px', color: '#ffd43b' }).setOrigin(0.5);
    const barBg = this.add.rectangle(W / 2, H / 2 + 20, 420, 22, 0x0e1a08).setOrigin(0.5);
    const bar = this.add.rectangle(W / 2 - 208, H / 2 + 20, 4, 14, 0x8ce99a).setOrigin(0, 0.5);
    this.load.on('progress', (v: number) => { bar.width = 4 + 412 * v; });
    void barBg;

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
    for (const m of ['4', '10', '15', '22', '24', '101']) {
      this.load.image(`bg_${m}`, `assets/lttt/maps/${m}.png`);
    }
    // ---- Decor Avatar (repo Lttt) ----
    for (const d of ['shelter', 'house_white', 'rank_sign', 'lamp_hd', 'icecream', 'love_tree']) {
      this.load.image(`lt_${d}`, `assets/lttt/${d}.png`);
    }
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
    if (hasSave() && load()) {
      // save cũ chưa có nhân vật chibi -> gán bộ mặc định theo giới tính
      if (!S.player.chibi) {
        S.player.chibi = defaultLook(S.player.gender === 'female' ? 1 : 0);
        for (const id of lookLayers(S.player.chibi)) {
          if (!S.chibiWardrobe.includes(id)) S.chibiWardrobe.push(id);
        }
      }
      this.scene.start('World');
    } else {
      this.scene.start('CharCreate');
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
    g.destroy();
  }
}
