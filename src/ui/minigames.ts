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
  toast(`Thắng! +${coins} xu`, '🏆');
  sfx.win();
}

export function registerMinigames() {

  // ================= Cờ caro (Gomoku 12x12, thắng 5) =================
  registerPanel('caro', () => {
    const N = 12;
    const { body } = openWindow('⭕ Cờ caro — bạn là X', { size: 'large' });
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
        if (lines(i, 1)) { over = true; status.textContent = '🎉 Bạn thắng!'; rewardWin(200, 'caroWins'); return; }
        if (!board.includes(0)) { over = true; status.textContent = 'Hòa!'; return; }
        const m = aiMove();
        board[m] = 2; render();
        if (lines(m, 2)) { over = true; status.textContent = '😢 Máy thắng rồi...'; sfx.lose(); }
      };
      cells.push(c);
      grid.append(c);
    }
    const reset = btn('🔄 Ván mới', 'blue', () => { board = new Array(N * N).fill(0); over = false; status.textContent = 'Lượt của bạn!'; render(); });
    const bar = h('div');
    bar.style.cssText = 'display:flex;justify-content:center;gap:10px;margin-top:8px';
    bar.append(reset);
    body.append(status, grid, bar);
  });

  // ================= Oẳn tù tì =================
  registerPanel('rps', () => {
    const { body } = openWindow('✊ Oẳn tù tì', { size: 'small' });
    addStat('daily_minigame');
    const status = h('div', 't1', 'Chọn kéo, búa hoặc bao! Thắng +50 xu');
    status.style.cssText = 'text-align:center;margin-bottom:10px';
    const show = h('div', '', '❔ vs ❔');
    show.style.cssText = 'text-align:center;font-size:44px;margin:10px 0';
    const bar = h('div');
    bar.style.cssText = 'display:flex;justify-content:center;gap:10px';
    const opts = [['✌️', 'Kéo'], ['✊', 'Búa'], ['🖐️', 'Bao']] as const;
    opts.forEach(([icon, name], i) => {
      bar.append(btn(`${icon} ${name}`, 'gold', () => {
        const ai = Math.floor(Math.random() * 3);
        show.textContent = `${icon} vs ${opts[ai][0]}`;
        if (ai === i) { status.textContent = 'Hòa! Chơi lại nào~'; return; }
        // kéo(0) thắng bao(2); búa(1) thắng kéo(0); bao(2) thắng búa(1)
        const win = (i === 0 && ai === 2) || (i === 1 && ai === 0) || (i === 2 && ai === 1);
        if (win) { status.textContent = '🎉 Bạn thắng!'; rewardWin(50, 'rpsWins'); }
        else { status.textContent = '😢 Thua rồi!'; sfx.lose(); }
      }));
    });
    body.append(status, show, bar);
  });

  // ================= Cờ tướng =================
  registerPanel('xiangqi', () => {
    const { body } = openWindow('♟️ Cờ tướng — bạn cầm Đỏ', { size: 'large' });
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
        if (isRed(captured)) { status.textContent = '😢 Mất tướng — thua rồi!'; sfx.lose(); }
        else { status.textContent = '🎉 Bắt được tướng — bạn thắng!'; rewardWin(500, 'xiangqiWins'); }
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
      if (!best) { over = true; status.textContent = '🎉 Máy hết nước đi — bạn thắng!'; rewardWin(500, 'xiangqiWins'); render(); return; }
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
    const reset = btn('🔄 Ván mới', 'blue', () => { setup(); sel = -1; legal = []; over = false; status.textContent = 'Lượt của bạn (Đỏ)'; render(); });
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
    const head = h('div', 'win-head', '✨ Tạo nhân vật');
    const bodyEl = h('div', 'cc-body');
    wrap.append(head, bodyEl);
    document.getElementById('ui-root')!.append(wrap);
    buildCharCreate(bodyEl, () => wrap.remove());
  });
}

// ===== Form tạo nhân vật =====
import { HAIR_STYLES, CLOTHES, HAIR_COLOR_NAMES, CLOTH_COLOR_NAMES } from '@/data/clothing';
import { bus, EV } from '@/core/events';

