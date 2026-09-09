/**
 * Cắt một tấm ảnh gộp thành từng vật rời, nền trong suốt.
 *
 * Loang nền từ VIỀN ảnh vào nên mảng màu trùng nền nhưng nằm TRONG vật vẫn giữ
 * nguyên — cắt theo lưới cố định thì sai ngay vì ảnh sinh bằng model không bao
 * giờ đều ô.
 */

/**
 * Cắt theo LƯỚI THƯA: tìm dải trống ngang để chia hàng, rồi trong từng hàng tìm
 * khoảng trống dọc để chia cột.
 *
 * Dùng cho tấm mà các vật CHẠM NHAU — art nhân vật có quầng sáng mờ rộng, xếp
 * sát nhau nên gom cụm liên thông sẽ dính cả tấm thành một khối. Cắt theo dải
 * trống không cần vật rời nhau, chỉ cần có khe.
 */
/**
 * Xoá quầng mờ quanh sprite, giữ nguyên mép khử răng cưa.
 *
 * Art sinh bằng model hay có một lớp sương rất nhạt lan rộng ra ngoài dáng vật.
 * Trên nền phẳng của tấm gốc thì không thấy, nhưng đặt lên nền trời trong game
 * là hiện ra viền sáng hình chữ nhật. Mép thật nhảy vọt qua ngưỡng này chỉ
 * trong một hai pixel nên cắt ở đây không làm sứt dáng.
 */
function trimGlow(rgba, cut) {
  for (let i = 3; i < rgba.length; i += 4) {
    if (rgba[i] < cut) { rgba[i] = 0; continue; }
    if (rgba[i] >= 250) rgba[i] = 255;
  }
}

function sliceByGaps(img, { alphaCut, minRun, minSize, trim, noise }) {
  const { width: W, height: H, data } = img;
  // HAI ngưỡng cho hai việc khác nhau:
  //  - `alphaCut` cao, để TÌM KHE giữa các vật: quầng sáng mờ phải bị coi là
  //    trống, không thì mọi thứ dính vào nhau.
  //  - `boxCut` thấp, để ĐO KHUNG BAO của vật: mép tóc mềm có alpha thấp nhưng
  //    vẫn là hình. Đo khung bằng ngưỡng cao thì mép mềm nằm ngoài khung và bị
  //    xén cụt bằng một đường thẳng — đúng lỗi tóc mất góc.
  const boxCut = Math.max(1, trim || 24);
  const solidAt = (x, y) => data[(y * W + x) * 4 + 3] >= alphaCut;
  const visibleAt = (x, y) => data[(y * W + x) * 4 + 3] >= boxCut;

  const bands = (from, to, along, cross, isSolid) => {
    const out = [];
    let start = -1; let gap = 0;
    for (let i = from; i <= to; i++) {
      // Đếm chứ không hỏi "có hay không": vài pixel khử răng cưa của chỏm tóc
      // hay vành tai vẫn còn sót trong khe, chỉ cần một pixel là hai hàng dính
      // liền thành một. `noise` là số pixel còn coi như khe trống.
      let n = 0;
      for (let j = cross[0]; j <= cross[1] && n <= noise; j++) if (isSolid(i, j)) n++;
      if (n > noise) {
        if (start === -1) start = i;
        gap = 0;
      } else if (start !== -1) {
        gap++;
        // Chỉ cắt khi khe đủ rộng: khe hẹp là kẽ giữa hai chân, không phải
        // ranh giới giữa hai nhân vật.
        if (gap >= minRun) { out.push([start, i - gap]); start = -1; gap = 0; }
      }
    }
    if (start !== -1) out.push([start, to]);
    return out.filter(([a, b]) => b - a + 1 >= minSize);
  };

  const rows = bands(0, H - 1, 'y', [0, W - 1], (y, x) => solidAt(x, y));
  const cells = [];
  for (const [y0, y1] of rows) {
    for (const [x0, x1] of bands(0, W - 1, 'x', [y0, y1], (x, y) => solidAt(x, y))) {
      // Cắt sát nội dung thật trong ô, không giữ nguyên khung dải.
      // Nới khung ra ngoài dải một chút: mép mềm của vật thường tràn qua ranh
      // giới khe, mà khe đã đủ rộng nên không sợ ăn sang vật bên cạnh.
      const pad = Math.max(2, minRun);
      const sx0 = Math.max(0, x0 - pad), sx1 = Math.min(W - 1, x1 + pad);
      const sy0 = Math.max(0, y0 - pad), sy1 = Math.min(H - 1, y1 + pad);
      let ax = x1, ay = y1, bx = x0, by = y0;
      for (let y = sy0; y <= sy1; y++) for (let x = sx0; x <= sx1; x++) {
        if (!visibleAt(x, y)) continue;
        if (x < ax) ax = x; if (x > bx) bx = x;
        if (y < ay) ay = y; if (y > by) by = y;
      }
      if (bx < ax) continue;
      const w = bx - ax + 1; const h = by - ay + 1;
      const out = new Uint8Array(w * h * 4);
      for (let y = 0; y < h; y++) {
        const src = ((ay + y) * W + ax) * 4;
        out.set(data.subarray(src, src + w * 4), y * w * 4);
      }
      if (trim) trimGlow(out, trim);
      cells.push({ w, h, x: ax, y: ay, data: out });
    }
  }
  return cells;
}

