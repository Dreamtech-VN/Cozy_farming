import Phaser from 'phaser';
import { S, save } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { ZONES, type ZoneDef, type NpcDef } from '@/data/zones';
import { CROPS } from '@/data/crops';
import { ANIMALS } from '@/data/animals';
import { FURNITURE, WALLPAPERS, FLOORS } from '@/data/furniture';
import { CharacterSprite, type Dir } from '@/gfx/CharacterSprite';
import { virtualInput, consumeAction } from '@/core/input';
import * as farming from '@/systems/farming';
import * as livestock from '@/systems/livestock';
import * as fishing from '@/systems/fishing';
import { houseSize, partyActive } from '@/systems/housing';
import { darkness, currentWeather, initTime } from '@/systems/time';
import { INSECTS, type InsectDef } from '@/data/insects';
import { sfx } from '@/core/audio';

const T = 16; // kích thước tile
const FARM_ORIGIN = { x: 6, y: 12 }; // vị trí ruộng trong zone farm (theo tile)
const BARN_RECT = { x: 30, y: 4, w: 12, h: 8 };

// Decor đặt sẵn theo khu (sprite thật từ asset pack) — toạ độ tile, origin đáy giữa
const ZONE_DECOR: Record<string, { key: string; x: number; y: number; s?: number }[]> = {
  town: [
    { key: 'bld_arcade', x: 12, y: 8 },      // trên cổng Game Center
    { key: 'bld_school', x: 24, y: 8 },      // trên cổng Trường học
    { key: 'bld_supam', x: 36, y: 8 },       // trên cổng Khu mua sắm
    { key: 'bld_pub', x: 6, y: 16 },
    { key: 'bld_cafe', x: 15, y: 16 },
    { key: 'bld_library', x: 26, y: 16 },
    { key: 'bld_inn', x: 40, y: 17 },
    { key: 'bld_shop', x: 8, y: 28 },
    { key: 'bld_greenhouse', x: 24, y: 33 }, // trên cổng Nhà riêng
    { key: 'deco_lamp_black', x: 10, y: 20 }, { key: 'deco_lamp_black', x: 20, y: 20 },
    { key: 'deco_lamp_black', x: 30, y: 20 }, { key: 'deco_lamp_black', x: 40, y: 20 },
    { key: 'deco_bench', x: 14, y: 22 }, { key: 'deco_bench', x: 34, y: 22 },
    { key: 'deco_flower_pot', x: 12, y: 22 }, { key: 'deco_flower_pot', x: 36, y: 22 }
  ],
  farm: [
    { key: 'deco_scarecrow', x: 4, y: 12 },
    { key: 'deco_barrel', x: 28, y: 4 }, { key: 'deco_barrel', x: 28, y: 6 },
    { key: 'deco_flower_pot', x: 6, y: 8 }, { key: 'deco_flower_pot', x: 12, y: 8 }
  ],
  park: [
    { key: 'deco_bench', x: 10, y: 10 }, { key: 'deco_bench', x: 26, y: 16 }, { key: 'deco_bench', x: 16, y: 24 },
    { key: 'deco_lamp_green', x: 14, y: 10 }, { key: 'deco_lamp_green', x: 30, y: 16 }, { key: 'deco_lamp_green', x: 20, y: 24 },
    { key: 'deco_bush', x: 8, y: 14 }, { key: 'deco_bush', x: 22, y: 12 }, { key: 'deco_bush', x: 30, y: 22 },
    { key: 'deco_flower_pot', x: 12, y: 10 }, { key: 'deco_flower_pot', x: 28, y: 16 }
  ],
  beach: [
    { key: 'bld_fishshop', x: 10, y: 7 },    // tiệm câu ông Biển
    { key: 'bld_beachbar', x: 22, y: 12 },
    { key: 'deco_barrel', x: 15, y: 8 }, { key: 'deco_bench', x: 18, y: 16 }
  ],
  pond: [
    { key: 'deco_bench', x: 12, y: 5 }, { key: 'deco_lamp_green', x: 24, y: 5 },
    { key: 'deco_barrel', x: 6, y: 8 }
  ]
};

interface WorldAction { icon: string; label: string; cb: () => void }

interface InsectSprite { def: InsectDef; obj: Phaser.GameObjects.Image; vx: number; vy: number; t: number }

export class WorldScene extends Phaser.Scene {
  zone!: ZoneDef;
  player!: CharacterSprite;
  private npcs: { def: NpcDef; sprite: CharacterSprite }[] = [];
  private plotTiles: Phaser.GameObjects.Image[] = [];
  private cropSprites: (Phaser.GameObjects.Sprite | undefined)[] = [];
  private plotOverlays: Phaser.GameObjects.Image[] = [];
  private animalSprites = new Map<string, Phaser.GameObjects.Sprite>();
  private insects: InsectSprite[] = [];
  private furnitureObjs: Phaser.GameObjects.Container[] = [];
  private partyGuests: CharacterSprite[] = [];
  private darkOverlay!: Phaser.GameObjects.Rectangle;
  private rain?: Phaser.GameObjects.Particles.ParticleEmitter;
  private waterRect?: Phaser.Geom.Rectangle;
  private pondEllipse?: Phaser.Geom.Ellipse;
  private fishingState: 'idle' | 'waiting' | 'bite' | 'reeling' = 'idle';
  private bobber?: Phaser.GameObjects.Image;
  private biteTimer?: Phaser.Time.TimerEvent;
  private selector!: Phaser.GameObjects.Image;
  private busy = false; // đang chạy animation hành động
  private placingItem?: string; // đang đặt nội thất
  private placeGhost?: Phaser.GameObjects.Container;
  private cursors!: Phaser.Types.Input.Keyboard.CursorKeys;
  private wasd!: Record<string, Phaser.Input.Keyboard.Key>;
  private lastHintKey = '';

