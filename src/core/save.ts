import type { GameState, StatKey } from './types';
import { ZONES } from '@/data/zones';
import { bus, EV, toast } from './events';
import { migrateBagToStore } from '@/systems/farmstore';
import { migrateHandItems } from '@/data/handitems';

const KEY = 'cozy_farming_save_v1';
const VERSION = 1;
export const HOTBAR_SLOTS = 5;
// ô cuối cùng dành riêng cho cần câu — chưa có cần thì cứ để trống
export const ROD_SLOT = HOTBAR_SLOTS - 1;

export function defaultState(): GameState {
  return {
    version: VERSION,
    player: {
      name: '',
      gender: 'male',
      appearance: {
        charIndex: 0, hairStyle: 'bob', hairColor: 0, eyesColor: 0,
        clothes: 'basic', clothesColor: 0, acc: []
      },
      level: 1, exp: 0,
      charStats: { health: 5, intellect: 5, strength: 5, agility: 5, charm: 5 },
      statPoints: 0,
      title: 'title_newbie', titles: ['title_newbie'], badges: [],
      createdAt: Date.now()
    },
    wallet: { farmCoins: 0, coins: 500, rubies: 10 },
    inventory: {},
    wardrobe: ['hair:bob', 'clothes:basic'],
    chibiWardrobe: [],
    pets: [],
    skins: [],
    hotbar: ['hoe', 'axe', 'can', 'basket', ''],
    tools: { rod: 0, can: 1, hoe: 1, net: 0, basket: 1, axe: 1 },
    farm: { unlocked: 6, plots: [] },
    farmStore: { seeds: { carrot: 5 }, produce: {}, fert: {} },
    orders: [],
    fishfarm: [],
    livestock: { barnLevel: 0, animals: [] },
    house: { owned: false, level: 0, wallpaper: 0, floor: 0, furniture: [], aquarium: [] },
    collections: { fish: [], insects: [], crops: [] },
    quests: { active: {}, completed: [], claimed: [] },
    achievements: [],
    stats: {},
    social: { friends: [], blocked: [], reported: [] },
    mail: [],
    daily: {
      lastLoginDate: '', streak: 0, loginClaimed: false,
      checkinDays: [], checkinMonth: '', wheelDate: '', wheelSpins: 0,
      dailyQuestDate: '', dailyQuests: []
    },
    minigames: { caroWins: 0, xiangqiWins: 0, rpsWins: 0 },
    settings: { music: true, sfx: true },
    zone: 'farm',
    clockOffset: 0
  };
}

// Trạng thái toàn cục — mọi hệ thống đọc/ghi qua biến này
export let S: GameState = defaultState();

export function hasSave(): boolean {
  return !!localStorage.getItem(KEY);
}

// Nông cụ đã sở hữu chưa: cuốc/bình tưới có sẵn cấp 1, cần/vợt mua theo cấp,
// giỏ/rìu/xẻng là vật phẩm mua ở bách hóa (nằm trong túi đồ)
export function ownedTool(id: string): boolean {
  return toolLevel(id) > 0;
}

// Cấp hiện tại của nông cụ (0 = chưa sở hữu)
export function toolLevel(id: string): number {
  if (!id) return 0;
  if (id === 'hoe') return S.tools.hoe;
  if (id === 'can') return S.tools.can;
  if (id === 'rod') return S.tools.rod;
  if (id === 'net') return S.tools.net;
  if (id === 'basket') return Math.max(S.tools.basket, (S.inventory['tool_basket'] ?? 0) > 0 ? 1 : 0);
  // rìu được phát sẵn khi tạo nhân vật nên phải đọc cả S.tools, không chỉ túi đồ
  if (id === 'axe') return Math.max(S.tools.axe, (S.inventory['tool_axe'] ?? 0) > 0 ? 1 : 0);
  // rìu được phát sẵn khi tạo nhân vật nên phải đọc cả S.tools, không chỉ túi đồ
  if (id === 'axe') return Math.max(S.tools.axe, (S.inventory['tool_axe'] ?? 0) > 0 ? 1 : 0);
  return (S.inventory[`tool_${id}`] ?? 0) > 0 ? 1 : 0;
}

