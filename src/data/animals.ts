// Vật nuôi — sprite từ public/assets/animals/*.png (mỗi sheet ~4 cột × 5 hàng)
export interface AnimalDef {
  id: string;
  name: string;
  icon: string;
  sheet: string;           // tên file trong assets/animals
  legs: 2 | 4;              // 4 chân phải nhốt trong chuồng rào, 2 chân thả rông
  frameW: number;
  frameH: number;
  hdScale: number;         // hệ số vẽ trên map nền HD (quy về cỡ Avatar/Lttt)
  price: number;           // giá mua (xu)
  product: string;         // itemId sản phẩm
  productQty: [number, number];
  produceMin: number;      // phút sau khi cho ăn thì có sản phẩm
  exp: number;
}

export const ANIMALS: Record<string, AnimalDef> = {
  chicken: { id: 'chicken', name: 'Gà',   icon: '🐔', legs: 2, sheet: 'chicken_animation.png', frameW: 16, frameH: 16, hdScale: 1.8, price: 300,  product: 'egg',  productQty: [1, 3], produceMin: 10, exp: 6 },
  cow:     { id: 'cow',     name: 'Bò',   icon: '🐄', legs: 4, sheet: 'cow_animation.png',     frameW: 24, frameH: 24, hdScale: 2.6, price: 1500, product: 'milk', productQty: [1, 2], produceMin: 30, exp: 15 },
  pig:     { id: 'pig',     name: 'Heo',  icon: '🐖', legs: 4, sheet: 'pig_animation.png',     frameW: 20, frameH: 20, hdScale: 2.4, price: 900,  product: 'meat', productQty: [1, 2], produceMin: 20, exp: 10 },
  sheep:   { id: 'sheep',   name: 'Cừu',  icon: '🐑', legs: 4, sheet: 'sheep_animation.png',   frameW: 17, frameH: 17, hdScale: 2.7, price: 1200, product: 'wool', productQty: [1, 1], produceMin: 45, exp: 14 }
};

export const ANIMAL_LIST = Object.values(ANIMALS);
export const BARN_CAPACITY = [0, 4, 8, 12]; // theo cấp chuồng
export const BARN_UPGRADE_COST = [500, 2000, 6000]; // mua cấp 1, lên 2, lên 3
