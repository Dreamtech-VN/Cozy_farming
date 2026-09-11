/**
 * Bootstrap client + vòng lặp game (doc 12 — world là trung tâm, doc 16 — client
 * dự đoán chuyển động và đồng bộ với snapshot của server).
 */
import { Api } from './net/api.js';
import { Realtime } from './net/realtime.js';
import { i18n, t, formatNumber } from './core/i18n.js';
import { settings } from './core/settings.js';
import { atlas } from './render/atlas.js';
import { fx } from './render/fx.js';
import { showLoading } from './scenes/loading.js';
import { showServerSelect } from './scenes/servers.js';
import { showCharacterScreen } from './scenes/character.js';
import { audio } from './core/audio.js';
import { Input } from './core/input.js';
import { WorldRenderer } from './render/world.js';
import { drawAvatarPortrait } from './render/avatar.js';
import { levelProgress } from './core/progression.js';
import { WorldClock } from './core/world_clock.js';
import { renderQuestTracker, claimFromTracker } from './ui/quest_tracker.js';
import { buildHudMenus, markActiveMenu, markMenuBadge } from './ui/hud_menu.js';
import { ChatDock } from './ui/chat_dock.js';
import { renderOnboarding, onboardingDone } from './ui/onboarding.js';
import { Match3Scene } from './scenes/match3.js';
import { showLogin } from './scenes/login.js';
import { toast, closePanel } from './ui/ui.js';
import { openQuests, openInventory, openFarm, openSocial, openProfile, openShop, harvest, openAreaMap, openBusStop, openAchievements, openLeaderboards, openLiveOps, openMenu, openMail, openSettings, openDaily, energyLine } from './ui/panels.js';

// Trục dọc là chiều sâu, không phải độ cao — đi lùi vào trong chậm hơn đi ngang.
const DEPTH_SPEED = 0.55;
const RUN_SPEED = 260;
const INTERACT_RANGE = 90;
// Bảng đồ tuyến tự bật khi ĐỨNG VÀO trạm, nên bán kính này phải hẹp hơn tầm
// tương tác chung: rộng bằng nhau thì đi ngang qua cũng bị bảng đồ chặn mặt.
const BUS_STOP_RANGE = 56;

class Game {
  constructor() {
    this.api = new Api('');
    this.realtime = new Realtime(this.api);
    this.input = new Input();
    this.canvas = document.getElementById('stage');
    this.players = new Map();
    this.self = { x: 0, y: 0, vx: 0, vy: 0, facing: 1, state: 'idle', phase: 0, equipment: {} };
    this.currentMap = null;
    this.farm = null;
    this.paused = false;
    this.time = 0;
    this.hintTarget = null;
    this.emotes = new Map();
    this.channel = 1;
    this.worldClock = new WorldClock(this.api);
    this.worldClockAt = 0;
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
      currenciesById: new Map((raw.economy?.currencies ?? []).map((c) => [c.currency_id, c])),
      mapsById: new Map(),
      shopsById: new Map(),
    };
    await i18n.load(this.api, settings.value.locale);
    // Art hỏng thì vẫn vào được game, chỉ là cảnh về lại bản tô màu phẳng.
    // Đây mới là phần nhẹ (tile, sprite sinh bằng code); trang art vẽ sẵn nặng
    // hơn 20 MB nên tải ở màn chờ trong enterGame(), có thanh tiến độ.
    await atlas.load().catch((err) => console.warn('không nạp được art:', err.message));

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
    // Đổi mức đồ hoạ phải vẽ lại canvas ở độ phân giải mới ngay.
    settings.addEventListener('change', () => this.renderer.resize());
    // Tiếng bấm cho mọi nút giao diện, đi qua bus âm thanh nên tuân theo âm lượng.
    document.addEventListener('pointerdown', (event) => {
      if (event.target.closest('button')) audio.click();
    });


    const menuHandlers = {
      inventory: () => { openInventory(this); markActiveMenu('menu'); },
      mail: () => { openMail(this); markActiveMenu('menu'); },
      map: () => { openAreaMap(this); markActiveMenu('menu'); },
      achievements: () => { openAchievements(this); markActiveMenu('menu'); },
      leaderboard: () => { openLeaderboards(this); markActiveMenu('menu'); },
    };
    this.menuHandlers = menuHandlers;

    buildHudMenus(this, {
      shop: () => { openShop(this, 'shop_general'); markActiveMenu('shop'); },
      event: () => { openLiveOps(this); markActiveMenu('event'); },
      menu: (game, node) => { openMenu(this, menuHandlers, node); markActiveMenu('menu'); },
    });

