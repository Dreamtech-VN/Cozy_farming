/**
 * Đo mốc ghép trên từng mảnh art nhân vật.
 *
 * Bộ art không kèm bộ xương nên không có mốc nào cho sẵn: mọi chỗ nối giữa các
 * mảnh đều phải suy ra từ chính hình, đo một lần lúc nhập art rồi ghi vào atlas.
 */

/**
 * Dòng CẰM trên mảnh khuôn mặt có sẵn khúc cổ.
 *
 * Mảnh mặt kiểu này gồm đầu và một khúc cổ, nên đáy mảnh là hết cổ chứ không
 * phải cằm. Lúc ghép cần cả hai mốc: đáy để lún vào cổ áo, còn cằm để đặt mái
 * tóc. Cằm tìm bằng chỗ hình PHÌNH RA: từ dưới lên, khúc cổ hẹp và đều, tới
 * cằm thì bề ngang nhảy vọt vì có thêm hai bên hàm.
 *
 * @returns {number|null} chỉ số dòng cằm, null nếu không tìm ra khúc cổ.
 */
export function chinRow(piece) {
  const { w: W, h: H, data } = piece;
  const widths = [];
  for (let y = 0; y < H; y++) {
    let n = 0;
    for (let x = 0; x < W; x++) if (data[(y * W + x) * 4 + 3] > 128) n++;
    widths.push(n);
  }
  // Cằm: đi xuống từ chỗ ĐẦU RỘNG NHẤT, dừng ở hàng đầu tiên hẹp còn chưa tới
  // 30% bề ngang đầu — dưới ngưỡng đó là đã sang khúc cổ.
  //
  // Không lấy mốc theo bề ngang khúc cổ: cổ mỗi mảnh một khác, có mảnh rất hẹp
  // nên ngưỡng tụt xuống tận chân cổ. Còn đi từ mép trên xuống thì dừng nhầm
  // ngay ở đỉnh đầu, vì đỉnh đầu cũng hẹp.
  let widest = 0;
  for (let y = 0; y < H; y++) if (widths[y] > widths[widest]) widest = y;
  const cut = widths[widest] * 0.3;
  for (let y = widest; y < H; y++) if (widths[y] < cut) return y;
  return null;
}

/**
 * Chỗ CẮM ĐẦU trên mảnh trang phục.
 *
 * Mảnh trang phục của bộ art mới là cả người trừ cái đầu, và chỗ cao nhất của
 * nó chính là miệng cổ áo — chỗ khúc cổ chui lên. Nên mốc lấy ngay ở đó: hàng
 * trên cùng có hình, tâm ngang của hình trên hàng ấy, và bề ngang miệng cổ.
 *
 * Đo tâm bằng TRUNG VỊ của mấy hàng đầu chứ không lấy một hàng: hàng trên cùng
 * của mấy bộ có mũ trùm hay khăn quàng chỉ là một chỏm lệch sang bên.
 */
export function collarSlot(piece) {
  const { w: W, h: H, data } = piece;
  const rows = [];
  for (let y = 0; y < H; y++) {
    let x0 = W, x1 = -1;
    for (let x = 0; x < W; x++) if (data[(y * W + x) * 4 + 3] > 128) { if (x < x0) x0 = x; x1 = x; }
    if (x1 >= x0) rows.push({ y, x0, x1 });
    if (rows.length >= Math.max(8, Math.round(H * 0.06))) break;
  }
  if (!rows.length) return {};
  const mid = rows.map((r) => (r.x0 + r.x1) / 2).sort((a, b) => a - b);
  return {
    collar: {
      x: Math.round(mid[mid.length >> 1]),
      y: rows[0].y,
      w: rows[0].x1 - rows[0].x0 + 1,
    },
  };
}

