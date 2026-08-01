import { S, save, addItem, itemCount, removeItem, addStat, STAT_KEYS } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { sfx } from '@/core/audio';
import type { CharStats, StatKey } from '@/core/types';
import { equipStats } from '@/data/chibi';
import {
  EQUIP_SLOTS, SLOT_OF, equipDef, enhanceMul, enhanceRate, enhanceCost,
  dropsOnFail, MAX_ENHANCE, ENHANCE_STONE, type EquipSlot, type EquipDef
} from '@/data/equip';

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
export function pieceStats(def: EquipDef, lv: number): CharStats {
  const s = SLOT_OF[def.slot];
  const out = zeroStats();
  const m = enhanceMul(lv);
  out[s.main] += Math.round(def.main * m);
  out[s.sub] += Math.round(def.sub * m);
  return out;
}

/** Tổng chỉ số từ toàn bộ trang bị đang đeo. */
export function equipTotal(): CharStats {
  const total = zeroStats();
  for (const p of worn()) {
    const s = pieceStats(p.def, p.lv);
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
  for (const p of worn()) cp += p.lv * 12;
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
    enhance: worn().reduce((n, p) => n + p.lv * 12, 0)
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

/** Mua trang bị (bằng xu — lượng là tiền nạp, chỉ cho gacha / skin giới hạn). */
export function buyEquip(id: string): boolean {
  const def = equipDef(id);
  if (!def) return false;
  if (S.wallet.coins < def.price) { toast(`Cần ${def.price} xu.`, 'coin'); sfx.error(); return false; }
  S.wallet.coins -= def.price;
  S.equipBag.push(id);
  save(); bus.emit(EV.WALLET); bus.emit(EV.STATE_CHANGED);
  toast(`Đã mua ${def.name}!`, 'shop'); sfx.coin();
  return true;
}

/** Đá cường hoá — vật phẩm dùng để đập đồ. */
export function addStones(n: number) { addItem(ENHANCE_STONE, n); }
