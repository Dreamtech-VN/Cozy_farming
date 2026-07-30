import Phaser from 'phaser';
import { S, save } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { ZONES, type ZoneDef, type NpcDef } from '@/data/zones';
import { CROPS, CROP_LIST } from '@/data/crops';
import { PETS } from '@/data/pets';
import { roamersIn } from '@/systems/social';
import type { Friend } from '@/core/types';
import { ANIMALS } from '@/data/animals';
import { FURNITURE, WALLPAPERS, FLOORS } from '@/data/furniture';
import { ChibiSprite } from '@/gfx/ChibiSprite';
import { defaultLook, starterList, EYES_ID } from '@/data/chibi';
type Dir = 0 | 1 | 2 | 3;
import { virtualInput, consumeAction } from '@/core/input';
import { RES } from '@/core/res';
import * as farming from '@/systems/farming';
import * as livestock from '@/systems/livestock';
import * as fishing from '@/systems/fishing';
import { houseSize, partyActive } from '@/systems/housing';
import { darkness, currentWeather, initTime } from '@/systems/time';
import { INSECTS, type InsectDef } from '@/data/insects';
import { sfx } from '@/core/audio';

const T = 16; // kích thước tile
// ---- Nông trại HD (nền imagemap Avatar 1008x506) — tọa độ px ----
const FARM_PLOT = { ox: 84, oy: 218, pw: 42, ph: 45 };            // lưới ruộng 8x6
const FARM_POND = { x: 850, y: 392, w: 274, h: 216 };             // hồ đá Avatar
const KHE_POS = { x: 790, y: 195 };                               // cây khế
const WAREHOUSE_POS = { x: 320, y: 175 };                         // nhà kho
const PETHOUSE_POS = { x: 648, y: 198 };                          // nhà thú cưng (chỉ hiện khi đã nuôi)
const PETSHOP_POS = { x: 21 * T, y: 13 * T };                     // tiệm thú cưng (Thành phố)
const BARN_RECT = { x: 26.5, y: 13.5, w: 9, h: 5.5 };             // sân chuồng thú (tile)
const FARM_ORIGIN = { x: Math.round(FARM_PLOT.ox / T), y: Math.round(FARM_PLOT.oy / T) };
const ROAD_TILES = 4; // đường xe chạy chiếm 4 hàng tile dưới cùng (map cổng)

// đang có chuyến xe tới khu mới (giữ qua lần restart scene)
let busArrival = false;
// vừa fade về map cổng để bắt xe đi tiếp tới zone này
let pendingDepart: string | undefined;

const TRAFFIC_KEYS = ['veh_bus', 'veh_truck_orange', 'veh_camper_pink', 'veh_camper_yellow', 'veh_truck_bee', 'veh_truck_gift'];

// Decor đặt sẵn theo khu (sprite thật từ asset pack) — toạ độ tile, origin đáy giữa
const ZONE_DECOR: Record<string, { key: string; x: number; y: number; s?: number }[]> = {
  farm: [
    // nông trại chỉ gồm: nhà bếp, nhà kho, chuồng thú, nhà chó (+ cây khế, ao cá)
    { key: 'lt_kitchen', x: 8.75, y: 12.6, s: 1 },     // nhà bếp (cửa vào nhà riêng)
    { key: 'lt_warehouse', x: 20, y: 12.7, s: 1 },     // nhà kho — mở kho đồ
    { key: 'lt_barn', x: 31, y: 13.2, s: 1 },          // chuồng gia súc
    { key: 'lt_tree', x: 49.4, y: 12.4, s: 1 },        // cây khế
    { key: 'lt_tree', x: 58.6, y: 14.8, s: 0.8 }
  ],
  beach: [
    { key: 'bld_fishshop', x: 10, y: 7 },    // tiệm câu ông Biển
    { key: 'bld_beachbar', x: 22, y: 12 },
    { key: 'deco_barrel', x: 15, y: 8 }, { key: 'deco_bench', x: 18, y: 16 }
  ],
  // decor Avatar trên map nền HD (scale 1 = đúng cỡ HD)
  town: [
    { key: 'lt_petshop', x: 21, y: 13, s: 1 },       // tiệm thú cưng
    { key: 'lt_house_white', x: 4, y: 13, s: 1 },    // nhà trắng — cửa Nhà riêng
    { key: 'lt_rank_sign', x: 31, y: 16, s: 1 },     // bảng xếp hạng
    { key: 'lt_lamp_hd', x: 20, y: 14, s: 1 }, { key: 'lt_lamp_hd', x: 38, y: 18, s: 1 }
  ],
  park: [
    { key: 'lt_icecream', x: 44, y: 14, s: 1 },      // quầy kem
    { key: 'lt_love_tree', x: 50, y: 22, s: 1 }      // cây tình yêu
  ],
  // map cổng: cây + đèn + ghế dọc vỉa hè
  farm_gate: [
    { key: 'deco_tree_round', x: 6, y: 8 }, { key: 'deco_tree_round2', x: 34, y: 8 },
    { key: 'deco_scarecrow', x: 27, y: 7 }, { key: 'deco_barrel', x: 30, y: 7 },
    { key: 'deco_lamp_black', x: 10, y: 11 }, { key: 'deco_lamp_black', x: 30, y: 11 },
    { key: 'deco_flower_pot', x: 16, y: 11 }, { key: 'deco_flower_pot', x: 24, y: 11 }
  ],
  town_gate: [
    { key: 'bld_cafe', x: 7, y: 8, s: 0.9 }, { key: 'bld_pub', x: 34, y: 8, s: 0.9 },
    { key: 'deco_lamp_black', x: 13, y: 11 }, { key: 'deco_lamp_black', x: 27, y: 11 },
    { key: 'deco_bench', x: 16, y: 11 }, { key: 'deco_bench', x: 24, y: 11 }
  ],
  beach_gate: [
    { key: 'bld_beachbar', x: 32, y: 9, s: 0.9 },
    { key: 'deco_lamp_green', x: 10, y: 11 }, { key: 'deco_lamp_green', x: 30, y: 11 },
    { key: 'deco_barrel', x: 7, y: 9 }, { key: 'deco_bench', x: 14, y: 11 }
  ],
  park_gate: [
    { key: 'deco_tree_round', x: 6, y: 8 }, { key: 'deco_tree_pine', x: 34, y: 8 },
    { key: 'deco_bush', x: 9, y: 9 }, { key: 'deco_bush', x: 31, y: 9 },
    { key: 'deco_lamp_green', x: 12, y: 11 }, { key: 'deco_lamp_green', x: 28, y: 11 },
    { key: 'deco_bench', x: 16, y: 11 }, { key: 'deco_bench', x: 24, y: 11 }
  ],
  pond_gate: [
    { key: 'deco_tree_pine', x: 6, y: 8 }, { key: 'deco_tree_pine', x: 34, y: 8 },
    { key: 'deco_lamp_green', x: 12, y: 11 }, { key: 'deco_lamp_green', x: 28, y: 11 },
    { key: 'deco_barrel', x: 9, y: 9 }, { key: 'deco_bench', x: 20, y: 11 }
  ]
};

interface WorldAction { icon: string; label: string; cb: () => void; sprite?: { url: string; sx: number; sy: number; sw: number; sh: number } }

// icon nông cụ (vẽ pixel 16px theo palette pack + cần câu từ fishing pack)
const TOOL_ICON = {
  hoe: { url: 'assets/chibi/tools/hoe.png', sx: 0, sy: 0, sw: 46, sh: 46 },
  can: { url: 'assets/chibi/tools/can.png', sx: 0, sy: 0, sw: 46, sh: 46 },
  basket: { url: 'assets/chibi/tools/basket.png', sx: 0, sy: 0, sw: 48, sh: 46 },
  net: { url: 'assets/chibi/tools/net.png', sx: 0, sy: 0, sw: 48, sh: 46 },
  rod: { url: 'assets/chibi/tools/rod.png', sx: 0, sy: 0, sw: 60, sh: 28 },
  seed: { url: 'assets/farm/seeds.png', sx: 0, sy: 0, sw: 16, sh: 16 }
};

interface InsectSprite { def: InsectDef; obj: Phaser.GameObjects.Image; vx: number; vy: number; t: number }

