import { defItem } from './items';

// Cây trồng — sprite lấy từ farm/crops_all.png (lưới 16px, mỗi cây 1 hàng,
// cột 0 là icon túi hạt, cột 1..5 là 5 giai đoạn lớn).
export interface CropDef {
  id: string;
  name: string;
  icon: string;        // emoji nông sản
  row: number;         // hàng trong crops_all.png
  stages: number;      // số giai đoạn (5)
  growMin: number;     // tổng phút để chín (đã tưới đủ)
  seedPrice: number;
  sellPrice: number;
  exp: number;
  yieldQty: [number, number]; // số lượng thu hoạch min..max
}

export const CROPS: Record<string, CropDef> = {};

const SHEET = 'assets/farm/crops_all.png';
// Icon nông sản/hạt giống nét hơn từ Cloverframe Cozy Farm pack (32x32)
const CF = 'assets/farm/cf/';
const CF_CROP: Record<string, string> = {
  carrot: '02_carrot', turnip: '03_turnip', tomato: '04_tomato', pumpkin: '05_pumpkin',
  corn: '06_corn', strawberry: '07_strawberry', potato: '09_potato', cabbage: '10_cabbage'
};

function defCrop(c: CropDef) {
  CROPS[c.id] = c;
  // cột 0 của mỗi hàng crops_all là icon túi hạt; cột 5 là cây chín
  defItem({
    id: `seed_${c.id}`, name: `Hạt ${c.name}`, kind: 'seed', icon: '',
    sprite: { url: `${CF}16_seed_bag.png`, sx: 0, sy: 0, sw: 32, sh: 32 },
    sell: Math.floor(c.seedPrice / 2), buy: c.seedPrice, meta: { crop: c.id }
  });
  defItem({
    id: `crop_${c.id}`, name: c.name, kind: 'crop', icon: c.icon,
    sprite: CF_CROP[c.id]
      ? { url: `${CF}${CF_CROP[c.id]}.png`, sx: 0, sy: 0, sw: 32, sh: 32 }
      : { url: SHEET, sx: c.stages * 16, sy: c.row * 16, sw: 16, sh: 16 },
    sell: c.sellPrice
  });
}

defCrop({ id: 'carrot',     name: 'Cà rốt',        icon: '🥕', row: 0,  stages: 5, growMin: 2,   seedPrice: 10,  sellPrice: 18,  exp: 3,  yieldQty: [1, 2] });
defCrop({ id: 'turnip',     name: 'Củ cải',        icon: '🌰', row: 1,  stages: 5, growMin: 4,   seedPrice: 15,  sellPrice: 26,  exp: 4,  yieldQty: [1, 2] });
defCrop({ id: 'potato',     name: 'Khoai tây',     icon: '🥔', row: 2,  stages: 5, growMin: 8,   seedPrice: 25,  sellPrice: 45,  exp: 6,  yieldQty: [1, 3] });
defCrop({ id: 'tomato',     name: 'Cà chua',       icon: '🍅', row: 3,  stages: 5, growMin: 15,  seedPrice: 40,  sellPrice: 70,  exp: 9,  yieldQty: [2, 3] });
defCrop({ id: 'cabbage',    name: 'Bắp cải',       icon: '🥬', row: 4,  stages: 5, growMin: 25,  seedPrice: 60,  sellPrice: 110, exp: 12, yieldQty: [1, 2] });
defCrop({ id: 'pumpkin',    name: 'Bí đỏ',         icon: '🎃', row: 5,  stages: 5, growMin: 45,  seedPrice: 100, sellPrice: 190, exp: 18, yieldQty: [1, 1] });
defCrop({ id: 'watermelon', name: 'Dưa hấu',       icon: '🍉', row: 6,  stages: 5, growMin: 60,  seedPrice: 130, sellPrice: 250, exp: 22, yieldQty: [1, 1] });
defCrop({ id: 'strawberry', name: 'Dâu tây',       icon: '🍓', row: 7,  stages: 5, growMin: 30,  seedPrice: 80,  sellPrice: 150, exp: 14, yieldQty: [2, 4] });
defCrop({ id: 'corn',       name: 'Ngô',           icon: '🌽', row: 10, stages: 5, growMin: 40,  seedPrice: 90,  sellPrice: 170, exp: 16, yieldQty: [2, 3] });
defCrop({ id: 'eggplant',   name: 'Cà tím',        icon: '🍆', row: 12, stages: 5, growMin: 35,  seedPrice: 85,  sellPrice: 160, exp: 15, yieldQty: [1, 2] });
defCrop({ id: 'chili',      name: 'Ớt',            icon: '🌶️', row: 14, stages: 5, growMin: 20,  seedPrice: 50,  sellPrice: 95,  exp: 10, yieldQty: [2, 3] });
defCrop({ id: 'sunflower',  name: 'Hướng dương',   icon: '🌻', row: 20, stages: 5, growMin: 90,  seedPrice: 200, sellPrice: 380, exp: 30, yieldQty: [1, 1] });
defCrop({ id: 'rose',       name: 'Hoa hồng',      icon: '🌹', row: 22, stages: 5, growMin: 120, seedPrice: 260, sellPrice: 520, exp: 40, yieldQty: [1, 1] });
defCrop({ id: 'tulip',      name: 'Tulip',         icon: '🌷', row: 24, stages: 5, growMin: 75,  seedPrice: 160, sellPrice: 310, exp: 26, yieldQty: [1, 2] });

export const CROP_LIST = Object.values(CROPS);
