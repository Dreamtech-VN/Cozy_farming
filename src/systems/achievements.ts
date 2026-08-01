// ===== Hệ thống Thành tựu =====
// Thành tựu KHÔNG tự cộng thưởng, phải bấm "Nhận". Nhận xong mới ăn xu và
// danh hiệu. Tiến độ đếm theo SỐ thành tựu, không còn điểm đổi huy hiệu.

import { S, save, addCoins, addStat } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { sfx } from '@/core/audio';
import { ACHS, ACH_TOTAL, achsOfCat, catTotal, type AchDef } from '@/data/achievements';
import { TITLES } from '@/data/quests';

/** Vài chỉ số không do addStat cộng mà tính lại từ trạng thái hiện tại. */
function liveStat(key: string): number | undefined {
  switch (key) {
    case 'fish_species': return new Set(S.house?.aquarium ?? []).size;
    case 'skins_owned': return S.skins?.length ?? 0;
    case 'titles_owned': return S.player.titles?.length ?? 0;
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

/** Số thành tựu ĐÃ nhận. */
export function achDone(): number {
  if (!S.achClaimed) return 0;
  return ACHS.reduce((n, a) => n + (S.achClaimed[a.id] ? 1 : 0), 0);
}
/** Số thành tựu đang chờ bấm nhận. */
export function pendingCount(): number {
  return ACHS.reduce((n, a) => n + (canClaim(a) ? 1 : 0), 0);
}
/** Số thành tựu đã nhận trong một nhóm. */
export function catDone(cat: string): number {
  return achsOfCat(cat).reduce((n, a) => n + (isClaimed(a) ? 1 : 0), 0);
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
  toast(`Nhận thành tựu ${a.name}!`, 'rank');
  return true;
}

/** Nhận hết những thành tựu đang đủ điều kiện. */
export function claimAll(): number {
  let n = 0;
  for (const a of ACHS) if (canClaim(a)) { if (claim(a.id)) n++; }
  if (!n) toast('Chưa có thành tựu nào để nhận.', 'alert');
  return n;
}

export { ACHS, ACH_TOTAL, achsOfCat, catTotal };
