/**
 * Sinh ID dạng snowflake-like (doc 14): thời gian + shard + counter, base36.
 * Không lộ sequence của database và vẫn sắp xếp được theo thời gian.
 */
import { randomInt } from 'node:crypto';

const EPOCH = Date.UTC(2026, 0, 1);
const SHARD = randomInt(0, 1024);
let counter = randomInt(0, 4096);
let lastMs = 0;

export function newId(prefix) {
  let now = Date.now();
  if (now === lastMs) counter = (counter + 1) & 0xfff;
  else { lastMs = now; counter = randomInt(0, 4096); }
  const ms = BigInt(now - EPOCH);
  const value = (ms << 22n) | (BigInt(SHARD) << 12n) | BigInt(counter);
  return `${prefix}_${value.toString(36)}`;
}
