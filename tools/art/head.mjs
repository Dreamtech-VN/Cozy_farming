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
