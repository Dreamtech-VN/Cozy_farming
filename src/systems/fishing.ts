import { S, save, addItem, addExp, addStat, equipTool, removeItem, itemCount } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { FISH_LIST, FISHES, RODS, RARITY_NAME, type FishDef } from '@/data/fish';
import { sfx } from '@/core/audio';

// ===== Câu cá =====

export function buyRod(tier: number): boolean {
  const rod = RODS.find(r => r.tier === tier);
  if (!rod || S.tools.rod >= tier) return false;
  // cần câu mua bằng xu — lượng là tiền nạp, chỉ dành cho gacha / skin giới hạn
  if (S.wallet.coins < rod.price) { toast(`Cần ${rod.price} xu.`, 'coin'); sfx.error(); return false; }
  S.wallet.coins -= rod.price;
  S.tools.rod = tier;
  // Lttt: cần câu là món "Cầm tay" -> mua xong có luôn trong tủ quần áo
  if (!S.chibiWardrobe.includes(rod.part)) S.chibiWardrobe.push(rod.part);
  bus.emit(EV.WALLET); bus.emit(EV.STATE_CHANGED); bus.emit(EV.APPEARANCE); save();
  toast(`Đã mua ${rod.name}!`, 'rod'); sfx.coin();
  equipTool('rod');
  return true;
}

// ===== Mồi câu =====
// Theo ParkService.handleQuangCau của Lttt: mỗi lần quăng câu là trừ 1 mồi,
// hết mồi thì không quăng được ("Hết mồi rồi sếp"). Ở đây dùng mồi xịn nhất
// đang có trong túi. 3 loại mồi lấy đúng bảng `items` (443 / 447 / 448).
export const BAIT_IDS = ['bait_ant_egg', 'bait_worm', 'bait_rice'];
const ITEMS_BAIT: Record<string, { name: string; wait: number; rare: number }> = {
  bait_rice: { name: 'Mồi cơm', wait: 1, rare: 0 },
  bait_worm: { name: 'Mồi trùng', wait: 0.7, rare: 0.1 },
  bait_ant_egg: { name: 'Trứng kiến', wait: 0.5, rare: 0.25 }
};

let baitRareBonus = 0;

/** Còn mồi nào trong túi không (kiểm trước khi quăng câu). */
export function hasBait(): boolean {
  return BAIT_IDS.some(id => itemCount(id) > 0);
}

export function useBait(): { name: string; wait: number } | null {
  for (const id of BAIT_IDS) {
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
