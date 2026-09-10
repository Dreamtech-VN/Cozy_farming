/**
 * Sửa những mảnh art vốn KHÔNG vẽ để làm sprite rời.
 *
 * Vài vật trong bộ art được vẽ như một khúc cảnh chứ không phải một món đồ: nó
 * có sẵn nền lát dưới chân, có mảng kính tô đặc như tường. Cắt ra dán lên map
 * thì thành một cái hộp nhờ nhờ đứng trên vỉa hè — nhìn là biết dán vào, dù màu
 * đã nắn đúng tông.
 *
 * Trạm xe buýt là ca nặng nhất, đo trên mảnh 275×147 cắt từ city.png:
 *
 *   - Đáy từ hàng 136 trở xuống là NỀN LÁT của tấm art: beige ấm (190,170,140),
 *     đục hẳn. Bốn chân trụ nằm xen trong đó ở x≈3-29, 82-91, 180-189, 243-269.
 *   - Ô kính giữa hai trụ trong (x 67-202) tô ĐẶC màu trắng lục nhạt. Kính mà
 *     không nhìn xuyên được thì không ra kính, thành mảng trắng.
 *   - Mảng nhạt bị phép tách nền ăn mòn loang lổ: cùng một mảng tường mà chỗ
 *     a=43, chỗ a=119, chỗ a=255. Lát lên map thì lỗ chỗ.
 *
 * Ba phép dưới đây chữa đúng ba chỗ ấy. Ngưỡng màu đo trên art GỐC nên phải
 * chạy TRƯỚC phép nắn tông.
 */

const lum = (r, g, b) => 0.299 * r + 0.587 * g + 0.114 * b;
const chroma = (r, g, b) => { const mx = Math.max(r, g, b); return mx ? (mx - Math.min(r, g, b)) / mx : 0; };

/**
 * Vá mảng bị ăn mòn: pixel nửa trong nằm LỌT GIỮA toàn pixel đục thì kéo về đục.
 *
 * Chỉ vá phần ruột. Viền ngoài cũng nửa trong nhưng đấy là khử răng cưa của
 * chính bức vẽ — kéo nốt nó về đục là silhouette răng cưa hết.
 */
export function solidify({ w, h, data }) {
  const a = (x, y) => data[(y * w + x) * 4 + 3];
  const fix = [];
  for (let y = 1; y < h - 1; y++) {
    for (let x = 1; x < w - 1; x++) {
      const cur = a(x, y);
      if (cur >= 205 || cur < 12) continue;
      if (a(x - 1, y) > 60 && a(x + 1, y) > 60 && a(x, y - 1) > 60 && a(x, y + 1) > 60) fix.push((y * w + x) * 4 + 3);
    }
  }
  for (const i of fix) data[i] = 255;
  return fix.length;
}

/** Ô kính: mọi pixel nhạt trong khung về ĐÚNG MỘT độ đục, để nhìn xuyên đều. */
export function glaze({ w, h, data }, [x0, y0, x1, y1], alpha, keepBright = 0) {
  let n = 0;
  for (let y = y0; y <= y1 && y < h; y++) {
    for (let x = x0; x <= x1 && x < w; x++) {
      const i = (y * w + x) * 4;
      if (data[i + 3] < 12) continue;
      const [r, g, b] = [data[i], data[i + 1], data[i + 2]];
      if (lum(r, g, b) < 145 || chroma(r, g, b) > 0.25) continue;
      data[i + 3] = keepBright && lum(r, g, b) > keepBright ? Math.min(255, Math.round(alpha * 1.5)) : alpha;
      n++;
    }
  }
  return n;
}

/**
 * Gỡ dải nền lát dính dưới chân: từ hàng `y0` xuống, xoá pixel SÁNG (nền lát)
 * và giữ pixel tối (chân trụ). Phân biệt bằng độ sáng chứ không bằng ô chữ nhật:
 * chân trụ nằm xen kẽ trong nền lát chứ không tách khối được.
 */
export function cutGround({ w, h, data }, y0, keepDarkerThan = 110) {
  let n = 0;
  for (let y = y0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      const i = (y * w + x) * 4;
      if (data[i + 3] < 12) continue;
      if (lum(data[i], data[i + 1], data[i + 2]) < keepDarkerThan) continue;
      data[i + 3] = 0;
      n++;
    }
  }
  return n;
}

/**
 * Chạy cả bộ phép theo khai báo trong <tấm>.names.json.
 *
 * Mọi phép ở đây đều đọc màu art GỐC nên phải chạy TRƯỚC khi nắn tông.
 *
 * Cố tình KHÔNG có bóng đổ. Vật trong tranh nền đều có bóng, nên đã thử vẽ thêm
 * một vệt ellipse mờ dưới chân — nhưng vệt mờ dán vào bộ art cạnh cứng thì ra
 * vết bẩn chứ không ra bóng, mà cắt xong cũng chẳng còn hàng trống nào dưới chân
 * trụ để vẽ. Bóng muốn có thì phải VẼ vào art, không sinh bằng code được.
 */
export function fixSprite(piece, spec) {
  // Toạ độ trong `glaze`/`cutGround` là toạ độ ĐO TRÊN MẢNH GỐC. Ai đó thêm
  // `scale` hay `maxHeight` cho tấm này là mảnh co lại mà mấy con số ở đây vẫn
  // giữ nguyên — ô kính trượt sang chỗ khác, lặng lẽ, không báo gì. Nên khai cỡ
  // mảnh ra và chặn ngay.
  if (spec.size && (piece.w !== spec.size[0] || piece.h !== spec.size[1])) {
    throw new Error(`sửa sprite: mảnh ${piece.w}×${piece.h} khác cỡ đã đo ${spec.size.join('×')} `
      + '— toạ độ ô kính đo trên mảnh gốc, mảnh đổi cỡ là phải đo lại');
  }
  if (spec.solidify) solidify(piece);
  for (const [x0, y0, x1, y1, alpha, keepBright] of spec.glaze ?? []) glaze(piece, [x0, y0, x1, y1], alpha, keepBright);
  if (spec.cutGround !== undefined) cutGround(piece, spec.cutGround);
}
