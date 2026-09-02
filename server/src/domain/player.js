/**
 * Account + character (doc 04, doc 14, doc 22).
 * Đăng ký/đăng nhập, hồ sơ, cosmetic đang mặc và tủ đồ.
 */
import { newId } from '../lib/ids.js';
import { transaction } from '../db/index.js';
import { badRequest, conflict, notFound, unauthorized } from '../lib/errors.js';
import { hashPassword, verifyPassword } from '../lib/password.js';
import { issueToken, newRefreshToken, hashRefreshToken, verifyToken } from '../lib/token.js';
import { config } from '../config.js';
import { createFarm } from './farm.js';
import { getWallet, getInventory, regenerateEnergy } from './economy.js';
import { logEvent } from './analytics.js';

const USERNAME_RE = /^[a-zA-Z0-9_]{3,20}$/;
const NICKNAME_RE = /^[\p{L}\p{N} _-]{2,16}$/u;

export function validateNickname(nickname) {
  if (typeof nickname !== 'string' || !NICKNAME_RE.test(nickname.trim())) {
    throw badRequest('Nickname phải dài 2–16 ký tự, chỉ gồm chữ, số, khoảng trắng, gạch dưới hoặc gạch ngang');
  }
  return nickname.trim();
}

export async function register(db, content, { username, password, nickname, appearance }) {
  if (!USERNAME_RE.test(username ?? '')) throw badRequest('Username phải dài 3–20 ký tự (chữ, số, gạch dưới)');
  if (typeof password !== 'string' || password.length < 8) throw badRequest('Mật khẩu tối thiểu 8 ký tự');
  const nick = validateNickname(nickname);

  if (db.prepare('SELECT 1 AS ok FROM users WHERE username = ?').get(username)) throw conflict('Username đã tồn tại');
  if (db.prepare('SELECT 1 AS ok FROM characters WHERE nickname = ?').get(nick)) throw conflict('Nickname đã có người dùng');

  const passwordHash = await hashPassword(password);
  const now = Date.now();
  const userId = newId('usr');
  const characterId = newId('chr');
  const startMap = content.maps.find((m) => m.map_id === 'map_city_plaza') ?? content.maps[0];
  const spawn = startMap.spawn_points.find((s) => s.id === 'spawn_default');

  transaction(db, () => {
    db.prepare('INSERT INTO users (id, username, password_hash, created_at) VALUES (?, ?, ?, ?)')
      .run(userId, username, passwordHash, now);
    db.prepare(`INSERT INTO characters (id, user_id, nickname, body_type, level, xp, last_map_id, last_x, last_y, created_at, updated_at)
                VALUES (?, ?, ?, ?, 1, 0, ?, ?, ?, ?, ?)`)
      .run(characterId, userId, nick, appearance?.body_type ?? 'a', startMap.map_id, spawn.x, spawn.y, now, now);

    // Grant khởi đầu (doc 09).
    for (const [currencyId, amount] of Object.entries(content.economy.starting_grant)) {
      db.prepare('INSERT INTO wallets (character_id, currency_id, amount, updated_at) VALUES (?, ?, ?, ?)')
        .run(characterId, currencyId, amount, now);
    }
    for (const itemId of ['item_tool_hoe', 'item_tool_wateringcan']) {
      db.prepare('INSERT INTO inventories (character_id, item_id, quantity, updated_at) VALUES (?, ?, 1, ?)').run(characterId, itemId, now);
    }
    db.prepare('INSERT INTO inventories (character_id, item_id, quantity, updated_at) VALUES (?, ?, 5, ?)')
      .run(characterId, 'item_seed_carrot', now);

    // Cosmetic mặc định + tủ đồ.
    const defaults = content.avatarItems.filter((i) => i.unlock.type === 'default');
    for (const item of defaults) {
      db.prepare('INSERT INTO character_wardrobe (character_id, avatar_item_id, acquired_at) VALUES (?, ?, ?)').run(characterId, item.item_id, now);
    }
    const chosen = normalizeAppearance(content, appearance);
    for (const [slot, avatarItemId] of Object.entries(chosen)) {
      db.prepare('INSERT INTO character_equipment (character_id, slot, avatar_item_id) VALUES (?, ?, ?)').run(characterId, slot, avatarItemId);
    }

    createFarm(db, content, characterId, now);
  });

  logEvent(db, characterId, 'login', { first_session: true });
  return { user_id: userId, character_id: characterId };
}

