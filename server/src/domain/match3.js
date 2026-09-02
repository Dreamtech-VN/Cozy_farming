/**
 * Match-3 session (doc 07 + doc 22).
 * Board sống trong database, không nằm ở client. Client chỉ gửi (from, to);
 * server xác thực nước đi, tự resolve và trả về các bước để phát animation.
 */
import { newId } from '../lib/ids.js';
import { transaction } from '../db/index.js';
import { badRequest, conflict, notFound } from '../lib/errors.js';
import { createRng, randomSeed } from '../lib/rng.js';
import { applyChange } from './economy.js';
import { trackProgress } from './quest.js';
import { logEvent } from './analytics.js';
import {
  createBoard, applyMove, serializeBoard, deserializeBoard, hasValidMove,
} from './match3_engine.js';

const publicBoard = (board) => ({
  width: board.width,
  height: board.height,
  cells: board.cells.map((c) => ({ t: c.type, s: c.special })),
});

function tileTypesFor(content, level) {
  const tier = content.difficultyTable.find((d) => d.tier === level.tier);
  return content.tileTypes.slice(0, tier.tile_type_count).map((t) => t.tile_id);
}

export function startMatch(db, content, characterId, { levelId, idempotencyKey }) {
  const level = content.byLevel.get(levelId);
  if (!level) throw notFound(`màn chơi không tồn tại: ${levelId}`);

  const character = db.prepare('SELECT level FROM characters WHERE id = ?').get(characterId);
  if (character.level < level.unlock_level) {
    throw conflict('Chưa đủ cấp để vào màn này', { required_level: level.unlock_level, level: character.level });
  }

  const active = db.prepare('SELECT id FROM matches WHERE character_id = ? AND state = \'active\'').get(characterId);
  if (active) throw conflict('Bạn đang có một trận chưa kết thúc', { match_id: active.id });

  const tier = content.difficultyTable.find((d) => d.tier === level.tier);
  const seed = randomSeed();
  const board = createBoard({
    width: level.board.width, height: level.board.height,
    tileTypes: tileTypesFor(content, level), seed,
  });
  const enemyHp = Math.round(level.enemy.hp * tier.enemy_hp_mult);
  const moves = Math.max(5, Math.round(level.moves * tier.move_mult));
  const now = Date.now();
  const matchId = newId('mt');

  return transaction(db, () => {
    // Energy là entry cost (doc 09 — sink).
    applyChange(db, content, characterId, { currencies: { energy: -level.energy_cost } },
      { kind: 'match_start', idempotencyKey });

    db.prepare(`INSERT INTO matches (id, character_id, level_id, mode, seed, state, board, moves_left, enemy_hp, turn, score, created_at, updated_at)
                VALUES (?, ?, ?, 'pve', ?, 'active', ?, ?, ?, 0, 0, ?, ?)`)
      .run(matchId, characterId, levelId, seed, JSON.stringify(serializeBoard(board)), moves, enemyHp, now, now);

    logEvent(db, characterId, 'match_start', { match_id: matchId, level_id: levelId });
    return {
      match_id: matchId,
      level_id: levelId,
      board: publicBoard(board),
      moves_left: moves,
      enemy: { ...level.enemy, hp: enemyHp, max_hp: enemyHp },
      player_hp: 100,
      turn: 0,
    };
  });
}

export function getMatch(db, content, characterId, matchId) {
  const row = db.prepare('SELECT * FROM matches WHERE id = ? AND character_id = ?').get(matchId, characterId);
  if (!row) throw notFound('Không tìm thấy trận đấu');
  const level = content.byLevel.get(row.level_id);
  return {
    match_id: row.id,
    level_id: row.level_id,
    state: row.state,
    board: publicBoard(deserializeBoard(JSON.parse(row.board))),
    moves_left: row.moves_left,
    enemy: { ...level.enemy, hp: row.enemy_hp },
    turn: row.turn,
    score: row.score,
  };
}

/**
 * Một nước đi. Damage tính từ số tile bị xoá và hệ số cascade;
 * enemy phản đòn theo attack_every_turns của level.
 */