  constructor() { super('World'); }

  init() {
    this.npcs = []; this.plotTiles = []; this.cropSprites = []; this.plotOverlays = [];
    this.animalSprites.clear(); this.insects = []; this.furnitureObjs = [];
    this.partyGuests = []; this.fishingState = 'idle'; this.busy = false;
    this.placingItem = undefined; this.lastHintKey = '';
  }

  create() {
    this.zone = ZONES[S.zone] ?? ZONES.farm;
    const zw = this.zone.w * T, zh = this.zone.h * T;
    this.cameras.main.setBounds(0, 0, zw, zh);
    this.physics.world.setBounds(0, 0, zw, zh);

    this.drawGround();
    if (this.zone.id === 'house') this.drawHouse();
    this.drawZoneDecor();
    this.drawPortals();
    this.spawnNpcs();
    if (this.zone.features.includes('farm')) this.buildFarm();
    if (this.zone.features.includes('barn')) this.buildBarn();
    if (this.zone.features.includes('insects')) this.spawnInsects();

    // người chơi
    this.player = new CharacterSprite(this, this.zone.spawn.x * T, this.zone.spawn.y * T, S.player.appearance);
    this.player.setDepth(1000);
    this.selector = this.add.image(0, 0, 'sel').setVisible(false).setDepth(900).setAlpha(0.9);

    this.cameras.main.startFollow(this.player, true, 0.12, 0.12);
    // trong nhà: phóng to để căn phòng lấp đầy màn hình
    const bw = this.physics.world.bounds;
    const fitZoom = Math.max(this.scale.width / bw.width, this.scale.height / bw.height);
    this.cameras.main.setZoom(Math.max(2.4, fitZoom));

    // lớp đêm + mưa
    this.darkOverlay = this.add.rectangle(0, 0, zw, zh, 0x0b1030).setOrigin(0).setDepth(5000).setAlpha(0);
    this.setupWeather();

    this.cursors = this.input.keyboard!.createCursorKeys();
    this.wasd = this.input.keyboard!.addKeys('W,A,S,D,E,SPACE') as Record<string, Phaser.Input.Keyboard.Key>;

    // chạm vào thế giới: đi tới / tương tác côn trùng / đặt đồ
    this.input.on('pointerdown', (p: Phaser.Input.Pointer) => this.onTap(p));

    bus.emit(EV.ZONE, this.zone);
    bus.on(EV.APPEARANCE, this.onAppearance, this);
    bus.on(EV.HOUSE, this.onHouseChanged, this);
    bus.on('world:place', this.startPlacing, this);
    bus.on('world:emote', this.onEmote, this);
    this.events.on('shutdown', () => {
      bus.off(EV.APPEARANCE, this.onAppearance, this);
      bus.off(EV.HOUSE, this.onHouseChanged, this);
      bus.off('world:place', this.startPlacing, this);
      bus.off('world:emote', this.onEmote, this);
    });

    initTimeOnce();
  }

  private onAppearance() { this.player.setAppearance(S.player.appearance); }
  private onEmote(i: number) { this.player.showEmote(i); }
  private onHouseChanged() { if (this.zone.id === 'house') this.scene.restart(); }

  // ================= vẽ nền =================
  private drawGround() {
    const { w, h, ground } = this.zone;
    this.add.tileSprite(0, 0, w * T, h * T, `g_${ground}`).setOrigin(0).setDepth(-100);

    if (this.zone.indoor && this.zone.id !== 'house') {
      // viền tường cho khu trong nhà
      this.add.rectangle(0, 0, w * T, 2 * T, 0x6b4a2e).setOrigin(0).setDepth(-90);
    }

    // mảng cỏ đậm ngẫu nhiên cho tự nhiên
    if (!this.zone.indoor) {
      let seed = this.zone.id.length * 31 + 7;
      const rnd = () => (seed = (seed * 9301 + 49297) % 233280) / 233280;
      for (let i = 0; i < (w * h) / 30; i++) {
        const x = Math.floor(rnd() * w), y = Math.floor(rnd() * h);
        this.add.image(x * T, y * T, this.zone.ground === 'grass' ? 'g_grass_dark' : `g_${this.zone.ground}`)
          .setOrigin(0).setDepth(-99).setAlpha(0.5).setScale(0.5);
      }
      // cây từ tileset (spring trees ở khoảng x0..128,y384..448 trong tiles.png)
      if (this.zone.features.includes('trees')) {
        for (let i = 0; i < 10; i++) {
          const x = Math.floor(rnd() * (w - 6)) + 3, y = Math.floor(rnd() * (h - 8)) + 3;
          if (this.zone.features.includes('farm') && x > FARM_ORIGIN.x - 2 && x < FARM_ORIGIN.x + 18 && y > FARM_ORIGIN.y - 2 && y < FARM_ORIGIN.y + 14) continue;
          if (this.zone.features.includes('barn') && x > BARN_RECT.x - 2 && x < BARN_RECT.x + BARN_RECT.w + 2 && y > BARN_RECT.y - 2 && y < BARN_RECT.y + BARN_RECT.h + 2) continue;
          const kind = Math.floor(rnd() * 3);
          this.add.image(x * T, y * T, ['deco_tree_round', 'deco_tree_round2', 'deco_tree_pine'][kind])
            .setOrigin(0.5, 0.9).setScale(1.4).setDepth(y * T);
        }
      }
      if (this.zone.features.includes('flowers')) {
        for (let i = 0; i < 14; i++) {
          const x = rnd() * w * T, y = rnd() * h * T;
          const c = [0xffd43b, 0xff8787, 0xdabfff, 0xffffff][Math.floor(rnd() * 4)];
          this.add.circle(x, y, 2.2, c).setDepth(-50);
        }
      }
    }

    // nước cho khu câu cá
    if (this.zone.features.includes('fishing')) {
      if (this.zone.id === 'beach') {
        const wx = (this.zone.w - 12) * T;
        this.add.tileSprite(wx, 0, 12 * T, this.zone.h * T, 'g_water').setOrigin(0).setDepth(-80);
        this.waterRect = new Phaser.Geom.Rectangle(wx, 0, 12 * T, this.zone.h * T);
      } else {
        const cx = this.zone.w * T / 2, cy = this.zone.h * T / 2 + 2 * T;
        this.pondEllipse = new Phaser.Geom.Ellipse(cx, cy, 20 * T, 12 * T);
        const g = this.add.graphics().setDepth(-80);
        g.fillStyle(0x4aa5d9); g.fillEllipse(cx, cy, 20 * T, 12 * T);
        g.fillStyle(0x62b7e6, 0.6); g.fillEllipse(cx, cy - 4, 18 * T, 10 * T);
      }
    }
  }

