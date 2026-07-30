// ===== Khu vực (map) — mỗi zone là 1 cấu hình cho WorldScene =====

export type GroundKind = 'grass' | 'sand' | 'wood' | 'stone';

export interface Portal { x: number; y: number; to: string; label: string; icon: string }
export interface NpcDef {
  id: string; name: string; x: number; y: number; charIndex: number;
  gender: number;          // 1 nam, 2 nữ (theo quy ước data Avatar)
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
  bg?: string;             // nền ảnh (assets/lttt/maps/<bg>.png) thay cho nền procedural
  water?: { x: number; y: number; w: number; h: number }[]; // vùng nước trên nền ảnh (tile)
  walkTop?: number;        // giới hạn đi lại trên nền ảnh (hàng tile)
  walkBottom?: number;
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
    // map HD dựng từ imagemap Avatar (map 7 đã vá chữ) + nhà/hồ/cây HD Avatar
    id: 'farm', name: 'Nông trại', icon: '🌾', w: 63, h: 32, ground: 'grass',
    spawn: { x: 31, y: 15 }, gate: 'farm_gate',
    bg: 'farmbg', walkTop: 7, walkBottom: 29,
    portals: [
      { x: 9, y: 13, to: 'house', label: 'Nhà bếp', icon: '🏠' },
      { x: 31, y: 29, to: 'farm_gate', label: 'Ra cổng', icon: '🚏' }
    ],
    npcs: [
      { id: 'npc_mai', name: 'Cô Mai', x: 15, y: 14, charIndex: 5, gender: 2, shop: 'shop_seed', lines: ['Chào con! Mua hạt giống không?', 'Nhớ tưới nước mỗi ngày nhé!'] }
    ],
    features: ['farm', 'barn', 'fishing', 'insects']
  },
  town: {
    id: 'town', name: 'Thành phố', icon: '🏙️', w: 50, h: 29, ground: 'stone',
    spawn: { x: 25, y: 18 }, gate: 'town_gate',
    bg: '22', walkTop: 11, walkBottom: 25,
    portals: [
      { x: 12, y: 12, to: 'gamecenter', label: 'Game Center', icon: '🕹️' },
      { x: 26, y: 12, to: 'school', label: 'Trường học', icon: '🏫' },
      { x: 41, y: 12, to: 'mall', label: 'Khu mua sắm', icon: '🛍️' },
      { x: 4, y: 13, to: 'house', label: 'Nhà riêng', icon: '🏠' },
      { x: 45, y: 24, to: 'town_gate', label: 'Ra cổng', icon: '🚏' }
    ],
    npcs: [
      { id: 'npc_hung', name: 'Chú Hùng', x: 18, y: 18, charIndex: 3, gender: 1, shop: 'shop_general', lines: ['Cửa hàng bách hóa đây!', 'Có phân bón, thức ăn gia súc, đủ cả.'] },
      { id: 'npc_lan', name: 'Chị Lan', x: 33, y: 20, charIndex: 6, gender: 2, shop: 'shop_house', lines: ['Muốn mua nhà hay nội thất không nè?'] }
    ],
    features: ['insects']
  },
  beach: {
    id: 'beach', name: 'Bãi biển', icon: '🏖️', w: 44, h: 30, ground: 'sand',
    spawn: { x: 6, y: 15 }, gate: 'beach_gate',
    portals: [{ x: 6, y: 28, to: 'beach_gate', label: 'Ra cổng', icon: '🚏' }],
    npcs: [
      { id: 'npc_bien', name: 'Ông Biển', x: 10, y: 9, charIndex: 2, gender: 1, shop: 'shop_fishing', lines: ['Cần câu tốt mới câu được cá to!', 'Cá huyền thoại chỉ cắn cần vàng.'] }
    ],
    features: ['fishing', 'insects', 'water_edge']
  },
  pond: {
    id: 'pond', name: 'Hồ câu', icon: '🎏', w: 63, h: 24, ground: 'grass',
    spawn: { x: 55, y: 8 }, gate: 'pond_gate',
    bg: '15', walkTop: 5,
    water: [{ x: 12, y: 9, w: 36, h: 15 }],
    portals: [{ x: 56, y: 21, to: 'pond_gate', label: 'Ra cổng', icon: '🚏' }],
    npcs: [],
    features: ['fishing', 'insects', 'water_edge']
  },
  park: {
    id: 'park', name: 'Công viên', icon: '🌳', w: 57, h: 32, ground: 'grass',
    spawn: { x: 44, y: 20 }, gate: 'park_gate',
    bg: '4', walkTop: 10, walkBottom: 27,
    water: [{ x: 9, y: 11, w: 26, h: 6 }],
    portals: [{ x: 28, y: 26, to: 'park_gate', label: 'Ra cổng', icon: '🚏' }],
    npcs: [
      { id: 'npc_tuan', name: 'Bé Tuấn', x: 30, y: 20, charIndex: 7, gender: 1, lines: ['Chơi oẳn tù tì với em không?'], minigame: 'rps' }
    ],
    features: ['insects']
  },
  school: {
    id: 'school', gate: 'town_gate', name: 'Trường học', icon: '🏫', w: 60, h: 33, ground: 'wood', indoor: true,
    spawn: { x: 30, y: 24 },
    bg: '101', walkTop: 14, walkBottom: 30,
    portals: [{ x: 45, y: 28, to: 'town', label: 'Thành phố', icon: '🏙️' }],
    npcs: [
      { id: 'npc_thay', name: 'Thầy Giáo', x: 24, y: 18, charIndex: 4, gender: 1, lines: ['Chăm học, chăm làm nhé!', 'Muốn thử tài cờ tướng không?'], minigame: 'xiangqi' }
    ],
    features: []
  },
  gamecenter: {
    id: 'gamecenter', gate: 'town_gate', name: 'Game Center', icon: '🕹️', w: 42, h: 31, ground: 'wood', indoor: true,
    spawn: { x: 21, y: 20 },
    bg: '10', walkTop: 13, walkBottom: 29,
    portals: [{ x: 36, y: 27, to: 'town', label: 'Thành phố', icon: '🏙️' }],
    npcs: [
      { id: 'npc_caro', name: 'Máy Caro', x: 13, y: 15, charIndex: 1, gender: 1, lines: ['Cờ caro 5 quân — dám đấu không?'], minigame: 'caro' },
      { id: 'npc_cotuong', name: 'Cụ Cờ', x: 21, y: 15, charIndex: 2, gender: 1, lines: ['Cờ tướng là tinh hoa!'], minigame: 'xiangqi' },
      { id: 'npc_rps', name: 'Bé Kéo Búa', x: 28, y: 15, charIndex: 7, gender: 2, lines: ['Oẳn tù tì ra cái gì ra cái này!'], minigame: 'rps' }
    ],
    features: []
  },
  mall: {
    id: 'mall', gate: 'town_gate', name: 'Khu mua sắm', icon: '🛍️', w: 44, h: 32, ground: 'wood', indoor: true,
    spawn: { x: 22, y: 20 },
    bg: '24', walkTop: 13, walkBottom: 23,
    portals: [{ x: 40, y: 22, to: 'town', label: 'Thành phố', icon: '🏙️' }],
    npcs: [
      { id: 'npc_fashion', name: 'Cô Trang', x: 10, y: 16, charIndex: 6, gender: 2, shop: 'shop_fashion', lines: ['Thời trang mới về nè!'] },
      { id: 'npc_gift', name: 'Anh Quà', x: 28, y: 16, charIndex: 0, gender: 1, shop: 'shop_gift', lines: ['Quà tặng cho người thương~'] }
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
