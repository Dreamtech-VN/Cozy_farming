#!/usr/bin/env node
/**
 * Kiểm tra tĩnh không phụ thuộc package ngoài:
 *  - mọi file .js parse được;
 *  - mọi import tương đối trỏ tới file có thật (bắt lỗi đổi tên/xoá file);
 *  - mọi .json parse được;
 *  - không còn dấu vết debug bỏ quên trong mã nguồn.
 */
import { readFileSync, readdirSync, statSync, existsSync } from 'node:fs';
import { join, dirname, resolve, extname } from 'node:path';
import { execFileSync } from 'node:child_process';

const ROOT = resolve(import.meta.dirname, '..');
const SCAN = ['server', 'client', 'tools', 'tests', 'data', 'locales'];
const SKIP = new Set(['node_modules', 'var', '.git']);

function walk(dir, out = []) {
  for (const entry of readdirSync(dir)) {
    if (SKIP.has(entry)) continue;
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) walk(full, out);
    else out.push(full);
  }
  return out;
}

/** Mẫu bị cấm trong mã nguồn. */
const BANNED = [
  ['còn sót câu lệnh dừng debug', new RegExp(`\\b${'debug' + 'ger'}\\b`)],
];
const SERVER_BANNED = [
  ['server phải dùng logger có cấu trúc thay cho console.log (doc 13)', /console\.log\(/],
];

const files = SCAN.flatMap((dir) => (existsSync(join(ROOT, dir)) ? walk(join(ROOT, dir)) : []));
const problems = [];

for (const file of files) {
  const relative = file.slice(ROOT.length + 1);
  const ext = extname(file);

  if (ext === '.json') {
    try { JSON.parse(readFileSync(file, 'utf8')); }
    catch (err) { problems.push(`${relative}: JSON không hợp lệ — ${err.message}`); }
    continue;
  }
  if (ext !== '.js' && ext !== '.mjs') continue;

  try {
    execFileSync(process.execPath, ['--check', file], { stdio: 'pipe' });
  } catch (err) {
    problems.push(`${relative}: lỗi cú pháp\n${String(err.stderr).split('\n').slice(0, 4).join('\n')}`);
    continue;
  }

  const source = readFileSync(file, 'utf8');

  for (const match of source.matchAll(/(?:^|\s)(?:import|export)[^'"]*?from\s+['"](\.[^'"]+)['"]/g)) {
    const target = resolve(dirname(file), match[1]);
    if (!existsSync(target)) problems.push(`${relative}: import trỏ tới file không tồn tại — ${match[1]}`);
  }

  // Ghép từ khoá từ mảnh để chính file lint này không tự khớp với luật của nó.
  if (relative !== 'tools/lint.mjs') {
    const rules = relative.startsWith('server/') ? [...BANNED, ...SERVER_BANNED] : BANNED;
    for (const [label, pattern] of rules) {
      if (pattern.test(source)) problems.push(`${relative}: ${label}`);
    }
  }
}

if (problems.length > 0) {
  for (const problem of problems) console.error(`✗ ${problem}`);
  console.error(`\n${problems.length} vấn đề.`);
  process.exit(1);
}
console.log(`✓ lint sạch — đã kiểm tra ${files.length} file.`);