  // Đặt nhà cửa/đèn/ghế... theo cấu hình ZONE_DECOR
  private drawZoneDecor() {
    for (const d of ZONE_DECOR[this.zone.id] ?? []) {
      if (!this.textures.exists(d.key)) continue;
      this.add.image(d.x * T, d.y * T, d.key)
        .setOrigin(0.5, 1)
        .setScale(d.s ?? (d.key.startsWith('bld_') ? 1.1 : 1.2))
        .setDepth(d.y * T);
    }
  }

  private inWater(x: number, y: number): boolean {
    if (this.waterRect?.contains(x, y)) return true;
    if (this.pondEllipse && Phaser.Geom.Ellipse.Contains(this.pondEllipse, x, y)) return true;
    return false;
  }

  // ================= nhà riêng =================
  private drawHouse() {
    const size = houseSize();
    // ghi đè kích thước zone theo cấp nhà
    const wall = WALLPAPERS[S.house.wallpaper % WALLPAPERS.length];
    const floor = FLOORS[S.house.floor % FLOORS.length];
    this.add.rectangle(0, 0, size * T, size * T, floor).setOrigin(0).setDepth(-95);
    this.add.rectangle(0, 0, size * T, 2 * T, wall).setOrigin(0).setDepth(-90);
    this.add.rectangle(0, 0, size * T, 4, 0x00000030).setOrigin(0).setDepth(-89);
    this.cameras.main.setBounds(0, 0, size * T, size * T);
    this.physics.world.setBounds(0, 0, size * T, size * T);

    for (const f of S.house.furniture) this.drawFurniture(f.id, f.itemId, f.x, f.y);

    // khách dự tiệc
    if (partyActive()) {
      for (let i = 0; i < 3; i++) {
        const guest = new CharacterSprite(this, (3 + i * 3) * T, 5 * T, {
          charIndex: (i * 2 + 1) % 8, hairStyle: ['braids', 'curly', 'ponytail'][i], hairColor: i * 3,
          eyesColor: i, clothes: ['dress', 'suit', 'floral'][i], clothesColor: i * 2, acc: []
        });
        guest.setDepth(500);
        guest.play('walk');
        this.partyGuests.push(guest);
        this.tweens.add({
          targets: guest, x: `+=${20 + i * 10}`, duration: 900 + i * 200, yoyo: true, repeat: -1,
          onYoyo: () => guest.setDir(2), onRepeat: () => guest.setDir(3)
        });
      }
      this.add.text(size * T / 2, T, '🎉 TIỆC TÙNG 🎉', { fontSize: '10px', color: '#fff' }).setOrigin(0.5).setDepth(600);
    }
  }

  private drawFurniture(placedId: string, itemId: string, tx: number, ty: number) {
    const def = FURNITURE[itemId];
    if (!def) return;
    const c = this.add.container(tx * T, ty * T).setDepth(ty * T + def.h * T);
    if (this.textures.exists(`fs_${itemId}`)) {
      // sprite thật từ Interior pack, co vừa khung w x h tile
      const img = this.add.image(def.w * T / 2, def.h * T, `fs_${itemId}`).setOrigin(0.5, 1);
      const tex = this.textures.get(`fs_${itemId}`).getSourceImage() as HTMLImageElement;
      const k = Math.min(def.w * T / tex.width, (def.h * T + 8) / tex.height);
      img.setScale(k);
      c.add(img);
    } else {
      const rect = this.add.rectangle(0, 0, def.w * T - 2, def.h * T - 2, def.color).setOrigin(0).setStrokeStyle(1, 0x00000060);
      const label = this.add.text(def.w * T / 2, def.h * T / 2, def.icon, { fontSize: '12px' }).setOrigin(0.5);
      c.add([rect, label]);
    }
    if (def.category === 'painting') c.setY(0.5 * T).setDepth(10);
    if (def.category === 'aquarium') {
      // cá bơi trong hồ
      const n = Math.min(S.house.aquarium.length, 5);
      for (let i = 0; i < n; i++) {
        const fishDot = this.add.text(4 + i * 9, 4, '🐟', { fontSize: '7px' });
        c.add(fishDot);
        this.tweens.add({ targets: fishDot, x: `+=${6}`, duration: 700 + i * 150, yoyo: true, repeat: -1 });
      }
    }
    c.setData('placedId', placedId);
    c.setSize(def.w * T, def.h * T);
    this.furnitureObjs.push(c);
  }

