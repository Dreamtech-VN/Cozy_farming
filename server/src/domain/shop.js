/**
 * Shop (doc 09, doc 10).
 * Client chỉ gửi entry_id + số lượng; giá, điều kiện mở khoá và giới hạn/ngày
 * đều do server tra từ content rồi trừ tiền trong một transaction.
 */
import { badRequest, conflict, notFound } from '../lib/errors.js';
import { transaction } from '../db/index.js';
import { applyChange } from './economy.js';
import { trackProgress } from './quest.js';
import { logEvent } from './analytics.js';

export function listShop(db, content, character, shopId) {
  const shop = content.byShop.get(shopId);
  if (!shop) throw notFound(`shop không tồn tại: ${shopId}`);
  return {
    shop_id: shop.shop_id,
    name_key: shop.name_key,
    entries: shop.entries.map((entry) => ({
      ...entry,
      locked: character.level < entry.unlock_level,
      bought_today: entry.limit_per_day > 0 ? countBoughtToday(db, character.id, entry.entry_id) : 0,
      name_key: entry.item_id
        ? content.byItem.get(entry.item_id)?.name_key
        : content.byAvatarItem.get(entry.avatar_item_id)?.name_key,
    })),
  };
}

const dayKey = (now = Date.now()) => new Date(now).toISOString().slice(0, 10);

function countBoughtToday(db, characterId, entryId) {
  const since = Date.parse(`${dayKey()}T00:00:00Z`);
  const row = db.prepare(`SELECT COALESCE(SUM(json_extract(payload, '$.detail.quantity')), 0) AS n
                          FROM transactions
                          WHERE character_id = ? AND kind = 'shop_purchase' AND created_at >= ?
                            AND json_extract(payload, '$.detail.entry_id') = ?`)
    .get(characterId, since, entryId);
  return Number(row?.n ?? 0);
}

export function purchase(db, content, character, { shopId, entryId, quantity = 1, idempotencyKey }) {
  const shop = content.byShop.get(shopId);
  if (!shop) throw notFound(`shop không tồn tại: ${shopId}`);
  const entry = shop.entries.find((e) => e.entry_id === entryId);
  if (!entry) throw notFound(`mặt hàng không tồn tại: ${entryId}`);

  const count = Number(quantity);
  if (!Number.isInteger(count) || count < 1 || count > 99) throw badRequest('quantity phải là số nguyên 1–99');
  if (character.level < entry.unlock_level) {
    throw conflict('Chưa đủ cấp để mua món này', { required_level: entry.unlock_level, level: character.level });
  }
  if (entry.avatar_item_id && count !== 1) throw badRequest('Cosmetic chỉ mua được 1 lần');
  if (entry.avatar_item_id) {
    const owned = db.prepare('SELECT 1 AS ok FROM character_wardrobe WHERE character_id = ? AND avatar_item_id = ?')
      .get(character.id, entry.avatar_item_id);
    if (owned) throw conflict('Bạn đã sở hữu món này');
  }
  if (entry.limit_per_day > 0 && countBoughtToday(db, character.id, entryId) + count > entry.limit_per_day) {
    throw conflict('Vượt giới hạn mua trong ngày', { limit_per_day: entry.limit_per_day });
  }

  const cost = entry.price * count;
  return transaction(db, () => {
    const change = applyChange(db, content, character.id, {
      currencies: { [entry.currency]: -cost },
      items: entry.item_id ? [{ item_id: entry.item_id, count }] : [],
      avatar_items: entry.avatar_item_id ? [entry.avatar_item_id] : [],
    }, {
      kind: 'shop_purchase',
      idempotencyKey: idempotencyKey ?? null,
      // detail nằm trong payload nên hạn mức mua/ngày đếm được mà không cần bảng riêng.
      detail: { entry_id: entryId, shop_id: shopId, quantity: count, cost, currency: entry.currency },
    });

    if (entry.item_id) trackProgress(db, content, character.id, 'buy_item', entry.item_id, count);
    logEvent(db, character.id, 'shop_purchase', { shop_id: shopId, entry_id: entryId, quantity: count, cost, currency: entry.currency });
    return { entry_id: entryId, quantity: count, cost, currency: entry.currency, transaction: change };
  });
}

/** Bán vật phẩm lấy coin — nguồn coin chính từ farming (doc 09). */
export function sellItem(db, content, character, { itemId, quantity = 1, idempotencyKey }) {
  const item = content.byItem.get(itemId);
  if (!item) throw notFound(`item không tồn tại: ${itemId}`);
  if (!(item.sell_price > 0)) throw conflict('Vật phẩm này không bán được');
  const count = Number(quantity);
  if (!Number.isInteger(count) || count < 1 || count > 999) throw badRequest('quantity phải là số nguyên 1–999');

  const gain = item.sell_price * count;
  const change = applyChange(db, content, character.id, {
    items: [{ item_id: itemId, count: -count }],
    currencies: { coin: gain },
  }, { kind: 'item_sell', idempotencyKey: idempotencyKey ?? null });
  logEvent(db, character.id, 'item_spent', { item_id: itemId, quantity: count, gain });
  return { item_id: itemId, quantity: count, gain, transaction: change };
}
