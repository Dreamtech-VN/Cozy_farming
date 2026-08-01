// ===== Khu vực (map) — mỗi zone là 1 cấu hình cho WorldScene =====
//
// Bố cục bám theo client Lttt: thành phố chia thành các KHU (T.nameRegion trong
// client java: "Khu nhà ở, Khu sinh thái, Sân bay, Khu giải trí, Khu mua sắm,
// Công viên, Khu ngoại ô, Nông trại"), mỗi khu là một map ngoài trời có trạm xe
// buýt để quay lại bản đồ thành phố. Cửa hàng nằm TRONG khu: bấm vào công trình
// là đi vào map nội thất riêng của tiệm đó.
//
// Nền lấy nguyên imageMap của Avatar, ghép bằng scripts/build_lttt_maps.py:
//   22 Khu nhà ở · 24 Khu mua sắm · 10 Khu giải trí · 4 Công viên ·
//   15 Hồ câu · 14 Bãi biển · 26 Khu Nông Trại · 25 Nông trại
//   58 tiệm thời trang · 59 tiệm quà · 104 mỹ viện · 105 tiệm thú cưng ·
//   101 trường học
// (Sân bay và Khu ngoại ô chưa dựng: bộ imageMap trong APK không có nền hai khu này.)

export type GroundKind = 'grass' | 'sand' | 'wood' | 'stone';

// spot: 'building' (mặc định) = khung bấm trùm cả mặt tiền công trình;
// 'door' = chỉ ô cửa (dùng cho cửa ra của map nội thất, khỏi bấm nhầm khi
// chỉ muốn đi vài bước quanh cửa)
export interface Portal { x: number; y: number; to: string; label: string; icon: string; spot?: 'building' | 'door' }
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
  // thất tiệm...) không hiện trên bản đồ mà phải đi qua cửa trong khu.
  hub?: boolean;
  bg?: string;             // nền ảnh (assets/lttt/maps/<bg>.png) thay cho nền procedural
  // id map Lttt trong src/data/lttt-maps.json: có thì lấy NGUYÊN lưới ô gốc
  // (đi được / mặt tiền công trình / trạm buýt / chỗ chờ) thay cho walkTop,
  // walkBottom và water khai tay
  lttt?: string;
  water?: { x: number; y: number; w: number; h: number }[]; // vùng nước trên nền ảnh (tile)
  skyTop?: number;         // bề cao vùng trời phía trên map nền (px)
  walkTop?: number;        // giới hạn đi lại trên nền ảnh (hàng tile)
  walkBottom?: number;
}

