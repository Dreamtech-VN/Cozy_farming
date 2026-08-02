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
  maturityMin: number;     // phút từ lúc mua tới lúc lớn hẳn (period=2), xem ghi chú dưới
  exp: number;
}

// maturityMin — số thật lấy từ FarmScr.cs (bản Lttt gốc):
//   FarmScr.cs:3639-3646 -> period = bornTime / (harvestTime*60/3), tối đa 2 (đã lớn).
//   bornTime tính bằng GIÂY, harvestTime tính bằng PHÚT (số duy nhất cho mỗi loài,
//   hiện ra ở shop dạng "(Xh)" — xem FarmScr.cs:883 `ani.harvestTime + T.h`).
//   => period đạt 2 khi bornTime(giây) >= harvestTime*60*2/3
//   => quy đổi ra phút: tuổi cần để lớn hẳn = harvestTime * 2/3 (phút).
// harvestTime của Lttt gốc chính là stat "thời gian ra sản phẩm" — đúng khái niệm
// produceMin ở bản này (không tìm được bảng số thật cho species=50/51/52 trong
// 127_0_0_1.sql, farmitems ở đó chỉ có dữ liệu CÂY TRỒNG, không có vật nuôi), nên
// ta dùng produceMin làm harvestTime và áp thẳng công thức thật: maturityMin = produceMin * 2/3.
export const ANIMALS: Record<string, AnimalDef> = {
  chicken: { id: 'chicken', name: 'Gà',   icon: '🐔', legs: 2, sheet: 'chicken_animation.png', frameW: 16, frameH: 16, hdScale: 1.8, price: 300,  product: 'egg',  productQty: [1, 3], produceMin: 10, maturityMin: 7,  exp: 6 },
  cow:     { id: 'cow',     name: 'Bò',   icon: '🐄', legs: 4, sheet: 'cow_animation.png',     frameW: 24, frameH: 24, hdScale: 2.6, price: 1500, product: 'milk', productQty: [1, 2], produceMin: 30, maturityMin: 20, exp: 15 },
  pig:     { id: 'pig',     name: 'Heo',  icon: '🐖', legs: 4, sheet: 'pig_animation.png',     frameW: 20, frameH: 20, hdScale: 2.4, price: 900,  product: 'meat', productQty: [1, 2], produceMin: 20, maturityMin: 13, exp: 10 },
  sheep:   { id: 'sheep',   name: 'Cừu',  icon: '🐑', legs: 4, sheet: 'sheep_animation.png',   frameW: 17, frameH: 17, hdScale: 2.7, price: 1200, product: 'wool', productQty: [1, 1], produceMin: 45, maturityMin: 30, exp: 14 }
};

export const ANIMAL_LIST = Object.values(ANIMALS);
export const BARN_CAPACITY = [0, 4, 8, 12]; // theo cấp chuồng
export const BARN_UPGRADE_COST = [500, 2000, 6000]; // mua cấp 1, lên 2, lên 3
