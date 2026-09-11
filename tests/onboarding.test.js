import { test, describe, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { startTestServer, createPlayer } from './helpers.js';

let server;
const steps = () => server.app.ctx.content.onboarding;

describe('Hướng dẫn người mới', () => {
  before(async () => { server = await startTestServer(); });
  after(() => server.close());

  test('nhân vật mới bắt đầu từ bước đầu tiên', async () => {
    const player = await createPlayer(server);
    const res = await server.get('/v1/onboarding', { token: player.access_token });
    assert.equal(res.body.step.step_id, steps()[0].step_id);
  });

  test('chỉ nhích khi sự kiện ĐÚNG bước đang chờ', async () => {
    const player = await createPlayer(server);
    // Client bắn sự kiện khá bừa; nhích theo bất cứ thứ gì tới là người chơi mở
    // nhầm một bảng lại nhảy mất hai bước.
    const wrong = await server.post('/v1/onboarding/report', { token: player.access_token, body: { event: 'harvest' } });
    assert.equal(wrong.body.advanced, false);
    assert.equal(wrong.body.step.step_id, steps()[0].step_id);

    const right = await server.post('/v1/onboarding/report', { token: player.access_token, body: { event: steps()[0].event } });
    assert.equal(right.body.advanced, true);
    assert.equal(right.body.step.step_id, steps()[1].step_id);
  });

  test('tiến trình giữ ở server nên đọc lại vẫn đúng bước', async () => {
    const player = await createPlayer(server);
    await server.post('/v1/onboarding/report', { token: player.access_token, body: { event: steps()[0].event } });
    const res = await server.get('/v1/onboarding', { token: player.access_token });
    assert.equal(res.body.step.step_id, steps()[1].step_id);
  });

  test('đi hết các bước thì không còn gì để hiện', async () => {
    const player = await createPlayer(server);
    for (const step of steps()) {
      await server.post('/v1/onboarding/report', { token: player.access_token, body: { event: step.event } });
    }
    const res = await server.get('/v1/onboarding', { token: player.access_token });
    assert.equal(res.body.step, null);
  });

  test('bỏ qua thì ẩn hẳn, và làm lại đúng việc cũ cũng không bật lại', async () => {
    const player = await createPlayer(server);
    await server.post('/v1/onboarding/skip', { token: player.access_token });
    assert.equal((await server.get('/v1/onboarding', { token: player.access_token })).body.step, null);
    await server.post('/v1/onboarding/report', { token: player.access_token, body: { event: steps()[0].event } });
    assert.equal((await server.get('/v1/onboarding', { token: player.access_token })).body.step, null);
  });

  test('thiếu event thì báo lỗi chứ không nhích bừa', async () => {
    const player = await createPlayer(server);
    const res = await server.post('/v1/onboarding/report', { token: player.access_token, body: {} });
    assert.equal(res.status, 400);
  });
});
