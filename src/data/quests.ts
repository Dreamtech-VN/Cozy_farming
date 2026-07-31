// ===== Nhiệm vụ, thành tựu, danh hiệu =====
// Cơ chế: mỗi nhiệm vụ theo dõi 1 chỉ số trong S.stats (được cộng bởi các hệ thống).

export interface Reward { coins?: number; rubies?: number; items?: Record<string, number>; exp?: number; title?: string }

export interface QuestDef {
  id: string;
  name: string;
  desc: string;
  stat: string;            // key trong S.stats
  target: number;
  reward: Reward;
  chain?: string;          // quest mở khóa tiếp theo (chuỗi nhiệm vụ)
  type: 'tutorial' | 'chain' | 'daily' | 'achievement';
}

export const QUESTS: Record<string, QuestDef> = {};
function q(d: QuestDef) { QUESTS[d.id] = d; }

// ---- Nhiệm vụ tân thủ (chuỗi hướng dẫn) ----
q({ id: 'tut_till', name: 'Tập làm nông', desc: 'Cuốc 3 ô đất tại Nông trại (đến gần ô đất và bấm hành động).', stat: 'tilled', target: 3, reward: { coins: 100, exp: 10, items: { seed_carrot: 3 } }, chain: 'tut_plant', type: 'tutorial' });
q({ id: 'tut_plant', name: 'Gieo hạt đầu tiên', desc: 'Trồng 3 hạt giống bất kỳ.', stat: 'planted', target: 3, reward: { coins: 100, exp: 10 }, chain: 'tut_water', type: 'tutorial' });
q({ id: 'tut_water', name: 'Tưới nước', desc: 'Tưới nước 3 lần cho cây.', stat: 'watered', target: 3, reward: { coins: 100, exp: 10 }, chain: 'tut_harvest', type: 'tutorial' });
q({ id: 'tut_harvest', name: 'Thu hoạch', desc: 'Thu hoạch 3 nông sản.', stat: 'harvested', target: 3, reward: { coins: 200, exp: 20 }, chain: 'tut_sell', type: 'tutorial' });
q({ id: 'tut_sell', name: 'Ra chợ bán hàng', desc: 'Bán 3 nông sản ở shop.', stat: 'sold_crops', target: 3, reward: { coins: 200, exp: 20 }, chain: 'tut_animal', type: 'tutorial' });
q({ id: 'tut_animal', name: 'Người chăn nuôi', desc: 'Mua 1 con vật nuôi (cần mua chuồng trước).', stat: 'animals_bought', target: 1, reward: { coins: 300, exp: 30, items: { feed: 5 } }, chain: 'tut_fish', type: 'tutorial' });
q({ id: 'tut_fish', name: 'Buông cần', desc: 'Câu được 1 con cá (mua cần ở shop, ra Bãi biển hoặc Hồ câu).', stat: 'fish_caught', target: 1, reward: { coins: 300, exp: 30 }, chain: 'tut_house', type: 'tutorial' });
q({ id: 'tut_house', name: 'An cư lạc nghiệp', desc: 'Mua nhà riêng ở Thành phố.', stat: 'house_bought', target: 1, reward: { coins: 500, rubies: 5, exp: 50, title: 'title_homeowner' }, type: 'tutorial' });

// ---- Nhiệm vụ ngày (mỗi ngày random 3 nhiệm vụ, stat theo dõi dạng daily_*) ----
q({ id: 'd_water5', name: 'Tưới 5 lần', desc: 'Tưới nước cho cây 5 lần hôm nay.', stat: 'daily_watered', target: 5, reward: { coins: 150, exp: 15 }, type: 'daily' });
q({ id: 'd_harvest5', name: 'Thu hoạch 5 nông sản', desc: 'Thu hoạch 5 nông sản hôm nay.', stat: 'daily_harvested', target: 5, reward: { coins: 200, exp: 20 }, type: 'daily' });
q({ id: 'd_fish3', name: 'Câu 3 con cá', desc: 'Câu được 3 con cá hôm nay.', stat: 'daily_fish', target: 3, reward: { coins: 200, exp: 20 }, type: 'daily' });
q({ id: 'd_cook1', name: 'Nấu 1 món', desc: 'Nấu xong 1 món ở nhà bếp hôm nay.', stat: 'daily_cook', target: 1, reward: { coins: 200, exp: 20 }, type: 'daily' });
q({ id: 'd_feed2', name: 'Chăm vật nuôi', desc: 'Cho vật nuôi ăn 2 lần hôm nay.', stat: 'daily_fed', target: 2, reward: { coins: 150, exp: 15 }, type: 'daily' });
q({ id: 'd_sell10', name: 'Buôn bán nhỏ', desc: 'Bán 10 vật phẩm bất kỳ hôm nay.', stat: 'daily_sold', target: 10, reward: { coins: 250, exp: 25 }, type: 'daily' });
q({ id: 'd_minigame1', name: 'Giải trí', desc: 'Chơi 1 ván mini game hôm nay.', stat: 'daily_minigame', target: 1, reward: { coins: 120, exp: 12 }, type: 'daily' });
q({ id: 'd_gift1', name: 'Trao yêu thương', desc: 'Tặng 1 món quà cho bạn bè hôm nay.', stat: 'daily_gifted', target: 1, reward: { coins: 150, rubies: 1, exp: 15 }, type: 'daily' });

