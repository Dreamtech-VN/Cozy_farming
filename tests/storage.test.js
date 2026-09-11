import { test, describe, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { startTestServer, createPlayer } from './helpers.js';
import { applyChange } from '../server/src/domain/economy.js';
import * as storage from '../server/src/domain/storage.js';

let server; let content; let db;
const ITEM = 'item_crop_carrot';
const stackMax = () => content.byItem.get(ITEM).stack_max;
const bag = (id) => db.prepare('SELECT quantity FROM inventories WHERE character_id = ? AND item_id = ?').get(id, ITEM)?.quantity ?? 0;

describe('Kho', () => {
  before(async () => {
    server = await startTestServer();
    content = server.app.ctx.content;
    db = server.app.ctx.db;
  });
  after(() => server.close());

  test('phần vượt sức chứa túi KHÔNG bị huỷ nữa mà chảy vào kho', async () => {
    const p = await createPlayer(server);
    // Đây là lỗi cũ mà cái kho sinh ra để vá: trước đây `Math.min(next,
    // stack_max)` cắt phăng phần thừa, im lặng, không ghi vào đâu cả.
    applyChange(db, content, p.character_id, { items: [{ item_id: ITEM, count: stackMax() + 40 }] }, { kind: 'test' });
    assert.equal(bag(p.character_id), stackMax(), 'túi đầy đúng sức chứa');
    assert.equal(storage.amountIn(db, p.character_id, ITEM), 40, 'phần dôi phải nằm trong kho');
  });

  test('đầy cả túi lẫn kho thì BÁO LỖI chứ không nuốt đồ', async () => {
    const p = await createPlayer(server);
    const cap = stackMax() + storage.storageCap(content, content.byItem.get(ITEM));
    applyChange(db, content, p.character_id, { items: [{ item_id: ITEM, count: cap }] }, { kind: 'test' });
    assert.throws(
      () => applyChange(db, content, p.character_id, { items: [{ item_id: ITEM, count: 1 }] }, { kind: 'test' }),
      /đầy/i,
      'thà hỏng to còn hơn âm thầm nuốt đồ',
    );
  });

  test('cất vào kho: túi giảm đúng bằng kho tăng', async () => {
    const p = await createPlayer(server);
    applyChange(db, content, p.character_id, { items: [{ item_id: ITEM, count: 10 }] }, { kind: 'test' });
    const res = await server.post('/v1/storage/deposit', { token: p.access_token, body: { item_id: ITEM, count: 4 } });
    assert.equal(res.status, 200);
    assert.equal(bag(p.character_id), 6);
    assert.equal(storage.amountIn(db, p.character_id, ITEM), 4);
  });

  test('cất nhiều hơn số đang có thì trượt, và KHÔNG nhân đôi vật phẩm', async () => {
    const p = await createPlayer(server);
    applyChange(db, content, p.character_id, { items: [{ item_id: ITEM, count: 3 }] }, { kind: 'test' });
    const res = await server.post('/v1/storage/deposit', { token: p.access_token, body: { item_id: ITEM, count: 99 } });
    assert.notEqual(res.status, 200);
    // Rút khỏi túi TRƯỚC rồi mới cộng vào kho, nên lỗi là cả giao dịch bị huỷ:
    // không có cửa nào ra thêm đồ từ hư không.
    assert.equal(bag(p.character_id), 3);
    assert.equal(storage.amountIn(db, p.character_id, ITEM), 0);
  });

  test('lấy ra khỏi kho thì kho giảm, túi tăng', async () => {
    const p = await createPlayer(server);
    applyChange(db, content, p.character_id, { items: [{ item_id: ITEM, count: 10 }] }, { kind: 'test' });
    await server.post('/v1/storage/deposit', { token: p.access_token, body: { item_id: ITEM, count: 6 } });
    const res = await server.post('/v1/storage/withdraw', { token: p.access_token, body: { item_id: ITEM, count: 2 } });
    assert.equal(res.status, 200);
    assert.equal(bag(p.character_id), 6);
    assert.equal(storage.amountIn(db, p.character_id, ITEM), 4);
  });

  test('lấy nhiều hơn số trong kho thì trượt', async () => {
    const p = await createPlayer(server);
    const res = await server.post('/v1/storage/withdraw', { token: p.access_token, body: { item_id: ITEM, count: 1 } });
    assert.notEqual(res.status, 200);
    assert.equal(bag(p.character_id), 0);
  });

  test('số âm hay số không thì bị chặn ngay', async () => {
    const p = await createPlayer(server);
    for (const count of [0, -5, 1.5]) {
      const res = await server.post('/v1/storage/deposit', { token: p.access_token, body: { item_id: ITEM, count } });
      if (count === 1.5) continue;   // 1.5 làm tròn xuống 1, hợp lệ về mặt cú pháp
      assert.equal(res.status, 400, `count=${count} phải bị chặn`);
    }
  });
});