/** Ghép lựa chọn tạo nhân vật với danh sách cosmetic hợp lệ; thiếu thì lấy mặc định. */
export function normalizeAppearance(content, appearance = {}) {
  const chosen = {};
  for (const slot of ['body', 'face', 'hair', 'top', 'bottom', 'shoes']) {
    const wanted = appearance?.[slot];
    const item = content.avatarItems.find((i) => i.item_id === wanted && i.slot === slot && i.unlock.type === 'default')
      ?? content.avatarItems.find((i) => i.slot === slot && i.unlock.type === 'default');
    if (item) chosen[slot] = item.item_id;
  }
  return chosen;
}

export async function login(db, { username, password, device }) {
  const user = db.prepare('SELECT * FROM users WHERE username = ?').get(username ?? '');
  if (!user) throw unauthorized('Sai tài khoản hoặc mật khẩu');
  if (user.status !== 'active') throw unauthorized('Tài khoản đang bị khoá');
  if (!(await verifyPassword(password ?? '', user.password_hash))) throw unauthorized('Sai tài khoản hoặc mật khẩu');

  const character = db.prepare('SELECT * FROM characters WHERE user_id = ?').get(user.id);
  const now = Date.now();
  db.prepare('UPDATE users SET last_login_at = ? WHERE id = ?').run(now, user.id);
  logEvent(db, character.id, 'login', {});
  return issueSession(db, user, character, device);
}

export function issueSession(db, user, character, device) {
  const now = Date.now();
  const refresh = newRefreshToken();
  db.prepare('INSERT INTO sessions (id, user_id, refresh_hash, device, created_at, expires_at) VALUES (?, ?, ?, ?, ?, ?)')
    .run(newId('ses'), user.id, hashRefreshToken(refresh), device ?? null, now, now + config.refreshTokenTtlSeconds * 1000);

  return {
    access_token: issueToken({ sub: user.id, chr: character.id }, config.accessTokenTtlSeconds),
    refresh_token: refresh,
    expires_in: config.accessTokenTtlSeconds,
    character_id: character.id,
    nickname: character.nickname,
  };
}

/** Refresh token xoay vòng: token cũ bị thu hồi ngay khi dùng (doc 22). */
export function refreshSession(db, refreshToken) {
  const hash = hashRefreshToken(refreshToken ?? '');
  const session = db.prepare('SELECT * FROM sessions WHERE refresh_hash = ?').get(hash);
  if (!session || session.revoked_at || session.expires_at < Date.now()) throw unauthorized('Refresh token không hợp lệ');

  const user = db.prepare('SELECT * FROM users WHERE id = ?').get(session.user_id);
  const character = db.prepare('SELECT * FROM characters WHERE user_id = ?').get(session.user_id);
  return transaction(db, () => {
    db.prepare('UPDATE sessions SET revoked_at = ? WHERE id = ?').run(Date.now(), session.id);
    return issueSession(db, user, character, session.device);
  });
}

export function logout(db, refreshToken) {
  const hash = hashRefreshToken(refreshToken ?? '');
  db.prepare('UPDATE sessions SET revoked_at = ? WHERE refresh_hash = ? AND revoked_at IS NULL').run(Date.now(), hash);
  return { ok: true };
}

