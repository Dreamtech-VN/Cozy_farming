/**
 * Bootstrap client + vòng lặp game (doc 12 — world là trung tâm, doc 16 — client
 * dự đoán chuyển động và đồng bộ với snapshot của server).
 */
import { Api } from './net/api.js';
import { Realtime } from './net/realtime.js';
import { i18n, t, formatNumber } from './core/i18n.js';
import { Input } from './core/input.js';
import { WorldRenderer } from './render/world.js';
import { drawAvatarPortrait } from './render/avatar.js';
import { levelProgress } from './core/progression.js';
import { Match3Scene } from './scenes/match3.js';
import { showLogin } from './scenes/login.js';
import { toast, closePanel } from './ui/ui.js';
import { openQuests, openInventory, openFarm, openSocial, openChat, openProfile, openShop, harvest, openAreaMap, energyLine } from './ui/panels.js';
import { drawAreaMap } from './ui/minimap.js';

const GRAVITY = 1800;
const RUN_SPEED = 260;
const JUMP_SPEED = 620;
const INTERACT_RANGE = 90;

class Game {
  constructor() {
    this.api = new Api('');
    this.realtime = new Realtime(this.api);
    this.input = new Input();
    this.canvas = document.getElementById('stage');
    this.players = new Map();
    this.self = { x: 0, y: 0, vx: 0, vy: 0, facing: 1, state: 'idle', phase: 0, equipment: {}, onGround: true };
    this.currentMap = null;
    this.farm = null;
    this.paused = false;
    this.time = 0;
    this.hintTarget = null;
    this.emotes = new Map();
    this.channel = 1;
    this.minimapAt = 0;
  }

  async boot() {
    const raw = await this.api.get('/v1/content');
    this.content = {
      ...raw,
      avatarItems: raw.avatar_items,
      tileTypes: raw.tile_types,
      itemsById: new Map(raw.items.map((i) => [i.item_id, i])),
      cropsById: new Map(raw.crops.map((c) => [c.crop_id, c])),
      avatarItemsById: new Map(raw.avatar_items.map((i) => [i.item_id, i])),
      levelsById: new Map(raw.levels.map((l) => [l.level_id, l])),
      mapsById: new Map(),
      shopsById: new Map(),
    };
    await i18n.load(this.api, 'vi');

    this.renderer = new WorldRenderer(this.canvas, this.content);
    this.match3 = new Match3Scene(this);
    this.#bindUi();
    this.#bindRealtime();

    if (this.api.token) {
      try {
        await this.enterGame();
        return;
      } catch { this.api.setSession(null); }
    }
    showLogin(this);
    this.#loop();
  }

  #bindUi() {
    for (const button of document.querySelectorAll('#toolbar button')) {
      button.addEventListener('click', () => {
        const panel = button.dataset.panel;
        const alreadyOpen = button.getAttribute('aria-pressed') === 'true';
        closePanel();
        if (alreadyOpen) return;
        ({
          quests: () => openQuests(this),
          inventory: () => openInventory(this),
          farm: () => openFarm(this),
          social: () => openSocial(this),
          chat: () => openChat(this),
          profile: () => openProfile(this),
        })[panel]?.();
      });
    }

    // Góc thông tin nhân vật mở thẳng panel Nhân vật.
    document.getElementById('player-card').addEventListener('click', () => {
      closePanel();
      openProfile(this);
    });

    // Minimap mở popup bản đồ khu vực.
    document.getElementById('minimap').addEventListener('click', () => {
      closePanel();
      openAreaMap(this);
    });

    // Chuyển khu: vào lại đúng map hiện tại nhưng ở instance khác.
    document.getElementById('channel-select').addEventListener('change', async (event) => {
      const channel = Number(event.target.value);
      if (!this.currentMap || channel === this.channel) return;
      try {
        await this.enterMap(this.currentMap.map_id, 'spawn_default', channel);
        toast(`Đã chuyển sang khu ${channel}`, 'good');
      } catch (err) {
        toast(err.message, 'bad');
        event.target.value = String(this.channel);
      }
    });

