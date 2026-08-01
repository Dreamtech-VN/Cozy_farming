import { S, save, toolLevel, itemCount, removeItem, addStat } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { sfx } from '@/core/audio';
import { TOOL_UPGRADES, toolUpgradeAt, TOOLS, type ToolUpgrade } from '@/data/tools';
import { item } from '@/data/items';

// ===== Nâng cấp công cụ =====
// Không phải cứ có xu là lên cấp: mỗi bậc còn đòi NGUYÊN LIỆU (gỗ từ chặt cây,
// đá từ đập đống đá) và có TỈ LỆ THÀNH CÔNG. Hỏng thì mất nguyên liệu + xu,
// cấp giữ nguyên — nhưng mỗi lần hỏng được cộng dồn 8% cho lần sau (tối đa
// +40%) để không ai xui đến mức kẹt mãi một bậc.

export const FAIL_BONUS = 0.08;
export const FAIL_BONUS_MAX = 0.4;

/** Số lần hỏng đã cộng dồn cho công cụ này. */
export function failStreak(tool: string): number {
  return S.stats[`upfail_${tool}`] ?? 0;
}

/** Tỉ lệ thành công thật sự của lần nâng tới (đã cộng dồn may mắn). */
export function upgradeRate(tool: string, next: ToolUpgrade): number {
  const base = next.rate ?? 1;
  const bonus = Math.min(FAIL_BONUS_MAX, failStreak(tool) * FAIL_BONUS);
  return Math.min(1, base + bonus);
}

/** Còn thiếu nguyên liệu gì (rỗng = đủ). */
export function missingMats(next: ToolUpgrade): { id: string; need: number; have: number }[] {
  return Object.entries(next.mats ?? {})
    .map(([id, need]) => ({ id, need, have: itemCount(id) }))
    .filter(m => m.have < m.need);
}

export interface UpgradeResult { ok: boolean; done?: boolean; msg?: string }

export function upgradeTool(tool: string): UpgradeResult {
  const lv = toolLevel(tool);
  if (lv <= 0) return { ok: false, msg: 'Chưa sở hữu công cụ này.' };
  const next = toolUpgradeAt(tool, lv + 1);
  if (!next) return { ok: false, msg: 'Công cụ đã ở cấp cao nhất.' };

  const miss = missingMats(next);
  if (miss.length) {
    const m = miss[0];
    toast(`Thiếu ${m.need - m.have} ${item(m.id).name.toLowerCase()}.`, 'inventory');
    sfx.error();
    return { ok: false };
  }
  if (S.wallet.coins < next.price) {
    toast(`Cần ${next.price} xu.`, 'coin'); sfx.error();
    return { ok: false };
  }

  // trừ chi phí trước — thành hay bại cũng mất
  S.wallet.coins -= next.price;
  for (const [id, n] of Object.entries(next.mats ?? {})) removeItem(id, n);

  const rate = upgradeRate(tool, next);
  const win = Math.random() < rate;
  if (win) {
    (S.tools as Record<string, number>)[tool] = next.level;
    S.stats[`upfail_${tool}`] = 0;
    addStat('tool_upgraded');
    sfx.coin();
    toast(`Nâng thành ${next.name}!`, 'rank');
  } else {
    S.stats[`upfail_${tool}`] = failStreak(tool) + 1;
    sfx.error();
    toast(`Nâng ${TOOLS[tool].name} hỏng mất rồi — lần sau dễ ăn hơn.`, 'alert');
  }
  save();
  bus.emit(EV.WALLET); bus.emit(EV.INVENTORY); bus.emit('hotbar:changed');
  bus.emit(EV.STATE_CHANGED);
  return { ok: true, done: win };
}

/** Danh sách công cụ có đường nâng cấp (dùng cho panel). */
export const UPGRADABLE = Object.keys(TOOL_UPGRADES);
