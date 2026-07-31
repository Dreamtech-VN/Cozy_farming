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
  features: ('farm' | 'barn' | 'fishing' | 'fishfarm' | 'house_door' | 'trees' | 'flowers' | 'water_edge')[];
  indoor?: boolean;
  // Nền map nào có sẵn con đường nhựa thì cho xe cộ AI chạy bên dưới mốc này (hàng tile)
  traffic?: { topTile: number };
  // Trạm xe buýt: đứng gần là bắt xe về bản đồ thành phố để sang khu khác
  // (Lttt: "Sau khi dạo một vòng hãy đến Trạm Xe Buýt để trở lại nơi này nhé!")
  busStop?: { x: number; y: number };
  // Khu chính hiện trên bản đồ thành phố; map con (nông trại riêng, nhà, nội
  // thất...) không hiện trên bản đồ mà phải đi qua cổng trong khu.
  hub?: boolean;
  bg?: string;             // nền ảnh (assets/lttt/maps/<bg>.png) thay cho nền procedural
  water?: { x: number; y: number; w: number; h: number }[]; // vùng nước trên nền ảnh (tile)
  skyTop?: number;         // bề cao vùng trời phía trên map nền (px)
  walkTop?: number;        // giới hạn đi lại trên nền ảnh (hàng tile)
  walkBottom?: number;
}

