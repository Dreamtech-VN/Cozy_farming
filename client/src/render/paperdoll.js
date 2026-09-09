/**
 * Ghép nhân vật từ các mảnh rời: trang phục, đầu, mắt, tóc.
 *
 * Art gốc không có sẵn nhân vật hoàn chỉnh cho mọi tổ hợp — 5 bộ đồ × 5 kiểu
 * tóc × 5 màu mắt × 5 tông da là 625 hình cho mỗi giới, nên phải ghép lúc vẽ.
 *
 * Bộ art này KHÔNG kèm bộ xương: `spine_export/*.json` trong gói art chỉ là
 * khung rỗng do một script sinh ra — mọi xương đều nằm ở gốc toạ độ, mỗi slot
 * gắn nguyên cả tấm 2304×1536 thay vì một ô, và ba animation `idle`/`blink`/
 * `walk` đều là object rỗng. Nên mốc ghép phải ĐO TỪ CHÍNH HÌNH lúc nhập art,
 * ghi vào atlas rồi dùng lại ở đây:
 *
 *   collar — miệng cổ áo trên mảnh trang phục: chỗ cắm đầu.
 *   cap    — khung sọ của mảnh đầu và mảnh tóc: đỉnh, hàng rộng nhất, tâm ngang.
 *   chin   — dòng cằm trên mảnh đầu (mảnh nam có sẵn khúc cổ nối xuống).
 *   tone   — tông da đo ngay trên mảnh đầu, để nhuộm tay chân trần cho khớp.
 *
 * Chỉ còn mấy tỉ lệ dưới đây là do mắt người chọn, vì art không có mốc nào nói
 * ra được: mắt đặt cao thấp cỡ nào trên khuôn mặt, đôi mắt rộng bằng mấy phần
 * cái đầu, và mái tóc trùm cao hơn đỉnh đầu bao nhiêu.
 */

/** Đôi mắt rộng bằng bao nhiêu phần bề ngang đầu. */
const EYE_SPAN = 0.66;

/** Tâm đôi mắt nằm ở đâu, tính từ đỉnh đầu xuống cằm. */
const EYE_Y = 0.58;

/** Mái tóc trùm cao hơn đỉnh đầu bao nhiêu, tính theo chiều cao mảnh đầu. */
const HAIR_LIFT = 0.3;

/** Chân đầu lún vào cổ áo bao nhiêu, tính theo chiều cao mảnh đầu. */
const NECK_SINK = 0.075;

/**
 * Chỗ cắm CÁNH TAY và cỡ vẽ nó, theo giới.
 *
 * Cánh tay cắt từ tấm sườn cơ thể, còn thân thì cắt từ tấm trang phục — hai tấm
 * vẽ ở hai cỡ khác nhau (cùng một nhân vật, nhưng cái đầu trên tấm sườn to hơn
 * cái đầu trên tấm da tới một phần năm) và KHÔNG có mốc nào chung để quy đổi.
 * Nên ba số này phải ướm bằng mắt, giống EYE_SPAN và HAIR_LIFT.
 *
 * `dx`, `dy` là chỗ cắm so với miệng cổ áo, tính theo chiều cao mảnh trang phục
 * chứ không phải pixel: mọi bộ đồ đều vẽ trên cùng một thân người, nên buộc vào
 * chiều cao thân thì thay bảng art vẫn còn đúng.
 */
const ARM = {
  m: { fit: 0.86, dx: 0.102, dy: 0.121 },
  f: { fit: 0.82, dx: 0.085, dy: 0.124 },
};

/**
 * Màu mắt — mỗi màu là một mảnh art riêng, không phải nhuộm lại.
 *
 * Thứ tự đúng theo thứ tự cột trên tấm gốc, nên `eyes: 2` là mảnh `eyes_?_03`.
 */
