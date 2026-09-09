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

/**
 * Màu mắt. Mảnh khuôn mặt gốc vẽ mắt nâu, các màu sau là nhuộm lại.
 *
 * Nhuộm chứ không vẽ thêm mảnh: mắt trên art gốc có cả vành tối, lòng sáng dần
 * và một chấm sáng — thay bằng một mảng màu phẳng là mất hết chiều sâu đó.
 */
export const EYE_COLOURS = [
  { id: 'nau', label: 'Nâu', hex: '#7a4a2a' },
  { id: 'xanh_duong', label: 'Xanh dương', hex: '#3d7bd6' },
  { id: 'xanh_la', label: 'Xanh lá', hex: '#3f9e5c' },
  { id: 'tim', label: 'Tím', hex: '#8a5ad6' },
  { id: 'ho_phach', label: 'Hổ phách', hex: '#d99a2b' },
];

// Cằm chờm xuống mảnh trang phục mấy pixel (tính theo art gốc).
//
// KHÔNG vẽ thêm cổ. Mảnh trang phục vốn đã có khúc cổ vẽ sẵn — có khối, có nét
// viền, có bóng — nên việc ở đây chỉ là đặt cằm xuống vừa chạm nó. Tôi đã thử
// vá bằng một mẩu cổ tô tay: mảng màu phẳng không ăn nhập với nét vẽ chung
// quanh, nhìn ra ngay là miếng dán, mà chờm sâu cho kín thì lại nuốt mất cổ.
const NECK_OVERLAP = 8;

// Khuôn mặt trên tấm gốc vẽ TO hơn cái đầu mà các kiểu tóc ôm quanh — bày
// riêng một khung để nhìn cho rõ nên nó được vẽ rộng ra. Đội thẳng thì đỉnh
// đầu trọc nhô ra ngoài mái tóc.
//
// Chỉnh bằng cách PHÓNG TÓC chứ không thu nhỏ mặt. Thu mặt thì cái đầu bé lại
// so với thân, mà khúc cổ trên mảnh trang phục lại vẽ vừa cái đầu cỡ thật —
// cằm hụt không với tới cổ, hở ra một vệt nhìn thấu nền ngay dưới hàm.
const HAIR_FIT = 1.06;

const BASE_SKIN = [254, 232, 210];

/** Da người trong bộ art này: sáng, ngả đỏ, R > G >= B, chênh lệch vừa phải. */
function isSkin(r, g, b) {
  return r >= 185 && r > g && g >= b && r - b >= 15 && r - b <= 95 && r - g <= 45;
}

const variantCache = new Map();

function toHsl(r, g, b) {
  r /= 255; g /= 255; b /= 255;
  const max = Math.max(r, g, b), min = Math.min(r, g, b), d = max - min;
  const l = (max + min) / 2;
  if (!d) return [0, 0, l];
  const s = d / (1 - Math.abs(2 * l - 1));
  const h = max === r ? ((g - b) / d + (g < b ? 6 : 0)) : max === g ? ((b - r) / d + 2) : ((r - g) / d + 4);
  return [h * 60, s, l];
}

function fromHsl(h, s, l) {
  const c = (1 - Math.abs(2 * l - 1)) * s;
  const x = c * (1 - Math.abs(((h / 60) % 2) - 1));
  const m = l - c / 2;
  const [r, g, b] = h < 60 ? [c, x, 0] : h < 120 ? [x, c, 0] : h < 180 ? [0, c, x]
    : h < 240 ? [0, x, c] : h < 300 ? [x, 0, c] : [c, 0, x];
  return [(r + m) * 255, (g + m) * 255, (b + m) * 255];
}

/**
 * Hai con mắt trên mảnh khuôn mặt: hai cụm pixel TỐI to nhất.
 *
 * Tìm theo cụm chứ không theo màu: lông mày và nét viền cũng nâu sẫm y hệt
 * lòng mắt, chỉ khác ở chỗ chúng bé hơn nhiều. Trên mảnh face_m_01 hai mắt là
 * 268 và 240 pixel, còn lông mày chỉ 38 và 33.
 */
