import { test, describe, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { startTestServer, createPlayer } from './helpers.js';

describe('Hòm thư (doc 08)', () => {
  let server; let player; let token;
  before(async () => {
    server = await startTestServer();
    player = await createPlayer(server);
    token = player.access_token;
  });
  after(() => server.close());

  test('mở hòm thư lần đầu là nhận đủ thư hệ thống', async () => {
    const res = await server.get('/v1/mails', { token });
    assert.equal(res.status, 200);
    assert.equal(res.body.mails.length, 2);
    assert.equal(res.body.unread, 2);
    assert.equal(res.body.unclaimed, 1, 'chỉ thư chào mừng có quà');
  });

  test('mở lại KHÔNG nhân đôi thư', async () => {
    await server.get('/v1/mails', { token });
    const res = await server.get('/v1/mails', { token });
    assert.equal(res.body.mails.length, 2);
  });

  test('đánh dấu đã đọc thì số chưa đọc giảm', async () => {
    const { mails } = (await server.get('/v1/mails', { token })).body;
    const first = mails[0];
    assert.equal((await server.post(`/v1/mails/${first.mail_id}/read`, { token })).status, 200);
    const after = (await server.get('/v1/mails', { token })).body;
    assert.equal(after.unread, 1);
  });

  test('nhận quà cộng đúng một lần', async () => {
    const { mails } = (await server.get('/v1/mails', { token })).body;
    const withGift = mails.find((m) => m.has_attachments);
    const before = (await server.get('/v1/player/wallet', { token })).body;

    const claimed = await server.post(`/v1/mails/${withGift.mail_id}/claim`, { token });
    assert.equal(claimed.status, 200);
    const after = (await server.get('/v1/player/wallet', { token })).body;
    assert.equal(after.coin, before.coin + 200);

    const again = await server.post(`/v1/mails/${withGift.mail_id}/claim`, { token });
    assert.equal(again.status, 409);
    const unchanged = (await server.get('/v1/player/wallet', { token })).body;
    assert.equal(unchanged.coin, after.coin);
  });

  test('thư suông thì không có gì để nhận', async () => {
    const { mails } = (await server.get('/v1/mails', { token })).body;
    const plain = mails.find((m) => !m.has_attachments);
    const res = await server.post(`/v1/mails/${plain.mail_id}/claim`, { token });
    assert.equal(res.status, 409);
  });

  test('không đọc được thư của người khác', async () => {
    const other = await createPlayer(server);
    const { mails } = (await server.get('/v1/mails', { token })).body;
    const res = await server.post(`/v1/mails/${mails[0].mail_id}/read`, { token: other.access_token });
    assert.equal(res.status, 404);
  });

  test('chưa nhận quà thì chưa xoá được thư', async () => {
    const fresh = await createPlayer(server);
    const { mails } = (await server.get('/v1/mails', { token: fresh.access_token })).body;
    const withGift = mails.find((m) => m.has_attachments);
    assert.equal((await server.del(`/v1/mails/${withGift.mail_id}`, { token: fresh.access_token })).status, 409);

    await server.post(`/v1/mails/${withGift.mail_id}/claim`, { token: fresh.access_token });
    assert.equal((await server.del(`/v1/mails/${withGift.mail_id}`, { token: fresh.access_token })).status, 200);
    const after = (await server.get('/v1/mails', { token: fresh.access_token })).body;
    assert.equal(after.mails.length, 1);
  });

  test('thư hết hạn không hiện trong hòm thư', async () => {
    const fresh = await createPlayer(server);
    await server.get('/v1/mails', { token: fresh.access_token });
    const db = server.app.ctx.db;
    const row = db.prepare('SELECT id FROM mails WHERE character_id = ? LIMIT 1').get(fresh.character_id);
    db.prepare('UPDATE mails SET expires_at = ? WHERE id = ?').run(Date.now() - 1000, row.id);

    const after = (await server.get('/v1/mails', { token: fresh.access_token })).body;
    assert.ok(after.mails.every((m) => m.mail_id !== row.id));
  });
});
