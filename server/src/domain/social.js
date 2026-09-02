/**
 * Social (doc 08) + moderation (doc 22).
 * Friend, chat, emote, report. Rate limit và chat filter nằm ở đây để mọi
 * đường vào (HTTP và websocket) đều đi qua cùng một luật.
 */
import { newId } from '../lib/ids.js';
import { badRequest, conflict, forbidden, notFound } from '../lib/errors.js';
import { logEvent } from './analytics.js';

const MAX_MESSAGE_LENGTH = 200;

/** Bộ lọc chat cơ bản; production thay bằng service riêng, interface không đổi. */
const BLOCKED_PATTERNS = [
  /\b(?:https?:\/\/|www\.)\S+/gi,       // link ngoài
  /\b\d{9,}\b/g,                         // số điện thoại / số tài khoản
];

export function filterMessage(body) {
  if (typeof body !== 'string') throw badRequest('Nội dung tin nhắn không hợp lệ');
  const trimmed = body.trim();
  if (trimmed.length === 0) throw badRequest('Tin nhắn rỗng');
  if (trimmed.length > MAX_MESSAGE_LENGTH) throw badRequest(`Tin nhắn tối đa ${MAX_MESSAGE_LENGTH} ký tự`);
  let filtered = trimmed;
  for (const pattern of BLOCKED_PATTERNS) filtered = filtered.replace(pattern, '***');
  return filtered;
}

function relation(db, characterId, otherId) {
  return db.prepare('SELECT * FROM friends WHERE character_id = ? AND friend_character_id = ?').get(characterId, otherId);
}

export function isBlocked(db, characterId, otherId) {
  return Boolean(
    db.prepare('SELECT 1 AS ok FROM friends WHERE state = \'blocked\' AND ((character_id = ? AND friend_character_id = ?) OR (character_id = ? AND friend_character_id = ?))')
      .get(characterId, otherId, otherId, characterId)
  );
}

export function listFriends(db, characterId) {
  const rows = db.prepare(`SELECT f.friend_character_id AS id, f.state, c.nickname, c.level, c.last_map_id
                           FROM friends f JOIN characters c ON c.id = f.friend_character_id
                           WHERE f.character_id = ? ORDER BY c.nickname`).all(characterId);
  const incoming = db.prepare(`SELECT f.character_id AS id, c.nickname, c.level
                               FROM friends f JOIN characters c ON c.id = f.character_id
                               WHERE f.friend_character_id = ? AND f.state = 'pending'`).all(characterId);
  return {
    friends: rows.filter((r) => r.state === 'accepted'),
    outgoing: rows.filter((r) => r.state === 'pending'),
    blocked: rows.filter((r) => r.state === 'blocked'),
    incoming,
  };
}

export function requestFriend(db, characterId, targetNickname) {
  const target = db.prepare('SELECT id, nickname FROM characters WHERE nickname = ?').get(targetNickname ?? '');
  if (!target) throw notFound('Không tìm thấy người chơi này');
  if (target.id === characterId) throw badRequest('Không thể tự kết bạn với chính mình');
  if (isBlocked(db, characterId, target.id)) throw forbidden('Không thể gửi lời mời tới người chơi này');
  if (relation(db, characterId, target.id)) throw conflict('Đã có quan hệ bạn bè hoặc lời mời đang chờ');

  const now = Date.now();
  // Nếu bên kia đã mời trước thì chấp nhận luôn cho gọn.
  const reverse = relation(db, target.id, characterId);
  if (reverse?.state === 'pending') return acceptFriend(db, characterId, target.id);

  db.prepare('INSERT INTO friends (id, character_id, friend_character_id, state, created_at, updated_at) VALUES (?, ?, ?, \'pending\', ?, ?)')
    .run(newId('fr'), characterId, target.id, now, now);
  logEvent(db, characterId, 'friend_request', { target_id: target.id });
  return { state: 'pending', target: { id: target.id, nickname: target.nickname } };
}

export function acceptFriend(db, characterId, requesterId) {
  const pending = db.prepare('SELECT * FROM friends WHERE character_id = ? AND friend_character_id = ? AND state = \'pending\'')
    .get(requesterId, characterId);
  if (!pending) throw notFound('Không có lời mời nào từ người chơi này');
  const now = Date.now();
  db.prepare('UPDATE friends SET state = \'accepted\', updated_at = ? WHERE id = ?').run(now, pending.id);
  db.prepare(`INSERT INTO friends (id, character_id, friend_character_id, state, created_at, updated_at) VALUES (?, ?, ?, 'accepted', ?, ?)
              ON CONFLICT (character_id, friend_character_id) DO UPDATE SET state = 'accepted', updated_at = excluded.updated_at`)
    .run(newId('fr'), characterId, requesterId, now, now);
  logEvent(db, characterId, 'friend_accept', { target_id: requesterId });
  return { state: 'accepted', friend_id: requesterId };
}

