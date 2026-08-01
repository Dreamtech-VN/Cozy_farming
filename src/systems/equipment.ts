import { S, save, addItem, itemCount, removeItem, addStat, STAT_KEYS } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { sfx } from '@/core/audio';
import type { CharStats, StatKey } from '@/core/types';
import { equipStats } from '@/data/chibi';
import {
  EQUIP_SLOTS, EQUIP_LIST, SLOT_OF, equipDef, enhanceMul, enhanceRate, enhanceCost,
  dropsOnFail, MAX_ENHANCE, ENHANCE_STONE, MAX_STAR, starMul, starCost, starRate,
  gemDef, gemMergeTo, gemPower, GEM_MERGE_N, type EquipSlot, type EquipDef
} from '@/data/equip';
import { item } from '@/data/items';

// ===== Trang bị: mặc / cởi / đập =====
// S.equip     : ô nào đang đeo món nào  { ring: 'ring_003', ... }
// S.equipLv   : cấp đập của từng món    { ring_003: 7 }
// S.equipBag  : mấy món đang có trong túi trang bị

export interface WornPiece { slot: EquipSlot; def: EquipDef; lv: number }

function zeroStats(): CharStats {
  return { health: 0, intellect: 0, strength: 0, agility: 0, charm: 0 };
}

export function equipLevel(id: string): number {
  return S.equipLv?.[id] ?? 0;
}

export function worn(): WornPiece[] {
  const out: WornPiece[] = [];
  for (const s of EQUIP_SLOTS) {
    const id = S.equip?.[s.id];
    const def = equipDef(id);
    if (def) out.push({ slot: s.id, def, lv: equipLevel(def.id) });
  }
  return out;
}

/** Chỉ số của một món ở cấp đập hiện tại. */
export function pieceStats(def: EquipDef, lv: number, star = 0, gems: string[] = []): CharStats {
  const s = SLOT_OF[def.slot];
  const out = zeroStats();
  const m = enhanceMul(lv) * starMul(star);
  out[s.main] += Math.round(def.main * m);
  out[s.sub] += Math.round(def.sub * m);
  for (const gid of gems) {
    const g = gemDef(gid);
    if (g) out[g.stat] += gemPower(g);
  }
  return out;
}

/** Tổng chỉ số từ toàn bộ trang bị đang đeo. */
export function equipTotal(): CharStats {
  const total = zeroStats();
  for (const p of worn()) {
    const s = pieceStats(p.def, p.lv, equipStar(p.def.id), gemsOn(p.def.id));
    for (const k of STAT_KEYS) total[k] += s[k];
  }
  return total;
}

// ===== Lực chiến =====
// Gộp chỉ số gốc + quần áo + trang bị, cộng thêm phần thưởng theo cấp nhân vật.
// Trọng số cho mỗi loại chỉ số khác nhau một chút để không món nào vô dụng.
const CP_WEIGHT: Record<StatKey, number> = {
  health: 9, strength: 9, agility: 8, intellect: 7, charm: 6
};

export function combatPower(): number {
  const look = S.player.chibi;
  const cloth = look ? equipStats(look) : zeroStats();
  const eq = equipTotal();
  let cp = 0;
  for (const k of STAT_KEYS) {
    cp += (S.player.charStats[k] + cloth[k] + eq[k]) * CP_WEIGHT[k];
  }
  cp += S.player.level * 25;
  // mỗi cấp đập cộng thêm một ít cho thấy công đập không phí
  for (const p of worn()) cp += p.lv * 12 + equipStar(p.def.id) * 40;
  return Math.round(cp);
}

/** Lực chiến tách theo nguồn — để hiện bảng chi tiết. */
export function cpBreakdown() {
  const look = S.player.chibi;
  const cloth = look ? equipStats(look) : zeroStats();
  const eq = equipTotal();
  const w = (s: CharStats) => STAT_KEYS.reduce((n, k) => n + s[k] * CP_WEIGHT[k], 0);
  return {
    base: Math.round(w(S.player.charStats)),
    clothes: Math.round(w(cloth)),
    equip: Math.round(w(eq)),
    level: S.player.level * 25,
    enhance: worn().reduce((n, p) => n + p.lv * 12 + equipStar(p.def.id) * 40, 0)
  };
}

