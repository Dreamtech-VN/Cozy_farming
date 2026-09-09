/**
 * Khoét phần ĐẦU ra khỏi mảnh tóc, và trả lại khung của cái lỗ vừa khoét.
 *
 * Mảnh tóc trên tấm gốc không phải chỉ có tóc: nó là cả cái đầu đội tóc, phần
 * mặt tô kín màu da. Vẽ thẳng lên nhân vật thì mảng da đó đè mất khuôn mặt bên
 * dưới. Khoét đi thì còn đúng phần tóc, mà cái LỖ vừa khoét lại chính là chỗ
 * khuôn mặt phải nằm — nên hàm trả về khung lỗ để dùng làm mốc căn, khỏi phải
 * chỉnh tay từng kiểu tóc.
 */

/** Da người trong tấm này: sáng, ngả đỏ, R > G >= B và chênh lệch vừa phải. */
function isSkin(r, g, b) {
  return r >= 185 && r > g && g >= b && r - b >= 15 && r - b <= 95 && r - g <= 45;
}

export function stripHead(piece) {
  const { w: W, h: H, data } = piece;
  const skinAt = (i) => data[i * 4 + 3] > 128 && isSkin(data[i * 4], data[i * 4 + 1], data[i * 4 + 2]);

  // Mồi loang: pixel da gần tâm khuôn mặt nhất. Khuôn mặt nằm ở nửa dưới mảnh
  // tóc — nửa trên là đỉnh tóc. Dò xoáy ốc ra ngoài từ điểm đoán.
  let seed = -1;
  const cx = W >> 1, cy = Math.round(H * 0.68);
  for (let r = 0; r < Math.max(W, H) && seed < 0; r++) {
    for (let dy = -r; dy <= r && seed < 0; dy++) {
      for (let dx = -r; dx <= r && seed < 0; dx++) {
        if (Math.max(Math.abs(dx), Math.abs(dy)) !== r) continue;
        const x = cx + dx, y = cy + dy;
        if (x < 0 || y < 0 || x >= W || y >= H) continue;
        if (skinAt(y * W + x)) seed = y * W + x;
      }
    }
  }
  if (seed < 0) return null; // tóc nhìn từ sau: không có mặt để khoét

  // Hai lần loang, chọn cái đúng.
  //
  // Loang rộng (chỉ hỏi "có phải da không") là cách duy nhất khoét sạch những
  // kiểu tóc mà mặt có nhiều mảng sáng tối, nhưng với tóc VÀNG thì nó lem
  // thẳng vào tóc: da trong bóng (244,216,189) và tóc vàng (248,217,187) gần
  // như trùng màu. Loang hẹp (bám sát màu điểm mồi) thì không lem, nhưng bỏ
  // sót nửa khuôn mặt ở mấy kiểu tóc kia.
  //
  // Phân biệt bằng một điều luôn đúng với bộ art này: ĐỈNH ĐẦU bao giờ cũng là
  // tóc. Lỗ khoét mà ăn lên tới đỉnh nghĩa là đã lem vào tóc — lúc đó mới hạ
  // xuống dùng bản hẹp.
  const TOL = 30;
  const s0 = data[seed * 4], s1 = data[seed * 4 + 1], s2 = data[seed * 4 + 2];
  const nearSeed = (i) => Math.abs(data[i * 4] - s0) <= TOL
    && Math.abs(data[i * 4 + 1] - s1) <= TOL && Math.abs(data[i * 4 + 2] - s2) <= TOL;

  const queue = new Int32Array(W * H);
  const fill = (tight) => {
    const mask = new Uint8Array(W * H);
    let qh = 0, qt = 0;
    mask[seed] = 1; queue[qt++] = seed;
    let x0 = W, y0 = H, x1 = 0, y1 = 0;
    while (qh < qt) {
      const i = queue[qh++];
      const x = i % W, y = (i / W) | 0;
      if (x < x0) x0 = x; if (x > x1) x1 = x;
      if (y < y0) y0 = y; if (y > y1) y1 = y;
      for (let dy = -1; dy <= 1; dy++) for (let dx = -1; dx <= 1; dx++) {
        const nx = x + dx, ny = y + dy;
        if (nx < 0 || ny < 0 || nx >= W || ny >= H) continue;
        const j = ny * W + nx;
        if (mask[j] || !skinAt(j) || (tight && !nearSeed(j))) continue;
        mask[j] = 1; queue[qt++] = j;
      }
    }
    return { mask, x0, y0, x1, y1 };
  };

  const CROWN = 0.18; // phần đỉnh mảnh tóc, tính theo chiều cao
  let spread = fill(false);
  if (spread.y0 < H * CROWN) spread = fill(true);
  const { mask: hole, x0, y0, x1, y1 } = spread;

  // Mắt, lông mày, miệng vẽ sẵn trong một vài mảnh tóc là những đảo nằm LỌT
  // trong vùng da. Xoá da mà để chúng lại thì khuôn mặt mới đội thêm một đôi
  // mắt cũ. Quét lại: cụm nào nằm gọn trong khung lỗ và không chạm mép mảnh
  // thì cũng là mặt cũ, xoá nốt.
  const seenPix = new Uint8Array(W * H);
  let qh = 0, qt = 0;
  for (let sy = y0; sy <= y1; sy++) {
    for (let sx = x0; sx <= x1; sx++) {
      const start = sy * W + sx;
      if (seenPix[start] || hole[start] || data[start * 4 + 3] <= 128) continue;
      qh = 0; qt = 0; queue[qt++] = start; seenPix[start] = 1;
      const cluster = [start];
      let outside = false;
      while (qh < qt) {
        const i = queue[qh++];
        const x = i % W, y = (i / W) | 0;
        if (x < x0 || x > x1 || y < y0 || y > y1) outside = true;
        for (let dy = -1; dy <= 1; dy++) for (let dx = -1; dx <= 1; dx++) {
          const nx = x + dx, ny = y + dy;
          if (nx < 0 || ny < 0 || nx >= W || ny >= H) continue;
          const j = ny * W + nx;
          if (seenPix[j] || hole[j] || data[j * 4 + 3] <= 128) continue;
          seenPix[j] = 1; queue[qt++] = j; cluster.push(j);
        }
      }
      if (!outside) for (const i of cluster) hole[i] = 1;
    }
  }

  // Đo khung SAU khi đã gom cả mắt mũi miệng vào lỗ: loang màu da dừng lại ở
  // đôi mắt vẽ sẵn, nên khung đo trước đó mới chỉ là một bên má.
  let hx0 = W, hy0 = H, hx1 = 0, hy1 = 0;
  for (let i = 0; i < W * H; i++) {
    if (!hole[i]) continue;
    data[i * 4 + 3] = 0;
    const x = i % W, y = (i / W) | 0;
    if (x < hx0) hx0 = x; if (x > hx1) hx1 = x;
    if (y < hy0) hy0 = y; if (y > hy1) hy1 = y;
  }
  return { x: hx0, y: hy0, w: hx1 - hx0 + 1, h: hy1 - hy0 + 1 };
}

