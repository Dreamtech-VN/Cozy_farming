// ===== Món nấu ở nhà bếp (theo Lttt) =====
// Lttt: class Food { ID, productID, cookTime, material[], numberMaterial[] }
// Mỗi lúc chỉ nấu 1 món, có đếm giờ; nấu xong vào lấy.
// Nguyên liệu lấy từ KHO nông trại, món nấu xong cũng cất vào kho.

export interface FoodDef {
  id: string;
  name: string;
  icon: string;            // id trong kho dùng làm ảnh minh hoạ (cropId hoặc item)
  cookMin: number;         // phút nấu
  sell: number;            // giá bán món
  exp: number;
  material: [string, number][];   // [cropId, số lượng]
}

export const FOODS: Record<string, FoodDef> = {};

function def(f: FoodDef) { FOODS[f.id] = f; return f; }

def({
  id: 'salad', name: 'Salad rau củ', icon: 'cabbage', cookMin: 8, sell: 320, exp: 12,
  material: [['cabbage', 2], ['carrot', 2]]
});
def({
  id: 'soup_pumpkin', name: 'Súp bí đỏ', icon: 'pumpkin', cookMin: 12, sell: 460, exp: 16,
  material: [['pumpkin', 2], ['potato', 1]]
});
def({
  id: 'juice_berry', name: 'Nước ép dâu', icon: 'strawberry', cookMin: 10, sell: 400, exp: 14,
  material: [['strawberry', 3]]
});
def({
  id: 'corn_grill', name: 'Ngô nướng', icon: 'corn', cookMin: 6, sell: 240, exp: 9,
  material: [['corn', 2]]
});
def({
  id: 'tomato_sauce', name: 'Sốt cà chua', icon: 'tomato', cookMin: 9, sell: 350, exp: 12,
  material: [['tomato', 3]]
});
def({
  id: 'veggie_stew', name: 'Canh thập cẩm', icon: 'turnip', cookMin: 18, sell: 720, exp: 26,
  material: [['turnip', 2], ['carrot', 2], ['potato', 2]]
});

// Món dùng sản phẩm chăn nuôi (trứng/sữa/thịt) — nguyên liệu cũng lấy từ kho
def({
  id: 'meat_grill', name: 'Thịt nướng', icon: 'meat', cookMin: 15, sell: 560, exp: 22,
  material: [['meat', 1], ['corn', 1]]
});
def({
  id: 'meat_stew', name: 'Thịt kho trứng', icon: 'meat', cookMin: 22, sell: 880, exp: 32,
  material: [['meat', 2], ['egg', 2], ['carrot', 1]]
});
def({
  id: 'milk_cake', name: 'Bánh sữa trứng', icon: 'milk', cookMin: 20, sell: 700, exp: 27,
  material: [['milk', 2], ['egg', 2], ['wheat', 2]]
});

export const FOOD_LIST = Object.values(FOODS);