/**
 * Khung SỌ của một mảnh đầu hoặc một mảnh tóc.
 *
 * Bộ art mới không có mảnh tóc nào bọc sẵn cái đầu để khoét lấy lỗ căn, nên
 * mốc phải suy từ dáng: cả đầu lẫn tóc đều là một khối tròn, chỗ PHÌNH RỘNG
 * NHẤT của tóc chính là chỗ nó ôm quanh chỗ phình rộng nhất của đầu. Ghi lại
 * đỉnh, hàng rộng nhất và tâm ngang tại hàng đó là đủ để đặt tóc lên đầu mà
 * không phải chỉnh tay từng kiểu.
 */
export function headCap(piece) {
  const { w: W, h: H, data } = piece;
  let top = -1, wide = 0, wideW = 0, wideCx = W / 2;
  for (let y = 0; y < H; y++) {
    let x0 = W, x1 = -1, n = 0;
    for (let x = 0; x < W; x++) if (data[(y * W + x) * 4 + 3] > 128) { if (x < x0) x0 = x; x1 = x; n++; }
    if (x1 < x0) continue;
    if (top < 0) top = y;
    const span = x1 - x0 + 1;
    if (span > wideW) { wideW = span; wide = y; wideCx = (x0 + x1) / 2; }
  }
  if (top < 0) return {};
  return { cap: { top, wide, w: wideW, cx: Math.round(wideCx) } };
}

/**
 * Mặt nạ da trần thành một mảnh vẽ được.
 *
 * `pocket` từ khâu tách nền đánh dấu chỗ ruột tay ruột chân — vốn là ô caro nằm
 * lọt trong nét viền. Đổ TRẮNG vào đó rồi vẽ lót dưới mảnh trang phục và nhân
 * với tông da người chơi chọn: một bộ đồ hợp cả năm tông, khỏi nhập năm bản.
 *
 * Nới ra một pixel để chui xuống dưới nét viền — tô đúng khít thì giữa mảng da
 * và nét viền còn một sợi trong suốt, phóng to lên là một đường sáng chạy dọc
 * cánh tay.
 */
export function pocketPiece(mask, W, H) {
  let n = 0;
  for (let i = 0; i < mask.length; i++) if (mask[i]) n++;
  if (n < 64) return null;
  const data = new Uint8Array(W * H * 4);
  for (let y = 0; y < H; y++) {
    for (let x = 0; x < W; x++) {
      let on = mask[y * W + x] === 1;
      if (!on) {
        for (let dy = -1; dy <= 1 && !on; dy++) for (let dx = -1; dx <= 1 && !on; dx++) {
          const nx = x + dx, ny = y + dy;
          if (nx < 0 || ny < 0 || nx >= W || ny >= H) continue;
          if (mask[ny * W + nx]) on = true;
        }
      }
      if (!on) continue;
      const i = (y * W + x) * 4;
      data[i] = 255; data[i + 1] = 255; data[i + 2] = 255; data[i + 3] = 255;
    }
  }
  return { w: W, h: H, data };
}

/**
 * TÔNG DA của một mảnh đầu.
 *
 * Năm mảnh đầu là năm tông vẽ sẵn, không phải một tông nhuộm lại — nên chỗ ghép
 * không cần nhuộm cái đầu. Nhưng tay chân trần trên mảnh trang phục thì lại
 * phải nhuộm cho khớp, mà "khớp" nghĩa là khớp với CHÍNH mảnh đầu đang đội. Nên
 * đo tông ngay lúc nhập art và ghi vào atlas, khỏi chép tay năm mã màu rồi lệch
 * lúc nào không biết.
 *
 * Lấy màu HAY GẶP NHẤT ở giữa má chứ không lấy trung bình: trung bình của cả
 * khuôn mặt bị nét viền tối và mảng sáng kéo lệch đi.
 */
export function skinTone(piece) {
  const { w: W, h: H, data } = piece;
  const tally = new Map();
  for (let y = Math.round(H * 0.35); y < Math.round(H * 0.6); y++) {
    for (let x = Math.round(W * 0.35); x < Math.round(W * 0.65); x++) {
      const i = (y * W + x) * 4;
      if (data[i + 3] < 250) continue;
      const key = (data[i] << 16) | (data[i + 1] << 8) | data[i + 2];
      tally.set(key, (tally.get(key) ?? 0) + 1);
    }
  }
  if (!tally.size) return {};
  let best = 0, bestN = -1;
  for (const [key, n] of tally) if (n > bestN) { best = key; bestN = n; }
  return { tone: `#${best.toString(16).padStart(6, '0')}` };
}