    // Cụm thông tin nhân vật mở thẳng panel Nhân vật.
    document.getElementById('player-card').addEventListener('click', () => {
      closePanel();
      openProfile(this);
      markActiveMenu(null);
    });

    // Dấu cộng cạnh ví dẫn tới cửa hàng.
    document.getElementById('wallet-add').addEventListener('click', () => {
      closePanel();
      openShop(this, 'shop_general');
      markActiveMenu('shop');
    });

    // Chạm vào ô đất trong nông trại để thu hoạch nhanh (doc 12 — một hành động chính).
    this.canvas.addEventListener('pointerdown', (event) => {
      if (!this.farm || !this.currentMap?.farm_layout) return;
      const point = this.renderer.toWorld(this.currentMap, event.clientX, event.clientY);
      const plot = this.farm.plots.find((p) => p.screen && Math.abs(p.screen.x - point.x) < 46 && Math.abs(p.screen.y - point.y) < 70);
      if (!plot) return;
      if (plot.state === 'mature') harvest(this, plot.plot_id, () => this.refreshFarm());
      else { openFarm(this); markActiveMenu('menu'); }
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
      // Máy chủ gửi body_type; đổi sang bodyType một chỗ ở đây để chỗ vẽ không
      // phải nhớ hai cách viết.
      for (const player of players) this.players.set(player.character_id, { ...player, bodyType: player.body_type, phase: 0 });
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
      this.chatDock?.append(event.detail.message);
    });

