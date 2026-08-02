// ===== Khung bong bóng chat =====
// Ảnh bóc từ atlas chat của GunPow (xem scripts/gp_chat_bubbles.py).
// Khung dùng kiểu 9 ô (border-image): 4 góc giữ nguyên hình trang trí, cạnh và
// ruột kéo giãn theo độ dài tin nhắn.
// Phần lớn khung là ẢNH ĐỘNG 2 khung hình (`anim`): đổi qua lại `<id>.png` và
// `<id>_b.png` — mèo vẫy đuôi, bướm bay, kim tuyến chạy...

export interface BubbleDef {
  id: string;
  name: string;
  price: number;                            // giá; 0 = có sẵn
  cur: 'xu' | 'ruby';                       // khung thường bán bằng xu, khung xịn bằng kim cương
  anim?: boolean;                           // có khung hình thứ 2 -> chạy động
  // ruột khung sáng hay tối -> chữ đen hay chữ trắng (đo bằng độ sáng ảnh)
  ink?: 'dark' | 'light';
  slice: [number, number, number, number];  // trên, phải, dưới, trái (px trên ảnh gốc)
}

const S1: [number, number, number, number] = [22, 30, 22, 30];   // khung 139x65
const S2: [number, number, number, number] = [24, 52, 24, 52];   // khung 170x70 (đầu nhọn)

export const BUBBLES: BubbleDef[] = [
  { id: 'b_default', name: 'Mặc định', price: 0, cur: 'xu', slice: [0, 0, 0, 0] },

  // ---- khung trơn (tĩnh) ----
  { id: 'b_plain_beige', name: 'Kem sữa', price: 800, cur: 'xu', ink: 'dark', slice: S1 },
  { id: 'b_plain_green', name: 'Cỏ non', price: 800, cur: 'xu', ink: 'dark', slice: S1 },
  { id: 'b_plain_yellow', name: 'Nắng mai', price: 800, cur: 'xu', ink: 'dark', slice: S1 },

  // ---- thú cưng & hoa lá (động, mua bằng xu) ----
  { id: 'b_cat', name: 'Mèo nghịch ngợm', price: 3000, cur: 'xu', anim: true, ink: 'light', slice: S1 },
  { id: 'b_snowman', name: 'Người tuyết', price: 3000, cur: 'xu', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_snowflake', name: 'Bông tuyết', price: 3000, cur: 'xu', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_bunny', name: 'Thỏ hồng', price: 3500, cur: 'xu', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_frog', name: 'Ếch cỏ', price: 3500, cur: 'xu', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_kitten', name: 'Mèo tam thể', price: 3500, cur: 'xu', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_violet', name: 'Hoa tím', price: 4000, cur: 'xu', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_leaf', name: 'Lá hồng', price: 4000, cur: 'xu', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_pinkcat', name: 'Mèo hồng', price: 6000, cur: 'xu', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_sakura_violet', name: 'Anh đào tím', price: 6000, cur: 'xu', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_chick', name: 'Gà con', price: 6000, cur: 'xu', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_dolphin', name: 'Cá heo', price: 8000, cur: 'xu', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_dove', name: 'Bồ câu', price: 8000, cur: 'xu', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_sakura_red', name: 'Anh đào đỏ', price: 8000, cur: 'xu', anim: true, ink: 'light', slice: S1 },

  // ---- khung cầu kỳ (động, mua bằng kim cương) ----
  { id: 'b_wood', name: 'Gỗ cổ', price: 60, cur: 'ruby', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_angel', name: 'Thiên thần', price: 60, cur: 'ruby', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_butterfly', name: 'Bướm hồng', price: 80, cur: 'ruby', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_forest', name: 'Rừng xanh', price: 80, cur: 'ruby', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_beach', name: 'Biển hè', price: 100, cur: 'ruby', anim: true, ink: 'dark', slice: S1 },
  { id: 'b_ruby', name: 'Hồng ngọc', price: 120, cur: 'ruby', anim: true, ink: 'light', slice: S1 },
  { id: 'b_royal', name: 'Hoàng kim', price: 150, cur: 'ruby', anim: true, ink: 'light', slice: S1 },
  { id: 'b_blossom', name: 'Hoa xuân', price: 150, cur: 'ruby', anim: true, ink: 'light', slice: S1 },

  // ---- hàng hiếm (khung to) ----
  { id: 'b_lotus', name: 'Sen ngọc', price: 200, cur: 'ruby', anim: true, ink: 'light', slice: S2 },
  { id: 'b_deer', name: 'Lộc rừng', price: 220, cur: 'ruby', ink: 'light', slice: S2 },
  { id: 'b_sword', name: 'Kiếm thần', price: 250, cur: 'ruby', ink: 'light', slice: S2 },
  { id: 'b_mountain', name: 'Non nước', price: 280, cur: 'ruby', ink: 'dark', slice: S2 },
  { id: 'b_aurora', name: 'Cực quang', price: 300, cur: 'ruby', ink: 'light', slice: S2 },
  { id: 'b_galaxy', name: 'Ngân hà', price: 350, cur: 'ruby', ink: 'light', slice: S2 },
  { id: 'b_phoenix', name: 'Phượng hoàng', price: 400, cur: 'ruby', ink: 'light', slice: S2 },
  { id: 'b_meteor', name: 'Sao băng', price: 500, cur: 'ruby', ink: 'light', slice: S2 }
];

export const BUBBLE_BY_ID: Record<string, BubbleDef> =
  Object.fromEntries(BUBBLES.map(b => [b.id, b]));

export const bubbleUrl = (id: string, second = false) =>
  `assets/chat/bubble/${id}${second ? '_b' : ''}.png`;