// Cầm / cất đồ trên tay
// ===== Nông cụ đang cầm =====
// Muốn cuốc/tưới/thu hoạch thì phải chọn đúng nông cụ ở thanh trang bị trước.
// Không lưu vào save — mỗi lần vào game tự chọn lại.
let _heldTool = '';
export function heldTool(): string { return _heldTool; }
export function selectTool(id: string): void {
  _heldTool = _heldTool === id ? '' : id;
  bus.emit('hotbar:changed');
}

export function toggleHand(partId: number) {
  if (!S.player.chibi) return;
  const now = S.player.chibi.hand ?? 0;
  S.player.chibi.hand = now === partId ? 0 : partId;
  save();
  bus.emit(EV.APPEARANCE);
}

// Gắn nông cụ vào ô trống đầu tiên trên thanh (đã có thì thôi)
export function equipTool(id: string): boolean {
  if (!ownedTool(id)) return false;
  if (S.hotbar.includes(id)) { toast('Nông cụ này đã nằm trên thanh rồi.', 'hoe'); return false; }
  // cần câu có ô riêng ở cuối thanh; nông cụ khác chỉ dùng các ô trước đó
  if (id === 'rod') { S.hotbar[ROD_SLOT] = id; }
  else {
    let i = S.hotbar.findIndex((t, k) => !t && k < ROD_SLOT);
    if (i < 0) i = ROD_SLOT - 1;        // hết chỗ -> thay ô cuối trước ô cần câu
    S.hotbar[i] = id;
  }
  save();
  bus.emit('hotbar:changed');
  toast('Đã gắn lên thanh nông cụ!', 'hoe');
  return true;
}

export function unequipTool(slot: number) {
  if (S.hotbar[slot]) {
    S.hotbar[slot] = '';
    save();
    bus.emit('hotbar:changed');
  }
}

export function load(): boolean {
  const raw = localStorage.getItem(KEY);
  if (!raw) return false;
  try {
    const data = JSON.parse(raw) as GameState;
    // chỗ migrate giữa các version save về sau
    S = { ...defaultState(), ...data };
    if (!S.chibiWardrobe) S.chibiWardrobe = [];
    if (S.wallet.farmCoins === undefined) S.wallet.farmCoins = 0;
    // save cũ để đồ cầm tay trong túi -> chuyển vào tủ quần áo (như Lttt)
    migrateHandItems(S.inventory, S.chibiWardrobe);
    if (!S.skins) S.skins = [];
    if (!S.pets) S.pets = S.farm?.hasDog ? ['dog'] : [];   // save cũ có chó -> chuyển sang hệ thú cưng
    if (S.tools.basket === undefined) S.tools.basket = (S.inventory['tool_basket'] ?? 0) > 0 ? 1 : 0;
    if (!S.player.charStats) S.player.charStats = { health: 5, intellect: 5, strength: 5, agility: 5, charm: 5 };
    if (S.player.statPoints == null) S.player.statPoints = 0;
    if (!S.hotbar) S.hotbar = ['hoe', 'axe', 'can', 'basket', ''];
    // save cũ 5 ô -> nới lên 10 ô, tặng luôn rìu/xẻng cho đủ bộ khởi đầu
    if (S.tools.axe === undefined) S.tools.axe = 1;
    // save cũ có 10 ô: giữ lại các món ở 4 ô đầu, ô cuối để dành cho cần câu
    S.hotbar = S.hotbar.filter(id => id && id !== 'rod').slice(0, ROD_SLOT);
    while (S.hotbar.length < ROD_SLOT) S.hotbar.push('');
    S.hotbar.push(toolLevel('rod') > 0 ? 'rod' : '');
    S.hotbar = S.hotbar.map(id => ownedTool(id) ? id : '');
    // save cũ để hạt/nông sản/phân trong túi -> chuyển sang kho nông trại
    if (!S.farmStore) S.farmStore = { seeds: {}, produce: {}, fert: {} };
    migrateBagToStore();
    // save cũ còn đứng ở map cổng (đã bỏ) -> đưa về nông trại
    if (!ZONES[S.zone]) S.zone = 'farm';
    if (!S.orders) S.orders = [];
    if (!S.fishfarm) S.fishfarm = [];
    return true;
  } catch {
    return false;
  }
}

