// ===== Thành tựu · Danh hiệu · Huy hiệu =====
// Dựng theo cách GunPow làm (màn Danh hiệu / Thành tựu):
//   · Thành tựu chia thành NHÓM, mỗi nhóm là một tab ngang.
//   · Mỗi thành tựu đạt điều kiện thì NHẬN được: điểm thành tựu (◆), xu, và
//     phần lớn kèm một danh hiệu.
//   · Thanh dưới cùng: tiến độ điểm của nhóm đang xem, số điểm còn chưa nhận,
//     và tổng tiến độ toàn bộ.
//   · Cộng dồn điểm thành tựu mở khoá HUY HIỆU — mỗi huy hiệu cho chỉ số cộng
//     thẳng vào nhân vật.
// Nội dung thì trộn việc của nông trại (trồng trọt, câu cá, chăn nuôi, nấu ăn)
// với việc kiểu GunPow (rèn đúc, sưu tập, giao lưu).


export interface AchCat { id: string; name: string }

/** 8 nhóm thành tựu, đúng kiểu 8 tab ngang của GunPow. */
export const ACH_CATS: AchCat[] = [
  { id: 'farm', name: 'Nhà Nông' },
  { id: 'fish', name: 'Cần Thủ' },
  { id: 'animal', name: 'Chăn Nuôi' },
  { id: 'kitchen', name: 'Bếp Núc' },
  { id: 'craft', name: 'Khéo Tay' },
  { id: 'social', name: 'Giải Trí' },
  { id: 'home', name: 'Tổ Ấm' },
  { id: 'collect', name: 'Sưu Tập' }
];

export interface AchDef {
  id: string;
  cat: string;
  name: string;
  desc: string;
  stat: string;       // khoá trong S.stats
  target: number;
  point: number;      // điểm thành tựu nhận được
  coins?: number;
  title?: string;     // danh hiệu tặng kèm
}

export const ACHS: AchDef[] = [];
function a(d: AchDef) { ACHS.push(d); }

// mỗi mốc của cùng một việc thì điểm tăng dần
const P = [200, 500, 1200, 3000, 8000];

// ---- Nhà Nông ----
a({ id: 'ac_till', cat: 'farm', name: 'Vỡ Đất', desc: 'Cuốc 50 ô đất.', stat: 'tilled', target: 50, point: P[0], coins: 500 });
a({ id: 'ac_plant', cat: 'farm', name: 'Gieo Mầm', desc: 'Trồng 200 hạt giống.', stat: 'planted', target: 200, point: P[1], coins: 1500, title: 'ti_seeder' });
a({ id: 'ac_water', cat: 'farm', name: 'Gánh Nước', desc: 'Tưới nước 300 lần.', stat: 'watered', target: 300, point: P[1], coins: 1500 });
a({ id: 'ac_fert', cat: 'farm', name: 'Bón Phân', desc: 'Bón phân 100 lần.', stat: 'fertilized', target: 100, point: P[1], coins: 1500 });
a({ id: 'ac_harv1', cat: 'farm', name: 'Nông Dân Chăm Chỉ', desc: 'Thu hoạch 100 nông sản.', stat: 'harvested', target: 100, point: P[1], coins: 2000, title: 'ti_farmer' });
a({ id: 'ac_harv2', cat: 'farm', name: 'Mùa Vàng', desc: 'Thu hoạch 1.000 nông sản.', stat: 'harvested', target: 1000, point: P[3], coins: 12000, title: 'ti_harvest_king' });
a({ id: 'ac_harv3', cat: 'farm', name: 'Vua Nông Trại', desc: 'Thu hoạch 5.000 nông sản.', stat: 'harvested', target: 5000, point: P[4], coins: 50000, title: 'ti_farm_king' });
a({ id: 'ac_plot', cat: 'farm', name: 'Mở Rộng Bờ Cõi', desc: 'Mua thêm 10 ô ruộng.', stat: 'plots_bought', target: 10, point: P[2], coins: 5000 });
a({ id: 'ac_wood', cat: 'farm', name: 'Tiều Phu', desc: 'Chặt 200 cây lấy gỗ.', stat: 'wood_chopped', target: 200, point: P[2], coins: 4000, title: 'ti_woodman' });
a({ id: 'ac_dig', cat: 'farm', name: 'Đào Bới', desc: 'Đào 200 đống đất.', stat: 'dug', target: 200, point: P[2], coins: 4000 });

