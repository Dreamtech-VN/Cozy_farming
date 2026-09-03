import { test, describe, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { startTestServer, createPlayer } from './helpers.js';

describe('Đổi mật khẩu (doc 22)', () => {
  let server; let player;
  before(async () => { server = await startTestServer(); player = await createPlayer(server); });
  after(() => server.close());

  test('sai mật khẩu hiện tại thì bị từ chối', async () => {
    const res = await server.post('/v1/auth/password', {
      token: player.access_token,
      body: { current_password: 'sai-be-bet', new_password: 'mat-khau-moi-1' },
    });
    assert.equal(res.status, 403);
  });

  test('mật khẩu mới quá ngắn thì bị từ chối', async () => {
    const res = await server.post('/v1/auth/password', {
      token: player.access_token,
      body: { current_password: player.password, new_password: 'ngan' },
    });
    assert.equal(res.status, 400);
    assert.equal(res.body.error.details.min_length, 8);
  });

  test('đổi thành công thì mật khẩu cũ hết dùng được và phiên cũ bị huỷ', async () => {
    const res = await server.post('/v1/auth/password', {
      token: player.access_token,
      body: { current_password: player.password, new_password: 'mat-khau-moi-1' },
    });
    assert.equal(res.status, 200);

    const old = await server.post('/v1/auth/login', { body: { username: player.username, password: player.password } });
    assert.equal(old.status, 401);

    const fresh = await server.post('/v1/auth/login', { body: { username: player.username, password: 'mat-khau-moi-1' } });
    assert.equal(fresh.status, 200);

    // Refresh token của phiên cũ phải chết theo.
    const refreshed = await server.post('/v1/auth/refresh', { body: { refresh_token: player.refresh_token } });
    assert.equal(refreshed.status, 401);
  });
});

describe('Liên kết mạng xã hội (doc 22)', () => {
  let server; let player;
  before(async () => { server = await startTestServer(); player = await createPlayer(server); });
  after(() => server.close());

  test('mặc định chưa provider nào được cấu hình', async () => {
    const res = await server.get('/v1/account', { token: player.access_token });
    assert.equal(res.status, 200);
    assert.deepEqual(res.body.providers.map((p) => p.provider), ['google', 'facebook', 'apple']);
    assert.ok(res.body.providers.every((p) => p.configured === false && p.linked === false));
  });

  test('gắn provider chưa cấu hình thì bị từ chối, không âm thầm bỏ qua', async () => {
    const res = await server.post('/v1/account/links', {
      token: player.access_token, body: { provider: 'google', provider_user_id: 'g-1' },
    });
    assert.equal(res.status, 400);
    assert.equal(res.body.error.details.provider, 'google');
  });

  test('provider lạ bị từ chối', async () => {
    const res = await server.post('/v1/account/links', {
      token: player.access_token, body: { provider: 'myspace', provider_user_id: 'x' },
    });
    assert.equal(res.status, 400);
  });
});

describe('Liên kết khi provider đã cấu hình', () => {
  let server; let player;
  before(async () => {
    server = await startTestServer({ oauthProviders: ['google'] });
    player = await createPlayer(server);
  });
  after(() => server.close());

  test('gắn rồi gỡ được, và một tài khoản Google chỉ gắn cho một người', async () => {
    const linked = await server.post('/v1/account/links', {
      token: player.access_token, body: { provider: 'google', provider_user_id: 'google-abc' },
    });
    assert.equal(linked.status, 200);

    const account = await server.get('/v1/account', { token: player.access_token });
    const google = account.body.providers.find((p) => p.provider === 'google');
    assert.equal(google.configured, true);
    assert.equal(google.linked, true);

    const other = await createPlayer(server);
    const stolen = await server.post('/v1/account/links', {
      token: other.access_token, body: { provider: 'google', provider_user_id: 'google-abc' },
    });
    assert.equal(stolen.status, 409);

    const removed = await server.del('/v1/account/links/google', { token: player.access_token });
    assert.equal(removed.status, 200);
    const after = await server.get('/v1/account', { token: player.access_token });
    assert.equal(after.body.providers.find((p) => p.provider === 'google').linked, false);
  });
});

describe('Giftcode (doc 18 — data-driven)', () => {
  let server; let player;
  before(async () => { server = await startTestServer(); player = await createPlayer(server); });
  after(() => server.close());

  test('đổi mã hợp lệ thì được cộng thưởng', async () => {
    const before = (await server.get('/v1/player/wallet', { token: player.access_token })).body;
    const res = await server.post('/v1/giftcodes/redeem', { token: player.access_token, body: { code: 'cozy2026' } });
    assert.equal(res.status, 200, JSON.stringify(res.body));
    assert.equal(res.body.code, 'COZY2026');

    const after = (await server.get('/v1/player/wallet', { token: player.access_token })).body;
    assert.equal(after.coin, before.coin + 1000);
    assert.equal(after.gem, before.gem + 20);
  });

  test('đổi lại mã đã dùng thì bị từ chối và KHÔNG cộng thêm lần nữa', async () => {
    const before = (await server.get('/v1/player/wallet', { token: player.access_token })).body;
    const res = await server.post('/v1/giftcodes/redeem', { token: player.access_token, body: { code: 'COZY2026' } });
    assert.equal(res.status, 409);
    const after = (await server.get('/v1/player/wallet', { token: player.access_token })).body;
    assert.equal(after.coin, before.coin);
  });

  test('mã không tồn tại trả 404', async () => {
    const res = await server.post('/v1/giftcodes/redeem', { token: player.access_token, body: { code: 'KHONGCO' } });
    assert.equal(res.status, 404);
  });

  test('mã hết hạn bị từ chối', async () => {
    const { content } = server.app.ctx;
    const expired = { code: 'HETHAN', name_key: 'giftcode.expired', max_uses: 0, expires_at: Date.now() - 1000, reward: { currencies: { coin: 1 } } };
    content.byGiftcode.set('HETHAN', expired);
    const res = await server.post('/v1/giftcodes/redeem', { token: player.access_token, body: { code: 'HETHAN' } });
    assert.equal(res.status, 409);
    content.byGiftcode.delete('HETHAN');
  });

  test('hết lượt đổi toàn server thì người sau không đổi được', async () => {
    const { content } = server.app.ctx;
    content.byGiftcode.set('CHI1LUOT', { code: 'CHI1LUOT', name_key: 'giftcode.one', max_uses: 1, expires_at: null, reward: { currencies: { coin: 10 } } });

    const first = await createPlayer(server);
    const second = await createPlayer(server);
    assert.equal((await server.post('/v1/giftcodes/redeem', { token: first.access_token, body: { code: 'CHI1LUOT' } })).status, 200);
    assert.equal((await server.post('/v1/giftcodes/redeem', { token: second.access_token, body: { code: 'CHI1LUOT' } })).status, 409);

    content.byGiftcode.delete('CHI1LUOT');
  });
});
