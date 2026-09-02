/**
 * Match-3 engine thuần (doc 07). Không chạm database, không phụ thuộc network
 * nên unit-test được và có thể tái dựng y hệt một trận từ seed đã lưu.
 *
 * Board là mảng phẳng theo hàng: index = y * width + x.
 * Mỗi ô: { type: <tile_id>, special: <special_id|null> }.
 */
import { createRng } from '../lib/rng.js';

export const SPECIAL = {
  LINE_H: 'sp_line_h',
  LINE_V: 'sp_line_v',
  AREA: 'sp_area',
  COLOR: 'sp_color',
};

const at = (board, x, y) => board.cells[y * board.width + x];
const inside = (board, x, y) => x >= 0 && y >= 0 && x < board.width && y < board.height;

export function createBoard({ width, height, tileTypes, seed }) {
  const rng = createRng(seed);
  const board = { width, height, tileTypes, cells: new Array(width * height).fill(null) };
  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      board.cells[y * width + x] = { type: pickSafeType(board, x, y, tileTypes, rng), special: null };
    }
  }
  // Board mở màn không được có sẵn match và phải còn ít nhất một nước đi.
  let guard = 0;
  while (!hasValidMove(board) && guard++ < 50) reshuffle(board, rng);
  return board;
}

/** Chọn tile không tạo match sẵn với hai ô liền trước theo hàng/cột. */
function pickSafeType(board, x, y, tileTypes, rng) {
  const banned = new Set();
  if (x >= 2 && at(board, x - 1, y).type === at(board, x - 2, y).type) banned.add(at(board, x - 1, y).type);
  if (y >= 2 && at(board, x, y - 1).type === at(board, x, y - 2).type) banned.add(at(board, x, y - 1).type);
  const pool = tileTypes.filter((t) => !banned.has(t));
  return pool[Math.floor(rng() * pool.length)] ?? tileTypes[0];
}

export function reshuffle(board, rng) {
  const types = board.cells.map((c) => c.type);
  for (let i = types.length - 1; i > 0; i--) {
    const j = Math.floor(rng() * (i + 1));
    [types[i], types[j]] = [types[j], types[i]];
  }
  board.cells.forEach((cell, i) => { cell.type = types[i]; });
  return board;
}

/** Các nhóm match hiện có. Mỗi nhóm: { cells:[{x,y}], type, orientation, length }. */
export function findMatches(board) {
  const groups = [];
  for (let y = 0; y < board.height; y++) {
    let run = 1;
    for (let x = 1; x <= board.width; x++) {
      const same = x < board.width && at(board, x, y).type === at(board, x - 1, y).type && at(board, x, y).type !== null;
      if (same) { run++; continue; }
      if (run >= 3) {
        groups.push({ type: at(board, x - 1, y).type, orientation: 'h', length: run,
          cells: Array.from({ length: run }, (_, i) => ({ x: x - run + i, y })) });
      }
      run = 1;
    }
  }
  for (let x = 0; x < board.width; x++) {
    let run = 1;
    for (let y = 1; y <= board.height; y++) {
      const same = y < board.height && at(board, x, y).type === at(board, x, y - 1).type && at(board, x, y).type !== null;
      if (same) { run++; continue; }
      if (run >= 3) {
        groups.push({ type: at(board, x, y - 1).type, orientation: 'v', length: run,
          cells: Array.from({ length: run }, (_, i) => ({ x, y: y - run + i })) });
      }
      run = 1;
    }
  }
  return groups;
}

const keyOf = ({ x, y }) => `${x},${y}`;

/**
 * Xác định special tile sinh ra từ các nhóm match (doc 07).
 * - run >= 5            -> sp_color
 * - giao nhau ngang+dọc -> sp_area (hình L/T)
 * - run == 4            -> sp_line_h / sp_line_v
 */
function plannedSpecials(groups, origin) {
  const specials = [];
  const horizontal = new Map();
  const vertical = new Map();
  for (const group of groups) {
    const target = group.orientation === 'h' ? horizontal : vertical;
    for (const cell of group.cells) target.set(keyOf(cell), group);
  }

  const consumed = new Set();
  for (const group of groups) {
    if (consumed.has(group)) continue;
    const anchor = group.cells.find((c) => origin && c.x === origin.x && c.y === origin.y) ?? group.cells[Math.floor(group.cells.length / 2)];
    if (group.length >= 5) {
      specials.push({ cell: anchor, special: SPECIAL.COLOR, type: group.type });
      consumed.add(group);
      continue;
    }
    const crossCell = group.cells.find((c) => horizontal.has(keyOf(c)) && vertical.has(keyOf(c)));
    if (crossCell) {
      const other = (group.orientation === 'h' ? vertical : horizontal).get(keyOf(crossCell));
      specials.push({ cell: crossCell, special: SPECIAL.AREA, type: group.type });
      consumed.add(group);
      if (other) consumed.add(other);
      continue;
    }
    if (group.length === 4) {
      specials.push({ cell: anchor, special: group.orientation === 'h' ? SPECIAL.LINE_H : SPECIAL.LINE_V, type: group.type });
      consumed.add(group);
    }
  }
  return specials;
}

