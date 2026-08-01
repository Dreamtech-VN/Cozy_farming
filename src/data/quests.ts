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
q({ id: 'tut_house', name: 'An cư lạc nghiệp', desc: 'Mua nhà riêng ở Thành phố.', stat: 'house_bought', target: 1, reward: { coins: 2000, exp: 50, title: 'title_homeowner' }, type: 'tutorial' });

// ---- Nhiệm vụ ngày (mỗi ngày random 3 nhiệm vụ, stat theo dõi dạng daily_*) ----
q({ id: 'd_water5', name: 'Tưới 5 lần', desc: 'Tưới nước cho cây 5 lần hôm nay.', stat: 'daily_watered', target: 5, reward: { coins: 150, exp: 15 }, type: 'daily' });
q({ id: 'd_harvest5', name: 'Thu hoạch 5 nông sản', desc: 'Thu hoạch 5 nông sản hôm nay.', stat: 'daily_harvested', target: 5, reward: { coins: 200, exp: 20 }, type: 'daily' });
q({ id: 'd_fish3', name: 'Câu 3 con cá', desc: 'Câu được 3 con cá hôm nay.', stat: 'daily_fish', target: 3, reward: { coins: 200, exp: 20 }, type: 'daily' });
q({ id: 'd_cook1', name: 'Nấu 1 món', desc: 'Nấu xong 1 món ở nhà bếp hôm nay.', stat: 'daily_cook', target: 1, reward: { coins: 200, exp: 20 }, type: 'daily' });
q({ id: 'd_feed2', name: 'Chăm vật nuôi', desc: 'Cho vật nuôi ăn 2 lần hôm nay.', stat: 'daily_fed', target: 2, reward: { coins: 150, exp: 15 }, type: 'daily' });
q({ id: 'd_sell10', name: 'Buôn bán nhỏ', desc: 'Bán 10 vật phẩm bất kỳ hôm nay.', stat: 'daily_sold', target: 10, reward: { coins: 250, exp: 25 }, type: 'daily' });
q({ id: 'd_minigame1', name: 'Giải trí', desc: 'Chơi 1 ván mini game hôm nay.', stat: 'daily_minigame', target: 1, reward: { coins: 120, exp: 12 }, type: 'daily' });
q({ id: 'd_gift1', name: 'Trao yêu thương', desc: 'Tặng 1 món quà cho bạn bè hôm nay.', stat: 'daily_gifted', target: 1, reward: { coins: 450, exp: 15 }, type: 'daily' });

export const DAILY_POOL = Object.values(QUESTS).filter(x => x.type === 'daily').map(x => x.id);

// ---- Thành tựu ----
// Bộ thành tựu cũ đã bỏ; hệ mới nằm ở src/data/achievements.ts (chia nhóm,
// có điểm thành tựu và huy hiệu theo cách GunPow làm).

export const ACHIEVEMENTS = Object.values(QUESTS).filter(x => x.type === 'achievement');  // rỗng

