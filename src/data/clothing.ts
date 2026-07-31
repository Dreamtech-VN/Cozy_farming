// ===== Thời trang (asset Character v2: lưới 32px, mỗi biến thể màu 1 block 256px = 8 cột) =====

export interface WearDef {
  id: string;              // tên file không đuôi, vd 'bob'
  name: string;
  price: number;           // xu; 0 = mặc định miễn phí
}

// Kiểu tóc (sheet có 14 màu)
export const HAIR_STYLES: WearDef[] = [
  { id: 'bob', name: 'Tóc bob', price: 0 },
  { id: 'braids', name: 'Tóc bím', price: 300 },
  { id: 'buzzcut', name: 'Đầu đinh', price: 200 },
  { id: 'curly', name: 'Tóc xoăn', price: 350 },
  { id: 'emo', name: 'Tóc emo', price: 400 },
  { id: 'extra_long', name: 'Tóc siêu dài', price: 600 },
  { id: 'extra_long_skirt', name: 'Siêu dài mái thưa', price: 650 },
  { id: 'french_curl', name: 'Xoăn Pháp', price: 500 },
  { id: 'gentleman', name: 'Quý ông', price: 450 },
  { id: 'long_straight', name: 'Dài thẳng', price: 400 },
  { id: 'long_straight_skirt', name: 'Dài thẳng mái', price: 450 },
  { id: 'midiwave', name: 'Gợn sóng', price: 500 },
  { id: 'ponytail', name: 'Đuôi ngựa', price: 350 },
  { id: 'spacebuns', name: 'Búi đôi', price: 550 },
  { id: 'wavy', name: 'Uốn lượn', price: 480 }
];

// Trang phục (đa số 10 màu)
export const CLOTHES: WearDef[] = [
  { id: 'basic', name: 'Đồ cơ bản', price: 0 },
  { id: 'overalls', name: 'Yếm nông dân', price: 400 },
  { id: 'dress', name: 'Đầm xòe', price: 500 },
  { id: 'skirt', name: 'Chân váy', price: 350 },
  { id: 'stripe', name: 'Áo kẻ sọc', price: 300 },
  { id: 'floral', name: 'Áo hoa', price: 450 },
  { id: 'sailor', name: 'Thủy thủ', price: 550 },
  { id: 'sailor_bow', name: 'Thủy thủ nơ', price: 600 },
  { id: 'spaghetti', name: 'Hai dây', price: 380 },
  { id: 'sporty', name: 'Thể thao', price: 420 },
  { id: 'suit', name: 'Vest lịch lãm', price: 900 },
  { id: 'pants_suit', name: 'Vest quần âu', price: 950 },
  { id: 'witch', name: 'Phù thủy', price: 800 },
  { id: 'pumpkin', name: 'Bí ngô Halloween', price: 800 },
  { id: 'spooky', name: 'Ma quái', price: 850 },
  { id: 'skull', name: 'Đầu lâu', price: 850 },
  { id: 'clown', name: 'Chú hề', price: 700 }
];

// Phụ kiện (mũ, kính, mặt nạ, khuyên tai, râu)
export const ACCESSORIES: WearDef[] = [
  { id: 'hat_cowboy', name: 'Mũ cao bồi', price: 500 },
  { id: 'hat_lucky', name: 'Mũ may mắn', price: 600 },
  { id: 'hat_witch', name: 'Mũ phù thủy', price: 700 },
  { id: 'hat_pumpkin', name: 'Mũ bí ngô', price: 650 },
  { id: 'hat_pumpkin_purple', name: 'Mũ bí ngô tím', price: 680 },
  { id: 'glasses', name: 'Kính cận', price: 250 },
  { id: 'glasses_sun', name: 'Kính râm', price: 300 },
  { id: 'mask_clown_red', name: 'Mũi hề đỏ', price: 200 },
  { id: 'mask_clown_blue', name: 'Mũi hề xanh', price: 200 },
  { id: 'mask_spooky', name: 'Mặt nạ ma', price: 450 },
  { id: 'earring_red', name: 'Khuyên tai đỏ', price: 150 },
  { id: 'earring_red_silver', name: 'Khuyên bạc đỏ', price: 220 },
  { id: 'earring_emerald', name: 'Khuyên ngọc lục', price: 350 },
  { id: 'earring_emerald_silver', name: 'Khuyên bạc ngọc', price: 420 },
  { id: 'beard', name: 'Râu quai nón', price: 100 }
];

// Nhóm phụ kiện để mặc chồng: mỗi nhóm chỉ đeo 1 món
export function accSlot(id: string): 'hat' | 'glasses' | 'mask' | 'earring' | 'beard' {
  if (id.startsWith('hat')) return 'hat';
  if (id.startsWith('glasses')) return 'glasses';
  if (id.startsWith('mask')) return 'mask';
  if (id.startsWith('earring')) return 'earring';
  return 'beard';
}

export const HAIR_COLOR_NAMES = ['Đen', 'Vàng', 'Nâu', 'Nâu nhạt', 'Đồng', 'Ngọc lục', 'Xanh lá', 'Xám', 'Tím nhạt', 'Xanh navy', 'Hồng', 'Tím', 'Đỏ', 'Ngọc lam'];
export const CLOTH_COLOR_NAMES = ['Đen', 'Xanh', 'Xanh nhạt', 'Nâu', 'Xanh lá', 'Lá nhạt', 'Hồng', 'Tím', 'Đỏ', 'Trắng'];
