/**
 * Hướng dẫn người mới.
 *
 * Không phải mấy trang chữ bấm Tiếp. Mỗi bước là một việc PHẢI TỰ LÀM — đi một
 * đoạn, nói chuyện với một người, gieo một hạt — và chỉ xong khi người chơi làm
 * thật. Đọc thì quên, làm thì nhớ; mà game này vốn đã có sẵn từng ấy việc, chỉ
 * thiếu người chỉ cho biết chúng tồn tại.
 *
 * Tiến trình giữ ở SERVER chứ không ở localStorage: đổi máy, đổi trình duyệt,
 * xoá cache — người chơi không phải học lại từ đầu, mà cũng không thể lỡ tay bỏ
 * qua rồi kẹt giữa chừng.
 *
 * Bước lưu bằng TÊN chứ không phải số thứ tự. Đánh số thì chèn thêm một bước vào
 * giữa là mọi người chơi đang dở nhảy sang bước khác — cùng lý do với
 * `character_flags` trong migration 007.
 */
const KEY = 'onboarding';

const read = (db, characterId) =>
  db.prepare('SELECT value FROM character_flags WHERE character_id = ? AND key = ?').get(characterId, KEY)?.value ?? null;

const write = (db, characterId, value, now) =>
  db.prepare(`INSERT INTO character_flags (character_id, key, value, updated_at) VALUES (?, ?, ?, ?)
              ON CONFLICT (character_id, key) DO UPDATE SET value = excluded.value, updated_at = excluded.updated_at`)
    .run(characterId, KEY, value, now);

/** Đã làm xong hết thì trả về `null` — client hiểu là ẩn thẻ hướng dẫn đi. */
export function currentStep(db, content, characterId) {
  const done = read(db, characterId);
  if (done === 'done') return null;
  // Chưa có dòng nào nghĩa là nhân vật mới toanh: bắt đầu từ bước đầu.
  const index = done ? content.onboarding.findIndex((s) => s.step_id === done) + 1 : 0;
  // Bước đã lưu không còn trong content nữa (vừa bị xoá khỏi file) thì
  // `findIndex` ra -1, cộng 1 thành 0 — quay về bước đầu. Thà thế còn hơn kẹt.
  return content.onboarding[index] ?? null;
}

/**
 * Báo người chơi vừa làm một việc. Chỉ nhích khi việc ấy ĐÚNG là bước đang chờ.
 *
 * Client bắn sự kiện khá bừa — đi một bước là bắn `move`, mở bảng nhiệm vụ là
 * bắn `open_quests` — nên ở đây phải lọc. Nhích theo bất cứ sự kiện nào tới thì
 * người chơi mở nhầm một bảng là nhảy mất hai bước.
 */
export function report(db, content, characterId, event, now = Date.now()) {
  const step = currentStep(db, content, characterId);
  if (!step || step.event !== event) return { step, advanced: false };
  const index = content.onboarding.findIndex((s) => s.step_id === step.step_id);
  const next = content.onboarding[index + 1] ?? null;
  write(db, characterId, next ? step.step_id : 'done', now);
  return { step: next, advanced: true, finished: !next };
}

/** Bỏ qua toàn bộ: người chơi cũ lập nhân vật mới không phải học lại. */
export function skip(db, characterId, now = Date.now()) {
  write(db, characterId, 'done', now);
}