export const EYE_COLOURS = [
  { id: 'nau', label: 'Nâu' },
  { id: 'xanh_duong', label: 'Xanh dương' },
  { id: 'xanh_la', label: 'Xanh lá' },
  { id: 'ho_phach', label: 'Hổ phách' },
  { id: 'tim', label: 'Tím' },
];

/** Số tông da trên tấm gốc. Mỗi tông là một mảnh đầu vẽ sẵn. */
export const SKIN_COUNT = 5;

function clampIndex(value, count) {
  const n = Number(value) || 0;
  return n >= 0 && n < count ? Math.floor(n) : 0;
}

const num = (i) => String(i + 1).padStart(2, '0');

/** Tên mảnh đầu ứng với giới và tông da. */
export const headName = (sex, skin) => `head_${sex}_${num(clampIndex(skin, SKIN_COUNT))}`;

/** Tên mảnh mắt ứng với giới và màu mắt. */
export const eyesName = (sex, eyes) => `eyes_${sex}_${num(clampIndex(eyes, EYE_COLOURS.length))}`;

/**
 * Mã màu của từng tông da, đọc từ atlas.
 *
 * Đọc chứ không chép: tông da là màu THẬT của mảnh đầu, đo lúc nhập art. Chép
 * tay vào đây thì thay bảng art là mảng da tay lệch màu với mặt mà không ai hay.
 */
export function skinTones(atlas, gender) {
  const sex = gender === 'f' ? 'f' : 'm';
  const index = atlas.meta?.sprites?.index ?? {};
  return Array.from({ length: SKIN_COUNT }, (_, i) => index[headName(sex, i)]?.tone ?? '#f0c8a8');
}

const tintCache = new Map();

/**
 * Bản sao của một mảnh art đã đổi tông da.
 *
 * Nhân theo TỈ LỆ giữa tông đích và tông gốc, không tô đè: mảng sáng tối vẽ sẵn
 * trên cánh tay giữ nguyên, chỉ nước da đổi. Tô đè một màu phẳng là mất hết khối.
 */
function reskinned(part, fromHex, toHex) {
  const { rect } = part;
  const key = `${rect.page}:${rect.x}:${rect.y}:${fromHex}>${toHex}`;
  const hit = tintCache.get(key);
  if (hit) return hit;

  const canvas = document.createElement('canvas');
  canvas.width = rect.w;
  canvas.height = rect.h;
  const ctx = canvas.getContext('2d', { willReadFrequently: true });
  ctx.drawImage(part.img, rect.x, rect.y, rect.w, rect.h, 0, 0, rect.w, rect.h);
  const hex = (v) => [1, 3, 5].map((i) => parseInt(v.slice(i, i + 2), 16));
  const from = hex(fromHex);
  const to = hex(toHex);
  const ratio = to.map((c, i) => c / Math.max(1, from[i]));
  const px = ctx.getImageData(0, 0, rect.w, rect.h);
  const d = px.data;
  for (let i = 0; i < d.length; i += 4) {
    if (!d[i + 3]) continue;
    for (let c = 0; c < 3; c++) d[i + c] = Math.min(255, Math.round(d[i + c] * ratio[c]));
  }
  ctx.putImageData(px, 0, 0);
  tintCache.set(key, canvas);
  return canvas;
}

/**
 * Mảnh da trần của bộ đồ, đã nhuộm sang tông da đang chọn.
 *
 * Mảnh này trên atlas là một vệt TRẮNG đúng hình cánh tay và bắp chân để trần —
 * chỗ mà trên tấm gốc chỉ có nét viền, ruột là ô caro. Nhân trắng với tông da là
 * ra đúng tông, nên một bộ đồ hợp cả năm tông mà không phải nhập năm bản.
 */