  // ================= cổng khu vực =================
  private drawPortals() {
    for (const p of this.zone.portals) {
      const px = p.x * T, py = p.y * T;
      this.add.circle(px, py, 10, 0xffe066, 0.35).setDepth(1);
      this.add.text(px, py - 14, `${p.icon}`, { fontSize: '12px' }).setOrigin(0.5).setDepth(2);
      this.add.text(px, py + 12, p.label, { fontSize: '7px', color: '#fff', backgroundColor: '#00000090', padding: { x: 3, y: 1 } }).setOrigin(0.5).setDepth(2);
    }
  }

  // ================= NPC =================
  private spawnNpcs() {
    for (const def of this.zone.npcs) {
      const sprite = new CharacterSprite(this, def.x * T, def.y * T, {
        charIndex: def.charIndex, hairStyle: ['bob', 'gentleman', 'curly', 'braids', 'buzzcut', 'ponytail', 'wavy', 'spacebuns'][def.charIndex],
        hairColor: (def.charIndex * 2) % 14, eyesColor: def.charIndex % 10,
        clothes: ['basic', 'suit', 'overalls', 'stripe', 'dress', 'floral', 'sailor', 'sporty'][def.charIndex],
        clothesColor: def.charIndex % 10, acc: []
      });
      sprite.setDepth(def.y * T);
      this.add.text(def.x * T, def.y * T - 26, def.name, { fontSize: '7px', color: '#ffe066', backgroundColor: '#00000090', padding: { x: 3, y: 1 } }).setOrigin(0.5).setDepth(2000);
      this.npcs.push({ def, sprite });
    }
  }

  // ================= ruộng =================
  private buildFarm() {
    farming.ensurePlots();
    const { x: ox, y: oy } = FARM_ORIGIN;
    for (let i = 0; i < farming.MAX_PLOTS; i++) {
      const col = i % farming.FARM_COLS, row = Math.floor(i / farming.FARM_COLS);
      const x = (ox + col * 2) * T, y = (oy + row * 2) * T;
      const img = this.add.image(x, y, 'g_soil').setOrigin(0).setDepth(-60).setDisplaySize(T * 1.8, T * 1.8);
      this.plotTiles.push(img);
      const overlay = this.add.image(x + T * 0.9, y + T * 0.4, 'sel').setVisible(false).setDepth(-30).setScale(0.5);
      this.plotOverlays.push(overlay);
      this.cropSprites.push(undefined);
    }
    this.refreshFarm();
    // đồng hồ cập nhật cây lớn
    this.time.addEvent({ delay: 2000, loop: true, callback: () => this.refreshFarm() });
  }

  private refreshFarm() {
    for (let i = 0; i < farming.MAX_PLOTS; i++) {
      const p = S.farm.plots[i];
      const img = this.plotTiles[i];
      if (!p || !img) continue;
      if (p.state === 'locked') { img.setTexture('g_grass_dark').setAlpha(0.3); }
      else if (p.state === 'empty') { img.setTexture('g_soil').setAlpha(0.55); }
      else img.setTexture(p.watered ? 'g_soil_wet' : 'g_soil').setAlpha(1);

      const crop = p?.crop ? CROPS[p.crop] : undefined;
      let spr = this.cropSprites[i];
      if (p?.state === 'planted' && crop) {
        const stage = farming.stageOf(p);
        const frame = crop.row * 25 + 1 + stage; // crops_all: 25 cột, cột 0 là icon
        if (!spr) {
          spr = this.add.sprite(img.x + T * 0.9, img.y + T * 0.7, 'crops', frame);
          spr.setDepth(img.y + T);
          this.cropSprites[i] = spr;
        } else spr.setFrame(frame);
        spr.setVisible(true);
        // cây chín thì nhún nhảy
        if (farming.isRipe(p) && !spr.getData('bounce')) {
          spr.setData('bounce', true);
          this.tweens.add({ targets: spr, y: spr.y - 2, duration: 400, yoyo: true, repeat: -1 });
        }
        if (!farming.isRipe(p) && spr.getData('bounce')) {
          spr.setData('bounce', false);
          this.tweens.killTweensOf(spr);
          spr.setY(img.y + T * 0.7);
        }
      } else if (spr) {
        this.tweens.killTweensOf(spr);
        spr.destroy();
        this.cropSprites[i] = undefined;
      }
    }
  }