// ===== Mặc / cởi =====
export function equipPiece(id: string): boolean {
  const def = equipDef(id);
  if (!def) return false;
  if (!S.equipBag.includes(id)) { toast('Món này không có trong túi trang bị.', 'inventory'); return false; }
  const old = S.equip[def.slot];
  S.equip[def.slot] = id;
  S.equipBag = S.equipBag.filter(x => x !== id);
  if (old) S.equipBag.push(old);
  save(); bus.emit(EV.STATE_CHANGED);
  sfx.click();
  toast(`Đã đeo ${def.name}.`, 'wardrobe');
  return true;
}

export function unequipPiece(slot: EquipSlot): boolean {
  const id = S.equip[slot];
  if (!id) return false;
  S.equip[slot] = '';
  S.equipBag.push(id);
  save(); bus.emit(EV.STATE_CHANGED);
  return true;
}

/** Tự chọn món mạnh nhất cho mỗi ô (nút "Mặc tối ưu"). */
export function autoEquip(): number {
  let n = 0;
  for (const s of EQUIP_SLOTS) {
    const cand = [S.equip[s.id], ...S.equipBag]
      .map(equipDef).filter((d): d is EquipDef => !!d && d.slot === s.id);
    if (!cand.length) continue;
    const best = cand.reduce((a, b) => {
      const va = a.tier * 10 + equipLevel(a.id);
      const vb = b.tier * 10 + equipLevel(b.id);
      return vb > va ? b : a;
    });
    if (S.equip[s.id] !== best.id) {
      const old = S.equip[s.id];
      S.equipBag = S.equipBag.filter(x => x !== best.id);
      if (old) S.equipBag.push(old);
      S.equip[s.id] = best.id;
      n++;
    }
  }
  if (n) { save(); bus.emit(EV.STATE_CHANGED); toast(`Đã mặc tối ưu ${n} món.`, 'wardrobe'); sfx.coin(); }
  else toast('Đang mặc bộ tốt nhất rồi.', 'wardrobe');
  return n;
}

// ===== Đập trang bị =====
export interface SmashResult { ok: boolean; win?: boolean; lv?: number }

export function smash(id: string): SmashResult {
  const def = equipDef(id);
  if (!def) return { ok: false };
  const lv = equipLevel(id);
  if (lv >= MAX_ENHANCE) { toast('Món này đã đập tới cấp tối đa.', 'alert'); return { ok: false }; }

  const cost = enhanceCost(def, lv);
  if (itemCount(ENHANCE_STONE) < cost.stones) {
    toast(`Thiếu ${cost.stones - itemCount(ENHANCE_STONE)} đá cường hoá.`, 'inventory');
    sfx.error(); return { ok: false };
  }
  if (S.wallet.coins < cost.coins) { toast(`Cần ${cost.coins} xu.`, 'coin'); sfx.error(); return { ok: false }; }

  S.wallet.coins -= cost.coins;
  removeItem(ENHANCE_STONE, cost.stones);

  const win = Math.random() < enhanceRate(lv);
  if (!S.equipLv) S.equipLv = {};
  if (win) {
    S.equipLv[id] = lv + 1;
    addStat('equip_smashed');
    sfx.coin();
    toast(`${def.name} lên +${lv + 1}!`, 'rank');
  } else if (dropsOnFail(lv)) {
    S.equipLv[id] = Math.max(0, lv - 1);
    sfx.error();
    toast(`Đập hỏng — ${def.name} tụt về +${Math.max(0, lv - 1)}.`, 'alert');
  } else {
    sfx.error();
    toast('Đập hỏng, cấp giữ nguyên.', 'alert');
  }
  save();
  bus.emit(EV.WALLET); bus.emit(EV.INVENTORY); bus.emit(EV.STATE_CHANGED);
  return { ok: true, win, lv: S.equipLv[id] };
}