function tinted(part, hex) {
  const { rect } = part;
  const key = `${rect.page}:${rect.x}:${rect.y}:${hex}`;
  const hit = tintCache.get(key);
  if (hit) return hit;

  const canvas = document.createElement('canvas');
  canvas.width = rect.w;
  canvas.height = rect.h;
  const ctx = canvas.getContext('2d');
  ctx.drawImage(part.img, rect.x, rect.y, rect.w, rect.h, 0, 0, rect.w, rect.h);
  ctx.globalCompositeOperation = 'source-in';
  ctx.fillStyle = hex;
  ctx.fillRect(0, 0, rect.w, rect.h);
  tintCache.set(key, canvas);
  return canvas;
}

/**
 * Các mảnh của một bộ ngoại hình, hoặc null nếu art chưa tới nơi.
 * Thiếu một mảnh là bỏ vẽ cả bộ: vẽ nửa vời ra cái thân không đầu.
 */
export function lookParts(atlas, look) {
  if (!look) return null;
  const sex = look.gender === 'f' ? 'f' : 'm';
  const outfit = atlas.part(look.outfit);
  const head = atlas.part(headName(sex, look.skin));
  const eyes = atlas.part(eyesName(sex, look.eyes));
  const hair = look.hair ? atlas.part(look.hair) : null;
  if (!outfit || !head || !eyes) return null;
  if (look.hair && !hair) return null;
  // Mảnh da trần chỉ có ở bộ đồ nào hở tay hở chân, nên vắng cũng không sao.
  const limbs = atlas.part(`${look.outfit}_limbs`) ?? null;
  // Cánh tay nối sẵn từ tấm sườn cơ thể, vẽ lót dưới bộ đồ: tấm trang phục là
  // người CỤT TAY (mấy bộ nữ còn không có cả nét tay), nên tay phải lấy từ sườn.
  const arms = ['l', 'r'].map((side) => atlas.part(`arm_${sex}_${side}`));
  return { sex, outfit, head, eyes, hair, limbs, arms: arms.every(Boolean) ? arms : null };
}

/** Chiều cao tự nhiên của bộ ngoại hình, theo đơn vị của mảnh art. */
function naturalHeight({ outfit, head, hair }) {
  const sink = head.rect.h * NECK_SINK;
  const lift = hair ? head.rect.h * HAIR_LIFT : 0;
  return outfit.rect.h - sink + head.rect.h + lift;
}

/**
 * Các mốc dựng hình: tỉ lệ vẽ, mép trên mảnh trang phục, đỉnh và chân đầu.
 *
 * Tách ra để chỗ khác đo lại được — bài kiểm tra dò lỗ hở ở khúc cổ cần biết
 * chính xác chân đầu nằm ở đâu, mà đoán lại công thức thì hai bên lệch nhau lúc
 * nào không hay.
 */
export function lookLayout(atlas, look, { groundY, height }) {
  const parts = lookParts(atlas, look);
  if (!parts) return null;
  const { outfit, head, hair } = parts;
  const s = height / naturalHeight(parts);
  const bodyTop = groundY - outfit.rect.h * s;
  const headBottom = bodyTop + head.rect.h * NECK_SINK * s;
  const headTop = headBottom - head.rect.h * s;
  return {
    s,
    bodyTop,
    headTop,
    headBottom,
    hairTop: hair ? headTop - head.rect.h * HAIR_LIFT * s : headTop,
    parts,
  };
}

/**
 * Vẽ nhân vật ghép, neo ĐÁY GIỮA tại (x, groundY), cao đúng `height`.
 * @returns true nếu vẽ được, false nếu art chưa sẵn sàng.
 */