/** @returns mảng {w, h, x, y, data} theo thứ tự đọc: trên xuống, trái sang phải. */
/**
 * Cắt theo LƯỚI ĐỀU rồi co khung về đúng nội dung từng ô.
 *
 * Dùng cho tấm bảng thành phần: tóc, mặt, trang phục bày thành hàng cột đều
 * tăm tắp. Với tấm kiểu đó, cắt theo khe là chọn nhầm việc — tóc dài của các
 * cô bé chạm nhau nên khe biến mất, mà nới ngưỡng nhiễu lên đủ để tách thì lại
 * ăn cụt chỏm tóc. Biết trước lưới thì chia thẳng theo lưới, chỉ còn việc co
 * khung cho sát hình.
 */
/**
 * Xoá những cụm pixel LẺ TẺ còn sót của nền.
 *
 * Phép thử nền "xám và sáng" bỏ lọt vài pixel ở mép ô caro — chúng hơi ngả màu
 * hoặc hơi tối hơn ngưỡng nên không bị loang tới. Nhìn thì chỉ là bụi, nhưng
 * chúng nằm TRONG khung bao nên khung cao thêm cả chục pixel, mà khung bao lại
 * là mốc căn đầu với thân: bụi ở trên đỉnh đầu là cả khuôn mặt tụt xuống.
 *
 * Ngưỡng để rất thấp: trên tấm này cụm rác lớn nhất là 9 pixel còn khuôn mặt là
 * 5162, nên không có gì để nhầm.
 */
function despeckle(data, W, H, minArea) {
  const label = new Int32Array(W * H).fill(-1);
  const queue = new Int32Array(W * H);
  for (let start = 0; start < W * H; start++) {
    if (label[start] >= 0 || data[start * 4 + 3] <= 40) continue;
    let qh = 0, qt = 0;
    queue[qt++] = start; label[start] = start;
    const cluster = [start];
    while (qh < qt) {
      const i = queue[qh++];
      const x = i % W, y = (i / W) | 0;
      for (let dy = -1; dy <= 1; dy++) for (let dx = -1; dx <= 1; dx++) {
        const nx = x + dx, ny = y + dy;
        if (nx < 0 || ny < 0 || nx >= W || ny >= H) continue;
        const j = ny * W + nx;
        if (label[j] >= 0 || data[j * 4 + 3] <= 40) continue;
        label[j] = start; queue[qt++] = j; cluster.push(j);
      }
    }
    if (cluster.length < minArea) for (const i of cluster) data[i * 4 + 3] = 0;
  }
}

