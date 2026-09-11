/**
 * Thành tựu: mốc dài hạn, nhiều BẬC.
 *
 * Đọc thẳng từ `character_stats` nên không tự đếm lấy — cùng một con số với
 * bảng xếp hạng, không bao giờ có chuyện hai chỗ nói hai kết quả cho cùng một
 * việc.
 *
 * Nhiều bậc chứ không phải một mốc: xong một phát rồi biến mất thì thành tựu chỉ
 * vui được đúng một lần. Bậc sau mở khi bậc trước ĐÃ NHẬN, nên người chơi luôn
 * nhìn thấy đúng một đích tiếp theo cho mỗi thành tựu.
 */
import { transaction } from '../db/index.js';
import { applyChange } from './economy.js';
import { badRequest, conflict, notFound } from '../lib/errors.js';
import { read } from './stats.js';

const flagKey = (achievementId, tier) => `ach:${achievementId}:${tier}`;

const claimed = (db, characterId, achievementId, tier) =>
  !!db.prepare('SELECT 1 FROM character_flags WHERE character_id = ? AND key = ?')
    .get(characterId, flagKey(achievementId, tier));

/** Bậc đang làm dở: bậc chưa nhận đầu tiên. `null` khi đã nhận hết. */
function openTier(db, characterId, achievement) {
  return achievement.tiers.find((tier) => !claimed(db, characterId, achievement.achievement_id, tier.tier)) ?? null;
}

export function list(db, content, characterId) {
  return content.achievements.map((achievement) => {
    const value = read(db, characterId, achievement.stat);
    const tier = openTier(db, characterId, achievement);
    return {
      achievement_id: achievement.achievement_id,
      name_key: achievement.name_key,
      desc_key: achievement.desc_key,
      value,
      // Đã nhận hết bậc thì `tier` null — client hiện "xong" chứ không hiện
      // thanh tiến độ đầy mãi mãi.
      tier: tier ? tier.tier : null,
      goal: tier ? tier.goal : null,
      reward: tier ? tier.reward : null,
      claimable: !!tier && value >= tier.goal,
      total_tiers: achievement.tiers.length,
      done_tiers: achievement.tiers.length - (tier ? achievement.tiers.length - achievement.tiers.indexOf(tier) : 0),
    };
  });
}

export function claim(db, content, characterId, achievementId, now = Date.now()) {
  const achievement = content.achievements.find((a) => a.achievement_id === achievementId);
  if (!achievement) throw notFound(`thành tựu không tồn tại: ${achievementId}`);
  const tier = openTier(db, characterId, achievement);
  if (!tier) throw conflict('Đã nhận hết các bậc của thành tựu này');
  const value = read(db, characterId, achievement.stat);
  if (value < tier.goal) throw badRequest(`Chưa đạt: ${value}/${tier.goal}`);

  return transaction(db, () => {
    // Ghi cờ TRƯỚC khi phát thưởng, và để KHOÁ CHÍNH chặn trùng: hai lần bấm
    // cùng lúc thì lần thứ hai vỡ ràng buộc, cả giao dịch bị huỷ, chứ không phát
    // thưởng hai lần. Kèm cả khoá chống trùng ở `applyChange` cho chắc — tiền
    // bạc thì hai lớp chặn vẫn hơn một.
    db.prepare('INSERT INTO character_flags (character_id, key, value, updated_at) VALUES (?, ?, ?, ?)')
      .run(characterId, flagKey(achievementId, tier.tier), String(now), now);
    const change = applyChange(db, content, characterId, {
      currencies: { coin: tier.reward.coin ?? 0, gem: tier.reward.gem ?? 0 },
      items: (tier.reward.items ?? []).map((r) => ({ item_id: r.item_id, count: r.count })),
      xp: tier.reward.xp ?? 0,
    }, { kind: 'achievement_claim', idempotencyKey: `ach:${achievementId}:${tier.tier}` });
    return { achievement_id: achievementId, tier: tier.tier, reward: tier.reward, transaction: change };
  });
}
