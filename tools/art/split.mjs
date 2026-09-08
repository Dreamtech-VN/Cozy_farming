/**
 * Cắt một tấm ảnh gộp thành từng vật rời, nền trong suốt.
 *
 * Loang nền từ VIỀN ảnh vào nên mảng màu trùng nền nhưng nằm TRONG vật vẫn giữ
 * nguyên — cắt theo lưới cố định thì sai ngay vì ảnh sinh bằng model không bao
 * giờ đều ô.
 */

/** @returns mảng {w, h, x, y, data} theo thứ tự đọc: trên xuống, trái sang phải. */
export function splitSheet(img, options = {}) {
  const { width: W, height: H, data } = img;
    const { tol: TOL = 22, minArea: MIN_AREA = 400, gap: GAP = 10 } = options;

  // Màu nền lấy từ trung vị viền ảnh, không lấy một pixel góc: model hay để
  // nền chuyển màu nhè nhẹ nên một mẫu đơn lẻ dễ lệch.
  const border = [];
  for (let x = 0; x < W; x += 4) { border.push([x, 0], [x, H - 1]); }
  for (let y = 0; y < H; y += 4) { border.push([0, y], [W - 1, y]); }
  const med = (arr) => arr.sort((a, b) => a - b)[arr.length >> 1];
  const bg = [0, 1, 2].map((c) => med(border.map(([x, y]) => data[(y * W + x) * 4 + c])));

  const near = (p) => {
    const dr = data[p] - bg[0], dg = data[p + 1] - bg[1], db = data[p + 2] - bg[2];
    return Math.sqrt(dr * dr + dg * dg + db * db) <= TOL;
  };

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
  let merged = boxes.filter((b) => b.area >= MIN_AREA);
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
        // Mép khử răng cưa: pixel càng gần màu nền thì càng trong, nếu không
        // vật sẽ có viền lởm chởm màu nền cũ khi đặt lên nền khác.
        const dr = data[p] - bg[0], dg = data[p + 1] - bg[1], db = data[p + 2] - bg[2];
        const dist = Math.sqrt(dr * dr + dg * dg + db * db);
        const alpha = dist >= TOL * 2 ? 255 : Math.round((dist / (TOL * 2)) * 255);
        out.set([data[p], data[p + 1], data[p + 2], alpha], (y * w + x) * 4);
      }
    }
    return { w, h, x: b.x0, y: b.y0, data: out };
  });
}
