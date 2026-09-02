#!/usr/bin/env node
/**
 * Chạy validation của content pipeline (doc 18) ngoài luồng server.
 * CI gọi lệnh này trước khi build/deploy: content sai thì fail sớm.
 */
import { loadContent } from '../server/src/content/index.js';
import { validateContent } from '../server/src/content/validate.js';
import { config } from '../server/src/config.js';

let content;
try {
  content = loadContent({ dataDir: config.dataDir, localeDir: config.localeDir });
} catch (err) {
  console.error(err.message);
  process.exit(1);
}

const issues = validateContent(content);
const errors = issues.filter((i) => i.severity === 'error');
const warnings = issues.filter((i) => i.severity === 'warning');

for (const issue of warnings) console.warn(`cảnh báo [${issue.rule}] ${issue.message}`);
for (const issue of errors) console.error(`LỖI    [${issue.rule}] ${issue.message}`);

console.log([
  `content version : ${content.version}`,
  `crops           : ${content.crops.length}`,
  `items           : ${content.items.length}`,
  `cosmetics       : ${content.avatarItems.length}`,
  `maps            : ${content.maps.length}`,
  `match-3 levels  : ${content.levels.length}`,
  `quests          : ${content.quests.length}`,
  `shops           : ${content.shops.length}`,
  `locales         : ${Object.keys(content.locales).join(', ')}`,
  `warnings/errors : ${warnings.length}/${errors.length}`,
].join('\n'));

process.exit(errors.length > 0 ? 1 : 0);
