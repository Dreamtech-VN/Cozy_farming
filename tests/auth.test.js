import { test, describe, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { startTestServer, createPlayer } from './helpers.js';

describe('Auth & session (doc 22)', () => {
  let server;
  before(async () => { server = await startTestServer(); });
  after(() => server.close());

  test('đăng ký trả về access token và tạo đủ state khởi đầu', async () => {
    const player = await createPlayer(server);
    assert.ok(player.access_token);
    assert.ok(player.refresh_token);

    const profile = await server.get('/v1/player/profile', { token: player.access_token });
    assert.equal(profile.status, 200);
    assert.equal(profile.body.level, 1);
    assert.equal(profile.body.wallet.coin, 500);
    assert.equal(profile.body.wallet.gem, 20);
    assert.ok(profile.body.equipment.body, 'phải có cosmetic mặc định');

    const farm = await server.get('/v1/farm', { token: player.access_token });
    assert.equal(farm.body.plots.length, 6);
  });

  test('từ chối username trùng và mật khẩu quá ngắn', async () => {
    const player = await createPlayer(server);
    const dup = await server.post('/v1/auth/register', {
      body: { username: player.username, password: 'super-secret-1', nickname: 'Khác' },
    });
    assert.equal(dup.status, 409);

    const weak = await server.post('/v1/auth/register', {
      body: { username: 'shortpw', password: '123', nickname: 'Yếu' },
    });
    assert.equal(weak.status, 400);
    assert.equal(weak.body.error.code, 'bad_request');
  });

  test('sai mật khẩu trả 401 và không lộ thông tin tài khoản', async () => {
    const player = await createPlayer(server);
    const res = await server.post('/v1/auth/login', { body: { username: player.username, password: 'sai-mat-khau' } });
    assert.equal(res.status, 401);
    assert.equal(res.body.error.message, 'Sai tài khoản hoặc mật khẩu');
  });

  test('refresh token xoay vòng: token cũ dùng lại bị từ chối', async () => {
    const player = await createPlayer(server);
    const first = await server.post('/v1/auth/refresh', { body: { refresh_token: player.refresh_token } });
    assert.equal(first.status, 200);
    assert.notEqual(first.body.refresh_token, player.refresh_token);

    const replay = await server.post('/v1/auth/refresh', { body: { refresh_token: player.refresh_token } });
    assert.equal(replay.status, 401);
  });

  test('endpoint cần auth từ chối request không token', async () => {
    const res = await server.get('/v1/player/profile');
    assert.equal(res.status, 401);
    assert.equal(res.body.error.code, 'unauthorized');
  });

  test('logout thu hồi refresh token', async () => {
    const player = await createPlayer(server);
    await server.post('/v1/auth/logout', { body: { refresh_token: player.refresh_token } });
    const res = await server.post('/v1/auth/refresh', { body: { refresh_token: player.refresh_token } });
    assert.equal(res.status, 401);
  });
});
