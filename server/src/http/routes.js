/**
 * Route definitions — bám sát doc 15 (API Specification).
 * Handler chỉ làm việc parse/uỷ quyền; luật chơi nằm trong domain layer.
 */
import { badRequest, notFound } from '../lib/errors.js';
import * as player from '../domain/player.js';
import * as farm from '../domain/farm.js';
import * as match3 from '../domain/match3.js';
import * as quest from '../domain/quest.js';
import * as social from '../domain/social.js';
import * as shop from '../domain/shop.js';
import { getWallet, regenerateEnergy } from '../domain/economy.js';
import { logEvent, summarize } from '../domain/analytics.js';

export function registerRoutes(router, ctx) {
  const { db, content } = ctx;

  // ---------- Health & content (doc 21 / doc 18) ----------
  router.get('/v1/health', () => ({
    body: { status: 'ok', content_version: content.version, uptime_seconds: Math.round(process.uptime()) },
  }), { auth: false });

  router.get('/v1/content', () => ({
    body: {
      version: content.version,
      crops: content.crops,
      items: content.items,
      avatar_items: content.avatarItems,
      layer_order: content.layerOrder,
      emotes: content.emotes,
      tile_types: content.tileTypes,
      levels: content.levels.map(({ level_id, name_key, tier, unlock_level, moves, enemy, energy_cost, rewards }) =>
        ({ level_id, name_key, tier, unlock_level, moves, enemy, energy_cost, rewards })),
      dialogues: content.dialogues,
      economy: { currencies: content.economy.currencies, level_curve: content.economy.level_curve, farm: content.economy.farm },
      feature_flags: content.liveops.feature_flags,
    },
  }), { auth: false });

  router.get('/v1/locales/:locale', ({ params }) => {
    const locale = content.locales[params.locale];
    if (!locale) throw notFound(`locale không tồn tại: ${params.locale}`);
    return { body: locale };
  }, { auth: false });

  // ---------- Auth (doc 15 §Auth) ----------
  router.post('/v1/auth/register', async ({ body }) => {
    const created = await player.register(db, content, body);
    const user = db.prepare('SELECT * FROM users WHERE id = ?').get(created.user_id);
    const character = db.prepare('SELECT * FROM characters WHERE id = ?').get(created.character_id);
    return { status: 201, body: player.issueSession(db, user, character, body.device) };
  }, { auth: false });

  router.post('/v1/auth/login', async ({ body }) => ({ body: await player.login(db, body) }), { auth: false });
  router.post('/v1/auth/refresh', ({ body }) => ({ body: player.refreshSession(db, body.refresh_token) }), { auth: false });
  router.post('/v1/auth/logout', ({ body }) => ({ body: player.logout(db, body.refresh_token) }), { auth: false });

  // ---------- Player (doc 15 §Player) ----------
  router.get('/v1/player/profile', ({ character }) => ({ body: player.getProfile(db, content, character.id) }));
  router.patch('/v1/player/profile', ({ character, body }) => ({ body: player.updateProfile(db, content, character.id, body) }));
  router.get('/v1/player/inventory', ({ character }) => ({
    body: { items: player.getInventoryView(db, content, character.id), wallet: getWallet(db, character.id) },
  }));
  router.get('/v1/player/wallet', ({ character }) => {
    regenerateEnergy(db, content, character.id);
    return { body: getWallet(db, character.id) };
  });

  // ---------- World (doc 15 §World, doc 03) ----------
  router.get('/v1/maps', ({ character }) => ({
    body: {
      maps: content.maps
        .filter((map) => character.level >= map.unlock_level)
        .map(({ map_id, name_key, map_type, group, unlock_level, instance_policy }) =>
          ({ map_id, name_key, map_type, group, unlock_level, instance_policy })),
    },
  }));

  router.get('/v1/maps/:mapId', ({ params, character }) => {
    const map = content.byMap.get(params.mapId);
    if (!map) throw notFound(`map không tồn tại: ${params.mapId}`);
    if (character.level < map.unlock_level) throw badRequest('Chưa mở khoá map này');
    return { body: map };
  });

  router.post('/v1/maps/:mapId/enter', ({ params, body, character }) => {
    const map = content.byMap.get(params.mapId);
    if (!map) throw notFound(`map không tồn tại: ${params.mapId}`);
    if (character.level < map.unlock_level) {
      throw badRequest('Chưa mở khoá map này', { required_level: map.unlock_level });
    }
    const spawn = map.spawn_points.find((s) => s.id === (body.spawn_id ?? 'spawn_default')) ?? map.spawn_points[0];
    const instance = ctx.world.assignInstance(map, character.id);
    player.savePosition(db, character.id, map.map_id, spawn.x, spawn.y);
    quest.trackProgress(db, content, character.id, 'visit_map', map.map_id);
    logEvent(db, character.id, 'map_enter', { map_id: map.map_id, instance_id: instance.instance_id });
    return { body: { map_id: map.map_id, instance_id: instance.instance_id, spawn, realtime_channel: instance.channel } };
  });

  // ---------- Farm (doc 15 §Farm, doc 06) ----------
  router.get('/v1/farm', ({ character }) => ({ body: farm.getFarm(db, content, character.id) }));

  router.post('/v1/farm/plant', ({ character, body, idempotencyKey }) => {
    const result = farm.plant(db, content, character.id, { plotId: body.plot_id, cropId: body.crop_id, idempotencyKey });
    logEvent(db, character.id, 'farm_plant', { crop_id: body.crop_id });
    return { body: result };
  });

  router.post('/v1/farm/harvest', ({ character, body, idempotencyKey }) => {
    const result = farm.harvest(db, content, character.id, { plotId: body.plot_id, idempotencyKey });
    quest.trackProgress(db, content, character.id, 'harvest', result.crop_id);
    for (const item of result.harvested) quest.trackProgress(db, content, character.id, 'collect', item.item_id, item.count);
    logEvent(db, character.id, 'farm_harvest', { crop_id: result.crop_id });
    return { body: result };
  });

  router.post('/v1/farm/expand', ({ character, idempotencyKey }) => ({
    body: farm.expandPlots(db, content, character.id, { idempotencyKey }),
  }));

  // ---------- Match-3 (doc 15 §Match-3, doc 07) ----------
  router.post('/v1/matches', ({ character, body, idempotencyKey }) => ({
    status: 201,
    body: match3.startMatch(db, content, character.id, { levelId: body.level_id, idempotencyKey }),
  }));

  router.get('/v1/matches/:id', ({ character, params }) => ({ body: match3.getMatch(db, content, character.id, params.id) }));

  router.post('/v1/matches/:id/actions', ({ character, params, body }) => ({
    body: match3.playAction(db, content, character.id, params.id, body.action ?? body),
  }));

  router.post('/v1/matches/:id/finish', ({ character, params }) => ({
    body: match3.abandonMatch(db, content, character.id, params.id),
  }));

  // ---------- Quest (doc 11) ----------
  router.get('/v1/quests', ({ character }) => ({ body: { quests: quest.listQuests(db, content, character.id) } }));

  router.post('/v1/quests/:questId/claim', ({ character, params }) => {
    const result = quest.claimQuest(db, content, character.id, params.questId);
    logEvent(db, character.id, 'quest_complete', { quest_id: params.questId });
    return { body: result };
  });

  router.post('/v1/npcs/:npcId/talk', ({ character, params }) => {
    const npc = content.byNpc.get(params.npcId);
    if (!npc) throw notFound(`npc không tồn tại: ${params.npcId}`);
    quest.trackProgress(db, content, character.id, 'talk_npc', npc.npc_id);
    return { body: { npc_id: npc.npc_id, dialogue: content.byDialogue.get(npc.dialogue_id) ?? null, shop_id: npc.shop_id ?? null } };
  });

  // ---------- Shop (doc 09/10) ----------
  router.get('/v1/shops/:shopId', ({ character, params }) => ({ body: shop.listShop(db, content, character, params.shopId) }));

  router.post('/v1/shops/:shopId/purchase', ({ character, params, body, idempotencyKey }) => ({
    body: shop.purchase(db, content, character, { shopId: params.shopId, entryId: body.entry_id, quantity: body.quantity ?? 1, idempotencyKey }),
  }));

  router.post('/v1/shops/sell', ({ character, body, idempotencyKey }) => ({
    body: shop.sellItem(db, content, character, { itemId: body.item_id, quantity: body.quantity ?? 1, idempotencyKey }),
  }));

  // ---------- Social (doc 15 §Social, doc 08) ----------
  router.get('/v1/friends', ({ character }) => ({ body: social.listFriends(db, character.id) }));
  router.post('/v1/friends/requests', ({ character, body }) => ({ body: social.requestFriend(db, character.id, body.nickname) }));
  router.post('/v1/friends/:id/accept', ({ character, params }) => ({ body: social.acceptFriend(db, character.id, params.id) }));
  router.delete('/v1/friends/:id', ({ character, params }) => ({ body: social.removeFriend(db, character.id, params.id) }));
  router.post('/v1/friends/:id/block', ({ character, params }) => ({ body: social.blockPlayer(db, character.id, params.id) }));

  router.get('/v1/chat/messages', ({ character, query }) => ({
    body: {
      messages: social.listMessages(db, character.id, {
        channel: query.get('channel') ?? 'world',
        scopeId: query.get('scope_id'),
        limit: query.get('limit'),
      }),
    },
  }));

  router.post('/v1/chat/messages', ({ character, body }) => {
    const message = social.postMessage(db, content, character, {
      channel: body.channel ?? 'world',
      scopeId: body.scope_id,
      body: body.body,
      recipientNickname: body.to,
    });
    ctx.world.broadcastMessage(message);
    return { status: 201, body: message };
  });

  router.post('/v1/moderation/reports', ({ character, body }) => ({
    status: 201,
    body: social.reportPlayer(db, character.id, { targetNickname: body.nickname, reason: body.reason, detail: body.detail }),
  }));

  // ---------- Analytics / LiveOps (doc 17, doc 19) ----------
  router.get('/v1/liveops/config', () => ({
    body: {
      feature_flags: content.liveops.feature_flags,
      seasons: content.liveops.seasons,
      events: content.liveops.events.filter((e) => Date.parse(e.ends_at) > Date.now()),
    },
  }), { auth: false });

  router.get('/v1/analytics/summary', ({ query }) => {
    const hours = Math.min(Number(query.get('hours') ?? 24), 24 * 30);
    return { body: { since_hours: hours, events: summarize(db, Date.now() - hours * 3600_000) } };
  });
}