export const DAILY_POOL = Object.values(QUESTS).filter(x => x.type === 'daily').map(x => x.id);

// ---- Thành tựu ----
q({ id: 'a_harvest100', name: 'Nông dân chăm chỉ', desc: 'Thu hoạch 100 nông sản.', stat: 'harvested', target: 100, reward: { coins: 1000, title: 'title_farmer', exp: 100 }, type: 'achievement' });
q({ id: 'a_harvest1000', name: 'Vua nông trại', desc: 'Thu hoạch 1000 nông sản.', stat: 'harvested', target: 1000, reward: { rubies: 50, title: 'title_farm_king', exp: 500 }, type: 'achievement' });
q({ id: 'a_fish50', name: 'Cần thủ', desc: 'Câu 50 con cá.', stat: 'fish_caught', target: 50, reward: { coins: 1500, title: 'title_angler', exp: 150 }, type: 'achievement' });
q({ id: 'a_fish_all', name: 'Bách khoa cá', desc: 'Sưu tập đủ 30 loài cá.', stat: 'fish_species', target: 30, reward: { rubies: 100, title: 'title_fish_master', exp: 800 }, type: 'achievement' });
q({ id: 'a_order30', name: 'Chủ tiệm giao hàng', desc: 'Giao 30 đơn hàng.', stat: 'orders_done', target: 30, reward: { coins: 1200, title: 'title_courier', exp: 120 }, type: 'achievement' });
q({ id: 'a_rich', name: 'Triệu phú', desc: 'Sở hữu 100.000 xu (tích lũy kiếm được).', stat: 'coins_earned', target: 100000, reward: { rubies: 30, title: 'title_millionaire', exp: 300 }, type: 'achievement' });
q({ id: 'a_friend5', name: 'Quảng giao', desc: 'Kết bạn với 5 người.', stat: 'friends_added', target: 5, reward: { coins: 500, title: 'title_social', exp: 80 }, type: 'achievement' });
q({ id: 'a_party', name: 'Chủ tiệc', desc: 'Tổ chức 1 bữa tiệc tại nhà.', stat: 'parties', target: 1, reward: { coins: 800, title: 'title_party', exp: 100 }, type: 'achievement' });
q({ id: 'a_caro10', name: 'Kỳ thủ caro', desc: 'Thắng 10 ván cờ caro.', stat: 'caro_wins', target: 10, reward: { coins: 1000, title: 'title_caro', exp: 150 }, type: 'achievement' });
q({ id: 'a_level10', name: 'Thăng tiến', desc: 'Đạt cấp 10.', stat: 'level_up', target: 9, reward: { rubies: 20, exp: 0, title: 'title_veteran' }, type: 'achievement' });

export const ACHIEVEMENTS = Object.values(QUESTS).filter(x => x.type === 'achievement');

// ---- Danh hiệu ----
// Danh hiệu: source = nhận từ đâu, how = điều kiện cụ thể
export interface TitleDef { name: string; color: string; source: string; how: string }
export const TITLES: Record<string, TitleDef> = {
  title_newbie: { name: 'Tân binh', color: '#9aa5b1', source: 'Mặc định', how: 'Có sẵn khi tạo nhân vật.' },
  title_homeowner: { name: 'Chủ nhà', color: '#74c0fc', source: 'Nhiệm vụ', how: 'Hoàn thành nhiệm vụ "An cư lạc nghiệp" — mua nhà riêng ở Thành phố.' },
  title_farmer: { name: 'Nông dân chăm chỉ', color: '#8ce99a', source: 'Thành tựu', how: 'Thu hoạch 100 nông sản.' },
  title_farm_king: { name: 'Vua nông trại', color: '#ffd43b', source: 'Thành tựu', how: 'Thu hoạch 1000 nông sản.' },
  title_angler: { name: 'Cần thủ', color: '#66d9e8', source: 'Thành tựu', how: 'Câu được 50 con cá.' },
  title_fish_master: { name: 'Bậc thầy câu cá', color: '#3bc9db', source: 'Thành tựu', how: 'Sưu tập đủ 30 loài cá.' },
  title_courier: { name: 'Chủ tiệm giao hàng', color: '#b197fc', source: 'Thành tựu', how: 'Giao 30 đơn hàng.' },
  title_millionaire: { name: 'Triệu phú', color: '#ffa94d', source: 'Thành tựu', how: 'Kiếm được tổng cộng 100.000 xu.' },
  title_social: { name: 'Quảng giao', color: '#faa2c1', source: 'Thành tựu', how: 'Kết bạn với 5 người chơi.' },
  title_party: { name: 'Chủ tiệc', color: '#ff8787', source: 'Thành tựu', how: 'Tổ chức 1 bữa tiệc tại nhà.' },
  title_caro: { name: 'Kỳ thủ caro', color: '#a9e34b', source: 'Minigame', how: 'Thắng 10 ván cờ caro ở Game Center.' },
  title_veteran: { name: 'Lão làng', color: '#e599f7', source: 'Cấp độ', how: 'Đạt cấp 10.' }
};
