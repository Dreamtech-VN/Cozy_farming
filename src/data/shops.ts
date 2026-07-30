// ===== Shop NPC =====
import { CROP_LIST } from './crops';
import { FURNITURE_LIST, HOUSE_LEVELS } from './furniture';

export interface ShopEntry { itemId: string; }
export interface ShopDef {
  id: string;
  name: string;
  icon: string;
  items: string[];         // itemId có bán (giá lấy từ ITEMS)
  buysKinds: string[];     // loại vật phẩm shop thu mua
  special?: 'fashion' | 'house' | 'fishing' | 'barber' | 'salon';
}

export const SHOPS: Record<string, ShopDef> = {
  shop_seed: {
    id: 'shop_seed', name: 'Tiệm hạt giống Cô Mai', icon: '🌱',
    items: [...CROP_LIST.map(c => `seed_${c.id}`), 'fertilizer'],
    buysKinds: ['crop', 'product']
  },
  shop_general: {
    id: 'shop_general', name: 'Bách hóa Chú Hùng', icon: '🏪',
    items: ['fertilizer', 'feed', 'food_cake', 'food_juice', 'lucky_ticket', 'tool_basket', 'tool_axe', 'tool_shovel'],
    buysKinds: ['crop', 'product', 'fish', 'insect', 'material', 'food']
  },
  shop_fishing: {
    id: 'shop_fishing', name: 'Tiệm câu Ông Biển', icon: '🎣',
    items: [], buysKinds: ['fish'], special: 'fishing'
  },
  shop_fashion: {
    id: 'shop_fashion', name: 'Thời trang Cô Trang', icon: '👗',
    items: [], buysKinds: [], special: 'fashion'
  },
  shop_barber: {
    id: 'shop_barber', name: 'Tiệm cắt tóc Anh Phong', icon: '💈',
    items: [], buysKinds: [], special: 'barber'
  },
  shop_salon: {
    id: 'shop_salon', name: 'Viện thẩm mỹ Cô Diễm', icon: '💄',
    items: [], buysKinds: [], special: 'salon'
  },
  shop_gift: {
    id: 'shop_gift', name: 'Tiệm quà Anh Quà', icon: '🎁',
    items: ['gift_flower', 'gift_choco', 'gift_teddy', 'food_cake'],
    buysKinds: ['gift']
  },
  shop_house: {
    id: 'shop_house', name: 'Nhà đất Chị Lan', icon: '🏠',
    items: FURNITURE_LIST.map(f => f.id),
    buysKinds: ['furniture', 'deco'], special: 'house'
  }
};

export { HOUSE_LEVELS };
