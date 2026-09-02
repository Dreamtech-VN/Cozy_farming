/** Structured log (doc 13 — observability). Một dòng JSON cho mỗi sự kiện. */
import { config } from '../config.js';

const LEVELS = { debug: 10, info: 20, warn: 30, error: 40 };

function emit(level, message, fields) {
  if (LEVELS[level] < (LEVELS[config.logLevel] ?? 20)) return;
  const line = { ts: new Date().toISOString(), level, message, ...fields };
  const out = level === 'error' || level === 'warn' ? process.stderr : process.stdout;
  out.write(JSON.stringify(line) + '\n');
}

export const logger = {
  debug: (message, fields = {}) => emit('debug', message, fields),
  info: (message, fields = {}) => emit('info', message, fields),
  warn: (message, fields = {}) => emit('warn', message, fields),
  error: (message, fields = {}) => emit('error', message, fields),
};