/**
 * Xoá nét viền dưới cằm của mảnh khuôn mặt.
 *
 * Mảnh mặt được cắt rời nên có nét viền khép KÍN vòng quanh đầu, kể cả dưới
 * cằm. Art vẽ liền thì không thế: nét hàm chạy xuống rồi thành nét cổ, dưới
 * cằm không có nét nào cắt ngang. Ghép mảnh mặt lên thân mà giữ nguyên nét ấy
 * thì nó nằm vắt ngang khúc cổ thành một vòng tối — nhìn đúng như đầu với thân
 * hở ra một đường, dù không hở pixel nào.
 *
 * Chỉ xoá ở khoảng GIỮA (chỗ khúc cổ đi qua) và chỉ vài pixel ngoài cùng; hai
 * bên hàm vẫn còn nét, vì ở đó hàm giáp nền thật.
 */
export function openChin(piece, { width = 0.5, depth = 3 } = {}) {
  const { w: W, h: H, data } = piece;
  const half = Math.round((W * width) / 2);
  const dark = (i) => 0.2126 * data[i * 4] + 0.7152 * data[i * 4 + 1] + 0.0722 * data[i * 4 + 2] < 165;
  for (let x = Math.round(W / 2) - half; x <= Math.round(W / 2) + half; x++) {
    if (x < 0 || x >= W) continue;
    let removed = 0;
    for (let y = H - 1; y >= 0 && removed < depth; y--) {
      const i = y * W + x;
      if (data[i * 4 + 3] < 40) continue;   // chưa tới hình
      if (!dark(i)) break;                   // hết nét viền, tới phần da
      data[i * 4 + 3] = 0;
      removed++;
    }
  }
}

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
 * Bề ngang hình ở một dòng.
 *
 * Dùng để đo khúc cổ — mốc quy tỉ lệ giữa mảnh mặt và mảnh trang phục. Hai
 * mảnh vẽ ở hai độ phân giải khác nhau, nhưng chỗ chúng NỐI vào nhau là khúc
 * cổ, nên cho hai khúc cổ bằng nhau là hai mảnh khớp nhau.
 */
export function widthAtRow(piece, row) {
  const { w: W, h: H, data } = piece;
  const y = Math.min(H - 1, Math.max(0, Math.round(row)));
  let n = 0;
  for (let x = 0; x < W; x++) if (data[(y * W + x) * 4 + 3] > 128) n++;
  return n;
}