/**
 * Xoá NÉT SỢI TÓC trên mảnh trang phục.
 *
 * Ở vài bộ đồ nữ, cánh tay trần chỉ còn đúng một nét viền ngoài — không có nét
 * trong, không có mảng màu nào, chỉ một sợi cong thả từ ống tay xuống. Đó là
 * vết sót của khâu tách nhân vật khỏi tấm gốc chứ không phải hình: cắt ra thì
 * nhân vật trông như có hai sợi dây thay cho hai cánh tay.
 *
 * Nhận ra bằng BỀ DÀY, không phải bằng màu: nét sót mảnh đúng một hai pixel,
 * còn mọi thứ khác trên bộ đồ — kể cả dây mũ, quai túi, dây giày — đều dày hơn
 * thế. (Thử bằng màu thì hỏng: vải sẫm như áo nỉ đỏ hay quần đen cũng "tối" y
 * như nét viền, xoá theo màu là bay mất nửa bộ đồ.)
 *
 * Cách đo bề dày: xói mòn mặt nạ đi `core` pixel rồi giữ lại phần nằm trong
 * `reach` pixel quanh cái lõi còn sót. Sợi mảnh không còn lõi nào nên rụng cả;
 * mảng dày thì lõi còn nguyên, và toàn bộ mảng nằm sát lõi nên giữ được hết.
 */
export function dropHairlines(piece, { core = 1, reach = 2 } = {}) {
  const { w: W, h: H, data } = piece;
  const on = (x, y) => x >= 0 && y >= 0 && x < W && y < H && data[(y * W + x) * 4 + 3] >= 40;

  const eroded = new Uint8Array(W * H);
  for (let y = 0; y < H; y++) {
    for (let x = 0; x < W; x++) {
      if (!on(x, y)) continue;
      let solid = true;
      for (let dy = -core; dy <= core && solid; dy++) {
        for (let dx = -core; dx <= core && solid; dx++) if (!on(x + dx, y + dy)) solid = false;
      }
      if (solid) eroded[y * W + x] = 1;
    }
  }

  let dropped = 0;
  for (let y = 0; y < H; y++) {
    for (let x = 0; x < W; x++) {
      const i = y * W + x;
      if (data[i * 4 + 3] < 40) continue;
      let keep = false;
      for (let dy = -reach; dy <= reach && !keep; dy++) {
        for (let dx = -reach; dx <= reach && !keep; dx++) {
          const nx = x + dx, ny = y + dy;
          if (nx < 0 || ny < 0 || nx >= W || ny >= H) continue;
          if (eroded[ny * W + nx]) keep = true;
        }
      }
      if (!keep) { data[i * 4 + 3] = 0; dropped++; }
    }
  }
  return dropped;
}

/** Tâm ngang của mấy hàng đặc đầu tiên tính từ một đầu mảnh. */
function capOf(piece, fromTop, rows = 4) {
  const { w: W, h: H, data } = piece;
  const seen = [];
  for (let k = 0; k < H && seen.length < rows; k++) {
    const y = fromTop ? k : H - 1 - k;
    let x0 = W, x1 = -1;
    for (let x = 0; x < W; x++) if (data[(y * W + x) * 4 + 3] > 128) { if (x < x0) x0 = x; x1 = x; }
    if (x1 >= x0) seen.push({ y, cx: (x0 + x1) / 2 });
  }
  if (!seen.length) return { x: W / 2, y: fromTop ? 0 : H - 1 };
  const cx = seen.reduce((a, r) => a + r.cx, 0) / seen.length;
  return { x: cx, y: seen[0].y };
}

