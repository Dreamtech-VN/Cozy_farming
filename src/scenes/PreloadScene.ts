import { CROP_ANIM } from '@/data/crops';
import Phaser from 'phaser';
import { HAIR_STYLES, CLOTHES, ACCESSORIES } from '@/data/clothing';
import { ANIMAL_LIST } from '@/data/animals';
import { hasSave, load, S } from '@/core/save';
import { CHIBI_PARTS, defaultLook, lookLayers } from '@/data/chibi';
import { RES } from '@/core/res';
import { GAME_VERSION, resFresh, markResLoaded } from '@/core/version';
import { showLoginFlow } from '@/ui/login';
import { showLoading } from '@/ui/loading';

export class PreloadScene extends Phaser.Scene {

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
    // cây trồng có animation lớn dần (Pack2)
    for (const [id, a] of Object.entries(CROP_ANIM)) {
      this.load.spritesheet(`grow_${id}`, `assets/pack2/crops/${id}.png`, { frameWidth: a[0], frameHeight: a[1] });
    }
    for (let i = 1; i <= 5; i++) {
      this.load.spritesheet(`pwater${i}`, `assets/pack2/water/water_${i}.png`, { frameWidth: 16, frameHeight: 16 });
    }
    this.load.spritesheet('seeds', 'assets/farm/seeds.png', { frameWidth: 16, frameHeight: 16 });
    this.load.spritesheet('tools', 'assets/farm/tools.png', { frameWidth: 16, frameHeight: 16 });
    this.load.spritesheet('items16', 'assets/farm/items.png', { frameWidth: 16, frameHeight: 16 });
    this.load.spritesheet('pond_deco', 'assets/farm/pond_deco.png', { frameWidth: 16, frameHeight: 16 });
    this.load.image('fx_heart', 'assets/animals/heart.png');
    this.load.image('fx_star', 'assets/ui/pack/icon_level.png');
    this.load.image('fx_drop', 'assets/ui/act/tool_can.png');
    this.load.image('trough', 'assets/lttt/trough.png');
    this.load.image('trough_full', 'assets/lttt/trough_full.png');
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
    // Nhà cửa dùng asset repo Lttt (assets/lttt/bld) — bộ nhà pack Cozy chỉ
    // còn giữ cho map cổng cũ, nay không map nào dùng nữa nên thôi nạp.
    // ---- Trời + hàng cây xa (bgHD Avatar) ----
    for (const b of ['sky', 'hills', 'fields']) {
      this.load.image(`sky_${b}`, `assets/lttt/sky/${b}.png`);
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
    for (const m of ['4', '10', '14', '15', '22', '24', '58', '59', '101', '104', '105', 'farmbg', 'farmgate']) {
      this.load.image(`bg_${m}`, `assets/lttt/maps/${m}.png`);
    }
    // ---- Decor Avatar (repo Lttt) ----
    for (const d of ['shelter', 'house_white', 'rank_sign', 'order_board', 'lamp_hd', 'icecream', 'love_tree']) {
      this.load.image(`lt_${d}`, `assets/lttt/${d}.png`);
    }
    this.load.image('lt_shop_av', 'assets/lttt/bld/shop_av.png');   // cửa hàng gốc Avatar
    // ---- Nhà + cây + hồ HD Avatar cho nông trại ----
    for (const b of ['kitchen', 'store', 'warehouse', 'tree', 'doghouse', 'barn', 'petshop', 'petbed', 'atm']) {
      this.load.image(`lt_${b}`, `assets/lttt/bld/${b}.png`);
    }
    this.load.image('lt_pond', 'assets/lttt/pond.png');
    // thú cưng GunPow nạp khi thả ra map (xem WorldScene.spawnPet)
    // ---- Ô ruộng kiểu Avatar (repo Lttt) ----
    // ô ruộng đã bỏ viền cỏ để không đè lên nền cỏ của map
    for (let i = 0; i < 8; i++) this.load.image(`fcell${i}`, `assets/lttt/farm/cellin${i}.png`);
    this.load.image('buyland', 'assets/lttt/farm/buyLand.png');
    this.load.image('mound', 'assets/farm/mound.png');          // đống đất để đào xẻng
    this.load.image('glow', 'assets/farm/glow.png');            // quầng sáng đèn đường

    // ---- Nông cụ cầm trên tay ----
    for (const [k, u] of Object.entries({
      hoe: 'assets/farm/chibi/18_hoe.png',
      can: 'assets/farm/chibi/17_watering_can.png',
      basket: 'assets/farm/chibi/19_sickle.png',
      axe: 'assets/farm/chibi/20_axe.png',
      net: 'assets/chibi/tools/net.png'
    })) this.load.image(`held_${k}`, u);

    // ---- Xe cộ ----
    for (const v of ['bus', 'truck_orange', 'camper_pink', 'camper_yellow', 'camper_green', 'truck_bee', 'truck_gift']) {
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

    // key art đã vẽ sẵn logo + 2 nhân vật nên không dựng linh vật chibi nữa

    // khung đăng nhập -> chọn máy chủ -> Bắt đầu
    showLoginFlow(() => {
      if (hasChar) showLoading();   // vào thẳng game -> che bằng key art trong lúc dựng cảnh
      this.scene.start(hasChar ? 'World' : 'CharCreate');
    });
  }


  // Nền title: ảnh map + logo game + badge 12+ + thanh tải tài nguyên (chỉ khi bản mới)
  private buildTitleScreen() {
    const W = this.scale.width, H = this.scale.height;

    // đẩy tranh lên chút để logo không bị khung đăng nhập che
    const bg = this.add.image(W / 2, H / 2 - 36, 'title_bg');
    const cover = Math.max(W / bg.width, H / bg.height);
    bg.setScale(cover);
    this.tweens.add({ targets: bg, scale: cover * 1.03, duration: 11000, yoyo: true, repeat: -1, ease: 'sine.inout' });
    this.add.rectangle(0, 0, W, H, 0x0a1220, 0.12).setOrigin(0);

    // logo chữ "Sunny Town" thật (ảnh wordmark thật, nền đã tách trong suốt)
    // — góc trái trên, cao cố định rồi co ngang theo đúng tỉ lệ ảnh gốc.
    if (this.textures.exists('sunny_logo')) {
      const logoH = 74 * RES;   // to hơn cho rõ chữ (trước 50*RES nhỏ + xa cỡ ảnh gốc nên mờ)
      const src = this.textures.get('sunny_logo').getSourceImage();
      const logoW = logoH * (src.width / src.height);
      this.add.image(12 * RES, 8 * RES, 'sunny_logo').setOrigin(0, 0).setDisplaySize(logoW, logoH);
    }

    // Key art gốc đã được xoá sạch badge 12+ + dòng bản quyền AI vẽ sẵn
    // (public/assets/ui/title_bg.jpg đã inpaint lại) -> giờ vẽ đè badge 12+
    // THẬT (hd/12Plus.png gốc Lttt) + dòng cảnh báo lên khung kính tối cho
    // rõ chữ (chữ tối trên nền sáng trước đó mờ, khó đọc).
    // Khung nền phải đo đúng theo chữ thật -> trước đây để cỡ cố định rộng
    // hơn nội dung, dư ra một mảng đen trống trông như lỗi đồ hoạ.
    const padX = 8 * RES, padBottom = 6 * RES;
    const barH = 46 * RES;
    const badgeX = padX + 18 * RES, badgeY = H - padBottom - barH / 2;
    const warnStyle = { fontFamily: 'sans-serif', fontSize: `${9.5 * RES}px`, color: '#ffffff', fontStyle: 'bold' };
    const warnMsg = 'Chơi quá 180 phút một ngày\nsẽ ảnh hưởng xấu đến sức khỏe';
    // đo trước bằng text tạm (không add vào scene) để vẽ khung nền KHÍT chữ
    // thật -> trước đây để khung rộng cố định hơn nội dung, dư ra một mảng
    // đen trống nhìn như lỗi đồ hoạ.
    const probe = this.make.text({ text: warnMsg, style: warnStyle }, false);
    const textW = probe.width;
    probe.destroy();
    const barW = (badgeX + 24 * RES + textW + 10 * RES) - padX;
    const barCX = padX + barW / 2, barCY = badgeY;
    this.add.graphics().fillStyle(0x000000, 0.55)
      .fillRoundedRect(barCX - barW / 2, barCY - barH / 2, barW, barH, 8 * RES);
    if (this.textures.exists('age12')) {
      this.add.image(badgeX, badgeY, 'age12').setScale(2 * RES).setOrigin(0.5);
    }
    this.add.text(badgeX + 24 * RES, badgeY, warnMsg, warnStyle)
      .setOrigin(0, 0.5).setShadow(0, 1, '#000000cc', 2, true, true);

    // dòng bản quyền viết lại bằng text thật (thay cho dòng AI vẽ sẵn đã xoá)
    this.add.text(W / 2, H - padBottom - 8 * RES, '© 2026 Dreamtech Studio. All right reserved.', {
      fontFamily: 'sans-serif', fontSize: `${11 * RES}px`, color: '#ffffff', fontStyle: 'bold'
    }).setOrigin(0.5).setShadow(0, 1, '#000000cc', 3, true, true);

    // số bản build góc phải dưới
    this.add.text(W - 8 * RES, H - 16 * RES, `v${GAME_VERSION}`, {
      fontFamily: 'monospace', fontSize: `${10 * RES}px`, color: '#ffffff'
    }).setOrigin(1, 0.5).setShadow(0, 1, '#000000cc', 2, true, true);

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
    g.destroy();
  }
}
