/**
 * Điểm danh hằng ngày (doc 09 — economy).
 *
 * Đây là lịch thưởng theo KHOẢNG THỜI GIAN cố định: mỗi ngày một lần, chuỗi
 * liên tiếp đi tiếp trong chu kỳ 7 ngày, bỏ một ngày là quay về ngày 1. Ba việc
 * nó giải quyết cùng lúc:
 *   - nhịp một phiên chơi đang phẳng, vào game không có gì để nhận;
 *   - ngọc chỉ có một nguồn lặp lại 10/tuần trong khi bồn tiêu tới 525/tuần;
 *   - thói quen quay lại, thứ mà game live-service sống nhờ.
 *
 * Ngày do SERVER quyết (doc 13): client đổi giờ máy không ăn thêm được lượt.
 */
import { conflict } from '../lib/errors.js';
import { transaction } from '../db/index.js';
import { applyChange } from './economy.js';
import { logEvent } from './analytics.js';

const DAY_MS = 86_400_000;

/** Số thứ tự ngày theo múi giờ khai báo trong content. */
export function dayIndex(content, now = Date.now()) {
  const offset = (content.economy.daily_rewards?.timezone_offset_minutes ?? 0) * 60_000;
  return Math.floor((now + offset) / DAY_MS);
}

const cycleOf = (content) => content.economy.daily_rewards?.cycle ?? [];

export function getDaily(db, content, characterId, now = Date.now()) {
  const cycle = cycleOf(content);
  const today = dayIndex(content, now);
  const row = db.prepare('SELECT * FROM daily_rewards WHERE character_id = ?').get(characterId);

  const claimedToday = row?.last_claim_day === today;
  // Chuỗi sẽ thành bao nhiêu NẾU nhận bây giờ — client cần số này để tô đúng ô.
  const nextStreak = !row ? 1 : row.last_claim_day === today - 1 ? row.streak + 1 : 1;
  const streak = claimedToday ? row.streak : nextStreak;

  return {
    can_claim: !claimedToday,
    streak,
    // Vị trí trong chu kỳ, đếm từ 0.
    position: (streak - 1) % cycle.length,
    total_claims: row?.total_claims ?? 0,
    cycle,
  };
}

export function claimDaily(db, content, characterId, now = Date.now()) {
  const cycle = cycleOf(content);
  if (cycle.length === 0) throw conflict('Chưa cấu hình phần thưởng điểm danh');

  return transaction(db, () => {
    const today = dayIndex(content, now);
    const row = db.prepare('SELECT * FROM daily_rewards WHERE character_id = ?').get(characterId);
    if (row?.last_claim_day === today) throw conflict('Hôm nay đã điểm danh rồi');

    const streak = !row ? 1 : row.last_claim_day === today - 1 ? row.streak + 1 : 1;
    const position = (streak - 1) % cycle.length;
    const reward = cycle[position];

    db.prepare(`INSERT INTO daily_rewards (character_id, last_claim_day, streak, total_claims)
                VALUES (?, ?, ?, 1)
                ON CONFLICT (character_id) DO UPDATE SET
                  last_claim_day = excluded.last_claim_day,
                  streak = excluded.streak,
                  total_claims = daily_rewards.total_claims + 1`)
      .run(characterId, today, streak);

    // Khoá idempotent gắn với NGÀY nên hai request song song chỉ cộng một lần.
    const result = applyChange(db, content, characterId, reward, {
      kind: 'daily_reward',
      idempotencyKey: `daily:${today}`,
      detail: { day: reward.day, streak },
    });
    logEvent(db, characterId, 'daily_claim', { streak, day: reward.day });
    return { streak, position, day: reward.day, ...result };
  });
}
