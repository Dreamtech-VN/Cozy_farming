// ===== Thú cưng =====
// 10 con chọn tay từ apk GunPow (skeleton Spine, nướng thành dải sprite 4 khung
// animation 'wait' bằng scripts/pet_strips.py) — bỏ hết bản trùng chỉ khác màu,
// mỗi con một tạo hình riêng. Mua bằng RUBY (không phải xu), vì đây là thú hiếm.
//
// Game không đánh nhau nên thú cưng KHÔNG có chỉ số chiến đấu: mỗi con mang
// một công dụng nhà nông, gán theo vòng để con nào cũng có việc.

import { S } from '@/core/save';
import GP from './pets-gp.json';

export type PetPerk = 'harvest' | 'sell' | 'guard' | 'fish' | 'grow';

export interface PetDef {
  id: string;
  name: string;
  art: { url: string; w: number; h: number; frames: number };
  price: number;         // giá tính bằng RUBY
  scale: number;
  perk: PetPerk;
  perkText: string;      // dòng ngắn trong shop
  perkFull: string;      // giải thích đầy đủ
}

/** Công dụng của từng loại — số nhỏ, chỉ để thưởng cho việc nuôi thú. */
export const PERKS: Record<PetPerk, { rate: number; text: string; full: string }> = {
  harvest: {
    rate: 0.15, text: '+15% cơ hội thu thêm nông sản',
    full: 'Bé lục lọi quanh ruộng: mỗi lần thu hoạch có thêm 15% cơ hội được thêm 1 nông sản.'
  },
  sell: {
    rate: 0.10, text: '+10% xu khi bán',
    full: 'Bé nhanh mồm mặc cả giúp bạn: mọi lần bán vật phẩm đều được thêm 10% xu.'
  },
  guard: {
    rate: 0.50, text: 'Giảm 50% mất đồ khi khách ghé',
    full: 'Bé canh nông trại: khi người chơi khác ghé thăm, tỉ lệ bị trộm nông sản giảm một nửa.'
  },
  fish: {
    rate: 0.10, text: '+10% tỉ lệ câu được cá hiếm',
    full: 'Bé ngồi rình bên hồ: mỗi lần câu, tỉ lệ dính cá hiếm tăng thêm 10%.'
  },
  grow: {
    rate: 0.05, text: 'Cây lớn nhanh hơn 5%',
    full: 'Bé chạy nhảy làm đất tơi: mọi cây trong nông trại lớn nhanh hơn 5%.'
  }
};

const PERK_ORDER: PetPerk[] = ['harvest', 'sell', 'guard', 'fish', 'grow'];

// pack không kèm bảng tên gốc nên tự đặt tên + giá ruby theo độ hiếm nhìn bằng mắt
const CURATED: { sid: string; name: string; price: number }[] = [
  { sid: '0003', name: 'Gấu Mèo Lãng Tử', price: 15 },
  { sid: '0006', name: 'Cáo Con Tinh Nghịch', price: 15 },
  { sid: '0019', name: 'Thỏ Bông Nhóc Tì', price: 20 },
  { sid: '0044', name: 'Mèo Máy Xanh', price: 25 },
  { sid: '0056', name: 'Nữ Xạ Thủ Bạch Thố', price: 30 },
  { sid: '0065', name: 'Tiên Nữ Cánh Hồng', price: 30 },
  { sid: '0156', name: 'Sói Tuyết Có Cánh', price: 35 },
  { sid: '0032', name: 'Pháp Sư Bóng Đêm', price: 45 },
  { sid: '0084', name: 'Rồng Ngọc Lam', price: 50 },
  { sid: '0108', name: 'Rồng Băng Giáp Vàng', price: 55 },
  { sid: '0009', name: 'Rồng Bạc Cổ Đại', price: 60 }
];

const SIZE = GP as unknown as Record<string, [number, number, number]>;

export const PETS: Record<string, PetDef> = {};
CURATED.forEach((c, i) => {
  const [w, h, frames] = SIZE[c.sid];
  const perk = PERK_ORDER[i % PERK_ORDER.length];
  PETS[`gp_${c.sid}`] = {
    id: `gp_${c.sid}`,
    name: c.name,
    art: { url: `assets/pet/gp/${c.sid}.webp`, w, h, frames },
    price: c.price,
    scale: 1,
    perk,
    perkText: PERKS[perk].text,
    perkFull: PERKS[perk].full
  };
});

export const PET_LIST = Object.values(PETS);

/** Ô hiển thị thú: khung cắt + ảnh trượt theo khung, giống skin. */
export function petArt(def: PetDef, size = 48): HTMLElement {
  const box = document.createElement('div');
  box.className = 'pet-anim';
  box.style.width = `${Math.round(size * def.art.w / def.art.h)}px`;
  box.style.height = `${size}px`;
  const img = document.createElement('img');
  img.src = def.art.url;
  img.draggable = false;
  img.style.animationDuration = '0.9s';
  img.style.animationTimingFunction = `steps(${def.art.frames})`;
  box.append(img);
  return box;
}

export function petDef(id?: string): PetDef | undefined { return id ? PETS[id] : undefined; }
export function ownsPet(id: string): boolean { return (S.pets ?? []).includes(id); }

/**
 * Hệ số thưởng của thú ĐANG THẢ (0 nếu không có).
 * Chỉ con đang thả mới tính — nuôi cả đàn không cộng dồn.
 */
export function petBonus(perk: PetPerk): number {
  const def = petDef(S.activePet);
  if (!def || !ownsPet(def.id)) return 0;
  return def.perk === perk ? PERKS[perk].rate : 0;
}