// ===== Nguồn trang bị: MỞ RƯƠNG, không bán thẳng =====
// GunPow không cho mua trang bị ở shop — đồ ra từ rương. Bên mình cũng vậy:
// rương rơi ra khi làm nông (đào đất, câu cá, hoàn thành đơn) hoặc đổi bằng xu
// ở Bách hóa, mở ra được 1 món ngẫu nhiên trong khoảng bậc của rương.
export interface ChestDef { id: string; name: string; lo: number; hi: number; price: number }
export const EQUIP_CHESTS: ChestDef[] = [
  { id: 'chest_eq1', name: 'Rương trang bị Sơ cấp', lo: 1, hi: 6, price: 3000 },
  { id: 'chest_eq2', name: 'Rương trang bị Trung cấp', lo: 5, hi: 12, price: 15000 },
  { id: 'chest_eq3', name: 'Rương trang bị Cao cấp', lo: 11, hi: 20, price: 60000 }
];
export function chestDef(id: string) { return EQUIP_CHESTS.find(c => c.id === id); }

/** Mở 1 rương -> nhận 1 món ngẫu nhiên (mọi ô, bậc trong khoảng của rương). */
export function openChest(chestId: string, quiet = false): EquipDef | undefined {
  const c = chestDef(chestId);
  if (!c) return undefined;
  if (itemCount(chestId) <= 0) { toast('Không có rương này.', 'inventory'); sfx.error(); return undefined; }
  const pool = EQUIP_LIST.filter(e => e.tier >= c.lo && e.tier <= c.hi);
  if (!pool.length) return undefined;
  removeItem(chestId, 1);
  const got = pool[Math.floor(Math.random() * pool.length)];
  S.equipBag.push(got.id);
  addStat('chest_opened');
  save(); bus.emit(EV.INVENTORY); bus.emit(EV.STATE_CHANGED);
  if (!quiet) { sfx.coin(); toast(`Mở rương được ${got.name}!`, 'rank'); }
  return got;
}

/** Rơi rương khi làm việc đồng áng — gọi từ WorldScene/hệ thống khác. */
export function rollChestDrop(chance = 0.04) {
  if (Math.random() > chance) return;
  const r = Math.random();
  const id = r < 0.7 ? 'chest_eq1' : r < 0.95 ? 'chest_eq2' : 'chest_eq3';
  addItem(id, 1);
  toast(`Nhặt được ${chestDef(id)!.name}!`, 'gift');
}

/** Đá cường hoá — vật phẩm dùng để đập đồ. */
export function addStones(n: number) { addItem(ENHANCE_STONE, n); }

// ===== Nâng sao =====
export function equipStar(id: string): number { return S.equipStar?.[id] ?? 0; }

export function upStar(id: string): { ok: boolean; win?: boolean } {
  const def = equipDef(id); if (!def) return { ok: false };
  const st = equipStar(id);
  if (st >= MAX_STAR) { toast('Món này đã đủ 5 sao.', 'alert'); return { ok: false }; }
  const c = starCost(def, st);
  if (itemCount(c.kind) < c.n) {
    toast(`Thiếu ${c.n - itemCount(c.kind)} ${item(c.kind).name}.`, 'inventory'); sfx.error();
    return { ok: false };
  }
  if (S.wallet.coins < c.coins) { toast(`Cần ${c.coins} xu.`, 'coin'); sfx.error(); return { ok: false }; }
  S.wallet.coins -= c.coins;
  removeItem(c.kind, c.n);
  const win = Math.random() < starRate(st);
  if (!S.equipStar) S.equipStar = {};
  if (win) {
    S.equipStar[id] = st + 1;
    addStat('equip_starred'); sfx.coin();
    toast(`${def.name} lên ${st + 1} sao!`, 'rank');
  } else { sfx.error(); toast('Nâng sao thất bại — sao giữ nguyên.', 'alert'); }
  save(); bus.emit(EV.WALLET); bus.emit(EV.INVENTORY); bus.emit(EV.STATE_CHANGED);
  return { ok: true, win };
}

