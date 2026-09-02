/**
 * Công thức level (doc 09 — level_curve).
 * Bản sao phía client CHỈ để hiển thị thanh XP; server vẫn là nơi quyết định
 * cấp độ thật. Tham số lấy từ /v1/content nên không hard-code hằng số ở đây.
 */
export function xpForLevel(curve, level) {
  return Math.round(curve.base_xp * Math.pow(curve.growth, Math.max(0, level - 1)));
}

/** Tiến độ tới cấp kế tiếp: { current, needed, ratio }. */
export function levelProgress(curve, level, xp) {
  if (level >= curve.max_level) return { current: xp, needed: xp, ratio: 1, maxed: true };
  const needed = xpForLevel(curve, level);
  return { current: xp, needed, ratio: needed > 0 ? Math.min(1, xp / needed) : 0, maxed: false };
}
