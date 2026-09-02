/**
 * World / map instance & presence (doc 16).
 *
 * Mô hình: state bền vững do HTTP + database quyết định; kênh realtime chỉ mang
 * presence, movement snapshot, chat và map event. Client dự đoán chuyển động
 * cục bộ, server kiểm tra bounds/collision/tốc độ rồi broadcast state chuẩn.
 */
import { verifyToken } from '../lib/token.js';
import { badRequest } from '../lib/errors.js';
import { logger } from '../lib/logger.js';
import { getEquipment } from '../domain/player.js';
import { savePosition } from '../domain/player.js';
import { createRateLimiter } from '../lib/ratelimit.js';
import { filterMessage, isBlocked } from '../domain/social.js';

const MAX_SPEED_PX_PER_SEC = 420;   // tốc độ chạy tối đa hợp lệ + biên an toàn
const SNAPSHOT_KEYS = ['x', 'y', 'facing', 'state'];

export function createWorld(ctx) {
  const { db, content, config } = ctx;

  /** instance_id -> { map, members: Map<characterId, member> } */
  const instances = new Map();
  /** characterId -> connection state */
  const online = new Map();

  const moveLimiter = createRateLimiter({ capacity: 60, refillPerSecond: 30 });
  const chatLimiter = createRateLimiter({
    capacity: content.economy.rate_limits.chat_messages_per_minute,
    refillPerSecond: content.economy.rate_limits.chat_messages_per_minute / 60,
  });

  /**
   * Map public được chia thành nhiều "khu" (channel) cùng nội dung nhưng khác
   * danh sách người chơi (doc 03 — public map partitioned into instances,
   * doc 16 — player capacity mỗi instance). Map private (nông trại, nhà) bỏ qua
   * channel: instance luôn thuộc về chủ sở hữu.
   */
  const instanceIdFor = (map, characterId, channel) =>
    map.instance_policy === 'owner' ? `${map.map_id}:${characterId}` : `${map.map_id}:ch${channel}`;

  function assignInstance(map, characterId, channel = 1) {
    const instanceId = instanceIdFor(map, characterId, normalizeChannel(channel));
    if (!instances.has(instanceId)) instances.set(instanceId, { instance_id: instanceId, map, members: new Map() });
    return {
      instance_id: instanceId,
      channel: map.instance_policy === 'owner' ? null : normalizeChannel(channel),
      socket_path: `/ws?instance=${encodeURIComponent(instanceId)}`,
    };
  }

  function normalizeChannel(channel) {
    const value = Number(channel);
    if (!Number.isInteger(value) || value < 1 || value > content.channelCount) {
      throw badRequest(`Khu phải là số nguyên từ 1 đến ${content.channelCount}`, { channel_count: content.channelCount });
    }
    return value;
  }

  /** Sĩ số từng khu của một map — để client hiện khu nào đang đông. */
  function listChannels(map) {
    if (map.instance_policy === 'owner') return [];
    return Array.from({ length: content.channelCount }, (_, index) => {
      const channel = index + 1;
      return {
        channel,
        players: instances.get(`${map.map_id}:ch${channel}`)?.members.size ?? 0,
        capacity: map.player_capacity,
      };
    });
  }

  function broadcast(instanceId, payload, exceptCharacterId = null) {
    const instance = instances.get(instanceId);
    if (!instance) return;
    for (const [characterId, member] of instance.members) {
      if (characterId === exceptCharacterId) continue;
      member.conn.sendJson(payload);
    }
  }

  /** Chat từ HTTP cũng phải tới được người đang online (doc 08). */
  function broadcastMessage(message) {
    if (message.channel === 'private') {
      online.get(message.recipient_id)?.conn.sendJson({ type: 'chat', message });
      online.get(message.sender_id)?.conn.sendJson({ type: 'chat', message });
      return;
    }
    if (message.channel === 'map') {
      for (const instance of instances.values()) {
        if (instance.map.map_id !== message.scope_id) continue;
        for (const [characterId, member] of instance.members) {
          if (isBlocked(db, characterId, message.sender_id)) continue;
          member.conn.sendJson({ type: 'chat', message });
        }
      }
      return;
    }
    for (const [characterId, state] of online) {
      if (isBlocked(db, characterId, message.sender_id)) continue;
      state.conn.sendJson({ type: 'chat', message });
    }
  }

  const memberView = (member) => ({
    character_id: member.characterId,
    nickname: member.nickname,
    level: member.level,
    x: member.x,
    y: member.y,
    facing: member.facing,
    state: member.state,
    equipment: member.equipment,
    body_type: member.body_type,
  });

  function join(conn, instanceId, character) {
    const instance = instances.get(instanceId);
    if (!instance) {
      conn.sendJson({ type: 'error', error: { code: 'not_found', message: 'instance không tồn tại, hãy gọi /v1/maps/{id}/enter trước' } });
      conn.close(1008, 'unknown instance');
      return null;
    }
    if (instance.members.size >= instance.map.player_capacity) {
      conn.sendJson({ type: 'error', error: { code: 'instance_full', message: 'Map đã đầy' } });
      conn.close(1013, 'instance full');
      return null;
    }

    // Một tài khoản chỉ giữ một kết nối; kết nối mới đá kết nối cũ (doc 22).
    const previous = online.get(character.id);
    if (previous) leave(previous.conn, 'replaced');

    const member = {
      conn,
      characterId: character.id,
      nickname: character.nickname,
      level: character.level,
      body_type: character.body_type,
      equipment: getEquipment(db, character.id),
      x: character.last_x,
      y: character.last_y,
      facing: 1,
      state: 'idle',
      instanceId,
      lastMoveAt: Date.now(),
      lastSeenAt: Date.now(),
    };
    instance.members.set(character.id, member);
    online.set(character.id, member);

    conn.sendJson({
      type: 'joined',
      instance_id: instanceId,
      map_id: instance.map.map_id,
      you: memberView(member),
      players: [...instance.members.values()].filter((m) => m.characterId !== character.id).map(memberView),
    });
    broadcast(instanceId, { type: 'player_join', player: memberView(member) }, character.id);
    logger.info('world join', { instance_id: instanceId, character_id: character.id });
    return member;
  }

  function leave(conn, reason = 'left') {
    const member = [...online.values()].find((m) => m.conn === conn);
    if (!member) return;
    instances.get(member.instanceId)?.members.delete(member.characterId);
    online.delete(member.characterId);
    savePosition(db, member.characterId, instances.get(member.instanceId)?.map.map_id ?? '', member.x, member.y);
    broadcast(member.instanceId, { type: 'player_leave', character_id: member.characterId, reason });
    logger.info('world leave', { instance_id: member.instanceId, character_id: member.characterId, reason });
  }

  /**
   * Server xác thực chuyển động: trong biên map, đứng trên nền hoặc platform,
   * và không vượt tốc độ tối đa. Sai thì server đẩy vị trí chuẩn về cho client.
   */
  function handleMove(member, payload) {
    if (!moveLimiter.take(member.characterId)) return;
    const instance = instances.get(member.instanceId);
    if (!instance) return;
    const map = instance.map;

    const now = Date.now();
    const dt = Math.max(0.016, (now - member.lastMoveAt) / 1000);
    const x = Number(payload.x);
    const y = Number(payload.y);
    if (!Number.isFinite(x) || !Number.isFinite(y)) return;

    const clampedX = Math.min(Math.max(x, 0), map.width);
    const clampedY = Math.min(Math.max(y, 0), map.height);
    const distance = Math.hypot(clampedX - member.x, clampedY - member.y);
    const maxDistance = MAX_SPEED_PX_PER_SEC * dt + 32;

    let corrected = false;
    if (distance > maxDistance) corrected = true;
    if (!standsOnSurface(map, clampedX, clampedY)) corrected = true;

    if (corrected) {
      member.conn.sendJson({ type: 'position_correction', x: member.x, y: member.y });
    } else {
      member.x = clampedX;
      member.y = clampedY;
      member.facing = payload.facing === -1 ? -1 : 1;
      member.state = ['idle', 'walk', 'run', 'jump', 'sit', 'farm'].includes(payload.state) ? payload.state : 'idle';
    }
    member.lastMoveAt = now;
    member.lastSeenAt = now;
  }

  /** Đứng trên mặt đất hoặc trên một platform (doc 03 — collision). */
  function standsOnSurface(map, x, y) {
    if (Math.abs(y - map.ground_y) <= 8) return true;
    for (const platform of map.platforms ?? []) {
      if (x >= platform.x - 8 && x <= platform.x + platform.w + 8 && Math.abs(y - platform.y) <= 8) return true;
    }
    // Cho phép ở trên không (đang nhảy) miễn là không rơi xuyên đất.
    return y < map.ground_y;
  }

  function handleChat(member, payload) {
    if (!chatLimiter.take(member.characterId)) {
      member.conn.sendJson({ type: 'error', error: { code: 'rate_limited', message: 'Nhắn tin quá nhanh' } });
      return;
    }
    const instance = instances.get(member.instanceId);
    let body;
    try {
      body = filterMessage(payload.body);
    } catch (err) {
      member.conn.sendJson({ type: 'error', error: { code: 'bad_request', message: err.message } });
      return;
    }
    const message = {
      id: `live_${Date.now()}_${member.characterId}`,
      channel: 'map',
      scope_id: instance?.map.map_id ?? null,
      sender_id: member.characterId,
      sender_nickname: member.nickname,
      body,
      created_at: Date.now(),
    };
    for (const [characterId, other] of instance?.members ?? []) {
      if (isBlocked(db, characterId, member.characterId)) continue;
      other.conn.sendJson({ type: 'chat', message });
    }
  }

  function handleEmote(member, payload) {
    const emote = content.emotes.find((e) => e.emote_id === payload.emote_id);
    if (!emote) return;
    broadcast(member.instanceId, { type: 'emote', character_id: member.characterId, emote_id: emote.emote_id });
  }

  /** Vòng broadcast snapshot; chỉ gửi khi có ai đó thực sự di chuyển. */
  const tick = setInterval(() => {
    for (const [instanceId, instance] of instances) {
      if (instance.members.size === 0) continue;
      const players = [...instance.members.values()].map((member) =>
        Object.fromEntries([['character_id', member.characterId], ...SNAPSHOT_KEYS.map((k) => [k, member[k]])]));
      broadcast(instanceId, { type: 'snapshot', t: Date.now(), players });
    }
  }, config.worldTickMs);
  tick.unref();

  /** Ping định kỳ để phát hiện client chết (doc 16 — heartbeat). */
  const heartbeat = setInterval(() => {
    for (const member of [...online.values()]) {
      if (!member.conn.isAlive && Date.now() - member.lastSeenAt > config.presenceTimeoutMs) {
        member.conn.close(1001, 'timeout');
        continue;
      }
      member.conn.ping();
    }
  }, Math.max(5000, config.presenceTimeoutMs / 2));
  heartbeat.unref();

  /** Điểm vào cho mỗi websocket mới. Auth bằng access token như REST. */
  function handleConnection(conn, url) {
    const instanceId = url.searchParams.get('instance');
    const payload = verifyToken(url.searchParams.get('token'));
    if (!payload) {
      conn.sendJson({ type: 'error', error: { code: 'unauthorized', message: 'token không hợp lệ' } });
      conn.close(1008, 'unauthorized');
      return;
    }
    const character = db.prepare('SELECT * FROM characters WHERE id = ?').get(payload.chr);
    if (!character) {
      conn.close(1008, 'unknown character');
      return;
    }

    const member = join(conn, instanceId, character);
    if (!member) return;

    conn.on('message', (message) => {
      member.lastSeenAt = Date.now();
      switch (message.type) {
        case 'move': handleMove(member, message); break;
        case 'chat': handleChat(member, message); break;
        case 'emote': handleEmote(member, message); break;
        case 'ping': conn.sendJson({ type: 'pong', t: Date.now() }); break;
        default: conn.sendJson({ type: 'error', error: { code: 'bad_request', message: `type không hỗ trợ: ${message.type}` } });
      }
    });
    conn.on('close', () => leave(conn, 'disconnect'));
  }

  return {
    assignInstance,
    listChannels,
    broadcastMessage,
    handleConnection,
    stats: () => ({
      instances: instances.size,
      online: online.size,
      per_instance: [...instances.values()].map((i) => ({ instance_id: i.instance_id, players: i.members.size })),
    }),
    shutdown: () => { clearInterval(tick); clearInterval(heartbeat); },
  };
}
