/**
 * Render map 2D side-view (doc 03 + doc 05).
 * Tách lớp background / midground / foreground, camera bám player,
 * mọi hình vẽ đều sinh theo data của map nên thêm map mới không cần sửa code.
 */
import { drawAvatar, roundRect } from './avatar.js';
import { t } from '../core/i18n.js';
import { settings } from '../core/settings.js';
import { atlas } from './atlas.js';

/** Tile 16px phóng 3 lần: đủ to để thấy rõ pixel mà không vỡ hình. */
const TILE_SCALE = 3;

/** Chọn biến thể tile cố định theo cột, để cùng một chỗ luôn ra cùng hoa văn. */
const hashCol = (mapId, col) => Math.abs(hashString(`${mapId}:${col}`));

/**
 * Ngăn xếp lớp cảnh, khai báo MỘT chỗ và vẽ đúng thứ tự này.
 *
 * `factor` là tốc độ trôi so với mặt sân (mặt sân = 1). Hai lớp đồi là thứ tạo
 * ra chiều sâu chứ không phải trang trí: hai dải trôi ở hai tốc độ khác nhau
 * mới ra parallax, một dải thì nhìn vẫn phẳng.
 *
 * Quy tắc đọc được: KHÔNG lớp nền nào được dùng sprite mà người chơi phải tương
 * tác (đài phun, bảng tin, máy game) — nhìn thấy ở nền rồi chạy tới bấm không
 * được thì ức chế. Vật tương tác chỉ nằm ở lớp mặt sân.
 */
// Hình học của từng lớp khai báo ở đây; DANH SÁCH VẬT thì lấy từ data của map
// (`scenery` trong maps.json). Trước đây danh sách nằm cứng trong code nên map
// nào cũng rải đúng một bộ, đi từ phố sang rừng vẫn thấy y hệt nhau.
const LAYERS = {
  hillsFar:  { factor: 0.12, slot: 300, baseY: -96, kinds: ['tree_big', 'tree_small'], scale: [1.5, 2.2], skip: 0.1, haze: 0.62 },
  hillsNear: { factor: 0.30, slot: 260, baseY: -58, kinds: ['tree_big', 'bush', 'rock'], scale: [1.5, 2.2], skip: 0.15, haze: 0.34 },
  mid:       { factor: 0.55, slot: 300, baseY: 0, kinds: ['house', 'stall', 'tree_big', 'tree_small', 'haystack'], scale: [1.8, 2.6], skip: 0.2, haze: 0.1 },
  /*
   * Tiền cảnh: chỉ một viền cỏ ở SÁT MÉP DƯỚI màn hình.
   *
   * Bản đầy đủ của kỹ thuật này (vật to lướt ngang qua sát camera) hợp game
   * chạy ngang tốc độ cao. Ở đây camera đi bộ chậm và vùng chơi nằm ngay giữa
   * màn hình, nên vật tiền cảnh to sẽ che mất chỗ đang chơi — trái đúng nguyên
   * tắc "vùng tương tác luôn là lớp trên cùng". Giữ đúng phần thêm chiều sâu mà
   * không chắn tầm nhìn: neo dưới mép dưới nên chỉ ló ngọn cỏ.
   */
  fore:      { factor: 1.5, slot: 300, anchor: 'viewBottom', baseY: 128, kinds: ['grass_tall'], scale: [2, 2.8], skip: 0.4, haze: 0 },
};

/** Băm xác định theo (lớp, ô) — quay lại chỗ cũ là thấy đúng cảnh cũ, không lưu gì. */
const slotHash = (mapId, layer, slot, salt) => {
  const h = hashString(`${mapId}|${layer}|${slot}|${salt}`);
  return (Math.abs(h) % 10000) / 10000;
};

