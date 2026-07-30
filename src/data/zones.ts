// ===== Khu vực (map) — mỗi zone là 1 cấu hình cho WorldScene =====

export type GroundKind = 'grass' | 'sand' | 'wood' | 'stone';

export interface Portal { x: number; y: number; to: string; label: string; icon: string }
export interface NpcDef {
  id: string; name: string; x: number; y: number; charIndex: number;
  shop?: string;           // mở shop khi nói chuyện
  lines: string[];         // thoại
  minigame?: 'caro' | 'xiangqi' | 'rps';
}

export interface ZoneDef {
  id: string;
  name: string;
  icon: string;
  w: number;               // theo tile 16px
  h: number;
  ground: GroundKind;
  spawn: { x: number; y: number };
  portals: Portal[];
  npcs: NpcDef[];
  features: ('farm' | 'barn' | 'fishing' | 'insects' | 'house_door' | 'trees' | 'flowers' | 'water_edge')[];
  indoor?: boolean;
  road?: boolean;          // map cổng: có đường xe chạy + trạm buýt ở mép dưới
  gate?: string;           // zone cổng phục vụ khu này (đi xe buýt phải qua đây)
  gateTo?: string;         // (zone cổng) map chính mà cổng dẫn vào
}

// Tạo map cổng cho 1 khu: dưới là đường xe, trên là vỉa hè + cổng vào
function gateZone(id: string, name: string, icon: string, to: string, ground: GroundKind): ZoneDef {
  return {
    id, name: `Cổng ${name}`, icon, w: 40, h: 16, ground,
    road: true, gateTo: to,
    spawn: { x: 20, y: 8 },
    portals: [{ x: 20, y: 5, to, label: `Vào ${name}`, icon }],
    npcs: [],
    features: []
  };
}