// ---- Danh hiệu ----
// Danh hiệu: source = nhận từ đâu, how = điều kiện cụ thể
export interface TitleDef { name: string; color: string; source: string; how: string }
export const TITLES: Record<string, TitleDef> = {
  // ---- Danh hiệu của bộ thành tựu (mỗi thành tựu lớn tặng một cái) ----
  ti_seeder: { name: 'Người Gieo Mầm', color: '#8ce99a', source: 'Nhà Nông', how: 'Trồng 200 hạt giống.' },
  ti_farmer: { name: 'Nông Dân Chăm Chỉ', color: '#8ce99a', source: 'Nhà Nông', how: 'Thu hoạch 100 nông sản.' },
  ti_harvest_king: { name: 'Mùa Vàng', color: '#ffd43b', source: 'Nhà Nông', how: 'Thu hoạch 1.000 nông sản.' },
  ti_farm_king: { name: 'Vua Nông Trại', color: '#ffa94d', source: 'Nhà Nông', how: 'Thu hoạch 5.000 nông sản.' },
  ti_woodman: { name: 'Tiều Phu', color: '#b08968', source: 'Nhà Nông', how: 'Chặt 200 cây lấy gỗ.' },
  ti_angler: { name: 'Cần Thủ', color: '#66d9e8', source: 'Cần Thủ', how: 'Câu được 50 con cá.' },
  ti_angler_pro: { name: 'Tay Câu Cứng', color: '#3bc9db', source: 'Cần Thủ', how: 'Câu được 500 con cá.' },
  ti_fish_king: { name: 'Ngư Ông Đắc Lợi', color: '#22b8cf', source: 'Cần Thủ', how: 'Câu được 2.000 con cá.' },
  ti_fish_master: { name: 'Bậc Thầy Câu Cá', color: '#15aabf', source: 'Cần Thủ', how: 'Sưu tập đủ 30 loài cá.' },
  ti_pond: { name: 'Chủ Ao', color: '#4dabf7', source: 'Cần Thủ', how: 'Vớt 200 con cá nuôi.' },
  ti_herder: { name: 'Người Chăn Nuôi', color: '#ffd8a8', source: 'Chăn Nuôi', how: 'Cho vật nuôi ăn 200 lần.' },
  ti_rancher: { name: 'Chủ Trại', color: '#e8b04b', source: 'Chăn Nuôi', how: 'Thu 500 sản phẩm từ vật nuôi.' },
  ti_chef: { name: 'Đầu Bếp', color: '#ff922b', source: 'Bếp Núc', how: 'Nấu xong 300 món ăn.' },
  ti_courier: { name: 'Người Giao Hàng', color: '#b197fc', source: 'Bếp Núc', how: 'Giao xong 30 đơn hàng.' },
  ti_shopkeep: { name: 'Chủ Tiệm Uy Tín', color: '#9775fa', source: 'Bếp Núc', how: 'Giao xong 300 đơn hàng.' },
  ti_trader: { name: 'Con Buôn', color: '#f783ac', source: 'Bếp Núc', how: 'Bán 2.000 vật phẩm.' },
  ti_smith: { name: 'Thợ Rèn', color: '#ced4da', source: 'Bậc Thầy Rèn', how: 'Cường hoá thành công 200 lần.' },
  ti_forge_master: { name: 'Bậc Thầy Rèn', color: '#ff6b6b', source: 'Bậc Thầy Rèn', how: 'Cường hoá thành công 1.000 lần.' },
  ti_starman: { name: 'Thăng Tinh Sư', color: '#ffe066', source: 'Bậc Thầy Rèn', how: 'Tăng sao thành công 50 lần.' },
  ti_heir: { name: 'Kế Thừa Y Bát', color: '#d0bfff', source: 'Bậc Thầy Rèn', how: 'Kế thừa trang bị 20 lần.' },
  ti_chest: { name: 'Săn Rương', color: '#ffc078', source: 'Bậc Thầy Rèn', how: 'Mở 100 rương trang bị.' },
  ti_social: { name: 'Quảng Giao', color: '#faa2c1', source: 'Giải Trí', how: 'Kết bạn với 10 người.' },
  ti_gifter: { name: 'Trao Yêu Thương', color: '#ff8787', source: 'Giải Trí', how: 'Tặng 100 món quà.' },
  ti_gamer: { name: 'Cao Thủ Mini Game', color: '#a9e34b', source: 'Giải Trí', how: 'Thắng 50 ván mini game.' },
  ti_caro: { name: 'Kỳ Thủ Caro', color: '#94d82d', source: 'Giải Trí', how: 'Thắng 30 ván cờ caro.' },
  ti_party: { name: 'Chủ Tiệc', color: '#ff8787', source: 'Giải Trí', how: 'Tổ chức 10 bữa tiệc.' },
  ti_homeowner: { name: 'Chủ Nhà', color: '#74c0fc', source: 'Tổ Ấm', how: 'Mua nhà riêng.' },
  ti_mansion: { name: 'Nhà Cao Cửa Rộng', color: '#4dabf7', source: 'Tổ Ấm', how: 'Nâng cấp nhà 3 lần.' },
  ti_decor: { name: 'Tay Bày Biện', color: '#66d9e8', source: 'Tổ Ấm', how: 'Đặt 50 món nội thất.' },
  ti_veteran: { name: 'Kỳ Cựu', color: '#ffd43b', source: 'Tổ Ấm', how: 'Đạt cấp 30.' },
  ti_fashion: { name: 'Tín Đồ Thời Trang', color: '#f06595', source: 'Sưu Tập', how: 'Sắm 50 món thời trang.' },
  ti_skinner: { name: 'Nhà Sưu Tầm Ảo Hoá', color: '#cc5de8', source: 'Sưu Tập', how: 'Sở hữu 5 bộ skin.' },
  ti_titled: { name: 'Danh Gia Vọng Tộc', color: '#ffa94d', source: 'Sưu Tập', how: 'Mở khoá 20 danh hiệu.' },
  ti_geared: { name: 'Đủ Bộ Đồ Nghề', color: '#a5d8ff', source: 'Sưu Tập', how: 'Đeo đủ 8 ô trang bị.' },
  ti_millionaire: { name: 'Triệu Phú', color: '#ffd43b', source: 'Sưu Tập', how: 'Kiếm được tổng cộng 1.000.000 xu.' },
  // ---- Danh hiệu cũ / gacha ----
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
  title_veteran: { name: 'Lão làng', color: '#e599f7', source: 'Cấp độ', how: 'Đạt cấp 10.' },

  // ---- Danh hiệu GunPow (lấy từ bảng vật phẩm của server GunPow) ----
  // Trong GunPow đây là các "Xưng Hào Tạp" — hộp mở ra được danh hiệu. Bên
  // mình gom hết vào Rương danh hiệu của gacha vật phẩm, đúng luật tiền nạp:
  // lượng chỉ tiêu cho gacha / skin giới hạn.
  gp_dan_dan_chien_than: { name: 'Đạn Đạn Chiến Thần', color: '#ffd43b', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_trung_cap_than_thoai: { name: 'Trùng Cấp Thần Thoại', color: '#ff8787', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_trung_cap_phong_ma: { name: 'Trùng Cấp Phong Ma', color: '#74c0fc', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_trung_cap_dat_nhan: { name: 'Trùng Cấp Đạt Nhân', color: '#b197fc', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_trung_cap_nang_thu: { name: 'Trùng Cấp Năng Thủ', color: '#8ce99a', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_canh_ky_vuong_gia: { name: 'Cạnh Kỹ Vương Giả', color: '#ffa94d', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_canh_ky_dai_su: { name: 'Cạnh Kỹ Đại Sư', color: '#faa2c1', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_canh_ky_dat_nhan: { name: 'Cạnh Kỹ Đạt Nhân', color: '#66d9e8', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_canh_ky_cuong_gia: { name: 'Cạnh Kỹ Cường Giả', color: '#a9e34b', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_truyen_ky_dan_than: { name: 'Truyện Kỳ Đạn Thần', color: '#e599f7', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_vinh_dieu_dan_hoang: { name: 'Vinh Diệu Đạn Hoàng', color: '#ffd43b', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_sieu_cap_dan_vuong: { name: 'Siêu Cấp Đạn Vương', color: '#ff8787', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_anh_dung_dan_tuong: { name: 'Anh Dũng Đạn Tương', color: '#74c0fc', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_ung_dung_bao_dung_si: { name: 'Ứng Dụng Bảo Dũng Sĩ', color: '#b197fc', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_nga_thi_lao_ti_ky: { name: 'Ngã Thị Lão Ti Ky', color: '#8ce99a', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_cuu_du_than_phao_thu: { name: 'Cửu Du Thần Pháo Thủ', color: '#ffa94d', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_mi_luc_vo_song: { name: 'Mị Lực Vô Song', color: '#faa2c1', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_mi_luc_dat_nhan: { name: 'Mị Lực Đạt Nhân', color: '#66d9e8', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_mi_luc_su_gia: { name: 'Mị Lực Sử Giả', color: '#a9e34b', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_diem_cau_dai_su: { name: 'Điểm Cầu Đại Sư', color: '#e599f7', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_dong_cau_de: { name: 'Đổng Cầu Đế', color: '#ffd43b', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_tram_ma_gia: { name: 'Trảm Ma Giả', color: '#ff8787', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_thien_lai_chi_am: { name: 'Thiên Lại Chi Âm', color: '#74c0fc', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_truy_mong_ca_thu: { name: 'Truy Mộng Ca Thủ', color: '#b197fc', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_canh_ky_chi_vuong: { name: 'Cạnh Kỹ Chi Vương', color: '#8ce99a', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_canh_ky_cao_thu: { name: 'Cạnh Kỹ Cao Thủ', color: '#ffa94d', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_toi_cuong_vuong_gia: { name: 'Tối Cường Vương Giả', color: '#faa2c1', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_sieu_pham_dai_su: { name: 'Siêu Phàm Đại Sư', color: '#66d9e8', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_tuyet_the_cao_thu: { name: 'Tuyệt Thế Cao Thủ', color: '#a9e34b', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_thua_phong_pha_lang: { name: 'Thừa Phong Phá Lãng', color: '#e599f7', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_ai_tinh_cong_ngu: { name: 'Ái Tình Công Ngụ', color: '#ffd43b', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_chien_luc_chi_vuong: { name: 'Chiến Lực Chi Vương', color: '#ff8787', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_trung_thanh_ngoan_gia: { name: 'Trung Thành Ngoạn Gia', color: '#74c0fc', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_huu_tien_vo_dich_mot_tien_mong_buc: { name: 'Hữu Tiễn Vô Địch Một Tiễn Mộng Bức', color: '#b197fc', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_trieu_luu_chi_ton: { name: 'Triều Lưu Chí Tôn', color: '#8ce99a', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_thi_thuong_tien_phong: { name: 'Thì Thượng Tiên Phong', color: '#ffa94d', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_thi_thuong_su_gia: { name: 'Thì Thượng Sử Giả', color: '#faa2c1', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
  gp_khai_phuc: { name: 'Khai Phục', color: '#66d9e8', source: 'Rương danh hiệu', how: 'Mở Rương danh hiệu (gacha vật phẩm).' },
};

/** Danh hiệu mở từ Rương danh hiệu (gacha) — không nhận qua nhiệm vụ thường. */
export const GACHA_TITLES = Object.keys(TITLES).filter(id => id.startsWith('gp_'));