function sliceByGrid(img, { rows, cols, trim, minArea }) {
  const { width: W, height: H, data } = img;
  const cut = Math.max(1, trim || 24);
  // Biên ô: một con số nghĩa là chia đều, một mảng nghĩa là biên đo sẵn.
  // Chia đều không phải lúc nào cũng đúng — các cột trên tấm gốc lệch nhau vài
  // chục pixel, chia đều là mép tóc của kiểu bên cạnh lọt vào ô này.
  const edges = (n, span) => (Array.isArray(n)
    ? n
    : Array.from({ length: n + 1 }, (_, i) => Math.round((i * span) / n)));
  const xs = edges(cols, W);
  const ys = edges(rows, H);
  const cells = [];
  for (let r = 0; r < ys.length - 1; r++) {
    for (let c = 0; c < xs.length - 1; c++) {
      const cx0 = xs[c], cx1 = xs[c + 1] - 1;
      const cy0 = ys[r], cy1 = ys[r + 1] - 1;
      const cw = cx1 - cx0 + 1, ch = cy1 - cy0 + 1;

      // Sao ô ra riêng rồi mới quét rác: quét trên cả khung thì mẩu vật bên
      // cạnh bị biên ô cắt còn một sợi vẫn thuộc về cụm lớn của nó, không bị
      // coi là rác, và cái sợi đó kéo khung bao của ô này rộng thêm cả chục
      // pixel — mặt lệch hẳn sang một bên khi ghép.
      const cell = new Uint8Array(cw * ch * 4);
      for (let y = 0; y < ch; y++) {
        const src = ((cy0 + y) * W + cx0) * 4;
        cell.set(data.subarray(src, src + cw * 4), y * cw * 4);
      }
      if (minArea) despeckle(cell, cw, ch, minArea);

      let ax = cw - 1, ay = ch - 1, bx = 0, by = 0;
      for (let y = 0; y < ch; y++) for (let x = 0; x < cw; x++) {
        if (cell[(y * cw + x) * 4 + 3] < cut) continue;
        if (x < ax) ax = x; if (x > bx) bx = x;
        if (y < ay) ay = y; if (y > by) by = y;
      }
      if (bx < ax) continue; // ô trống
      const w = bx - ax + 1, h = by - ay + 1;
      const out = new Uint8Array(w * h * 4);
      for (let y = 0; y < h; y++) {
        const src = ((ay + y) * cw + ax) * 4;
        out.set(cell.subarray(src, src + w * 4), y * w * 4);
      }
      if (trim) trimGlow(out, trim);
      cells.push({ w, h, x: cx0 + ax, y: cy0 + ay, data: out });
    }
  }
  return cells;
}

/**
 * Mặt nạ nền (1 = nền, loang từ viền ảnh vào) kèm cách suy alpha cho pixel
 * thuộc vật — hai thứ này phải đi cùng nhau vì cùng dựa trên một phép thử nền.
 *
 * Loang chứ không quét cả ảnh — mảng màu trùng nền nhưng nằm TRONG vật (áo
 * trắng, giày trắng) phải giữ nguyên, chỉ phần nối được ra tới viền mới là nền.
 */
