import { test, describe, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { startTestServer, createPlayer, grant } from './helpers.js';
import { createBoard, findMatches, hasValidMove, applyMove, resolveBoard, SPECIAL } from '../server/src/domain/match3_engine.js';
import { createRng } from '../server/src/lib/rng.js';

describe('Match-3 engine (doc 07)', () => {
  const tileTypes = ['t_a', 't_b', 't_c', 't_d', 't_e'];

  test('board sinh ra không có match sẵn và luôn còn nước đi', () => {
    for (let seed = 1; seed <= 100; seed++) {
      const board = createBoard({ width: 8, height: 8, tileTypes, seed });
      assert.equal(findMatches(board).length, 0, `seed ${seed} có match sẵn`);
      assert.ok(hasValidMove(board), `seed ${seed} không còn nước đi`);
    }
  });

  test('swap không tạo match bị từ chối và board giữ nguyên', () => {
    const board = createBoard({ width: 8, height: 8, tileTypes, seed: 42 });
    const snapshot = board.cells.map((c) => c.type).join(',');
    // Tìm một cặp swap không tạo match.
    let rejected = 0;
    for (let y = 0; y < 8 && rejected === 0; y++) {
      for (let x = 0; x < 7; x++) {
        const result = applyMove(board, { x, y }, { x: x + 1, y }, createRng(1));
        if (result === null) { rejected++; break; }
      }
    }
    assert.ok(rejected > 0, 'phải có ít nhất một swap không hợp lệ');
    assert.equal(board.cells.map((c) => c.type).join(','), snapshot, 'board không được đổi sau swap bị từ chối');
  });

  test('swap không kề nhau luôn bị từ chối', () => {
    const board = createBoard({ width: 8, height: 8, tileTypes, seed: 7 });
    assert.equal(applyMove(board, { x: 0, y: 0 }, { x: 5, y: 5 }, createRng(1)), null);
    assert.equal(applyMove(board, { x: 0, y: 0 }, { x: 0, y: 2 }, createRng(1)), null);
  });

  test('match 4 sinh line special, match 5 sinh color special', () => {
    const make = (rows) => ({
      width: rows[0].length, height: rows.length, tileTypes,
      cells: rows.flatMap((row) => [...row].map((ch) => ({ type: `t_${ch}`, special: null }))),
    });

    // Kéo 'a' từ (1,3) xuống (1,4) để hàng 4 thành a a a a -> sp_line_h.
    const board4 = make([
      'bcbcbc',
      'cbcbcb',
      'bcbcbc',
      'cacbcb',
      'abaadd',
      'cbcbcb',
    ]);
    assert.equal(findMatches(board4).length, 0, 'fixture không được có match sẵn');
    const moved4 = applyMove(board4, { x: 1, y: 4 }, { x: 1, y: 3 }, createRng(3));
    assert.ok(moved4, 'nước đi phải hợp lệ');
    const created4 = moved4.steps.flatMap((s) => s.specials_created);
    assert.ok(created4.some((s) => s.special === SPECIAL.LINE_H), 'match 4 ngang phải tạo sp_line_h');

    // Kéo 'a' từ (2,3) xuống (2,4) để hàng 4 thành a a a a a -> sp_color.
    const board5 = make([
      'bcbcbcb',
      'cbcbcbc',
      'bcbcbcb',
      'cbacbcb',
      'aabaade',
      'cbcbcbc',
    ]);
    assert.equal(findMatches(board5).length, 0, 'fixture không được có match sẵn');
    const moved5 = applyMove(board5, { x: 2, y: 4 }, { x: 2, y: 3 }, createRng(3));
    assert.ok(moved5, 'nước đi phải hợp lệ');
    const created5 = moved5.steps.flatMap((s) => s.specials_created);
    assert.ok(created5.some((s) => s.special === SPECIAL.COLOR), 'match 5 phải tạo sp_color');
  });

  test('cascade cộng dồn điểm theo bậc', () => {
    const board = createBoard({ width: 8, height: 8, tileTypes, seed: 11 });
    const rng = createRng(5);
    let played = null;
    outer: for (let y = 0; y < 8; y++) {
      for (let x = 0; x < 7; x++) {
        played = applyMove(board, { x, y }, { x: x + 1, y }, rng);
        if (played) break outer;
      }
    }
    assert.ok(played);
    assert.ok(played.cleared >= 3, 'ít nhất 3 tile bị xoá');
    assert.ok(played.score > 0);
    assert.equal(findMatches(board).length, 0, 'sau khi resolve không còn match tồn đọng');
  });

  test('board đầy sau mỗi lần resolve (không còn ô trống)', () => {
    const board = createBoard({ width: 8, height: 8, tileTypes, seed: 23 });
    const rng = createRng(9);
    for (let i = 0; i < 30; i++) {
      outer: for (let y = 0; y < 8; y++) {
        for (let x = 0; x < 7; x++) if (applyMove(board, { x, y }, { x: x + 1, y }, rng)) break outer;
      }
      assert.ok(board.cells.every((c) => c.type !== null), `lượt ${i} còn ô trống`);
    }
  });
});

describe('Match-3 session (doc 20 — match result)', () => {
  let server; let player; let token;
  before(async () => {
    server = await startTestServer();
    player = await createPlayer(server);
    token = player.access_token;
    await grant(server, player.character_id, { currencies: { energy: 100 } });
  });
  after(() => server.close());

  test('bắt đầu trận trừ energy và trả về board', async () => {
    const wallet = await server.get('/v1/player/wallet', { token });
    const res = await server.post('/v1/matches', { token, body: { level_id: 'm3_pve_001' } });
    assert.equal(res.status, 201);
    assert.equal(res.body.board.cells.length, 64);
    assert.ok(res.body.moves_left > 0);

    const after = await server.get('/v1/player/wallet', { token });
    assert.equal(after.body.energy, wallet.body.energy - 5);
  });

  test('không mở được hai trận cùng lúc', async () => {
    const res = await server.post('/v1/matches', { token, body: { level_id: 'm3_pve_001' } });
    assert.equal(res.status, 409);
  });

  test('nước đi không hợp lệ bị server từ chối, không tốn lượt', async () => {
    const active = server.app.ctx.db.prepare('SELECT * FROM matches WHERE character_id = ? AND state = \'active\'').get(player.character_id);
    const before = await server.get(`/v1/matches/${active.id}`, { token });
    const res = await server.post(`/v1/matches/${active.id}/actions`, {
      token, body: { action: { type: 'swap', from: { x: 0, y: 0 }, to: { x: 7, y: 7 } } },
    });
    assert.equal(res.status, 409);
    const after = await server.get(`/v1/matches/${active.id}`, { token });
    assert.equal(after.body.moves_left, before.body.moves_left);
  });

  test('không chơi được trận của người khác', async () => {
    const other = await createPlayer(server);
    const active = server.app.ctx.db.prepare('SELECT id FROM matches WHERE character_id = ? AND state = \'active\'').get(player.character_id);
    const res = await server.get(`/v1/matches/${active.id}`, { token: other.access_token });
    assert.equal(res.status, 404);
  });

  test('thắng trận cấp thưởng đúng một lần và ghi match_results', async () => {
    const db = server.app.ctx.db;
    const active = db.prepare('SELECT * FROM matches WHERE character_id = ? AND state = \'active\'').get(player.character_id);
    // Đặt enemy còn 1 HP để nước đi hợp lệ tiếp theo kết thúc trận.
    db.prepare('UPDATE matches SET enemy_hp = 1 WHERE id = ?').run(active.id);

    const walletBefore = (await server.get('/v1/player/wallet', { token })).body;
    let finished = null;
    outer: for (let y = 0; y < 8; y++) {
      for (let x = 0; x < 7; x++) {
        const res = await server.post(`/v1/matches/${active.id}/actions`, {
          token, body: { action: { type: 'swap', from: { x, y }, to: { x: x + 1, y } } },
        });
        if (res.status === 200) { finished = res.body; break outer; }
      }
    }
    assert.ok(finished, 'phải tìm được một nước đi hợp lệ');
    assert.equal(finished.state, 'won');
    assert.equal(finished.settlement.result, 'won');
    assert.equal(finished.settlement.first_clear, true);

    const walletAfter = (await server.get('/v1/player/wallet', { token })).body;
    assert.ok(walletAfter.coin > walletBefore.coin, 'phải được cộng coin');

    const results = db.prepare('SELECT * FROM match_results WHERE character_id = ?').all(player.character_id);
    assert.equal(results.length, 1);

    // Trận đã kết thúc thì không nhận thêm action nào nữa.
    const replay = await server.post(`/v1/matches/${active.id}/actions`, {
      token, body: { action: { type: 'swap', from: { x: 0, y: 0 }, to: { x: 1, y: 0 } } },
    });
    assert.equal(replay.status, 409);
  });

  test('không vào được màn chưa đủ cấp', async () => {
    const rookie = await createPlayer(server);
    await grant(server, rookie.character_id, { currencies: { energy: 100 } });
    const res = await server.post('/v1/matches', { token: rookie.access_token, body: { level_id: 'm3_pve_005' } });
    assert.equal(res.status, 409);
    assert.equal(res.body.error.details.required_level, 9);
  });

  test('không đủ energy thì không vào được trận', async () => {
    const tired = await createPlayer(server);
    const wallet = (await server.get('/v1/player/wallet', { token: tired.access_token })).body;
    await grant(server, tired.character_id, { currencies: { energy: -wallet.energy } });
    const res = await server.post('/v1/matches', { token: tired.access_token, body: { level_id: 'm3_pve_001' } });
    assert.equal(res.status, 409);
    assert.equal(res.body.error.details.currency_id, 'energy');
  });
});
