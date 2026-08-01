// ===== Kiểu dữ liệu trạng thái game (lưu localStorage, sau này sync server) =====

export type Gender = 'male' | 'female';

export interface Appearance {
  charIndex: number;        // 0..7 (char1..char8 – màu da/kiểu nền)
  hairStyle: string;        // id trong data/clothing HAIR_STYLES
  hairColor: number;        // 0..13
  eyesColor: number;        // 0..13 (sheet eyes có 14 biến thể)
  clothes: string;          // id bộ đồ (basic, dress, overalls...)
  clothesColor: number;     // 0..9
  acc: string[];            // id phụ kiện đang đeo (hat_*, glasses_*, mask_*...)
}

export interface ChibiLookState {
  gender: number;          // 0 nam, 1 nữ
  pant: number; shirt: number; hair: number; eyes: number;
  hat: number; glasses: number; hand?: number; skin?: string;
}

export type StatKey = 'health' | 'intellect' | 'strength' | 'agility' | 'charm';
export interface CharStats {
  health: number;     // Sức khỏe
  intellect: number;  // Trí tuệ
  strength: number;   // Sức mạnh
  agility: number;    // Nhanh nhẹn
  charm: number;      // Quyến rũ
}

export interface PlayerProfile {
  name: string;
  gender: Gender;
  appearance: Appearance;  // (cũ — giữ cho save tương thích)
  chibi?: ChibiLookState;  // nhân vật chibi kiểu Avatar (hiện hành)
  level: number;
  exp: number;
  charStats: CharStats;    // chỉ số nhân vật kiểu Avatar
  statPoints: number;      // điểm chưa phân bổ
  avatarFace?: number;     // part mắt riêng cho ảnh đại diện (0/undefined = theo nhân vật)
  avatarPic?: string;      // 'pack:07' hoặc data URL ảnh tự tải lên; bỏ trống = dùng đầu chibi
  title: string;            // danh hiệu đang dùng
  titles: string[];         // danh hiệu đã mở
  badges: string[];         // huy hiệu
  guild?: string;           // tên hội nhóm — hiện trong () trước tên
  createdAt: number;
}

export type PlotState = 'locked' | 'empty' | 'tilled' | 'planted';

export interface Plot {
  state: PlotState;
  crop?: string;            // cropId
  plantedAt?: number;
  watered?: boolean;
  wateredAt?: number;
  fertilized?: boolean;     // bón phân: giảm 30% thời gian
  health?: number;          // sức khỏe cây 0..100 (Lttt) — quyết định sản lượng
}

// Kho nông trại (Lttt tách hẳn khỏi túi đồ: hatgiong / NongSan / PhanBon)
export interface FarmStore {
  seeds: Record<string, number>;     // cropId -> số hạt
  produce: Record<string, number>;   // cropId -> số nông sản
  fert: Record<string, number>;      // loại phân -> số lượng
}

// Đang nấu ở nhà bếp (Lttt: mỗi lúc 1 món, có đếm giờ)
export interface CookState {
  foodId: string;
  startedAt: number;
}

export interface Animal {
  id: string;
  type: string;             // 'chicken' | 'cow' | 'pig' | ...
  name: string;
  boughtAt: number;
  fedAt: number;            // lần cho ăn gần nhất
  collectedAt: number;      // lần thu sản phẩm gần nhất
}

export interface PlacedFurniture {
  id: string;               // instance id
  itemId: string;           // furniture item
  x: number;                // toạ độ tile trong nhà
  y: number;
}

export interface HouseState {
  owned: boolean;
  level: number;            // 1..3
  wallpaper: number;
  floor: number;
  furniture: PlacedFurniture[];
  aquarium: string[];       // fishId nuôi trong hồ cá
  partyUntil?: number;      // đang mở tiệc tới thời điểm này
}

export interface QuestProgressMap { [questId: string]: number }

export interface DailyState {
  lastLoginDate: string;    // yyyy-mm-dd
  streak: number;
  loginClaimed: boolean;    // quà đăng nhập hôm nay
  checkinDays: number[];    // ngày đã điểm danh trong tháng
  checkinMonth: string;     // yyyy-mm
  wheelDate: string;
  wheelSpins: number;       // đã quay hôm nay
  dailyQuestDate: string;
  dailyQuests: string[];    // id nhiệm vụ ngày hôm nay
}

export interface MailMessage {
  id: string;
  from: string;
  subject: string;
  body: string;
  attachments?: { itemId?: string; qty?: number; coins?: number; rubies?: number };
  read: boolean;
  claimed: boolean;
  at: number;
}

export interface Friend {
  id: string;
  name: string;
  level: number;
  online: boolean;
  npc?: boolean;            // bạn NPC (chế độ offline)
}

export interface ChatMessage {
  channel: 'public' | 'area' | 'private' | 'guild' | 'system';
  from: string;
  to?: string;
  text: string;
  at: number;
  voice?: string;          // data URL tin nhắn thoại (chỉ giữ trong phiên, không lưu save)
  dur?: number;            // độ dài tin thoại (giây)
}

export interface GameState {
  version: number;
  player: PlayerProfile;
  // Lttt: thu hoạch/bán nông sản vào TÀI KHOẢN NÔNG TRẠI, ra ATM mới
  // chuyển sang ví chính tiêu được.
  wallet: { coins: number; rubies: number; farmCoins: number };
  inventory: Record<string, number>;
  wardrobe: string[];       // (cũ) thời trang pack Cozy
  chibiWardrobe: number[];  // part chibi đã sở hữu (id part Avatar)
  hotbar: string[];         // nông cụ gắn trên thanh nhanh
  tools: { rod: number; can: number; hoe: number; net: number; basket: number; axe: number }; // cấp độ dụng cụ
  farm: { unlocked: number; plots: Plot[]; hasDog?: boolean };  // hasDog: (cũ) chó giữ trại
  farmStore: FarmStore;     // kho nông trại — nông sản KHÔNG nằm trong túi đồ
  cooking?: CookState;      // món đang nấu ở nhà bếp
  orders: import('@/systems/orders').Order[];   // bảng đơn hàng kiểu Hay Day
  fishfarm: { id: string; type: string; at: number }[];   // cá đang nuôi trong ao
  pets: string[];           // thú cưng đã nuôi
  skins: string[];          // skin trọn bộ đã sở hữu
  activePet?: string;       // thú cưng đang dắt theo
  livestock: { barnLevel: number; animals: Animal[] };
  house: HouseState;
  collections: { fish: string[]; insects: string[]; crops: string[] };
  quests: { active: QuestProgressMap; completed: string[]; claimed: string[] };
  achievements: string[];
  stats: Record<string, number>;
  social: { friends: Friend[]; blocked: string[]; reported: string[]; affinity?: Record<string, number> };
  mail: MailMessage[];
  daily: DailyState;
  minigames: { caroWins: number; xiangqiWins: number; rpsWins: number };
  settings: { music: boolean; sfx: boolean };
  zone: string;
  zoneRoom: number;         // "khu vực" của map hiện tại (Lttt: 10 khu / map)
  clockOffset: number;      // phút cộng thêm vào giờ thật (đổi ngày/đêm nhanh)
}
