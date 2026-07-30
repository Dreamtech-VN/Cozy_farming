import { S, save, addItem, addExp, addStat, equipTool } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { FISH_LIST, FISHES, RODS, RARITY_NAME, type FishDef } from '@/data/fish';
import { INSECT_LIST, type InsectDef } from '@/data/insects';
import { sfx } from '@/core/audio';

// ===== Câu cá =====

export function buyRod(tier: number): boolean {
  const rod = RODS.find(r => r.tier === tier);
  if (!rod || S.tools.rod >= tier) return false;
  if (S.wallet.coins < rod.price) { toast(`Cần ${rod.price} xu.`, '💰'); sfx.error(); return false; }
  S.wallet.coins -= rod.price;
  S.tools.rod = tier;
  bus.emit(EV.WALLET); bus.emit(EV.STATE_CHANGED); save();
  toast(`Đã mua ${rod.name}!`, '🎣'); sfx.coin();
  equipTool('rod');
  return true;
}

// Chọn ngẫu nhiên cá theo khu + độ hiếm (cần xịn tăng tỉ lệ hiếm)
export function rollFish(zone: string): FishDef | undefined {
  if (S.tools.rod <= 0) return undefined;
  const rodBonus = RODS.find(r => r.tier === S.tools.rod)?.bonus ?? 0;
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
  addItem(fish.id);
  addExp(fish.rarity === 'legendary' ? 100 : fish.rarity === 'epic' ? 40 : fish.rarity === 'rare' ? 15 : 6);
  addStat('fish_caught'); addStat('daily_fish');
  if (!S.collections.fish.includes(fish.id)) {
    S.collections.fish.push(fish.id);
    S.stats['fish_species'] = S.collections.fish.length;
    bus.emit(EV.STAT, 'fish_species');
    toast(`Loài mới: ${fish.name} (${RARITY_NAME[fish.rarity]})!`, '📖');
  }
  sfx.harvest(); save(); bus.emit(EV.STATE_CHANGED);
}

// Thả cá vào hồ trong nhà
export function addToAquarium(fishId: string): boolean {
  const hasTank = S.house.furniture.some(f => f.itemId.startsWith('aquarium'));
  if (!hasTank) { toast('Cần đặt Hồ cá trong nhà trước.', '🐠'); return false; }
  const cap = S.house.furniture.some(f => f.itemId === 'aquarium_big') ? 8 : 3;
  if (S.house.aquarium.length >= cap) { toast('Hồ cá đầy rồi!'); return false; }
  if (!S.inventory[fishId]) return false;
  S.inventory[fishId]--;
  if (S.inventory[fishId] <= 0) delete S.inventory[fishId];
  S.house.aquarium.push(fishId);
  bus.emit(EV.INVENTORY); bus.emit(EV.HOUSE); save();
  toast(`Đã thả ${FISHES[fishId]?.name ?? 'cá'} vào hồ.`, '🐠');
  return true;
}

// ===== Bắt côn trùng =====

export function rollInsect(zone: string): InsectDef | undefined {
  const pool = INSECT_LIST.filter(i => i.zones.includes(zone));
  if (!pool.length) return undefined;
  const netBonus = S.tools.net >= 2 ? 1.8 : 1;
  const weight = (i: InsectDef) =>
    i.rarity === 'common' ? 100 :
    i.rarity === 'rare' ? 22 * netBonus :
    i.rarity === 'epic' ? 7 * netBonus : 1.2 * netBonus;
  let total = 0;
  const acc = pool.map(i => (total += weight(i), total));
  const r = Math.random() * total;
  return pool[acc.findIndex(a => r <= a)];
}

export function catchInsect(ins: InsectDef): boolean {
  if (S.tools.net <= 0) { toast('Cần mua vợt ở Bách hóa trước!', '🥅'); return false; }
  // tỉ lệ bắt trượt với loài hiếm
  const chance = ins.rarity === 'common' ? 0.95 : ins.rarity === 'rare' ? 0.75 : ins.rarity === 'epic' ? 0.55 : 0.35;
  if (Math.random() > chance) { toast(`${ins.name} bay mất rồi!`, '💨'); return false; }
  addItem(ins.id);
  addExp(ins.rarity === 'legendary' ? 90 : ins.rarity === 'epic' ? 35 : ins.rarity === 'rare' ? 12 : 5);
  addStat('insects_caught'); addStat('daily_insects');
  if (!S.collections.insects.includes(ins.id)) {
    S.collections.insects.push(ins.id);
    toast(`Loài mới: ${ins.name}!`, '📖');
  }
  sfx.harvest(); save(); bus.emit(EV.STATE_CHANGED);
  toast(`Bắt được ${ins.name}!`, ins.icon);
  return true;
}
