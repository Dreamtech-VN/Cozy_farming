/**
 * Farming (doc 06). Server giữ timestamp authoritative: client chỉ hiển thị.
 * Trạng thái cây được tính từ planted_at/ready_at nên offline progress là "miễn phí".
 */
import { newId } from '../lib/ids.js';
import { transaction } from '../db/index.js';
import { badRequest, conflict, notFound } from '../lib/errors.js';
import { applyChange, xpForLevel } from './economy.js';
import { createRng, randomSeed } from '../lib/rng.js';

export function createFarm(db, content, characterId, now = Date.now()) {
  const farmId = newId('farm');
  const plots = content.economy.farm.starting_plots;
  db.prepare('INSERT INTO farms (id, character_id, level, xp, plot_count, created_at, updated_at) VALUES (?, ?, 1, 0, ?, ?, ?)')
    .run(farmId, characterId, plots, now, now);
  const insert = db.prepare('INSERT INTO farm_plots (id, farm_id, slot_index, state, updated_at) VALUES (?, ?, ?, \'empty\', ?)');
  for (let i = 0; i < plots; i++) insert.run(newId('plot'), farmId, i, now);
  return farmId;
}

export function getFarm(db, content, characterId, now = Date.now()) {
  const farm = db.prepare('SELECT * FROM farms WHERE character_id = ?').get(characterId);
  if (!farm) throw notFound('Nông trại chưa được tạo');
  const plots = db.prepare('SELECT * FROM farm_plots WHERE farm_id = ? ORDER BY slot_index').all(farm.id);
  return {
    farm_id: farm.id,
    level: farm.level,
    xp: farm.xp,
    xp_to_next: xpForLevel(content.economy.farm.farm_level_xp, farm.level),
    plot_count: farm.plot_count,
    plots: plots.map((plot) => viewPlot(content, plot, now)),
    next_unlock: content.economy.farm.plot_unlock.find((u) => u.plots > farm.plot_count) ?? null,
  };
}

/** Trạng thái hiển thị của một ô đất, suy ra từ mốc thời gian server. */
function viewPlot(content, plot, now) {
  const view = {
    plot_id: plot.id,
    slot_index: plot.slot_index,
    state: plot.state,
    crop_id: plot.crop_id,
    planted_at: plot.planted_at,
    ready_at: plot.ready_at,
    stage: 0,
    seconds_left: 0,
  };
  if (plot.state !== 'seeded' || !plot.crop_id) return view;

  const crop = content.byCrop.get(plot.crop_id);
  const total = plot.ready_at - plot.planted_at;
  const elapsed = Math.max(0, now - plot.planted_at);
  if (now >= plot.ready_at) {
    view.state = 'mature';
    view.stage = crop.stages - 1;
    return view;
  }
  view.state = 'growing';
  view.stage = Math.min(crop.stages - 2, Math.floor((elapsed / total) * (crop.stages - 1)));
  view.seconds_left = Math.ceil((plot.ready_at - now) / 1000);
  return view;
}

function loadPlot(db, characterId, plotId) {
  const row = db.prepare(`SELECT p.* FROM farm_plots p JOIN farms f ON f.id = p.farm_id
                          WHERE p.id = ? AND f.character_id = ?`).get(plotId, characterId);
  if (!row) throw notFound('Không tìm thấy ô đất này');
  return row;
}

export function plant(db, content, characterId, { plotId, cropId, idempotencyKey }) {
  const now = Date.now();
  const crop = content.byCrop.get(cropId);
  if (!crop) throw badRequest(`crop không tồn tại: ${cropId}`);

  const farm = db.prepare('SELECT * FROM farms WHERE character_id = ?').get(characterId);
  if (!farm) throw notFound('Nông trại chưa được tạo');
  if (farm.level < crop.unlock_farm_level) {
    throw conflict('Nông trại chưa đủ cấp cho loại cây này', { required_farm_level: crop.unlock_farm_level, farm_level: farm.level });
  }

  const plot = loadPlot(db, characterId, plotId);
  if (plot.state === 'seeded') throw conflict('Ô đất đang có cây');

  // Trừ hạt giống và gieo trong cùng một transaction.
  return transaction(db, () => {
    applyChange(db, content, characterId, { items: [{ item_id: crop.seed_item_id, count: -1 }] },
      { kind: 'farm_plant', idempotencyKey });
    const readyAt = now + crop.growth_seconds * 1000;
    db.prepare('UPDATE farm_plots SET state = ?, crop_id = ?, planted_at = ?, ready_at = ?, updated_at = ? WHERE id = ?')
      .run('seeded', cropId, now, readyAt, now, plot.id);
    return { plot: viewPlot(content, { ...plot, state: 'seeded', crop_id: cropId, planted_at: now, ready_at: readyAt }, now) };
  });
}

