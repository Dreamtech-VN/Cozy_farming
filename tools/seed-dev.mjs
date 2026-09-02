#!/usr/bin/env node
/**
 * Tạo dữ liệu dev: vài tài khoản có sẵn tài nguyên, nông trại đang trồng dở và
 * một ít lịch sử chat, để QA/designer mở game là có gì đó để xem ngay.
 * KHÔNG dùng ở production.
 */
import { config } from '../server/src/config.js';
import { loadContent } from '../server/src/content/index.js';
import { openDatabase } from '../server/src/db/index.js';
import { register } from '../server/src/domain/player.js';
import { applyChange } from '../server/src/domain/economy.js';
import { plant } from '../server/src/domain/farm.js';
import { postMessage } from '../server/src/domain/social.js';

if (config.env === 'production') {
  console.error('Không chạy seed trên production.');
  process.exit(1);
}

const content = loadContent({ dataDir: config.dataDir, localeDir: config.localeDir });
const db = openDatabase(config.dbFile);

const ACCOUNTS = [
  { username: 'demo_farmer', nickname: 'Bé Na', crop: 'crop_carrot' },
  { username: 'demo_player', nickname: 'Cu Tí', crop: 'crop_turnip' },
  { username: 'demo_social', nickname: 'Chị Hai', crop: null },
];

for (const account of ACCOUNTS) {
  if (db.prepare('SELECT 1 AS ok FROM users WHERE username = ?').get(account.username)) {
    console.log(`bỏ qua ${account.username} (đã có)`);
    continue;
  }
  const created = await register(db, content, {
    username: account.username,
    password: 'demo-password-1',
    nickname: account.nickname,
  });

  applyChange(db, content, created.character_id, {
    currencies: { coin: 50_000, gem: 500, energy: 60 },
    items: content.crops.slice(0, 6).map((crop) => ({ item_id: crop.seed_item_id, count: 20 })),
    xp: 1500,
  }, { kind: 'dev_seed' });

  if (account.crop) {
    const farm = db.prepare('SELECT id FROM farms WHERE character_id = ?').get(created.character_id);
    const plots = db.prepare('SELECT id FROM farm_plots WHERE farm_id = ? ORDER BY slot_index LIMIT 3').all(farm.id);
    for (const plot of plots) plant(db, content, created.character_id, { plotId: plot.id, cropId: account.crop });
  }

  const character = db.prepare('SELECT * FROM characters WHERE id = ?').get(created.character_id);
  postMessage(db, content, character, { channel: 'world', body: `${account.nickname} vừa vào thế giới!` });
  console.log(`đã tạo ${account.username} / demo-password-1 (${account.nickname})`);
}

db.close();
console.log('seed xong.');