export class WorldRenderer {
  constructor(canvas, content) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.content = content;
    this.camera = { x: 0, y: 0 };
    this.dpr = 1;
    this.resize();
    addEventListener('resize', () => this.resize());
  }

  resize() {
    // Trần dpr lấy từ thiết lập đồ hoạ: máy yếu hạ xuống 1 là giảm hẳn số điểm
    // phải vẽ mỗi khung.
    this.dpr = Math.min(devicePixelRatio || 1, settings.maxDpr);
    this.canvas.width = Math.floor(this.canvas.clientWidth * this.dpr);
    this.canvas.height = Math.floor(this.canvas.clientHeight * this.dpr);
  }

  get viewWidth() { return this.canvas.width / this.dpr / this.scale; }
  get viewHeight() { return this.canvas.height / this.dpr / this.scale; }

  /** Map hiện tại quyết định zoom, nên renderer cần biết map đang vẽ. */
  setMap(map) { this.map = map; }

  /** Giờ trong ngày và thời tiết lấy từ server (doc 03 — weather/day-night flags). */
  setWorldState(state) { this.world = state; }

  /**
   * Zoom cân giữa hai ràng buộc:
   *  - chiều rộng: game side-view sống nhờ bối cảnh hai bên. Màn hình ngang cho
   *    thấy khoảng 900px thế giới, đủ để NPC và portal hai bên vào khung;
   *  - chiều cao: nếu khung nhìn cao hơn map quá nhiều thì nửa dưới màn hình chỉ
   *    còn một mảng đất trống.
   * Lấy giá trị lớn hơn của hai mức tối thiểu để không vi phạm ràng buộc nào.
   */
  get scale() {
    const width = this.canvas.width / this.dpr;
    const height = this.canvas.height / this.dpr;
    const mapHeight = this.map?.height ?? 720;
    const byWidth = width / 900;
    const byHeight = height / (mapHeight * 1.35);
    return Math.max(0.5, Math.min(1.8, Math.max(byWidth, byHeight)));
  }

  /**
   * Nhân vật đứng ở khoảng 76% chiều cao khung nhìn — tức camera đặt cao hơn và
   * chúc xuống. Để thấp hơn (66% như trước) thì gần một phần ba màn hình phía
   * dưới chỉ còn nền đất trống, trong khi nhà cửa và cây phía trên bị cắt ngọn.
   */
  get anchorY() { return this.viewHeight * 0.76; }

  followCamera(map, target) {
    const halfW = this.viewWidth / 2;
    this.camera.x = map.width < this.viewWidth ? map.width / 2 : Math.max(halfW, Math.min(map.width - halfW, target.x));

    // Camera dọc bám người chơi và chỉ chặn phía TRÊN (không lộ ra ngoài trời của
    // map). Phía dưới cứ để tràn: nền đất được vẽ kéo dài xuống hết khung nhìn,
    // nên màn hình dọc không bị dồn hết cảnh vật xuống đáy.
    this.camera.y = Math.max(this.anchorY - 40, target.y);
  }

  render(map, { players, self, farm, hintTarget, time }) {
    const ctx = this.ctx;
    const scale = this.scale;
    ctx.setTransform(this.dpr * scale, 0, 0, this.dpr * scale, 0, 0);
    ctx.clearRect(0, 0, this.viewWidth, this.viewHeight);

    this.#drawSky(map);

    ctx.save();
    ctx.translate(this.viewWidth / 2 - this.camera.x, this.anchorY - this.camera.y);

    this.#drawBackground(map, time);
    this.#drawGround(map);
    this.#drawPlatforms(map);
    if (farm) this.#drawFarm(map, farm, time);
    this.#drawObjects(map, hintTarget);
    this.#drawPortals(map, hintTarget);
    this.#drawNpcs(map, hintTarget, time);

    const everyone = [...players, self].sort((a, b) => a.y - b.y);
    for (const player of everyone) {
      ctx.save();
      ctx.translate(player.x, player.y);
      drawAvatar(ctx, this.content, {
        equipment: player.equipment,
        facing: player.facing,
        state: player.state,
        phase: player.phase ?? 0,
        // Ẩn tên người khác giúp màn hình đỡ rối ở khu đông người.
        nickname: player === self || settings.value.graphics.otherNames ? player.nickname : null,
        emote: player.emote,
      });
      ctx.restore();
    }

    this.#drawForeground(map);
    // Lớp tiền cảnh lướt qua sát camera, vẽ sau cùng và không hề chặn thao tác.
    this.#drawLayer(map, 'fore', time);
    ctx.restore();

    this.#drawWorldMood(time);
  }

  /**
   * Phủ sắc theo giờ trong ngày và vẽ thời tiết. Vẽ ở toạ độ MÀN HÌNH sau khi đã
   * dựng xong thế giới, nên một lớp phủ là đủ cho cả trời lẫn đất — không phải
   * đụng vào từng lớp vẽ bên trong.
   */
  #drawWorldMood(time) {
    const state = this.world;
    if (!state) return;
    const ctx = this.ctx;
    const width = this.viewWidth;
    const height = this.viewHeight;

    const tint = PHASE_TINT[state.phase];
    if (tint) {
      const gradient = ctx.createLinearGradient(0, 0, 0, height);
      gradient.addColorStop(0, tint.top);
      gradient.addColorStop(1, tint.bottom);
      ctx.fillStyle = gradient;
      ctx.fillRect(0, 0, width, height);
    }

    const weather = settings.value.graphics.weather ? state.weather?.id : null;
    const veil = WEATHER_VEIL[weather];
    if (veil) {
      ctx.fillStyle = veil;
      ctx.fillRect(0, 0, width, height);
    }

    if (weather === 'rain' || weather === 'storm') this.#drawRain(width, height, time, weather === 'storm');
  }

  /** Mưa: các vệt rơi tính thẳng từ thời gian nên không phải giữ mảng hạt. */
  #drawRain(width, height, time, heavy) {
    const ctx = this.ctx;
    const count = heavy ? 160 : 90;
    const speed = heavy ? 1150 : 780;
    const slant = heavy ? 0.28 : 0.16;
    const length = heavy ? 26 : 18;

    ctx.save();
    ctx.strokeStyle = heavy ? 'rgba(198, 224, 255, .55)' : 'rgba(200, 226, 255, .45)';
    ctx.lineWidth = heavy ? 1.6 : 1.2;
    ctx.lineCap = 'round';
    ctx.beginPath();
    for (let i = 0; i < count; i++) {
      const seedX = ((i * 9301 + 49297) % 233280) / 233280;
      const seedY = ((i * 4801 + 12923) % 233280) / 233280;
      const fall = (seedY * height + time * speed) % (height + length);
      const x = seedX * (width + 200) - 100 + fall * slant;
      ctx.moveTo(x, fall - length);
      ctx.lineTo(x - length * slant, fall);
    }
    ctx.stroke();
    ctx.restore();
  }

  #drawSky(map) {
    const ctx = this.ctx;
    const gradient = ctx.createLinearGradient(0, 0, 0, this.viewHeight);
    gradient.addColorStop(0, map.theme.sky[0]);
    gradient.addColorStop(1, map.theme.sky[1]);
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, this.viewWidth, this.viewHeight);
  }

  /**
   * Vẽ một lớp cảnh: chia thế giới thành ô, mỗi ô băm ra biến thể/vị trí/cỡ.
   * Chỉ dựng những ô lọt vào khung nhìn nên map rộng bao nhiêu cũng vậy.
   */
  /** Vật của lớp: ưu tiên khai báo trong data map, không có thì dùng mặc định. */
  #kindsFor(map, name) {
    return map.scenery?.[name] ?? LAYERS[name].kinds;
  }

  #drawLayer(map, name, time) {
    if (!atlas.ready) return;
    const ctx = this.ctx;
    const spec = LAYERS[name];
    // Lớp trôi chậm hơn mặt sân, nên dịch ngược lại phần chênh lệch.
    const shift = this.camera.x * (1 - spec.factor);
    const viewLeft = this.camera.x - this.viewWidth / 2 - shift;
    const from = Math.floor((viewLeft - spec.slot) / spec.slot);
    const to = Math.ceil((viewLeft + this.viewWidth + spec.slot) / spec.slot);

    ctx.save();
    ctx.translate(shift, 0);
    if (spec.haze > 0) ctx.globalAlpha = 1 - spec.haze;
    // Lớp tiền cảnh lướt sát camera nên làm mờ — đó là thứ khiến nó đọc ra
    // "gần" chứ không phải "vật cản".
    if (name === 'fore') { ctx.filter = 'blur(3px)'; ctx.globalAlpha = 0.9; }

    const kinds = this.#kindsFor(map, name);
    for (let slot = from; slot <= to; slot++) {
      if (slotHash(map.map_id, name, slot, 'skip') < spec.skip) continue;
      const pick = slotHash(map.map_id, name, slot, 'kind');
      const kind = kinds[Math.floor(pick * kinds.length) % kinds.length];
      const jitter = (slotHash(map.map_id, name, slot, 'x') - 0.5) * spec.slot * 0.7;
      const [lo, hi] = spec.scale;
      const scale = lo + slotHash(map.map_id, name, slot, 's') * (hi - lo);
      const x = slot * spec.slot + jitter;
      // Chân đặt theo mốc riêng của lớp: lớp đồi đứng trên sườn đồi phía sau,
      // lớp tiền cảnh neo vào mép dưới khung nhìn nên luôn ló đúng phần ngọn dù
      // camera đang ở đâu.
      const anchorBase = spec.anchor === 'viewBottom'
        ? this.camera.y + (this.viewHeight - this.anchorY)
        : map.ground_y;
      const y = anchorBase + spec.baseY;
      atlas.prop(ctx, kind, x, y, scale);
    }
    ctx.restore();
  }

  /** Nền: trời → mây → hai dải đồi → lớp cảnh giữa. */
  #drawBackground(map, time) {
    const ctx = this.ctx;

    // Mây trôi nhẹ để thế giới có nhịp sống. Giữ mây đủ thấp so với mép trên
    // khung nhìn: mây bị mép cắt ngang trông như một mảng trắng dán lên màn hình.
    const cloudTop = Math.max(map.ground_y - 430, this.camera.y - this.anchorY + 60);
    ctx.save();
    ctx.globalAlpha = 0.5;
    ctx.fillStyle = '#ffffff';
    for (let i = 0; i < 8; i++) {
      const x = ((i * 397 + time * 12) % (map.width + 500)) - 250 + this.camera.x * 0.9;
      const y = cloudTop + (i % 3) * 58;
      ctx.beginPath();
      ctx.ellipse(x, y, 52, 20, 0, 0, Math.PI * 2);
      ctx.ellipse(x + 40, y + 6, 36, 15, 0, 0, Math.PI * 2);
      ctx.fill();
    }
    ctx.restore();

    // Phối cảnh trên không: dải càng XA thì càng ngả về màu trời — nhạt hơn và
    // ít tương phản hơn, chứ không phải tối hơn. Tối dần về xa là làm ngược,
    // nhìn ra hai vệt đè lên nhau chứ không ra chiều sâu.
    const sky = map.theme.sky[1];
    this.#drawRidge(map, 0.12, 128, mixColour(map.theme.ground, sky, 0.5), 470);
    this.#drawRidge(map, 0.30, 96, mixColour(map.theme.ground, sky, 0.26), 330);

    this.#drawLayer(map, 'hillsFar', time);
    this.#drawLayer(map, 'hillsNear', time);
    this.#drawLayer(map, 'mid', time);
  }

  /** Một dải đồi liền mạch; các mảnh chồng lên nhau nên không thành gò rời rạc. */
  #drawRidge(map, factor, height, colour, spacing) {
    const ctx = this.ctx;
    const shift = this.camera.x * (1 - factor);
    const viewLeft = this.camera.x - this.viewWidth / 2 - shift;
    ctx.save();
    ctx.translate(shift, 0);
    ctx.fillStyle = colour;
    const from = Math.floor((viewLeft - spacing) / spacing);
    const to = Math.ceil((viewLeft + this.viewWidth + spacing) / spacing);
    for (let i = from; i <= to; i++) {
      const wobble = 0.8 + slotHash(map.map_id, `ridge${factor}`, i, 'h') * 0.5;
      ctx.beginPath();
      // Bán trục ngang lớn hơn khoảng cách ô nên các vòm chồng mép vào nhau.
      ctx.ellipse(i * spacing, map.ground_y + 8, spacing * 0.78, height * wobble, 0, Math.PI, Math.PI * 2);
      ctx.fill();
    }
    ctx.restore();
  }

  #drawGround(map) {
    const ctx = this.ctx;
    // Kéo nền đất xuống hết khung nhìn: camera dọc được phép tràn dưới đáy map,
    // nếu chỉ fill tới map.height thì lộ ra khoảng trời ở dưới chân nhân vật.
    const depth = map.height - map.ground_y + this.viewHeight + 400;

    if (!atlas.ready) {
      ctx.fillStyle = map.theme.ground;
      ctx.fillRect(-200, map.ground_y, map.width + 400, depth);
      return;
    }

    // Lát tile theo lưới: một hàng tile "mặt cỏ" ở trên, còn lại là đất. Chỉ vẽ
    // phần lọt vào khung nhìn — map rộng 2600px mà lát hết thì mỗi khung tốn
    // hàng nghìn lệnh drawImage vô ích.
    // camera.x/y là TÂM khung nhìn (xem followCamera), không phải mép trái/trên
    // — lấy nhầm là nửa màn hình bên trái không được lát tile nào.
    const size = atlas.meta.tiles.size * TILE_SCALE;
    const viewLeft = this.camera.x - this.viewWidth / 2;
    const viewBottom = this.camera.y + (this.viewHeight - this.anchorY);
    const left = Math.floor((viewLeft - size) / size) * size;
    const right = viewLeft + this.viewWidth + size;
    const rows = Math.ceil(depth / size);
    const seed = hashString(map.map_id);

    for (let x = left; x < right; x += size) {
      const col = Math.round(x / size);
      for (let row = 0; row < rows; row++) {
        const y = map.ground_y + row * size;
        if (y > viewBottom + size) break;
        // Hàng đầu là mặt cỏ (3 biến thể), các hàng dưới là đất (2 biến thể).
        const index = row === 0
          ? Math.abs(hashString(`${seed}:${col}`)) % 3
          : 3 + (Math.abs(hashString(`${seed}:${col}:${row}`)) % 2);
        atlas.tile(ctx, index, x, y, TILE_SCALE);
      }
    }
  }

  #drawPlatforms(map) {
    const ctx = this.ctx;
    for (const platform of map.platforms ?? []) {
      if (!atlas.ready) {
        ctx.fillStyle = shade(map.theme.ground, -8);
        roundRect(ctx, platform.x, platform.y, platform.w, platform.h, 6);
        continue;
      }
      // Bệ đứng lát bằng chính tile mặt đất, khỏi lạc chất với nền.
      const size = atlas.meta.tiles.size * TILE_SCALE;
      const cols = Math.max(1, Math.round(platform.w / size));
      const step = platform.w / cols;
      for (let i = 0; i < cols; i++) {
        const x = platform.x + i * step;
        ctx.save();
        // Bệ hẹp hơn một tile thì phải co ngang, không thì thò ra ngoài mép bệ.
        ctx.translate(x, platform.y);
        ctx.scale(step / size, 1);
        atlas.tile(ctx, hashCol(map.map_id, i) % 3, 0, 0, TILE_SCALE);
        ctx.restore();
      }
    }
  }

  /** Ô đất + cây trồng theo từng giai đoạn (doc 06 — visual_stages). */
  #drawFarm(map, farm, time) {
    const ctx = this.ctx;
    const layout = map.farm_layout;
    if (!layout) return;

    farm.plots.forEach((plot, index) => {
      const x = layout.plot_origin_x + index * layout.plot_spacing_x;
      const y = layout.plot_y;
      plot.screen = { x, y };

      if (atlas.ready) {
        const crop = plot.crop_id ? this.content.cropsById.get(plot.crop_id) : null;
        // stage của server đếm từ 0; ô chín vẽ khung cuối cùng của sprite.
        const stage = plot.state === 'mature' ? atlas.meta.crops.stages - 1 : plot.stage ?? 0;
        // Sprite tra theo crop_id nên thêm cây mới không phải sửa gì ở đây.
        if (plot.state === 'empty') atlas.prop(ctx, 'soil', x, y + 4, 1.6);
        else atlas.crop(ctx, plot.crop_id, stage, x, y + 4, 2.6);
      }

      if (plot.state === 'empty') return;
      const crop = this.content.cropsById.get(plot.crop_id);
      if (!crop) return;
      const ready = plot.state === 'mature';
      const sway = Math.sin(time * 2 + index) * 2;
      const height = 40;

      if (ready) { // hào quang báo "thu hoạch được"
        ctx.strokeStyle = 'rgba(242,201,76,.85)';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.arc(x + sway, y - 16 - height, size + 6 + Math.sin(time * 4) * 2, 0, Math.PI * 2);
        ctx.stroke();
      }
    });
  }

  #drawObjects(map, hintTarget) {
    const ctx = this.ctx;
    for (const object of map.objects ?? []) {
      const highlight = hintTarget?.id === object.object_id;
      if (atlas.ready && object.sprite) {
        // Vật đang trong tầm tương tác thì sáng lên, thay cho đổi màu tô.
        ctx.save();
        if (highlight) { ctx.shadowColor = 'rgba(255,232,150,.95)'; ctx.shadowBlur = 18; }
        atlas.prop(ctx, object.sprite, object.x, object.y + 4, object.scale ?? 2);
        ctx.restore();
        continue;
      }
      ctx.fillStyle = highlight ? shade(map.theme.accent, 30) : map.theme.accent;
      roundRect(ctx, object.x - object.w / 2, object.y - object.h, object.w, object.h, 8);
    }
  }

  #drawPortals(map, hintTarget) {
    const ctx = this.ctx;
    for (const portal of map.portals) {
      const highlight = hintTarget?.id === portal.portal_id;
      ctx.globalAlpha = highlight ? 0.95 : 0.65;
      const gradient = ctx.createLinearGradient(0, portal.y - portal.h, 0, portal.y);
      gradient.addColorStop(0, '#eaf7ff');
      gradient.addColorStop(1, '#6fb6d8');
      ctx.fillStyle = gradient;
      roundRect(ctx, portal.x - portal.w / 2, portal.y - portal.h, portal.w, portal.h, portal.w / 2);
      ctx.globalAlpha = 1;

      ctx.font = '600 12px system-ui, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillStyle = '#0e1a15';
      ctx.fillText(t(portal.label_key), portal.x, portal.y - portal.h - 8);
    }
  }

  #drawNpcs(map, hintTarget, time) {
    const ctx = this.ctx;
    for (const npc of map.npcs) {
      ctx.save();
      ctx.translate(npc.x, npc.y);
      // NPC không có tủ đồ; màu lấy thẳng từ palette khai báo trong data map.
      drawAvatar(ctx, this.content, {
        equipment: {},
        palette: { body: npc.palette[0], top: npc.palette[1], hair: npc.palette[2] },
        facing: -1,
        state: 'idle',
        phase: 0,
        nickname: t(npc.name_key),
      });
      ctx.restore();

      const bounce = Math.sin(time * 3 + npc.x) * 3;
      ctx.fillStyle = hintTarget?.id === npc.npc_id ? '#f2c94c' : 'rgba(242,201,76,.75)';
      ctx.beginPath();
      ctx.moveTo(npc.x, npc.y - 118 + bounce);
      ctx.lineTo(npc.x - 7, npc.y - 130 + bounce);
      ctx.lineTo(npc.x + 7, npc.y - 130 + bounce);
      ctx.closePath();
      ctx.fill();
    }
  }

  /** Bụi cỏ tiền cảnh bám sát đáy khung nhìn, tạo chiều sâu mà không che gameplay. */
  #drawForeground(map) {
    const ctx = this.ctx;
    const baseY = this.camera.y + (this.viewHeight - this.anchorY) + 30;
    if (baseY <= map.ground_y + 40) return;

    ctx.globalAlpha = 0.55;
    ctx.fillStyle = shade(map.theme.ground, -34);
    for (let i = 0; i < map.width / 240 + 4; i++) {
      const x = i * 240 - this.camera.x * 0.06;
      ctx.beginPath();
      ctx.ellipse(x, baseY, 160, 60, 0, Math.PI, Math.PI * 2);
      ctx.fill();
    }
    ctx.globalAlpha = 1;
  }

  /** Đổi toạ độ màn hình -> toạ độ thế giới (dùng cho chạm vào ô đất). */
  toWorld(map, clientX, clientY) {
    const rect = this.canvas.getBoundingClientRect();
    const scale = this.scale;
    const x = (clientX - rect.left) / scale - this.viewWidth / 2 + this.camera.x;
    const y = (clientY - rect.top) / scale - this.anchorY + this.camera.y;
    return { x, y };
  }
}

