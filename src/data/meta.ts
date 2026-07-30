// ===== Quà đăng nhập, điểm danh, vòng quay may mắn, sự kiện theo mùa =====
import type { Reward } from './quests';

// Quà đăng nhập theo chuỗi ngày (streak) — lặp sau 7 ngày
export const LOGIN_REWARDS: Reward[] = [
  { coins: 100 },
  { coins: 150 },
  { coins: 200, items: { seed_tomato: 2 } },
  { coins: 250, rubies: 1 },
  { coins: 300, items: { fertilizer: 3 } },
  { coins: 400, rubies: 2 },
  { coins: 800, rubies: 5, items: { lucky_ticket: 1 } }
];

// Điểm danh tháng: mốc thưởng
export const CHECKIN_MILESTONES: { days: number; reward: Reward }[] = [
  { days: 5, reward: { coins: 500 } },
  { days: 10, reward: { rubies: 5 } },
  { days: 15, reward: { coins: 1500, items: { gift_teddy: 1 } } },
  { days: 20, reward: { rubies: 10 } },
  { days: 25, reward: { coins: 3000, rubies: 10, items: { lucky_ticket: 2 } } }
];

// Vòng quay may mắn (1 lượt miễn phí/ngày, thêm lượt bằng vé)
// icon: tên icon trong ICON_SRC (ui/kit.ts), không dùng emoji
export interface WheelSlice { label: string; icon: string; weight: number; reward: Reward }
export const WHEEL: WheelSlice[] = [
  { label: '50 xu', icon: 'coin', weight: 30, reward: { coins: 50 } },
  { label: '200 xu', icon: 'coin', weight: 20, reward: { coins: 200 } },
  { label: '1 Ruby', icon: 'ruby', weight: 15, reward: { rubies: 1 } },
  { label: 'Phân bón x3', icon: 'fertilizer', weight: 12, reward: { items: { fertilizer: 3 } } },
  { label: 'Hạt dâu x2', icon: 'seed', weight: 10, reward: { items: { seed_strawberry: 2 } } },
  { label: '500 xu', icon: 'coin', weight: 8, reward: { coins: 500 } },
  { label: '5 Ruby', icon: 'ruby', weight: 4, reward: { rubies: 5 } },
  { label: 'JACKPOT 2000 xu', icon: 'rank', weight: 1, reward: { coins: 2000, rubies: 10 } }
];

// Sự kiện theo tháng (trang trí + shop đặc biệt sẽ mở theo mùa)
export interface SeasonEvent { id: string; name: string; icon: string; months: number[]; desc: string }
export const EVENTS: SeasonEvent[] = [
  { id: 'ev_tet', name: 'Tết Nguyên Đán', icon: 'gift', months: [1, 2], desc: 'Lì xì đăng nhập x2, trang phục áo dài (sắp ra mắt).' },
  { id: 'ev_valentine', name: 'Valentine', icon: 'heart', months: [2], desc: 'Quà tặng bạn bè giảm giá 50%.' },
  { id: 'ev_summer', name: 'Lễ hội biển', icon: 'rod', months: [6, 7], desc: 'Tỷ lệ cá hiếm ở Bãi biển tăng.' },
  { id: 'ev_midautumn', name: 'Trung Thu', icon: 'cake', months: [9], desc: 'Nhận bánh trung thu khi đăng nhập.' },
  { id: 'ev_halloween', name: 'Halloween', icon: 'w_leaf', months: [10], desc: 'Trang phục ma quái mở bán.' },
  { id: 'ev_noel', name: 'Giáng Sinh', icon: 'tree', months: [12], desc: 'Cây thông Noel bán tại tiệm nội thất.' },
  { id: 'ev_birthday', name: 'Sinh nhật game', icon: 'cake', months: [7], desc: 'Quà tri ân toàn server.' }
];

export function activeEvents(date = new Date()): SeasonEvent[] {
  const m = date.getMonth() + 1;
  return EVENTS.filter(e => e.months.includes(m));
}
