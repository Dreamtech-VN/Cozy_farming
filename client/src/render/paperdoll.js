/**
 * Ghép nhân vật từ các mảnh rời: thân (trang phục), khuôn mặt, kiểu tóc.
 *
 * Art gốc không có sẵn nhân vật hoàn chỉnh cho mọi tổ hợp — 5 bộ đồ × 9 khuôn
 * mặt × 6 kiểu tóc × 4 màu da là 1080 hình, nên phải ghép lúc vẽ.
 *
 * Ba mảnh ăn khớp nhau nhờ hai mốc đo được từ chính art, không phải số chỉnh
 * tay: mảnh trang phục là thân người CỤT ĐẦU nên mép trên của nó là cổ, còn
 * mảnh tóc thì lúc nhập art đã bị khoét rỗng phần mặt và cái LỖ đó ghi lại
 * trong atlas (`hole`) — đáy lỗ chính là cằm. Đặt cằm của khuôn mặt trùng đáy
 * lỗ của tóc là xong, thêm kiểu tóc mới không phải chỉnh gì.
 */

/** Bốn tông da trên bảng thành phần, đọc thẳng từ ô màu trong tấm gốc. */
export const SKIN_TONES = ['#fee8d2', '#fed2b5', '#fbc4a1', '#d69a7a'];

// Cổ áo chờm lên cằm vài pixel: để hở là nhân vật có một khe sáng giữa đầu và
// thân, nhìn như cái đầu bay lơ lửng.
const NECK_OVERLAP = 6;

// Khuôn mặt trên tấm gốc vẽ TO hơn cái đầu mà các kiểu tóc ôm quanh — bày
// riêng một khung để nhìn cho rõ nên nó được vẽ rộng ra. Đội thẳng thì đỉnh
// đầu trọc nhô ra ngoài mái tóc. Hệ số này đo bằng mắt trên cả 11 kiểu tóc.
const FACE_FIT = 0.86;

const BASE_SKIN = [254, 232, 210];

/** Da người trong bộ art này: sáng, ngả đỏ, R > G >= B, chênh lệch vừa phải. */
function isSkin(r, g, b) {
  return r >= 185 && r > g && g >= b && r - b >= 15 && r - b <= 95 && r - g <= 45;
}

const tintCache = new Map();

/**
 * Bản sao của một mảnh art đã đổi tông da.
 *
 * Nhân theo TỈ LỆ với tông gốc chứ không tô đè: giữ nguyên mảng sáng tối đã vẽ
 * sẵn trên mặt, tô đè một màu phẳng là mất hết khối.
 */
function tinted(part, toneIndex) {
  const { rect, img } = part;
  const key = `${rect.page}:${rect.x}:${rect.y}:${toneIndex}`;
  const hit = tintCache.get(key);
  if (hit) return hit;

  const canvas = document.createElement('canvas');
  canvas.width = rect.w;
  canvas.height = rect.h;
  const ctx = canvas.getContext('2d', { willReadFrequently: true });
  ctx.drawImage(img, rect.x, rect.y, rect.w, rect.h, 0, 0, rect.w, rect.h);

  const tone = SKIN_TONES[toneIndex];
  const target = [1, 3, 5].map((i) => parseInt(tone.slice(i, i + 2), 16));
  const ratio = target.map((c, i) => c / BASE_SKIN[i]);
  const px = ctx.getImageData(0, 0, rect.w, rect.h);
  const d = px.data;
  for (let i = 0; i < d.length; i += 4) {
    if (!d[i + 3] || !isSkin(d[i], d[i + 1], d[i + 2])) continue;
    d[i] = Math.min(255, d[i] * ratio[0]);
    d[i + 1] = Math.min(255, d[i + 1] * ratio[1]);
    d[i + 2] = Math.min(255, d[i + 2] * ratio[2]);
  }
  ctx.putImageData(px, 0, 0);
  tintCache.set(key, canvas);
  return canvas;
}

/** Mảnh art để vẽ: ảnh nguồn kèm ô cần cắt, đã đổi tông da nếu cần. */
function source(part, toneIndex) {
  if (!toneIndex) return { img: part.img, sx: part.rect.x, sy: part.rect.y };
  return { img: tinted(part, toneIndex), sx: 0, sy: 0 };
}

/**
 * Ba mảnh của một bộ ngoại hình, hoặc null nếu art chưa tới nơi.
 * Thiếu một mảnh là bỏ vẽ cả bộ: vẽ nửa vời ra cái thân không đầu.
 */
export function lookParts(atlas, look) {
  const outfit = atlas.part(look.outfit);
  const face = atlas.part(look.face);
  const hair = look.hair ? atlas.part(look.hair) : null;
  if (!outfit || !face) return null;
  if (look.hair && !hair) return null;
  return { outfit, face, hair };
}

/** Chiều cao tự nhiên của bộ ngoại hình theo pixel art gốc. */
function naturalHeight({ outfit, face, hair }) {
  // Từ cằm lên đỉnh: tóc thường cao hơn đầu trọc, nhưng kiểu tóc sát đầu thì
  // không — lấy cái nào cao hơn.
  const hairAboveChin = hair?.rect.hole ? hair.rect.hole.y + hair.rect.hole.h : 0;
  const aboveChin = Math.max(face.rect.h * FACE_FIT, hairAboveChin);
  return outfit.rect.h - NECK_OVERLAP + aboveChin;
}

/**
 * Vẽ nhân vật ghép, neo ĐÁY GIỮA tại (x, groundY), cao đúng `height`.
 * @returns true nếu vẽ được, false nếu art chưa sẵn sàng.
 */
export function drawLook(ctx, atlas, look, { x, groundY, height }) {
  const parts = lookParts(atlas, look);
  if (!parts) return false;
  const { outfit, face, hair } = parts;
  const tone = look.skin ?? 0;
  const s = height / naturalHeight(parts);

  const putAt = (part, dx, dy, scale, toneIndex) => {
    const { img, sx, sy } = source(part, toneIndex);
    ctx.drawImage(img, sx, sy, part.rect.w, part.rect.h,
      dx, dy, part.rect.w * scale, part.rect.h * scale);
  };
  const put = (part, dx, dy, toneIndex) => putAt(part, dx, dy, s, toneIndex);

  const bodyW = outfit.rect.w * s;
  const bodyTop = groundY - outfit.rect.h * s;
  put(outfit, x - bodyW / 2, bodyTop, tone);

  const chinY = bodyTop + NECK_OVERLAP * s;
  const faceS = s * FACE_FIT;
  const faceW = face.rect.w * faceS;
  putAt(face, x - faceW / 2, chinY - face.rect.h * faceS, faceS, tone);

  if (hair) {
    // Căn theo LỖ khoét trên mảnh tóc: tâm lỗ trùng tâm mặt, đáy lỗ trùng cằm.
    const hole = hair.rect.hole;
    const hairW = hair.rect.w * s;
    const hairX = hole
      ? x - (hole.x + hole.w / 2) * s
      : x - hairW / 2;
    const hairY = hole
      ? chinY - (hole.y + hole.h) * s
      : chinY - hair.rect.h * s;
    // Tóc KHÔNG đổi theo tông da: tóc vàng và da gần như trùng màu nên phép
    // thử da bắt luôn cả mái tóc, chọn da ngăm là tóc vàng thành tóc nâu.
    put(hair, hairX, hairY, 0);
  }
  return true;
}
