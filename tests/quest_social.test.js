import { test, describe, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { startTestServer, createPlayer, grant, makeCropReady } from './helpers.js';
import { periodKey } from '../server/src/domain/quest.js';

describe('Quest (doc 11, doc 20 — quest reward)', () => {
  let server; let player; let token;
  before(async () => {
    server = await startTestServer();
    player = await createPlayer(server);
    token = player.access_token;
  });
  after(() => server.close());

  test('chỉ quest đủ prerequisite mới hiện ra', async () => {
    const res = await server.get('/v1/quests', { token });
    const ids = res.body.quests.map((q) => q.quest_id);
    assert.ok(ids.includes('quest_main_001'));
    assert.ok(!ids.includes('quest_main_002'), 'quest_main_002 cần hoàn thành quest_main_001 trước');
  });

  test('nói chuyện NPC đẩy tiến độ và cho phép nhận thưởng', async () => {
    const talk = await server.post('/v1/npcs/npc_farmer_tu/talk', { token });
    assert.equal(talk.status, 200);
    assert.ok(talk.body.dialogue.lines.length > 0);

    const quests = (await server.get('/v1/quests', { token })).body.quests;
    const main1 = quests.find((q) => q.quest_id === 'quest_main_001');
    assert.equal(main1.state, 'completed');

    const walletBefore = (await server.get('/v1/player/wallet', { token })).body;
    const claim = await server.post('/v1/quests/quest_main_001/claim', { token });
    assert.equal(claim.status, 200);
    const walletAfter = (await server.get('/v1/player/wallet', { token })).body;
    assert.equal(walletAfter.coin, walletBefore.coin + 200);
  });

  test('không nhận thưởng hai lần cho cùng một quest', async () => {
    const again = await server.post('/v1/quests/quest_main_001/claim', { token });
    assert.equal(again.status, 409);
  });

  test('không nhận thưởng quest chưa hoàn thành', async () => {
    const res = await server.post('/v1/quests/quest_main_002/claim', { token });
    assert.equal(res.status, 409);
  });

  test('quest mở khoá sau khi quest trước được nhận thưởng', async () => {
    const quests = (await server.get('/v1/quests', { token })).body.quests;
    assert.ok(quests.some((q) => q.quest_id === 'quest_main_002'));
  });

  test('thu hoạch đẩy tiến độ quest harvest', async () => {
    const farm = (await server.get('/v1/farm', { token })).body;
    for (const plot of farm.plots.slice(0, 3)) {
      await server.post('/v1/farm/plant', { token, body: { plot_id: plot.plot_id, crop_id: 'crop_carrot' } });
      makeCropReady(server, plot.plot_id);
      await server.post('/v1/farm/harvest', { token, body: { plot_id: plot.plot_id } });
    }
    const quests = (await server.get('/v1/quests', { token })).body.quests;
    const main2 = quests.find((q) => q.quest_id === 'quest_main_002');
    assert.equal(main2.objectives[0].current, 3);
    assert.equal(main2.state, 'completed');
  });

  test('ghé map đẩy tiến độ quest daily', async () => {
    await server.post('/v1/maps/map_city_plaza/enter', { token, body: {} });
    const quests = (await server.get('/v1/quests', { token })).body.quests;
    const daily = quests.find((q) => q.quest_id === 'quest_daily_social');
    assert.equal(daily.state, 'completed');
  });

  test('period key của daily/weekly khác nhau theo chu kỳ', () => {
    const monday = Date.parse('2026-09-07T10:00:00Z');
    const tuesday = Date.parse('2026-09-08T10:00:00Z');
    assert.notEqual(periodKey('daily', monday), periodKey('daily', tuesday));
    assert.equal(periodKey('weekly', monday), periodKey('weekly', tuesday));
    assert.equal(periodKey('main', monday), '');
  });
});

describe('Social & moderation (doc 08, doc 22, doc 20 — chat moderation)', () => {
  let server; let alice; let bob;
  before(async () => {
    server = await startTestServer();
    alice = await createPlayer(server);
    bob = await createPlayer(server);
  });
  after(() => server.close());

  test('luồng kết bạn: gửi -> hiện ở incoming -> chấp nhận', async () => {
    const req = await server.post('/v1/friends/requests', { token: alice.access_token, body: { nickname: bob.nickname } });
    assert.equal(req.status, 200);
    assert.equal(req.body.state, 'pending');

    const bobView = (await server.get('/v1/friends', { token: bob.access_token })).body;
    assert.equal(bobView.incoming.length, 1);

    const accept = await server.post(`/v1/friends/${alice.character_id}/accept`, { token: bob.access_token });
    assert.equal(accept.status, 200);

    const aliceView = (await server.get('/v1/friends', { token: alice.access_token })).body;
    assert.equal(aliceView.friends.length, 1);
    assert.equal(aliceView.friends[0].nickname, bob.nickname);
  });

  test('không tự kết bạn với chính mình, không mời trùng', async () => {
    const self = await server.post('/v1/friends/requests', { token: alice.access_token, body: { nickname: alice.nickname } });
    assert.equal(self.status, 400);
    const dup = await server.post('/v1/friends/requests', { token: alice.access_token, body: { nickname: bob.nickname } });
    assert.equal(dup.status, 409);
  });

  test('chat lọc link và số dài', async () => {
    const res = await server.post('/v1/chat/messages', {
      token: alice.access_token,
      body: { channel: 'world', body: 'ghé http://vi-du.example nhé, sđt 0123456789' },
    });
    assert.equal(res.status, 201);
    assert.ok(!res.body.body.includes('http'), 'link phải bị lọc');
    assert.ok(!res.body.body.includes('0123456789'), 'số dài phải bị lọc');
  });

  test('chat rỗng hoặc quá dài bị từ chối', async () => {
    const empty = await server.post('/v1/chat/messages', { token: alice.access_token, body: { channel: 'world', body: '   ' } });
    assert.equal(empty.status, 400);
    const long = await server.post('/v1/chat/messages', { token: alice.access_token, body: { channel: 'world', body: 'x'.repeat(500) } });
    assert.equal(long.status, 400);
  });

  test('block chặn được tin nhắn riêng', async () => {
    const carol = await createPlayer(server);
    await server.post(`/v1/friends/${carol.character_id}/block`, { token: alice.access_token });
    const res = await server.post('/v1/chat/messages', {
      token: carol.access_token,
      body: { channel: 'private', to: alice.nickname, body: 'xin chào' },
    });
    assert.equal(res.status, 403);
  });

  test('lịch sử chat riêng chỉ trả về hội thoại của hai người', async () => {
    await server.post('/v1/chat/messages', { token: alice.access_token, body: { channel: 'private', to: bob.nickname, body: 'chào bob' } });
    await server.post('/v1/chat/messages', { token: bob.access_token, body: { channel: 'private', to: alice.nickname, body: 'chào alice' } });
    const res = await server.get(`/v1/chat/messages?channel=private&scope_id=${bob.character_id}`, { token: alice.access_token });
    assert.equal(res.body.messages.length, 2);
    assert.equal(res.body.messages[0].body, 'chào bob');
  });

  test('report được ghi nhận', async () => {
    const res = await server.post('/v1/moderation/reports', {
      token: alice.access_token,
      body: { nickname: bob.nickname, reason: 'spam', detail: 'gửi link liên tục' },
    });
    assert.equal(res.status, 201);
    const rows = server.app.ctx.db.prepare('SELECT * FROM moderation_reports WHERE reporter_id = ?').all(alice.character_id);
    assert.equal(rows.length, 1);
    assert.equal(rows[0].reason, 'spam');
  });

  test('reason không hợp lệ bị từ chối', async () => {
    const res = await server.post('/v1/moderation/reports', { token: alice.access_token, body: { nickname: bob.nickname, reason: 'linh-tinh' } });
    assert.equal(res.status, 400);
  });
});