// ---- Cần Thủ ----
a({ id: 'ac_fish1', cat: 'fish', name: 'Buông Cần', desc: 'Câu được 50 con cá.', stat: 'fish_caught', target: 50, point: P[1], coins: 1500, title: 'ti_angler' });
a({ id: 'ac_fish2', cat: 'fish', name: 'Tay Câu Cứng', desc: 'Câu được 500 con cá.', stat: 'fish_caught', target: 500, point: P[3], coins: 12000, title: 'ti_angler_pro' });
a({ id: 'ac_fish3', cat: 'fish', name: 'Ngư Ông Đắc Lợi', desc: 'Câu được 2.000 con cá.', stat: 'fish_caught', target: 2000, point: P[4], coins: 40000, title: 'ti_fish_king' });
a({ id: 'ac_fishdex', cat: 'fish', name: 'Bách Khoa Cá', desc: 'Sưu tập đủ 30 loài cá.', stat: 'fish_species', target: 30, point: P[4], coins: 30000, title: 'ti_fish_master' });
a({ id: 'ac_fry', cat: 'fish', name: 'Ươm Cá Giống', desc: 'Thả 100 con cá giống xuống ao.', stat: 'fry_stocked', target: 100, point: P[2], coins: 5000 });
a({ id: 'ac_farmfish', cat: 'fish', name: 'Chủ Ao', desc: 'Vớt 200 con cá nuôi.', stat: 'fish_farmed', target: 200, point: P[2], coins: 5000, title: 'ti_pond' });

// ---- Chăn Nuôi ----
a({ id: 'ac_buyani', cat: 'animal', name: 'Nuôi Con Đầu Lòng', desc: 'Mua 5 con vật nuôi.', stat: 'animals_bought', target: 5, point: P[0], coins: 800 });
a({ id: 'ac_feed1', cat: 'animal', name: 'Chăm Bẵm', desc: 'Cho vật nuôi ăn 200 lần.', stat: 'fed', target: 200, point: P[1], coins: 2000, title: 'ti_herder' });
a({ id: 'ac_feed2', cat: 'animal', name: 'Trại Chăn Nuôi Lớn', desc: 'Cho vật nuôi ăn 1.000 lần.', stat: 'fed', target: 1000, point: P[3], coins: 12000 });
a({ id: 'ac_prod', cat: 'animal', name: 'Thu Hoạch Chuồng', desc: 'Thu 500 sản phẩm từ vật nuôi.', stat: 'collected_products', target: 500, point: P[2], coins: 6000, title: 'ti_rancher' });

// ---- Bếp Núc ----
a({ id: 'ac_cook1', cat: 'kitchen', name: 'Vào Bếp', desc: 'Nấu xong 30 món ăn.', stat: 'cooked', target: 30, point: P[1], coins: 1500 });
a({ id: 'ac_cook2', cat: 'kitchen', name: 'Đầu Bếp Cứng', desc: 'Nấu xong 300 món ăn.', stat: 'cooked', target: 300, point: P[3], coins: 12000, title: 'ti_chef' });
a({ id: 'ac_order1', cat: 'kitchen', name: 'Giao Hàng', desc: 'Giao xong 30 đơn hàng.', stat: 'orders_done', target: 30, point: P[1], coins: 2000, title: 'ti_courier' });
a({ id: 'ac_order2', cat: 'kitchen', name: 'Chủ Tiệm Uy Tín', desc: 'Giao xong 300 đơn hàng.', stat: 'orders_done', target: 300, point: P[3], coins: 15000, title: 'ti_shopkeep' });
a({ id: 'ac_sell', cat: 'kitchen', name: 'Buôn May Bán Đắt', desc: 'Bán 2.000 vật phẩm.', stat: 'sold', target: 2000, point: P[2], coins: 8000, title: 'ti_trader' });

// ---- Khéo Tay: nông cụ & việc vặt quanh nông trại ----
a({ id: 'ac_tool', cat: 'craft', name: 'Mài Cuốc', desc: 'Nâng cấp công cụ 20 lần.', stat: 'tool_upgraded', target: 20, point: P[1], coins: 3000, title: 'ti_smith' });
a({ id: 'ac_tool2', cat: 'craft', name: 'Bộ Đồ Nghề Xịn', desc: 'Nâng cấp công cụ 100 lần.', stat: 'tool_upgraded', target: 100, point: P[3], coins: 15000, title: 'ti_forge_master' });
a({ id: 'ac_khe', cat: 'craft', name: 'Ăn Khế Trả Vàng', desc: 'Rung cây khế 200 lần.', stat: 'khe_shaken', target: 200, point: P[2], coins: 6000, title: 'ti_chest' });
a({ id: 'ac_prod', cat: 'craft', name: 'Gom Góp', desc: 'Thu 500 sản phẩm chăn nuôi.', stat: 'collected_products', target: 500, point: P[2], coins: 6000 });
a({ id: 'ac_sellcrop', cat: 'craft', name: 'Được Mùa Được Giá', desc: 'Bán 1.000 nông sản.', stat: 'sold_crops', target: 1000, point: P[2], coins: 8000, title: 'ti_starman' });

