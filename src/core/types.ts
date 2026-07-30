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

export interface PlayerProfile {
  name: string;
  gender: Gender;
  appearance: Appearance;
  level: number;
  exp: number;
  title: string;            // danh hiệu đang dùng
  titles: string[];         // danh hiệu đã mở
  badges: string[];         // huy hiệu
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
}

export interface GameState {
  version: number;
  player: PlayerProfile;
  wallet: { coins: number; rubies: number };
  inventory: Record<string, number>;
  wardrobe: string[];       // thời trang đã sở hữu (clothing ids: "hair:xx", "clothes:xx", "acc:xx")
  tools: { rod: number; can: number; hoe: number; net: number }; // cấp độ dụng cụ
  farm: { unlocked: number; plots: Plot[] };
  livestock: { barnLevel: number; animals: Animal[] };
  house: HouseState;
  collections: { fish: string[]; insects: string[]; crops: string[] };
  quests: { active: QuestProgressMap; completed: string[]; claimed: string[] };
  achievements: string[];
  stats: Record<string, number>;
  social: { friends: Friend[]; blocked: string[]; reported: string[] };
  mail: MailMessage[];
  daily: DailyState;
  minigames: { caroWins: number; xiangqiWins: number; rpsWins: number };
  garage: string[];         // xe đã sở hữu
  vehicle: string;          // xe đang dùng ('' = đi xe buýt công cộng)
  settings: { music: boolean; sfx: boolean };
  zone: string;
  clockOffset: number;      // phút cộng thêm vào giờ thật (đổi ngày/đêm nhanh)
}