export const ZONES: Record<string, ZoneDef> = {
  farm_gate: gateZone('farm_gate', 'Nông trại', '🌾', 'farm', 'grass'),
  town_gate: gateZone('town_gate', 'Thành phố', '🏙️', 'town', 'stone'),
  beach_gate: gateZone('beach_gate', 'Bãi biển', '🏖️', 'beach', 'sand'),
  park_gate: gateZone('park_gate', 'Công viên', '🌳', 'park', 'grass'),
  pond_gate: gateZone('pond_gate', 'Hồ câu', '🎏', 'pond', 'grass'),
  farm: {
    id: 'farm', name: 'Nông trại', icon: '🌾', w: 44, h: 34, ground: 'grass',
    spawn: { x: 9, y: 10 }, gate: 'farm_gate',
    portals: [{ x: 22, y: 32, to: 'farm_gate', label: 'Ra cổng', icon: '🚏' }],
    npcs: [
      { id: 'npc_mai', name: 'Cô Mai', x: 8, y: 6, charIndex: 5, shop: 'shop_seed', lines: ['Chào con! Mua hạt giống không?', 'Nhớ tưới nước mỗi ngày nhé!'] }
    ],
    features: ['farm', 'barn', 'insects', 'trees']
  },
  town: {
    id: 'town', name: 'Thành phố', icon: '🏙️', w: 48, h: 36, ground: 'stone',
    spawn: { x: 20, y: 20 }, gate: 'town_gate',
    portals: [
      { x: 12, y: 10, to: 'gamecenter', label: 'Game Center', icon: '🕹️' },
      { x: 24, y: 10, to: 'school', label: 'Trường học', icon: '🏫' },
      { x: 36, y: 10, to: 'mall', label: 'Khu mua sắm', icon: '🛍️' },
      { x: 24, y: 30, to: 'house', label: 'Nhà riêng', icon: '🏠' },
      { x: 6, y: 34, to: 'town_gate', label: 'Ra cổng', icon: '🚏' }
    ],
    npcs: [
      { id: 'npc_hung', name: 'Chú Hùng', x: 16, y: 22, charIndex: 3, shop: 'shop_general', lines: ['Cửa hàng bách hóa đây!', 'Có phân bón, thức ăn gia súc, đủ cả.'] },
      { id: 'npc_lan', name: 'Chị Lan', x: 32, y: 24, charIndex: 6, shop: 'shop_house', lines: ['Muốn mua nhà hay nội thất không nè?'] }
    ],
    features: ['insects', 'flowers']
  },
  beach: {
    id: 'beach', name: 'Bãi biển', icon: '🏖️', w: 44, h: 30, ground: 'sand',
    spawn: { x: 6, y: 15 }, gate: 'beach_gate',
    portals: [{ x: 6, y: 28, to: 'beach_gate', label: 'Ra cổng', icon: '🚏' }],
    npcs: [
      { id: 'npc_bien', name: 'Ông Biển', x: 10, y: 9, charIndex: 2, shop: 'shop_fishing', lines: ['Cần câu tốt mới câu được cá to!', 'Cá huyền thoại chỉ cắn cần vàng.'] }
    ],
    features: ['fishing', 'insects', 'water_edge']
  },
  pond: {
    id: 'pond', name: 'Hồ câu', icon: '🎏', w: 36, h: 28, ground: 'grass',
    spawn: { x: 18, y: 5 }, gate: 'pond_gate',
    portals: [{ x: 18, y: 26, to: 'pond_gate', label: 'Ra cổng', icon: '🚏' }],
    npcs: [],
    features: ['fishing', 'insects', 'trees', 'water_edge']
  },
  park: {
    id: 'park', name: 'Công viên', icon: '🌳', w: 40, h: 30, ground: 'grass',
    spawn: { x: 6, y: 15 }, gate: 'park_gate',
    portals: [{ x: 20, y: 28, to: 'park_gate', label: 'Ra cổng', icon: '🚏' }],
    npcs: [
      { id: 'npc_tuan', name: 'Bé Tuấn', x: 20, y: 10, charIndex: 7, lines: ['Chơi oẳn tù tì với em không?'], minigame: 'rps' }
    ],
    features: ['insects', 'trees', 'flowers']
  },
  school: {
    id: 'school', gate: 'town_gate', name: 'Trường học', icon: '🏫', w: 28, h: 20, ground: 'wood', indoor: true,
    spawn: { x: 14, y: 17 },
    portals: [{ x: 14, y: 19, to: 'town', label: 'Thành phố', icon: '🏙️' }],
    npcs: [
      { id: 'npc_thay', name: 'Thầy Giáo', x: 14, y: 5, charIndex: 4, lines: ['Chăm học, chăm làm nhé!', 'Muốn thử tài cờ tướng không?'], minigame: 'xiangqi' }
    ],
    features: []
  },
  gamecenter: {
    id: 'gamecenter', gate: 'town_gate', name: 'Game Center', icon: '🕹️', w: 28, h: 20, ground: 'wood', indoor: true,
    spawn: { x: 14, y: 17 },
    portals: [{ x: 14, y: 19, to: 'town', label: 'Thành phố', icon: '🏙️' }],
    npcs: [
      { id: 'npc_caro', name: 'Máy Caro', x: 8, y: 6, charIndex: 1, lines: ['Cờ caro 5 quân — dám đấu không?'], minigame: 'caro' },
      { id: 'npc_cotuong', name: 'Cụ Cờ', x: 14, y: 6, charIndex: 2, lines: ['Cờ tướng là tinh hoa!'], minigame: 'xiangqi' },
      { id: 'npc_rps', name: 'Bé Kéo Búa', x: 20, y: 6, charIndex: 7, lines: ['Oẳn tù tì ra cái gì ra cái này!'], minigame: 'rps' }
    ],
    features: []
  },
  mall: {
    id: 'mall', gate: 'town_gate', name: 'Khu mua sắm', icon: '🛍️', w: 30, h: 22, ground: 'wood', indoor: true,
    spawn: { x: 15, y: 19 },
    portals: [{ x: 15, y: 21, to: 'town', label: 'Thành phố', icon: '🏙️' }],
    npcs: [
      { id: 'npc_fashion', name: 'Cô Trang', x: 8, y: 6, charIndex: 6, shop: 'shop_fashion', lines: ['Thời trang mới về nè!'] },
      { id: 'npc_gift', name: 'Anh Quà', x: 22, y: 6, charIndex: 0, shop: 'shop_gift', lines: ['Quà tặng cho người thương~'] }
    ],
    features: []
  },
  house: {
    id: 'house', gate: 'town_gate', name: 'Nhà riêng', icon: '🏠', w: 14, h: 12, ground: 'wood', indoor: true,
    spawn: { x: 7, y: 10 },
    portals: [{ x: 7, y: 11, to: 'town', label: 'Thành phố', icon: '🏙️' }],
    npcs: [],
    features: []
  }
};

export const ZONE_LIST = Object.values(ZONES);
