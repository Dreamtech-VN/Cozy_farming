/**
 * Content loader (doc 13 — data-driven, doc 18 — content pipeline).
 * Đọc data/content + locales, index theo ID và chạy validation trước khi server
 * nhận traffic. Content sai reference thì server không được phép khởi động.
 */
import { readFileSync, readdirSync } from 'node:fs';
import { join, basename } from 'node:path';
import { validateContent } from './validate.js';

const FILES = ['crops', 'items', 'avatar_items', 'maps', 'match3_levels', 'quests', 'shops', 'economy', 'liveops', 'giftcodes'];

const indexBy = (rows, key) => new Map(rows.map((row) => [row[key], row]));

export function loadContent({ dataDir, localeDir }) {
  const raw = {};
  for (const name of FILES) {
    raw[name] = JSON.parse(readFileSync(join(dataDir, `${name}.json`), 'utf8'));
  }

  const locales = {};
  for (const file of readdirSync(localeDir).filter((f) => f.endsWith('.json'))) {
    const parsed = JSON.parse(readFileSync(join(localeDir, file), 'utf8'));
    locales[parsed.locale ?? basename(file, '.json')] = parsed;
  }

  const content = {
    version: raw.crops.version,
    crops: raw.crops.crops,
    items: raw.items.items,
    avatarItems: raw.avatar_items.avatar_items,
    layerOrder: raw.avatar_items.layer_order,
    emotes: raw.avatar_items.emotes,
    giftcodes: raw.giftcodes.giftcodes,
    maps: raw.maps.maps,
    channelCount: raw.maps.world?.channel_count ?? 1,
    world: raw.maps.world ?? {},
    tileTypes: raw.match3_levels.tile_types,
    specialTiles: raw.match3_levels.special_tiles,
    difficultyTable: raw.match3_levels.difficulty_table,
    levels: raw.match3_levels.levels,
    quests: raw.quests.quests,
    dialogues: raw.quests.dialogues,
    shops: raw.shops.shops,
    economy: raw.economy,
    liveops: raw.liveops,
    locales,

    byCrop: indexBy(raw.crops.crops, 'crop_id'),
    byItem: indexBy(raw.items.items, 'item_id'),
    byAvatarItem: indexBy(raw.avatar_items.avatar_items, 'item_id'),
    byMap: indexBy(raw.maps.maps, 'map_id'),
    byLevel: indexBy(raw.match3_levels.levels, 'level_id'),
    byQuest: indexBy(raw.quests.quests, 'quest_id'),
    byDialogue: indexBy(raw.quests.dialogues, 'dialogue_id'),
    byShop: indexBy(raw.shops.shops, 'shop_id'),
    byCurrency: indexBy(raw.economy.currencies, 'currency_id'),
    // Mã đổi quà không phân biệt hoa thường: người chơi gõ tay nên chuẩn hoá
    // ngay ở tầng index thay vì mỗi chỗ dùng lại tự upper.
    byGiftcode: new Map(raw.giftcodes.giftcodes.map((g) => [String(g.code).toUpperCase(), g])),
  };

  content.byNpc = new Map();
  for (const map of content.maps) {
    for (const npc of map.npcs) content.byNpc.set(npc.npc_id, { ...npc, map_id: map.map_id });
  }

  const issues = validateContent(content);
  const errors = issues.filter((i) => i.severity === 'error');
  if (errors.length > 0) {
    const list = errors.map((e) => ` - [${e.rule}] ${e.message}`).join('\n');
    throw new Error(`Content không hợp lệ (${errors.length} lỗi):\n${list}`);
  }
  content.warnings = issues.filter((i) => i.severity === 'warning');
  return content;
}

/** Tra chuỗi đã dịch; thiếu key thì fallback về locale gốc rồi tới chính key đó (doc 23). */
export function translate(content, locale, key, params = {}) {
  const table = content.locales[locale]?.strings ?? content.locales.vi?.strings ?? {};
  const fallback = content.locales.vi?.strings ?? {};
  const template = table[key] ?? fallback[key] ?? key;
  return template.replace(/\{(\w+)\}/g, (_, name) => (name in params ? String(params[name]) : `{${name}}`));
}