    this.realtime.addEventListener('emote', (event) => {
      const emote = this.content.emotes.find((e) => e.emote_id === event.detail.emote_id);
      this.emotes.set(event.detail.character_id, { glyph: emote?.glyph ?? '!', until: performance.now() + 2500 });
    });
  }

  async enterGame({ pickServer = true } = {}) {
    if (pickServer) {
      // Chọn server TRƯỚC khi tải: tải xong 25 MB rồi mới hỏi đổi server thì
      // đổi xong lại phải tải lại từ đầu.
      const account = await this.api.get('/v1/account').catch(() => null);
      await showServerSelect(this, account);
      // Rồi mới tới nhân vật: nhân vật thuộc về một server cụ thể.
      const { characters } = await this.api.get('/v1/characters');
      await showCharacterScreen(this, characters);
    }
    // Chặn ở màn chờ tới khi tải xong art. Vào thẳng rồi để cảnh vật hiện dần
    // trông như game lỗi.
    await showLoading();
    const profile = await this.api.get('/v1/player/profile');
    this.characterId = profile.character_id;
    this.self.equipment = profile.equipment;
    this.self.nickname = profile.nickname;
    this.self.bodyType = profile.body_type;
    this.self.appearance = profile.appearance;
    this.profile = profile;

    document.getElementById('hud').classList.remove('hidden');
    this.chatDock ??= new ChatDock(this);
    this.chatDock.show();

    await this.enterMap(profile.position.map_id, 'spawn_default');
    this.#updateHud();
    await this.refreshOnboarding();
    // Mỏ neo đầu phiên: vào game là có thứ để nhận ngay.
    await openDaily(this, { auto: true });
    if (!this.running) {
      this.running = true;
      this.#loop();   // đã chạy từ màn đăng nhập thì lệnh này không làm gì
      // Sĩ số khu đổi khi người khác ra vào, nên làm mới định kỳ thay vì chỉ đọc
      // một lần lúc vào map.
      // Đồng hồ chạy cục bộ mỗi giây; hỏi lại server mỗi phút để không trôi lệch.
      setInterval(() => this.#renderWorldClock(), 1000);
      setInterval(() => this.#refreshWorldClock(), 60_000);
      // Tiến độ nhiệm vụ đổi theo nhiều đường (thu hoạch, trận đấu, NPC), nên
      // ngoài các điểm gọi tường minh vẫn quét lại định kỳ cho chắc.
      setInterval(() => this.refreshQuests(), 20_000);
    }
  }

  /**
   * Rời thế giới, quay về màn chọn server.
   *
   * Đổi server nghĩa là vào lại từ đầu, nên phải cắt kết nối và dọn HUD chứ
   * không chỉ đổi một biến — để nguyên thì người chơi vẫn đang đứng trong map
   * của server cũ.
   */
  async backToServerSelect() {
    closePanel();
    this.realtime.close();
    this.players.clear();
    this.currentMap = null;
    this.chatDock?.hide();
    document.getElementById('hud').classList.add('hidden');
    await this.enterGame();
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

    this.busStop = 'arrived';
    this.reportOnboarding('travel');
    this.self.x = entered.spawn.x;
    this.self.y = entered.spawn.y;
    this.self.vx = 0;
    this.self.vy = 0;

    this.realtime.close();
    this.realtime.connect(entered.instance_id);

    this.farm = map.farm_layout ? await this.api.get('/v1/farm') : null;
    this.channel = entered.channel ?? 1;
    await this.#refreshWorldClock();
    await this.refreshQuests();
    await this.chatDock?.loadHistory();
    await this.refreshMail();
  }

  /**
   * Giờ trong game, sáng tối và thời tiết — lấy từ server.
   * HUD không còn hiện đồng hồ nữa; dữ liệu này chỉ để renderer phủ sắc trời
   * theo giai đoạn trong ngày và vẽ mưa.
   */
  async #refreshWorldClock() {
    if (!this.currentMap) return;
    try {
      await this.worldClock.refresh(this.currentMap.map_id);
    } catch {
      return; // Mất mạng thì giữ nguyên trạng thái cũ.
    }
    this.#renderWorldClock();
  }

  #renderWorldClock() {
    const state = this.worldClock.now();
    if (state) this.renderer.setWorldState(state);
  }

  async refreshFarm() {
    if (this.currentMap?.farm_layout) this.farm = await this.api.get('/v1/farm');
  }

  async refreshPlayer() {
    const before = this.profile;
    this.profile = await this.api.get('/v1/player/profile');
    this.self.equipment = this.profile.equipment;
    this.#popGains(before, this.profile);
    this.#updateHud();
  }

  /**
   * Số bay lên khi ví hoặc XP đổi.
   *
   * Đặt ở ĐÂY chứ không ở từng chỗ gọi, vì mọi nguồn thu — thu hoạch, bán hàng,
   * nhận nhiệm vụ, điểm danh, thắng match-3 — đều phải gọi `refreshPlayer` để
   * cập nhật HUD. Móc một chỗ là phủ hết, mà thêm nguồn thu mới sau này cũng
   * không phải nhớ móc thêm.
   *
   * Chỉ báo phần TĂNG. Tiêu tiền thì người chơi vừa tự bấm mua, đã biết mình
   * tiêu; bắn thêm một số đỏ bay lên chỉ khiến màn hình ồn.
   */
  #popGains(before, after) {
    if (!before) return;                       // lần nạp đầu: không có gì để so
    const { x, y } = this.self;
    const head = y - 104;
    const LABEL = { coin: 'xu', gem: 'ngọc', energy: 'năng lượng' };
    for (const [currency, label] of Object.entries(LABEL)) {
      const delta = (after.wallet?.[currency] ?? 0) - (before.wallet?.[currency] ?? 0);
      if (delta > 0) fx.pop(x, head, `+${formatNumber(delta)} ${label}`, currency === 'gem' ? 'gem' : 'coin');
    }
    // XP so sánh theo TỔNG tích luỹ, không theo `xp` trong cấp: lên cấp thì `xp`
    // bị trừ đi phần đã tiêu, hiệu số hoá ra âm dù người chơi vừa được thưởng.
    if (after.level > before.level) {
      fx.pop(x, head - 26, `Cấp ${after.level}!`, 'level');
      fx.burst(x, y - 48);
      audio.levelUp();
    } else if (after.xp > before.xp) {
      fx.pop(x, head, `+${after.xp - before.xp} XP`, 'xp');
    }
  }

  /** Nhớ số thư chưa đọc để chấm đỏ trên nút Menu khớp với hòm thư. */
  setMailCounts({ unread, unclaimed }) {
    this.mailUnread = unread;
    this.mailUnclaimed = unclaimed;
    this.#refreshMenuBadge();
  }

  async refreshMail() {
    try { this.setMailCounts(await this.api.get('/v1/mails')); } catch { /* để nguyên số cũ */ }
  }

  #refreshMenuBadge() {
    const pending = (this.mailUnread ?? 0) > 0 || (this.questsPending ?? false);
    markMenuBadge('menu', pending);
  }

  /** Đăng xuất: báo server rồi xoá phiên và tải lại trang cho sạch trạng thái. */
  async logout() {
    try { await this.api.post('/v1/auth/logout', {}); } catch { /* hết hạn rồi thì thôi */ }
    this.api.setSession(null);
    location.reload();
  }

  /** Bước hướng dẫn hiện tại, lấy từ server. */
  async refreshOnboarding() {
    try {
      const { step } = await this.api.get('/v1/onboarding');
      this.#showOnboarding(step);
    } catch { /* mất mạng thì giữ nguyên thẻ cũ */ }
  }

  /**
   * Báo vừa làm một việc. Server tự lọc: sự kiện không đúng bước đang chờ thì
   * không nhích, nên chỗ gọi cứ bắn thoải mái, khỏi tự kiểm tra.
   *
   * Không chờ kết quả ở chỗ gọi: hướng dẫn là thứ phụ, không được làm chậm hay
   * làm hỏng hành động chính chỉ vì mạng chập.
   */
  reportOnboarding(event) {
    if (this.onboardingStep == null) return;          // đã xong hoặc đã bỏ qua
    this.api.post('/v1/onboarding/report', { event })
      .then((res) => { if (res.advanced) { onboardingDone(); this.#showOnboarding(res.step); } })
      .catch(() => { /* im lặng: không đáng làm phiền người chơi */ });
  }

  async skipOnboarding() {
    this.#showOnboarding(null);
    try { await this.api.post('/v1/onboarding/skip', {}); } catch { /* lần sau vào lại sẽ hiện lại */ }
  }

  #showOnboarding(step) {
    this.onboardingStep = step;
    const all = this.content.onboarding ?? [];
    const index = step ? all.findIndex((s) => s.step_id === step.step_id) : -1;
    renderOnboarding(this, step, { index: index < 0 ? null : index, total: all.length || null });
  }

  /** Bảng nhiệm vụ trên HUD. Gọi lại sau mỗi hành động có thể đổi tiến độ. */
  async refreshQuests() {
    try {
      const { quests, guide } = await this.api.get('/v1/quests');
      // Chỉ dẫn do server giải, gắn kèm danh sách nhiệm vụ nên luôn khớp với nó.
      this.guide = guide ?? null;
      renderQuestTracker(this, quests, {
        onOpen: () => { closePanel(); openQuests(this); markActiveMenu('menu'); },
        onClaim: (questId) => claimFromTracker(this, questId),
      });
      // Chấm đỏ trên nút Menu gộp cả nhiệm vụ chờ nhận lẫn thư chưa đọc.
      this.questsPending = quests.some((quest) => quest.state === 'completed');
      this.#refreshMenuBadge();
    } catch {
      // Mất mạng thì giữ nguyên bảng cũ thay vì xoá trắng.
    }
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
      // Không dùng dấu phân cách ngàn ở đây: "529 / 9.016" dễ bị đọc thành số thập phân.
      : `${Math.round(progress.current)} / ${Math.round(progress.needed)}`;

    drawAvatarPortrait(document.getElementById('avatar-portrait'), this.content, {
      bodyType: this.self.bodyType,
      appearance: profile.appearance,
      equipment: profile.equipment,
    });

    document.getElementById('hud-coin').lastElementChild.textContent = formatNumber(profile.wallet.coin ?? 0);
    document.getElementById('hud-gem').lastElementChild.textContent = formatNumber(profile.wallet.gem ?? 0);
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

    // Nhìn ngang nhưng đi được BỐN HƯỚNG trong một dải đất (doc 03).
    //
    // Không có trọng lực, không có nhảy, không có platform: đi lên là lùi vào
    // trong theo chiều sâu chứ không phải bay lên. Nhờ vậy không ai trèo được
    // lên nóc nhà, và cảnh vật phía sau luôn là nền chứ không thành chỗ đứng.
    const dirX = (this.input.keys.right ? 1 : 0) - (this.input.keys.left ? 1 : 0);
    const dirY = (this.input.keys.down ? 1 : 0) - (this.input.keys.up ? 1 : 0);
    if (dirX !== 0) self.facing = dirX;

    // Bước hướng dẫn "biết đi" xong khi đã đi được một QUÃNG, không phải khi
    // vừa chạm phím. Chạm phím thì lỡ tay cũng tính là xong, mà người chơi chưa
    // kịp thấy nhân vật nhúc nhích.
    if (this.onboardingStep?.event === 'move' && (dirX || dirY)) {
      this.walked = (this.walked ?? 0) + RUN_SPEED * dt;
      if (this.walked > 220) this.reportOnboarding('move');
    }

    // Đi chéo không được nhanh hơn đi thẳng.
    const len = Math.hypot(dirX, dirY) || 1;
    self.vx = (dirX / len) * RUN_SPEED;
    // Trục dọc là CHIỀU SÂU nên đi chậm hơn: cùng một quãng đường trên màn hình
    // ứng với quãng đường xa hơn trong không gian, đi bằng tốc độ ngang sẽ thấy
    // như trượt.
    self.vy = (dirY / len) * RUN_SPEED * DEPTH_SPEED;

    const backY = map.ground_y - (map.walk_depth ?? 0);
    self.x = Math.max(20, Math.min(map.width - 20, self.x + self.vx * dt));
    self.y = Math.max(backY, Math.min(map.ground_y, self.y + self.vy * dt));

    const moving = dirX !== 0 || dirY !== 0;
    self.state = moving ? 'walk' : 'idle';
    self.phase = (self.phase + dt * (moving ? 2.6 : 1)) % 1;

    if (self.state !== this.lastSentState
      || Math.abs(self.x - (this.lastSentX ?? 0)) > 1
      || Math.abs(self.y - (this.lastSentY ?? 0)) > 1) {
      this.realtime.sendMove({ x: Math.round(self.x), y: Math.round(self.y), facing: self.facing, state: self.state });
      this.lastSentState = self.state;
      this.lastSentX = self.x;
      this.lastSentY = self.y;
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
      ...map.portals.map((portal) => ({ id: portal.portal_id, x: portal.x, kind: 'portal', data: portal, label: 'Xem tuyến xe buýt' })),
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

    // Tới trạm là bảng đồ tuyến tự bật. Nhớ lại trạm vừa mở để đứng yên trong
    // trạm không bị bật đi bật lại; đi khỏi trạm mới quên.
    const stop = map.portals.find((portal) => Math.abs(portal.x - self.x) < BUS_STOP_RANGE);
    if (!stop) this.busStop = null;
    // 'arrived': vừa xuống xe ngay tại một trạm. Không quên ngay được, không thì
    // vừa tới nơi bảng đồ đã bật lên mời đi tiếp.
    else if (this.busStop !== stop.portal_id && this.busStop !== 'arrived') {
      this.busStop = stop.portal_id;
      openBusStop(this, stop);
    }
  }

  async #interact(target) {
    try {
      if (target.kind === 'portal') {
        this.busStop = target.data.portal_id;
        openBusStop(this, target.data);
        return;
      }
      if (target.kind === 'npc') {
        this.reportOnboarding('talk');
        const result = await this.api.post(`/v1/npcs/${target.data.npc_id}/talk`, {});
        if (result.dialogue) {
          for (const line of result.dialogue.lines) toast(`${t(target.data.name_key)}: ${t(line)}`);
        }
        await this.refreshQuests();
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

  /**
   * Vòng vẽ. Gọi bao nhiêu lần cũng chỉ chạy MỘT chuỗi.
   *
   * Trước đây có hai chỗ gọi: màn đăng nhập gọi một lần không chốt gì, vào game
   * gọi lần nữa. Thế là hai chuỗi requestAnimationFrame cùng cộng `dt` vào
   * `this.time` và cùng gọi `#step` — thế giới mô phỏng GẤP ĐÔI tốc độ. Không ai
   * nhận ra vì nó không sai ở chỗ nào rõ rệt: nhân vật chỉ đi nhanh hơn dự tính,
   * mưa rơi nhanh hơn, phủ sắc ngày đêm trôi nhanh hơn. Chỉ tới khi thêm hiệu
   * ứng số bay lên, thấy nó tắt trước khi kịp đọc, dò ra đồng hồ chạy 3.6 lần
   * thực tế, mới lần ngược lại được tới đây.
   */
  #loop() {
    if (this.looping) return;
    this.looping = true;
    let last = performance.now();
    let lastDraw = 0;
    const frame = (now) => {
      const dt = Math.min(0.05, (now - last) / 1000);
      last = now;
      this.time += dt;
      this.#step(dt);

      // Giới hạn FPS theo thiết lập: máy yếu chọn 30 thì bỏ nửa số khung vẽ,
      // nhưng phần mô phỏng ở #step vẫn chạy mỗi khung cho mượt điều khiển.
      const minGap = 1000 / settings.value.graphics.fpsCap - 1;
      const shouldDraw = now - lastDraw >= minGap;
      if (shouldDraw) lastDraw = now;

      if (this.currentMap && !this.paused && shouldDraw) {
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
          guide: this.guide,
          time: this.time,
        });
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
