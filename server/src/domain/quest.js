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
  // `newbie` là chuỗi nhiệm vụ tân thủ: mở dần theo ngày nhưng KHÔNG reset. Ai
  // bỏ lỡ ngày 3 thì hôm sau vẫn làm được — chuỗi dẫn người mới đi tiếp, không
  // phải cái bẫy phạt người bận.
  if (type === 'daily') return date.toISOString().slice(0, 10);
  if (type === 'weekly') {
    const monday = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()));
    monday.setUTCDate(monday.getUTCDate() - ((monday.getUTCDay() + 6) % 7));
    return `w${monday.toISOString().slice(0, 10)}`;
  }
  return '';
}

const rowKey = (quest, now) => periodKey(quest.type, now);

/**
 * Lúc chu kỳ hiện tại hết hạn. `null` với nhiệm vụ không reset.
 *
 * Có con số này thì "việc trong ngày" mới thật sự CÓ HẠN: client đếm ngược được,
 * và người chơi thấy mình còn bao lâu thay vì đoán. Tính ở server vì mốc reset
 * theo UTC — để client tự suy từ giờ máy nó là mỗi múi giờ ra một hạn khác.
 */
function expiresAt(type, now) {
  const date = new Date(now);
  const midnight = Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()) + 86_400_000;
  if (type === 'daily') return midnight;
  if (type === 'weekly') return midnight + ((7 - ((date.getUTCDay() + 6) % 7) - 1) * 86_400_000);
  return null;
}

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

/** Ngày thứ mấy kể từ lúc lập nhân vật, đếm từ 1. */
function dayOfLife(db, characterId, now) {
  const born = db.prepare('SELECT created_at FROM characters WHERE id = ?').get(characterId)?.created_at;
  if (!born) return 1;
  // Đếm theo NGÀY LỊCH chứ không theo số giờ trôi qua: lập nhân vật lúc 23h thì
  // một tiếng sau đã là ngày 2, đúng như người chơi hiểu "hôm sau".
  const day = (t) => Math.floor(t / 86_400_000);
  return day(now) - day(born) + 1;
}

/**
 * Nhiệm vụ nào của một BỂ LUÂN PHIÊN được mở trong chu kỳ này.
 *
 * Sự kiện ngày cần "mỗi hôm một việc khác", nhưng không đáng lưu state: suy
 * thẳng từ khoá chu kỳ, thế là mọi người chơi thấy cùng một việc trong cùng một
 * ngày, không bảng nào phải ghi, không có gì để lệch giữa các tiến trình — cùng
 * cách `world_clock` đang làm.
 */
function pickedFromPool(content, pool, key) {
  const members = content.quests.filter((q) => q.pool === pool).map((q) => q.quest_id).sort();
  if (!members.length) return null;
  let hash = 0;
  for (const ch of key) hash = (hash * 31 + ch.charCodeAt(0)) >>> 0;
  return members[hash % members.length];
}

/** Quest đã đủ điều kiện xuất hiện với nhân vật này chưa (doc 11 — prerequisites). */
function isAvailable(db, content, characterId, quest, now) {
  for (const prereq of quest.prerequisites ?? []) {
    const done = db.prepare('SELECT state FROM quest_progress WHERE character_id = ? AND quest_id = ? AND state = \'claimed\'')
      .get(characterId, prereq);
    if (!done) return false;
  }
  if (quest.unlock_day && dayOfLife(db, characterId, now) < quest.unlock_day) return false;
  if (quest.pool && pickedFromPool(content, quest.pool, periodKey(quest.type, now)) !== quest.quest_id) return false;
  return true;
}

export function listQuests(db, content, characterId, now = Date.now()) {
  const out = [];
  for (const quest of content.quests) {
    if (!isAvailable(db, content, characterId, quest, now)) continue;
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
      expires_at: expiresAt(quest.type, now),
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
    if (!isAvailable(db, content, characterId, quest, now)) continue;

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