export function playAction(db, content, characterId, matchId, action) {
  const row = db.prepare('SELECT * FROM matches WHERE id = ? AND character_id = ?').get(matchId, characterId);
  if (!row) throw notFound('Không tìm thấy trận đấu');
  if (row.state !== 'active') throw conflict('Trận đấu đã kết thúc', { state: row.state });
  if (action?.type !== 'swap') throw badRequest('action.type phải là "swap"');

  const from = action.from;
  const to = action.to;
  for (const point of [from, to]) {
    if (!Number.isInteger(point?.x) || !Number.isInteger(point?.y)) throw badRequest('toạ độ swap không hợp lệ');
  }

  const level = content.byLevel.get(row.level_id);
  const board = deserializeBoard(JSON.parse(row.board));
  // Seed theo lượt: cùng một trận + cùng một lượt luôn refill giống nhau khi audit lại.
  const rng = createRng((row.seed + row.turn * 2654435761) >>> 0);

  const result = applyMove(board, from, to, rng);
  if (!result) throw conflict('Nước đi không tạo được match');

  const damage = result.cleared * 25 + result.cascades * 40;
  const turn = row.turn + 1;
  const movesLeft = row.moves_left - 1;
  const enemyHp = Math.max(0, row.enemy_hp - damage);
  const enemyAttacks = enemyHp > 0 && turn % level.enemy.attack_every_turns === 0;
  const now = Date.now();

  let state = 'active';
  if (enemyHp === 0) state = 'won';
  else if (movesLeft <= 0) state = 'lost';

  const response = transaction(db, () => {
    db.prepare('UPDATE matches SET board = ?, moves_left = ?, enemy_hp = ?, turn = ?, score = ?, state = ?, updated_at = ? WHERE id = ?')
      .run(JSON.stringify(serializeBoard(board)), movesLeft, enemyHp, turn, row.score + result.score, state, now, matchId);

    const payload = {
      match_id: matchId,
      state,
      steps: result.steps,
      reshuffled: result.reshuffled,
      damage,
      score: row.score + result.score,
      moves_left: movesLeft,
      enemy_hp: enemyHp,
      enemy_attacked: enemyAttacks ? level.enemy.attack : 0,
      turn,
      board: publicBoard(board),
    };
    if (state !== 'active') payload.settlement = settle(db, content, characterId, row, state, turn, row.score + result.score, now);
    return payload;
  });

  return response;
}

/** Kết toán trận: cấp thưởng đúng một lần, ghi match_results, bắn quest + analytics. */
function settle(db, content, characterId, matchRow, state, turns, score, now) {
  const level = content.byLevel.get(matchRow.level_id);
  const resultId = newId('mr');
  const won = state === 'won';

  const cleared = db.prepare('SELECT 1 AS ok FROM match_results WHERE character_id = ? AND level_id = ? AND result = \'won\' LIMIT 1')
    .get(characterId, matchRow.level_id);
  const firstClear = won && !cleared;

  let rewards = { coin: 0, gem: 0, xp: 0, items: [] };
  if (won) {
    rewards = {
      coin: level.rewards.coin ?? 0,
      gem: level.first_clear_rewards && firstClear ? (level.first_clear_rewards.gem ?? 0) : 0,
      xp: level.rewards.xp ?? 0,
      items: (level.rewards.items ?? []).map((r) => ({ item_id: r.item_id, count: r.min + Math.floor(Math.random() * (r.max - r.min + 1)) })),
    };
    if (firstClear) {
      rewards.coin += level.first_clear_rewards.coin ?? 0;
      for (const item of level.first_clear_rewards.items ?? []) rewards.items.push({ item_id: item.item_id, count: item.min });
    }
  }

  const change = applyChange(db, content, characterId, {
    currencies: { coin: rewards.coin, gem: rewards.gem },
    items: rewards.items,
    xp: rewards.xp,
  }, { kind: 'match_settle', idempotencyKey: `match:${matchRow.id}` });

  db.prepare(`INSERT INTO match_results (id, match_id, character_id, level_id, result, score, turns_used, rewards, first_clear, created_at)
              VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`)
    .run(resultId, matchRow.id, characterId, matchRow.level_id, state, score, turns, JSON.stringify(rewards), firstClear ? 1 : 0, now);

  if (won) trackProgress(db, content, characterId, 'match3_win', matchRow.level_id, 1, now);
  logEvent(db, characterId, won ? 'match_win' : 'match_loss', { match_id: matchRow.id, level_id: matchRow.level_id, score, turns });

  return { result: state, first_clear: firstClear, rewards, transaction: change };
}

/** Bỏ trận (thoát giữa chừng hoặc mất kết nối quá lâu) — doc 16 disconnect policy. */
export function abandonMatch(db, content, characterId, matchId) {
  const row = db.prepare('SELECT * FROM matches WHERE id = ? AND character_id = ?').get(matchId, characterId);
  if (!row) throw notFound('Không tìm thấy trận đấu');
  if (row.state !== 'active') return { state: row.state };
  const now = Date.now();
  return transaction(db, () => {
    db.prepare('UPDATE matches SET state = \'abandoned\', updated_at = ? WHERE id = ?').run(now, matchId);
    settle(db, content, characterId, row, 'abandoned', row.turn, row.score, now);
    return { state: 'abandoned' };
  });
}

export { hasValidMove };
