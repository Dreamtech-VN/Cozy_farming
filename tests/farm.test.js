import { test, describe, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { startTestServer, createPlayer, grant, makeCropReady } from './helpers.js';

describe('Farming (doc 06, doc 20 — farm harvest)', () => {
  let server; let player; let token;
  before(async () => {
    server = await startTestServer();
    player = await createPlayer(server);
    token = player.access_token;
  });
  after(() => server.close());

  test('gieo hạt trừ đúng 1 hạt và đặt mốc thời gian chín', async () => {
    const farm = await server.get('/v1/farm', { token });
    const plot = farm.body.plots[0];

    const before = await server.get('/v1/player/inventory', { token });
    const seedsBefore = before.body.items.find((i) => i.item_id === 'item_seed_carrot').quantity;

    const res = await server.post('/v1/farm/plant', { token, body: { plot_id: plot.plot_id, crop_id: 'crop_carrot' } });
    assert.equal(res.status, 200);
    assert.equal(res.body.plot.state, 'growing');
    assert.ok(res.body.plot.seconds_left > 0);

    const after = await server.get('/v1/player/inventory', { token });
    const seedsAfter = after.body.items.find((i) => i.item_id === 'item_seed_carrot').quantity;
    assert.equal(seedsAfter, seedsBefore - 1);
  });

  test('không thu hoạch được khi cây chưa chín', async () => {
    const farm = await server.get('/v1/farm', { token });
    const plot = farm.body.plots.find((p) => p.state === 'growing');
    const res = await server.post('/v1/farm/harvest', { token, body: { plot_id: plot.plot_id } });
    assert.equal(res.status, 409);
    assert.ok(res.body.error.details.seconds_left > 0);
  });

  test('thu hoạch cấp item + xp và trả ô đất về trạng thái trống', async () => {
    const farm = await server.get('/v1/farm', { token });
    const plot = farm.body.plots.find((p) => p.state === 'growing');
    makeCropReady(server, plot.plot_id);

    const res = await server.post('/v1/farm/harvest', { token, body: { plot_id: plot.plot_id } });
    assert.equal(res.status, 200);
    assert.equal(res.body.crop_id, 'crop_carrot');
    assert.ok(res.body.harvested[0].count >= 1);

    const after = await server.get('/v1/farm', { token });
    const same = after.body.plots.find((p) => p.plot_id === plot.plot_id);
    assert.equal(same.state, 'empty');
  });

  test('retry thu hoạch không cấp thưởng hai lần (idempotency)', async () => {
    const farm = await server.get('/v1/farm', { token });
    const plot = farm.body.plots.find((p) => p.state === 'empty');
    await server.post('/v1/farm/plant', { token, body: { plot_id: plot.plot_id, crop_id: 'crop_carrot' } });
    makeCropReady(server, plot.plot_id);

    const key = 'harvest-retry-1';
    const first = await server.post('/v1/farm/harvest', { token, body: { plot_id: plot.plot_id }, headers: { 'idempotency-key': key } });
    assert.equal(first.status, 200);
    const gained = first.body.harvested[0].count;

    const inventoryAfterFirst = await server.get('/v1/player/inventory', { token });
    const qty = inventoryAfterFirst.body.items.find((i) => i.item_id === 'item_crop_carrot').quantity;

    // Trồng lại rồi retry với CÙNG idempotency key: server không được cộng thêm lần nữa.
    await server.post('/v1/farm/plant', { token, body: { plot_id: plot.plot_id, crop_id: 'crop_carrot' } });
    makeCropReady(server, plot.plot_id);
    const replay = await server.post('/v1/farm/harvest', { token, body: { plot_id: plot.plot_id }, headers: { 'idempotency-key': key } });
    assert.equal(replay.status, 200);

    const inventoryAfterReplay = await server.get('/v1/player/inventory', { token });
    const qty2 = inventoryAfterReplay.body.items.find((i) => i.item_id === 'item_crop_carrot').quantity;
    assert.equal(qty2, qty, `replay không được cộng thêm (đã nhận ${gained})`);
  });

  test('không gieo được cây chưa mở khoá theo cấp nông trại', async () => {
    await grant(server, player.character_id, { items: [{ item_id: 'item_seed_watermelon', count: 1 }] });
    const farm = await server.get('/v1/farm', { token });
    const plot = farm.body.plots.find((p) => p.state === 'empty');
    const res = await server.post('/v1/farm/plant', { token, body: { plot_id: plot.plot_id, crop_id: 'crop_watermelon' } });
    assert.equal(res.status, 409);
    assert.equal(res.body.error.details.required_farm_level, 9);
  });

  test('không gieo được khi hết hạt', async () => {
    const farm = await server.get('/v1/farm', { token });
    const plot = farm.body.plots.find((p) => p.state === 'empty');
    // Xả sạch hạt cà rốt trước.
    const inv = await server.get('/v1/player/inventory', { token });
    const carrot = inv.body.items.find((i) => i.item_id === 'item_seed_carrot');
    if (carrot) await grant(server, player.character_id, { items: [{ item_id: 'item_seed_carrot', count: -carrot.quantity }] });

    const res = await server.post('/v1/farm/plant', { token, body: { plot_id: plot.plot_id, crop_id: 'crop_carrot' } });
    assert.equal(res.status, 409);
    assert.equal(res.body.error.details.item_id, 'item_seed_carrot');
  });

  test('không thao tác được lên ô đất của người khác', async () => {
    const other = await createPlayer(server);
    const farm = await server.get('/v1/farm', { token });
    const plot = farm.body.plots[0];
    const res = await server.post('/v1/farm/plant', {
      token: other.access_token,
      body: { plot_id: plot.plot_id, crop_id: 'crop_carrot' },
    });
    assert.equal(res.status, 404);
  });

  test('mở rộng ô đất trừ coin và tăng plot_count', async () => {
    const rich = await createPlayer(server);
    await grant(server, rich.character_id, { currencies: { coin: 5000 } });
    server.app.ctx.db.prepare('UPDATE farms SET level = 3 WHERE character_id = ?').run(rich.character_id);

    const before = await server.get('/v1/farm', { token: rich.access_token });
    const res = await server.post('/v1/farm/expand', { token: rich.access_token });
    assert.equal(res.status, 200);
    assert.equal(res.body.plot_count, 8);

    const after = await server.get('/v1/farm', { token: rich.access_token });
    assert.equal(after.body.plots.length, before.body.plots.length + 2);
  });
});
