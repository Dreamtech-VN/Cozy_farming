import { registerPanel } from './UIManager';
import { h, openWindow, btn } from './kit';
import { S, save, addCoins, addStat } from '@/core/save';
import { toast } from '@/core/events';
import { sfx } from '@/core/audio';

function rewardWin(coins: number, statKey: 'caroWins' | 'xiangqiWins' | 'rpsWins') {
  addCoins(coins);
  S.stats['coins_earned'] = (S.stats['coins_earned'] ?? 0) + coins;
  S.minigames[statKey]++;
  if (statKey === 'caroWins') addStat('caro_wins');
  addStat('minigame_wins');
  save();
  toast(`Thắng! +${coins} xu`, 'rank');
  sfx.win();
}

export function registerMinigames() {

  // ================= Cờ caro (Gomoku 12x12, thắng 5) =================
  registerPanel('caro', () => {
    const N = 12;
    const { body } = openWindow('Cờ caro — bạn là X', { size: 'large' });
    addStat('daily_minigame');
    let board: number[] = new Array(N * N).fill(0); // 0 trống, 1 người, 2 máy
    let over = false;
    const grid = h('div', 'board');
    grid.style.gridTemplateColumns = `repeat(${N}, 26px)`;
    const cells: HTMLElement[] = [];
    const status = h('div', 't1', 'Lượt của bạn!');
    status.style.textAlign = 'center';

    const lines = (i: number, who: number): boolean => {
      const x = i % N, y = Math.floor(i / N);
      for (const [dx, dy] of [[1, 0], [0, 1], [1, 1], [1, -1]]) {
        let cnt = 1;
        for (const s of [1, -1]) {
          let nx = x + dx * s, ny = y + dy * s;
          while (nx >= 0 && nx < N && ny >= 0 && ny < N && board[ny * N + nx] === who) {
            cnt++; nx += dx * s; ny += dy * s;
          }
        }
        if (cnt >= 5) return true;
      }
      return false;
    };

    // AI: chấm điểm từng ô theo chuỗi tấn công/phòng thủ
    const aiMove = (): number => {
      let best = -1, bestScore = -1;
      for (let i = 0; i < N * N; i++) {
        if (board[i] !== 0) continue;
        const score = evalCell(i, 2) * 1.1 + evalCell(i, 1);
        if (score > bestScore) { bestScore = score; best = i; }
      }
      return best;
    };
    const evalCell = (i: number, who: number): number => {
      const x = i % N, y = Math.floor(i / N);
      let total = 0;
      for (const [dx, dy] of [[1, 0], [0, 1], [1, 1], [1, -1]]) {
        let cnt = 0, open = 0;
        for (const s of [1, -1]) {
          let nx = x + dx * s, ny = y + dy * s;
          while (nx >= 0 && nx < N && ny >= 0 && ny < N && board[ny * N + nx] === who) {
            cnt++; nx += dx * s; ny += dy * s;
          }
          if (nx >= 0 && nx < N && ny >= 0 && ny < N && board[ny * N + nx] === 0) open++;
        }
        total += Math.pow(10, cnt) * (open + 1);
      }
      return total + Math.random() * 5;
    };

    const render = () => {
      cells.forEach((c, i) => {
        c.textContent = board[i] === 1 ? '✕' : board[i] === 2 ? '○' : '';
        c.style.color = board[i] === 1 ? '#c92a2a' : '#1864ab';
      });
    };

    for (let i = 0; i < N * N; i++) {
      const c = h('div', 'bcell');
      c.onclick = () => {
        if (over || board[i] !== 0) return;
        board[i] = 1; render(); sfx.click();
        if (lines(i, 1)) { over = true; status.textContent = 'Bạn thắng!'; rewardWin(200, 'caroWins'); return; }
        if (!board.includes(0)) { over = true; status.textContent = 'Hòa!'; return; }
        const m = aiMove();
        board[m] = 2; render();
        if (lines(m, 2)) { over = true; status.textContent = 'Máy thắng rồi...'; sfx.lose(); }
      };
      cells.push(c);
      grid.append(c);
    }
    const reset = btn('Ván mới', 'blue', () => { board = new Array(N * N).fill(0); over = false; status.textContent = 'Lượt của bạn!'; render(); });
    const bar = h('div');
    bar.style.cssText = 'display:flex;justify-content:center;gap:10px;margin-top:8px';
    bar.append(reset);
    body.append(status, grid, bar);
  });

  // ================= Oẳn tù tì =================
  registerPanel('rps', () => {
    const { body } = openWindow('Oẳn tù tì', { size: 'small' });
    addStat('daily_minigame');
    const status = h('div', 't1', 'Chọn kéo, búa hoặc bao! Thắng +50 xu');
    status.style.cssText = 'text-align:center;margin-bottom:10px';
    const show = h('div', '', '? vs ?');
    show.style.cssText = 'text-align:center;font-size:44px;margin:10px 0';
    const bar = h('div');
    bar.style.cssText = 'display:flex;justify-content:center;gap:10px';
    const opts = ['Kéo', 'Búa', 'Bao'] as const;
    opts.forEach((name, i) => {
      bar.append(btn(name, 'gold', () => {
        const ai = Math.floor(Math.random() * 3);
        show.textContent = `${name} vs ${opts[ai]}`;
        if (ai === i) { status.textContent = 'Hòa! Chơi lại nào~'; return; }
        // kéo(0) thắng bao(2); búa(1) thắng kéo(0); bao(2) thắng búa(1)
        const win = (i === 0 && ai === 2) || (i === 1 && ai === 0) || (i === 2 && ai === 1);
        if (win) { status.textContent = 'Bạn thắng!'; rewardWin(50, 'rpsWins'); }
        else { status.textContent = 'Thua rồi!'; sfx.lose(); }
      }));
    });
    body.append(status, show, bar);
  });

  // ================= Cờ tướng =================
  registerPanel('xiangqi', () => {
    const { body } = openWindow('Cờ tướng — bạn cầm Đỏ', { size: 'large' });
    addStat('daily_minigame');
    // bàn 9x10; quân: chữ hoa = đỏ (người), thường = đen (máy)
    // K tướng, A sĩ, E tượng, H mã, R xe, C pháo, P tốt
    const W = 9, H10 = 10;
    let board: (string | null)[] = new Array(W * H10).fill(null);
    const put = (s: string, x: number, y: number) => { board[y * W + x] = s; };
    const setup = () => {
      board = new Array(W * H10).fill(null);
      const back = ['R', 'H', 'E', 'A', 'K', 'A', 'E', 'H', 'R'];
      back.forEach((p, x) => put(p.toLowerCase(), x, 0));
      put('c', 1, 2); put('c', 7, 2);
      for (let x = 0; x < 9; x += 2) put('p', x, 3);
      back.forEach((p, x) => put(p, x, 9));
      put('C', 1, 7); put('C', 7, 7);
      for (let x = 0; x < 9; x += 2) put('P', x, 6);
    };
    setup();
    const isRed = (p: string) => p === p.toUpperCase();
    const VAL: Record<string, number> = { k: 1000, r: 90, c: 45, h: 40, e: 20, a: 20, p: 10 };

    const moves = (i: number): number[] => {
      const p = board[i];
      if (!p) return [];
      const red = isRed(p);
      const x = i % W, y = Math.floor(i / W);
      const out: number[] = [];
      const add = (nx: number, ny: number) => {
        if (nx < 0 || nx >= W || ny < 0 || ny >= H10) return false;
        const t = board[ny * W + nx];
        if (t && isRed(t) === red) return false;
        out.push(ny * W + nx);
        return !t;
      };
      const inPalace = (nx: number, ny: number) => nx >= 3 && nx <= 5 && (red ? ny >= 7 : ny <= 2);
      const kind = p.toLowerCase();
      if (kind === 'k') {
        for (const [dx, dy] of [[1, 0], [-1, 0], [0, 1], [0, -1]]) {
          const nx = x + dx, ny = y + dy;
          if (inPalace(nx, ny)) add(nx, ny);
        }
      } else if (kind === 'a') {
        for (const [dx, dy] of [[1, 1], [1, -1], [-1, 1], [-1, -1]]) {
          const nx = x + dx, ny = y + dy;
          if (inPalace(nx, ny)) add(nx, ny);
        }
      } else if (kind === 'e') {
        for (const [dx, dy] of [[2, 2], [2, -2], [-2, 2], [-2, -2]]) {
          const nx = x + dx, ny = y + dy;
          const ex = x + dx / 2, ey = y + dy / 2;
          if (nx < 0 || nx >= W || ny < 0 || ny >= H10) continue;
          if (red ? ny < 5 : ny > 4) continue; // không qua sông
          if (board[ey * W + ex]) continue;    // cản mắt tượng
          add(nx, ny);
        }
      } else if (kind === 'h') {
        for (const [dx, dy, bx, by] of [[1, 2, 0, 1], [-1, 2, 0, 1], [1, -2, 0, -1], [-1, -2, 0, -1], [2, 1, 1, 0], [2, -1, 1, 0], [-2, 1, -1, 0], [-2, -1, -1, 0]]) {
          const nx = x + dx, ny = y + dy;
          if (nx < 0 || nx >= W || ny < 0 || ny >= H10) continue;
          if (board[(y + by) * W + (x + bx)]) continue; // cản chân mã
          add(nx, ny);
        }
      } else if (kind === 'r') {
        for (const [dx, dy] of [[1, 0], [-1, 0], [0, 1], [0, -1]]) {
          let nx = x + dx, ny = y + dy;
          while (add(nx, ny)) { nx += dx; ny += dy; }
        }
      } else if (kind === 'c') {
        for (const [dx, dy] of [[1, 0], [-1, 0], [0, 1], [0, -1]]) {
          let nx = x + dx, ny = y + dy;
          // đi: ô trống
          while (nx >= 0 && nx < W && ny >= 0 && ny < H10 && !board[ny * W + nx]) {
            out.push(ny * W + nx); nx += dx; ny += dy;
          }
          // ăn: nhảy qua 1 quân
          nx += dx; ny += dy;
          while (nx >= 0 && nx < W && ny >= 0 && ny < H10) {
            const t = board[ny * W + nx];
            if (t) { if (isRed(t) !== red) out.push(ny * W + nx); break; }
            nx += dx; ny += dy;
          }
        }
      } else if (kind === 'p') {
        const fwd = red ? -1 : 1;
        add(x, y + fwd);
        const crossed = red ? y <= 4 : y >= 5;
        if (crossed) { add(x + 1, y); add(x - 1, y); }
      }
      return out;
    };

    const CHAR: Record<string, string> = { K: '帥', A: '仕', E: '相', H: '傌', R: '俥', C: '炮', P: '兵', k: '將', a: '士', e: '象', h: '馬', r: '車', c: '砲', p: '卒' };

    let sel = -1;
    let legal: number[] = [];
    let over = false;
    const status = h('div', 't1', 'Lượt của bạn (Đỏ)');
    status.style.cssText = 'text-align:center;margin-bottom:6px';
    const grid = h('div', 'board');
    grid.style.gridTemplateColumns = `repeat(${W}, 34px)`;
    const cells: HTMLElement[] = [];

    const render = () => {
      cells.forEach((c, i) => {
        const p = board[i];
        c.className = 'bcell xq-cell' + (p ? ` xq-piece ${isRed(p) ? 'xq-red' : 'xq-black'}` : '');
        if (sel === i) c.classList.add('xq-sel');
        if (legal.includes(i)) c.classList.add('xq-move');
        c.textContent = p ? CHAR[p] : '';
      });
    };

    const doMove = (from: number, to: number) => {
      const captured = board[to];
      board[to] = board[from];
      board[from] = null;
      if (captured?.toLowerCase() === 'k') {
        over = true;
        if (isRed(captured)) { status.textContent = 'Mất tướng — thua rồi!'; sfx.lose(); }
        else { status.textContent = 'Bắt được tướng — bạn thắng!'; rewardWin(500, 'xiangqiWins'); }
      }
    };

    const aiTurn = () => {
      if (over) return;
      let best: { from: number; to: number; score: number } | undefined;
      for (let i = 0; i < board.length; i++) {
        const p = board[i];
        if (!p || isRed(p)) continue;
        for (const m of moves(i)) {
          const t = board[m];
          const score = (t ? VAL[t.toLowerCase()] : 0) + Math.random() * 3;
          if (!best || score > best.score) best = { from: i, to: m, score };
        }
      }
      if (!best) { over = true; status.textContent = 'Máy hết nước đi — bạn thắng!'; rewardWin(500, 'xiangqiWins'); render(); return; }
      doMove(best.from, best.to);
      if (!over) status.textContent = 'Lượt của bạn (Đỏ)';
      render();
    };

    for (let i = 0; i < W * H10; i++) {
      const c = h('div', 'bcell xq-cell');
      c.onclick = () => {
        if (over) return;
        const p = board[i];
        if (sel >= 0 && legal.includes(i)) {
          doMove(sel, i);
          sel = -1; legal = [];
          render();
          if (!over) { status.textContent = 'Máy đang nghĩ...'; setTimeout(aiTurn, 500); }
          return;
        }
        if (p && isRed(p)) { sel = i; legal = moves(i); sfx.click(); }
        else { sel = -1; legal = []; }
        render();
      };
      cells.push(c);
      grid.append(c);
    }
    const reset = btn('Ván mới', 'blue', () => { setup(); sel = -1; legal = []; over = false; status.textContent = 'Lượt của bạn (Đỏ)'; render(); });
    const bar = h('div');
    bar.style.cssText = 'display:flex;justify-content:center;margin-top:8px';
    bar.append(reset);
    body.append(status, grid, bar);
    render();
  });

  // ================= Tạo nhân vật =================
  registerPanel('charcreate', () => {
    // panel cố định bên phải, không phải cửa sổ
    const wrap = h('div', 'cc-panel');
    const head = h('div', 'win-head');
    head.dataset.title = 'Tạo nhân vật';   // bảng tên vẽ bằng ::before như Túi đồ
    const bodyEl = h('div', 'cc-body');
    wrap.append(head, bodyEl);
    document.getElementById('ui-root')!.append(wrap);
    buildCharCreate(bodyEl, () => wrap.remove());
  });
}