/** Đường kính ống ở khúc cuối mảnh — bề ngang lớn nhất trong một phần tư dưới. */
function tubeWidth(piece) {
  const { w: W, h: H, data } = piece;
  let best = 0;
  for (let y = Math.floor(H * 0.75); y < H; y++) {
    let x0 = W, x1 = -1;
    for (let x = 0; x < W; x++) if (data[(y * W + x) * 4 + 3] > 128) { if (x < x0) x0 = x; x1 = x; }
    if (x1 >= x0 && x1 - x0 + 1 > best) best = x1 - x0 + 1;
  }
  return best;
}

/**
 * Nối mấy KHÚC CHI rời thành một cánh tay liền.
 *
 * Tấm sườn cơ thể bày từng khúc một — bắp tay, cẳng tay, bàn tay — mỗi khúc là
 * một ống có hai đầu bịt hình bầu dục. Nối bằng chính hai cái đầu ấy: tâm đầu
 * TRÊN của khúc dưới đặt trùng tâm đầu DƯỚI của khúc trên. Không phải số chỉnh
 * tay, mà đo trên hình, nên khúc nào thon khúc nào to đều nối đúng chỗ.
 *
 * Chồng lấn vài pixel để cái bầu dục hở của khúc trên bị khúc dưới che đi —
 * nối đúng khít thì chỗ nối hiện ra một vành tối như khớp búp bê.
 *
 * @returns mảnh đã nối, kèm `socket` là tâm đầu trên của khúc đầu tiên — chỗ
 *          cắm vào vai.
 */
export function chainLimb(parts, { overlap = null } = {}) {
  if (!parts.length) return null;
  const at = [{ x: 0, y: 0 }];
  for (let i = 1; i < parts.length; i++) {
    const bot = capOf(parts[i - 1], false);
    const top = capOf(parts[i], true);
    // Chồng lấn đo theo BỀ NGANG ống, không ghi số chết: cái bầu dục bịt đầu
    // ống cao chừng một phần ba đường kính ống, ống to thì bầu dục cũng to.
    const sink = overlap ?? Math.round(tubeWidth(parts[i - 1]) * 0.45);
    at.push({
      x: at[i - 1].x + bot.x - top.x,
      y: at[i - 1].y + bot.y - top.y - sink,
    });
  }
  const x0 = Math.min(...at.map((p) => p.x));
  const y0 = Math.min(...at.map((p) => p.y));
  const x1 = Math.max(...at.map((p, i) => p.x + parts[i].w));
  const y1 = Math.max(...at.map((p, i) => p.y + parts[i].h));
  const W = Math.ceil(x1 - x0), H = Math.ceil(y1 - y0);
  const data = new Uint8Array(W * H * 4);
  parts.forEach((part, i) => {
    const ox = Math.round(at[i].x - x0), oy = Math.round(at[i].y - y0);
    for (let y = 0; y < part.h; y++) {
      for (let x = 0; x < part.w; x++) {
        const s = (y * part.w + x) * 4;
        const a = part.data[s + 3];
        if (!a) continue;
        const d = ((oy + y) * W + ox + x) * 4;
        if (d < 0 || d >= data.length) continue;
        const k = a / 255;
        for (let c = 0; c < 3; c++) data[d + c] = Math.round(part.data[s + c] * k + data[d + c] * (1 - k));
        data[d + 3] = Math.max(data[d + 3], a);
      }
    }
  });
  const head = capOf(parts[0], true);
  return {
    w: W, h: H, data,
    socket: { x: Math.round(head.x - x0), y: Math.round(at[0].y - y0 + head.y) },
  };
}