    // Chạm vào ô đất trong nông trại để thu hoạch nhanh (doc 12 — một hành động chính).
    this.canvas.addEventListener('pointerdown', (event) => {
      if (!this.farm || !this.currentMap?.farm_layout) return;
      const point = this.renderer.toWorld(this.currentMap, event.clientX, event.clientY);
      const plot = this.farm.plots.find((p) => p.screen && Math.abs(p.screen.x - point.x) < 46 && Math.abs(p.screen.y - point.y) < 70);
      if (!plot) return;
      if (plot.state === 'mature') harvest(this, plot.plot_id, () => this.refreshFarm());
      else openFarm(this);
    });
  }

  #bindRealtime() {
    const status = document.getElementById('connection');
    this.realtime.addEventListener('status', (event) => {
      status.classList.toggle('hidden', event.detail.connected);
    });

    this.realtime.addEventListener('joined', (event) => {
      const { you, players } = event.detail;
      this.self.x = you.x;
      this.self.y = you.y;
      this.self.equipment = you.equipment;
      this.self.nickname = you.nickname;
      this.players.clear();
      for (const player of players) this.players.set(player.character_id, { ...player, phase: 0 });
    });

    this.realtime.addEventListener('player_join', (event) => {
      this.players.set(event.detail.player.character_id, { ...event.detail.player, phase: 0 });
    });
    this.realtime.addEventListener('player_leave', (event) => this.players.delete(event.detail.character_id));

    this.realtime.addEventListener('snapshot', (event) => {
      for (const remote of event.detail.players) {
        if (remote.character_id === this.characterId) continue;
        const player = this.players.get(remote.character_id);
        if (!player) continue;
        // Nội suy mềm để nhân vật khác không giật (doc 16).
        player.targetX = remote.x;
        player.targetY = remote.y;
        player.facing = remote.facing;
        player.state = remote.state;
      }
    });

    this.realtime.addEventListener('position_correction', (event) => {
      this.self.x = event.detail.x;
      this.self.y = event.detail.y;
      this.self.vy = 0;
    });

    this.realtime.addEventListener('chat', (event) => {
      const message = event.detail.message;
      this.chatSink?.(message);
      if (message.sender_id !== this.characterId) toast(`${message.sender_nickname}: ${message.body}`);
    });

    this.realtime.addEventListener('emote', (event) => {
      const emote = this.content.emotes.find((e) => e.emote_id === event.detail.emote_id);
      this.emotes.set(event.detail.character_id, { glyph: emote?.glyph ?? '!', until: performance.now() + 2500 });
    });
  }

  async enterGame() {
    const profile = await this.api.get('/v1/player/profile');
    this.characterId = profile.character_id;
    this.self.equipment = profile.equipment;
    this.self.nickname = profile.nickname;
    this.profile = profile;

    document.getElementById('hud').classList.remove('hidden');
    document.getElementById('toolbar').classList.remove('hidden');

    await this.enterMap(profile.position.map_id, 'spawn_default');
    this.#updateHud();
    if (!this.running) { this.running = true; this.#loop(); }
  }

  async enterMap(mapId, spawnId = 'spawn_default', channel = 1) {
    const [map, entered] = await Promise.all([
      this.api.get(`/v1/maps/${mapId}`),
      this.api.post(`/v1/maps/${mapId}/enter`, { spawn_id: spawnId, channel }),
    ]);
    this.currentMap = map;
    this.renderer.setMap(map);
    this.content.mapsById.set(map.map_id, map);
    this.players.clear();

    this.self.x = entered.spawn.x;
    this.self.y = entered.spawn.y;
    this.self.vx = 0;
    this.self.vy = 0;

    this.realtime.close();
    this.realtime.connect(entered.instance_id);

    this.farm = map.farm_layout ? await this.api.get('/v1/farm') : null;
    this.channel = entered.channel ?? 1;
    document.getElementById('hud-map').textContent = t(map.name_key);
    await this.#refreshChannels();
    this.#drawMinimap();
  }

  async refreshFarm() {
    if (this.currentMap?.farm_layout) this.farm = await this.api.get('/v1/farm');
  }

  async refreshPlayer() {
    this.profile = await this.api.get('/v1/player/profile');
    this.self.equipment = this.profile.equipment;
    this.#updateHud();
  }

  #updateHud() {
    if (!this.profile) return;
    const profile = this.profile;

    document.getElementById('hud-name').textContent = profile.nickname;
    document.getElementById('hud-level').textContent = String(profile.level);

    const progress = levelProgress(this.content.economy.level_curve, profile.level, profile.xp);
    document.getElementById('hud-xp-fill').style.width = `${progress.ratio * 100}%`;
    document.getElementById('hud-xp').textContent = progress.maxed
      ? 'Cấp tối đa'
      : `${formatNumber(progress.current)} / ${formatNumber(progress.needed)} XP`;

    drawAvatarPortrait(document.getElementById('avatar-portrait'), this.content, {
      equipment: profile.equipment,
      body_type: profile.body_type,
    });

    document.getElementById('hud-coin').lastElementChild.textContent = formatNumber(profile.wallet.coin ?? 0);
    document.getElementById('hud-gem').lastElementChild.textContent = formatNumber(profile.wallet.gem ?? 0);
  }

  /** Dropdown chuyển khu: 1..N lấy từ content, kèm sĩ số hiện tại của từng khu. */
  async #refreshChannels() {
    const select = document.getElementById('channel-select');
    const map = this.currentMap;
    if (!map) return;

    // Map private (nông trại, nhà) không chia khu.
    if (map.instance_policy === 'owner') {
      select.replaceChildren(new Option('riêng', '0'));
      select.disabled = true;
      return;
    }

    select.disabled = false;
    let channels = null;
    try {
      channels = (await this.api.get(`/v1/maps/${map.map_id}/channels`)).channels;
    } catch { /* mất mạng thì vẫn dựng danh sách khu, chỉ thiếu sĩ số */ }

    const count = this.content.channel_count ?? 20;
    select.replaceChildren(...Array.from({ length: count }, (_, index) => {
      const channel = index + 1;
      const info = channels?.find((c) => c.channel === channel);
      const label = info ? `${channel}  ·  ${info.players}/${info.capacity}` : String(channel);
      return new Option(label, String(channel));
    }));
    select.value = String(this.channel);
  }

  #drawMinimap() {
    if (!this.currentMap) return;
    drawAreaMap(document.getElementById('minimap-canvas'), this.currentMap, {
      self: this.self,
      players: [...this.players.values()],
    });
  }

  pauseWorld() { this.paused = true; this.input.enabled = false; }

  resumeWorld() {
    this.paused = false;
    this.input.enabled = true;
    this.refreshPlayer();
  }

  /** Vật lý cục bộ; server vẫn là trọng tài (doc 16 — client prediction). */
  #step(dt) {
    if (this.paused || !this.currentMap) return;
    const map = this.currentMap;
    const self = this.self;

    const direction = (this.input.keys.right ? 1 : 0) - (this.input.keys.left ? 1 : 0);
    self.vx = direction * RUN_SPEED;
    if (direction !== 0) self.facing = direction;

    if (this.input.keys.jump && self.onGround) {
      self.vy = -JUMP_SPEED;
      self.onGround = false;
    }

    self.vy += GRAVITY * dt;
    self.x = Math.max(20, Math.min(map.width - 20, self.x + self.vx * dt));
    self.y += self.vy * dt;

    // Va chạm: mặt đất và các platform (doc 03).
    const surfaces = [{ x: -1e6, y: map.ground_y, w: 2e6 }, ...(map.platforms ?? []).map((p) => ({ x: p.x, y: p.y, w: p.w }))];
    self.onGround = false;
    for (const surface of surfaces) {
      const within = self.x >= surface.x - 6 && self.x <= surface.x + surface.w + 6;
      if (within && self.vy >= 0 && self.y >= surface.y && self.y - self.vy * dt <= surface.y + 12) {
        self.y = surface.y;
        self.vy = 0;
        self.onGround = true;
        break;
      }
    }

    self.state = !self.onGround ? 'jump' : direction !== 0 ? 'run' : 'idle';
    self.phase = (self.phase + dt * (self.state === 'run' ? 3.2 : 1)) % 1;

    if (self.state !== this.lastSentState || Math.abs(self.x - (this.lastSentX ?? 0)) > 1) {
      this.realtime.sendMove({ x: Math.round(self.x), y: Math.round(self.y), facing: self.facing, state: self.state });
      this.lastSentState = self.state;
      this.lastSentX = self.x;
    }

    // Nội suy vị trí người chơi khác.
    for (const player of this.players.values()) {
      if (player.targetX === undefined) continue;
      player.x += (player.targetX - player.x) * Math.min(1, dt * 12);
      player.y += (player.targetY - player.y) * Math.min(1, dt * 12);
      player.phase = (player.phase + dt * (player.state === 'run' ? 3.2 : 1)) % 1;
    }

    this.#updateInteraction();
  }

  /** Tìm mục tiêu tương tác gần nhất và xử lý phím hành động. */
  #updateInteraction() {
    const map = this.currentMap;
    const self = this.self;
    const candidates = [
      ...map.npcs.map((npc) => ({ id: npc.npc_id, x: npc.x, kind: 'npc', data: npc, label: `Nói chuyện với ${t(npc.name_key)}` })),
      ...map.portals.map((portal) => ({ id: portal.portal_id, x: portal.x, kind: 'portal', data: portal, label: t(portal.label_key) })),
      ...(map.objects ?? []).filter((o) => o.action).map((object) => ({
        id: object.object_id, x: object.x, kind: 'object', data: object, label: OBJECT_LABEL[object.action] ?? 'Tương tác',
      })),
    ];

    let nearest = null;
    for (const candidate of candidates) {
      const distance = Math.abs(candidate.x - self.x);
      if (distance < INTERACT_RANGE && (!nearest || distance < nearest.distance)) nearest = { ...candidate, distance };
    }
    this.hintTarget = nearest;

    const hint = document.getElementById('interact-hint');
    if (nearest) {
      hint.textContent = nearest.label;
      hint.classList.remove('hidden');
    } else {
      hint.classList.add('hidden');
    }

    if (this.input.consumeAction() && nearest) this.#interact(nearest);
  }

  async #interact(target) {
    try {
      if (target.kind === 'portal') {
        await this.enterMap(target.data.target_map_id, target.data.target_spawn);
        return;
      }
      if (target.kind === 'npc') {
        const result = await this.api.post(`/v1/npcs/${target.data.npc_id}/talk`, {});
        if (result.dialogue) {
          for (const line of result.dialogue.lines) toast(`${t(target.data.name_key)}: ${t(line)}`);
        }
        if (target.data.action === 'open_match3') { this.#openMatchPicker(); return; }
        if (result.shop_id) {
          this.content.shopsById.set(result.shop_id, { shop_id: result.shop_id });
          openShop(this, result.shop_id);
        }
        return;
      }
      const action = target.data.action;
      if (action === 'open_match3') this.#openMatchPicker();
      else if (action === 'open_inventory') openInventory(this);
      else if (action === 'open_quest') openQuests(this);
    } catch (err) {
      toast(err.message, 'bad');
    }
  }

  #openMatchPicker() {
    import('./ui/ui.js').then(({ showPanel, el }) => {
      showPanel('Chọn màn Match-3', (body) => {
        body.append(energyLine(this));
        for (const level of this.content.levels) {
          const locked = (this.profile?.level ?? 1) < level.unlock_level;
          body.append(el('div', { class: 'row' }, [
            el('div', { class: 'grow' }, [
              el('div', { class: 'title', text: t(level.name_key) }),
              el('div', { class: 'sub', text: `${t(level.enemy.name_key)} · ${level.energy_cost} năng lượng · ${level.moves} lượt` }),
            ]),
            locked
              ? el('span', { class: 'tag locked', text: `Cấp ${level.unlock_level}` })
              : el('button', {
                  class: 'primary', type: 'button', text: 'Vào trận',
                  onClick: () => { closePanel(); this.pauseWorld(); this.match3.start(level.level_id); },
                }),
          ]));
        }
      });
    });
  }

  #loop() {
    let last = performance.now();
    const frame = (now) => {
      const dt = Math.min(0.05, (now - last) / 1000);
      last = now;
      this.time += dt;
      this.#step(dt);

      if (this.currentMap && !this.paused) {
        this.renderer.followCamera(this.currentMap, this.self);
        const others = [...this.players.values()].map((player) => ({
          ...player,
          emote: this.#emoteFor(player.character_id, now),
        }));
        this.renderer.render(this.currentMap, {
          players: others,
          self: { ...this.self, emote: this.#emoteFor(this.characterId, now) },
          farm: this.farm,
          hintTarget: this.hintTarget,
          time: this.time,
        });
      }
      // Minimap chỉ cần ~4 khung/giây, vẽ mỗi frame là phí.
      if (this.currentMap && now - this.minimapAt > 250) {
        this.minimapAt = now;
        this.#drawMinimap();
      }
      requestAnimationFrame(frame);
    };
    requestAnimationFrame(frame);
  }

  #emoteFor(characterId, now) {
    const emote = this.emotes.get(characterId);
    if (!emote) return null;
    if (emote.until < now) { this.emotes.delete(characterId); return null; }
    return emote.glyph;
  }
}

const OBJECT_LABEL = {
  open_match3: 'Chơi Match-3',
  open_inventory: 'Mở kho',
  open_quest: 'Xem nhiệm vụ',
};

const game = new Game();
window.game = game;
game.boot().catch((err) => {
  document.body.innerHTML = `<div style="padding:24px;font:15px system-ui;color:#eef6ef">Không khởi động được client: ${err.message}</div>`;
});
