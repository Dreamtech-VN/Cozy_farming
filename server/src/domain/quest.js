/**
 * Quest & progression (doc 11).
 * Tiến độ được cập nhật bằng "event" do các domain khác bắn ra
 * (harvest, match3_win, visit_map, talk_npc, ...) chứ không do client tự khai báo.
 */
import { transaction } from '../db/index.js';
import { applyChange } from './economy.js';
import { badRequest, conflict, notFound } from '../lib/errors.js';

/** Quest daily/weekly reset theo chu kỳ; period_key giữ tiến độ của chu kỳ hiện tại. */
export function periodKey(type, now = Date.now()) {
  const date = new Date(now);
  if (type === 'daily') return date.toISOString().slice(0, 10);
  if (type === 'weekly') {
    const monday = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()));
    monday.setUTCDate(monday.getUTCDate() - ((monday.getUTCDay() + 6) % 7));
    return `w${monday.toISOString().slice(0, 10)}`;
  }
  return '';
}

const rowKey = (quest, now) => periodKey(quest.type, now);

function ensureRow(db, characterId, quest, now) {
  const key = rowKey(quest, now);
  const existing = db.prepare('SELECT * FROM quest_progress WHERE character_id = ? AND quest_id = ? AND period_key = ?')
    .get(characterId, quest.quest_id, key);
  if (existing) return existing;
  db.prepare('INSERT INTO quest_progress (character_id, quest_id, state, progress, period_key, started_at) VALUES (?, ?, \'active\', \'{}\', ?, ?)')
    .run(characterId, quest.quest_id, key, now);
  return db.prepare('SELECT * FROM quest_progress WHERE character_id = ? AND quest_id = ? AND period_key = ?')
    .get(characterId, quest.quest_id, key);
}

/** Quest đã đủ điều kiện xuất hiện với nhân vật này chưa (doc 11 — prerequisites). */
function isAvailable(db, characterId, quest, now) {
  for (const prereq of quest.prerequisites ?? []) {
    const done = db.prepare('SELECT state FROM quest_progress WHERE character_id = ? AND quest_id = ? AND state = \'claimed\'')
      .get(characterId, prereq);
    if (!done) return false;
  }
  return true;
}

export function listQuests(db, content, characterId, now = Date.now()) {
  const out = [];
  for (const quest of content.quests) {
    if (!isAvailable(db, characterId, quest, now)) continue;
    const row = ensureRow(db, characterId, quest, now);
    const progress = JSON.parse(row.progress);
    out.push({
      quest_id: quest.quest_id,
      type: quest.type,
      name_key: quest.name_key,
      desc_key: quest.desc_key,
      dialogue_id: quest.dialogue_id,
      state: row.state,
      rewards: quest.rewards,
      objectives: quest.objectives.map((objective, index) => ({
        ...objective,
        current: Math.min(progress[String(index)] ?? 0, objective.count),
      })),
    });
  }
  return out;
}

/**
 * Ghi nhận một hành động của người chơi vào mọi quest đang mở.
 * type: harvest | collect | match3_win | visit_map | talk_npc | reach_level | buy_item
 */
export function trackProgress(db, content, characterId, type, target, amount = 1, now = Date.now()) {
  const updated = [];
  for (const quest of content.quests) {
    if (!quest.objectives.some((o) => o.type === type)) continue;
    if (!isAvailable(db, characterId, quest, now)) continue;

    const row = ensureRow(db, characterId, quest, now);
    if (row.state !== 'active') continue;

    const progress = JSON.parse(row.progress);
    let changed = false;
    quest.objectives.forEach((objective, index) => {
      if (objective.type !== type) return;
      if (objective.target !== 'any' && String(objective.target) !== String(target)) return;
      const key = String(index);
      const next = Math.min(objective.count, (progress[key] ?? 0) + amount);
      if (next !== (progress[key] ?? 0)) { progress[key] = next; changed = true; }
    });
    if (!changed) continue;

    const complete = quest.objectives.every((objective, index) => (progress[String(index)] ?? 0) >= objective.count);
    db.prepare('UPDATE quest_progress SET progress = ?, state = ?, completed_at = ? WHERE character_id = ? AND quest_id = ? AND period_key = ?')
      .run(JSON.stringify(progress), complete ? 'completed' : 'active', complete ? now : null,
        characterId, quest.quest_id, rowKey(quest, now));
    updated.push({ quest_id: quest.quest_id, state: complete ? 'completed' : 'active', progress });
  }
  return updated;
}

/** Người chơi bấm nhận thưởng. Server kiểm tra lại điều kiện, không tin client. */
export function claimQuest(db, content, characterId, questId, now = Date.now()) {
  const quest = content.byQuest.get(questId);
  if (!quest) throw notFound(`quest không tồn tại: ${questId}`);
  const key = rowKey(quest, now);
  const row = db.prepare('SELECT * FROM quest_progress WHERE character_id = ? AND quest_id = ? AND period_key = ?')
    .get(characterId, questId, key);
  if (!row) throw conflict('Nhiệm vụ chưa được mở');
  if (row.state === 'claimed') throw conflict('Nhiệm vụ đã nhận thưởng');
  if (row.state !== 'completed') throw conflict('Nhiệm vụ chưa hoàn thành');

  return transaction(db, () => {
    const rewards = quest.rewards;
    const change = applyChange(db, content, characterId, {
      currencies: { coin: rewards.coin ?? 0, gem: rewards.gem ?? 0 },
      items: (rewards.items ?? []).map((r) => ({ item_id: r.item_id, count: r.count })),
      avatar_items: rewards.avatar_items ?? [],
      xp: rewards.xp ?? 0,
    }, { kind: 'quest_claim', idempotencyKey: `quest:${questId}:${key}` });

    db.prepare('UPDATE quest_progress SET state = \'claimed\', claimed_at = ? WHERE character_id = ? AND quest_id = ? AND period_key = ?')
      .run(now, characterId, questId, key);
    return { quest_id: questId, rewards, transaction: change };
  });
}

/** Quest reach_level được kiểm tra mỗi khi nhân vật lên cấp. */
export function syncLevelObjectives(db, content, characterId, level, now = Date.now()) {
  for (const quest of content.quests) {
    for (const objective of quest.objectives) {
      if (objective.type !== 'reach_level') continue;
      if (level >= Number(objective.target)) trackProgress(db, content, characterId, 'reach_level', objective.target, 1, now);
    }
  }
}

export function assertObjectiveType(type) {
  const known = ['harvest', 'collect', 'match3_win', 'visit_map', 'talk_npc', 'reach_level', 'buy_item'];
  if (!known.includes(type)) throw badRequest(`objective type không hợp lệ: ${type}`);
}
