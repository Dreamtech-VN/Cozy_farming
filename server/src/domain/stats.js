/**
 * Số liệu tích luỹ cả đời nhân vật.
 *
 * Nguồn DUY NHẤT cho cả thành tựu lẫn bảng xếp hạng. Hai thứ ấy nhìn qua thì
 * khác nhau, nhưng đều hỏi đúng một câu: "người này đã làm việc đó bao nhiêu
 * lần". Để mỗi bên tự đếm thì kiểu gì cũng có lúc bảng xếp hạng nói 40 mà thành
 * tựu nói 38, rồi không ai biết bên nào đúng.
 *
 * Cộng dồn ngay trong `quest.trackProgress` chứ không rải lời gọi ra sáu chỗ
 * bắn sự kiện: thêm nguồn sự kiện mới sau này là nó tự vào đây, không phải nhớ.
 */

/** Khoá thống kê của một loại sự kiện. `null` nghĩa là loại này không đáng đếm. */
export function statKey(type) {
  // `reach_level` không cộng dồn được — cấp là một con số, không phải số lần.
  // Bảng xếp hạng cấp đọc thẳng từ `characters.level`.
  return type === 'reach_level' ? null : `count:${type}`;
}

export function bump(db, characterId, key, amount = 1, now = Date.now()) {
  if (!key || amount <= 0) return;
  db.prepare(`INSERT INTO character_stats (character_id, key, value, updated_at) VALUES (?, ?, ?, ?)
              ON CONFLICT (character_id, key) DO UPDATE SET value = value + excluded.value, updated_at = excluded.updated_at`)
    .run(characterId, key, amount, now);
}

export function read(db, characterId, key) {
  return db.prepare('SELECT value FROM character_stats WHERE character_id = ? AND key = ?').get(characterId, key)?.value ?? 0;
}

export function all(db, characterId) {
  const rows = db.prepare('SELECT key, value FROM character_stats WHERE character_id = ?').all(characterId);
  return Object.fromEntries(rows.map((r) => [r.key, r.value]));
}

/**
 * Bảng xếp hạng theo một khoá.
 *
 * `level` là trường hợp riêng: nó nằm ở `characters` chứ không phải bảng thống
 * kê, vì cấp không phải số lần làm gì. Xếp theo cấp rồi tới XP để hai người cùng
 * cấp vẫn có thứ tự, chứ không phải ai vào trước đứng trên.
 */
export function top(db, key, limit = 20) {
  if (key === 'level') {
    return db.prepare(`SELECT id AS character_id, nickname, level AS value, xp FROM characters
                       ORDER BY level DESC, xp DESC, nickname ASC LIMIT ?`).all(limit)
      .map((r, i) => ({ rank: i + 1, character_id: r.character_id, nickname: r.nickname, value: r.value }));
  }
  return db.prepare(`SELECT s.character_id, c.nickname, s.value FROM character_stats s
                     JOIN characters c ON c.id = s.character_id
                     WHERE s.key = ? AND s.value > 0
                     ORDER BY s.value DESC, c.nickname ASC LIMIT ?`).all(key, limit)
    .map((r, i) => ({ rank: i + 1, character_id: r.character_id, nickname: r.nickname, value: r.value }));
}

/**
 * Hạng của một người, kể cả khi họ không nằm trong bảng đầu.
 *
 * Người chơi hạng 900 mà chỉ thấy top 20 thì bảng xếp hạng chẳng nói gì với họ.
 */
export function rankOf(db, key, characterId) {
  if (key === 'level') {
    const me = db.prepare('SELECT level, xp FROM characters WHERE id = ?').get(characterId);
    if (!me) return null;
    const above = db.prepare('SELECT COUNT(*) AS n FROM characters WHERE level > ? OR (level = ? AND xp > ?)')
      .get(me.level, me.level, me.xp).n;
    return { rank: above + 1, value: me.level };
  }
  const value = read(db, characterId, key);
  if (!value) return null;
  const above = db.prepare('SELECT COUNT(*) AS n FROM character_stats WHERE key = ? AND value > ?').get(key, value).n;
  return { rank: above + 1, value };
}