export const ZONES: Record<string, ZoneDef> = {
  // Khu Nông Trại — nền map 26 gốc Avatar (biển FARM + cửa hàng + đường đất).
  // Lttt: "Khu vực nông trại có 4 nơi bạn có thể vào: Cửa hàng, ATM, Nông trại
  // của mình, và Nông trại của bạn bè." Bản này mới có Cửa hàng + Nông trại
  // của mình; ATM và nông trại bạn bè để dành.
  farm_gate: {
    id: 'farm_gate', name: 'Khu Nông Trại', icon: '', w: 82, h: 29, ground: 'grass',
    spawn: { x: 26, y: 16 }, hub: true,
    bg: 'farmgate', walkTop: 11, walkBottom: 24, skyTop: 150,
    traffic: { topTile: 25 }, busStop: { x: 14, y: 22 },
    portals: [{ x: 26, y: 11, to: 'farm', label: 'Nông trại của bạn', icon: '' }],
    npcs: [],
    features: []
  },
  farm: {
    // Nền là map 25 gốc Avatar (ghép đủ 6 mảnh): nhà bếp, nhà kho, sân rào
    // nuôi thú, hồ cá và đường đất đều đã vẽ sẵn nên không chồng lên nhau.
    id: 'farm', name: 'Nông trại', icon: '', w: 127, h: 33, ground: 'grass',
    spawn: { x: 34, y: 25 },
    bg: 'farmbg', walkTop: 11, walkBottom: 28, skyTop: 150,
    water: [{ x: 110, y: 16, w: 12, h: 12 }],   // hồ cá vẽ sẵn ở góc phải
    // Nông trại riêng là map con: ra ngoài là về khu Nông Trại (nơi có cửa
    // hàng + trạm xe buýt), giống Lttt. Nhà riêng nằm ở nhà trắng Thị trấn.
    portals: [{ x: 28, y: 27, to: 'farm_gate', label: 'Ra khu Nông Trại', icon: '' }],
    npcs: [
      { id: 'npc_mai', name: 'Cô Mai', x: 24, y: 16, charIndex: 5, gender: 2, shop: 'shop_seed', lines: ['Chào con! Mua hạt giống không?', 'Nhớ tưới nước mỗi ngày nhé!'] }
    ],
    features: ['farm', 'barn', 'fishfarm']
  },
  town: {
    id: 'town', name: 'Thành phố', icon: '', w: 50, h: 29, ground: 'stone',
    spawn: { x: 25, y: 18 }, hub: true, busStop: { x: 33, y: 24 },
    bg: '22', walkTop: 11, walkBottom: 25, traffic: { topTile: 26 },
    portals: [
      { x: 12, y: 12, to: 'gamecenter', label: 'Game Center', icon: '' },
      { x: 26, y: 12, to: 'school', label: 'Trường học', icon: '' },
      { x: 41, y: 12, to: 'mall', label: 'Khu mua sắm', icon: '' },
      { x: 4, y: 13, to: 'house', label: 'Nhà riêng', icon: '' },
    ],
    npcs: [
      { id: 'npc_hung', name: 'Chú Hùng', x: 18, y: 18, charIndex: 3, gender: 1, shop: 'shop_general', lines: ['Cửa hàng bách hóa đây!', 'Có phân bón, thức ăn gia súc, đủ cả.'] },
      { id: 'npc_lan', name: 'Chị Lan', x: 33, y: 20, charIndex: 6, gender: 2, shop: 'shop_house', lines: ['Muốn mua nhà hay nội thất không nè?'] }
    ],
    features: []
  },
  beach: {
    id: 'beach', name: 'Bãi biển', icon: '', w: 44, h: 30, ground: 'sand',
    spawn: { x: 6, y: 15 }, hub: true, busStop: { x: 20, y: 20 },
    portals: [],
    npcs: [
      { id: 'npc_bien', name: 'Ông Biển', x: 10, y: 9, charIndex: 2, gender: 1, shop: 'shop_fishing', lines: ['Cần câu tốt mới câu được cá to!', 'Cá huyền thoại chỉ cắn cần vàng.'] }
    ],
    features: ['fishing', 'water_edge']
  },
  pond: {
    id: 'pond', name: 'Hồ câu', icon: '', w: 63, h: 24, ground: 'grass',
    spawn: { x: 55, y: 8 }, hub: true, busStop: { x: 57, y: 10 },
    bg: '15', walkTop: 5,
    water: [{ x: 12, y: 9, w: 36, h: 15 }],
    portals: [],
    npcs: [],
    features: ['fishing', 'water_edge']
  },
  park: {
    id: 'park', name: 'Công viên', icon: '', w: 57, h: 32, ground: 'grass',
    spawn: { x: 44, y: 20 }, hub: true, busStop: { x: 50, y: 24 },
    bg: '4', walkTop: 10, walkBottom: 27,
    water: [{ x: 9, y: 11, w: 26, h: 6 }],
    portals: [],
    npcs: [
      { id: 'npc_tuan', name: 'Bé Tuấn', x: 30, y: 20, charIndex: 7, gender: 1, lines: ['Chơi oẳn tù tì với em không?'], minigame: 'rps' }
    ],
    features: []
  },
  school: {
    id: 'school', name: 'Trường học', icon: '', w: 60, h: 33, ground: 'wood', indoor: true,
    spawn: { x: 30, y: 24 },
    bg: '101', walkTop: 14, walkBottom: 30,
    portals: [{ x: 45, y: 28, to: 'town', label: 'Thành phố', icon: '' }],
    npcs: [
      { id: 'npc_thay', name: 'Thầy Giáo', x: 24, y: 18, charIndex: 4, gender: 1, lines: ['Chăm học, chăm làm nhé!', 'Muốn thử tài cờ tướng không?'], minigame: 'xiangqi' }
    ],
    features: []
  },
  gamecenter: {
    id: 'gamecenter', name: 'Game Center', icon: '', w: 42, h: 31, ground: 'wood', indoor: true,
    spawn: { x: 21, y: 20 },
    bg: '10', walkTop: 13, walkBottom: 29,
    portals: [{ x: 36, y: 27, to: 'town', label: 'Thành phố', icon: '' }],
    npcs: [
      { id: 'npc_caro', name: 'Máy Caro', x: 13, y: 15, charIndex: 1, gender: 1, lines: ['Cờ caro 5 quân — dám đấu không?'], minigame: 'caro' },
      { id: 'npc_cotuong', name: 'Cụ Cờ', x: 21, y: 15, charIndex: 2, gender: 1, lines: ['Cờ tướng là tinh hoa!'], minigame: 'xiangqi' },
      { id: 'npc_rps', name: 'Bé Kéo Búa', x: 28, y: 15, charIndex: 7, gender: 2, lines: ['Oẳn tù tì ra cái gì ra cái này!'], minigame: 'rps' }
    ],
    features: []
  },
  mall: {
    id: 'mall', name: 'Khu mua sắm', icon: '', w: 44, h: 32, ground: 'wood', indoor: true,
    spawn: { x: 22, y: 20 },
    bg: '24', walkTop: 13, walkBottom: 23,
    portals: [{ x: 40, y: 22, to: 'town', label: 'Thành phố', icon: '' }],
    npcs: [
      { id: 'npc_fashion', name: 'Cô Trang', x: 10, y: 16, charIndex: 6, gender: 2, shop: 'shop_fashion', lines: ['Thời trang mới về nè!'] },
      { id: 'npc_gift', name: 'Anh Quà', x: 28, y: 16, charIndex: 0, gender: 1, shop: 'shop_gift', lines: ['Quà tặng cho người thương~'] },
      { id: 'npc_barber', name: 'Anh Phong', x: 16, y: 16, charIndex: 3, gender: 1, shop: 'shop_barber', lines: ['Cắt kiểu gì cũng đẹp!', 'Đổi tóc là đổi vận đó nha.'] },
      { id: 'npc_salon', name: 'Cô Diễm', x: 22, y: 16, charIndex: 7, gender: 2, shop: 'shop_salon', lines: ['Vào đây chị làm cho đôi mắt biết nói.', 'Ánh mắt là hồn của gương mặt đó em.'] }
    ],
    features: []
  },
  house: {
    id: 'house', name: 'Nhà riêng', icon: '', w: 14, h: 12, ground: 'wood', indoor: true,
    spawn: { x: 7, y: 10 },
    portals: [{ x: 7, y: 11, to: 'town', label: 'Thành phố', icon: '' }],
    npcs: [],
    features: []
  }
};

export const ZONE_LIST = Object.values(ZONES);