// ===== Form tạo nhân vật chibi =====
import { bus, EV } from '@/core/events';
import { chibiPreview, charFace, charHeadOnly } from './kit';
import { defaultLook, simplestList, chibiList, FACE } from '@/data/chibi';

function buildCharCreate(body: HTMLElement, done: () => void) {
  if (!S.player.chibi) S.player.chibi = defaultLook(1);
  const look = S.player.chibi;
  const emit = () => bus.emit(EV.APPEARANCE);

  // --- Tên nhân vật: trên cùng ---
  const nameInput = h('input', 'ui-input cc-input') as HTMLInputElement;
  nameInput.placeholder = 'Nhập tên...';
  nameInput.maxLength = 12;
  nameInput.onkeydown = e => e.stopPropagation();
  body.append(h('div', 'cc-mini-label', 'Tên nhân vật'), nameInput);

  // --- preview + giới tính + biểu cảm ---
  const topArea = h('div', 'cc-top');

  // preview nhân vật + 2 nút xoay trái/phải
  const previewWrap = h('div', 'cc-preview-wrap');
  const preview = h('div', 'cc-preview');
  let faceLeft = false;                       // art chỉ có 1 hướng -> lật ngang
  const turnL = h('button', 'cc-turn cc-turn-l');
  const turnR = h('button', 'cc-turn cc-turn-r');
  turnL.title = 'Quay sang trái'; turnR.title = 'Quay sang phải';
  turnL.onclick = () => { faceLeft = true; refreshPreview(); };
  turnR.onclick = () => { faceLeft = false; refreshPreview(); };
  previewWrap.append(turnL, preview, turnR);
  topArea.append(previewWrap);

  // giới tính nằm cạnh preview
  const sideInfo = h('div', 'cc-side');
  const gRow = h('div', 'cc-gender-row');
  const genders: [number, string][] = [[1, 'Nam'], [2, 'Nữ']];
  const buildGender = () => {
    gRow.innerHTML = '';
    for (const [g, lbl] of genders) {
      const c = h('div', `cc-chip ${look.gender === g ? 'active' : ''}`, lbl);
      c.onclick = () => {
        Object.assign(look, defaultLook(g));
        S.player.gender = g === 2 ? 'female' : 'male';
        emit(); rebuild();
      };
      gRow.append(c);
    }
  };
  sideInfo.append(h('div', 'cc-mini-label', 'Giới tính'), gRow);

  // biểu cảm ngay dưới giới tính
  const exprRow = h('div', 'cc-expr-row');
  const EXPRS: [number, string][] = [[FACE.normal, 'Bình thường'], [FACE.happy, 'Vui vẻ'], [FACE.wink, 'Tinh nghịch']];
  const buildExpr = () => {
    exprRow.innerHTML = '';
    for (const [id, lbl] of EXPRS) {
      const c = h('div', `cc-expr ${look.eyes === id ? 'active' : ''}`);
      c.append(charHeadOnly({ ...look, eyes: id }, 30));
      c.title = lbl;
      c.onclick = () => { look.eyes = id; emit(); rebuild(); };
      exprRow.append(c);
    }
  };
  sideInfo.append(h('div', 'cc-mini-label', 'Biểu cảm'), exprRow);

  topArea.append(sideInfo);
  body.append(topArea);

  // --- Tabs: Tóc / Trang phục ---
  const tabBar = h('div', 'cc-tabs');
  const tabContent = h('div', 'cc-tab-content');
  const TABS = ['Tóc', 'Mắt', 'Trang phục'];
  let activeTab = 0;
  const tabBtns: HTMLElement[] = [];
  for (let i = 0; i < TABS.length; i++) {
    const t = h('div', `cc-tab ${i === 0 ? 'active' : ''}`, TABS[i]);
    t.onclick = () => { activeTab = i; tabBtns.forEach((b, j) => b.classList.toggle('active', j === i)); rebuildTabs(); };
    tabBtns.push(t);
    tabBar.append(t);
  }
  body.append(tabBar, tabContent);

  // --- Nút bắt đầu ---
  const startBtn = btn('Bắt đầu!', 'gold', () => {
    const name = nameInput.value.trim();
    if (name.length < 2) { toast('Tên cần ít nhất 2 ký tự nha!', 'alert'); return; }
    S.player.name = name;
    done();
    bus.emit('charcreate:done');
  });
  startBtn.classList.add('cc-start');
  const foot = h('div', 'cc-foot');
  foot.append(startBtn);
  body.parentElement?.append(foot);

  function refreshPreview() {
    preview.innerHTML = '';
    const face = charFace(look, 100);
    // sprite chỉ vẽ 1 hướng -> lật ngang giống lúc chạy trong game (setFlipX)
    face.style.transform = faceLeft ? 'scaleX(-1)' : '';
    preview.append(face);
    turnL.classList.toggle('active', faceLeft);
    turnR.classList.toggle('active', !faceLeft);
  }

  const rebuildTabs = () => {
    tabContent.innerHTML = '';
    const chips = h('div', 'cc-opts');

    if (activeTab === 0) {
      const hairOpts = simplestList(50, look.gender, 3);
      for (const p of hairOpts) {
        const c = h('div', `cc-opt cc-opt-icon ${look.hair === p.id ? 'active' : ''}`);
        c.append(chibiPreview(p.id, 38), h('span', 'cc-opt-name', p.name));
        c.onclick = () => { look.hair = p.id; emit(); rebuild(); };
        chips.append(c);
      }
    } else if (activeTab === 1) {
      // màu mắt (bỏ các part "Mat ..." vì đó là biểu cảm, đã có hàng riêng ở trên)
      const eyeOpts = chibiList(40, look.gender)
        .filter(p => p.level === 0 && p.gold <= 0 && !/^mat\s/i.test(p.name))
        .slice(0, 6);
      for (const p of eyeOpts) {
        const c = h('div', `cc-opt cc-opt-icon ${look.eyes === p.id ? 'active' : ''}`);
        c.append(charHeadOnly({ ...look, eyes: p.id }, 32), h('span', 'cc-opt-name', p.name));
        c.onclick = () => { look.eyes = p.id; emit(); rebuild(); };
        chips.append(c);
      }
    } else {
      const shirtOpts = simplestList(20, look.gender, 3);
      const pantOpts = simplestList(10, look.gender, 3);
      if (shirtOpts.length) {
        const lbl = h('div', 'cc-mini-label cc-tab-label', 'Áo');
        tabContent.append(lbl);
        const sc = h('div', 'cc-opts');
        for (const p of shirtOpts) {
          const c = h('div', `cc-opt cc-opt-icon ${look.shirt === p.id ? 'active' : ''}`);
          c.append(chibiPreview(p.id, 38), h('span', 'cc-opt-name', p.name));
          c.onclick = () => { look.shirt = p.id; emit(); rebuild(); };
          sc.append(c);
        }
        tabContent.append(sc);
      }
      if (pantOpts.length) {
        const lbl = h('div', 'cc-mini-label cc-tab-label', 'Quần');
        tabContent.append(lbl);
        const pc = h('div', 'cc-opts');
        for (const p of pantOpts) {
          const c = h('div', `cc-opt cc-opt-icon ${look.pant === p.id ? 'active' : ''}`);
          c.append(chibiPreview(p.id, 38), h('span', 'cc-opt-name', p.name));
          c.onclick = () => { look.pant = p.id; emit(); rebuild(); };
          pc.append(c);
        }
        tabContent.append(pc);
      }
      return;
    }
    tabContent.append(chips);
  };

  const rebuild = () => {
    buildGender();
    buildExpr();
    refreshPreview();
    rebuildTabs();
  };
  rebuild();
}
