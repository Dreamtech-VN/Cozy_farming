/**
 * Cắt TILESET từ art vẽ sẵn.
 *
 * Khác sprite ở đúng một điểm, và điểm ấy quyết định mọi thứ: sprite chỉ cần
 * đẹp một mình, còn tile phải GHÉP LIỀN với chính nó ở cả bốn phía. Art trong
 * gói là những phiến đất rời, mỗi phiến có nét viền tối bao quanh — lát cạnh
 * nhau là hiện ra một hàng rào kẻ ô. Nên tile không cắt nguyên phiến mà lấy
 * RUỘT phiến rồi khâu mép cho liền.
 */
import { downscale } from './resize.mjs';

/**
 * Khâu mép cho ảnh lát được: hoà k cột cuối vào k cột đầu rồi cắt bỏ chúng đi.
 *
 * Sau phép này, cột cuối cùng nối liền với cột đầu tiên, nên lát bao nhiêu ô
 * cạnh nhau cũng không thấy đường nối. Hoà dần chứ không cắt ngang: cắt ngang
 * thì hết đường nối cũ nhưng lại sinh ra một mối gấp khúc mới ngay chỗ cắt.
 *
 * @param axis 'x' khâu hai mép trái/phải, 'y' khâu hai mép trên/dưới.
 */
export function wrapSeam({ w, h, data }, axis, k) {
  const span = axis === 'x' ? w : h;
  const cut = Math.min(k, Math.floor(span / 3));
  if (cut < 2) return { w, h, data };
  const nw = axis === 'x' ? w - cut : w;
  const nh = axis === 'y' ? h - cut : h;
  const out = new Uint8Array(nw * nh * 4);
  for (let y = 0; y < nh; y++) {
    for (let x = 0; x < nw; x++) {
      const i = (y * nw + x) * 4;
      const near = (y * w + x) * 4;                 // pixel gốc
      const far = axis === 'x'
        ? (y * w + (x + nw)) * 4                    // pixel bên kia mép
        : ((y + nh) * w + x) * 4;
      const t = axis === 'x' ? x : y;
      if (t >= cut) { out.set(data.subarray(near, near + 4), i); continue; }
      const a = t / cut;                            // 0 ở mép, 1 khi hết dải hoà
      for (let c = 0; c < 4; c++) out[i + c] = Math.round(data[near + c] * a + data[far + c] * (1 - a));
    }
  }
  return { w: nw, h: nh, data: out };
}

/** Cắt một khung khỏi tấm gốc. */
export function cropTile(img, [x0, y0, w, h]) {
  const data = new Uint8Array(w * h * 4);
  for (let y = 0; y < h; y++) {
    const src = ((y0 + y) * img.width + x0) * 4;
    data.set(img.data.subarray(src, src + w * 4), y * w * 4);
  }
  return { w, h, data };
}

/**
 * Một ô tileset hoàn chỉnh: cắt ruột phiến, khâu mép, thu về đúng cỡ ô.
 *
 * `seam` khai KHÂU MÉP NÀO. Ô đất, ô đá, ô nước lát kín cả mảng nên phải liền
 * cả bốn phía ('xy'). Ô mặt cỏ thì chỉ liền hai bên ('x'): trên là ngọn cỏ,
 * dưới là đất, khâu dọc là ngọn cỏ mọc ngược lên từ dưới đáy ô.
 */
export function makeTile(sheet, { rect, seam = 'xy', blend = 10 }, size) {
  let tile = cropTile(sheet, rect);
  if (seam.includes('x')) tile = wrapSeam(tile, 'x', blend);
  if (seam.includes('y')) tile = wrapSeam(tile, 'y', blend);
  // Ô vuông: nguồn hiếm khi vuông sẵn, mà thu hai chiều theo hai tỉ lệ khác
  // nhau thì hoa văn bị kéo méo — thu theo chiều DÀI hơn rồi cắt phần thừa.
  const factor = Math.min(tile.w, tile.h) / size;
  const small = downscale(tile, factor);
  const out = new Uint8Array(size * size * 4);
  const ox = Math.floor((small.w - size) / 2);
  const oy = Math.floor((small.h - size) / 2);
  for (let y = 0; y < size; y++) {
    const src = ((oy + y) * small.w + ox) * 4;
    out.set(small.data.subarray(src, src + size * 4), y * size * 4);
  }
  return { w: size, h: size, data: out };
}