/** Mở rộng tập ô bị xoá theo hiệu ứng của các special tile nằm trong đó. */
function expandSpecials(board, cleared) {
  const queue = [...cleared];
  const triggered = [];
  const seen = new Set([...cleared]);

  while (queue.length > 0) {
    const key = queue.pop();
    const [x, y] = key.split(',').map(Number);
    const cell = at(board, x, y);
    if (!cell?.special) continue;
    const special = cell.special;
    cell.special = null; // chỉ kích hoạt một lần
    triggered.push({ x, y, special });

    const add = (nx, ny) => {
      if (!inside(board, nx, ny)) return;
      const k = `${nx},${ny}`;
      if (seen.has(k)) return;
      seen.add(k);
      queue.push(k);
    };

    if (special === SPECIAL.LINE_H) for (let nx = 0; nx < board.width; nx++) add(nx, y);
    else if (special === SPECIAL.LINE_V) for (let ny = 0; ny < board.height; ny++) add(x, ny);
    else if (special === SPECIAL.AREA) {
      for (let dy = -1; dy <= 1; dy++) for (let dx = -1; dx <= 1; dx++) add(x + dx, y + dy);
    } else if (special === SPECIAL.COLOR) {
      const target = cell.type;
      for (let ny = 0; ny < board.height; ny++) {
        for (let nx = 0; nx < board.width; nx++) if (at(board, nx, ny).type === target) add(nx, ny);
      }
    }
  }
  return { cleared: seen, triggered };
}

/** Rơi xuống + refill. Trả về danh sách ô mới để client dựng animation. */
function collapse(board, rng) {
  const spawned = [];
  for (let x = 0; x < board.width; x++) {
    let write = board.height - 1;
    for (let y = board.height - 1; y >= 0; y--) {
      const cell = at(board, x, y);
      if (cell.type === null) continue;
      board.cells[write * board.width + x] = cell;
      if (write !== y) board.cells[y * board.width + x] = { type: null, special: null };
      write--;
    }
    for (let y = write; y >= 0; y--) {
      const type = board.tileTypes[Math.floor(rng() * board.tileTypes.length)];
      board.cells[y * board.width + x] = { type, special: null };
      spawned.push({ x, y, type });
    }
  }
  return spawned;
}

/**
 * Giải quyết toàn bộ chuỗi cascade sau một nước đi.
 * Trả về các "step" để client phát lại animation, cùng tổng thiệt hại/điểm.
 */
export function resolveBoard(board, rng, origin = null) {
  const steps = [];
  let totalCleared = 0;
  let score = 0;
  let cascade = 0;

  for (;;) {
    const groups = findMatches(board);
    if (groups.length === 0) break;

    const specials = plannedSpecials(groups, cascade === 0 ? origin : null);
    const protectedCells = new Set(specials.map((s) => keyOf(s.cell)));
    const base = new Set();
    for (const group of groups) for (const cell of group.cells) base.add(keyOf(cell));

    const { cleared, triggered } = expandSpecials(board, base);

    const removed = [];
    for (const key of cleared) {
      if (protectedCells.has(key)) continue;
      const [x, y] = key.split(',').map(Number);
      removed.push({ x, y, type: at(board, x, y).type });
      board.cells[y * board.width + x] = { type: null, special: null };
    }
    for (const spec of specials) {
      const cell = at(board, spec.cell.x, spec.cell.y);
      cell.type = spec.type;
      cell.special = spec.special;
    }

    cascade += 1;
    totalCleared += removed.length;
    score += removed.length * 10 * cascade;

    const spawned = collapse(board, rng);
    steps.push({ cascade, matched: removed, specials_created: specials, specials_triggered: triggered, spawned });
  }

  return { steps, cleared: totalCleared, score, cascades: cascade };
}

/** Có ít nhất một nước swap tạo được match không (doc 07 — playable state). */
export function hasValidMove(board) {
  const trySwap = (x1, y1, x2, y2) => {
    const a = at(board, x1, y1);
    const b = at(board, x2, y2);
    [a.type, b.type] = [b.type, a.type];
    const ok = findMatches(board).length > 0;
    [a.type, b.type] = [b.type, a.type];
    return ok;
  };
  for (let y = 0; y < board.height; y++) {
    for (let x = 0; x < board.width; x++) {
      if (x + 1 < board.width && trySwap(x, y, x + 1, y)) return true;
      if (y + 1 < board.height && trySwap(x, y, x, y + 1)) return true;
    }
  }
  return false;
}

export const isAdjacent = (a, b) => Math.abs(a.x - b.x) + Math.abs(a.y - b.y) === 1;

/**
 * Thực hiện một nước đi. Trả về null nếu nước đi không hợp lệ (board giữ nguyên).
 * Server dùng hàm này làm nguồn sự thật duy nhất cho kết quả nước đi (doc 22).
 */
export function applyMove(board, from, to, rng) {
  if (!inside(board, from.x, from.y) || !inside(board, to.x, to.y)) return null;
  if (!isAdjacent(from, to)) return null;

  const a = at(board, from.x, from.y);
  const b = at(board, to.x, to.y);
  [a.type, b.type] = [b.type, a.type];
  [a.special, b.special] = [b.special, a.special];

  const swapOfSpecials = a.special && b.special;
  if (findMatches(board).length === 0 && !swapOfSpecials) {
    [a.type, b.type] = [b.type, a.type];
    [a.special, b.special] = [b.special, a.special];
    return null;
  }

  const result = resolveBoard(board, rng, to);

  // Board bí thì xáo lại thay vì để người chơi kẹt (doc 07 — playable state).
  let reshuffled = false;
  let guard = 0;
  while (!hasValidMove(board) && guard++ < 50) { reshuffle(board, rng); reshuffled = true; }
  if (reshuffled) {
    const extra = resolveBoard(board, rng);
    result.steps.push(...extra.steps);
    result.cleared += extra.cleared;
    result.score += extra.score;
  }
  return { ...result, reshuffled };
}

export const serializeBoard = (board) => ({
  width: board.width,
  height: board.height,
  tile_types: board.tileTypes,
  cells: board.cells.map((c) => ({ t: c.type, s: c.special })),
});

export const deserializeBoard = (data) => ({
  width: data.width,
  height: data.height,
  tileTypes: data.tile_types,
  cells: data.cells.map((c) => ({ type: c.t, special: c.s })),
});
