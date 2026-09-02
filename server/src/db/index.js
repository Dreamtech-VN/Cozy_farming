/**
 * Kết nối SQLite + migration runner (doc 14, doc 21).
 * SQLite đủ cho local/dev/staging và cho test tự động; interface truy vấn được
 * giữ mỏng để đổi sang Postgres ở production mà không đụng tới domain layer.
 */
import { DatabaseSync } from 'node:sqlite';
import { readFileSync, readdirSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { logger } from '../lib/logger.js';

const MIGRATIONS_DIR = join(dirname(fileURLToPath(import.meta.url)), 'migrations');

export function openDatabase(dbFile) {
  if (dbFile !== ':memory:') mkdirSync(dirname(dbFile), { recursive: true });
  const db = new DatabaseSync(dbFile);
  db.exec('PRAGMA journal_mode = WAL');
  db.exec('PRAGMA foreign_keys = ON');
  db.exec('PRAGMA busy_timeout = 5000');
  migrate(db);
  return db;
}

function migrate(db) {
  db.exec('CREATE TABLE IF NOT EXISTS schema_migrations (version TEXT PRIMARY KEY, applied_at INTEGER NOT NULL)');
  const applied = new Set(db.prepare('SELECT version FROM schema_migrations').all().map((r) => r.version));
  const files = readdirSync(MIGRATIONS_DIR).filter((f) => f.endsWith('.sql')).sort();
  for (const file of files) {
    const version = file.replace('.sql', '');
    if (applied.has(version)) continue;
    const sql = readFileSync(join(MIGRATIONS_DIR, file), 'utf8');
    db.exec('BEGIN');
    try {
      db.exec(sql);
      db.prepare('INSERT INTO schema_migrations (version, applied_at) VALUES (?, ?)').run(version, Date.now());
      db.exec('COMMIT');
      logger.info('migration applied', { version });
    } catch (err) {
      db.exec('ROLLBACK');
      throw new Error(`migration ${version} thất bại: ${err.message}`);
    }
  }
}

/**
 * Chạy fn trong một transaction. Economy/inventory bắt buộc dùng hàm này
 * để đảm bảo atomicity (doc 14 — Consistency).
 *
 * Tái nhập được: domain layer hay gọi lồng nhau (ví dụ farm.plant gọi
 * economy.applyChange, và cả hai đều muốn nguyên tử). Lần ngoài cùng mở
 * transaction thật, các lần lồng bên trong dùng SAVEPOINT — nên rollback của
 * lớp trong không phá commit của lớp ngoài, và ngược lại lớp ngoài rollback
 * thì mọi thứ bên trong cũng mất theo.
 */
const depths = new WeakMap();

export function transaction(db, fn) {
  const depth = depths.get(db) ?? 0;
  const savepoint = depth > 0 ? `sp_${depth}` : null;

  if (savepoint) db.exec(`SAVEPOINT ${savepoint}`);
  else db.exec('BEGIN IMMEDIATE');
  depths.set(db, depth + 1);

  try {
    const result = fn();
    if (savepoint) db.exec(`RELEASE ${savepoint}`);
    else db.exec('COMMIT');
    return result;
  } catch (err) {
    if (savepoint) db.exec(`ROLLBACK TO ${savepoint}`);
    else db.exec('ROLLBACK');
    throw err;
  } finally {
    depths.set(db, depth);
  }
}
