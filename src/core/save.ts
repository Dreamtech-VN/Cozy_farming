import type { GameState } from './types';
import { bus, EV, toast } from './events';

const KEY = 'cozy_farming_save_v1';
const VERSION = 1;

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
      title: 'title_newbie', titles: ['title_newbie'], badges: [],
      createdAt: Date.now()
    },
    wallet: { coins: 500, rubies: 10 },
    inventory: { seed_carrot: 5 },
    wardrobe: ['hair:bob', 'clothes:basic'],
    chibiWardrobe: [],
    pets: [],
    skins: [],
    hotbar: ['hoe', 'can', '', '', ''],
    tools: { rod: 0, can: 1, hoe: 1, net: 0, basket: 0 },
    farm: { unlocked: 6, plots: [] },
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
    garage: [],
    vehicle: '',
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
  return (S.inventory[`tool_${id}`] ?? 0) > 0 ? 1 : 0;
}

// Gắn đồ cầm tay (part Avatar) xuống ô trang bị
export function equipHandItem(partId: number): boolean {
  const key = `hand:${partId}`;
  if (S.hotbar.includes(key)) { toast('Món này đã nằm trên thanh trang bị rồi.', '🖐️'); return false; }
  let i = S.hotbar.findIndex(t => !t);
  if (i < 0) i = S.hotbar.length - 1;
  S.hotbar[i] = key;
  save();
  bus.emit('hotbar:changed');
  toast('Đã đưa xuống ô trang bị — bấm vào ô để cầm lên tay!', '🖐️');
  return true;
}

// Cầm / cất đồ trên tay
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
  if (S.hotbar.includes(id)) { toast('Nông cụ này đã nằm trên thanh rồi.', '🛠️'); return false; }
  let i = S.hotbar.findIndex(t => !t);
  if (i < 0) i = S.hotbar.length - 1;   // hết chỗ -> thay ô cuối
  S.hotbar[i] = id;
  save();
  bus.emit('hotbar:changed');
  toast('Đã gắn lên thanh nông cụ!', '🛠️');
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
    if (!S.skins) S.skins = [];
    if (!S.pets) S.pets = S.farm?.hasDog ? ['dog'] : [];   // save cũ có chó -> chuyển sang hệ thú cưng
    if (S.tools.basket === undefined) S.tools.basket = (S.inventory['tool_basket'] ?? 0) > 0 ? 1 : 0;
    if (!S.hotbar) S.hotbar = ['hoe', 'can', '', '', ''];
    while (S.hotbar.length < 5) S.hotbar.push('');
    S.hotbar = S.hotbar.map(id => ownedTool(id) ? id : '');
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
  if (!canAfford(coins, rubies)) { toast('Không đủ tiền!', '💰'); return false; }
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
    toast(`Lên cấp ${S.player.level}!`, '⭐');
    addStat('level_up');
  }
  bus.emit(EV.STATE_CHANGED); save();
}

export function todayStr(): string {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
}
