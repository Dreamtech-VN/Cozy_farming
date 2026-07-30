import { S, save, removeItem, addItem, addStat, itemCount } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { FURNITURE, HOUSE_LEVELS } from '@/data/furniture';
import { sfx } from '@/core/audio';

export function houseSize(): number {
  return HOUSE_LEVELS[Math.max(0, S.house.level - 1)]?.size ?? 10;
}

export function buyHouse(): boolean {
  if (S.house.owned) return false;
  const lv = HOUSE_LEVELS[0];
  if (S.wallet.coins < lv.price) { toast(`Cần ${lv.price} xu để mua ${lv.name}.`, 'coin'); sfx.error(); return false; }
  S.wallet.coins -= lv.price;
  S.house.owned = true; S.house.level = 1;
  addStat('house_bought');
  bus.emit(EV.WALLET); bus.emit(EV.HOUSE); bus.emit(EV.STATE_CHANGED); save();
  toast(`Chúc mừng tân gia — ${lv.name}!`, 'house'); sfx.win();
  return true;
}

export function upgradeHouse(): boolean {
  if (!S.house.owned || S.house.level >= HOUSE_LEVELS.length) return false;
  const next = HOUSE_LEVELS[S.house.level];
  if (S.wallet.coins < next.price) { toast(`Cần ${next.price} xu.`, 'coin'); sfx.error(); return false; }
  S.wallet.coins -= next.price;
  S.house.level++;
  addStat('house_upgraded');
  bus.emit(EV.WALLET); bus.emit(EV.HOUSE); bus.emit(EV.STATE_CHANGED); save();
  toast(`Nhà nâng cấp thành ${next.name}!`, 'house'); sfx.win();
  return true;
}

export function placeFurniture(itemId: string, x: number, y: number): boolean {
  const def = FURNITURE[itemId];
  if (!def || !S.house.owned) return false;
  if (itemCount(itemId) <= 0) return false;
  const size = houseSize();
  if (x < 1 || y < 1 || x + def.w > size - 1 || y + def.h > size - 1) { toast('Ngoài phạm vi phòng.'); return false; }
  // tranh treo tường: y = 0 vẫn hợp lệ (đặt lên tường)
  const overlap = S.house.furniture.some(f => {
    const d = FURNITURE[f.itemId];
    return x < f.x + d.w && x + def.w > f.x && y < f.y + d.h && y + def.h > f.y;
  });
  if (overlap) { toast('Vị trí bị chồng lên đồ khác.'); return false; }
  removeItem(itemId);
  S.house.furniture.push({ id: `p${Date.now()}${Math.floor(Math.random() * 999)}`, itemId, x, y });
  addStat('furniture_placed');
  bus.emit(EV.HOUSE); save(); sfx.plant();
  return true;
}

export function pickupFurniture(placedId: string): boolean {
  const idx = S.house.furniture.findIndex(f => f.id === placedId);
  if (idx < 0) return false;
  const f = S.house.furniture[idx];
  // cá trong hồ trả về kho khi dọn hồ
  if (f.itemId.startsWith('aquarium')) {
    const remaining = S.house.furniture.filter(x => x.itemId.startsWith('aquarium') && x.id !== placedId);
    if (!remaining.length && S.house.aquarium.length) {
      for (const fid of S.house.aquarium) addItem(fid);
      S.house.aquarium = [];
    }
  }
  S.house.furniture.splice(idx, 1);
  addItem(f.itemId);
  bus.emit(EV.HOUSE); save();
  return true;
}

export function setWallpaper(i: number) {
  S.house.wallpaper = i; bus.emit(EV.HOUSE); save();
}
export function setFloor(i: number) {
  S.house.floor = i; bus.emit(EV.HOUSE); save();
}

// Tổ chức tiệc: tốn 1 bánh kem, bạn NPC đến chơi 2 phút
export function throwParty(): boolean {
  if (!S.house.owned) { toast('Bạn chưa có nhà.'); return false; }
  if (!removeItem('food_cake')) { toast('Cần 1 Bánh kem để mở tiệc (mua ở Bách hóa).', 'gift'); return false; }
  S.house.partyUntil = Date.now() + 2 * 60_000;
  addStat('parties');
  bus.emit(EV.HOUSE); save(); sfx.win();
  toast('Tiệc bắt đầu! Bạn bè đang đến nhà bạn 🎉', 'gift');
  return true;
}

export function partyActive(): boolean {
  return !!S.house.partyUntil && Date.now() < S.house.partyUntil;
}