function eyeMask(data, w, h) {
  const dark = (i) => data[i * 4 + 3] > 128
    && 0.2126 * data[i * 4] + 0.7152 * data[i * 4 + 1] + 0.0722 * data[i * 4 + 2] < 150;
  const label = new Int32Array(w * h).fill(-1);
  const queue = new Int32Array(w * h);
  const clusters = [];
  for (let start = 0; start < w * h; start++) {
    if (label[start] >= 0 || !dark(start)) continue;
    let qh = 0, qt = 0;
    queue[qt++] = start; label[start] = start;
    const cluster = [start];
    while (qh < qt) {
      const i = queue[qh++];
      const x = i % w, y = (i / w) | 0;
      for (let dy = -1; dy <= 1; dy++) for (let dx = -1; dx <= 1; dx++) {
        const nx = x + dx, ny = y + dy;
        if (nx < 0 || ny < 0 || nx >= w || ny >= h) continue;
        const j = ny * w + nx;
        if (label[j] >= 0 || !dark(j)) continue;
        label[j] = start; queue[qt++] = j; cluster.push(j);
      }
    }
    clusters.push(cluster);
  }
  clusters.sort((a, b) => b.length - a.length);
  const mask = new Uint8Array(w * h);
  for (const cluster of clusters.slice(0, 2)) for (const i of cluster) mask[i] = 1;
  return mask;
}

/** Tông màu giữa của vùng mắt — mốc để xoay sang màu người chơi chọn. */
function medianHue(d, mask) {
  const hues = [];
  for (let i = 0; i < mask.length; i++) {
    if (!mask[i]) continue;
    const p = i * 4;
    const [h, sat] = toHsl(d[p], d[p + 1], d[p + 2]);
    if (sat >= 0.2) hues.push(h);
  }
  if (!hues.length) return 25; // nâu, tông mắt trên art gốc
  hues.sort((a, b) => a - b);
  return hues[hues.length >> 1];
}

/**
 * Bản sao của một mảnh art đã đổi tông da và/hoặc màu mắt.
 *
 * Da nhân theo TỈ LỆ với tông gốc chứ không tô đè: giữ nguyên mảng sáng tối đã
 * vẽ sẵn trên mặt, tô đè một màu phẳng là mất hết khối. Mắt thì giữ nguyên độ
 * sáng của từng pixel và chỉ thay màu, nên vành tối và chấm sáng còn nguyên.
 */
function recoloured(part, skin, eyes) {
  const { rect, img } = part;
  const key = `${rect.page}:${rect.x}:${rect.y}:${skin}:${eyes}`;
  const hit = variantCache.get(key);
  if (hit) return hit;

  const canvas = document.createElement('canvas');
  canvas.width = rect.w;
  canvas.height = rect.h;
  const ctx = canvas.getContext('2d', { willReadFrequently: true });
  ctx.drawImage(img, rect.x, rect.y, rect.w, rect.h, 0, 0, rect.w, rect.h);

  const px = ctx.getImageData(0, 0, rect.w, rect.h);
  const d = px.data;

  if (skin) {
    const tone = SKIN_TONES[skin];
    const target = [1, 3, 5].map((i) => parseInt(tone.slice(i, i + 2), 16));
    const ratio = target.map((c, i) => c / BASE_SKIN[i]);
    for (let i = 0; i < d.length; i += 4) {
      if (!d[i + 3] || !isSkin(d[i], d[i + 1], d[i + 2])) continue;
      d[i] = Math.min(255, d[i] * ratio[0]);
      d[i + 1] = Math.min(255, d[i + 1] * ratio[1]);
      d[i + 2] = Math.min(255, d[i + 2] * ratio[2]);
    }
  }

  if (eyes) {
    const mask = eyeMask(d, rect.w, rect.h);
    const hex = EYE_COLOURS[eyes].hex;
    const [th] = toHsl(...[1, 3, 5].map((i) => parseInt(hex.slice(i, i + 2), 16)));

    // XOAY tông màu, không gán tông mới.
    //
    // Gán thẳng tông và độ tươi của màu đích cho mọi pixel trong vùng mắt thì
    // nét viền và phần trắng cũng bị nhuộm đậm như nhau, con mắt biến thành
    // một MẢNG MÀU vuông vắn thay vì con mắt có vành, có lòng, có chấm sáng.
    // Xoay thì mỗi pixel giữ nguyên độ tươi và độ sáng của nó, chỉ đổi tông —
    // nét gần như không màu vẫn gần như không màu.
    const base = medianHue(d, mask);
    const turn = ((th - base) % 360 + 360) % 360;
    for (let i = 0; i < mask.length; i++) {
      if (!mask[i]) continue;
      const p = i * 4;
      const [h, sat, l] = toHsl(d[p], d[p + 1], d[p + 2]);
      if (sat < 0.12) continue; // chấm sáng và nét xám: để yên
      const [r, g, b] = fromHsl((h + turn) % 360, Math.min(1, sat * 1.15), l);
      d[p] = r; d[p + 1] = g; d[p + 2] = b;
    }
  }

  ctx.putImageData(px, 0, 0);
  variantCache.set(key, canvas);
  return canvas;
}