  // ================= chuồng =================
  private buildBarn() {
    const { x, y, w, h } = BARN_RECT;
    // hàng rào
    const g = this.add.graphics().setDepth(-70);
    g.lineStyle(2, 0x8d5a3a);
    g.strokeRect(x * T, y * T, w * T, h * T);
    g.fillStyle(0xc9a26b, 0.25); g.fillRect(x * T, y * T, w * T, h * T);
    // nhà chuồng
    const bx = (x + w / 2) * T, by = y * T - 4;
    this.add.rectangle(bx, by, 40, 22, 0xa9714b).setDepth(by).setStrokeStyle(2, 0x6b4a2e);
    const lvl = S.livestock.barnLevel;
    this.add.text(bx, by, lvl === 0 ? '🏚️ Xây chuồng' : `🏚️ Chuồng cấp ${lvl}`, { fontSize: '7px', color: '#fff' }).setOrigin(0.5).setDepth(by + 1);

    for (const a of S.livestock.animals) this.spawnAnimal(a.id, a.type);
    this.time.addEvent({ delay: 1500, loop: true, callback: () => this.wanderAnimals() });
  }

  private spawnAnimal(id: string, type: string) {
    const def = ANIMALS[type];
    if (!def) return;
    const { x, y, w, h } = BARN_RECT;
    const ax = (x + 1 + Math.random() * (w - 2)) * T;
    const ay = (y + 1 + Math.random() * (h - 2)) * T;
    const spr = this.add.sprite(ax, ay, `animal_${type}`, 0).setDepth(ay);
    spr.setInteractive({ useHandCursor: true });
    spr.on('pointerdown', () => this.animalDialog(id));
    this.animalSprites.set(id, spr);
  }

  private wanderAnimals() {
    const { x, y, w, h } = BARN_RECT;
    for (const [id, spr] of this.animalSprites) {
      if (Math.random() < 0.5) continue;
      const nx = Phaser.Math.Clamp(spr.x + (Math.random() * 40 - 20), (x + 1) * T, (x + w - 1) * T);
      const ny = Phaser.Math.Clamp(spr.y + (Math.random() * 30 - 15), (y + 1) * T, (y + h - 1) * T);
      this.tweens.add({ targets: spr, x: nx, y: ny, duration: 1200, onUpdate: () => spr.setDepth(spr.y) });
      const a = S.livestock.animals.find(v => v.id === id);
      if (a && livestock.hasProduct(a) && !spr.getData('mark')) {
        spr.setData('mark', true);
        const m = this.add.text(spr.x, spr.y - 14, '❗', { fontSize: '10px' }).setOrigin(0.5).setDepth(3000);
        spr.setData('markObj', m);
      }
      const m = spr.getData('markObj') as Phaser.GameObjects.Text | undefined;
      if (m) {
        m.setPosition(spr.x, spr.y - 14);
        if (a && !livestock.hasProduct(a)) { m.destroy(); spr.setData('mark', false); spr.setData('markObj', undefined); }
      }
    }
  }

  private animalDialog(id: string) {
    const a = S.livestock.animals.find(v => v.id === id);
    if (!a) return;
    const def = ANIMALS[a.type];
    const acts: { icon: string; label: string; cb: () => void }[] = [];
    if (livestock.isHungry(a)) acts.push({ icon: '🌾', label: 'Cho ăn', cb: () => { livestock.feed(a); } });
    if (livestock.hasProduct(a)) acts.push({ icon: '🧺', label: `Thu ${'' + def.name}`, cb: () => { livestock.collect(a); toast(`Thu được sản phẩm từ ${def.name}!`, def.icon); } });
    acts.push({ icon: '🪙', label: 'Bán (50%)', cb: () => { livestock.sellAnimal(id); this.animalSprites.get(id)?.destroy(); this.animalSprites.delete(id); } });
    bus.emit(EV.OPEN_PANEL, {
      panel: 'dialog',
      data: {
        title: `${def.icon} ${a.name}`,
        text: livestock.isHungry(a) ? 'Bé đang đói meo...' : livestock.hasProduct(a) ? 'Có sản phẩm rồi nè!' : 'Bé đang no và vui vẻ ~',
        actions: acts
      }
    });
  }

  // ================= côn trùng =================
  private spawnInsects() {
    const pool = Object.values(INSECTS).filter(i => i.zones.includes(this.zone.id));
    if (!pool.length) return;
    this.time.addEvent({
      delay: 4000, loop: true, callback: () => {
        if (this.insects.length >= 5) return;
        const def = fishing.rollInsect(this.zone.id);
        if (!def) return;
        const x = Math.random() * this.zone.w * T, y = Math.random() * this.zone.h * T;
        if (this.inWater(x, y)) return;
        const obj = this.add.image(x, y, def.kind === 'butterfly' ? 'butterfly' : 'bug')
          .setTint(def.color).setDepth(2500).setScale(0.8);
        obj.setInteractive({ useHandCursor: true });
        const ins: InsectSprite = { def, obj, vx: Math.random() * 30 - 15, vy: Math.random() * 30 - 15, t: 0 };
        obj.on('pointerdown', () => this.tryCatchInsect(ins));
        this.insects.push(ins);
        // tự bay đi sau 25s
        this.time.delayedCall(25_000, () => this.removeInsect(ins));
      }
    });
  }

  private removeInsect(ins: InsectSprite) {
    ins.obj.destroy();
    this.insects = this.insects.filter(i => i !== ins);
  }

