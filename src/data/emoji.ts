// ===== Emoji chat (bóc từ armature chat của GunPow) =====
// TỰ SINH bằng scripts/gp_chat_emoji.py — đừng sửa tay.
// Mỗi emoji là một dải ngang `frames` khung vuông, chạy bằng CSS steps().

export interface EmojiDef {
  id: string;      // mã trong tin nhắn: [e01]
  frames: number;  // số khung trong dải
  dur: number;     // giây một vòng
  w: number;       // cỡ một khung (px)
  h: number;
}

export const EMOJIS: EmojiDef[] = [
  { id: 'e01', frames: 12, dur: 0.4, w: 72, h: 72 },
  { id: 'e02', frames: 12, dur: 0.4, w: 72, h: 72 },
  { id: 'e03', frames: 10, dur: 0.33, w: 72, h: 72 },
  { id: 'e04', frames: 13, dur: 1.08, w: 72, h: 65 },
  { id: 'e05', frames: 12, dur: 0.4, w: 72, h: 72 },
  { id: 'e06', frames: 4, dur: 0.07, w: 72, h: 72 },
  { id: 'e07', frames: 4, dur: 0.07, w: 72, h: 72 },
  { id: 'e08', frames: 8, dur: 0.53, w: 72, h: 72 },
  { id: 'e09', frames: 13, dur: 0.43, w: 56, h: 72 },
  { id: 'e10', frames: 8, dur: 0.27, w: 72, h: 72 },
  { id: 'e11', frames: 10, dur: 0.33, w: 69, h: 72 },
  { id: 'e12', frames: 12, dur: 0.4, w: 72, h: 72 },
  { id: 'e13', frames: 10, dur: 0.33, w: 72, h: 72 },
  { id: 'e14', frames: 15, dur: 1.25, w: 61, h: 72 },
  { id: 'e15', frames: 8, dur: 0.13, w: 72, h: 72 },
  { id: 'e16', frames: 7, dur: 0.12, w: 72, h: 72 },
  { id: 'e17', frames: 13, dur: 0.43, w: 67, h: 72 },
  { id: 'e18', frames: 9, dur: 0.75, w: 72, h: 72 },
  { id: 'e19', frames: 12, dur: 0.4, w: 72, h: 72 },
  { id: 'e20', frames: 12, dur: 0.4, w: 72, h: 72 },
  { id: 'e21', frames: 12, dur: 1.0, w: 72, h: 72 },
  { id: 'e22', frames: 12, dur: 0.4, w: 72, h: 72 },
  { id: 'e23', frames: 12, dur: 0.4, w: 72, h: 72 },
  { id: 'e24', frames: 10, dur: 0.33, w: 69, h: 72 },
  { id: 'e25', frames: 13, dur: 0.43, w: 72, h: 63 },
  { id: 'e26', frames: 12, dur: 0.4, w: 68, h: 72 },
  { id: 'e27', frames: 11, dur: 0.37, w: 72, h: 71 },
  { id: 'e28', frames: 11, dur: 0.5, w: 68, h: 72 },
  { id: 'e29', frames: 13, dur: 0.43, w: 61, h: 72 },
  { id: 'e30', frames: 13, dur: 0.43, w: 67, h: 72 },
  { id: 'e31', frames: 13, dur: 0.65, w: 72, h: 62 },
  { id: 'e32', frames: 32, dur: 1.33, w: 60, h: 72 },
  { id: 'e33', frames: 16, dur: 1.33, w: 61, h: 72 },
  { id: 'e34', frames: 33, dur: 2.75, w: 71, h: 72 },
  { id: 'e35', frames: 30, dur: 1.33, w: 63, h: 72 },
  { id: 'e36', frames: 10, dur: 0.33, w: 63, h: 72 },
  { id: 'e37', frames: 10, dur: 0.4, w: 72, h: 66 },
  { id: 'e38', frames: 12, dur: 0.4, w: 67, h: 72 },
  { id: 'e39', frames: 10, dur: 0.33, w: 72, h: 58 },
  { id: 'e40', frames: 4, dur: 0.42, w: 72, h: 72 },
  { id: 'e41', frames: 30, dur: 0.97, w: 72, h: 72 },
];

export const EMOJI_BY_ID: Record<string, EmojiDef> =
  Object.fromEntries(EMOJIS.map(e => [e.id, e]));

export const emojiUrl = (id: string) => `assets/chat/emoji/${id}.png`;

// [e01] trong tin nhắn -> emoji; tách chuỗi thành khúc chữ và khúc emoji
export const EMOJI_RE = /\[(e\d{2})\]/g;
