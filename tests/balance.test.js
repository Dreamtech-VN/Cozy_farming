import { test, describe } from 'node:test';
import assert from 'node:assert/strict';
import { validateContent } from '../server/src/content/validate.js';
import { loadContent } from '../server/src/content/index.js';
import { config } from '../server/src/config.js';

const content = loadContent({ dataDir: config.dataDir, localeDir: config.localeDir });

/** Số liệu kinh tế của một cây, tính đúng như validator. */
function economics(crop) {
  const seed = content.shops
    .flatMap((s) => s.entries)
    .find((e) => e.item_id === crop.seed_item_id && e.currency === 'coin');
  const total = crop.yield_table.reduce((sum, y) => sum + y.weight, 0);
  const avg = crop.yield_table.reduce((sum, y) => sum + ((y.min + y.max) / 2) * (y.weight / total), 0);
  const hours = crop.growth_seconds / 3600;
  const profit = avg * (content.byItem.get(crop.product_item_id).sell_price ?? 0) - seed.price;
  return { minutes: crop.growth_seconds / 60, coinPerHour: profit / hours, xpPerHour: crop.xp / hours };
}

const planted = content.crops
  .filter((c) => content.shops.some((s) => s.entries.some((e) => e.item_id === c.seed_item_id && e.currency === 'coin')))
  .map((c) => ({ id: c.crop_id, ...economics(c) }))
  .sort((a, b) => a.minutes - b.minutes);

describe('Cân bằng cây trồng (docs/DESIGN-PILLARS.md)', () => {
  test('trồng cây lâu phải cho nhiều xu hơn mỗi giờ', () => {
    for (let i = 1; i < planted.length; i++) {
      assert.ok(
        planted[i].coinPerHour >= planted[i - 1].coinPerHour,
        `${planted[i].id} lớn lâu hơn ${planted[i - 1].id} nhưng chỉ ${Math.round(planted[i].coinPerHour)} xu/giờ so với ${Math.round(planted[i - 1].coinPerHour)}`,
      );
    }
  });

  test('cây ngắn phải cho nhiều XP hơn mỗi giờ — hai trục thắng khác nhau', () => {
    const shortest = planted[0];
    const longest = planted[planted.length - 1];
    assert.ok(
      shortest.xpPerHour > longest.xpPerHour,
      'không được có cây vừa nhiều xu vừa nhiều XP mỗi giờ, nếu không thì hết chỗ cân nhắc',
    );
  });

  test('mở khoá cấp cao không được ra lựa chọn tệ hơn cây cấp 1', () => {
    const base = content.crops.find((c) => c.crop_id === 'crop_carrot');
    const baseRate = economics(base).coinPerHour;
    for (const crop of content.crops) {
      if (crop.unlock_farm_level <= 1) continue;
      if (!content.shops.some((s) => s.entries.some((e) => e.item_id === crop.seed_item_id && e.currency === 'coin'))) continue;
      const rate = economics(crop).coinPerHour;
      assert.ok(rate > baseRate, `${crop.crop_id} mở ở cấp ${crop.unlock_farm_level} mà chỉ ${Math.round(rate)} xu/giờ, kém cà rốt cấp 1 (${Math.round(baseRate)})`);
    }
  });

  test('validator bắt được khi ai đó phá bất biến', () => {
    // Dựng bản sao content với một cây lâu bị hạ giá bán xuống đáy.
    const broken = { ...content, items: content.items.map((i) => (i.item_id === 'item_crop_watermelon' ? { ...i, sell_price: 1 } : i)) };
    const issues = validateContent(broken);
    assert.ok(
      issues.some((i) => i.rule === 'balance'),
      'sửa giá bán làm cây lâu hết đáng trồng thì validator phải kêu',
    );
  });
});
