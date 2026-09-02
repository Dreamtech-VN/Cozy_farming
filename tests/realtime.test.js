import { test, describe, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { startTestServer, createPlayer } from './helpers.js';

/** Client websocket nhỏ: chờ đúng loại message cần kiểm tra. */
function connect(server, token, instanceId) {
  const url = `ws://127.0.0.1:${server.port}/ws?instance=${encodeURIComponent(instanceId)}&token=${encodeURIComponent(token)}`;
  const socket = new WebSocket(url);
  const inbox = [];
  const waiters = [];

  socket.addEventListener('message', (event) => {
    const message = JSON.parse(event.data);
    inbox.push(message);
    for (let i = waiters.length - 1; i >= 0; i--) {
      if (waiters[i].match(message)) waiters.splice(i, 1)[0].resolve(message);
    }
  });

  return {
    socket,
    open: () => new Promise((resolve, reject) => {
      socket.addEventListener('open', resolve, { once: true });
      socket.addEventListener('error', reject, { once: true });
    }),
    send: (value) => socket.send(JSON.stringify(value)),
    /** Chờ message thoả điều kiện, kể cả message đã tới trước đó. */
    waitFor: (match, timeoutMs = 3000) => {
      const found = inbox.find(match);
      if (found) return Promise.resolve(found);
      return new Promise((resolve, reject) => {
        const timer = setTimeout(() => reject(new Error('hết thời gian chờ message')), timeoutMs);
        waiters.push({ match, resolve: (m) => { clearTimeout(timer); resolve(m); } });
      });
    },
    close: () => socket.close(),
  };
}

describe('Realtime world (doc 16)', () => {
  let server;
  before(async () => { server = await startTestServer(); });
  after(() => server.close());

  const enter = async (player, mapId = 'map_city_plaza', channel = 1) => {
    const res = await server.post(`/v1/maps/${mapId}/enter`, { token: player.access_token, body: { channel } });
    assert.equal(res.status, 200);
    return res.body.instance_id;
  };

  test('kết nối không token bị từ chối', async () => {
    const player = await createPlayer(server);
    const instanceId = await enter(player);
    const client = connect(server, 'token-bay-bien', instanceId);
    await client.open();
    const error = await client.waitFor((m) => m.type === 'error');
    assert.equal(error.error.code, 'unauthorized');
    client.close();
  });

  test('hai người chơi cùng map nhìn thấy nhau', async () => {
    const alice = await createPlayer(server);
    const bob = await createPlayer(server);
    const instanceId = await enter(alice);
    await enter(bob);

    const clientA = connect(server, alice.access_token, instanceId);
    await clientA.open();
    await clientA.waitFor((m) => m.type === 'joined');

    const clientB = connect(server, bob.access_token, instanceId);
    await clientB.open();
    await clientB.waitFor((m) => m.type === 'joined');

    const join = await clientA.waitFor((m) => m.type === 'player_join' && m.player.character_id === bob.character_id);
    assert.equal(join.player.nickname, bob.nickname);

    clientA.close();
    clientB.close();
  });

  test('di chuyển hợp lệ được broadcast qua snapshot', async () => {
    const alice = await createPlayer(server);
    const bob = await createPlayer(server);
    const instanceId = await enter(alice);
    await enter(bob);

    const clientA = connect(server, alice.access_token, instanceId);
    await clientA.open();
    const joinedA = await clientA.waitFor((m) => m.type === 'joined');

    const clientB = connect(server, bob.access_token, instanceId);
    await clientB.open();
    await clientB.waitFor((m) => m.type === 'joined');

    clientA.send({ type: 'move', x: joinedA.you.x + 30, y: joinedA.you.y, facing: 1, state: 'run' });
    const snapshot = await clientB.waitFor((m) =>
      m.type === 'snapshot' && m.players.some((p) => p.character_id === alice.character_id && p.x === joinedA.you.x + 30));
    assert.ok(snapshot);

    clientA.close();
    clientB.close();
  });

  test('dịch chuyển tức thời bị server sửa lại vị trí', async () => {
    const player = await createPlayer(server);
    const instanceId = await enter(player);
    const client = connect(server, player.access_token, instanceId);
    await client.open();
    const joined = await client.waitFor((m) => m.type === 'joined');

    client.send({ type: 'move', x: joined.you.x + 2000, y: joined.you.y, facing: 1, state: 'run' });
    const correction = await client.waitFor((m) => m.type === 'position_correction');
    assert.equal(correction.x, joined.you.x);
    client.close();
  });

  test('bay lơ lửng dưới mặt đất bị từ chối', async () => {
    const player = await createPlayer(server);
    const instanceId = await enter(player);
    const client = connect(server, player.access_token, instanceId);
    await client.open();
    const joined = await client.waitFor((m) => m.type === 'joined');

    client.send({ type: 'move', x: joined.you.x + 10, y: joined.you.y + 90, facing: 1, state: 'walk' });
    const correction = await client.waitFor((m) => m.type === 'position_correction');
    assert.equal(correction.y, joined.you.y);
    client.close();
  });

  test('chat map tới được người cùng instance', async () => {
    const alice = await createPlayer(server);
    const bob = await createPlayer(server);
    const instanceId = await enter(alice);
    await enter(bob);

    const clientA = connect(server, alice.access_token, instanceId);
    await clientA.open();
    await clientA.waitFor((m) => m.type === 'joined');
    const clientB = connect(server, bob.access_token, instanceId);
    await clientB.open();
    await clientB.waitFor((m) => m.type === 'joined');

    clientA.send({ type: 'chat', body: 'xin chào cả nhà' });
    const received = await clientB.waitFor((m) => m.type === 'chat' && m.message.body === 'xin chào cả nhà');
    assert.equal(received.message.sender_nickname, alice.nickname);

    clientA.close();
    clientB.close();
  });

  test('rời map thì người còn lại nhận player_leave', async () => {
    const alice = await createPlayer(server);
    const bob = await createPlayer(server);
    const instanceId = await enter(alice);
    await enter(bob);

    const clientA = connect(server, alice.access_token, instanceId);
    await clientA.open();
    await clientA.waitFor((m) => m.type === 'joined');
    const clientB = connect(server, bob.access_token, instanceId);
    await clientB.open();
    await clientB.waitFor((m) => m.type === 'joined');
    await clientA.waitFor((m) => m.type === 'player_join');

    clientB.close();
    const left = await clientA.waitFor((m) => m.type === 'player_leave' && m.character_id === bob.character_id);
    assert.ok(left);
    clientA.close();
  });

  test('hai khu khác nhau của cùng một map là hai instance tách biệt', async () => {
    const alice = await createPlayer(server);
    const bob = await createPlayer(server);
    const ch1 = await enter(alice, 'map_city_plaza', 1);
    const ch7 = await enter(bob, 'map_city_plaza', 7);
    assert.notEqual(ch1, ch7);

    const clientA = connect(server, alice.access_token, ch1);
    await clientA.open();
    const joined = await clientA.waitFor((m) => m.type === 'joined');
    assert.deepEqual(joined.players, [], 'khu 1 phải trống, bob đang ở khu 7');

    const clientB = connect(server, bob.access_token, ch7);
    await clientB.open();
    await clientB.waitFor((m) => m.type === 'joined');

    // Alice không được nhận player_join của Bob vì khác khu.
    await new Promise((resolve) => setTimeout(resolve, 300));
    await assert.rejects(
      clientA.waitFor((m) => m.type === 'player_join', 400),
      /hết thời gian chờ/,
    );
    clientA.close();
    clientB.close();
  });

  test('khu ngoài khoảng 1–20 bị từ chối', async () => {
    const player = await createPlayer(server);
    for (const channel of [0, 21, -3, 1.5, 'abc']) {
      const res = await server.post('/v1/maps/map_city_plaza/enter', { token: player.access_token, body: { channel } });
      assert.equal(res.status, 400, `khu ${channel} phải bị từ chối`);
      assert.equal(res.body.error.details.channel_count, 20);
    }
  });

  test('danh sách khu trả về sĩ số từng khu', async () => {
    const alice = await createPlayer(server);
    const bob = await createPlayer(server);
    const instanceId = await enter(alice, 'map_city_plaza', 5);
    await enter(bob, 'map_city_plaza', 5);

    const clientA = connect(server, alice.access_token, instanceId);
    await clientA.open();
    await clientA.waitFor((m) => m.type === 'joined');
    const clientB = connect(server, bob.access_token, instanceId);
    await clientB.open();
    await clientB.waitFor((m) => m.type === 'joined');

    const res = await server.get('/v1/maps/map_city_plaza/channels', { token: alice.access_token });
    assert.equal(res.status, 200);
    assert.equal(res.body.channels.length, 20);
    assert.equal(res.body.channels.find((c) => c.channel === 5).players, 2);
    assert.equal(res.body.channels.find((c) => c.channel === 5).capacity, 40);

    clientA.close();
    clientB.close();
  });

  test('map private bỏ qua khu — mỗi người một instance riêng', async () => {
    const alice = await createPlayer(server);
    const res = await server.post('/v1/maps/map_player_farm/enter', { token: alice.access_token, body: { channel: 9 } });
    assert.equal(res.status, 200);
    assert.equal(res.body.channel, null);
    assert.ok(res.body.instance_id.includes(alice.character_id));

    const list = await server.get('/v1/maps/map_player_farm/channels', { token: alice.access_token });
    assert.deepEqual(list.body.channels, []);
  });

  test('bản đồ thành phố trả về node và cạnh khớp với portal trong data', async () => {
    const player = await createPlayer(server);
    const res = await server.get('/v1/world/atlas', { token: player.access_token });
    assert.equal(res.status, 200);

    const { content } = server.app.ctx;
    assert.equal(res.body.maps.length, content.maps.length);

    const forest = res.body.maps.find((m) => m.map_id === 'map_forest');
    assert.equal(forest.locked, true, 'rừng cần cấp 3 nên phải bị khoá với người mới');

    // Mỗi cạnh phải trỏ tới một map có thật.
    const ids = new Set(res.body.maps.map((m) => m.map_id));
    for (const map of res.body.maps) {
      for (const link of map.links) assert.ok(ids.has(link.to), `${map.map_id} nối tới map lạ ${link.to}`);
    }

    const plaza = res.body.maps.find((m) => m.map_id === 'map_city_plaza');
    assert.deepEqual(
      plaza.links.map((l) => l.to).sort(),
      ['map_city_shopping', 'map_farm_village'],
    );
  });

  test('nông trại riêng là instance riêng của từng người', async () => {
    const alice = await createPlayer(server);
    const bob = await createPlayer(server);
    const a = await enter(alice, 'map_player_farm');
    const b = await enter(bob, 'map_player_farm');
    assert.notEqual(a, b, 'hai người chơi không được vào chung nông trại');
  });
});