// ---- Giải Trí ----
a({ id: 'ac_friend', cat: 'social', name: 'Quảng Giao', desc: 'Kết bạn với 10 người.', stat: 'friends_added', target: 10, point: P[1], coins: 1500, title: 'ti_social' });
a({ id: 'ac_gift', cat: 'social', name: 'Trao Yêu Thương', desc: 'Tặng 100 món quà.', stat: 'gifts_given', target: 100, point: P[2], coins: 5000, title: 'ti_gifter' });
a({ id: 'ac_chat', cat: 'social', name: 'Nhiều Chuyện', desc: 'Gửi 500 tin nhắn.', stat: 'chats_sent', target: 500, point: P[1], coins: 2000 });
a({ id: 'ac_mini1', cat: 'social', name: 'Chơi Cho Vui', desc: 'Thắng 50 ván mini game.', stat: 'minigame_wins', target: 50, point: P[2], coins: 5000, title: 'ti_gamer' });
a({ id: 'ac_caro', cat: 'social', name: 'Kỳ Thủ Caro', desc: 'Thắng 30 ván cờ caro.', stat: 'caro_wins', target: 30, point: P[2], coins: 5000, title: 'ti_caro' });
a({ id: 'ac_party', cat: 'social', name: 'Chủ Tiệc', desc: 'Tổ chức 10 bữa tiệc.', stat: 'parties', target: 10, point: P[2], coins: 6000, title: 'ti_party' });

// ---- Tổ Ấm ----
a({ id: 'ac_house', cat: 'home', name: 'An Cư', desc: 'Mua nhà riêng.', stat: 'house_bought', target: 1, point: P[1], coins: 2000, title: 'ti_homeowner' });
a({ id: 'ac_upg', cat: 'home', name: 'Nhà Cao Cửa Rộng', desc: 'Nâng cấp nhà 3 lần.', stat: 'house_upgraded', target: 3, point: P[3], coins: 15000, title: 'ti_mansion' });
a({ id: 'ac_furn', cat: 'home', name: 'Bày Biện', desc: 'Đặt 50 món nội thất.', stat: 'furniture_placed', target: 50, point: P[2], coins: 6000, title: 'ti_decor' });
a({ id: 'ac_lvl', cat: 'home', name: 'Thăng Tiến', desc: 'Đạt cấp 30.', stat: 'level_up', target: 29, point: P[3], coins: 20000, title: 'ti_veteran' });

// ---- Sưu Tập ----
a({ id: 'ac_fashion', cat: 'collect', name: 'Tín Đồ Thời Trang', desc: 'Sắm 50 món thời trang.', stat: 'fashion_bought', target: 50, point: P[2], coins: 6000, title: 'ti_fashion' });
a({ id: 'ac_skin', cat: 'collect', name: 'Sưu Tập Ảo Hoá', desc: 'Sở hữu 5 bộ skin.', stat: 'skins_owned', target: 5, point: P[3], coins: 15000, title: 'ti_skinner' });
a({ id: 'ac_title', cat: 'collect', name: 'Danh Gia Vọng Tộc', desc: 'Mở khoá 20 danh hiệu.', stat: 'titles_owned', target: 20, point: P[3], coins: 15000, title: 'ti_titled' });
a({ id: 'ac_rich', cat: 'collect', name: 'Triệu Phú', desc: 'Kiếm được tổng cộng 1.000.000 xu.', stat: 'coins_earned', target: 1000000, point: P[4], coins: 50000, title: 'ti_millionaire' });

export const ACH_TOTAL_POINT = ACHS.reduce((n, x) => n + x.point, 0);
export function achsOfCat(cat: string): AchDef[] { return ACHS.filter(x => x.cat === cat); }
export function catTotal(cat: string): number {
  return achsOfCat(cat).reduce((n, x) => n + x.point, 0);
}