// ===== Gắn đá =====
export function gemsOn(id: string): string[] {
  const def = equipDef(id);
  const arr = (S.equipGems?.[id] ?? []).slice(0, def?.sockets ?? 0);
  while (def && arr.length < def.sockets) arr.push('');
  return arr;
}
export function gemCount(gid: string): number { return S.gemBag?.[gid] ?? 0; }
export function addGem(gid: string, n = 1) {
  if (!S.gemBag) S.gemBag = {};
  S.gemBag[gid] = (S.gemBag[gid] ?? 0) + n;
  save(); bus.emit(EV.STATE_CHANGED);
}

export function socketGem(id: string, slotIdx: number, gid: string): boolean {
  const def = equipDef(id); if (!def || slotIdx >= def.sockets) return false;
  if (gemCount(gid) <= 0) { toast('Không còn viên đá này.', 'inventory'); return false; }
  const arr = gemsOn(id);
  const old = arr[slotIdx];
  arr[slotIdx] = gid;
  S.gemBag[gid] -= 1;
  if (S.gemBag[gid] <= 0) delete S.gemBag[gid];
  if (old) addGem(old);                  // gỡ viên cũ về túi
  if (!S.equipGems) S.equipGems = {};
  S.equipGems[id] = arr;
  save(); bus.emit(EV.STATE_CHANGED); sfx.coin();
  toast(`Đã gắn ${gemDef(gid)?.name}.`, 'rank');
  return true;
}

export function unsocketGem(id: string, slotIdx: number): boolean {
  const arr = gemsOn(id);
  const gid = arr[slotIdx];
  if (!gid) return false;
  arr[slotIdx] = '';
  S.equipGems[id] = arr;
  addGem(gid);
  save(); bus.emit(EV.STATE_CHANGED);
  return true;
}

/** Ghép 3 viên cùng loại cùng cấp thành 1 viên cấp trên. */
export function mergeGem(gid: string): boolean {
  const g = gemDef(gid); if (!g) return false;
  const to = gemMergeTo(g);
  if (!to) { toast('Đá đã ở cấp cao nhất.', 'alert'); return false; }
  if (gemCount(gid) < GEM_MERGE_N) {
    toast(`Cần ${GEM_MERGE_N} viên ${g.name} để ghép.`, 'inventory'); sfx.error(); return false;
  }
  S.gemBag[gid] -= GEM_MERGE_N;
  if (S.gemBag[gid] <= 0) delete S.gemBag[gid];
  addGem(to.id);
  sfx.coin(); toast(`Ghép thành ${to.name}!`, 'rank');
  return true;
}

/** Cường hoá liên tục (nút "1 chạm" của GunPow): đập tới khi hết tài nguyên. */
export function smashUntil(id: string, maxTry = 30): { tries: number; up: number } {
  let tries = 0, up = 0;
  const start = equipLevel(id);
  for (let i = 0; i < maxTry; i++) {
    const lv = equipLevel(id);
    if (lv >= MAX_ENHANCE) break;
    const def = equipDef(id); if (!def) break;
    const c = enhanceCost(def, lv);
    if (itemCount(ENHANCE_STONE) < c.stones || S.wallet.coins < c.coins) break;
    smash(id); tries++;
  }
  up = equipLevel(id) - start;
  if (!tries) toast('Không đủ xu hoặc đá cường hoá.', 'coin');
  return { tries, up };
}

/** Mở nhiều rương một lượt (trang mở rương có nút -10/+10 như GunPow). */
export function openChestMany(chestId: string, n: number): EquipDef[] {
  const out: EquipDef[] = [];
  for (let i = 0; i < n; i++) {
    const g = openChest(chestId, true);
    if (!g) break;
    out.push(g);
  }
  return out;
}
