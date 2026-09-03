/**
 * Hòm thư (doc 08). Thư hệ thống khai báo trong content rồi gửi LƯỜI: chỉ tạo
 * bản ghi khi người chơi mở hòm thư, nên thêm một thư mới không phải chạy job
 * ghi hàng loạt cho mọi tài khoản.
 *
 * Quà đính kèm đi qua economy.applyChange nên vẫn nguyên tử và idempotent như
 * mọi thay đổi tài nguyên khác (doc 13).
 */
import { conflict, notFound } from '../lib/errors.js';
import { newId } from '../lib/ids.js';
import { transaction } from '../db/index.js';
import { applyChange } from './economy.js';
import { logEvent } from './analytics.js';

const KEEP = 50;

const hasAttachments = (attachments) =>
  Object.keys(attachments.currencies ?? {}).length > 0
  || (attachments.items ?? []).length > 0
  || (attachments.avatar_items ?? []).length > 0
  || Boolean(attachments.xp);

/** Tạo bản ghi cho những thư hệ thống người này chưa nhận. */
export function deliverPendingMails(db, content, characterId) {
  const now = Date.now();
  const due = content.mails.filter((mail) =>
    (!mail.starts_at || now >= mail.starts_at) && (!mail.ends_at || now <= mail.ends_at));
  if (due.length === 0) return;

  transaction(db, () => {
    for (const mail of due) {
      // Ghi vào sổ đã gửi TRƯỚC: khoá chính (character_id, source_key) lo phần
      // chống trùng, và vì sổ này tách khỏi hòm thư nên người chơi xoá thư rồi
      // thì thư không quay lại ở lần mở hòm sau.
      const inserted = db.prepare('INSERT OR IGNORE INTO mail_deliveries (character_id, source_key, delivered_at) VALUES (?, ?, ?)')
        .run(characterId, mail.mail_id, now);
      if (inserted.changes === 0) continue;

      db.prepare(`INSERT INTO mails (id, character_id, source_key, subject, body, attachments, created_at, expires_at)
                  VALUES (?, ?, ?, ?, ?, ?, ?, ?)`)
        .run(newId('mail'), characterId, mail.mail_id, mail.subject_key, mail.body_key,
             JSON.stringify(mail.attachments ?? {}), now, mail.ends_at ?? null);
    }
  });
}

const toView = (row) => {
  const attachments = JSON.parse(row.attachments);
  return {
    mail_id: row.id,
    subject_key: row.subject,
    body_key: row.body,
    attachments,
    has_attachments: hasAttachments(attachments),
    read: row.read_at !== null,
    claimed: row.claimed_at !== null,
    created_at: row.created_at,
    expires_at: row.expires_at,
  };
};

export function listMails(db, content, characterId) {
  deliverPendingMails(db, content, characterId);
  const now = Date.now();
  const rows = db.prepare(`SELECT * FROM mails WHERE character_id = ? AND (expires_at IS NULL OR expires_at > ?)
                           ORDER BY created_at DESC LIMIT ?`).all(characterId, now, KEEP);
  const mails = rows.map(toView);
  return {
    mails,
    unread: mails.filter((mail) => !mail.read).length,
    unclaimed: mails.filter((mail) => mail.has_attachments && !mail.claimed).length,
  };
}

const load = (db, characterId, mailId) => {
  const row = db.prepare('SELECT * FROM mails WHERE id = ? AND character_id = ?').get(mailId, characterId);
  if (!row) throw notFound('Không tìm thấy thư');
  return row;
};

export function markRead(db, characterId, mailId) {
  const row = load(db, characterId, mailId);
  if (row.read_at === null) db.prepare('UPDATE mails SET read_at = ? WHERE id = ?').run(Date.now(), mailId);
  return { mail_id: mailId, read: true };
}

export function claimMail(db, content, characterId, mailId) {
  return transaction(db, () => {
    const row = load(db, characterId, mailId);
    const attachments = JSON.parse(row.attachments);
    if (!hasAttachments(attachments)) throw conflict('Thư này không có quà đính kèm');
    if (row.claimed_at !== null) throw conflict('Đã nhận quà của thư này rồi');

    const now = Date.now();
    db.prepare('UPDATE mails SET claimed_at = ?, read_at = COALESCE(read_at, ?) WHERE id = ?').run(now, now, mailId);
    const result = applyChange(db, content, characterId, attachments, {
      kind: 'mail_claim',
      idempotencyKey: `mail:${mailId}`,
      detail: { mail_id: mailId },
    });
    logEvent(db, characterId, 'mail_claim', { mail_id: mailId, source_key: row.source_key });
    return { mail_id: mailId, ...result };
  });
}

/** Chỉ xoá được thư đã đọc và đã nhận hết quà, khỏi mất quà vì lỡ tay. */
export function deleteMail(db, characterId, mailId) {
  const row = load(db, characterId, mailId);
  const attachments = JSON.parse(row.attachments);
  if (hasAttachments(attachments) && row.claimed_at === null) throw conflict('Hãy nhận quà trước khi xoá thư');
  db.prepare('DELETE FROM mails WHERE id = ?').run(mailId);
  return { mail_id: mailId, deleted: true };
}