let saveTimer: number | undefined;
export function save(immediate = false) {
  if (immediate) {
    localStorage.setItem(KEY, JSON.stringify(S));
    return;
  }
  // gộp nhiều thay đổi liên tiếp thành 1 lần ghi
  if (saveTimer) window.clearTimeout(saveTimer);
  saveTimer = window.setTimeout(() => localStorage.setItem(KEY, JSON.stringify(S)), 400);
}

export function resetSave() {
  localStorage.removeItem(KEY);
  S = defaultState();
}

// ===== Helpers dùng chung =====

// Tiền bán nông sản vào tài khoản nông trại (Lttt), ra ATM mới rút được
export function addFarmCoins(n: number) {
  S.wallet.farmCoins = Math.max(0, (S.wallet.farmCoins ?? 0) + n);
  bus.emit(EV.WALLET); save();
}

export function withdrawFarm(n?: number): number {
  const take = Math.min(S.wallet.farmCoins ?? 0, n ?? (S.wallet.farmCoins ?? 0));
  if (take <= 0) return 0;
  S.wallet.farmCoins -= take;
  S.wallet.coins += take;
  S.stats['coins_earned'] = (S.stats['coins_earned'] ?? 0) + take;
  bus.emit(EV.WALLET); save(true);
  return take;
}

export function addCoins(n: number) {
  S.wallet.coins = Math.max(0, S.wallet.coins + n);
  bus.emit(EV.WALLET); save();
}
export function addRubies(n: number) {
  S.wallet.rubies = Math.max(0, S.wallet.rubies + n);
  bus.emit(EV.WALLET); save();
}
export function canAfford(coins: number, rubies = 0): boolean {
  return S.wallet.coins >= coins && S.wallet.rubies >= rubies;
}
export function spend(coins: number, rubies = 0): boolean {
  if (!canAfford(coins, rubies)) { toast('Không đủ tiền!', 'coin'); return false; }
  S.wallet.coins -= coins; S.wallet.rubies -= rubies;
  bus.emit(EV.WALLET); save();
  return true;
}

export function addItem(itemId: string, qty = 1) {
  S.inventory[itemId] = (S.inventory[itemId] ?? 0) + qty;
  if (S.inventory[itemId] <= 0) delete S.inventory[itemId];
  bus.emit(EV.INVENTORY); save();
}
export function itemCount(itemId: string): number {
  return S.inventory[itemId] ?? 0;
}
export function removeItem(itemId: string, qty = 1): boolean {
  if (itemCount(itemId) < qty) return false;
  addItem(itemId, -qty);
  return true;
}

// Cộng chỉ số thống kê -> hệ thống nhiệm vụ/thành tựu lắng nghe
export function addStat(key: string, n = 1) {
  S.stats[key] = (S.stats[key] ?? 0) + n;
  bus.emit(EV.STAT, key); save();
}

export function addExp(n: number) {
  S.player.exp += n;
  const need = () => S.player.level * 100;
  while (S.player.exp >= need()) {
    S.player.exp -= need();
    S.player.level++;
    S.player.statPoints += 3;
    toast(`Lên cấp ${S.player.level}! (+3 điểm chỉ số)`, 'rank');
    addStat('level_up');
  }
  bus.emit(EV.STATE_CHANGED); save();
}

export const STAT_NAMES: Record<StatKey, string> = {
  health: 'Sức khỏe', intellect: 'Trí tuệ', strength: 'Sức mạnh',
  agility: 'Nhanh nhẹn', charm: 'Quyến rũ'
};
export const STAT_ICONS: Record<StatKey, string> = {
  health: '❤️', intellect: '📘', strength: '💪', agility: '⚡', charm: '✨'
};
export const STAT_KEYS: StatKey[] = ['health', 'intellect', 'strength', 'agility', 'charm'];

export function allocateStat(key: StatKey, n = 1): boolean {
  if (S.player.statPoints < n) return false;
  S.player.charStats[key] += n;
  S.player.statPoints -= n;
  bus.emit(EV.STATE_CHANGED); save();
  return true;
}

export function todayStr(): string {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
}
