import { test, describe, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { startTestServer, createPlayer } from './helpers.js';
import { listQuests, periodKey } from '../server/src/domain/quest.js';

let server; let content; let db;
const DAY = 86_400_000;
const ids = (quests) => quests.map((q) => q.quest_id);

describe('Chuỗi tân thủ 7 ngày và sự kiện ngày', () => {
  before(async () => {
    server = await startTestServer();
    content = server.app.ctx.content;
    db = server.app.ctx.db;
  });
  after(() => server.close());

  test('ngày đầu chỉ mở nhiệm vụ tân thủ ngày 1', async () => {
    const player = await createPlayer(server);
    const open = ids(listQuests(db, content, player.character_id));
    assert.ok(open.includes('quest_newbie_01'));
    assert.ok(!open.includes('quest_newbie_02'), 'ngày 2 chưa được mở sớm');
    assert.ok(!open.includes('quest_newbie_07'));
  });

  test('sang ngày sau thì mở thêm, mà ngày cũ KHÔNG mất', async () => {
    const player = await createPlayer(server);
    const open = ids(listQuests(db, content, player.character_id, Date.now() + 2 * DAY));
    assert.ok(open.includes('quest_newbie_03'), 'ngày 3 phải mở');
    // Đây là điểm thiết kế, không phải chi tiết cài đặt: chuỗi tân thủ dẫn người
    // mới đi tiếp chứ không phải cái bẫy phạt người bận. Bỏ lỡ ngày 1 thì hôm
    // sau vẫn làm được.
    assert.ok(open.includes('quest_newbie_01'), 'ngày cũ vẫn phải làm được');
  });

  test('lập nhân vật lúc 23h thì một tiếng sau đã là ngày 2', async () => {
    const player = await createPlayer(server);
    const born = db.prepare('SELECT created_at FROM characters WHERE id = ?').get(player.character_id).created_at;
    // Đếm theo ngày lịch, không theo số giờ trôi qua — đúng như người chơi hiểu
    // chữ "hôm sau".
    const nextMidnight = (Math.floor(born / DAY) + 1) * DAY;
    const open = ids(listQuests(db, content, player.character_id, nextMidnight + 3600_000));
    assert.ok(open.includes('quest_newbie_02'));
  });

  test('sự kiện ngày: mỗi hôm mở ĐÚNG MỘT việc trong bể', async () => {
    const player = await createPlayer(server);
    const pool = content.quests.filter((q) => q.pool === 'daily_event').map((q) => q.quest_id);
    assert.ok(pool.length > 1, 'bể phải có nhiều hơn một để luân phiên mới có nghĩa');
    const open = ids(listQuests(db, content, player.character_id)).filter((id) => pool.includes(id));
    assert.equal(open.length, 1);
  });

  test('cùng một ngày thì mọi người chơi thấy cùng một việc', async () => {
    const a = await createPlayer(server);
    const b = await createPlayer(server);
    const pool = content.quests.filter((q) => q.pool === 'daily_event').map((q) => q.quest_id);
    const pick = (p, at) => ids(listQuests(db, content, p.character_id, at)).filter((id) => pool.includes(id))[0];
    const at = Date.now();
    assert.equal(pick(a, at), pick(b, at));
  });

  test('qua ngày khác thì việc đổi — có ít nhất hai ngày ra hai việc khác nhau', async () => {
    const player = await createPlayer(server);
    const pool = content.quests.filter((q) => q.pool === 'daily_event').map((q) => q.quest_id);
    const pick = (at) => ids(listQuests(db, content, player.character_id, at)).filter((id) => pool.includes(id))[0];
    const seen = new Set();
    for (let d = 0; d < 14; d++) seen.add(pick(Date.now() + d * DAY));
    assert.ok(seen.size > 1, `14 ngày liền mà vẫn một việc thì luân phiên hỏng: ${[...seen]}`);
  });

  test('khoá chu kỳ của nhiệm vụ ngày đổi theo ngày', () => {
    assert.notEqual(periodKey('daily', Date.now()), periodKey('daily', Date.now() + DAY));
  });
});