function buildCharCreate(body: HTMLElement, done: () => void) {
  const a = S.player.appearance;
  const HAIR_HEX = ['#2b2b2b', '#e6c25a', '#8a5a33', '#c49a6c', '#b3592e', '#2e8b6f', '#4caf50', '#9aa5b1', '#c6a3e0', '#2c3e70', '#f7a3c2', '#8e44ad', '#c0392b', '#39c2c9'];
  const CLOTH_HEX = ['#2b2b2b', '#3b5bdb', '#74c0fc', '#8a5a33', '#2f9e44', '#8ce99a', '#f783ac', '#9c36b5', '#e03131', '#dee2e6'];
  const emit = () => bus.emit(EV.APPEARANCE);

  const row = (label: string) => {
    const d = h('div', 'cc-row');
    d.append(h('div', 'lbl', label));
    body.append(d);
    return d;
  };

  // tên
  let r = row('📛 Tên nhân vật');
  const nameInput = h('input', 'ui-input') as HTMLInputElement;
  nameInput.placeholder = 'Nhập tên (2-12 ký tự)';
  nameInput.maxLength = 12;
  nameInput.onkeydown = e => e.stopPropagation();
  r.append(nameInput);

  // giới tính
  r = row('🚻 Giới tính');
  const gchips = h('div', 'chips');
  const genders = [['male', '👦 Nam'], ['female', '👧 Nữ']] as const;
  for (const [g, lbl] of genders) {
    const c = h('div', `chip ${S.player.gender === g ? 'active' : ''}`, lbl);
    c.onclick = () => {
      S.player.gender = g;
      // gợi ý mặc định theo giới tính (vẫn đổi thoải mái)
      if (g === 'female' && a.hairStyle === 'buzzcut') a.hairStyle = 'bob';
      gchips.querySelectorAll('.chip').forEach(x => x.classList.remove('active'));
      c.classList.add('active');
      emit();
    };
    gchips.append(c);
  }
  r.append(gchips);

  // màu da / kiểu người
  r = row('🧑 Ngoại hình');
  const skin = h('div', 'chips');
  for (let i = 0; i < 8; i++) {
    const c = h('div', `chip ${a.charIndex === i ? 'active' : ''}`, `Kiểu ${i + 1}`);
    c.onclick = () => { a.charIndex = i; skin.querySelectorAll('.chip').forEach(x => x.classList.remove('active')); c.classList.add('active'); emit(); };
    skin.append(c);
  }
  r.append(skin);

  // tóc
  r = row('💇 Kiểu tóc');
  const hchips = h('div', 'chips');
  for (const hs of HAIR_STYLES) {
    const c = h('div', `chip ${a.hairStyle === hs.id ? 'active' : ''}`, hs.name);
    c.onclick = () => { a.hairStyle = hs.id; hchips.querySelectorAll('.chip').forEach(x => x.classList.remove('active')); c.classList.add('active'); emit(); };
    hchips.append(c);
  }
  r.append(hchips);
  r.append(swatches(HAIR_HEX, a.hairColor, i => { a.hairColor = i; emit(); }, HAIR_COLOR_NAMES));

  // mắt
  r = row('👁️ Màu mắt');
  r.append(swatches(HAIR_HEX.slice(0, 10), a.eyesColor, i => { a.eyesColor = i; emit(); }));

  // đồ khởi đầu
  r = row('👕 Trang phục khởi đầu');
  const cchips = h('div', 'chips');
  for (const cl of CLOTHES.filter(x => x.price === 0 || ['overalls', 'dress', 'stripe'].includes(x.id))) {
    const c = h('div', `chip ${a.clothes === cl.id ? 'active' : ''}`, cl.name);
    c.onclick = () => {
      a.clothes = cl.id;
      if (!S.wardrobe.includes(`clothes:${cl.id}`)) S.wardrobe.push(`clothes:${cl.id}`);
      cchips.querySelectorAll('.chip').forEach(x => x.classList.remove('active'));
      c.classList.add('active');
      emit();
    };
    cchips.append(c);
  }
  r.append(cchips);
  r.append(swatches(CLOTH_HEX, a.clothesColor, i => { a.clothesColor = i; emit(); }, CLOTH_COLOR_NAMES));

  const start = btn('🌾 BẮT ĐẦU CUỘC SỐNG MỚI!', 'gold', () => {
    const name = nameInput.value.trim();
    if (name.length < 2) { toast('Tên cần ít nhất 2 ký tự nha!', '📛'); return; }
    S.player.name = name;
    if (!S.wardrobe.includes(`hair:${a.hairStyle}`)) S.wardrobe.push(`hair:${a.hairStyle}`);
    done();
    bus.emit('charcreate:done');
  });
  start.style.cssText = 'width:100%;padding:14px;font-size:16px;margin-top:6px';
  body.append(start);

  function swatches(hex: string[], active: number, onPick: (i: number) => void, names?: string[]): HTMLElement {
    const wrap = h('div', 'swatches');
    wrap.style.marginTop = '5px';
    hex.forEach((c, i) => {
      const s = h('div', `sw ${active === i ? 'active' : ''}`);
      s.style.background = c;
      s.title = names?.[i] ?? '';
      s.onclick = () => { onPick(i); wrap.querySelectorAll('.sw').forEach(x => x.classList.remove('active')); s.classList.add('active'); };
      wrap.append(s);
    });
    return wrap;
  }
}
