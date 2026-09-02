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

  const enter = async (player, mapId = 'map_city_plaza') => {
    const res = await server.post(`/v1/maps/${mapId}/enter`, { token: player.access_token, body: {} });
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

  test('nông trại riêng là instance riêng của từng người', async () => {
    const alice = await createPlayer(server);
    const bob = await createPlayer(server);
    const a = await enter(alice, 'map_player_farm');
    const b = await enter(bob, 'map_player_farm');
    assert.notEqual(a, b, 'hai người chơi không được vào chung nông trại');
  });
});