export function drawLook(ctx, atlas, look, { x, groundY, height }) {
  const layout = lookLayout(atlas, look, { groundY, height });
  if (!layout) return false;
  const { s, bodyTop, headTop, parts } = layout;
  const { sex, outfit, head, eyes, hair, limbs, arms } = parts;

  const put = (part, dx, dy, scale = s, img = part.img, sx = part.rect.x, sy = part.rect.y) => {
    ctx.drawImage(img, sx, sy, part.rect.w, part.rect.h,
      dx, dy, part.rect.w * scale, part.rect.h * scale);
  };

  // Trục dọc của người là miệng cổ áo, không phải giữa mảnh trang phục: mấy bộ
  // có túi đeo chéo hay tay áo thùng thình lệch hẳn khung bao sang một bên.
  const bodyX = x - outfit.rect.collar.x * s;

  // Tay vẽ TRƯỚC bộ đồ: ống tay áo che phần nào thì che, thò ra bao nhiêu là do
  // chính bộ đồ quyết định — áo dài tay chỉ hở bàn tay, váy hai dây thì hở cả tay.
  if (arms) {
    const fit = ARM[sex].fit * s;
    const shoulderY = bodyTop + ARM[sex].dy * outfit.rect.h * s;
    const shoulderX = ARM[sex].dx * outfit.rect.h * s;
    arms.forEach((arm, i) => {
      const img = reskinned(arm, arm.rect.tone ?? '#f0c8a8', head.rect.tone ?? '#f0c8a8');
      const side = i === 0 ? -1 : 1;
      put(arm, x + side * shoulderX - arm.rect.socket.x * fit,
        shoulderY - arm.rect.socket.y * fit, fit, img, 0, 0);
    });
  }
  if (limbs) put(limbs, bodyX, bodyTop, s, tinted(limbs, head.rect.tone ?? '#f0c8a8'), 0, 0);
  put(outfit, bodyX, bodyTop);
  put(head, x - head.rect.cap.cx * s, headTop);

  // Đôi mắt là MỘT mảnh gồm cả hai mắt nên khoảng cách giữa chúng giữ nguyên;
  // ở đây chỉ quy bề ngang cả đôi về một phần bề ngang đầu.
  const eyeS = (EYE_SPAN * head.rect.cap.w * s) / eyes.rect.w;
  const eyeCy = headTop + EYE_Y * (head.rect.chin ?? head.rect.h) * s;
  put(eyes, x - (eyes.rect.w * eyeS) / 2, eyeCy - (eyes.rect.h * eyeS) / 2, eyeS);

  if (hair) put(hair, x - hair.rect.cap.cx * s, layout.hairTop);
  return true;
}

/** Tên các lựa chọn có thật trong atlas, theo giới. Đọc từ atlas chứ không
 *  chép tay: thêm kiểu tóc vào bảng art là màn tạo nhân vật có thêm lựa chọn. */
export function lookOptions(atlas, gender) {
  const index = atlas.meta?.sprites?.index ?? {};
  const pick = (prefix) => Object.keys(index)
    .filter((n) => n.startsWith(`${prefix}_${gender}_`) && !n.endsWith('_limbs'))
    .sort();
  return { hair: pick('hair'), outfit: pick('outfit') };
}

/** Bộ ngoại hình mở màn: mảnh đầu tiên của mỗi loại, da sáng nhất, mắt nâu. */
export function defaultLook(atlas, gender) {
  const options = lookOptions(atlas, gender);
  return { gender, hair: options.hair[0], outfit: options.outfit[0], skin: 0, eyes: 0 };
}

/** Bộ ngoại hình ngẫu nhiên — nút xúc xắc ở màn tạo nhân vật. */
export function randomLook(atlas, gender) {
  const options = lookOptions(atlas, gender);
  const any = (list) => list[Math.floor(Math.random() * list.length)];
  return {
    gender,
    hair: any(options.hair),
    outfit: any(options.outfit),
    skin: Math.floor(Math.random() * SKIN_COUNT),
    eyes: Math.floor(Math.random() * EYE_COLOURS.length),
  };
}

/**
 * Vẽ MỘT lựa chọn vừa khít trong khung, dùng cho ô chọn.
 *
 * Tóc, mắt và tông da đều là thứ đội lên hoặc vẽ lên một cái đầu, nên ô chọn
 * dựng nguyên cái đầu ấy chứ không bày mảnh rời — và dựng bằng ĐÚNG phép căn
 * như lúc ghép người, để cái nhìn thấy ở ô chọn đúng là cái sẽ hiện ra.
 */
