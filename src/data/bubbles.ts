// ===== Khung bong bóng chat (mua bằng xu) =====
// Ảnh bóc từ atlas chat của GunPow (xem scripts/gp_chat_bubbles.py).
// Mỗi khung dùng kiểu 9 ô (border-image): 4 góc giữ nguyên (chỗ có hình trang
// trí), cạnh và ruột kéo giãn theo độ dài tin nhắn.

export interface BubbleDef {
  id: string;
  name: string;
  price: number;                        // 0 = có sẵn, không cần mua
  slice: [number, number, number, number];  // trên, phải, dưới, trái (px trên ảnh gốc)
  pad?: [number, number, number, number];   // đệm chữ, mặc định theo slice
}

const S1: [number, number, number, number] = [22, 30, 22, 30];   // khung 139x65
const S2: [number, number, number, number] = [24, 52, 24, 52];   // khung 170x70 (đầu nhọn)

export const BUBBLES: BubbleDef[] = [
  { id: 'b_default', name: 'Mặc định', price: 0, slice: [0, 0, 0, 0] },

  // ---- rẻ: khung trơn ----
  { id: 'b_plain_beige', name: 'Kem sữa', price: 800, slice: S1 },
  { id: 'b_plain_green', name: 'Cỏ non', price: 800, slice: S1 },
  { id: 'b_plain_yellow', name: 'Nắng mai', price: 800, slice: S1 },

  // ---- thú cưng & hoa lá ----
  { id: 'b_cat', name: 'Mèo nghịch ngợm', price: 3000, slice: S1 },
  { id: 'b_snowman', name: 'Người tuyết', price: 3000, slice: S1 },
  { id: 'b_snowflake', name: 'Bông tuyết', price: 3000, slice: S1 },
  { id: 'b_bunny', name: 'Thỏ hồng', price: 3500, slice: S1 },
  { id: 'b_frog', name: 'Ếch cỏ', price: 3500, slice: S1 },
  { id: 'b_owl', name: 'Cú mèo', price: 3500, slice: S1 },
  { id: 'b_violet', name: 'Hoa tím', price: 4000, slice: S1 },
  { id: 'b_leaf', name: 'Lá hồng', price: 4000, slice: S1 },
  { id: 'b_pinkcat', name: 'Mèo hồng', price: 6000, slice: S1 },
  { id: 'b_sakura_violet', name: 'Anh đào tím', price: 6000, slice: S1 },
  { id: 'b_chick', name: 'Gà con', price: 6000, slice: S1 },
  { id: 'b_dolphin', name: 'Cá heo', price: 8000, slice: S1 },
  { id: 'b_bird', name: 'Chim sẻ', price: 8000, slice: S1 },
  { id: 'b_sakura_red', name: 'Anh đào đỏ', price: 8000, slice: S1 },

  // ---- khung cầu kỳ ----
  { id: 'b_wood', name: 'Gỗ cổ', price: 15000, slice: S1 },
  { id: 'b_angel', name: 'Thiên thần', price: 15000, slice: S1 },
  { id: 'b_butterfly', name: 'Bướm hồng', price: 18000, slice: S1 },
  { id: 'b_forest', name: 'Rừng xanh', price: 18000, slice: S1 },
  { id: 'b_beach', name: 'Biển hè', price: 20000, slice: S1 },
  { id: 'b_ruby', name: 'Hồng ngọc', price: 25000, slice: S1 },
  { id: 'b_royal', name: 'Hoàng kim', price: 30000, slice: S1 },
  { id: 'b_blossom', name: 'Hoa xuân', price: 30000, slice: S1 },

  // ---- hàng hiếm ----
  { id: 'b_lotus', name: 'Sen ngọc', price: 50000, slice: S2 },
  { id: 'b_sword', name: 'Kiếm thần', price: 60000, slice: S2 },
  { id: 'b_aurora', name: 'Cực quang', price: 70000, slice: S2 },
  { id: 'b_galaxy', name: 'Ngân hà', price: 90000, slice: S2 },
  { id: 'b_phoenix', name: 'Phượng hoàng', price: 100000, slice: S2 },
  { id: 'b_meteor', name: 'Sao băng', price: 120000, slice: S2 }
];

export const BUBBLE_BY_ID: Record<string, BubbleDef> =
  Object.fromEntries(BUBBLES.map(b => [b.id, b]));

export const bubbleUrl = (id: string) => `assets/chat/bubble/${id}.png`;

/** CSS đắp khung vào một bong bóng chat (border-image 9 ô).
 *  `k` thu nhỏ viền so với ảnh gốc (khung gốc 139x65 to hơn bong bóng chat). */
export function bubbleStyle(id: string, k = 0.55): string {
  const b = BUBBLE_BY_ID[id];
  if (!b || b.id === 'b_default') return '';
  const [t, r, bo, l] = b.slice;
  const bw = (v: number) => Math.round(v * k);
  return `border-image: url(${bubbleUrl(id)}) ${t} ${r} ${bo} ${l} fill stretch;`
    + `border-width: ${bw(t)}px ${bw(r)}px ${bw(bo)}px ${bw(l)}px; border-style: solid;`
    + 'background: none; box-shadow: none; padding: 1px 4px;';
}
