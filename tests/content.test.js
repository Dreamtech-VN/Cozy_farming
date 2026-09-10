import { test, describe } from 'node:test';
import assert from 'node:assert/strict';
import { loadContent } from '../server/src/content/index.js';
import { validateContent, collectLocalizationKeys } from '../server/src/content/validate.js';
import { config } from '../server/src/config.js';
import { readFileSync } from 'node:fs';

const content = loadContent({ dataDir: config.dataDir, localeDir: config.localeDir });

describe('Content pipeline (doc 18)', () => {
  test('content thật không có lỗi lẫn cảnh báo', () => {
    const issues = validateContent(content);
    assert.deepEqual(issues.filter((i) => i.severity === 'error'), []);
    assert.deepEqual(issues.filter((i) => i.severity === 'warning'), []);
  });

  test('mọi locale phủ đủ key (doc 23)', () => {
    const keys = collectLocalizationKeys(content);
    for (const [locale, table] of Object.entries(content.locales)) {
      const missing = [...keys].filter((k) => !(k in table.strings));
      assert.deepEqual(missing, [], `locale ${locale} thiếu key`);
    }
  });

  test('bắt được duplicate ID', () => {
    const broken = { ...content, crops: [...content.crops, content.crops[0]] };
    const issues = validateContent(broken);
    assert.ok(issues.some((i) => i.rule === 'duplicate_id'));
  });

  test('bắt được reference gãy', () => {
    const broken = {
      ...content,
      crops: content.crops.map((c, i) => (i === 0 ? { ...c, seed_item_id: 'item_khong_ton_tai' } : c)),
    };
    const issues = validateContent(broken);
    assert.ok(issues.some((i) => i.rule === 'missing_ref' && i.message.includes('item_khong_ton_tai')));
  });

  test('bắt được giá trị ngoài khoảng hợp lệ', () => {
    const broken = { ...content, crops: content.crops.map((c, i) => (i === 0 ? { ...c, growth_seconds: 0 } : c)) };
    assert.ok(validateContent(broken).some((i) => i.rule === 'invalid_range'));
  });

  test('bắt được circular prerequisite', () => {
    const a = { quest_id: 'q_a', type: 'main', prerequisites: ['q_b'], objectives: [], rewards: {}, unlocks: [] };
    const b = { quest_id: 'q_b', type: 'main', prerequisites: ['q_a'], objectives: [], rewards: {}, unlocks: [] };
    const issues = validateContent({ ...content, quests: [...content.quests, a, b] });
    assert.ok(issues.some((i) => i.rule === 'circular_prerequisite'));
  });

  test('bắt được localization gap', () => {
    const stripped = {
      ...content,
      locales: { ...content.locales, vi: { ...content.locales.vi, strings: {} } },
    };
    assert.ok(validateContent(stripped).some((i) => i.rule === 'localization_gap'));
  });

  test('mọi portal trỏ tới map và spawn có thật', () => {
    for (const map of content.maps) {
      for (const portal of map.portals) {
        const target = content.byMap.get(portal.target_map_id);
        assert.ok(target, `${map.map_id}: portal tới ${portal.target_map_id}`);
        assert.ok(target.spawn_points.some((s) => s.id === portal.target_spawn));
      }
    }
  });

  // Renderer không còn vẽ hình lui bằng khối màu cho vật hay cửa ngõ nữa: mọi
  // thứ trong map phải có art thật. Bỏ hình lui mà không có bài test này thì
  // khai sai một cái tên là vật ấy BIẾN MẤT trên map, im lặng, không báo gì.
  test('mọi tên sprite khai trong map đều có art thật', () => {
    const atlas = JSON.parse(readFileSync('client/assets/world/atlas.json', 'utf8'));
    const have = new Set(Object.keys(atlas.sprites.index));
    for (const map of content.maps) {
      for (const object of map.objects ?? []) {
        if (object.sprite) assert.ok(have.has(object.sprite), `${map.map_id}: vật ${object.object_id} dùng sprite lạ "${object.sprite}"`);
      }
      for (const portal of map.portals) {
        if (portal.sprite) assert.ok(have.has(portal.sprite), `${map.map_id}: cổng ${portal.portal_id} dùng sprite lạ "${portal.sprite}"`);
      }
      for (const names of Object.values(map.scenery ?? {})) {
        for (const name of Array.isArray(names) ? names : []) {
          assert.ok(have.has(name), `${map.map_id}: cảnh vật dùng sprite lạ "${name}"`);
        }
      }
    }
  });

  test('mọi crop có đủ hạt giống bán trong shop', () => {
    const sold = new Set(content.shops.flatMap((s) => s.entries.map((e) => e.item_id)));
    const missing = content.crops
      .filter((c) => c.unlock_farm_level <= 9)
      .filter((c) => !sold.has(c.seed_item_id))
      .map((c) => c.crop_id);
    assert.deepEqual(missing, [], 'crop mở khoá sớm phải mua được hạt');
  });
});
