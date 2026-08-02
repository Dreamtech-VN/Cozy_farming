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
  { id: 'e01', frames: 12, dur: 0.4, w: 124, h: 124 },
  { id: 'e02', frames: 12, dur: 0.4, w: 124, h: 124 },
  { id: 'e03', frames: 10, dur: 0.33, w: 124, h: 124 },
  { id: 'e04', frames: 13, dur: 1.08, w: 146, h: 132 },
  { id: 'e05', frames: 12, dur: 0.4, w: 124, h: 124 },
  { id: 'e06', frames: 4, dur: 0.07, w: 124, h: 124 },
  { id: 'e07', frames: 4, dur: 0.07, w: 124, h: 124 },
  { id: 'e08', frames: 8, dur: 0.53, w: 124, h: 124 },
  { id: 'e09', frames: 13, dur: 0.43, w: 124, h: 159 },
  { id: 'e10', frames: 8, dur: 0.27, w: 124, h: 124 },
  { id: 'e11', frames: 10, dur: 0.33, w: 118, h: 124 },
  { id: 'e12', frames: 12, dur: 0.4, w: 124, h: 124 },
  { id: 'e13', frames: 10, dur: 0.33, w: 124, h: 124 },
  { id: 'e14', frames: 15, dur: 1.25, w: 114, h: 134 },
  { id: 'e15', frames: 8, dur: 0.13, w: 124, h: 124 },
  { id: 'e16', frames: 7, dur: 0.12, w: 124, h: 124 },
  { id: 'e17', frames: 13, dur: 0.43, w: 115, h: 124 },
  { id: 'e18', frames: 9, dur: 0.75, w: 124, h: 124 },
  { id: 'e19', frames: 12, dur: 0.4, w: 124, h: 124 },
  { id: 'e20', frames: 12, dur: 0.4, w: 124, h: 124 },
  { id: 'e21', frames: 12, dur: 1.0, w: 124, h: 124 },
  { id: 'e22', frames: 12, dur: 0.4, w: 124, h: 124 },
  { id: 'e23', frames: 12, dur: 0.4, w: 124, h: 124 },
  { id: 'e24', frames: 10, dur: 0.33, w: 118, h: 124 },
  { id: 'e25', frames: 13, dur: 0.43, w: 148, h: 129 },
  { id: 'e26', frames: 12, dur: 0.4, w: 115, h: 121 },
  { id: 'e27', frames: 11, dur: 0.37, w: 139, h: 138 },
  { id: 'e28', frames: 11, dur: 0.5, w: 126, h: 134 },
  { id: 'e29', frames: 13, dur: 0.43, w: 123, h: 145 },
  { id: 'e30', frames: 13, dur: 0.43, w: 124, h: 133 },
  { id: 'e31', frames: 13, dur: 0.65, w: 157, h: 135 },
  { id: 'e32', frames: 32, dur: 1.33, w: 105, h: 125 },
  { id: 'e33', frames: 16, dur: 1.33, w: 114, h: 134 },
  { id: 'e34', frames: 33, dur: 2.75, w: 114, h: 116 },
  { id: 'e35', frames: 30, dur: 1.33, w: 108, h: 124 },
  { id: 'e36', frames: 10, dur: 0.33, w: 129, h: 147 },
  { id: 'e37', frames: 10, dur: 0.4, w: 140, h: 129 },
  { id: 'e38', frames: 12, dur: 0.4, w: 119, h: 128 },
  { id: 'e39', frames: 10, dur: 0.33, w: 160, h: 129 },
  { id: 'e40', frames: 4, dur: 0.42, w: 135, h: 135 },
  { id: 'e41', frames: 30, dur: 0.97, w: 160, h: 160 },
];

export const EMOJI_BY_ID: Record<string, EmojiDef> =
  Object.fromEntries(EMOJIS.map(e => [e.id, e]));

export const emojiUrl = (id: string) => `assets/chat/emoji/${id}.png`;

// [e01] trong tin nhắn -> emoji; tách chuỗi thành khúc chữ và khúc emoji
export const EMOJI_RE = /\[(e\d{2})\]/g;
