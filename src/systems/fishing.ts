import { S, save, addItem, addExp, addStat, equipTool, removeItem, itemCount } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { FISH_LIST, FISHES, RODS, RARITY_NAME, type FishDef } from '@/data/fish';
import { sfx } from '@/core/audio';

// ===== Câu cá =====

export function buyRod(tier: number): boolean {
  const rod = RODS.find(r => r.tier === tier);
  if (!rod || S.tools.rod >= tier) return false;
  if (S.wallet.coins < rod.price) { toast(`Cần ${rod.price} xu.`, 'coin'); sfx.error(); return false; }
  S.wallet.coins -= rod.price;
  S.tools.rod = tier;
  bus.emit(EV.WALLET); bus.emit(EV.STATE_CHANGED); save();
  toast(`Đã mua ${rod.name}!`, 'rod'); sfx.coin();
  equipTool('rod');
  return true;
}

// ===== Mồi câu =====
// Tự dùng mồi xịn nhất trong túi khi thả câu; trả hiệu ứng cho lượt câu này
const BAITS = ['bait_vip', 'bait_shrimp', 'bait_worm'];
let baitRareBonus = 0;
export function useBait(): { name: string; wait: number } | null {
  for (const id of BAITS) {
    if (itemCount(id) > 0) {
      removeItem(id);
      const def = ITEMS_BAIT[id];
      baitRareBonus = def.rare;
      return { name: def.name, wait: def.wait };
    }
  }
  baitRareBonus = 0;
  return null;
}
const ITEMS_BAIT: Record<string, { name: string; wait: number; rare: number }> = {
  bait_worm: { name: 'Mồi giun', wait: 0.7, rare: 0 },
  bait_shrimp: { name: 'Mồi tôm', wait: 0.6, rare: 0.1 },
  bait_vip: { name: 'Mồi thượng hạng', wait: 0.3, rare: 0.25 }
};

// Chọn ngẫu nhiên cá theo khu + độ hiếm (cần xịn + mồi tăng tỉ lệ hiếm)
export function rollFish(zone: string): FishDef | undefined {
  if (S.tools.rod <= 0) return undefined;
  const rodBonus = (RODS.find(r => r.tier === S.tools.rod)?.bonus ?? 0) + baitRareBonus;
  const pool = FISH_LIST.filter(f => f.zones.includes(zone) && f.minRod <= S.tools.rod);
  if (!pool.length) return undefined;
  const weight = (f: FishDef) =>
    f.rarity === 'common' ? 100 :
    f.rarity === 'rare' ? 25 * (1 + rodBonus * 2) :
    f.rarity === 'epic' ? 8 * (1 + rodBonus * 3) : 1.5 * (1 + rodBonus * 4);
  let total = 0;
  const acc = pool.map(f => (total += weight(f), total));
  const r = Math.random() * total;
  return pool[acc.findIndex(a => r <= a)];
}

export function landFish(fish: FishDef) {
  baitRareBonus = 0;
  addItem(fish.id);
  addExp(fish.rarity === 'legendary' ? 100 : fish.rarity === 'epic' ? 40 : fish.rarity === 'rare' ? 15 : 6);
  addStat('fish_caught'); addStat('daily_fish');
  if (!S.collections.fish.includes(fish.id)) {
    S.collections.fish.push(fish.id);
    S.stats['fish_species'] = S.collections.fish.length;
    bus.emit(EV.STAT, 'fish_species');
    toast(`Loài mới: ${fish.name} (${RARITY_NAME[fish.rarity]})!`, 'collection');
  }
  sfx.harvest(); save(); bus.emit(EV.STATE_CHANGED);
}

// Thả cá vào hồ trong nhà
export function addToAquarium(fishId: string): boolean {
  const hasTank = S.house.furniture.some(f => f.itemId.startsWith('aquarium'));
  if (!hasTank) { toast('Cần đặt Hồ cá trong nhà trước.', 'fish'); return false; }
  const cap = S.house.furniture.some(f => f.itemId === 'aquarium_big') ? 8 : 3;
  if (S.house.aquarium.length >= cap) { toast('Hồ cá đầy rồi!'); return false; }
  if (!S.inventory[fishId]) return false;
  S.inventory[fishId]--;
  if (S.inventory[fishId] <= 0) delete S.inventory[fishId];
  S.house.aquarium.push(fishId);
  bus.emit(EV.INVENTORY); bus.emit(EV.HOUSE); save();
  toast(`Đã thả ${FISHES[fishId]?.name ?? 'cá'} vào hồ.`, 'fish');
  return true;
}
