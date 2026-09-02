/**
 * Economy & inventory (doc 09, doc 14, doc 22).
 * Đây là NƠI DUY NHẤT thay đổi currency và item. Mọi thay đổi:
 *  - chạy trong transaction,
 *  - ghi một dòng vào bảng transactions để audit,
 *  - hỗ trợ idempotency key nên retry của client không cấp thưởng hai lần.
 */
import { newId } from '../lib/ids.js';
import { transaction } from '../db/index.js';
import { badRequest, conflict } from '../lib/errors.js';

/** XP cần để lên cấp tiếp theo (doc 09 — level_curve). */
export function xpForLevel(curve, level) {
  return Math.round(curve.base_xp * Math.pow(curve.growth, Math.max(0, level - 1)));
}

export function getWallet(db, characterId) {
  const rows = db.prepare('SELECT currency_id, amount FROM wallets WHERE character_id = ?').all(characterId);
  return Object.fromEntries(rows.map((r) => [r.currency_id, r.amount]));
}

export function getInventory(db, characterId) {
  return db.prepare('SELECT item_id, quantity FROM inventories WHERE character_id = ? AND quantity > 0 ORDER BY item_id').all(characterId);
}

function addCurrencyRaw(db, content, characterId, currencyId, delta, now) {
  const currency = content.byCurrency.get(currencyId);
  if (!currency) throw badRequest(`currency không tồn tại: ${currencyId}`);
  const current = db.prepare('SELECT amount FROM wallets WHERE character_id = ? AND currency_id = ?').get(characterId, currencyId)?.amount ?? 0;
  const next = current + delta;
  if (next < 0) throw conflict('Không đủ tài nguyên', { currency_id: currencyId, required: -delta, available: current });
  const capped = Math.min(next, currency.cap);
  db.prepare(`INSERT INTO wallets (character_id, currency_id, amount, updated_at) VALUES (?, ?, ?, ?)
              ON CONFLICT (character_id, currency_id) DO UPDATE SET amount = excluded.amount, updated_at = excluded.updated_at`)
    .run(characterId, currencyId, capped, now);
  return capped;
}

function addItemRaw(db, content, characterId, itemId, delta, now) {
  const item = content.byItem.get(itemId);
  if (!item) throw badRequest(`item không tồn tại: ${itemId}`);
  const current = db.prepare('SELECT quantity FROM inventories WHERE character_id = ? AND item_id = ?').get(characterId, itemId)?.quantity ?? 0;
  const next = current + delta;
  if (next < 0) throw conflict('Không đủ vật phẩm', { item_id: itemId, required: -delta, available: current });
  const capped = Math.min(next, item.stack_max);
  db.prepare(`INSERT INTO inventories (character_id, item_id, quantity, updated_at) VALUES (?, ?, ?, ?)
              ON CONFLICT (character_id, item_id) DO UPDATE SET quantity = excluded.quantity, updated_at = excluded.updated_at`)
    .run(characterId, itemId, capped, now);
  return capped;
}

function addXpRaw(db, content, characterId, xp, now) {
  if (xp <= 0) return { level_up: false };
  const curve = content.economy.level_curve;
  const row = db.prepare('SELECT level, xp FROM characters WHERE id = ?').get(characterId);
  let level = row.level;
  let total = row.xp + xp;
  let levelUp = false;
  while (level < curve.max_level && total >= xpForLevel(curve, level)) {
    total -= xpForLevel(curve, level);
    level += 1;
    levelUp = true;
  }
  db.prepare('UPDATE characters SET level = ?, xp = ?, updated_at = ? WHERE id = ?').run(level, total, now, characterId);
  return { level_up: levelUp, level, xp: total };
}

/**
 * Áp dụng một grant/spend nguyên khối.
 * change = { currencies: {coin: 100, gem: -5}, items: [{item_id, count}], avatar_items: [id], xp }
 * Số âm nghĩa là trừ; thiếu tài nguyên thì toàn bộ transaction rollback.
 * meta.detail được lưu kèm vào payload để audit và để đếm hạn mức (ví dụ giới hạn mua/ngày).
 */
export function applyChange(db, content, characterId, change, meta) {
  const { kind, idempotencyKey = null, detail = null } = meta;
  const now = Date.now();

  if (idempotencyKey) {
    const existing = db.prepare('SELECT payload FROM transactions WHERE character_id = ? AND idempotency_key = ?').get(characterId, idempotencyKey);
    if (existing) return { ...JSON.parse(existing.payload), replayed: true };
  }

  return transaction(db, () => {
    const applied = { currencies: {}, items: [], avatar_items: [], xp: 0 };

    for (const [currencyId, delta] of Object.entries(change.currencies ?? {})) {
      if (!delta) continue;
      applied.currencies[currencyId] = addCurrencyRaw(db, content, characterId, currencyId, delta, now);
    }
    for (const entry of change.items ?? []) {
      if (!entry.count) continue;
      const quantity = addItemRaw(db, content, characterId, entry.item_id, entry.count, now);
      applied.items.push({ item_id: entry.item_id, delta: entry.count, quantity });
    }
    for (const avatarItemId of change.avatar_items ?? []) {
      if (!content.byAvatarItem.has(avatarItemId)) throw badRequest(`cosmetic không tồn tại: ${avatarItemId}`);
      db.prepare('INSERT OR IGNORE INTO character_wardrobe (character_id, avatar_item_id, acquired_at) VALUES (?, ?, ?)')
        .run(characterId, avatarItemId, now);
      applied.avatar_items.push(avatarItemId);
    }
    if (change.xp) applied.progression = addXpRaw(db, content, characterId, change.xp, now);

    const record = { transaction_id: newId('txn'), kind, applied, ...(detail ? { detail } : {}) };
    db.prepare('INSERT INTO transactions (id, character_id, kind, idempotency_key, payload, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)')
      .run(record.transaction_id, characterId, kind, idempotencyKey, JSON.stringify(record), 'committed', now);
    return record;
  });
}

/** Hồi energy theo thời gian (doc 09) — tính lười, chỉ khi có ai đó đọc ví. */
export function regenerateEnergy(db, content, characterId) {
  const cfg = content.economy.energy;
  const now = Date.now();
  const row = db.prepare('SELECT amount, updated_at FROM wallets WHERE character_id = ? AND currency_id = ?').get(characterId, 'energy');
  if (!row) return 0;
  if (row.amount >= cfg.soft_cap) return row.amount;
  const ticks = Math.floor((now - row.updated_at) / (cfg.regen_seconds * 1000));
  if (ticks <= 0) return row.amount;
  const amount = Math.min(cfg.soft_cap, row.amount + ticks * cfg.regen_amount);
  const consumed = row.updated_at + ticks * cfg.regen_seconds * 1000;
  db.prepare('UPDATE wallets SET amount = ?, updated_at = ? WHERE character_id = ? AND currency_id = ?')
    .run(amount, consumed, characterId, 'energy');
  return amount;
}