function backgroundMask(img, options = {}) {
  const { width: W, height: H, data } = img;
  const {
    tol: TOL = 22, alpha: ALPHA = null,
    bgTest: BG_TEST = 'colour', lightSat: LIGHT_SAT = 14, lightMin: LIGHT_MIN = 196,
  } = options;

  // Ảnh đã có alpha thật thì cắt theo alpha, đừng đoán màu nền. Nhưng phải lấy
  // NGƯỠNG cao: art nhân vật có quầng sáng mờ rộng quanh người, cắt ở alpha > 0
  // là quầng của hai người cạnh nhau chạm nhau và dính thành một cụm.
  let hasAlpha = ALPHA !== null;
  if (ALPHA === null) {
    let clear = 0;
    for (let i = 3; i < data.length; i += 4) if (data[i] === 0) clear++;
    hasAlpha = clear > W * H * 0.05;
  }
  const alphaCut = ALPHA ?? 110;

  // Màu nền lấy từ trung vị viền ảnh, không lấy một pixel góc: model hay để
  // nền chuyển màu nhè nhẹ nên một mẫu đơn lẻ dễ lệch.
  const border = [];
  for (let x = 0; x < W; x += 4) { border.push([x, 0], [x, H - 1]); }
  for (let y = 0; y < H; y += 4) { border.push([0, y], [W - 1, y]); }
  const med = (arr) => arr.sort((a, b) => a - b)[arr.length >> 1];
  const bg = [0, 1, 2].map((c) => med(border.map(([x, y]) => data[(y * W + x) * 4 + c])));

  // Nền là ô caro xám nhạt, KHÔNG đồng màu: bốn góc tấm hero chênh nhau tới 60
  // nên một ngưỡng quanh một màu gốc không phủ nổi. Bắt theo tính chất thay vì
  // theo màu cụ thể: xám (bão hoà thấp) và sáng. Nhân vật có nét viền tối bao
  // quanh nên vùng trắng bên trong (áo, giày) không bị loang tới.
  const isLightGrey = (p) => {
    const r = data[p], g = data[p + 1], b = data[p + 2];
    const max = Math.max(r, g, b), min = Math.min(r, g, b);
    return max - min <= LIGHT_SAT && min >= LIGHT_MIN;
  };

  const near = (p) => (BG_TEST === 'light' ? isLightGrey(p) : hasAlpha
    ? data[p + 3] < alphaCut
    : Math.sqrt((data[p] - bg[0]) ** 2 + (data[p + 1] - bg[1]) ** 2 + (data[p + 2] - bg[2]) ** 2) <= TOL);

  // Loang nền từ viền. Dùng hàng đợi mảng phẳng thay vì đệ quy — 3,7 triệu pixel
  // sẽ làm tràn ngăn xếp.
  const isBg = new Uint8Array(W * H);
  const queue = new Int32Array(W * H);
  let qh = 0, qt = 0;
  const push = (x, y) => {
    if (x < 0 || y < 0 || x >= W || y >= H) return;
    const i = y * W + x;
    if (isBg[i] || !near(i * 4)) return;
    isBg[i] = 1; queue[qt++] = i;
  };
  for (let x = 0; x < W; x++) { push(x, 0); push(x, H - 1); }
  for (let y = 0; y < H; y++) { push(0, y); push(W - 1, y); }
  while (qh < qt) {
    const i = queue[qh++];
    const x = i % W, y = (i / W) | 0;
    push(x - 1, y); push(x + 1, y); push(x, y - 1); push(x, y + 1);
  }
  // QUẦNG SÁNG Ở MÉP.
  //
  // Loang nền dừng ở ngưỡng "xám và sáng", nên hàng pixel ngoài cùng của vật —
  // chỗ nét viền hoà với ô caro — vẫn được coi là vật và giữ nguyên màu nhợt
  // của nó. Trên nền kem thì không thấy gì, nhưng đặt nhân vật lên nền xanh
  // trong game là hiện ra một vòng sáng quanh mép, rõ nhất là dưới cằm.
  //
  // Cho những pixel SÁT NỀN mà nhạt màu và sáng như nền trong dần đi. Chỉ xét
  // pixel sát nền: áo trắng nằm bên trong tuy cũng sáng và nhạt màu nhưng
  // không đụng nền nên giữ nguyên.
  const rim = new Float32Array(W * H).fill(-1);
  if (BG_TEST === 'light') {
    for (let y = 0; y < H; y++) {
      for (let x = 0; x < W; x++) {
        const i = y * W + x;
        if (isBg[i]) continue;
        let touches = false;
        for (let dy = -1; dy <= 1 && !touches; dy++) for (let dx = -1; dx <= 1; dx++) {
          const nx = x + dx, ny = y + dy;
          if (nx < 0 || ny < 0 || nx >= W || ny >= H) continue;
          if (isBg[ny * W + nx]) { touches = true; break; }
        }
        if (!touches) continue;
        const p = i * 4;
        const mx = Math.max(data[p], data[p + 1], data[p + 2]);
        const mn = Math.min(data[p], data[p + 1], data[p + 2]);
        const dark = Math.min(1, Math.max(0, (LIGHT_MIN + 4 - mn) / 30));
        const colour = Math.min(1, Math.max(0, (mx - mn - LIGHT_SAT * 0.7) / 15));
        rim[i] = Math.max(dark, colour);
      }
    }
  }

  // Mép khử răng cưa: pixel càng gần màu nền thì càng trong, nếu không vật sẽ
  // có viền lởm chởm màu nền cũ khi đặt lên nền khác. Cắt theo alpha thì giữ
  // nguyên alpha gốc; cắt theo màu thì suy alpha từ khoảng cách màu.
  const alphaAt = (p) => {
    if (BG_TEST === 'light') {
      const edge = rim[p >> 2];
      return edge < 0 ? 255 : Math.round(255 * edge);
    }
    if (hasAlpha) return data[p + 3];
    const dist = Math.sqrt((data[p] - bg[0]) ** 2 + (data[p + 1] - bg[1]) ** 2 + (data[p + 2] - bg[2]) ** 2);
    return dist >= TOL * 2 ? 255 : Math.round((dist / (TOL * 2)) * 255);
  };
  return { isBg, alphaAt };
}

