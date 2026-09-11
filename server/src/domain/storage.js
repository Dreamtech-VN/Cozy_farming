/**
 * Kho: chỗ chứa thứ hai, hứng phần vượt sức chứa của túi.
 *
 * Lý do có nó không phải "game nào cũng có kho", mà là một lỗi thật: trước đây
 * `addItemRaw` cắt phăng phần quá `stack_max` đi. Thu hoạch vào chồng đã đầy là
 * mất trắng số dôi ra, im lặng, không ghi vào đâu. Từ nay phần dôi chảy vào kho,
 * và đầy cả kho thì BÁO LỖI — thà hỏng to còn hơn âm thầm nuốt đồ của người
 * chơi, vì hỏng to thì còn biết mà sửa.
 */
import { badRequest, conflict } from '../lib/errors.js';

/** Sức chứa kho cho một loại vật phẩm. */
export const storageCap = (content, item) =>
  item.stack_max * (content.economy.storage?.stack_multiplier ?? 10);

export function list(db, content, characterId) {
  const rows = db.prepare('SELECT item_id, quantity FROM character_storage WHERE character_id = ? AND quantity > 0')
    .all(characterId);
  return rows.map((row) => ({
    item_id: row.item_id,
    quantity: row.quantity,
    capacity: storageCap(content, content.byItem.get(row.item_id) ?? { stack_max: 0 }),
  }));
}

export const amountIn = (db, characterId, itemId) =>
  db.prepare('SELECT quantity FROM character_storage WHERE character_id = ? AND item_id = ?')
    .get(characterId, itemId)?.quantity ?? 0;

/**
 * Cộng vào kho. Trả về phần KHÔNG nhét được — chỗ gọi phải xử lý, không được lờ.
 *
 * Cố tình trả về phần thừa thay vì tự ném lỗi: chỗ gọi biết rõ hơn nên làm gì
 * với nó (phép cộng vật phẩm thì ném lỗi, người chơi tự cất thì báo "kho đầy").
 */
export function add(db, content, characterId, itemId, count, now = Date.now()) {
  const item = content.byItem.get(itemId);
  if (!item) throw badRequest(`item không tồn tại: ${itemId}`);
  const cap = storageCap(content, item);
  const current = amountIn(db, characterId, itemId);
  const room = Math.max(0, cap - current);
  const stored = Math.min(count, room);
  if (stored > 0) {
    db.prepare(`INSERT INTO character_storage (character_id, item_id, quantity, updated_at) VALUES (?, ?, ?, ?)
                ON CONFLICT (character_id, item_id) DO UPDATE SET quantity = quantity + excluded.quantity, updated_at = excluded.updated_at`)
      .run(characterId, itemId, stored, now);
  }
  return { stored, overflow: count - stored };
}

/** Bớt khỏi kho. Ném lỗi nếu không đủ — không bao giờ để số âm. */
export function take(db, characterId, itemId, count, now = Date.now()) {
  const current = amountIn(db, characterId, itemId);
  if (current < count) throw conflict('Kho không đủ vật phẩm', { item_id: itemId, required: count, available: current });
  db.prepare('UPDATE character_storage SET quantity = quantity - ?, updated_at = ? WHERE character_id = ? AND item_id = ?')
    .run(count, now, characterId, itemId);
  return current - count;
}
