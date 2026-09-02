import { test, describe } from 'node:test';
import assert from 'node:assert/strict';
import { loadContent } from '../server/src/content/index.js';
import { validateContent } from '../server/src/content/validate.js';
import { config } from '../server/src/config.js';
import { minuteOfDay, phaseAt, weatherAt, worldState } from '../server/src/domain/world_clock.js';
import { startTestServer, createPlayer } from './helpers.js';

const content = loadContent({ dataDir: config.dataDir, localeDir: config.localeDir });
const cycle = content.world.day_cycle;

describe('Đồng hồ thế giới & thời tiết (doc 03)', () => {
  test('một chu kỳ thật đi hết 1440 phút game rồi lặp lại', () => {
    const cycleMs = cycle.real_minutes_per_day * 60_000;
    assert.equal(minuteOfDay(cycle, 0), 0);
    assert.equal(minuteOfDay(cycle, cycleMs / 2), 720);
    assert.equal(minuteOfDay(cycle, cycleMs - 1), 1439);
    assert.equal(minuteOfDay(cycle, cycleMs), 0, 'hết một ngày thì quay lại 0');
  });

  test('mọi phút trong ngày đều rơi vào đúng một giai đoạn', () => {
    for (let minute = 0; minute < 1440; minute++) {
      const phase = phaseAt(cycle, minute);
      assert.ok(phase, `phút ${minute} không có giai đoạn`);
      const matches = cycle.phases.filter((p) => {
        const wraps = p.to <= p.from;
        return wraps ? (minute >= p.from || minute < p.to) : (minute >= p.from && minute < p.to);
      });
      assert.equal(matches.length, 1, `phút ${minute} khớp ${matches.length} giai đoạn`);
    }
  });

  test('giai đoạn vắt qua nửa đêm được nhận đúng', () => {
    assert.equal(phaseAt(cycle, 1300).id, 'night');
    assert.equal(phaseAt(cycle, 30).id, 'night');
    assert.equal(phaseAt(cycle, 360).id, 'dawn');
    assert.equal(phaseAt(cycle, 700).id, 'day');
    assert.equal(phaseAt(cycle, 1100).id, 'dusk');
  });

  test('thời tiết xác định: cùng map và cùng lát thời gian luôn ra cùng kết quả', () => {
    const now = 1_800_000_000_000;
    const a = weatherAt(content.world.weather, 'map_city_plaza', now);
    const b = weatherAt(content.world.weather, 'map_city_plaza', now + 1000);
    assert.equal(a.id, b.id, 'trong cùng một lát thì thời tiết không đổi');
  });

  test('hai map khác nhau có thời tiết riêng', () => {
    const now = 1_800_000_000_000;
    const ids = content.maps.map((m) => weatherAt(content.world.weather, m.map_id, now).id);
    assert.ok(new Set(ids).size > 1, 'các map không được luôn giống nhau');
  });

  test('thời tiết đổi khi sang lát mới', () => {
    const slotMs = content.world.weather.slot_minutes * 60_000;
    let changed = 0;
    for (let slot = 0; slot < 400; slot++) {
      const now = slot * slotMs;
      const next = (slot + 1) * slotMs;
      if (weatherAt(content.world.weather, 'map_forest', now).id !== weatherAt(content.world.weather, 'map_forest', next).id) changed++;
    }
    assert.ok(changed > 50, `thời tiết phải đổi thường xuyên, chỉ đổi ${changed}/400 lần`);
  });

  test('phân bố thời tiết bám theo trọng số khai báo', () => {
    const slotMs = content.world.weather.slot_minutes * 60_000;
    const counts = {};
    const samples = 20000;
    for (let slot = 0; slot < samples; slot++) {
      const id = weatherAt(content.world.weather, 'map_city_plaza', slot * slotMs).id;
      counts[id] = (counts[id] ?? 0) + 1;
    }
    const total = content.world.weather.types.reduce((sum, t) => sum + t.weight, 0);
    for (const type of content.world.weather.types) {
      const expected = type.weight / total;
      const actual = (counts[type.id] ?? 0) / samples;
      assert.ok(Math.abs(actual - expected) < 0.03,
        `${type.id}: mong ${expected.toFixed(3)}, thực tế ${actual.toFixed(3)}`);
    }
  });

  test('worldState trả về đủ thông tin cho HUD', () => {
    const state = worldState(content, 'map_city_plaza', 0);
    assert.match(state.clock, /^\d{2}:\d{2}$/);
    assert.equal(state.minute_of_day, 0);
    assert.equal(state.is_night, true, 'nửa đêm phải là ban đêm');
    assert.ok(state.phase_minutes_left > 0);
    assert.ok(state.weather.seconds_left > 0);
  });

  test('validator bắt được giai đoạn không phủ kín ngày', () => {
    const broken = {
      ...content,
      world: { ...content.world, day_cycle: { ...cycle, phases: cycle.phases.slice(0, 2) } },
    };
    assert.ok(validateContent(broken).some((i) => i.message.includes('phủ')));
  });

  test('validator bắt được trọng số thời tiết không hợp lệ', () => {
    const broken = {
      ...content,
      world: { ...content.world, weather: { ...content.world.weather, types: [{ id: 'x', name_key: 'weather.clear', weight: 0 }] } },
    };
    assert.ok(validateContent(broken).some((i) => i.rule === 'invalid_range' && i.message.includes('weight')));
  });
});

describe('API đồng hồ thế giới', () => {
  test('/v1/world/clock trả về giờ, giai đoạn và thời tiết của map', async () => {
    const server = await startTestServer();
    try {
      const player = await createPlayer(server);
      const res = await server.get('/v1/world/clock?map_id=map_forest', { token: player.access_token });
      assert.equal(res.status, 200);
      assert.match(res.body.clock, /^\d{2}:\d{2}$/);
      assert.ok(['dawn', 'day', 'dusk', 'night'].includes(res.body.phase));
      assert.ok(res.body.weather.id);

      const bad = await server.get('/v1/world/clock?map_id=map_khong_co', { token: player.access_token });
      assert.equal(bad.status, 404);
    } finally {
      await server.close();
    }
  });
});