/**
 * Sắc phủ theo giai đoạn trong ngày. Bình minh và hoàng hôn ám ấm, ban đêm ám
 * xanh lạnh và đậm hơn hẳn; ban ngày không phủ gì.
 */
const PHASE_TINT = {
  dawn: { top: 'rgba(255, 176, 104, .17)', bottom: 'rgba(255, 214, 162, .07)' },
  dusk: { top: 'rgba(255, 128, 72, .19)', bottom: 'rgba(146, 92, 128, .10)' },
  night: { top: 'rgba(14, 26, 68, .50)', bottom: 'rgba(24, 44, 88, .34)' },
};

/* Màn thời tiết phải nhẹ tay: nó chồng lên sắc phủ theo giờ, hai lớp cộng lại
   dễ biến cả khung hình thành một mảng xám bệch. */
const WEATHER_VEIL = {
  cloudy: 'rgba(120, 134, 152, .10)',
  rain: 'rgba(64, 92, 128, .15)',
  storm: 'rgba(38, 54, 86, .26)',
};

/** Hash chuỗi -> số nguyên, để mỗi map có bố cục cảnh vật cố định. */
function hashString(value) {
  let hash = 2166136261;
  for (const ch of value) hash = Math.imul(hash ^ ch.charCodeAt(0), 16777619);
  return hash >>> 0;
}

