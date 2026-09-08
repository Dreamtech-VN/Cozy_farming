/** Thu nhỏ ảnh RGBA. Dùng chung cho khâu nhập sprite và khâu chuẩn bị nền giao diện. */
/**
 * Thu nhỏ sprite bằng trung bình vùng (box filter).
 *
 * Ảnh nhân vật cao 1024px trong khi game vẽ ra 96px — giữ nguyên là phí chỗ
 * trong atlas gấp cả trăm lần diện tích. Lấy trung bình cả vùng chứ không lấy
 * mẫu điểm: lấy mẫu điểm ở tỉ lệ thu nhỏ lớn sẽ làm nét mảnh (sợi tóc, viền)
 * biến mất chỗ có chỗ không.
 */
export function downscale({ w, h, data }, factor) {
  const nw = Math.max(1, Math.round(w / factor));
  const nh = Math.max(1, Math.round(h / factor));
  const out = new Uint8Array(nw * nh * 4);
  for (let y = 0; y < nh; y++) {
    const y0 = Math.floor(y * h / nh); const y1 = Math.max(y0 + 1, Math.floor((y + 1) * h / nh));
    for (let x = 0; x < nw; x++) {
      const x0 = Math.floor(x * w / nw); const x1 = Math.max(x0 + 1, Math.floor((x + 1) * w / nw));
      let r = 0, g = 0, bl = 0, a = 0, n = 0;
      for (let sy = y0; sy < y1; sy++) {
        for (let sx = x0; sx < x1; sx++) {
          const i = (sy * w + sx) * 4;
          const av = data[i + 3] / 255;
          // Nhân trước với alpha rồi mới trung bình: không thì màu của vùng
          // trong suốt (thường là đen) rỉ ra thành viền tối quanh dáng.
          r += data[i] * av; g += data[i + 1] * av; bl += data[i + 2] * av; a += data[i + 3];
          n++;
        }
      }
      const alpha = a / n;
      const j = (y * nw + x) * 4;
      const un = alpha > 0 ? (n * 255) / (a || 1) : 0;
      out[j] = Math.round(r * un / n * (alpha / 255) || 0);
      out[j + 1] = Math.round(g * un / n * (alpha / 255) || 0);
      out[j + 2] = Math.round(bl * un / n * (alpha / 255) || 0);
      out[j + 3] = Math.round(alpha);
    }
  }
  return { w: nw, h: nh, data: out };
}