export function harvest(db, content, characterId, { plotId, idempotencyKey }) {
  const now = Date.now();
  const plot = loadPlot(db, characterId, plotId);
  if (plot.state !== 'seeded' || !plot.crop_id) throw conflict('Ô đất không có cây để thu hoạch');
  if (now < plot.ready_at) throw conflict('Cây chưa chín', { seconds_left: Math.ceil((plot.ready_at - now) / 1000) });

  const crop = content.byCrop.get(plot.crop_id);
  // Seed từ chính ô đất -> cùng một lần thu hoạch luôn cho cùng kết quả, kể cả khi client retry.
  const rng = createRng(hashSeed(plot.id, plot.planted_at));
  const items = crop.yield_table.map((entry) => ({
    item_id: entry.item_id,
    count: entry.min + Math.floor(rng() * (entry.max - entry.min + 1)),
  }));

  return transaction(db, () => {
    const change = applyChange(db, content, characterId, { items, xp: crop.xp },
      { kind: 'farm_harvest', idempotencyKey: idempotencyKey ?? `harvest:${plot.id}:${plot.planted_at}` });
    db.prepare('UPDATE farm_plots SET state = ?, crop_id = NULL, planted_at = NULL, ready_at = NULL, updated_at = ? WHERE id = ?')
      .run('empty', now, plot.id);
    addFarmXp(db, content, characterId, crop.xp, now);
    return { harvested: items, crop_id: crop.crop_id, transaction: change };
  });
}

function hashSeed(...parts) {
  let hash = 2166136261;
  for (const part of parts.join('|')) hash = Math.imul(hash ^ part.charCodeAt(0), 16777619);
  return hash >>> 0;
}

export function addFarmXp(db, content, characterId, xp, now = Date.now()) {
  const curve = content.economy.farm.farm_level_xp;
  const farm = db.prepare('SELECT * FROM farms WHERE character_id = ?').get(characterId);
  if (!farm) return null;
  let level = farm.level;
  let total = farm.xp + xp;
  while (level < curve.max_level && total >= xpForLevel(curve, level)) {
    total -= xpForLevel(curve, level);
    level += 1;
  }
  db.prepare('UPDATE farms SET level = ?, xp = ?, updated_at = ? WHERE id = ?').run(level, total, now, farm.id);
  return { level, xp: total };
}

/** Mở thêm ô đất (doc 09 — sink coin chính của farming). */
export function expandPlots(db, content, characterId, { idempotencyKey } = {}) {
  const now = Date.now();
  const farm = db.prepare('SELECT * FROM farms WHERE character_id = ?').get(characterId);
  if (!farm) throw notFound('Nông trại chưa được tạo');
  const unlock = content.economy.farm.plot_unlock.find((u) => u.plots > farm.plot_count);
  if (!unlock) throw conflict('Nông trại đã mở tối đa');
  if (farm.level < unlock.farm_level) {
    throw conflict('Nông trại chưa đủ cấp', { required_farm_level: unlock.farm_level, farm_level: farm.level });
  }

  return transaction(db, () => {
    applyChange(db, content, characterId, { currencies: { coin: -unlock.coin } },
      { kind: 'farm_expand', idempotencyKey: idempotencyKey ?? `expand:${farm.id}:${unlock.plots}` });
    const insert = db.prepare('INSERT INTO farm_plots (id, farm_id, slot_index, state, updated_at) VALUES (?, ?, ?, \'empty\', ?)');
    for (let i = farm.plot_count; i < unlock.plots; i++) insert.run(newId('plot'), farm.id, i, now);
    db.prepare('UPDATE farms SET plot_count = ?, updated_at = ? WHERE id = ?').run(unlock.plots, now, farm.id);
    return { plot_count: unlock.plots, spent: { coin: unlock.coin } };
  });
}

export { randomSeed };
