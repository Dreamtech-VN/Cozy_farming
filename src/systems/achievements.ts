// ===== Hệ thống Thành tựu · Huy hiệu =====
// Cách chạy giống GunPow: thành tựu KHÔNG tự cộng thưởng, phải bấm "Nhận".
// Nhận xong mới cộng điểm thành tựu (◆), xu và danh hiệu. Điểm cộng dồn mở
// khoá huy hiệu, huy hiệu cộng thẳng chỉ số cho nhân vật.

import { S, save, addCoins, addStat } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { sfx } from '@/core/audio';
import { ACHS, BADGES, BADGE_MAX, badgeCost, ACH_TOTAL_POINT, achsOfCat, catTotal, type AchDef } from '@/data/achievements';
import { TITLES } from '@/data/quests';
import { EQUIP_SLOTS } from '@/data/equip';
import type { CharStats } from '@/core/types';

/** Vài chỉ số không do addStat cộng mà tính lại từ trạng thái hiện tại. */
function liveStat(key: string): number | undefined {
  switch (key) {
    case 'fish_species': return new Set(S.house?.aquarium ?? []).size;
    case 'skins_owned': return S.skins?.length ?? 0;
    case 'titles_owned': return S.player.titles?.length ?? 0;
    case 'gear_full': return EQUIP_SLOTS.filter(sl => S.equip?.[sl.id]).length;
    case 'level_up': return Math.max(0, S.player.level - 1);
    default: return undefined;
  }
}

export function progressOf(a: AchDef): number {
  const live = liveStat(a.stat);
  return Math.min(a.target, live ?? (S.stats?.[a.stat] ?? 0));
}
export function isDone(a: AchDef): boolean { return progressOf(a) >= a.target; }
export function isClaimed(a: AchDef): boolean { return !!S.achClaimed?.[a.id]; }
export function canClaim(a: AchDef): boolean { return isDone(a) && !isClaimed(a); }

/** Tổng điểm thành tựu ĐÃ nhận. */
export function achPoints(): number {
  if (!S.achClaimed) return 0;
  return ACHS.reduce((n, a) => n + (S.achClaimed[a.id] ? a.point : 0), 0);
}
/** Điểm đang chờ nhận. */
export function pendingPoints(): number {
  return ACHS.reduce((n, a) => n + (canClaim(a) ? a.point : 0), 0);
}
/** Điểm đã nhận trong một nhóm. */
export function catPoints(cat: string): number {
  return achsOfCat(cat).reduce((n, a) => n + (isClaimed(a) ? a.point : 0), 0);
}

export function claim(id: string): boolean {
  const a = ACHS.find(x => x.id === id);
  if (!a) return false;
  if (!isDone(a)) { toast('Chưa đạt điều kiện.', 'alert'); sfx.error(); return false; }
  if (isClaimed(a)) return false;
  if (!S.achClaimed) S.achClaimed = {};
  S.achClaimed[a.id] = true;
  if (a.coins) addCoins(a.coins);
  if (a.title && !S.player.titles.includes(a.title)) {
    S.player.titles.push(a.title);
    toast(`Mở khoá danh hiệu 【${TITLES[a.title]?.name ?? a.title}】`, 'rank');
  }
  addStat('ach_claimed');
  save(); bus.emit(EV.WALLET); bus.emit(EV.STATE_CHANGED);
  sfx.coin();
  toast(`Nhận thành tựu ${a.name}: +${a.point} điểm`, 'rank');
  return true;
}

/** Nhận hết những thành tựu đang đủ điều kiện. */
export function claimAll(): number {
  let n = 0;
  for (const a of ACHS) if (canClaim(a)) { if (claim(a.id)) n++; }
  if (!n) toast('Chưa có thành tựu nào để nhận.', 'alert');
  return n;
}

export function badgeLv(id: string): number { return S.badgeLv?.[id] ?? 0; }

/** Điểm thành tựu đã tiêu để nâng huy hiệu. */
export function achSpent(): number {
  let n = 0;
  for (const b of BADGES) for (let i = 0; i < badgeLv(b.id); i++) n += badgeCost(i);
  return n;
}
/** Điểm còn xài được ("Thành tựu còn" của GunPow). */
export function achLeft(): number { return achPoints() - achSpent(); }

export function upBadge(id: string): boolean {
  const b = BADGES.find(x => x.id === id);
  if (!b) return false;
  const lv = badgeLv(id);
  if (lv >= BADGE_MAX) { toast('Huy hiệu đã tối đa.', 'alert'); return false; }
  const cost = badgeCost(lv);
  if (achLeft() < cost) { toast(`Cần ${cost} điểm thành tựu.`, 'alert'); sfx.error(); return false; }
  if (!S.badgeLv) S.badgeLv = {};
  S.badgeLv[id] = lv + 1;
  save(); bus.emit(EV.STATE_CHANGED); sfx.coin();
  toast(`${b.name} lên Lv${lv + 1}.`, 'rank');
  return true;
}

/** Chỉ số cộng thêm từ huy hiệu. */
export function badgeStats(): CharStats {
  const out: CharStats = { health: 0, intellect: 0, strength: 0, agility: 0, charm: 0 };
  for (const b of BADGES) out[b.stat] += b.per * badgeLv(b.id);
  return out;
}

export { ACHS, BADGES, BADGE_MAX, badgeCost, ACH_TOTAL_POINT, achsOfCat, catTotal };
