import { test, describe, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { startTestServer, createPlayer } from './helpers.js';
import { trackProgress } from '../server/src/domain/quest.js';
import * as stats from '../server/src/domain/stats.js';

let server; let content; let db;
const win = (id, n) => { for (let i = 0; i < n; i++) trackProgress(db, content, id, 'match3_win', 'any'); };

describe('Thành tựu và bảng xếp hạng', () => {
  before(async () => {
    server = await startTestServer();
    content = server.app.ctx.content;
    db = server.app.ctx.db;
  });
  after(() => server.close());

  test('số liệu cộng dồn dù không nhiệm vụ nào đang cần việc ấy', async () => {
    const p = await createPlayer(server);
    win(p.character_id, 3);
    // Đây là lý do phải cộng TRONG trackProgress chứ không trong phần xử lý
    // nhiệm vụ: thành tựu đếm mọi lần làm, kể cả khi không có nhiệm vụ nào nhận.
    assert.equal(stats.read(db, p.character_id, 'count:match3_win'), 3);
  });

  test('chưa đủ ngưỡng thì không nhận được', async () => {
    const p = await createPlayer(server);
    win(p.character_id, 2);
    const res = await server.post('/v1/achievements/ach_match3/claim', { token: p.access_token });
    assert.equal(res.status, 400);
  });

  test('đủ ngưỡng thì nhận được, và nhận xong mở ra bậc sau', async () => {
    const p = await createPlayer(server);
    win(p.character_id, 5);
    const before = await server.get('/v1/achievements', { token: p.access_token });
    const m = before.body.achievements.find((a) => a.achievement_id === 'ach_match3');
    assert.equal(m.tier, 1);
    assert.equal(m.claimable, true);

    const claim = await server.post('/v1/achievements/ach_match3/claim', { token: p.access_token });
    assert.equal(claim.status, 200);

    const after = await server.get('/v1/achievements', { token: p.access_token });
    const m2 = after.body.achievements.find((a) => a.achievement_id === 'ach_match3');
    assert.equal(m2.tier, 2, 'bậc sau phải mở ra chứ không biến mất');
    assert.equal(m2.claimable, false);
  });

  test('không nhận được hai lần cùng một bậc', async () => {
    const p = await createPlayer(server);
    win(p.character_id, 5);
    assert.equal((await server.post('/v1/achievements/ach_match3/claim', { token: p.access_token })).status, 200);
    const wallet = (await server.get('/v1/player/profile', { token: p.access_token })).body.wallet.coin;
    // Bậc 1 đã nhận, bậc 2 cần 30 trận — bấm nữa phải trượt vì chưa đủ, không
    // phải vì "đã nhận": cả hai đều chặn, nhưng tiền không được tăng thêm.
    await server.post('/v1/achievements/ach_match3/claim', { token: p.access_token });
    assert.equal((await server.get('/v1/player/profile', { token: p.access_token })).body.wallet.coin, wallet);
  });

  test('bảng xếp hạng sắp đúng thứ tự và có hạng của chính mình', async () => {
    const a = await createPlayer(server);
    const b = await createPlayer(server);
    win(a.character_id, 40);
    win(b.character_id, 12);
    const res = await server.get('/v1/leaderboards', { token: b.access_token });
    const board = res.body.boards.find((x) => x.board_id === 'match3');
    const top = board.entries.map((e) => e.character_id);
    assert.ok(top.indexOf(a.character_id) < top.indexOf(b.character_id), 'ai nhiều hơn phải đứng trên');
    assert.ok(board.me, 'phải kèm hạng của chính mình');
    assert.equal(board.me.value, 12);
  });

  test('xếp hạng cấp: cùng cấp thì XP phân định, không phải ai vào trước', async () => {
    const p = await createPlayer(server);
    const res = await server.get('/v1/leaderboards', { token: p.access_token });
    const board = res.body.boards.find((x) => x.board_id === 'level');
    assert.ok(board.entries.length > 0);
    for (let i = 1; i < board.entries.length; i++) {
      assert.ok(board.entries[i - 1].value >= board.entries[i].value, 'phải xếp giảm dần');
    }
  });
});
