import { test, describe } from 'node:test';
import assert from 'node:assert/strict';
import { loadContent } from '../server/src/content/index.js';
import { config } from '../server/src/config.js';
import { guideFor } from '../server/src/domain/guide.js';

const content = loadContent({ dataDir: config.dataDir, localeDir: config.localeDir });
const active = (objective) => [{
  quest_id: 'q', type: 'main', name_key: 'quest.main_001.name', state: 'active',
  objectives: [{ count: 1, current: 0, ...objective }],
}];

describe('Chỉ dẫn nhiệm vụ', () => {
  test('mục tiêu ở map khác thì chỉ tới CỬA NGÕ, không chỉ thẳng tới đích', () => {
    const guide = guideFor(content, active({ type: 'talk_npc', target: 'npc_farmer_tu' }), 'map_city_plaza');
    assert.equal(guide.target.map_id, 'map_farm_village');
    assert.equal(guide.step.same_map, false);
    // Đây là điểm dễ sai nhất: chỉ thẳng toạ độ của bác Tư thì mũi tên xuyên
    // tường về phía map khác, người chơi đi theo là đâm vào mép map.
    const portal = content.byMap.get('map_city_plaza').portals.find((p) => p.portal_id === guide.step.portal_id);
    assert.ok(portal, 'cửa ngõ phải có thật trên map đang đứng');
    assert.equal(guide.step.x, portal.x);
  });

  test('đứng đúng map thì chỉ thẳng tới mục tiêu', () => {
    const guide = guideFor(content, active({ type: 'talk_npc', target: 'npc_farmer_tu' }), 'map_farm_village');
    assert.equal(guide.step.same_map, true);
    const npc = content.byMap.get('map_farm_village').npcs.find((n) => n.npc_id === 'npc_farmer_tu');
    assert.equal(guide.step.x, npc.x);
  });

  test('đường đi vòng qua nhiều map vẫn ra cửa ngõ ĐẦU TIÊN', () => {
    // Rừng không nối thẳng tới quảng trường: phải qua làng nông trại.
    const guide = guideFor(content, active({ type: 'visit_map', target: 'map_city_plaza' }), 'map_forest');
    const portal = content.byMap.get('map_forest').portals.find((p) => p.portal_id === guide.step.portal_id);
    assert.ok(portal, 'cửa ngõ phải nằm trên map đang đứng, không phải map trung gian');
    assert.equal(portal.target_map_id, 'map_farm_village');
  });

  test('mục tiêu không gắn với chỗ nào thì không chỉ bừa', () => {
    assert.equal(guideFor(content, active({ type: 'reach_level', target: '5' }), 'map_city_plaza'), null);
  });

  test('nhiệm vụ cốt truyện được ưu tiên hơn nhiệm vụ phụ', () => {
    const quests = [
      { quest_id: 'phu', type: 'side', name_key: 'x', state: 'active', objectives: [{ type: 'talk_npc', target: 'npc_guide_mai', count: 1, current: 0 }] },
      { quest_id: 'chinh', type: 'main', name_key: 'y', state: 'active', objectives: [{ type: 'talk_npc', target: 'npc_farmer_tu', count: 1, current: 0 }] },
    ];
    assert.equal(guideFor(content, quests, 'map_city_plaza').quest_id, 'chinh');
  });

  test('nhiệm vụ đã xong hết thì không còn gì để chỉ', () => {
    const done = [{ quest_id: 'q', type: 'main', name_key: 'x', state: 'active', objectives: [{ type: 'talk_npc', target: 'npc_farmer_tu', count: 1, current: 1 }] }];
    assert.equal(guideFor(content, done, 'map_city_plaza'), null);
  });
});
