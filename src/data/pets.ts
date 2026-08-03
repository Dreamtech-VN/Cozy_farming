// ===== Thú cưng =====
// 10 con chọn tay từ apk GunPow (skeleton Spine, nướng thành dải sprite 4 khung
// animation 'wait' bằng scripts/pet_strips.py) — bỏ hết bản trùng chỉ khác màu,
// mỗi con một tạo hình riêng. Mua bằng RUBY (không phải xu), vì đây là thú hiếm.
//
// Theo bản gốc Lttt (Pet.cs): thú cưng chỉ là MỘT MÓN TRANG PHỤC nữa của avatar
// (đọc từ AvatarData.getPart(follow.idPet) — cùng bảng part với tóc/áo/quần),
// bám theo người chơi và có thanh đói cần cho ăn — KHÔNG có % thưởng thu hoạch/
// bán/câu cá/canh trại nào cả (hệ đó là ta tự chế trước đây, đã bỏ).

import { S } from '@/core/save';
import GP from './pets-gp.json';

export interface PetDef {
  id: string;
  name: string;
  art: { url: string; w: number; h: number; frames: number };
  price: number;         // giá tính bằng RUBY
  scale: number;
}

// pack không kèm bảng tên gốc nên tự đặt tên + giá ruby theo độ hiếm nhìn bằng mắt
// (đã bỏ 0006/0032/0084/0156 — ráp bị dư mảnh rời phía sau lưng không sửa nổi)
const CURATED: { sid: string; name: string; price: number }[] = [
  { sid: '0003', name: 'Gấu Mèo Lãng Tử', price: 15 },
  { sid: '0019', name: 'Thỏ Bông Nhóc Tì', price: 20 },
  { sid: '0044', name: 'Mèo Máy Xanh', price: 25 },
  { sid: '0056', name: 'Nữ Xạ Thủ Bạch Thố', price: 30 },
  { sid: '0065', name: 'Tiên Nữ Cánh Hồng', price: 30 },
  { sid: '0108', name: 'Rồng Băng Giáp Vàng', price: 55 },
  { sid: '0009', name: 'Rồng Bạc Cổ Đại', price: 60 }
];

const SIZE = GP as unknown as Record<string, [number, number, number]>;

export const PETS: Record<string, PetDef> = {};
CURATED.forEach(c => {
  const [w, h, frames] = SIZE[c.sid];
  PETS[`gp_${c.sid}`] = {
    id: `gp_${c.sid}`,
    name: c.name,
    art: { url: `assets/pet/gp/${c.sid}.webp`, w, h, frames },
    price: c.price,
    scale: 1
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
