#!/usr/bin/env node
/**
 * Chuyển bộ tài liệu thiết kế (.docx) sang Markdown trong docs/.
 *
 * Tài liệu Word là bản gốc do Game Production phát hành; Markdown trong repo là
 * bản đọc/diff được cho engineer. Chạy lại script này mỗi khi nhận bản .docx mới:
 *
 *   node tools/docx-to-markdown.mjs <thu-muc-chua-docx>
 *
 * Chỉ dùng thư viện chuẩn của Node: docx là zip, phần cần đọc là word/document.xml.
 */
import { createInflateRaw } from 'node:zlib';
import { readFile, writeFile, readdir, mkdir } from 'node:fs/promises';
import { join, basename, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');

/** Đọc một entry trong file zip mà không cần dependency ngoài. */
async function readZipEntry(zipPath, entryName) {
  const buf = await readFile(zipPath);
  // Quét End Of Central Directory để lấy offset của central directory.
  let eocd = -1;
  for (let i = buf.length - 22; i >= 0; i--) {
    if (buf.readUInt32LE(i) === 0x06054b50) { eocd = i; break; }
  }
  if (eocd < 0) throw new Error(`${zipPath}: không tìm thấy EOCD, file zip hỏng`);
  const entries = buf.readUInt16LE(eocd + 10);
  let p = buf.readUInt32LE(eocd + 16);
  for (let i = 0; i < entries; i++) {
    if (buf.readUInt32LE(p) !== 0x02014b50) throw new Error('central directory hỏng');
    const method = buf.readUInt16LE(p + 10);
    const compressedSize = buf.readUInt32LE(p + 20);
    const nameLen = buf.readUInt16LE(p + 28);
    const extraLen = buf.readUInt16LE(p + 30);
    const commentLen = buf.readUInt16LE(p + 32);
    const localOffset = buf.readUInt32LE(p + 42);
    const name = buf.toString('utf8', p + 46, p + 46 + nameLen);
    if (name === entryName) {
      const lNameLen = buf.readUInt16LE(localOffset + 26);
      const lExtraLen = buf.readUInt16LE(localOffset + 28);
      const start = localOffset + 30 + lNameLen + lExtraLen;
      const raw = buf.subarray(start, start + compressedSize);
      if (method === 0) return raw.toString('utf8');
      return await new Promise((resolve, reject) => {
        const chunks = [];
        const inflate = createInflateRaw();
        inflate.on('data', (c) => chunks.push(c));
        inflate.on('end', () => resolve(Buffer.concat(chunks).toString('utf8')));
        inflate.on('error', reject);
        inflate.end(raw);
      });
    }
    p += 46 + nameLen + extraLen + commentLen;
  }
  throw new Error(`${zipPath}: không có entry ${entryName}`);
}

const unescapeXml = (s) => s
  .replace(/&lt;/g, '<').replace(/&gt;/g, '>')
  .replace(/&quot;/g, '"').replace(/&apos;/g, "'")
  .replace(/&#(\d+);/g, (_, d) => String.fromCodePoint(Number(d)))
  .replace(/&amp;/g, '&');

/** Gom toàn bộ <w:t> trong một đoạn XML thành chuỗi text. */
const textOf = (xml) => unescapeXml(
  [...xml.matchAll(/<w:t(?:\s[^>]*)?>([\s\S]*?)<\/w:t>/g)].map((m) => m[1]).join('')
).trim();

/** Tách body thành danh sách block: paragraph hoặc table, giữ đúng thứ tự. */
function splitBlocks(xml) {
  const blocks = [];
  const re = /<w:(p|tbl)(?:\s[^>]*)?(?:\/>|>([\s\S]*?)<\/w:\1>)/g;
  for (const m of xml.matchAll(re)) {
    blocks.push({ kind: m[1], xml: m[2] ?? '' });
  }
  return blocks;
}

function tableToMarkdown(tblXml) {
  const rows = [...tblXml.matchAll(/<w:tr(?:\s[^>]*)?>([\s\S]*?)<\/w:tr>/g)].map((tr) =>
    [...tr[1].matchAll(/<w:tc(?:\s[^>]*)?>([\s\S]*?)<\/w:tc>/g)].map((tc) => textOf(tc[1]))
  );
  if (rows.length === 0) return [];
  const width = Math.max(...rows.map((r) => r.length));
  const pad = (r) => Array.from({ length: width }, (_, i) => r[i] ?? '');
  const out = [`| ${pad(rows[0]).join(' | ')} |`, `| ${pad([]).map(() => '---').join(' | ')} |`];
  for (const r of rows.slice(1)) out.push(`| ${pad(r).join(' | ')} |`);
  return out;
}

function docxToMarkdown(xml) {
  const body = xml.slice(xml.indexOf('<w:body>'), xml.lastIndexOf('</w:body>'));
  const lines = [];
  let titleSeen = 0;
  let numbered = 0;

  for (const block of splitBlocks(body)) {
    if (block.kind === 'tbl') {
      if (lines.at(-1) !== '') lines.push('');
      lines.push(...tableToMarkdown(block.xml), '');
      numbered = 0;
      continue;
    }
    const text = textOf(block.xml);
    if (!text) continue;
    const style = block.xml.match(/<w:pStyle w:val="([^"]+)"/)?.[1] ?? '';

    if (style === 'Heading1') {
      if (lines.at(-1) !== '') lines.push('');
      lines.push(`## ${text}`, '');
      numbered = 0;
    } else if (style === 'ListBullet') {
      lines.push(`- ${text}`);
    } else if (style === 'ListNumber') {
      lines.push(`${++numbered}. ${text}`);
    } else if (titleSeen === 0) {
      // Dòng đầu là tên dự án (banner), dòng thứ hai mới là tiêu đề tài liệu.
      titleSeen = 1;
      lines.push(`> ${text}`, '');
    } else if (titleSeen === 1) {
      titleSeen = 2;
      lines.unshift(`# ${text}`, '');
    } else {
      if (lines.at(-1)?.startsWith('- ') || lines.at(-1)?.match(/^\d+\. /)) lines.push('');
      lines.push(text, '');
      numbered = 0;
    }
  }
  return lines.join('\n').replace(/\n{3,}/g, '\n\n').trim() + '\n';
}

const srcDir = process.argv[2];
if (!srcDir) {
  console.error('Cách dùng: node tools/docx-to-markdown.mjs <thu-muc-chua-docx>');
  process.exit(2);
}
const outDir = join(ROOT, 'docs');
await mkdir(outDir, { recursive: true });
const files = (await readdir(srcDir)).filter((f) => f.endsWith('.docx') && !f.startsWith('~$')).sort();
for (const file of files) {
  const xml = await readZipEntry(join(srcDir, file), 'word/document.xml');
  const md = docxToMarkdown(xml);
  const out = join(outDir, basename(file, '.docx') + '.md');
  await writeFile(out, md);
  console.log(`${file} -> docs/${basename(out)} (${md.length} bytes)`);
}
