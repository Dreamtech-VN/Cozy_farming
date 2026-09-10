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

/** Thu/phóng về ĐÚNG một cỡ, hai chiều hai tỉ lệ riêng. */
function resizeTo({ w, h, data }, nw, nh) {
  const out = new Uint8Array(nw * nh * 4);
  for (let y = 0; y < nh; y++) {
    const y0 = Math.floor((y * h) / nh);
    const y1 = Math.max(y0 + 1, Math.floor(((y + 1) * h) / nh));
    for (let x = 0; x < nw; x++) {
      const x0 = Math.floor((x * w) / nw);
      const x1 = Math.max(x0 + 1, Math.floor(((x + 1) * w) / nw));
      let r = 0, g = 0, b = 0, a = 0, n = 0;
      for (let sy = y0; sy < y1; sy++) {
        for (let sx = x0; sx < x1; sx++) {
          const i = (sy * w + sx) * 4;
          const k = data[i + 3] / 255;
          r += data[i] * k; g += data[i + 1] * k; b += data[i + 2] * k; a += data[i + 3];
          n++;
        }
      }
      const alpha = a / n;
      const j = (y * nw + x) * 4;
      const un = alpha > 0 ? (255 * n) / a : 0;
      out[j] = Math.round((r / n) * un) || 0;
      out[j + 1] = Math.round((g / n) * un) || 0;
      out[j + 2] = Math.round((b / n) * un) || 0;
      out[j + 3] = Math.round(alpha);
    }
  }
  return { w: nw, h: nh, data: out };
}

/**
 * Một ô tileset hoàn chỉnh: cắt ruột phiến, khâu mép, thu về đúng cỡ ô.
 *
 * `seam` khai KHÂU MÉP NÀO. Ô đất, ô đá, ô nước lát kín cả mảng nên phải liền
 * cả bốn phía ('xy'). Ô mặt cỏ và ô viền đường chỉ liền hai bên ('x'): trên là
 * ngọn cỏ, dưới là đất, khâu dọc là ngọn cỏ mọc ngược lên từ đáy ô.
 *
 * Sau khi khâu thì THU cả tấm về cỡ ô, tuyệt đối không cắt bớt: cắt là đứt đúng
 * chỗ vừa khâu, lát ra hở khe. Nên `rect` phải gần vuông — thu một dải 162×40
 * về ô vuông thì viên đá bẹp đi bốn lần.
 */
export function makeTile(sheet, { rect, seam = 'xy', blend = 10, repeat = 1 }, size) {
  const aspect = rect[2] / rect[3];
  if (aspect < 0.6 || aspect > 1.7) {
    throw new Error(`khung tile ${rect.join(',')} quá dẹt (${aspect.toFixed(2)}): phải gần vuông, `
      + 'vì thu về ô vuông là kéo méo hoa văn mà cắt bớt là đứt chỗ khâu mép');
  }
  let tile = cropTile(sheet, rect);
  if (seam.includes('x')) tile = wrapSeam(tile, 'x', blend);
  if (seam.includes('y')) tile = wrapSeam(tile, 'y', blend);
  // `repeat` nhồi hoa văn mấy lần vào MỘT ô rồi mới thu nhỏ, nên viên đá bé đi
  // đúng chừng ấy lần. Cần vì cỡ ô trên màn hình là con số chung cho cả bảng:
  // hoa văn nào vẽ to quá thì lát ra nhìn thành bức tường đá tảng chứ không ra
  // mặt đường. Chỉ nhồi được SAU khi đã khâu — chưa khâu mà nhồi là nhân bản
  // luôn cả đường nối.
  if (repeat > 1) {
    const rw = tile.w * repeat, rh = tile.h * repeat;
    const big = new Uint8Array(rw * rh * 4);
    for (let y = 0; y < rh; y++) {
      const src = (y % tile.h) * tile.w * 4;
      for (let r = 0; r < repeat; r++) big.set(tile.data.subarray(src, src + tile.w * 4), (y * rw + r * tile.w) * 4);
    }
    tile = { w: rw, h: rh, data: big };
  }
  return resizeTo(tile, size, size);
}