  private tryCatchInsect(ins: InsectSprite) {
    const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, ins.obj.x, ins.obj.y);
    if (d > 48) { toast('Lại gần hơn chút nữa!', '🥅'); return; }
    if (this.busy) return;
    this.busy = true;
    // quay mặt về phía côn trùng
    const ang = Math.atan2(ins.obj.y - this.player.y, ins.obj.x - this.player.x);
    const adir: Dir = Math.abs(Math.cos(ang)) > Math.abs(Math.sin(ang)) ? (Math.cos(ang) > 0 ? 3 : 2) : (Math.sin(ang) > 0 ? 0 : 1);
    this.player.setDir(adir);
    this.player.play('pickup', () => {
      this.busy = false;
      const ok = fishing.catchInsect(ins.def);
      if (ok !== undefined) this.removeInsect(ins);
    });
  }

  // ================= câu cá =================
  private startFishing() {
    if (S.tools.rod <= 0) { toast('Bạn chưa có cần câu — mua ở tiệm câu Bãi biển.', '🎣'); sfx.error(); return; }
    if (this.fishingState !== 'idle') return;
    this.fishingState = 'waiting';
    this.busy = true;
    this.player.play('fishing');
    // vị trí phao: hướng mặt người chơi ra nước
    const off = [{ x: 0, y: 28 }, { x: 0, y: -28 }, { x: -28, y: 0 }, { x: 28, y: 0 }][this.player.dir];
    this.bobber = this.add.image(this.player.x + off.x, this.player.y + off.y, 'bobber').setDepth(3000);
    this.tweens.add({ targets: this.bobber, y: '+=2', duration: 500, yoyo: true, repeat: -1 });
    sfx.splash();
    const wait = 1500 + Math.random() * 3500;
    this.biteTimer = this.time.delayedCall(wait, () => {
      this.fishingState = 'bite';
      this.bobber?.setTint(0xff0000);
      this.tweens.add({ targets: this.bobber, scale: 1.6, duration: 120, yoyo: true, repeat: 3 });
      toast('Cá cắn câu! Bấm ngay!', '❗');
      sfx.click();
      this.time.delayedCall(900, () => {
        if (this.fishingState === 'bite') {
          toast('Cá chạy mất rồi...', '💨');
          this.stopFishing();
        }
      });
    });
  }

  private reelFish() {
    if (this.fishingState === 'waiting') {
      toast('Chưa có cá cắn — kiên nhẫn nào.', '🎣');
      this.stopFishing();
      return;
    }
    if (this.fishingState !== 'bite') return;
    this.fishingState = 'reeling';
    const f = fishing.rollFish(this.zone.id);
    if (f) {
      fishing.landFish(f);
      toast(`Câu được ${f.name}!`, '🐟');
    }
    this.stopFishing();
  }

  private stopFishing() {
    this.fishingState = 'idle';
    this.busy = false;
    this.biteTimer?.remove();
    if (this.bobber) { this.tweens.killTweensOf(this.bobber); this.bobber.destroy(); this.bobber = undefined; }
    this.player.play('idle');
  }

  // ================= đặt nội thất =================
  private startPlacing(itemId: string) {
    if (this.zone.id !== 'house') { toast('Về nhà để đặt nội thất nhé.', '🏠'); return; }
    const def = FURNITURE[itemId];
    if (!def) return;
    this.placingItem = itemId;
    this.placeGhost?.destroy();
    const c = this.add.container(0, 0).setDepth(6000).setAlpha(0.7);
    if (this.textures.exists(`fs_${itemId}`)) {
      const img = this.add.image(def.w * T / 2, def.h * T, `fs_${itemId}`).setOrigin(0.5, 1);
      const tex = this.textures.get(`fs_${itemId}`).getSourceImage() as HTMLImageElement;
      img.setScale(Math.min(def.w * T / tex.width, (def.h * T + 8) / tex.height));
      c.add(img);
    } else {
      c.add(this.add.rectangle(0, 0, def.w * T - 2, def.h * T - 2, def.color).setOrigin(0));
      c.add(this.add.text(def.w * T / 2, def.h * T / 2, def.icon, { fontSize: '12px' }).setOrigin(0.5));
    }
    this.placeGhost = c;
    toast('Chạm vào sàn để đặt. Chạm 2 lần nhanh để hủy.', '📦');
  }

  // ================= tap =================
  private tapTimer = 0;
  private onTap(p: Phaser.Input.Pointer) {
    const wp = this.cameras.main.getWorldPoint(p.x, p.y);
    // chế độ đặt đồ
    if (this.placingItem) {
      const now = Date.now();
      if (now - this.tapTimer < 300) { // double tap hủy
        this.placingItem = undefined; this.placeGhost?.destroy(); this.placeGhost = undefined;
        return;
      }
      this.tapTimer = now;
      const tx = Math.floor(wp.x / T), ty = Math.floor(wp.y / T);
      import('@/systems/housing').then(h => {
        if (h.placeFurniture(this.placingItem!, tx, ty)) {
          this.placingItem = undefined; this.placeGhost?.destroy(); this.placeGhost = undefined;
        }
      });
      return;
    }
    // gõ vào nội thất đã đặt -> thu dọn
    if (this.zone.id === 'house') {
      for (const c of this.furnitureObjs) {
        const b = c.getBounds();
        if (b.contains(wp.x, wp.y)) {
          const placedId = c.getData('placedId') as string;
          bus.emit(EV.OPEN_PANEL, {
            panel: 'dialog',
            data: {
              title: '📦 Nội thất', text: 'Bạn muốn làm gì?',
              actions: [{ icon: '🧺', label: 'Thu dọn về kho', cb: () => import('@/systems/housing').then(h => h.pickupFurniture(placedId)) }]
            }
          });
          return;
        }
      }
    }
  }

  // ================= hành động theo ngữ cảnh =================
  private nearestPlot(): number {
    if (!this.zone.features.includes('farm')) return -1;
    const { x: ox, y: oy } = FARM_ORIGIN;
    let best = -1, bd = 26;
    for (let i = 0; i < farming.MAX_PLOTS; i++) {
      const col = i % farming.FARM_COLS, row = Math.floor(i / farming.FARM_COLS);
      const cx = (ox + col * 2) * T + T * 0.9, cy = (oy + row * 2) * T + T * 0.9;
      const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, cx, cy);
      if (d < bd) { bd = d; best = i; }
    }
    return best;
  }

  private nearWater(): boolean {
    if (!this.zone.features.includes('fishing')) return false;
    for (const off of [[0, 30], [0, -30], [-30, 0], [30, 0]]) {
      if (this.inWater(this.player.x + off[0], this.player.y + off[1])) return true;
    }
    return false;
  }

  private contextActions(): WorldAction[] {
    const acts: WorldAction[] = [];
    if (this.busy) return acts;

    // NPC gần
    for (const { def, sprite } of this.npcs) {
      if (Phaser.Math.Distance.Between(this.player.x, this.player.y, sprite.x, sprite.y) < 34) {
        acts.push({ icon: '💬', label: `Nói chuyện: ${def.name}`, cb: () => this.talkNpc(def) });
      }
    }
    // cổng
    for (const p of this.zone.portals) {
      if (Phaser.Math.Distance.Between(this.player.x, this.player.y, p.x * T, p.y * T) < 26) {
        acts.push({ icon: p.icon, label: `Đi tới ${p.label}`, cb: () => this.travel(p.to) });
      }
    }
    // ruộng
    const pi = this.nearestPlot();
    if (pi >= 0) {
      const p = S.farm.plots[pi];
      this.selector.setVisible(true).setPosition(this.plotTiles[pi].x + T * 0.9, this.plotTiles[pi].y + T * 0.9).setScale(0.95);
      if (p.state === 'locked') acts.push({
        icon: '🪙', label: `Mua ô đất (${farming.plotPrice()} xu)`,
        cb: () => bus.emit(EV.OPEN_PANEL, {
          panel: 'dialog',
          data: {
            title: '🟫 Mua đất', text: `Mở thêm 1 ô đất với giá ${farming.plotPrice()} xu?`,
            actions: [{ icon: '🪙', label: 'Mua', cb: () => { farming.buyPlot(); this.refreshFarm(); } }]
          }
        })
      });
      if (p.state === 'empty') acts.push({ icon: '⛏️', label: 'Cuốc đất', cb: () => this.doTill(pi) });
      if (p.state === 'tilled') acts.push({ icon: '🌱', label: 'Trồng cây', cb: () => bus.emit(EV.OPEN_PANEL, { panel: 'seedpicker', data: { plot: pi } }) });
      if (p.state === 'planted') {
        if (farming.isRipe(p)) acts.push({ icon: '🧺', label: 'Thu hoạch', cb: () => this.doHarvest(pi) });
        else {
          if (!p.watered) acts.push({ icon: '💧', label: 'Tưới nước', cb: () => this.doWater(pi) });
          if (!p.fertilized) acts.push({ icon: '💩', label: 'Bón phân', cb: () => farming.fertilize(pi) });
        }
      }
    } else this.selector.setVisible(false);

    // chuồng
    if (this.zone.features.includes('barn')) {
      const bx = (BARN_RECT.x + BARN_RECT.w / 2) * T, by = BARN_RECT.y * T;
      if (Phaser.Math.Distance.Between(this.player.x, this.player.y, bx, by) < 40) {
        if (S.livestock.barnLevel === 0) acts.push({ icon: '🏚️', label: 'Xây chuồng (500 xu)', cb: () => { livestock.upgradeBarn(); this.scene.restart(); } });
        else {
          acts.push({ icon: '🐔', label: 'Mua vật nuôi', cb: () => bus.emit(EV.OPEN_PANEL, { panel: 'animalshop' }) });
          if (S.livestock.barnLevel < 3) acts.push({ icon: '⬆️', label: 'Nâng chuồng', cb: () => { livestock.upgradeBarn(); this.scene.restart(); } });
        }
      }
    }

    // câu cá
    if (this.nearWater()) {
      if (this.fishingState === 'idle') acts.push({ icon: '🎣', label: 'Câu cá', cb: () => this.startFishing() });
      else acts.push({ icon: '❗', label: 'Kéo cần!', cb: () => this.reelFish() });
    }
    return acts;
  }

  private talkNpc(def: NpcDef) {
    const acts: WorldAction[] = [];
    if (def.shop) acts.push({ icon: '🛒', label: 'Xem hàng', cb: () => bus.emit(EV.OPEN_PANEL, { panel: 'shop', data: { shopId: def.shop } }) });
    if (def.minigame) acts.push({ icon: '🎮', label: 'Chơi mini game', cb: () => bus.emit(EV.OPEN_PANEL, { panel: def.minigame }) });
    bus.emit(EV.OPEN_PANEL, {
      panel: 'dialog',
      data: {
        title: `💬 ${def.name}`,
        text: def.lines[Math.floor(Math.random() * def.lines.length)],
        actions: acts
      }
    });
  }

  private doTill(i: number) {
    this.busy = true;
    this.player.play('hoe', () => { this.busy = false; farming.till(i); this.refreshFarm(); });
  }
  private doWater(i: number) {
    this.busy = true;
    this.player.play('water', () => { this.busy = false; farming.water(i); this.refreshFarm(); });
  }
  private doHarvest(i: number) {
    this.busy = true;
    this.player.play('pickup', () => { this.busy = false; farming.harvest(i); this.refreshFarm(); });
  }

  travel(zoneId: string) {
    if (zoneId === 'house' && !S.house.owned) {
      bus.emit(EV.OPEN_PANEL, {
        panel: 'dialog',
        data: {
          title: '🏠 Nhà riêng', text: 'Bạn chưa có nhà. Mua nhà gỗ nhỏ với 2000 xu?',
          actions: [{ icon: '🪙', label: 'Mua nhà (2000 xu)', cb: () => import('@/systems/housing').then(h => { if (h.buyHouse()) this.travel('house'); }) }]
        }
      });
      return;
    }
    S.zone = zoneId;
    save(true);
    this.stopFishing();
    this.cameras.main.fadeOut(200, 0, 0, 0);
    this.time.delayedCall(220, () => this.scene.restart());
  }

  // ================= thời tiết / đêm =================
  private setupWeather() {
    this.time.addEvent({ delay: 3000, loop: true, callback: () => this.applyWeather() });
    this.applyWeather();
  }

  private applyWeather() {
    this.darkOverlay.setAlpha(this.zone.indoor ? 0 : darkness() * 0.55);
    const raining = currentWeather() === 'rain' && !this.zone.indoor;
    if (raining && !this.rain) {
      this.rain = this.add.particles(0, 0, 'raindrop', {
        x: { min: 0, max: this.zone.w * T }, y: -10,
        lifespan: 1200, speedY: { min: 160, max: 220 }, speedX: -20,
        quantity: 2, alpha: 0.6
      }).setDepth(5500);
    } else if (!raining && this.rain) {
      this.rain.destroy(); this.rain = undefined;
    }
  }

  // ================= update =================
  update(_t: number, dt: number) {
    if (!this.player) return;
    const spd = 90 * (dt / 1000);
    let dx = 0, dy = 0;
    if (this.cursors.left.isDown || this.wasd.A.isDown) dx -= 1;
    if (this.cursors.right.isDown || this.wasd.D.isDown) dx += 1;
    if (this.cursors.up.isDown || this.wasd.W.isDown) dy -= 1;
    if (this.cursors.down.isDown || this.wasd.S.isDown) dy += 1;
    dx += virtualInput.x; dy += virtualInput.y;
    const len = Math.hypot(dx, dy);
    if (len > 0.2 && !this.busy) {
      dx /= Math.max(1, len); dy /= Math.max(1, len);
      let nx = this.player.x + dx * spd, ny = this.player.y + dy * spd;
      const bw = this.physics.world.bounds;
      nx = Phaser.Math.Clamp(nx, bw.x + 8, bw.right - 8);
      ny = Phaser.Math.Clamp(ny, bw.y + 8, bw.bottom - 8);
      if (!this.inWater(nx, ny)) { this.player.x = nx; this.player.y = ny; }
      else if (!this.inWater(nx, this.player.y)) this.player.x = nx;
      else if (!this.inWater(this.player.x, ny)) this.player.y = ny;
      const dir: Dir = Math.abs(dx) > Math.abs(dy) ? (dx > 0 ? 3 : 2) : (dy > 0 ? 0 : 1);
      this.player.setDir(dir);
      this.player.play('walk');
      this.player.setDepth(this.player.y);
    } else if (!this.busy && this.player.current === 'walk') {
      this.player.play('idle');
    }
    this.player.tick(dt);
    for (const { sprite } of this.npcs) sprite.tick(dt);
    for (const g of this.partyGuests) g.tick(dt);

    // côn trùng bay
    for (const ins of this.insects) {
      ins.t += dt / 1000;
      ins.obj.x += ins.vx * dt / 1000;
      ins.obj.y += ins.vy * dt / 1000 + Math.sin(ins.t * 6) * 0.4;
      if (Math.random() < 0.01) { ins.vx = Math.random() * 30 - 15; ins.vy = Math.random() * 30 - 15; }
      ins.obj.x = Phaser.Math.Clamp(ins.obj.x, 0, this.zone.w * T);
      ins.obj.y = Phaser.Math.Clamp(ins.obj.y, 0, this.zone.h * T);
    }

    // ghost đặt đồ theo con trỏ
    if (this.placeGhost) {
      const p = this.input.activePointer;
      const wp = this.cameras.main.getWorldPoint(p.x, p.y);
      this.placeGhost.setPosition(Math.floor(wp.x / T) * T, Math.floor(wp.y / T) * T);
    }

    // gợi ý hành động cho HUD
    const acts = this.contextActions();
    const key = acts.map(a => a.label).join('|');
    if (key !== this.lastHintKey) {
      this.lastHintKey = key;
      bus.emit(EV.ACTION_HINT, acts);
    }
    // nút hành động (A): chạy hành động đầu tiên
    if (consumeAction() && acts.length) acts[0].cb();
  }
}

let timeInit = false;
function initTimeOnce() {
  if (!timeInit) { timeInit = true; initTime(); }
}
