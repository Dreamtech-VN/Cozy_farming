/**
 * Analytics (doc 19). Event được ghi vào bảng riêng, không chặn gameplay.
 * Production sẽ đẩy sang pipeline ngoài; interface giữ nguyên.
 */
import { newId } from '../lib/ids.js';
import { logger } from '../lib/logger.js';

const KNOWN_EVENTS = new Set([
  'login', 'map_enter', 'farm_plant', 'farm_harvest',
  'match_start', 'match_win', 'match_loss', 'quest_complete',
  'item_obtained', 'item_spent', 'shop_purchase',
  'friend_request', 'friend_accept', 'chat_sent', 'gift_sent', 'home_visit', 'report',
]);

export function logEvent(db, characterId, eventName, payload = {}) {
  if (!KNOWN_EVENTS.has(eventName)) {
    logger.warn('analytics event lạ', { event_name: eventName });
  }
  db.prepare('INSERT INTO analytics_events (id, character_id, event_name, payload, created_at) VALUES (?, ?, ?, ?, ?)')
    .run(newId('ev'), characterId, eventName, JSON.stringify(payload), Date.now());
}

/** Tổng hợp nhanh cho admin/QA; production dùng warehouse thay cho query này. */
export function summarize(db, sinceMs) {
  return db.prepare(`SELECT event_name, COUNT(*) AS count FROM analytics_events
                     WHERE created_at >= ? GROUP BY event_name ORDER BY count DESC`).all(sinceMs);
}

export { KNOWN_EVENTS };
