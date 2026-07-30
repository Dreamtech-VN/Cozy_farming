// ===== Thú cưng =====
// Mua ở Tiệm thú cưng (Khu mua sắm). Mỗi loài có công dụng riêng.
// Sprite lấy từ object thú cưng Avatar (res Lttt) — xem docs/ASSETS.md.

import { S } from '@/core/save';

export interface PetDef {
  id: string;
  name: string;
  icon: string;
  sheet: string;           // key spritesheet đã preload
  frameW: number;
  frameH: number;
  frames: { idle: number[]; move: number },
  price: number;
  scale: number;
  perk: string;            // mô tả ngắn công dụng
  perkFull: string;
}

export const PETS: Record<string, PetDef> = {
  dog: {
    id: 'dog', name: 'Cún giữ nhà', icon: '🐶', sheet: 'avdog', frameW: 48, frameH: 36,
    frames: { idle: [0, 1], move: 2 }, price: 2000, scale: 1.15,
    perk: 'Giảm 50% mất đồ khi khách ghé thăm',
    perkFull: 'Cún canh nông trại: khi người chơi khác ghé thăm, tỉ lệ bị trộm nông sản giảm một nửa.'
  },
  cat: {
    id: 'cat', name: 'Mèo bắt chuột', icon: '🐱', sheet: 'avcat', frameW: 38, frameH: 45,
    frames: { idle: [0, 1], move: 2 }, price: 2500, scale: 1.05,
    perk: '+15% cơ hội thu hoạch thêm nông sản',
    perkFull: 'Mèo đuổi chuột phá mùa màng: mỗi lần thu hoạch có thêm 15% cơ hội được thêm 1 nông sản.'
  },
  parrot: {
    id: 'parrot', name: 'Vẹt lanh lợi', icon: '🦜', sheet: 'avparrot', frameW: 34, frameH: 40,
    frames: { idle: [0, 1], move: 2 }, price: 3000, scale: 1.1,
    perk: '+10% xu khi bán vật phẩm',
    perkFull: 'Vẹt mặc cả giúp bạn: mọi lần bán vật phẩm đều được thêm 10% xu.'
  }
};

export const PET_LIST = Object.values(PETS);

export function ownsPet(id: string): boolean {
  return (S.pets ?? []).includes(id);
}

// hệ số thưởng theo loài (0 nếu chưa nuôi)
export function petBonus(id: 'dog' | 'cat' | 'parrot'): number {
  if (!ownsPet(id)) return 0;
  return id === 'dog' ? 0.5 : id === 'cat' ? 0.15 : 0.1;
}