export class WorldScene extends Phaser.Scene {
  zone!: ZoneDef;
  player!: ChibiSprite;
  private npcs: { def: NpcDef; sprite: ChibiSprite }[] = [];
  private plotTiles: Phaser.GameObjects.Image[] = [];
  private cropSprites: (Phaser.GameObjects.Sprite | undefined)[] = [];
  private plotOverlays: Phaser.GameObjects.Image[] = [];
  private animalSprites = new Map<string, Phaser.GameObjects.Sprite>();
  private insects: InsectSprite[] = [];
  private furnitureObjs: Phaser.GameObjects.Container[] = [];
  private partyGuests: ChibiSprite[] = [];
  private darkOverlay!: Phaser.GameObjects.Rectangle;
  private rain?: Phaser.GameObjects.Particles.ParticleEmitter;
  private waterRect?: Phaser.Geom.Rectangle;
  private pondEllipse?: Phaser.Geom.Ellipse;
  private obstacles: Phaser.Geom.Rectangle[] = [];   // chân nhà/cây — không đi xuyên
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
    this.chopTrees = []; this.mounds = []; this.obstacles = [];
    this.pet = undefined; this.petWalk = false; this.roamers = []; this.running = false;
  }

  create() {
    this.zone = ZONES[S.zone] ?? ZONES.farm;
    const zw = this.zone.w * T, zh = this.zone.h * T;
    this.cameras.main.setBounds(0, 0, zw, zh);
    this.physics.world.setBounds(0, 0, zw, zh);

    this.drawGround();
    if (this.zone.id === 'house') this.drawHouse();
    this.drawRoad();
    this.drawZoneDecor();
    this.drawPortals();
    this.spawnNpcs();
    if (this.zone.features.includes('farm')) this.buildFarm();
    if (this.zone.features.includes('barn')) this.buildBarn();
    if (this.zone.features.includes('insects')) this.spawnInsects();
    if (this.zone.id === 'farm') this.spawnChopTrees();
    if (this.zone.id === 'farm') this.buildPetHouse();
    if (this.zone.id === 'farm' || this.zone.id === 'beach') this.spawnMounds();

    // người chơi chibi Avatar: cao 84px native HD -> map nền HD scale 1,
    // map tile 16px thu về 0.5 (=42px ~ 2.6 tile) cho cân cảnh pixel-art
    const charScale = this.zone.bg ? 1 : 0.5;
    this.player = new ChibiSprite(this, this.zone.spawn.x * T, this.zone.spawn.y * T, S.player.chibi ?? defaultLook(0));
    this.player.setDepth(1000).setScale(charScale);
    this.selector = this.add.image(0, 0, 'sel').setVisible(false).setDepth(900).setAlpha(0.9);

    // chạm vào chính mình -> bảng thao tác cá nhân
    this.attachTapZone(this.player, () => bus.emit(EV.OPEN_PANEL, { panel: 'selfmenu' }));

    this.spawnPet();
    this.spawnRoamers();

    this.cameras.main.startFollow(this.player, true, 0.12, 0.12);
    // canvas render ở 960x540 * RES -> mọi zoom nhân RES để giữ nguyên khung nhìn
    const bw = this.physics.world.bounds;
    const fitZoom = Math.max(this.scale.width / bw.width, this.scale.height / bw.height);
    if (this.zone.road) {
      // map cổng thấp: thu nhỏ vừa đủ để thấy cả cổng chào lẫn con đường
      this.cameras.main.setZoom(Math.min(2.4 * RES, this.scale.height / bw.height));
    } else if (this.zone.bg) {
      // nền ảnh HD kiểu Avatar: zoom nhẹ để thấy khung cảnh đúng tỉ lệ art
      this.cameras.main.setZoom(Math.max(1.6 * RES, fitZoom));
    } else {
      // trong nhà: phóng to để căn phòng lấp đầy màn hình
      this.cameras.main.setZoom(Math.max(2.4 * RES, fitZoom));
    }

    // lớp đêm + mưa
    this.darkOverlay = this.add.rectangle(0, 0, zw, zh, 0x0b1030).setOrigin(0).setDepth(5000).setAlpha(0);
    this.setupWeather();

    this.cursors = this.input.keyboard!.createCursorKeys();
    this.wasd = this.input.keyboard!.addKeys('W,A,S,D,E,SPACE') as Record<string, Phaser.Input.Keyboard.Key>;

    this.cameras.main.fadeIn(250, 0, 0, 0);
    // vừa đi xe tới cổng khu này -> xe vào bến trả khách
    if (busArrival && this.zone.road) this.playArrival();
    // vừa fade ra cổng để đi tiếp -> xe đón luôn
    else if (pendingDepart && this.zone.road) {
      const target = pendingDepart;
      pendingDepart = undefined;
      this.time.delayedCall(350, () => this.playDeparture(target));
    }

    // chạm vào thế giới: đi tới / tương tác côn trùng / đặt đồ
    this.input.on('pointerdown', (p: Phaser.Input.Pointer) => this.onTap(p));

    bus.emit(EV.ZONE, this.zone);
    bus.on(EV.APPEARANCE, this.onAppearance, this);
    bus.on(EV.HOUSE, this.onHouseChanged, this);
    bus.on('world:place', this.startPlacing, this);
    bus.on('world:emote', this.onEmote, this);
    bus.on('world:say', this.onSay, this);
    bus.on('hotbar:use', this.useTool, this);
    bus.on('world:selfact', this.selfAct, this);
    bus.on('world:playeract', this.playPlayerAct, this);
    bus.on('world:selfemote', this.onEmote, this);
    this.events.on('shutdown', () => {
      bus.off(EV.APPEARANCE, this.onAppearance, this);
      bus.off(EV.HOUSE, this.onHouseChanged, this);
      bus.off('world:place', this.startPlacing, this);
      bus.off('world:emote', this.onEmote, this);
      bus.off('world:say', this.onSay, this);
      bus.off('hotbar:use', this.useTool, this);
      bus.off('world:selfact', this.selfAct, this);
      bus.off('world:playeract', this.playPlayerAct, this);
      bus.off('world:selfemote', this.onEmote, this);
    });

    initTimeOnce();
  }

  private onAppearance() { if (S.player.chibi) this.player.setLook(S.player.chibi); }
  private onEmote(i: number) { this.player.showEmote(i); }

  // bong bóng chat trên đầu nhân vật khi nhắn Tổng/Gần
  private speech?: Phaser.GameObjects.Text;
  private speechTimer?: Phaser.Time.TimerEvent;
  private onSay(text: string) {
    this.speech?.destroy();
    this.speechTimer?.remove();
    const off = this.zone.bg ? 104 : 54;
    this.speech = this.add.text(this.player.x, this.player.y - off, text.slice(0, 40), {
      fontSize: this.zone.bg ? '12px' : '8px', color: '#333', backgroundColor: '#ffffff',
      padding: { x: 5, y: 3 }, wordWrap: { width: 140 }, align: 'center'
    }).setOrigin(0.5, 1).setDepth(9500);
    this.speechTimer = this.time.delayedCall(3500, () => { this.speech?.destroy(); this.speech = undefined; });
  }
  private onHouseChanged() { if (this.zone.id === 'house') this.scene.restart(); }

  // ================= vẽ nền =================
  // chân vật thể (điểm neo giữa-dưới): chặn đi xuyên nhà/cây
  private addFootprint(cx: number, baseY: number, w: number, h: number) {
    this.obstacles.push(new Phaser.Geom.Rectangle(cx - w / 2, baseY - h, w, h));
  }

  private blockedAt(x: number, y: number): boolean {
    if (this.inWater(x, y)) return true;
    for (const r of this.obstacles) if (r.contains(x, y)) return true;
    return false;
  }

  // gần nước (kể cả mép) — dùng khi rải cây/hoa/ụ đất
  private nearWaterTile(tx: number, ty: number): boolean {
    for (const [dx, dy] of [[0, 0], [1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1]]) {
      if (this.inWater((tx + dx) * T, (ty + dy) * T)) return true;
    }
    return false;
  }

  private drawGround() {
    const { w, h, ground } = this.zone;

    // nền ảnh (map Avatar từ repo Lttt)
    if (this.zone.bg) {
      this.add.rectangle(0, 0, w * T, h * T, 0x4e8a2a).setOrigin(0).setDepth(-101);
      this.add.image(0, 0, `bg_${this.zone.bg}`).setOrigin(0).setDepth(-100);
      // nông trại HD: hồ đá Avatar góc phải dưới
      if (this.zone.id === 'farm') {
        const P = FARM_POND;
        this.add.image(P.x, P.y, 'lt_pond').setDisplaySize(P.w, P.h).setDepth(-80);
        this.pondEllipse = new Phaser.Geom.Ellipse(P.x, P.y + 4, P.w * 0.94, P.h * 0.84);
        this.add.text(P.x, P.y - P.h / 2 - 10, '🐟 Hồ cá', { fontSize: '10px', color: '#fff', backgroundColor: '#00000080', padding: { x: 4, y: 2 } }).setOrigin(0.5).setDepth(2);
      }
      return;
    }

    // khai báo vùng nước TRƯỚC khi rải decor để cây/hoa không mọc dưới hồ
    if (this.zone.features.includes('fishing')) {
      if (this.zone.id === 'beach') {
        const wx = (this.zone.w - 12) * T;
        this.waterRect = new Phaser.Geom.Rectangle(wx, 0, 12 * T, this.zone.h * T);
      } else if (this.zone.id === 'farm') {
        this.pondEllipse = new Phaser.Geom.Ellipse(34 * T, 28 * T, 10 * T, 5 * T);
      }
    }

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
      // cây từ tileset (tránh ruộng, chuồng và mặt nước)
      if (this.zone.features.includes('trees')) {
        for (let i = 0; i < 10; i++) {
          const x = Math.floor(rnd() * (w - 6)) + 3, y = Math.floor(rnd() * (h - 8)) + 3;
          if (this.zone.features.includes('farm') && x > FARM_ORIGIN.x - 2 && x < FARM_ORIGIN.x + 18 && y > FARM_ORIGIN.y - 2 && y < FARM_ORIGIN.y + 14) continue;
          if (this.zone.features.includes('barn') && x > BARN_RECT.x - 2 && x < BARN_RECT.x + BARN_RECT.w + 2 && y > BARN_RECT.y - 2 && y < BARN_RECT.y + BARN_RECT.h + 2) continue;
          if (this.nearWaterTile(x, y)) continue;
          const kind = Math.floor(rnd() * 3);
          this.add.image(x * T, y * T, ['deco_tree_round', 'deco_tree_round2', 'deco_tree_pine'][kind])
            .setOrigin(0.5, 0.9).setScale(1.4).setDepth(y * T);
        }
      }
      // hoa sprite thật (pack farm) cho map cỏ ngoài trời
      if (ground === 'grass' && (this.zone.features.includes('flowers') || this.zone.features.includes('trees'))) {
        for (let i = 0; i < 16; i++) {
          const x = Math.floor(rnd() * (w - 4)) + 2, y = Math.floor(rnd() * (h - 6)) + 3;
          if (this.zone.features.includes('farm') && x > FARM_ORIGIN.x - 1 && x < FARM_ORIGIN.x + 17 && y > FARM_ORIGIN.y - 1 && y < FARM_ORIGIN.y + 13) continue;
          if (this.zone.features.includes('barn') && x > BARN_RECT.x - 1 && x < BARN_RECT.x + BARN_RECT.w + 1 && y > BARN_RECT.y - 1 && y < BARN_RECT.y + BARN_RECT.h + 1) continue;
          if (this.nearWaterTile(x, y)) continue;
          this.add.image(x * T, y * T, 'pond_deco', 7 + Math.floor(rnd() * 9)).setDepth(-49);
        }
      }
    }

    // nước cho khu câu cá
    if (this.zone.features.includes('fishing')) {
      if (this.zone.id === 'beach' && this.waterRect) {
        // biển dùng tile nước Avatar + dải sóng lấp lánh gần bờ
        const sea = this.add.tileSprite(this.waterRect.x, 0, 12 * T, this.zone.h * T, 'av_water').setOrigin(0).setDepth(-80);
        this.tweens.add({ targets: sea, tilePositionY: 48, duration: 6000, repeat: -1 });
        const foam = this.add.tileSprite(this.waterRect.x, 0, 2.5 * T, this.zone.h * T, 'av_water_spark').setOrigin(0).setDepth(-79).setAlpha(0.8);
        this.tweens.add({ targets: foam, alpha: 0.4, duration: 1400, yoyo: true, repeat: -1 });
      } else if (this.zone.id === 'farm') {
        // hồ cá trong nông trại: viền cát + nước tile Avatar (mask ellipse) + lá súng
        const cx = 34 * T, cy = 28 * T;
        const g = this.add.graphics().setDepth(-80);
        g.fillStyle(0xd9c184); g.fillEllipse(cx, cy, 10.9 * T, 5.9 * T);          // viền cát
        g.fillStyle(0x2e6f9e); g.fillEllipse(cx, cy, 10.2 * T, 5.2 * T);          // mép nước sẫm
        const water = this.add.tileSprite(cx - 4.8 * T, cy - 2.4 * T, 9.6 * T, 4.8 * T, 'av_water').setOrigin(0).setDepth(-79);
        const mg = this.make.graphics({}, false);
        mg.fillStyle(0xffffff); mg.fillEllipse(cx, cy, 9.6 * T, 4.7 * T);
        water.setMask(mg.createGeometryMask());
        this.tweens.add({ targets: water, tilePositionX: 48, duration: 8000, repeat: -1 });
        const shine = this.add.tileSprite(cx - 4.8 * T, cy - 2.4 * T, 9.6 * T, 4.8 * T, 'av_water_spark').setOrigin(0).setDepth(-78).setAlpha(0.35);
        shine.setMask(mg.createGeometryMask());
        this.tweens.add({ targets: shine, alpha: 0.75, duration: 1600, yoyo: true, repeat: -1 });
        // lá súng dập dềnh
        for (const [lx, ly, f] of [[-2.8, -0.9, 0], [1.6, -1.6, 1], [3, 0.9, 2], [-1.2, 1.3, 3]] as [number, number, number][]) {
          const lily = this.add.image(cx + lx * T, cy + ly * T, 'pond_deco', f).setDepth(-78).setScale(1.15);
          this.tweens.add({ targets: lily, y: lily.y - 2, duration: 1600 + f * 300, yoyo: true, repeat: -1, ease: 'sine.inout' });
        }
        // ánh nước lấp lánh
        for (const [sx2, sy2, f] of [[-1, 0.2, 4], [2.2, -0.6, 5], [0.6, 1.5, 6]] as [number, number, number][]) {
          const sp = this.add.image(cx + sx2 * T, cy + sy2 * T, 'pond_deco', f).setDepth(-77).setAlpha(0.4);
          this.tweens.add({ targets: sp, alpha: 0.95, duration: 900 + f * 200, yoyo: true, repeat: -1 });
        }
        // hoa + bụi cây quanh mép hồ
        this.add.image(cx - 5.6 * T, cy - 2.4 * T, 'pond_deco', 13).setDepth(-49);
        this.add.image(cx + 5.4 * T, cy - 2.6 * T, 'pond_deco', 10).setDepth(-49);
        this.add.image(cx - 5.9 * T, cy + 2 * T, 'deco_bush').setOrigin(0.5, 0.8).setDepth((cy + 2 * T));
        this.add.image(cx + 5.7 * T, cy + 1.6 * T, 'deco_bush').setOrigin(0.5, 0.8).setDepth((cy + 1.6 * T));
        this.add.text(cx, cy - 5.8 * T, '🐟 Hồ cá', { fontSize: '8px', color: '#fff', backgroundColor: '#00000080', padding: { x: 3, y: 1 } }).setOrigin(0.5).setDepth(2);
      }
    }
  }

  // ================= đường xe & trạm buýt (khu ngoài trời) =================
  private roadTopY(): number {
    return (this.zone.h - ROAD_TILES) * T;
  }
  private roadMidY(): number {
    return (this.zone.h - ROAD_TILES / 2) * T;
  }
  private roadWidth(): number {
    return this.zone.w * T;
  }
  private busStopX(): number {
    return Math.min(this.roadWidth() - 6 * T, Math.max(6 * T, this.zone.spawn.x * T - 6 * T));
  }

  private drawRoad() {
    if (!this.zone.road) return;
    const top = this.roadTopY(), w = this.roadWidth(), zh = this.zone.h * T;
    const g = this.add.graphics().setDepth(-85);
    // vỉa hè
    g.fillStyle(0xcfc3ae); g.fillRect(0, top - 6, w, 6);
    // mặt đường
    g.fillStyle(0x5b6068); g.fillRect(0, top, w, zh - top);
    // vạch kẻ giữa
    g.fillStyle(0xe8e8e8);
    for (let x = 6; x < w - 20; x += 40) g.fillRect(x, top + (zh - top) / 2 - 1, 22, 3);
    // nhà chờ xe buýt Avatar (repo Lttt)
    const sx = this.busStopX();
    this.add.image(sx, top - 2, 'lt_shelter').setOrigin(0.5, 1).setDepth(top - 40).setScale(0.6);
    // xe riêng đậu mép đường
    if (S.vehicle && this.textures.exists(`veh_${S.vehicle}`)) {
      this.add.image(sx + 7 * T, this.roadMidY(), `veh_${S.vehicle}`).setDepth(this.roadMidY()).setScale(1.1);
    }

    this.drawGateArch();
    this.startTraffic();
  }

  // cổng chào dẫn vào map chính
  private drawGateArch() {
    const p = this.zone.portals[0];
    if (!p) return;
    const gx = p.x * T, gy = p.y * T;
    const g = this.add.graphics().setDepth(gy - 40);
    // hàng rào chạy ngang hai bên cổng
    g.fillStyle(0x8a5a33);
    g.fillRect(0, gy - 26, gx - 3 * T, 6);
    g.fillRect(gx + 3 * T, gy - 26, this.zone.w * T - gx - 3 * T, 6);
    for (let x = T; x < this.zone.w * T; x += 2 * T) {
      if (Math.abs(x - gx) < 3 * T) continue;
      g.fillRect(x - 2, gy - 32, 5, 18);
    }
    // hai trụ cổng + mái
    g.fillStyle(0x6b4a2e);
    g.fillRect(gx - 3 * T, gy - 44, 8, 34);
    g.fillRect(gx + 3 * T - 8, gy - 44, 8, 34);
    g.fillStyle(0xa9714b);
    g.fillRoundedRect(gx - 3 * T - 6, gy - 56, 6 * T + 12, 16, 5);
    const title = this.add.text(gx, gy - 48, `${this.zone.icon} ${ZONES[this.zone.gateTo ?? '']?.name ?? ''}`, {
      fontSize: '9px', color: '#fff8e8', fontStyle: 'bold'
    }).setOrigin(0.5).setDepth(gy - 39);
    void title;
  }

  // xe cộ AI chạy qua lại trên đường
  private startTraffic() {
    const spawnCar = () => {
      if (!this.scene.isActive()) return;
      const key = TRAFFIC_KEYS[Math.floor(Math.random() * TRAFFIC_KEYS.length)];
      if (!this.textures.exists(key)) return;
      const toRight = Math.random() < 0.5;
      const top = this.roadTopY(), zh = this.zone.h * T;
      // 2 làn: làn trên chạy sang trái, làn dưới chạy sang phải
      const laneY = toRight ? top + (zh - top) * 0.72 : top + (zh - top) * 0.3;
      const w = this.zone.w * T;
      const car = this.add.image(toRight ? -120 : w + 120, laneY, key)
        .setDepth(laneY).setScale(1.05).setFlipX(!toRight);
      this.tweens.add({
        targets: car, x: toRight ? w + 120 : -120,
        duration: 6000 + Math.random() * 4000,
        onComplete: () => car.destroy()
      });
    };
    this.time.addEvent({ delay: 2600, loop: true, callback: () => { if (Math.random() < 0.8) spawnCar(); } });
    spawnCar();
  }

  // hiệu ứng xe buýt/xe riêng đón khách rồi rời bến
  private playDeparture(zoneId: string) {
    if (this.busy) return;
    this.busy = true;
    this.stopFishing();
    const key = S.vehicle && this.textures.exists(`veh_${S.vehicle}`) ? `veh_${S.vehicle}` : 'veh_bus';
    const stopX = this.busStopX();
    const midY = this.roadMidY();
    const exitLeft = this.roadWidth() < this.zone.w * T;
    // 1) người chơi chạy tới trạm
    this.tweens.add({
      targets: this.player, x: stopX, y: this.roadTopY() - 10, duration: 450,
      onStart: () => this.player.play('walk'),
      onComplete: () => {
        this.player.play('idle');
        this.player.setDir(0);
        // 2) xe chạy vào bến
        const bus = this.add.image(-120, midY, key).setDepth(9000).setScale(1.15);
        this.tweens.add({
          targets: bus, x: stopX, duration: 1100, ease: 'Cubic.easeOut',
          onComplete: () => {
            sfx.click();
            // 3) lên xe
            this.time.delayedCall(350, () => {
              this.player.setVisible(false);
              // 4) xe rời bến
              this.tweens.add({
                targets: bus, x: exitLeft ? -140 : this.zone.w * T + 140, duration: 1100, ease: 'Cubic.easeIn',
                onStart: () => {
                  if (exitLeft) bus.setFlipX(true);
                  this.cameras.main.fadeOut(900, 0, 0, 0);
                },
                onComplete: () => {
                  busArrival = true;
                  S.zone = zoneId;
                  save(true);
                  this.scene.restart();
                }
              });
            });
          }
        });
      }
    });
  }

  // xe tới bến ở khu mới, người chơi bước xuống
  private playArrival() {
    busArrival = false;
    this.busy = true;
    const key = S.vehicle && this.textures.exists(`veh_${S.vehicle}`) ? `veh_${S.vehicle}` : 'veh_bus';
    const stopX = this.busStopX();
    this.player.setPosition(stopX, this.roadTopY() - 10);
    this.player.setVisible(false);
    const bus = this.add.image(-120, this.roadMidY(), key).setDepth(9000).setScale(1.15);
    this.tweens.add({
      targets: bus, x: stopX, duration: 1100, ease: 'Cubic.easeOut',
      onComplete: () => {
        this.time.delayedCall(300, () => {
          this.player.setVisible(true);
          this.player.setDir(1);
          sfx.click();
          this.tweens.add({
            targets: bus, x: this.zone.w * T + 140, duration: 1100, ease: 'Cubic.easeIn',
            onComplete: () => { bus.destroy(); this.busy = false; }
          });
        });
      }
    });
  }

  // Đặt nhà cửa/đèn/ghế... theo cấu hình ZONE_DECOR
  private drawZoneDecor() {
    for (const d of ZONE_DECOR[this.zone.id] ?? []) {
      if (!this.textures.exists(d.key)) continue;
      const img = this.add.image(d.x * T, d.y * T, d.key)
        .setOrigin(0.5, 1)
        .setScale(d.s ?? (d.key.startsWith('bld_') ? 1.1 : 1.2))
        .setDepth(d.y * T);
      // chân nhà/cây chặn di chuyển (trừ decor nhỏ như hoa/đèn)
      if (img.displayWidth >= 40) {
        this.addFootprint(d.x * T, d.y * T, img.displayWidth * 0.68, Math.min(34, img.displayHeight * 0.24));
      }
    }
  }

  private inWater(x: number, y: number): boolean {
    if (this.waterRect?.contains(x, y)) return true;
    if (this.pondEllipse && Phaser.Geom.Ellipse.Contains(this.pondEllipse, x, y)) return true;
    // vùng nước khai báo trên nền ảnh
    for (const r of this.zone.water ?? []) {
      if (x >= r.x * T && x < (r.x + r.w) * T && y >= r.y * T && y < (r.y + r.h) * T) return true;
    }
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
        const guest = new ChibiSprite(this, (3 + i * 3) * T, 5 * T, this.npcLook(i + 1, i % 2 ? 2 : 1));
        guest.setDepth(500).setScale(0.5);
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
  // bộ đồ chibi cho NPC: đúng giới tính khai báo, chọn đồ khởi đầu theo chỉ số cố định
  private npcLook(seed: number, gender: number) {
    const g = gender;
    const pick = (z: number, i: number) => {
      const list = starterList(z, g);
      return list.length ? list[i % list.length].id : 0;
    };
    return {
      gender: g,
      pant: pick(10, seed), shirt: pick(20, seed + 1), hair: pick(50, seed + 2),
      eyes: EYES_ID, hat: 0, glasses: 0, wing: 0
    };
  }

  private spawnNpcs() {
    const cs = this.zone.bg ? 1 : 0.5;
    const labelOff = cs === 1 ? 104 : 54;
    for (const def of this.zone.npcs) {
      const sprite = new ChibiSprite(this, def.x * T, def.y * T, this.npcLook(def.charIndex, def.gender));
      sprite.setDepth(def.y * T).setScale(cs);
      this.attachTapZone(sprite, () => this.talkNpc(def));
      this.add.text(def.x * T, def.y * T - labelOff, def.name, { fontSize: cs === 1 ? '11px' : '8px', color: '#ffe066', backgroundColor: '#00000090', padding: { x: 3, y: 1 } }).setOrigin(0.5).setDepth(2000);
      this.npcs.push({ def, sprite });
    }
  }

  // ================= ruộng =================
  private buildFarm() {
    farming.ensurePlots();
    const { ox, oy, pw, ph } = FARM_PLOT;
    for (let i = 0; i < farming.MAX_PLOTS; i++) {
      const col = i % farming.FARM_COLS, row = Math.floor(i / farming.FARM_COLS);
      const x = ox + col * pw, y = oy + row * ph;
      const img = this.add.image(x, y, 'fcell2').setOrigin(0).setDepth(-60).setDisplaySize(pw, ph);
      this.plotTiles.push(img);
      // biển "MUA" cho ô sắp mở khóa
      const overlay = this.add.image(x + pw / 2, y + ph * 0.55, 'buyland').setVisible(false).setDepth(y + ph).setScale(0.6);
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
      // ô ruộng kiểu Avatar: cell0 cỏ, cell2 đất trống, cell4 đã cuốc, cell7 tưới ẩm
      if (p.state === 'locked') { img.setTexture('fcell0').setAlpha(0.45); }
      else if (p.state === 'empty') { img.setTexture('fcell2').setAlpha(1); }
      else img.setTexture(p.watered ? 'fcell7' : 'fcell4').setAlpha(1);
      // biển MUA trên ô kế tiếp có thể mở khóa
      const nextIdx = farming.UNLOCK_ORDER[S.farm.unlocked];
      this.plotOverlays[i]?.setVisible(i === nextIdx && S.farm.unlocked < farming.MAX_PLOTS);

      const crop = p?.crop ? CROPS[p.crop] : undefined;
      let spr = this.cropSprites[i];
      if (p?.state === 'planted' && crop) {
        const stage = farming.stageOf(p);
        const frame = crop.row * 25 + 1 + stage; // crops_all: 25 cột, cột 0 là icon
        // cây đứng giữa ô đất, neo chân để gốc chạm đất
        const cx = img.x + FARM_PLOT.pw / 2, cy = img.y + FARM_PLOT.ph * 0.86;
        if (!spr) {
          spr = this.add.sprite(cx, cy, 'crops', frame);
          spr.setOrigin(0.5, 1).setScale(2);
          spr.setDepth(img.y + FARM_PLOT.ph);
          this.cropSprites[i] = spr;
        } else spr.setFrame(frame);
        spr.setVisible(true);
        // cây chín thì nhún nhảy
        if (farming.isRipe(p) && !spr.getData('bounce')) {
          spr.setData('bounce', true);
          this.tweens.add({ targets: spr, y: cy - 2, duration: 400, yoyo: true, repeat: -1 });
        }
        if (!farming.isRipe(p) && spr.getData('bounce')) {
          spr.setData('bounce', false);
          this.tweens.killTweensOf(spr);
          spr.setY(img.y + FARM_PLOT.ph * 0.86);
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
    // nhà chuồng là building HD trong decor; ở đây chỉ vẽ sân + bảng tên
    const lvl = S.livestock.barnLevel;
    const barnLabel = lvl === 0 ? '🏚️ Xây chuồng' : `🐄 Chuồng thú cấp ${lvl}`;
    this.add.text((x + w / 2) * T, (y - 0.4) * T, barnLabel, { fontSize: '10px', color: '#fff', backgroundColor: '#00000080', padding: { x: 4, y: 2 } }).setOrigin(0.5).setDepth(3000);

    for (const a of S.livestock.animals) this.spawnAnimal(a.id, a.type);
    this.time.addEvent({ delay: 1500, loop: true, callback: () => this.wanderAnimals() });
  }

  private spawnAnimal(id: string, type: string) {
    const def = ANIMALS[type];
    if (!def) return;
    const { x, y, w, h } = BARN_RECT;
    const ax = (x + 1 + Math.random() * (w - 2)) * T;
    const ay = (y + 1 + Math.random() * (h - 2)) * T;
    const spr = this.add.sprite(ax, ay, `animal_${type}`, 0).setDepth(ay).setScale(this.zone.bg ? 1.9 : 1);
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
    if (livestock.hasProduct(a)) acts.push({
      icon: '🧺', label: `Thu ${'' + def.name}`, cb: () => {
        livestock.collect(a); toast(`Thu được sản phẩm từ ${def.name}!`, def.icon);
        const spr = this.animalSprites.get(id);
        if (spr) {
          this.fxBurst(spr.x, spr.y - 8, 0xffe066, 10);
          // frame trong items.png (10 cột): trứng 40, sữa 30, nấm 62, len 50
          const pf: Record<string, number> = { egg: 40, milk: 30, pork: 62, wool: 50 };
          this.fxFloatIcon(spr.x, spr.y - 20, 'items16', pf[def.product] ?? 40, '+1');
        }
      }
    });
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
        const maxY = this.zone.road ? this.roadTopY() - 16 : this.zone.h * T;
        const x = Math.random() * this.zone.w * T, y = Math.random() * maxY;
        if (this.inWater(x, y)) return;
        // sprite côn trùng thật từ nature pack (fallback procedural nếu thiếu)
        const obj = this.textures.exists('nature')
          ? this.add.sprite(x, y, 'nature', def.frame).setDepth(2500).setScale(this.zone.bg ? 2.4 : 1.1) as unknown as Phaser.GameObjects.Image
          : this.add.image(x, y, def.kind === 'butterfly' ? 'butterfly' : 'bug').setTint(def.color).setDepth(2500).setScale(0.8);
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
    if (d > (this.zone.bg ? 95 : 48)) { toast('Lại gần hơn chút nữa!', '🥅'); return; }
    if (this.busy) return;
    this.busy = true;
    // quay mặt về phía côn trùng
    const ang = Math.atan2(ins.obj.y - this.player.y, ins.obj.x - this.player.x);
    const adir: Dir = Math.abs(Math.cos(ang)) > Math.abs(Math.sin(ang)) ? (Math.cos(ang) > 0 ? 3 : 2) : (Math.sin(ang) > 0 ? 0 : 1);
    this.player.setDir(adir);
    this.player.play('pickup', () => {
      this.busy = false;
      const ok = fishing.catchInsect(ins.def);
      if (ok !== undefined) {
        this.fxBurst(ins.obj.x, ins.obj.y, 0x8ce99a, 8);
        this.fxFloatIcon(ins.obj.x, ins.obj.y - 12, 'nature', ins.def.frame, '+1', '#8ce99a');
        this.removeInsect(ins);
      }
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
    const bait = fishing.useBait();
    if (bait) toast(`Đã móc ${bait.name}`, '🪱');
    const wait = (1500 + Math.random() * 3500) * (bait?.wait ?? 1);
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
    // hồ cá nông trại dùng bảng cá của hồ câu
    const f = fishing.rollFish(this.zone.id === 'farm' ? 'pond' : this.zone.id);
    if (f) {
      fishing.landFish(f);
      toast(`Câu được ${f.name}!`, '🐟');
      if (this.bobber) this.fxBurst(this.bobber.x, this.bobber.y, 0x74c0fc, 10);
      this.fxFloatIcon(this.player.x, this.player.y - (this.zone.bg ? 100 : 50), 'fish', f.index, `+${f.name}`, '#74c0fc');
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
    const { ox, oy, pw, ph } = FARM_PLOT;
    let best = -1, bd = 42;
    for (let i = 0; i < farming.MAX_PLOTS; i++) {
      const col = i % farming.FARM_COLS, row = Math.floor(i / farming.FARM_COLS);
      const cx = ox + col * pw + pw / 2, cy = oy + row * ph + ph / 2;
      const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, cx, cy);
      if (d < bd) { bd = d; best = i; }
    }
    return best;
  }

  private nearWater(): boolean {
    if (!this.zone.features.includes('fishing')) return false;
    const R = this.zone.bg ? 60 : 30;
    for (const off of [[0, R], [0, -R], [-R, 0], [R, 0]]) {
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
      this.selector.setVisible(true).setPosition(this.plotTiles[pi].x + FARM_PLOT.pw / 2, this.plotTiles[pi].y + FARM_PLOT.ph / 2).setScale(1.3);
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
      if (p.state === 'empty') acts.push({ icon: '⛏️', sprite: TOOL_ICON.hoe, label: 'Cuốc đất', cb: () => this.doTill(pi) });
      if (p.state === 'tilled') acts.push({ icon: '🌱', sprite: TOOL_ICON.seed, label: 'Trồng cây', cb: () => bus.emit(EV.OPEN_PANEL, { panel: 'seedpicker', data: { plot: pi } }) });
      if (p.state === 'planted') {
        if (farming.isRipe(p)) acts.push({ icon: '🧺', sprite: TOOL_ICON.basket, label: 'Thu hoạch', cb: () => this.doHarvest(pi) });
        else {
          if (!p.watered) acts.push({ icon: '💧', sprite: TOOL_ICON.can, label: 'Tưới nước', cb: () => this.doWater(pi) });
          if (!p.fertilized) acts.push({ icon: '💩', label: 'Bón phân', cb: () => farming.fertilize(pi) });
        }
      }
    } else this.selector.setVisible(false);

    // bảng xếp hạng (thành phố)
    if (this.zone.id === 'town' && Phaser.Math.Distance.Between(this.player.x, this.player.y, 31 * T, 16 * T) < 50) {
      acts.push({ icon: '🏆', label: 'Xem bảng xếp hạng', cb: () => bus.emit(EV.OPEN_PANEL, { panel: 'ranking' }) });
    }

    // nhà kho + cây khế (nông trại)
    if (this.zone.id === 'farm') {
      // nhà kho: mở kho đồ
      if (Phaser.Math.Distance.Between(this.player.x, this.player.y, WAREHOUSE_POS.x, WAREHOUSE_POS.y + 40) < 80) {
        acts.push({ icon: '🎒', label: 'Mở nhà kho', cb: () => bus.emit(EV.OPEN_PANEL, { panel: 'inventory' }) });
      }
      // cây khế: rung cây nhặt quả (hồi 10 phút)
      if (Phaser.Math.Distance.Between(this.player.x, this.player.y, KHE_POS.x, KHE_POS.y + 30) < 85) {
        const last = S.stats['khe_last'] ?? 0;
        const readyIn = 10 * 60_000 - (Date.now() - last);
        if (readyIn <= 0) {
          acts.push({
            icon: '⭐', label: 'Rung cây khế', cb: () => {
              this.busy = true;
              this.player.play('pickup', () => {
                this.busy = false;
                const qty = 1 + Math.floor(Math.random() * 3);
                S.stats['khe_last'] = Date.now();
                import('@/core/save').then(m => { m.addItem('crop_khe', qty); m.addStat('khe_shaken'); });
                toast(`Rụng ${qty} quả khế!`, '⭐');
              });
            }
          });
        } else {
          acts.push({ icon: '⏳', label: `Khế chưa chín (${Math.ceil(readyIn / 60000)} phút)`, cb: () => toast('Chờ khế chín đã nha!', '⭐') });
        }
      }
    }

    // nhà thú cưng (nông trại) — chỉ có khi đã nuôi
    if (this.zone.id === 'farm' && S.pets?.length &&
        Phaser.Math.Distance.Between(this.player.x, this.player.y, PETHOUSE_POS.x + 30, PETHOUSE_POS.y + 40) < 95) {
      acts.push({ icon: '🐾', label: 'Thú cưng của tôi', cb: () => bus.emit(EV.OPEN_PANEL, { panel: 'petbag' }) });
    }

    // tiệm thú cưng (thành phố)
    if (this.zone.id === 'town' && Phaser.Math.Distance.Between(this.player.x, this.player.y, PETSHOP_POS.x, PETSHOP_POS.y + 30) < 110) {
      acts.push({ icon: '🐾', label: 'Tiệm thú cưng', cb: () => bus.emit(EV.OPEN_PANEL, { panel: 'petshop' }) });
    }

    // chuồng
    if (this.zone.features.includes('barn')) {
      const bx = (BARN_RECT.x + BARN_RECT.w / 2) * T, by = (BARN_RECT.y + BARN_RECT.h / 2) * T;
      if (Phaser.Math.Distance.Between(this.player.x, this.player.y, bx, by) < (this.zone.bg ? 110 : 40)) {
        if (S.livestock.barnLevel === 0) acts.push({ icon: '🏚️', label: 'Xây chuồng (500 xu)', cb: () => { livestock.upgradeBarn(); this.scene.restart(); } });
        else {
          acts.push({ icon: '🐔', label: 'Mua vật nuôi', cb: () => bus.emit(EV.OPEN_PANEL, { panel: 'animalshop' }) });
          if (S.livestock.barnLevel < 3) acts.push({ icon: '⬆️', label: 'Nâng chuồng', cb: () => { livestock.upgradeBarn(); this.scene.restart(); } });
        }
      }
    }

    // câu cá
    if (this.nearWater()) {
      if (this.fishingState === 'idle') acts.push({ icon: '🎣', sprite: TOOL_ICON.rod, label: 'Câu cá', cb: () => this.startFishing() });
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

  // ================= hiệu ứng thu hoạch / tương tác =================
  private fxBurst(x: number, y: number, tint = 0xfff3bf, count = 10) {
    const em = this.add.particles(x, y, 'glow', {
      speed: { min: 30, max: 100 }, scale: { start: 0.45, end: 0 }, alpha: { start: 1, end: 0 },
      lifespan: 450, tint, emitting: false
    }).setDepth(7000);
    em.explode(count, 0, 0);
    this.time.delayedCall(650, () => em.destroy());
  }

  private fxFloat(x: number, y: number, msg: string, color = '#ffd43b') {
    const big = !!this.zone.bg;
    const t = this.add.text(x, y, msg, {
      fontSize: big ? '15px' : '11px', fontStyle: 'bold', color,
      stroke: '#3d2c05', strokeThickness: 3
    }).setOrigin(0.5).setDepth(7001);
    this.tweens.add({ targets: t, y: y - (big ? 44 : 30), alpha: 0, duration: 950, ease: 'cubic.out', onComplete: () => t.destroy() });
  }

  // chữ bay kèm sprite thật (thay emoji): [icon] +text
  private fxFloatIcon(x: number, y: number, texture: string, frame: number, msg: string, color = '#ffd43b') {
    const big = !!this.zone.bg;
    const c = this.add.container(x, y).setDepth(7001);
    const img = this.add.image(0, 0, texture, frame).setScale(big ? 1.6 : 1.1);
    const t = this.add.text(big ? 14 : 10, 0, msg, {
      fontSize: big ? '15px' : '11px', fontStyle: 'bold', color,
      stroke: '#3d2c05', strokeThickness: 3
    }).setOrigin(0, 0.5);
    c.add([img, t]);
    // căn giữa cụm icon + chữ
    const w = (big ? 14 : 10) + t.width;
    img.x -= w / 2; t.x -= w / 2;
    this.tweens.add({ targets: c, y: y - (big ? 44 : 30), alpha: 0, duration: 950, ease: 'cubic.out', onComplete: () => c.destroy() });
  }

  // ================= rìu chặt cây & xẻng đào đất =================
  private chopTrees: { obj: Phaser.GameObjects.Image; readyAt: number }[] = [];
  private mounds: Phaser.GameObjects.Image[] = [];

  private spawnChopTrees() {
    // 3 cây gỗ HD giữa nông trại (ngoài ruộng/chuồng/hồ)
    for (const [px2, py2] of [[485, 315], [610, 380], [500, 480]] as [number, number][]) {
      const obj = this.add.image(px2, py2, 'lt_tree').setOrigin(0.5, 1).setScale(0.72).setDepth(py2);
      this.addFootprint(px2, py2, 46, 22);
      this.chopTrees.push({ obj, readyAt: 0 });
    }
  }

  // vùng chạm ôm trọn nhân vật (zone con trong container -> transform chuẩn)
  private attachTapZone(c: ChibiSprite, cb: () => void) {
    const z = this.add.zone(0, -44, 52, 92).setInteractive({ useHandCursor: true });
    z.on('pointerdown', cb);
    c.add(z);
  }

  // ================= diễn hành động với người chơi khác =================
  // Sprite Avatar không có tư thế hôn/ôm/đá riêng -> dựng hành động bằng
  // chuyển động (tiến/lùi/nghiêng/văng) + hiệu ứng, kèm tư thế tay gần nhất.
  private playPlayerAct(d: { id: string; name: string; kind: string; icon: string; text: string; aff: number }) {
    const target = this.roamers.find(r => r.def.id === d.id);
    if (!target) { toast(d.text, d.icon); return; }
    if (this.busy) return;
    this.busy = true;
    this.tweens.killTweensOf(target.sprite);
    this.tweens.killTweensOf(target.label);
    target.busy = true;
    target.sprite.play('idle');

    const big = !!this.zone.bg;
    const tx = target.sprite.x, ty = target.sprite.y;
    const side = this.player.x <= tx ? -1 : 1;              // đứng bên nào
    const gap = big ? 46 : 24;
    const headY = big ? 96 : 52;
    const done = () => { this.busy = false; this.player.setAngle(0); this.player.play('idle'); };

    // bước tới cạnh đối phương rồi diễn
    this.player.play('walk');
    this.player.setDir(tx + side * gap < this.player.x ? 2 : 3);
    this.tweens.add({
      targets: this.player, x: tx + side * gap, y: ty,
      duration: Math.min(900, Phaser.Math.Distance.Between(this.player.x, this.player.y, tx, ty) * 4),
      onUpdate: () => this.player.setDepth(this.player.y),
      onComplete: () => {
        this.player.setDir(side < 0 ? 3 : 2);                // quay mặt vào nhau
        target.sprite.setDir(side < 0 ? 2 : 3);
        this.onSay(d.text);
        const near = tx + side * (gap * 0.45);               // vị trí áp sát

        if (d.kind === 'kiss') {
          this.player.play('reach');
          this.player.setFace('kiss', 1400);
          // nghiêng người tới hôn rồi lùi
          this.tweens.add({
            targets: this.player, x: near, duration: 260, yoyo: true, hold: 260, ease: 'sine.inout',
            onComplete: done
          });
          this.tweens.add({ targets: this.player, angle: side * -6, duration: 260, yoyo: true, hold: 260 });
          // tim bay từ mình sang đối phương
          this.time.delayedCall(320, () => {
            const heart = this.add.text(this.player.x, this.player.y - headY, '❤️', { fontSize: big ? '18px' : '12px' })
              .setOrigin(0.5).setDepth(9000);
            this.tweens.add({
              targets: heart, x: tx, y: ty - headY - 14, alpha: 0, duration: 900, ease: 'sine.out',
              onComplete: () => heart.destroy()
            });
            target.sprite.play('cheer');
            target.sprite.setFace('shy', 1600);
            this.time.delayedCall(700, () => { target.sprite.play('idle'); target.busy = false; });
          });

        } else if (d.kind === 'hug') {
          this.player.play('reach');
          // cả hai xích sát vào nhau rồi rung nhẹ
          this.tweens.add({ targets: this.player, x: near, duration: 240, ease: 'sine.out' });
          this.tweens.add({ targets: [target.sprite, target.label], x: `-=${side * 10}`, duration: 240, ease: 'sine.out' });
          this.time.delayedCall(260, () => {
            target.sprite.play('reach');
            this.player.setFace('happy', 1500);
            target.sprite.setFace('laugh', 1500);
            this.tweens.add({ targets: [this.player, target.sprite], x: `+=${side * 3}`, duration: 110, yoyo: true, repeat: 2 });
            for (let i = 0; i < 3; i++) {
              this.time.delayedCall(i * 180, () => this.fxFloat((this.player.x + tx) / 2, ty - headY + i * 6, '❤️', '#ff8787'));
            }
          });
          this.time.delayedCall(1100, () => {
            target.sprite.play('idle');
            this.tweens.add({ targets: [target.sprite, target.label], x: `+=${side * 10}`, duration: 240 });
            target.busy = false;
            done();
          });

        } else if (d.kind === 'kick') {
          // lùi lấy đà -> lao tới -> đối phương văng ra
          this.tweens.add({
            targets: this.player, x: `+=${side * 16}`, duration: 180, ease: 'sine.out',
            onComplete: () => {
              this.player.play('strike');
              this.player.setFace('tongue', 1600);
              this.tweens.add({
                targets: this.player, x: near, duration: 130, ease: 'back.in',
                onComplete: () => {
                  sfx.error();
                  target.sprite.setFace('hurt');          // mặt đau lúc trúng đòn
                  this.fxBurst(tx, ty - headY * 0.4, 0xffd43b, 12);
                  this.fxFloat(tx, ty - headY, '💢', '#ff8787');
                  // văng ra sau rồi ngã nằm sõng soài
                  this.tweens.add({
                    targets: [target.sprite, target.label], x: `-=${side * 46}`, duration: 220, ease: 'quad.out'
                  });
                  this.tweens.add({
                    targets: target.sprite, angle: side * -70, duration: 260, ease: 'back.out',
                    onComplete: () => {
                      target.sprite.play('lie');
                      target.sprite.setFace('cry');       // nằm mếu máo
                      target.sprite.setAngle(0);
                      this.fxBurst(target.sprite.x, target.sprite.y, 0xd9c184, 8);   // bụi khi tiếp đất
                      // sao xoay quanh đầu lúc nằm
                      const stars = this.add.text(target.sprite.x, target.sprite.y - headY * 0.45, '💫', {
                        fontSize: big ? '16px' : '11px'
                      }).setOrigin(0.5).setDepth(9000);
                      this.tweens.add({ targets: stars, alpha: 0.3, duration: 420, yoyo: true, repeat: 2 });
                      // nằm một lúc rồi lồm cồm bò dậy
                      this.time.delayedCall(1800, () => {
                        stars.destroy();
                        target.sprite.play('work');                                   // chống tay ngồi dậy
                        target.sprite.setFace('angry', 2000);                         // dậy là quạu
                        this.tweens.add({
                          targets: [target.sprite, target.label], x: `+=${side * 46}`, duration: 420, ease: 'sine.inout'
                        });
                        this.time.delayedCall(500, () => {
                          target.sprite.play('idle');
                          target.busy = false;
                          this.fxFloat(target.sprite.x, target.sprite.y - headY, '😤', '#ffd43b');
                        });
                      });
                    }
                  });
                  this.time.delayedCall(900, done);
                }
              });
            }
          });

        } else {  // an ủi: vỗ vai
          this.player.play('pat');
          this.player.setFace('happy', 1600);
          target.sprite.setFace('sad');
          this.tweens.add({ targets: this.player, x: near, duration: 240, yoyo: true, hold: 700, ease: 'sine.inout', onComplete: done });
          this.time.delayedCall(300, () => {
            // tay vỗ nhẹ 2 cái -> đối phương gật gù
            this.tweens.add({ targets: target.sprite, y: `-=4`, duration: 160, yoyo: true, repeat: 1 });
            this.fxFloat(tx, ty - headY, '💛', '#ffd43b');
            target.sprite.play('cheer');
            this.time.delayedCall(500, () => target.sprite.setFace('happy', 1200));   // được an ủi thì tươi lại
            this.time.delayedCall(800, () => { target.sprite.play('idle'); target.busy = false; });
          });
        }
      }
    });
  }

  // ================= thao tác bản thân =================
  private running = false;

  private selfAct(kind: string) {
    if (kind === 'run') {
      this.running = !this.running;
      toast(this.running ? 'Bật chế độ chạy 🏃' : 'Tắt chế độ chạy', '🏃');
      return;
    }
    if (kind === 'sit' || kind === 'lie') {
      this.busy = true;
      this.player.play(kind === 'sit' ? 'sit' : 'lie');
      this.player.setFace(kind === 'lie' ? 'wink' : 'happy', 2500);   // nằm thì lim dim, ngồi thì thoải mái
      toast(kind === 'sit' ? 'Ngồi nghỉ một chút~' : 'Nằm thư giãn~', kind === 'sit' ? '🪑' : '🛌');
      // đứng dậy khi di chuyển
      const stand = this.time.addEvent({ delay: 200, loop: true, callback: () => {
        if (Math.hypot(virtualInput.x, virtualInput.y) > 0.25 ||
            this.cursors.left.isDown || this.cursors.right.isDown || this.cursors.up.isDown || this.cursors.down.isDown) {
          this.busy = false; this.player.resetFace(); this.player.play('idle'); stand.remove();
        }
      } });
    }
  }

  // ================= người chơi khác trong khu =================
  private spawnRoamers() {
    // chỉ ở khu công cộng (không phải nông trại / nhà riêng / map cổng)
    if (this.zone.id === 'farm' || this.zone.id === 'house' || this.zone.road) return;
    const cs = this.zone.bg ? 1 : 0.5;
    const list = roamersIn(this.zone.id, 3);
    list.forEach((def, i) => {
      const bx = this.zone.spawn.x * T + (i - 1) * 230 + (i % 2 ? 70 : -70);
      const by = this.zone.spawn.y * T + (i % 2 ? 90 : -60);
      const sprite = new ChibiSprite(this, bx, by, this.npcLook(i + 3, i % 2 ? 2 : 1));
      sprite.setScale(cs).setDepth(by);
      const label = this.add.text(bx, by - (cs === 1 ? 104 : 54), def.name, {
        fontSize: cs === 1 ? '11px' : '8px', color: '#8ce99a',
        backgroundColor: '#00000090', padding: { x: 3, y: 1 }
      }).setOrigin(0.5).setDepth(2000);
      // vùng chạm rộng, không cần đứng sát
      this.attachTapZone(sprite, () => bus.emit(EV.OPEN_PANEL, { panel: 'playermenu', data: { friend: def } }));
      const entry: { def: Friend; sprite: ChibiSprite; label: Phaser.GameObjects.Text; busy?: boolean } = { def, sprite, label };
      this.roamers.push(entry);
      // đi lại lững thững
      const walk = () => {
        if (!sprite.active) return;
        if (entry.busy) { this.time.delayedCall(700, walk); return; }   // đang bị tác động -> chưa đi
        const tx = Phaser.Math.Clamp(bx + (Math.random() - 0.5) * 260, 60, this.zone.w * T - 60);
        const ty = Phaser.Math.Clamp(by + (Math.random() - 0.5) * 120,
          (this.zone.walkTop ?? 2) * T + 10, (this.zone.walkBottom ?? this.zone.h - 2) * T - 10);
        sprite.setDir(tx < sprite.x ? 2 : 3);
        sprite.play('walk');
        this.tweens.add({
          targets: [sprite, label], x: tx, duration: 2200 + Math.random() * 1500,
          onUpdate: () => { sprite.setDepth(sprite.y); },
          onComplete: () => { sprite.play('idle'); this.time.delayedCall(1500 + Math.random() * 3000, walk); }
        });
        this.tweens.add({ targets: sprite, y: ty, duration: 2200 + Math.random() * 1500 });
        this.tweens.add({ targets: label, y: ty - (cs === 1 ? 104 : 54), duration: 2200 + Math.random() * 1500 });
      };
      this.time.delayedCall(800 + i * 600, walk);
    });
  }

  // ================= thú cưng =================
  private pet?: Phaser.GameObjects.Sprite;
  private petWalk = false;
  private roamers: { def: Friend; sprite: ChibiSprite; label: Phaser.GameObjects.Text; busy?: boolean }[] = [];      // đang dắt đi dạo (đi theo người chơi)

  // nhà thú cưng chỉ dựng khi đã nuôi ít nhất 1 bé
  private buildPetHouse() {
    if (!S.pets?.length) return;
    const baseY = PETHOUSE_POS.y + 60;
    const img = this.add.image(PETHOUSE_POS.x, baseY, 'lt_doghouse').setOrigin(0.5, 1).setDepth(baseY);
    this.addFootprint(PETHOUSE_POS.x, baseY, img.displayWidth * 0.72, 22);
    // ổ nệm + bảng tên
    this.add.image(PETHOUSE_POS.x + 82, baseY - 4, 'lt_petbed').setOrigin(0.5, 1).setDepth(baseY - 4);
    this.add.text(PETHOUSE_POS.x, baseY - img.displayHeight - 6, '🐾 Nhà thú cưng', {
      fontSize: '10px', color: '#fff', backgroundColor: '#00000080', padding: { x: 4, y: 2 }
    }).setOrigin(0.5).setDepth(3000);
  }

  private spawnPet() {
    const id = S.activePet;
    if (!id || !S.pets?.includes(id)) return;
    const def = PETS[id];
    if (!def || !this.textures.exists(def.sheet)) return;
    const home = this.zone.id === 'farm'
      ? { x: PETHOUSE_POS.x + 46, y: PETHOUSE_POS.y + 60 }
      : { x: this.player.x + 40, y: this.player.y + 8 };
    this.pet = this.add.sprite(home.x, home.y, def.sheet, def.frames.idle[0])
      .setOrigin(0.5, 1).setScale(def.scale * (this.zone.bg ? 1 : 0.5)).setDepth(home.y);
    this.pet.setInteractive({ useHandCursor: true });
    this.pet.on('pointerdown', () => this.petMenu());

    // thở / vẫy khi đứng yên
    this.time.addEvent({ delay: 850, loop: true, callback: () => {
      if (!this.pet?.active || this.tweens.isTweening(this.pet)) return;
      const f = def.frames.idle;
      this.pet.setFrame(this.pet.frame.name === String(f[0]) ? f[1] : f[0]);
    } });

    // đi loanh quanh khi không dắt
    const wander = () => {
      if (!this.pet?.active) return;
      if (this.petWalk) { this.time.delayedCall(900, wander); return; }
      const base = this.zone.id === 'farm' ? PETHOUSE_POS : { x: this.player.x, y: this.player.y };
      const tx = base.x + (this.zone.id === 'farm' ? 20 + Math.random() * 90 : -50 + Math.random() * 100);
      const ty = (this.zone.id === 'farm' ? PETHOUSE_POS.y + 10 : this.player.y - 10) + Math.random() * 40;
      this.pet.setFrame(def.frames.move);
      this.pet.setFlipX(tx < this.pet.x);
      this.tweens.add({
        targets: this.pet, x: tx, y: ty, duration: 1400 + Math.random() * 1200,
        onUpdate: () => this.pet?.setDepth(this.pet.y),
        onComplete: () => { this.pet?.setFrame(def.frames.idle[0]); this.time.delayedCall(1200 + Math.random() * 2200, wander); }
      });
    };
    this.time.delayedCall(1200, wander);
  }

  // pet bám theo người chơi khi đang dắt đi dạo
  private followPet(dt: number) {
    if (!this.pet?.active || !this.petWalk) return;
    const def = PETS[S.activePet ?? ''];
    if (!def) return;
    const gap = this.zone.bg ? 52 : 26;
    const dx = this.player.x - this.pet.x, dy = this.player.y + 6 - this.pet.y;
    const d = Math.hypot(dx, dy);
    if (d > gap) {
      const spd = Math.min(d - gap, (this.zone.bg ? 150 : 100) * (dt / 1000));
      this.pet.x += (dx / d) * spd;
      this.pet.y += (dy / d) * spd;
      this.pet.setFlipX(dx < 0);
      this.pet.setFrame(def.frames.move);
      this.pet.setDepth(this.pet.y);
    } else if (this.pet.frame.name === String(def.frames.move)) {
      this.pet.setFrame(def.frames.idle[0]);
    }
  }

  // bảng chọn khi bấm vào thú cưng
  private petMenu() {
    const def = PETS[S.activePet ?? ''];
    if (!def) return;
    bus.emit(EV.OPEN_PANEL, {
      panel: 'dialog',
      data: {
        title: def.name,
        text: def.perkFull,
        actions: [
          {
            icon: this.petWalk ? '🏠' : '🦮', label: this.petWalk ? 'Cho về nhà' : 'Dắt đi dạo',
            cb: () => {
              this.petWalk = !this.petWalk;
              this.tweens.killTweensOf(this.pet!);
              toast(this.petWalk ? `${def.name} đi dạo cùng bạn!` : `${def.name} về chỗ nghỉ.`, def.icon);
            }
          },
          {
            icon: '❤️', label: 'Vuốt ve', cb: () => {
              if (this.pet) this.fxFloat(this.pet.x, this.pet.y - 54, '❤️', '#ff8787');
              toast(`${def.name} kêu vui vẻ~`, def.icon);
            }
          }
        ]
      }
    });
  }

  private spawnMounds(n = 3) {
    for (let i = 0; i < n; i++) this.spawnMound();
  }

  private spawnMound() {
    // vị trí ngẫu nhiên tránh vùng ruộng
    for (let tries = 0; tries < 40; tries++) {
      const tx = 3 + Math.floor(Math.random() * (this.zone.w - 6));
      const ty = 4 + Math.floor(Math.random() * (this.zone.h - 8));
      if (this.zone.id === 'farm') {
        if (tx > 3 && tx < 28 && ty > 12 && ty < 32) continue;                       // lưới ruộng
        if (ty < 14) continue;                                                       // dãy nhà + chuồng
      }
      if (this.nearWaterTile(tx, ty)) continue;                                      // không mọc dưới nước
      const obj = this.add.image(tx * T, ty * T, 'mound').setDepth(ty * T - 8).setScale(this.zone.bg ? 1.9 : 1);
      this.mounds.push(obj);
      return;
    }
  }

  private chopNearestTree() {
    let best: { obj: Phaser.GameObjects.Image; readyAt: number } | undefined; let bd = 1e9;
    for (const t of this.chopTrees) {
      const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, t.obj.x, t.obj.y - 10);
      if (d < bd) { bd = d; best = t; }
    }
    if (!best || bd > 95) { toast('Lại gần mấy cây gỗ giữa nông trại nhé.', '🪓'); return; }
    if (Date.now() < best.readyAt) {
      toast(`Cây đang mọc lại (${Math.ceil((best.readyAt - Date.now()) / 60000)} phút).`, '🌱');
      return;
    }
    const tree = best;
    this.busy = true;
    this.player.play('axe', () => {
      this.busy = false;
      const qty = 1 + Math.floor(Math.random() * 2);
      import('@/core/save').then(m => { m.addItem('wood', qty); m.addStat('wood_chopped', qty); });
      this.tweens.add({ targets: tree.obj, angle: { from: -4, to: 4 }, duration: 70, yoyo: true, repeat: 3, onComplete: () => tree.obj.setAngle(0) });
      this.fxBurst(tree.obj.x, tree.obj.y - 16, 0xb08850, 8);
      this.fxFloatIcon(tree.obj.x, tree.obj.y - 30, 'items16', 70, `+${qty} Gỗ`);
      sfx.harvest();
      tree.readyAt = Date.now() + 4 * 60_000;
      tree.obj.setAlpha(0.45);
      this.time.delayedCall(4 * 60_000, () => tree.obj.setAlpha(1));
    });
  }

  private digNearestMound() {
    let best: Phaser.GameObjects.Image | undefined; let bd = 1e9;
    for (const m of this.mounds) {
      const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, m.x, m.y);
      if (d < bd) { bd = d; best = m; }
    }
    if (!best || bd > (this.zone.bg ? 90 : 52)) { toast('Không có đống đất nào gần đây — tìm mấy ụ đất nâu nhé.', '🦯'); return; }
    const mound = best;
    this.busy = true;
    this.player.play('hoe', () => {
      this.busy = false;
      this.mounds = this.mounds.filter(m => m !== mound);
      const { x, y } = mound;
      mound.destroy();
      this.fxBurst(x, y, 0x8a5a33, 8);
      // rương ngẫu nhiên
      const r = Math.random();
      import('@/core/save').then(m => {
        if (r < 0.35) {
          const coins = 10 + Math.floor(Math.random() * 31);
          m.addCoins(coins);
          this.fxFloat(x, y - 10, `+${coins} xu`);
        } else if (r < 0.6) {
          const crop = CROP_LIST[Math.floor(Math.random() * CROP_LIST.length)];
          m.addItem(`seed_${crop.id}`);
          toast(`Đào được Hạt ${crop.name}!`, '🌱');
        } else if (r < 0.75) {
          m.addItem('fertilizer');
          toast('Đào được Phân bón!', '💩');
        } else if (r < 0.93) {
          m.addItem('stone');
          this.fxFloatIcon(x, y - 10, 'items16', 71, '+1 Đá');
        } else {
          m.addRubies(1);
          toast('Đào trúng 1 Ruby! 💎', '💎');
        }
        m.addStat('dug');
      });
      sfx.plant();
      // ụ đất mới mọc chỗ khác sau 45s
      this.time.delayedCall(45_000, () => { if (this.scene.isActive()) this.spawnMound(); });
    });
  }

  // dùng nông cụ gắn trên thanh nhanh (hotbar): tác động lên mục tiêu gần nhất
  private useTool(id: string) {
    if (this.busy) return;
    const pi = this.zone.features.includes('farm') ? this.nearestPlot() : -1;
    const p = pi >= 0 ? S.farm.plots[pi] : undefined;
    switch (id) {
      case 'hoe':
        if (p?.state === 'empty') this.doTill(pi);
        else toast('Đứng cạnh ô đất trống rồi dùng cuốc nhé.', '⛏️');
        break;
      case 'can':
        if (p?.state === 'planted' && !p.watered) this.doWater(pi);
        else toast('Không có cây nào cần tưới ở gần đây.', '💧');
        break;
      case 'basket':
        if (p && p.state === 'planted' && farming.isRipe(p)) this.doHarvest(pi);
        else toast('Chưa có cây chín gần đây để thu hoạch.', '🧺');
        break;
      case 'rod':
        if (this.fishingState === 'bite') this.reelFish();
        else if (this.fishingState === 'waiting') this.stopFishing();
        else if (this.nearWater()) this.startFishing();
        else toast('Lại gần mép nước rồi thả câu nhé.', '🎣');
        break;
      case 'net': {
        let best: InsectSprite | undefined; let bd = 1e9;
        for (const ins of this.insects) {
          const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, ins.obj.x, ins.obj.y);
          if (d < bd) { bd = d; best = ins; }
        }
        if (best && bd <= (this.zone.bg ? 100 : 64)) this.tryCatchInsect(best);
        else toast('Không có côn trùng nào trong tầm vợt.', '🥅');
        break;
      }
      case 'axe':
        if (this.zone.id === 'farm') this.chopNearestTree();
        else toast('Cây gỗ nằm ở Nông trại.', '🪓');
        break;
      case 'shovel':
        if (this.mounds.length) this.digNearestMound();
        else toast('Đống đất chỉ có ở Nông trại và Bãi biển.', '🦯');
        break;
      default:
        toast('Nông cụ này sẽ dùng được trong bản cập nhật tới!', '🛠️');
    }
  }

  private plotCenter(i: number): { x: number; y: number } {
    const t = this.plotTiles[i];
    return t ? { x: t.x + FARM_PLOT.pw / 2, y: t.y + FARM_PLOT.ph / 2 } : { x: this.player.x, y: this.player.y };
  }

  private doTill(i: number) {
    this.busy = true;
    this.player.play('hoe', () => {
      this.busy = false;
      if (farming.till(i)) { const c = this.plotCenter(i); this.fxBurst(c.x, c.y, 0xb08850, 6); }
      this.refreshFarm();
    });
  }
  private doWater(i: number) {
    this.busy = true;
    this.player.play('water', () => {
      this.busy = false;
      if (farming.water(i)) { const c = this.plotCenter(i); this.fxBurst(c.x, c.y, 0x4aa5d9, 8); this.fxFloat(c.x, c.y - 8, '💧', '#74c0fc'); }
      this.refreshFarm();
    });
  }
  private doHarvest(i: number) {
    this.busy = true;
    const p = S.farm.plots[i];
    const crop = p?.crop ? CROPS[p.crop] : undefined;
    this.player.play('pickup', () => {
      this.busy = false;
      if (farming.harvest(i) && crop) {
        const c = this.plotCenter(i);
        this.fxBurst(c.x, c.y, 0xffe066, 12);
        this.fxFloatIcon(c.x, c.y - 10, 'crops', crop.row * 25 + crop.stages, `+${crop.name}`);
      }
      this.refreshFarm();
    });
  }

  travel(zoneId: string) {
    if (zoneId === this.zone.id || this.busy) return;
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
    const to = ZONES[zoneId];
    if (!to) return;
    // khu ngoài trời -> đích thật là map cổng của khu đó (trừ khi đang đứng ngay cổng ấy)
    const dest = (!to.indoor && !to.road && to.gate && this.zone.id !== to.gate) ? to.gate : zoneId;
    const destZone = ZONES[dest];
    // cần đi xe: đích là map cổng khác với cổng của khu hiện tại
    if (destZone.road && dest !== this.zone.gate && dest !== this.zone.id) {
      if (this.zone.road) {
        // đang đứng ở cổng có đường: xe đón tại trạm
        this.playDeparture(dest);
      } else {
        // đang trong khu/nhà: fade ra cổng khu mình rồi xe đón
        const own = this.zone.gate;
        if (!own) return;
        pendingDepart = dest;
        S.zone = own;
        save(true);
        this.stopFishing();
        this.cameras.main.fadeOut(200, 0, 0, 0);
        this.time.delayedCall(220, () => this.scene.restart());
      }
      return;
    }
    // đi bộ qua cổng/cửa: chỉ fade
    S.zone = dest;
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
    // map HD nhân vật to hơn -> đi nhanh hơn cho cân cảm giác
    const spd = (this.zone.bg ? 140 : 90) * (this.running ? 1.7 : 1) * (dt / 1000);
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
      // không đi xuống lòng đường (map cổng)
      if (this.zone.road) ny = Math.min(ny, this.roadTopY() - 10);
      // giới hạn đi lại trên nền ảnh (tường nhà / mép đường trong ảnh)
      if (this.zone.walkTop) ny = Math.max(ny, this.zone.walkTop * T);
      if (this.zone.walkBottom) ny = Math.min(ny, this.zone.walkBottom * T);
      if (!this.blockedAt(nx, ny)) { this.player.x = nx; this.player.y = ny; }
      else if (!this.blockedAt(nx, this.player.y)) this.player.x = nx;
      else if (!this.blockedAt(this.player.x, ny)) this.player.y = ny;
      const dir: Dir = Math.abs(dx) > Math.abs(dy) ? (dx > 0 ? 3 : 2) : (dy > 0 ? 0 : 1);
      this.player.setDir(dir);
      this.player.play('walk');
    } else if (!this.busy && this.player.current === 'walk') {
      this.player.play('idle');
    }
    // depth theo trục y để đứng sau/trước nhà cửa đúng lớp
    this.player.setDepth(this.player.y);
    this.player.tick(dt);
    this.followPet(dt);
    for (const { sprite } of this.npcs) sprite.tick(dt);
    for (const { sprite } of this.roamers) sprite.tick(dt);
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

    // bong bóng chat bám theo người chơi
    if (this.speech) {
      this.speech.setPosition(this.player.x, this.player.y - (this.zone.bg ? 104 : 54));
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
