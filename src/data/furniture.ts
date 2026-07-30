import { defItem } from './items';

// Nội thất — v0 vẽ procedural trong nhà (sheet interior/global.png sẽ map chi tiết sau)
export interface FurnitureDef {
  id: string;
  name: string;
  icon: string;
  price: number;
  rubyPrice?: number;
  w: number;               // kích thước theo tile 16px
  h: number;
  color: number;           // màu vẽ tạm
  category: 'furniture' | 'deco' | 'painting' | 'aquarium';
}

export const FURNITURE: Record<string, FurnitureDef> = {};

// kích thước file sprite đã cắt từ Interior pack (assets/interior/<id>.png)
const SPRITE_SIZE: Record<string, [number, number]> = {
  furn_bed: [31, 48], furn_bed_pink: [23, 48], furn_couch: [48, 32], furn_chair: [13, 19],
  furn_table: [48, 44], furn_shelf: [29, 62], furn_kitchen: [80, 58], furn_fireplace: [15, 16],
  furn_tv: [14, 16], deco_plant: [20, 40], deco_vase: [15, 20], deco_bear: [29, 46],
  deco_rug: [48, 26], deco_xmas_tree: [30, 32], aquarium_small: [16, 15], aquarium_big: [30, 16]
};

function defFurn(f: FurnitureDef) {
  FURNITURE[f.id] = f;
  const sz = SPRITE_SIZE[f.id];
  defItem({
    id: f.id, name: f.name, kind: f.category === 'painting' || f.category === 'deco' ? 'deco' : 'furniture',
    icon: f.icon,
    sprite: sz ? { url: `assets/interior/${f.id}.png`, sx: 0, sy: 0, sw: sz[0], sh: sz[1] } : undefined,
    sell: Math.floor(f.price / 3), buy: f.price, rubyBuy: f.rubyPrice, meta: { furniture: true }
  });
}

defFurn({ id: 'furn_bed', name: 'Giường gỗ', icon: '🛏️', price: 400, w: 2, h: 3, color: 0xc86f4a, category: 'furniture' });
defFurn({ id: 'furn_bed_pink', name: 'Giường hồng', icon: '🛏️', price: 800, w: 2, h: 3, color: 0xf783ac, category: 'furniture' });
defFurn({ id: 'furn_table', name: 'Bàn ăn', icon: '🪵', price: 250, w: 2, h: 2, color: 0xa9714b, category: 'furniture' });
defFurn({ id: 'furn_chair', name: 'Ghế gỗ', icon: '🪑', price: 100, w: 1, h: 1, color: 0xb08653, category: 'furniture' });
defFurn({ id: 'furn_couch', name: 'Ghế sofa', icon: '🛋️', price: 600, w: 3, h: 1, color: 0x748ffc, category: 'furniture' });
defFurn({ id: 'furn_shelf', name: 'Kệ sách', icon: '📚', price: 350, w: 2, h: 1, color: 0x8d6e4c, category: 'furniture' });
defFurn({ id: 'furn_tv', name: 'Tivi', icon: '📺', price: 1200, w: 2, h: 1, color: 0x343a40, category: 'furniture' });
defFurn({ id: 'furn_piano', name: 'Đàn piano', icon: '🎹', price: 2500, w: 2, h: 2, color: 0x212529, category: 'furniture' });
defFurn({ id: 'furn_kitchen', name: 'Bếp', icon: '🍳', price: 900, w: 3, h: 1, color: 0x868e96, category: 'furniture' });
defFurn({ id: 'furn_fireplace', name: 'Lò sưởi', icon: '🔥', price: 1500, w: 2, h: 1, color: 0x845ef7, category: 'furniture' });

defFurn({ id: 'deco_rug', name: 'Thảm tròn', icon: '🟠', price: 150, w: 2, h: 2, color: 0xe8590c, category: 'deco' });
defFurn({ id: 'deco_plant', name: 'Chậu cây', icon: '🪴', price: 120, w: 1, h: 1, color: 0x2f9e44, category: 'deco' });
defFurn({ id: 'deco_lamp', name: 'Đèn cây', icon: '🛋', price: 200, w: 1, h: 1, color: 0xffd43b, category: 'deco' });
defFurn({ id: 'deco_vase', name: 'Bình hoa', icon: '🏺', price: 180, w: 1, h: 1, color: 0x9c36b5, category: 'deco' });
defFurn({ id: 'deco_bear', name: 'Gấu bông lớn', icon: '🧸', price: 500, w: 1, h: 1, color: 0xd9480f, category: 'deco' });
defFurn({ id: 'deco_xmas_tree', name: 'Cây thông Noel', icon: '🎄', price: 999, rubyPrice: 10, w: 2, h: 2, color: 0x087f5b, category: 'deco' });

defFurn({ id: 'paint_sunset', name: 'Tranh hoàng hôn', icon: '🖼️', price: 300, w: 1, h: 1, color: 0xff922b, category: 'painting' });
defFurn({ id: 'paint_sea', name: 'Tranh biển', icon: '🖼️', price: 300, w: 1, h: 1, color: 0x339af0, category: 'painting' });
defFurn({ id: 'paint_farm', name: 'Tranh nông trại', icon: '🖼️', price: 350, w: 1, h: 1, color: 0x66a80f, category: 'painting' });
defFurn({ id: 'paint_abstract', name: 'Tranh trừu tượng', icon: '🖼️', price: 600, rubyPrice: 5, w: 1, h: 1, color: 0xcc5de8, category: 'painting' });

defFurn({ id: 'aquarium_small', name: 'Hồ cá nhỏ', icon: '🐠', price: 800, w: 2, h: 1, color: 0x22b8cf, category: 'aquarium' });
defFurn({ id: 'aquarium_big', name: 'Hồ cá lớn', icon: '🐠', price: 3000, rubyPrice: 15, w: 3, h: 1, color: 0x15aabf, category: 'aquarium' });

export const FURNITURE_LIST = Object.values(FURNITURE);

// Nhà ở
export const HOUSE_LEVELS = [
  { level: 1, name: 'Nhà gỗ nhỏ', price: 2000, size: 10 },   // size: cạnh phòng theo tile
  { level: 2, name: 'Nhà khang trang', price: 10000, size: 14 },
  { level: 3, name: 'Biệt thự', price: 50000, size: 18 }
];
export const WALLPAPERS = [0xd9b38c, 0xa5d8ff, 0xffc9c9, 0xb2f2bb, 0xe5dbff, 0xffe066];
export const FLOORS = [0x966f33, 0xcfad84, 0x8ca66a, 0x9fa8b5, 0xc79b6d, 0xdec4a1];