/** Xác thực access token cho mỗi request; trả về character đang hoạt động. */
export function authenticate(db, authorizationHeader) {
  const token = /^Bearer (.+)$/i.exec(authorizationHeader ?? '')?.[1];
  const payload = token ? verifyToken(token) : null;
  if (!payload) throw unauthorized();
  const character = db.prepare('SELECT * FROM characters WHERE id = ?').get(payload.chr);
  if (!character) throw unauthorized();
  const user = db.prepare('SELECT status FROM users WHERE id = ?').get(payload.sub);
  if (user?.status !== 'active') throw unauthorized('Tài khoản đang bị khoá');
  return character;
}

export function getEquipment(db, characterId) {
  const rows = db.prepare('SELECT slot, avatar_item_id FROM character_equipment WHERE character_id = ?').all(characterId);
  return Object.fromEntries(rows.map((r) => [r.slot, r.avatar_item_id]));
}

export function getProfile(db, content, characterId) {
  const character = db.prepare('SELECT * FROM characters WHERE id = ?').get(characterId);
  if (!character) throw notFound('Không tìm thấy nhân vật');
  regenerateEnergy(db, content, characterId);
  const wardrobe = db.prepare('SELECT avatar_item_id FROM character_wardrobe WHERE character_id = ?').all(characterId).map((r) => r.avatar_item_id);
  return {
    character_id: character.id,
    nickname: character.nickname,
    level: character.level,
    xp: character.xp,
    body_type: character.body_type,
    position: { map_id: character.last_map_id, x: character.last_x, y: character.last_y },
    equipment: getEquipment(db, characterId),
    wardrobe,
    wallet: getWallet(db, characterId),
  };
}

export function getInventoryView(db, content, characterId) {
  return getInventory(db, characterId).map((row) => {
    const item = content.byItem.get(row.item_id);
    return { item_id: row.item_id, quantity: row.quantity, name_key: item?.name_key, category: item?.category, sell_price: item?.sell_price, ref: item?.ref };
  });
}

/** Đổi cosmetic đang mặc — chỉ cho phép item đã có trong tủ đồ. */
export function updateProfile(db, content, characterId, patch) {
  const now = Date.now();
  return transaction(db, () => {
    if (patch.nickname !== undefined) {
      const nick = validateNickname(patch.nickname);
      const taken = db.prepare('SELECT 1 AS ok FROM characters WHERE nickname = ? AND id != ?').get(nick, characterId);
      if (taken) throw conflict('Nickname đã có người dùng');
      db.prepare('UPDATE characters SET nickname = ?, updated_at = ? WHERE id = ?').run(nick, now, characterId);
    }
    for (const [slot, avatarItemId] of Object.entries(patch.equipment ?? {})) {
      if (avatarItemId === null) {
        db.prepare('DELETE FROM character_equipment WHERE character_id = ? AND slot = ?').run(characterId, slot);
        continue;
      }
      const item = content.byAvatarItem.get(avatarItemId);
      if (!item) throw badRequest(`cosmetic không tồn tại: ${avatarItemId}`);
      if (item.slot !== slot) throw badRequest(`cosmetic ${avatarItemId} không thuộc slot ${slot}`);
      const owned = db.prepare('SELECT 1 AS ok FROM character_wardrobe WHERE character_id = ? AND avatar_item_id = ?').get(characterId, avatarItemId);
      if (!owned) throw conflict('Bạn chưa sở hữu món này', { avatar_item_id: avatarItemId });
      db.prepare(`INSERT INTO character_equipment (character_id, slot, avatar_item_id) VALUES (?, ?, ?)
                  ON CONFLICT (character_id, slot) DO UPDATE SET avatar_item_id = excluded.avatar_item_id`)
        .run(characterId, slot, avatarItemId);
    }
    return getProfile(db, content, characterId);
  });
}

export function savePosition(db, characterId, mapId, x, y) {
  db.prepare('UPDATE characters SET last_map_id = ?, last_x = ?, last_y = ?, updated_at = ? WHERE id = ?')
    .run(mapId, x, y, Date.now(), characterId);
}