/** Mảnh art để vẽ: ảnh nguồn kèm ô cần cắt, đã nhuộm lại nếu cần. */
function source(part, { skin = 0, eyes = 0 } = {}) {
  if (!skin && !eyes) return { img: part.img, sx: part.rect.x, sy: part.rect.y };
  return { img: recoloured(part, skin, eyes), sx: 0, sy: 0 };
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
  const hairAboveChin = hair?.rect.hole ? (hair.rect.hole.y + hair.rect.hole.h) * HAIR_FIT : 0;
  const aboveChin = Math.max(face.rect.h, hairAboveChin);
  return outfit.rect.h - NECK_OVERLAP + aboveChin;
}


/**
 * Các mốc dựng hình: tỉ lệ vẽ, mép trên mảnh trang phục, và cằm.
 *
 * Tách ra để chỗ khác đo lại được — bài kiểm tra dò lỗ hở ở khúc cổ cần biết
 * chính xác khúc cổ nằm ở đâu, mà đoán lại công thức thì hai bên lệch nhau lúc
 * nào không hay.
 */
export function lookLayout(atlas, look, { groundY, height }) {
  const parts = lookParts(atlas, look);
  if (!parts) return null;
  const s = height / naturalHeight(parts);
  const bodyTop = groundY - parts.outfit.rect.h * s;
  return { s, bodyTop, chinY: bodyTop + NECK_OVERLAP * s, parts };
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

  const putAt = (part, dx, dy, scale, opts) => {
    const { img, sx, sy } = source(part, opts);
    ctx.drawImage(img, sx, sy, part.rect.w, part.rect.h,
      dx, dy, part.rect.w * scale, part.rect.h * scale);
  };
  const put = (part, dx, dy, opts) => putAt(part, dx, dy, s, opts);

  const bodyW = outfit.rect.w * s;
  const bodyTop = groundY - outfit.rect.h * s;
  const chinY = bodyTop + NECK_OVERLAP * s;
  const faceW = face.rect.w * s;

  put(outfit, x - bodyW / 2, bodyTop, { skin: tone });
  put(face, x - faceW / 2, chinY - face.rect.h * s, { skin: tone, eyes: look.eyes ?? 0 });

  if (hair) {
    // Căn theo LỖ khoét trên mảnh tóc: tâm lỗ trùng tâm mặt, đáy lỗ trùng cằm.
    const hole = hair.rect.hole;
    const hairS = s * HAIR_FIT;
    const hairX = hole
      ? x - (hole.x + hole.w / 2) * hairS
      : x - hair.rect.w * hairS / 2;
    const hairY = hole
      ? chinY - (hole.y + hole.h) * hairS
      : chinY - hair.rect.h * hairS;
    // Tóc KHÔNG đổi theo tông da: tóc vàng và da gần như trùng màu nên phép
    // thử da bắt luôn cả mái tóc, chọn da ngăm là tóc vàng thành tóc nâu.
    putAt(hair, hairX, hairY, hairS, {});
  }
  return true;
}

