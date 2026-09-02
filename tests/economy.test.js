import { test, describe, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { startTestServer, createPlayer, grant } from './helpers.js';
import { applyChange, xpForLevel } from '../server/src/domain/economy.js';

describe('Economy & shop (doc 09/10, doc 20 — purchase grant, inventory transaction)', () => {
  let server; let player; let token;
  before(async () => {
    server = await startTestServer();
    player = await createPlayer(server);
    token = player.access_token;
  });
  after(() => server.close());

  test('mua hàng trừ đúng tiền và cộng đúng item', async () => {
    await grant(server, player.character_id, { currencies: { coin: 1000 } });
    const before = (await server.get('/v1/player/wallet', { token })).body;

    const res = await server.post('/v1/shops/shop_seed/purchase', { token, body: { entry_id: 'se_carrot', quantity: 3 } });
    assert.equal(res.status, 200);
    assert.equal(res.body.cost, 12);

    const after = (await server.get('/v1/player/wallet', { token })).body;
    assert.equal(after.coin, before.coin - 12);

    const inv = (await server.get('/v1/player/inventory', { token })).body;
    assert.equal(inv.items.find((i) => i.item_id === 'item_seed_carrot').quantity, 8); // 5 khởi đầu + 3
  });

  test('không đủ tiền thì giao dịch rollback hoàn toàn', async () => {
    const broke = await createPlayer(server);
    const wallet = (await server.get('/v1/player/wallet', { token: broke.access_token })).body;
    await grant(server, broke.character_id, { currencies: { coin: -wallet.coin } });

    const res = await server.post('/v1/shops/shop_seed/purchase', { token: broke.access_token, body: { entry_id: 'se_carrot', quantity: 1 } });
    assert.equal(res.status, 409);

    const inv = (await server.get('/v1/player/inventory', { token: broke.access_token })).body;
    assert.equal(inv.items.find((i) => i.item_id === 'item_seed_carrot').quantity, 5, 'không được cộng item khi thanh toán thất bại');
  });

  test('cùng idempotency key chỉ trừ tiền một lần', async () => {
    await grant(server, player.character_id, { currencies: { coin: 1000 } });
    const before = (await server.get('/v1/player/wallet', { token })).body;
    const key = 'buy-once-123';

    const first = await server.post('/v1/shops/shop_seed/purchase', { token, body: { entry_id: 'se_turnip', quantity: 2 }, headers: { 'idempotency-key': key } });
    const second = await server.post('/v1/shops/shop_seed/purchase', { token, body: { entry_id: 'se_turnip', quantity: 2 }, headers: { 'idempotency-key': key } });
    assert.equal(first.status, 200);
    assert.equal(second.status, 200);
    assert.equal(second.body.transaction.replayed, true);

    const after = (await server.get('/v1/player/wallet', { token })).body;
    assert.equal(after.coin, before.coin - 12, 'chỉ được trừ tiền cho lần đầu');
  });

  test('không mua được món chưa đủ cấp', async () => {
    const res = await server.post('/v1/shops/shop_seed/purchase', { token, body: { entry_id: 'se_watermelon', quantity: 1 } });
    assert.equal(res.status, 409);
    assert.equal(res.body.error.details.required_level, 9);
  });

  test('cosmetic đã sở hữu không mua lại được', async () => {
    await grant(server, player.character_id, { currencies: { coin: 5000 } });
    server.app.ctx.db.prepare('UPDATE characters SET level = 5 WHERE id = ?').run(player.character_id);
    const first = await server.post('/v1/shops/shop_cosmetic/purchase', { token, body: { entry_id: 'co_hair03' } });
    assert.equal(first.status, 200);
    const again = await server.post('/v1/shops/shop_cosmetic/purchase', { token, body: { entry_id: 'co_hair03' } });
    assert.equal(again.status, 409);
  });

  test('giới hạn mua theo ngày được tôn trọng', async () => {
    const buyer = await createPlayer(server);
    await grant(server, buyer.character_id, { currencies: { coin: 100000 } });
    let lastStatus = 200;
    for (let i = 0; i < 11; i++) {
      const res = await server.post('/v1/shops/shop_general/purchase', { token: buyer.access_token, body: { entry_id: 'ge_snack', quantity: 1 } });
      lastStatus = res.status;
    }
    assert.equal(lastStatus, 409, 'lần thứ 11 phải bị chặn (limit 10/ngày)');
  });

  test('bán vật phẩm cộng coin và trừ item', async () => {
    await grant(server, player.character_id, { items: [{ item_id: 'item_crop_carrot', count: 10 }] });
    const before = (await server.get('/v1/player/wallet', { token })).body;
    const res = await server.post('/v1/shops/sell', { token, body: { item_id: 'item_crop_carrot', quantity: 4 } });
    assert.equal(res.status, 200);
    assert.equal(res.body.gain, 48);
    const after = (await server.get('/v1/player/wallet', { token })).body;
    assert.equal(after.coin, before.coin + 48);
  });

  test('không bán được nhiều hơn số đang có', async () => {
    const res = await server.post('/v1/shops/sell', { token, body: { item_id: 'item_crop_moon_lotus', quantity: 5 } });
    assert.equal(res.status, 409);
  });

  test('cấp xp đủ ngưỡng thì lên cấp', async () => {
    const { ctx } = server.app;
    const rookie = await createPlayer(server);
    const need = xpForLevel(ctx.content.economy.level_curve, 1);
    const result = applyChange(ctx.db, ctx.content, rookie.character_id, { xp: need }, { kind: 'test_xp' });
    assert.equal(result.applied.progression.level, 2);
    assert.equal(result.applied.progression.level_up, true);
  });

  test('currency không vượt quá cap trong content', async () => {
    const { ctx } = server.app;
    const whale = await createPlayer(server);
    const cap = ctx.content.byCurrency.get('energy').cap;
    applyChange(ctx.db, ctx.content, whale.character_id, { currencies: { energy: cap * 10 } }, { kind: 'test_cap' });
    const wallet = (await server.get('/v1/player/wallet', { token: whale.access_token })).body;
    assert.equal(wallet.energy, cap);
  });
});