/**
 * Bản sao của ảnh với nền đã thành trong suốt, loang từ viền vào.
 *
 * Tách riêng vì hai chế độ cắt đều cần: chế độ khe làm việc trên alpha, mà tấm
 * nền caro vẽ chết thì alpha đâu mà tìm khe. Loang từ viền chứ không quét cả
 * ảnh: áo trắng và giày trắng cũng là "xám sáng", quét cả ảnh là thủng người.
 */
function withBackgroundCleared(img, options) {
  const { width: W, height: H } = img;
  const { isBg, alphaAt } = backgroundMask(img, options);
  const data = new Uint8Array(img.data);
  for (let i = 0; i < W * H; i++) data[i * 4 + 3] = isBg[i] ? 0 : alphaAt(i * 4);
  return { width: W, height: H, data };
}

export function splitSheet(img, options = {}) {
  if (options.mode === 'grid') {
    const src = options.bgTest ? withBackgroundCleared(img, options) : img;
    return sliceByGrid(src, {
      rows: options.rows ?? 1, cols: options.cols ?? 1,
      trim: options.trim ?? 0, minArea: options.minArea ?? 0,
    });
  }
  if (options.mode === 'gaps') {
    // Tấm không có alpha thật thì phải dựng alpha từ nền trước, không thì cả
    // tấm là một mảng đặc và không có khe nào để cắt.
    const src = options.bgTest ? withBackgroundCleared(img, options) : img;
    return sliceByGaps(src, {
      alphaCut: options.alpha ?? 110,
      minRun: options.minRun ?? 4,
      minSize: options.minSize ?? 24,
      trim: options.trim ?? 0,
      noise: options.noise ?? 0,
    });
  }
  const { width: W, height: H, data } = img;
  const { minArea: MIN_AREA = 400, gap: GAP = 10 } = options;
  const { isBg, alphaAt } = backgroundMask(img, options);
  const queue = new Int32Array(W * H);
  let qh = 0, qt = 0;

  // Gom cụm liên thông 8 hướng trên phần không phải nền.
  const label = new Int32Array(W * H).fill(-1);
  const boxes = [];
  for (let start = 0; start < W * H; start++) {
    if (isBg[start] || label[start] !== -1) continue;
    const id = boxes.length;
    let x0 = W, y0 = H, x1 = 0, y1 = 0, area = 0;
    qh = 0; qt = 0; queue[qt++] = start; label[start] = id;
    while (qh < qt) {
      const i = queue[qh++];
      const x = i % W, y = (i / W) | 0;
      area++;
      if (x < x0) x0 = x; if (x > x1) x1 = x;
      if (y < y0) y0 = y; if (y > y1) y1 = y;
      for (let dy = -1; dy <= 1; dy++) for (let dx = -1; dx <= 1; dx++) {
        const nx = x + dx, ny = y + dy;
        if (nx < 0 || ny < 0 || nx >= W || ny >= H) continue;
        const j = ny * W + nx;
        if (isBg[j] || label[j] !== -1) continue;
        label[j] = id; queue[qt++] = j;
      }
    }
    boxes.push({ x0, y0, x1, y1, area });
  }

  // Gộp cụm rời nhưng thuộc cùng một vật: biển hiệu treo, ống khói, bánh xe tách
  // khỏi thân. Chỉ gộp khi hai khung CHỒNG NHAU rõ trên một trục và sát nhau trên
  // trục kia — phần rời của cùng một vật gần như luôn nằm thẳng trên/dưới thân nó.
  // Gộp thuần theo khoảng cách thì hai chiếc xe đỗ cạnh nhau cũng dính làm một.
  const OVERLAP = 0.4;
  // Cụm nhỏ KHÔNG vứt thẳng: một chỏm tóc, một sợi tách rời hay cái nơ nối với
  // thân bằng vài pixel mờ đều thành cụm riêng bé tí. Vứt trước rồi mới gộp là
  // mất luôn phần đó, và vì khung bao co lại nên vật bị cắt PHẲNG một đường —
  // đúng lỗi đỉnh tóc bị xén. Gộp cụm nhỏ vào cụm lớn ở sát bên trước đã.
  let merged = boxes.filter((b) => b.area >= MIN_AREA);
  for (const bit of boxes.filter((b) => b.area < MIN_AREA)) {
    let host = -1; let bestGap = Infinity;
    for (let i = 0; i < merged.length; i++) {
      const a = merged[i];
      const gapX = Math.max(a.x0 - bit.x1, bit.x0 - a.x1, 0);
      const gapY = Math.max(a.y0 - bit.y1, bit.y0 - a.y1, 0);
      const gap = Math.max(gapX, gapY);
      if (gap <= GAP && gap < bestGap) { bestGap = gap; host = i; }
    }
    if (host === -1) continue; // hạt bụi thật, đứng một mình giữa nền
    const a = merged[host];
    merged[host] = {
      x0: Math.min(a.x0, bit.x0), y0: Math.min(a.y0, bit.y0),
      x1: Math.max(a.x1, bit.x1), y1: Math.max(a.y1, bit.y1),
      area: a.area + bit.area,
    };
  }
  let changed = true;
  while (changed) {
    changed = false;
    outer:
    for (let i = 0; i < merged.length; i++) {
      for (let j = i + 1; j < merged.length; j++) {
        const a = merged[i], b = merged[j];
        const gapX = Math.max(a.x0 - b.x1, b.x0 - a.x1);
        const gapY = Math.max(a.y0 - b.y1, b.y0 - a.y1);
        const overX = Math.min(a.x1, b.x1) - Math.max(a.x0, b.x0);
        const overY = Math.min(a.y1, b.y1) - Math.max(a.y0, b.y0);
        const minW = Math.min(a.x1 - a.x0, b.x1 - b.x0) + 1;
        const minH = Math.min(a.y1 - a.y0, b.y1 - b.y0) + 1;
        const stacked = overX >= minW * OVERLAP && gapY <= GAP && gapX < 0;
        const sideBySide = overY >= minH * OVERLAP && gapX <= 3 && gapY < 0;
        if (!stacked && !sideBySide) continue;
        merged[i] = {
          x0: Math.min(a.x0, b.x0), y0: Math.min(a.y0, b.y0),
          x1: Math.max(a.x1, b.x1), y1: Math.max(a.y1, b.y1),
          area: a.area + b.area,
        };
        merged.splice(j, 1);
        changed = true;
        break outer;
      }
    }
  }

  // Đọc theo thứ tự người nhìn: trên xuống dưới, trái sang phải. Gom thành hàng
  // trước rồi mới sắp trong hàng, chứ sắp thuần theo y thì vật thấp ở hàng trên
  // nhảy xuống lẫn với hàng dưới.
  merged.sort((a, b) => a.y0 - b.y0);
  const rows = [];
  for (const b of merged) {
    const row = rows.find((r) => b.y0 < r.yMax - (r.yMax - r.yMin) * 0.4);
    if (row) { row.items.push(b); row.yMax = Math.max(row.yMax, b.y1); }
    else rows.push({ yMin: b.y0, yMax: b.y1, items: [b] });
  }
  for (const r of rows) r.items.sort((a, b) => a.x0 - b.x0);
  const ordered = rows.flatMap((r) => r.items);


  return ordered.map((b) => {
    const w = b.x1 - b.x0 + 1;
    const h = b.y1 - b.y0 + 1;
    const out = new Uint8Array(w * h * 4);
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        const i = (b.y0 + y) * W + (b.x0 + x);
        if (isBg[i]) continue;
        const p = i * 4;
        out.set([data[p], data[p + 1], data[p + 2], alphaAt(p)], (y * w + x) * 4);
      }
    }
    return { w, h, x: b.x0, y: b.y0, data: out };
  });
}