export const ZONES: Record<string, ZoneDef> = {
  // ===================== KHU NÔNG TRẠI =====================
  // Lttt: "Khu vực nông trại có 4 nơi bạn có thể vào: Cửa hàng, ATM, Nông trại
  // của mình, và Nông trại của bạn bè."
  farm_gate: {
    id: 'farm_gate', name: 'Khu Nông Trại', icon: '', w: 82, h: 29, ground: 'grass',
    spawn: { x: 26, y: 16 }, hub: true,
    bg: 'farmgate', walkTop: 11, walkBottom: 24, skyTop: 150,
    traffic: { topTile: 25 }, busStop: { x: 14, y: 22 },
    portals: [{ x: 26, y: 11, to: 'farm', label: 'Nông trại của bạn', icon: '' }],
    // lối mòn bên trái map dẫn sang nông trại bạn bè (mở bằng panel)
    npcs: [],
    features: []
  },
  farm: {
    // Nền là map 25 gốc Avatar (ghép đủ 6 mảnh): nhà bếp, nhà kho, sân rào
    // nuôi thú, hồ cá và đường đất đều đã vẽ sẵn nên không chồng lên nhau.
    id: 'farm', name: 'Nông trại', icon: '', w: 127, h: 33, ground: 'grass',
    spawn: { x: 34, y: 25 },
    bg: 'farmbg', walkTop: 11, walkBottom: 28, skyTop: 150,
    // hồ cá vẽ sẵn ở góc phải — mặt nước thật rộng 108.8..123.3 x 15.4..29.4 tile,
    // khai thiếu 1 ô mỗi bên nên vành hồ đứng lên được (đi trên mặt nước)
    // Hồ cá vẽ sẵn góc phải. Trước khai gọn 1 hình chữ nhật 12x12 nên vành hồ
    // (rộng hơn 1 ô mỗi bên) đứng lên được — nhìn như đi trên mặt nước. Nay bám
    // đúng mặt nước đo từ ảnh, chia theo từng dải hàng.
    water: [
      { x: 109, y: 15, w: 14, h: 5 }, { x: 109, y: 20, w: 15, h: 5 },
      { x: 108, y: 25, w: 16, h: 2 }, { x: 109, y: 27, w: 15, h: 2 },
      { x: 111, y: 29, w: 12, h: 1 }
    ],
    portals: [{ x: 28, y: 27, to: 'farm_gate', label: 'Ra khu Nông Trại', icon: '', spot: 'door' }],
    npcs: [
      { id: 'npc_mai', name: 'Cô Mai', x: 24, y: 16, charIndex: 5, gender: 2, lines: ['Chào con! Muốn mua hạt giống thì ra Cửa hàng ngoài khu Nông Trại nhé.', 'Nhớ tưới nước mỗi ngày nha!'] }
    ],
    features: ['farm', 'barn', 'fishfarm']
  },

  // ===================== KHU NHÀ Ở =====================
  // map 22: dãy 8 căn nhà 2-3 tầng, vỉa hè lát đá, đường nhựa chạy dọc mép dưới
  town: {
    id: 'town', name: 'Khu nhà ở', icon: '', w: 151, h: 30, ground: 'stone',
    spawn: { x: 74, y: 20 }, hub: true,
    bg: '22', lttt: '22', traffic: { topTile: 27 },
    portals: [],
    npcs: [],
    features: []
  },
  school: {
    // map 101: sàn gỗ, kệ sách, quầy có sách vở + đồng hồ — dùng làm Trường học
    id: 'school', name: 'Trường học', icon: '', w: 60, h: 33, ground: 'wood', indoor: true,
    spawn: { x: 28, y: 26 },
    bg: '101', lttt: '101',
    portals: [],
    npcs: [
      { id: 'npc_thay', name: 'Thầy Giáo', x: 32, y: 14, charIndex: 4, gender: 1, lines: ['Chăm học, chăm làm nhé!', 'Muốn thử tài cờ tướng không?'], minigame: 'xiangqi' }
    ],
    features: []
  },
  house: {
    id: 'house', name: 'Nhà riêng', icon: '', w: 14, h: 12, ground: 'wood', indoor: true,
    spawn: { x: 7, y: 10 },
    portals: [{ x: 7, y: 11, to: 'town', label: 'Ra Khu nhà ở', icon: '', spot: 'door' }],
    npcs: [],
    features: []
  },

  // ===================== KHU MUA SẮM =====================
  // map 24: Mỹ Viện · Gift · ATM · tiệm thú cưng · Premium · trang sức · Shop
  mall: {
    id: 'mall', name: 'Khu mua sắm', icon: '', w: 133, h: 33, ground: 'stone',
    spawn: { x: 62, y: 26 }, hub: true,
    bg: '24', lttt: '24', traffic: { topTile: 29 },
    portals: [],
    npcs: [],
    features: []
  },
  fashion_shop: {
    id: 'fashion_shop', name: 'Tiệm thời trang', icon: '', w: 36, h: 33, ground: 'wood', indoor: true,
    spawn: { x: 22, y: 26 },
    bg: '58', lttt: '58',
    // cô bán hàng đã vẽ sẵn sau quầy trong ảnh nền -> bấm vào quầy là mở shop
    portals: [],
    npcs: [],
    features: []
  },
  gift_shop: {
    id: 'gift_shop', name: 'Tiệm quà', icon: '', w: 36, h: 33, ground: 'wood', indoor: true,
    spawn: { x: 16, y: 26 },
    bg: '59', lttt: '59',
    portals: [],
    npcs: [],
    features: []
  },
  salon_shop: {
    id: 'salon_shop', name: 'Mỹ Viện', icon: '', w: 54, h: 33, ground: 'wood', indoor: true,
    spawn: { x: 26, y: 26 },
    bg: '104', lttt: '104',
    portals: [],
    npcs: [
      { id: 'npc_barber', name: 'Anh Phong', x: 21, y: 14, charIndex: 3, gender: 1, shop: 'shop_barber', lines: ['Cắt kiểu gì cũng đẹp!', 'Đổi tóc là đổi vận đó nha.'] },
      { id: 'npc_salon', name: 'Cô Diễm', x: 33, y: 14, charIndex: 7, gender: 2, shop: 'shop_salon', lines: ['Vào đây chị làm cho đôi mắt biết nói.', 'Ánh mắt là hồn của gương mặt đó em.'] }
    ],
    features: []
  },
  pet_shop: {
    id: 'pet_shop', name: 'Tiệm thú cưng', icon: '', w: 42, h: 33, ground: 'wood', indoor: true,
    spawn: { x: 20, y: 26 },
    bg: '105', lttt: '105',
    portals: [],
    npcs: [
      { id: 'npc_pet', name: 'Chị Mèo', x: 26, y: 15, charIndex: 5, gender: 2, lines: ['Bé nào cũng ngoan hết á!', 'Nuôi thú cưng nhớ cho ăn đều nha.'] }
    ],
    features: []
  },

  // ===================== KHU GIẢI TRÍ =====================
  // map 10: ATM · GAME (2 máy thùng) · nhà lớn · xe bói · VÒNG QUAY · Pet Racing
  gamecenter: {
    id: 'gamecenter', name: 'Khu giải trí', icon: '', w: 127, h: 32, ground: 'stone',
    spawn: { x: 56, y: 25 }, hub: true,
    bg: '10', lttt: '10', traffic: { topTile: 28 },
    portals: [],
    npcs: [
      { id: 'npc_caro', name: 'Máy Caro', x: 20, y: 20, charIndex: 1, gender: 1, lines: ['Cờ caro 5 quân — dám đấu không?'], minigame: 'caro' },
      { id: 'npc_rps', name: 'Bé Kéo Búa', x: 26, y: 20, charIndex: 7, gender: 2, lines: ['Oẳn tù tì ra cái gì ra cái này!'], minigame: 'rps' },
      { id: 'npc_cotuong', name: 'Cụ Cờ', x: 44, y: 21, charIndex: 2, gender: 1, lines: ['Cờ tướng là tinh hoa!', 'Ngồi xuống làm ván đi cháu.'], minigame: 'xiangqi' }
    ],
    features: []
  },
  // ===================== CÔNG VIÊN =====================
  park: {
    id: 'park', name: 'Công viên', icon: '', w: 57, h: 33, ground: 'grass',
    spawn: { x: 28, y: 26 }, hub: true,
    bg: '4', lttt: '4',
    portals: [],
    npcs: [
      { id: 'npc_tuan', name: 'Bé Tuấn', x: 30, y: 24, charIndex: 7, gender: 1, lines: ['Chơi oẳn tù tì với em không?'], minigame: 'rps' }
    ],
    features: []
  },

  // ===================== KHU SINH THÁI =====================
  pond: {
    id: 'pond', name: 'Hồ câu', icon: '', w: 63, h: 24, ground: 'grass',
    spawn: { x: 32, y: 18 }, hub: true,
    bg: '15', lttt: '15',
    portals: [],
    npcs: [],
    features: ['fishing', 'water_edge']
  },
  beach: {
    // Nền map 14 gốc Avatar: bờ nước + kè đá + tiệm câu (biển SHOP có cần câu)
    id: 'beach', name: 'Bãi biển', icon: '', w: 63, h: 28, ground: 'stone',
    spawn: { x: 32, y: 22 }, hub: true,
    bg: '14', lttt: '14', skyTop: 57, traffic: { topTile: 24 },
    portals: [],
    npcs: [
      { id: 'npc_bien', name: 'Ông Biển', x: 40, y: 17, charIndex: 2, gender: 1, lines: ['Cần câu tốt mới câu được cá to — ghé tiệm của ta xem thử!', 'Cá huyền thoại chỉ cắn cần vàng.'] }
    ],
    features: ['fishing', 'water_edge']
  }
};

export const ZONE_LIST = Object.values(ZONES);
