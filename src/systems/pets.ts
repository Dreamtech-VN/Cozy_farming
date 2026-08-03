// ===== Đói của thú cưng đang thả =====
// Lttt gốc (Pet.cs): Avatar.hungerPet là số 0-100, Pet.move() đi chậm hẳn khi
// đói (num = v * hungerPet/100, chỉ full tốc khi hungerPet >= 70), paintIcon vẽ
// thanh đói nhỏ phía trên đầu. Ta không có công thức suy giảm thật của server
// nên mô phỏng tuyến tính theo giờ kể từ lần cho ăn gần nhất, cùng khung 4 giờ
// đang dùng cho vật nuôi trên cạn (livestock.ts) và cá (fishfarm.ts) cho đồng bộ.

import { S, save, itemCount, removeItem } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { sfx } from '@/core/audio';

const FULL_HOURS = 4; // no -> đói hẳn sau 4 giờ, giống vật nuôi khác

/** Độ no của thú đang thả, 0-100 (100 = vừa cho ăn). */
export function petFullness(): number {
  const hrs = (Date.now() - (S.petFedAt ?? 0)) / 3600_000;
  return Math.max(0, Math.min(100, Math.round(100 - (hrs / FULL_HOURS) * 100)));
}

export function isPetHungry(): boolean {
  return petFullness() < 40;
}

/** Hệ số tốc độ khi dắt đi dạo — phỏng theo move(): đói thì đi ì ạch, no thì full tốc. */
export function petSpeedMult(): number {
  const f = petFullness();
  if (f >= 70) return 1;
  return Math.max(0.35, f / 100);
}

export function feedPet(): boolean {
  if (!S.activePet) { toast('Chưa thả thú nào để cho ăn.', 'pet'); return false; }
  if (!isPetHungry()) { toast('Bé no rồi!'); return false; }
  if (itemCount('feed') <= 0) { toast('Hết thức ăn — mua ở Bách hóa.', 'feed'); return false; }
  removeItem('feed');
  S.petFedAt = Date.now();
  sfx.plant(); save(); bus.emit(EV.STATE_CHANGED);
  toast('Bé măm măm ngon lành~', 'pet');
  return true;
}