/** Tên các lựa chọn có thật trong atlas, theo giới. Đọc từ atlas chứ không
 *  chép tay: thêm kiểu tóc vào bảng art là màn tạo nhân vật có thêm lựa chọn. */
export function lookOptions(atlas, gender) {
  const index = atlas.meta?.sprites?.index ?? {};
  const pick = (prefix) => Object.keys(index)
    .filter((n) => n.startsWith(`${prefix}_${gender}_`) && !n.endsWith('_back'))
    .sort();
  return { face: pick('face'), hair: pick('hair'), outfit: pick('outfit') };
}

/** Bộ ngoại hình mở màn: mảnh đầu tiên của mỗi loại, da sáng nhất, mắt nâu. */
export function defaultLook(atlas, gender) {
  const options = lookOptions(atlas, gender);
  return {
    gender,
    face: options.face[0],
    hair: options.hair[0],
    outfit: options.outfit[0],
    skin: 0,
    eyes: 0,
  };
}

/** Bộ ngoại hình ngẫu nhiên — nút xúc xắc ở màn tạo nhân vật. */
export function randomLook(atlas, gender) {
  const options = lookOptions(atlas, gender);
  const any = (list) => list[Math.floor(Math.random() * list.length)];
  return {
    gender,
    // Khuôn mặt chỉ dùng MỘT mảnh: những mảnh còn lại trên tấm gốc khác nhau ở
    // nét mặt (nháy mắt, cười) chứ không phải ở kiểu, để dành cho biểu cảm sau
    // này. Cái người chơi đổi được ở đây là màu mắt.
    face: options.face[0],
    hair: any(options.hair),
    outfit: any(options.outfit),
    skin: Math.floor(Math.random() * SKIN_TONES.length),
    eyes: Math.floor(Math.random() * EYE_COLOURS.length),
  };
}

/**
 * Vẽ MỘT mảnh vừa khít trong khung, dùng cho ô chọn.
 *
 * Ô chọn kiểu tóc phải thấy cả khuôn mặt mới biết tóc ôm đầu thế nào, nên
 * `face` truyền vào thì vẽ mặt trước rồi mới úp tóc lên.
 */
export function drawThumb(ctx, atlas, name, { x, y, w, h, face = null, skin = 0, eyes = 0 }) {
  const part = atlas.part(name);
  if (!part) return false;
  const head = face ? atlas.part(face) : null;
  if (face && !head) return false;

  const s = Math.min(w / part.rect.w, h / part.rect.h);
  const cx = x + w / 2;
  const bottom = y + h - (h - part.rect.h * s) / 2;

  if (head) {
    // Cùng cách căn như lúc ghép người: đáy lỗ khoét trùng cằm, mặt vẽ cỡ thật
    // còn tóc thì đã to sẵn theo HAIR_FIT nên ở đây mặt nhỏ lại tương ứng.
    const hole = part.rect.hole;
    const chin = hole ? bottom - (part.rect.h - hole.y - hole.h) * s : bottom;
    const faceS = s / HAIR_FIT;
    const src = source(head, { skin, eyes });
    ctx.drawImage(src.img, src.sx, src.sy, head.rect.w, head.rect.h,
      cx - head.rect.w * faceS / 2, chin - head.rect.h * faceS, head.rect.w * faceS, head.rect.h * faceS);
  }
  const src = source(part, head ? {} : { skin, eyes });
  ctx.drawImage(src.img, src.sx, src.sy, part.rect.w, part.rect.h,
    cx - part.rect.w * s / 2, bottom - part.rect.h * s, part.rect.w * s, part.rect.h * s);
  return true;
}
