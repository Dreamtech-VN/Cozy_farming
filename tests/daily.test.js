import { test, describe, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { startTestServer, createPlayer } from './helpers.js';
import { claimDaily, getDaily, dayIndex } from '../server/src/domain/daily.js';

const DAY_MS = 86_400_000;

describe('Điểm danh hằng ngày (doc 09)', () => {
  let server; let player; let token; let ctx;
  before(async () => {
    server = await startTestServer();
    player = await createPlayer(server);
    token = player.access_token;
    ctx = server.app.ctx;
  });
  after(() => server.close());

  test('chưa nhận thì báo nhận được, chuỗi bắt đầu từ 1', async () => {
    const res = await server.get('/v1/daily', { token });
    assert.equal(res.status, 200);
    assert.equal(res.body.can_claim, true);
    assert.equal(res.body.streak, 1);
    assert.equal(res.body.position, 0);
    assert.equal(res.body.cycle.length, 7);
  });

  test('nhận xong thì cộng đúng thưởng ngày 1', async () => {
    const before = (await server.get('/v1/player/wallet', { token })).body;
    const res = await server.post('/v1/daily/claim', { token });
    assert.equal(res.status, 200);
    assert.equal(res.body.day, 1);
    const after = (await server.get('/v1/player/wallet', { token })).body;
    assert.equal(after.coin, before.coin + 300);
  });

  test('nhận lần hai trong ngày bị từ chối và KHÔNG cộng thêm', async () => {
    const before = (await server.get('/v1/player/wallet', { token })).body;
    const res = await server.post('/v1/daily/claim', { token });
    assert.equal(res.status, 409);
    const after = (await server.get('/v1/player/wallet', { token })).body;
    assert.equal(after.coin, before.coin);
  });

  test('vào ngày hôm sau thì chuỗi tăng và đi tiếp trong chu kỳ', () => {
    const fresh = ctx.db.prepare('SELECT id FROM characters WHERE id = ?').get(player.character_id);
    assert.ok(fresh);
    const tomorrow = Date.now() + DAY_MS;
    const result = claimDaily(ctx.db, ctx.content, player.character_id, tomorrow);
    assert.equal(result.streak, 2);
    assert.equal(result.day, 2);
  });

  test('bỏ một ngày thì chuỗi quay về 1', () => {
    // Đang ở chuỗi 2 (nhận hôm qua theo mốc "ngày mai" ở test trên).
    const skipped = Date.now() + DAY_MS * 5;
    const result = claimDaily(ctx.db, ctx.content, player.character_id, skipped);
    assert.equal(result.streak, 1, 'nghỉ giữa chừng là mất chuỗi');
    assert.equal(result.day, 1);
  });

  test('đi hết 7 ngày liên tiếp thì vòng lại đầu chu kỳ', () => {
    const other = ctx.db.prepare('SELECT id FROM characters LIMIT 1').get().id;
    const base = Date.now() + DAY_MS * 100;
    ctx.db.prepare('DELETE FROM daily_rewards WHERE character_id = ?').run(other);

    const days = [];
    for (let i = 0; i < 8; i++) days.push(claimDaily(ctx.db, ctx.content, other, base + i * DAY_MS));
    assert.deepEqual(days.map((d) => d.day), [1, 2, 3, 4, 5, 6, 7, 1]);
    assert.equal(days[7].streak, 8, 'chuỗi vẫn đếm tiếp dù chu kỳ vòng lại');
  });

  test('ngọc chỉ rơi vào ngày 4 và ngày 7', () => {
    const cycle = ctx.content.economy.daily_rewards.cycle;
    const gemDays = cycle.filter((c) => c.currencies?.gem).map((c) => c.day);
    assert.deepEqual(gemDays, [4, 7]);
    const perWeek = cycle.reduce((sum, c) => sum + (c.currencies?.gem ?? 0), 0);
    assert.equal(perWeek, 35, 'một tuần điểm danh đủ phải ra 35 ngọc');
  });

  test('mốc ngày tính theo múi giờ trong content, không theo giờ máy chủ', () => {
    const content = ctx.content;
    const offset = content.economy.daily_rewards.timezone_offset_minutes;
    assert.equal(offset, 420, 'đang đặt theo giờ Việt Nam');
    // Ngay trước và sau nửa đêm theo múi giờ đó phải rơi vào hai ngày khác nhau.
    const midnight = Math.ceil((Date.now() + offset * 60_000) / DAY_MS) * DAY_MS - offset * 60_000;
    assert.equal(dayIndex(content, midnight - 1000) + 1, dayIndex(content, midnight + 1000));
  });

  test('người chơi mới chưa có bản ghi vẫn đọc được trạng thái', async () => {
    const rookie = await createPlayer(server);
    const state = getDaily(ctx.db, ctx.content, rookie.character_id);
    assert.equal(state.can_claim, true);
    assert.equal(state.total_claims, 0);
  });
});