/**
 * Gỡ lớp phủ mờ khỏi mấy khung nét đứt trên tranh nền.
 *
 * Bộ art chừa chỗ đặt công trình bằng khung nét đứt trắng, bên trong tô một lớp
 * phủ mờ. Nhìn thì tưởng hình bên dưới mất rồi, nên phép chữa đầu tiên là chép
 * một khúc khác đè lên — mà tranh này VẼ TAY, khúc nào cũng khác khúc nào, chép
 * sang là nhân đôi gốc cây với gãy nhịp hàng rào, đúng kiểu "lòi lem".
 *
 * Thật ra lớp phủ chỉ là một phép trộn tuyến tính: v = gốc·(1−a) + mực·a. Biết
 * `a` với `mực` là giải ngược ra gốc, hàng rào và bụi cây hiện lại nguyên chỗ
 * cũ, khỏi chép của ai.
 *
 * Đo `a` với `mực` bằng dải NỀN LÁT: nó chạy liền từ trong khung xuống dưới đáy
 * khung, nên cùng một thứ mà một nửa bị phủ một nửa không — hai đầu của đúng
 * một phép trộn. Ba khung đo ra gần như y hệt nhau nên con số là chắc.
 *
 * Lớp phủ không dừng gọn ở khung: nó nhoè ra ngoài chừng chục pixel. Gỡ phẳng
 * một mực trong khung rồi thôi là để lại đúng cái quầng ấy — nhìn vẫn ra hình
 * chữ nhật. Nên `feather` khai bề rộng vệt nhoè, và độ đậm lớp phủ dốc dần về 0
 * qua vệt ấy, gỡ tới đâu vừa tới đó.
 *
 * `edge` là bề dày nét đứt. Nét vẽ đè lên trên nên gỡ phủ không cứu được, phải
 * trám lại: nội suy ngang/dọc qua vài pixel, mắt không bắt được.
 */
export function liftVeil(img, [x0, y0, x1, y1], { alpha, ink, edge = 2, feather = 0 }) {
  const { width: W, data } = img;
  // `alpha` khai riêng cho từng kênh. Lớp phủ thật thì một mực một độ đậm, mà
  // đo ra ba số khác nhau — vì hai mốc dùng để đo (nền lát, hàng cây) không
  // phải cùng một vật tuyệt đối. Lấy đúng ba số đo được vẫn hơn ép về một số
  // trung bình: ép thì kênh lam thiếu lực, trong khung còn vương quầng xanh.
  const A = Array.isArray(alpha) ? alpha : [alpha, alpha, alpha];
  const ramp = (d) => (feather < 1 ? 1 : Math.max(0, Math.min(1, (d + feather + 0.5) / feather)));
  for (let y = y0 - feather; y <= y1 + feather; y++) {
    const wy = ramp(Math.min(y - y0, y1 - y));
    for (let x = x0 - feather; x <= x1 + feather; x++) {
      const w = Math.min(wy, ramp(Math.min(x - x0, x1 - x)));
      if (w <= 0) continue;
      const i = (y * W + x) * 4;
      for (let c = 0; c < 3; c++) {
        const a = A[c] * w;
        data[i + c] = Math.max(0, Math.min(255, Math.round((data[i + c] - ink[c] * a) / (1 - a))));
      }
    }
  }
  const lerp = (di, ai, bi, t) => {
    for (let c = 0; c < 3; c++) data[di + c] = Math.round(data[ai + c] * (1 - t) + data[bi + c] * t);
  };
  for (let x = x0 - edge; x <= x1 + edge; x++) {
    for (const [a, b] of [[y0 - 1, y0 + edge], [y1 - edge, y1 + 1]]) {
      for (let y = a + 1; y < b; y++) lerp((y * W + x) * 4, (a * W + x) * 4, (b * W + x) * 4, (y - a) / (b - a));
    }
  }
  for (let y = y0 - edge; y <= y1 + edge; y++) {
    for (const [a, b] of [[x0 - 1, x0 + edge], [x1 - edge, x1 + 1]]) {
      for (let x = a + 1; x < b; x++) lerp((y * W + x) * 4, (y * W + a) * 4, (y * W + b) * 4, (x - a) / (b - a));
    }
  }
}