/**
 * MIỆNG ỐNG TAY trên mảnh trang phục — chỗ bàn tay thò ra.
 *
 * Tấm trang phục vẽ cả người MẶC ĐỒ, tay áo đã vẽ sẵn tới cổ tay: cái thiếu chỉ
 * là bàn tay. Nhét nguyên một cánh tay lấy từ tấm sườn vào sau áo là sai — sau
 * ống tay áo đã có tay rồi, và bàn tay sẽ rơi ở chỗ cánh tay lạ ấy kết thúc chứ
 * không phải ở miệng ống tay.
 *
 * Tìm miệng ống tay bằng chỗ mép ngoài của dáng TỤT VÀO đột ngột: đi từ vai
 * xuống, mép ngoài chạy dọc ống tay rồi rơi hẳn vào trong khi hết ống tay, vì
 * dưới đó chỉ còn thân với quần.
 *
 * Chỉ dò trong khoảng 38%–56% chiều cao, vì trên thân người này cổ tay bao giờ
 * cũng nằm ngay dưới ngang hông. Ngoài khoảng ấy thì chỗ tụt là thứ khác: trên
 * nữa là mép áo cộc tay (hở cả cẳng tay, phải vẽ cả cánh tay chứ không phải mỗi
 * bàn tay), dưới nữa là gấu váy xoè ra — mà gấu váy còn tụt mạnh hơn cả ống tay
 * nên không lấy chỗ tụt MẠNH NHẤT được, phải lấy chỗ tụt đầu tiên trong khoảng.
 *
 * @returns {{cuff:{l?:{x,y,w},r?:{x,y,w}}}|{}} vắng một bên nghĩa là bên ấy
 *          không có ống tay (váy hai dây, áo cộc tay) — chỗ ghép sẽ vẽ cả cánh
 *          tay thay vì chỉ bàn tay.
 */
export function cuffSlot(piece, { minDrop = 10 } = {}) {
  const { w: W, h: H, data } = piece;
  const on = (x, y) => data[(y * W + x) * 4 + 3] > 128;
  const edge = (y, side) => {
    for (let k = 0; k < W; k++) {
      const x = side < 0 ? k : W - 1 - k;
      if (on(x, y)) return x;
    }
    return null;
  };
  const runs = (y) => {
    const out = []; let s = -1;
    for (let x = 0; x < W; x++) {
      if (on(x, y)) { if (s < 0) s = x; } else if (s >= 0) { out.push([s, x - 1]); s = -1; }
    }
    if (s >= 0) out.push([s, W - 1]);
    return out;
  };

  const cuff = {};
  for (const side of [-1, 1]) {
    // Lấy chỗ tụt ĐẦU TIÊN tính từ vai xuống, không lấy chỗ tụt mạnh nhất: đi
    // từ trên xuống thì bao giờ cũng gặp hết ống tay trước, còn gấu váy nằm
    // dưới nữa mà lại tụt mạnh hơn — lấy mạnh nhất là cắm bàn tay vào gấu váy.
    let best = null;
    for (let y = Math.round(H * 0.38); y <= Math.round(H * 0.56) && !best; y++) {
      const a = edge(y, side), b = edge(y + 3, side);
      if (a == null || b == null) continue;
      const drop = side < 0 ? b - a : a - b;      // dương = mép tụt vào trong
      if (drop >= minDrop) best = { y, drop, x: a };
    }
    if (!best) continue;
    // Bề ngang miệng ống đo ở vài dòng TRÊN chỗ tụt: đúng dòng tụt thì ống đã
    // cụt mất một nửa. Lấy mảng ngoài cùng nếu nó rời khỏi thân, không thì
    // đành lấy một khúc từ mép ngoài vào.
    const probe = Math.max(0, best.y - 3);
    const list = runs(probe).filter(([p, q]) => q - p >= 2);
    const body = list.reduce((m, c) => (c[1] - c[0] > m[1] - m[0] ? c : m), list[0] ?? [0, 0]);
    const outer = side < 0 ? list[0] : list[list.length - 1];
    const sleeve = outer && outer !== body ? outer : null;
    const w = sleeve ? sleeve[1] - sleeve[0] + 1 : Math.max(8, Math.round(W * 0.09));
    const x = sleeve ? Math.round((sleeve[0] + sleeve[1]) / 2) : best.x - side * Math.round(w / 2);
    cuff[side < 0 ? 'l' : 'r'] = { x, y: best.y, w };
  }
  return Object.keys(cuff).length ? { cuff } : {};
}