function seededRandom(seed) {
  let a = seed >>> 0;
  return () => {
    a = (a + 0x6d2b79f5) >>> 0;
    let t = a;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

/** Làm sáng/tối một màu hex — dùng để dựng bảng màu phái sinh cho từng map. */
/** Trộn hai màu hex theo tỉ lệ — dùng cho phối cảnh trên không của các dải đồi. */
export function mixColour(a, b, k) {
  const parse = (hex) => {
    const v = hex.replace('#', '');
    const n = parseInt(v.length === 3 ? [...v].map((c) => c + c).join('') : v, 16);
    return [(n >> 16) & 0xff, (n >> 8) & 0xff, n & 0xff];
  };
  const [r1, g1, b1] = parse(a);
  const [r2, g2, b2] = parse(b);
  const mix = (x, y) => Math.round(x + (y - x) * k);
  return `#${((mix(r1, r2) << 16) | (mix(g1, g2) << 8) | mix(b1, b2)).toString(16).padStart(6, '0')}`;
}

export function shade(hex, amount) {
  const value = hex.replace('#', '');
  const num = parseInt(value.length === 3 ? value.split('').map((c) => c + c).join('') : value, 16);
  const clamp = (v) => Math.max(0, Math.min(255, v));
  const r = clamp((num >> 16) + amount);
  const g = clamp(((num >> 8) & 0xff) + amount);
  const b = clamp((num & 0xff) + amount);
  return `#${((r << 16) | (g << 8) | b).toString(16).padStart(6, '0')}`;
}