export function removeFriend(db, characterId, otherId) {
  db.prepare('DELETE FROM friends WHERE character_id = ? AND friend_character_id = ? AND state != \'blocked\'').run(characterId, otherId);
  db.prepare('DELETE FROM friends WHERE character_id = ? AND friend_character_id = ? AND state != \'blocked\'').run(otherId, characterId);
  return { ok: true };
}

export function blockPlayer(db, characterId, otherId) {
  const now = Date.now();
  db.prepare('DELETE FROM friends WHERE character_id = ? AND friend_character_id = ?').run(otherId, characterId);
  db.prepare(`INSERT INTO friends (id, character_id, friend_character_id, state, created_at, updated_at) VALUES (?, ?, ?, 'blocked', ?, ?)
              ON CONFLICT (character_id, friend_character_id) DO UPDATE SET state = 'blocked', updated_at = excluded.updated_at`)
    .run(newId('fr'), characterId, otherId, now, now);
  return { state: 'blocked' };
}

/**
 * Lưu một tin nhắn. channel: world | map | private.
 * Trả về bản ghi để realtime layer phát đi.
 */
export function postMessage(db, content, character, { channel, scopeId, body, recipientNickname }) {
  if (!['world', 'map', 'private'].includes(channel)) throw badRequest('channel không hợp lệ');
  if (channel === 'world' && !content.liveops.feature_flags.chat_global) throw forbidden('Chat thế giới đang tắt');

  const filtered = filterMessage(body);
  let recipientId = null;
  if (channel === 'private') {
    const recipient = db.prepare('SELECT id FROM characters WHERE nickname = ?').get(recipientNickname ?? '');
    if (!recipient) throw notFound('Không tìm thấy người nhận');
    if (isBlocked(db, character.id, recipient.id)) throw forbidden('Không thể nhắn tin cho người chơi này');
    recipientId = recipient.id;
  }

  const message = {
    id: newId('msg'),
    channel,
    scope_id: channel === 'map' ? (scopeId ?? character.last_map_id) : (channel === 'private' ? recipientId : null),
    sender_id: character.id,
    sender_nickname: character.nickname,
    recipient_id: recipientId,
    body: filtered,
    created_at: Date.now(),
  };
  db.prepare('INSERT INTO messages (id, channel, scope_id, sender_id, recipient_id, body, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)')
    .run(message.id, message.channel, message.scope_id, message.sender_id, message.recipient_id, message.body, message.created_at);
  logEvent(db, character.id, 'chat_sent', { channel });
  return message;
}

export function listMessages(db, characterId, { channel, scopeId, limit = 50 }) {
  const capped = Math.min(Math.max(Number(limit) || 50, 1), 100);
  if (channel === 'private') {
    return db.prepare(`SELECT m.*, c.nickname AS sender_nickname FROM messages m JOIN characters c ON c.id = m.sender_id
                       WHERE m.channel = 'private' AND ((m.sender_id = ? AND m.recipient_id = ?) OR (m.sender_id = ? AND m.recipient_id = ?))
                       ORDER BY m.created_at DESC LIMIT ?`).all(characterId, scopeId, scopeId, characterId, capped).reverse();
  }
  return db.prepare(`SELECT m.*, c.nickname AS sender_nickname FROM messages m JOIN characters c ON c.id = m.sender_id
                     WHERE m.channel = ? AND (m.scope_id IS ? OR m.scope_id = ?)
                     ORDER BY m.created_at DESC LIMIT ?`).all(channel, scopeId ?? null, scopeId ?? null, capped).reverse();
}

export function reportPlayer(db, characterId, { targetNickname, reason, detail }) {
  const target = db.prepare('SELECT id FROM characters WHERE nickname = ?').get(targetNickname ?? '');
  if (!target) throw notFound('Không tìm thấy người chơi này');
  if (!['spam', 'harassment', 'cheating', 'other'].includes(reason)) throw badRequest('reason không hợp lệ');
  db.prepare('INSERT INTO moderation_reports (id, reporter_id, target_id, reason, detail, created_at) VALUES (?, ?, ?, ?, ?, ?)')
    .run(newId('rep'), characterId, target.id, reason, detail ?? null, Date.now());
  logEvent(db, characterId, 'report', { target_id: target.id, reason });
  return { ok: true };
}