export function drawThumb(ctx, atlas, name, { x, y, w, h, look = null }) {
  const part = atlas.part(name);
  if (!part) return false;
  const kind = name.split('_')[0];
  const sex = look?.gender === 'f' ? 'f' : 'm';

  if (kind === 'outfit') {
    const s = Math.min(w / part.rect.w, h / part.rect.h);
    const dx = x + (w - part.rect.w * s) / 2;
    const dy = y + (h - part.rect.h * s) / 2;
    const head = atlas.part(headName(sex, look?.skin ?? 0));
    const tone = head?.rect.tone ?? '#f0c8a8';
    // Cùng thứ tự lớp như lúc ghép người, để ô chọn cho thấy đúng cái sẽ hiện ra.
    const cx = dx + part.rect.collar.x * s;
    for (const [i, side] of ['l', 'r'].entries()) {
      const arm = atlas.part(`arm_${sex}_${side}`);
      if (!arm) continue;
      const fit = ARM[sex].fit * s;
      const img = reskinned(arm, arm.rect.tone ?? '#f0c8a8', tone);
      const sx = cx + (i === 0 ? -1 : 1) * ARM[sex].dx * part.rect.h * s;
      ctx.drawImage(img, 0, 0, arm.rect.w, arm.rect.h,
        sx - arm.rect.socket.x * fit, dy + ARM[sex].dy * part.rect.h * s - arm.rect.socket.y * fit,
        arm.rect.w * fit, arm.rect.h * fit);
    }
    const limbs = atlas.part(`${name}_limbs`);
    if (limbs) {
      const canvas = tinted(limbs, tone);
      ctx.drawImage(canvas, 0, 0, limbs.rect.w, limbs.rect.h,
        dx, dy, limbs.rect.w * s, limbs.rect.h * s);
    }
    ctx.drawImage(part.img, part.rect.x, part.rect.y, part.rect.w, part.rect.h,
      dx, dy, part.rect.w * s, part.rect.h * s);
    return true;
  }

  const skin = kind === 'head' ? Number(name.split('_')[2]) - 1 : (look?.skin ?? 0);
  const head = kind === 'head' ? part : atlas.part(headName(sex, skin));
  const eyes = kind === 'eyes' ? part : atlas.part(eyesName(sex, look?.eyes ?? 0));
  if (!head || !eyes) return false;
  const hair = kind === 'hair' ? part : (look?.hair ? atlas.part(look.hair) : null);

  // Cao bằng đầu cộng phần tóc trùm lên trên, để ô nào cũng cùng một khuôn.
  const lift = hair ? head.rect.h * HAIR_LIFT : 0;
  const wide = Math.max(head.rect.w, hair?.rect.w ?? 0);
  const s = Math.min(w / wide, h / (head.rect.h + lift));
  const cx = x + w / 2;
  const headTop = y + (h - (head.rect.h + lift) * s) / 2 + lift * s;

  ctx.drawImage(head.img, head.rect.x, head.rect.y, head.rect.w, head.rect.h,
    cx - head.rect.cap.cx * s, headTop, head.rect.w * s, head.rect.h * s);
  const eyeS = (EYE_SPAN * head.rect.cap.w * s) / eyes.rect.w;
  const eyeCy = headTop + EYE_Y * (head.rect.chin ?? head.rect.h) * s;
  ctx.drawImage(eyes.img, eyes.rect.x, eyes.rect.y, eyes.rect.w, eyes.rect.h,
    cx - (eyes.rect.w * eyeS) / 2, eyeCy - (eyes.rect.h * eyeS) / 2,
    eyes.rect.w * eyeS, eyes.rect.h * eyeS);
  if (hair) {
    ctx.drawImage(hair.img, hair.rect.x, hair.rect.y, hair.rect.w, hair.rect.h,
      cx - hair.rect.cap.cx * s, headTop - lift * s, hair.rect.w * s, hair.rect.h * s);
  }
  return true;
}
