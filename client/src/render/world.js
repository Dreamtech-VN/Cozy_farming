/**
 * Render map 2D side-view (doc 03 + doc 05).
 * Tách lớp background / midground / foreground, camera bám player,
 * mọi hình vẽ đều sinh theo data của map nên thêm map mới không cần sửa code.
 */
import { drawAvatar, roundRect } from './avatar.js';
import { t } from '../core/i18n.js';

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
    this.dpr = Math.min(devicePixelRatio || 1, 2);
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
        nickname: player.nickname,
        emote: player.emote,
      });
      ctx.restore();
    }

    this.#drawForeground(map);
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

    const weather = state.weather?.id;
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

  /** Parallax: đồi xa trôi chậm hơn camera (doc 05 — nhiều lớp chiều sâu). */
  #drawBackground(map, time) {
    const ctx = this.ctx;
    const drift = this.camera.x * 0.35;
    ctx.save();
    ctx.translate(drift, 0);
    ctx.fillStyle = shade(map.theme.ground, -32);
    for (let i = -1; i < map.width / 420 + 2; i++) {
      const x = i * 420 - drift * 0.6;
      ctx.beginPath();
      ctx.ellipse(x, map.ground_y - 10, 260, 130, 0, Math.PI, Math.PI * 2);
      ctx.fill();
    }
    ctx.restore();

    const drift2 = this.camera.x * 0.18;
    ctx.save();
    ctx.translate(drift2, 0);
    ctx.fillStyle = shade(map.theme.ground, -16);
    for (let i = -1; i < map.width / 300 + 2; i++) {
      const x = i * 300 - drift2 * 0.5;
      ctx.beginPath();
      ctx.ellipse(x, map.ground_y + 6, 190, 90, 0, Math.PI, Math.PI * 2);
      ctx.fill();
    }
    ctx.restore();

    this.#drawScenery(map);

    // Mây trôi nhẹ để thế giới có nhịp sống.
    ctx.globalAlpha = 0.5;
    ctx.fillStyle = '#ffffff';
    for (let i = 0; i < 8; i++) {
      const x = ((i * 397 + time * 12) % (map.width + 500)) - 250 + this.camera.x * 0.05;
      const y = 90 + (i % 3) * 60;
      ctx.beginPath();
      ctx.ellipse(x, y, 52, 20, 0, 0, Math.PI * 2);
      ctx.ellipse(x + 40, y + 6, 36, 15, 0, 0, Math.PI * 2);
      ctx.fill();
    }
    ctx.globalAlpha = 1;
  }

  /**
   * Cây và nhà dọc theo mặt đất. Sinh xác định từ map_id nên mỗi map luôn có
   * cùng một bố cục, và thêm map mới không cần vẽ tay asset (doc 05 — modular prop).
   */
  #drawScenery(map) {
    const ctx = this.ctx;
    const rng = seededRandom(hashString(map.map_id));
    const city = map.group === 'City';
    const count = Math.floor(map.width / 240);

    // Cảnh vật là lớp nền: giảm độ đậm để nhân vật và NPC luôn nổi lên phía trước
    // (doc 05 — silhouette gameplay phải đọc được trước bối cảnh).
    ctx.save();
    ctx.globalAlpha = 0.72;

    for (let i = 0; i < count; i++) {
      const x = 60 + i * 240 + rng() * 90;
      const scale = 0.75 + rng() * 0.55;
      const y = map.ground_y + 4;

      if (city && rng() > 0.35) {
        const w = 96 * scale;
        const h = (150 + rng() * 90) * scale;
        ctx.fillStyle = shade(map.theme.accent, -60 + Math.floor(rng() * 26));
        roundRect(ctx, x - w / 2, y - h, w, h, 6);
        ctx.fillStyle = shade(map.theme.accent, 34);
        for (let row = 0; row < Math.floor(h / 42); row++) {
          for (let col = 0; col < 2; col++) {
            roundRect(ctx, x - w / 2 + 16 + col * (w / 2 - 4), y - h + 22 + row * 42, 18, 20, 3);
          }
        }
        continue;
      }

      // Tán cây dùng bảng màu riêng, không phái sinh từ màu nền: nếu lấy theo
      // theme.ground thì cây chìm hẳn vào đồi và chỉ còn thấy mỗi thân cây.
      const trunk = 52 * scale;
      ctx.fillStyle = '#6a4a2f';
      roundRect(ctx, x - 7 * scale, y - trunk, 14 * scale, trunk, 4);
      ctx.fillStyle = shade('#2f6b34', Math.floor(rng() * 30));
      ctx.beginPath();
      ctx.arc(x, y - trunk - 26 * scale, 40 * scale, 0, Math.PI * 2);
      ctx.arc(x - 26 * scale, y - trunk - 8 * scale, 28 * scale, 0, Math.PI * 2);
      ctx.arc(x + 26 * scale, y - trunk - 8 * scale, 28 * scale, 0, Math.PI * 2);
      ctx.fill();
    }
    ctx.restore();
  }

  #drawGround(map) {
    const ctx = this.ctx;
    // Kéo nền đất xuống hết khung nhìn: camera dọc được phép tràn dưới đáy map,
    // nếu chỉ fill tới map.height thì lộ ra khoảng trời ở dưới chân nhân vật.
    const depth = map.height - map.ground_y + this.viewHeight + 400;
    ctx.fillStyle = map.theme.ground;
    ctx.fillRect(-200, map.ground_y, map.width + 400, depth);
    ctx.fillStyle = shade(map.theme.ground, 22);
    ctx.fillRect(-200, map.ground_y, map.width + 400, 10);

    // Vệt cỏ rải trên mặt đất: màn hình ngang để lộ nhiều nền, nếu để phẳng trơn
    // thì mất cảm giác chiều sâu. Sinh theo seed của map nên bố cục cố định.
    const rng = seededRandom(hashString(map.map_id) ^ 0x9e3779b9);
    ctx.fillStyle = shade(map.theme.ground, -18);
    const rows = Math.ceil(Math.min(depth, this.viewHeight) / 70);
    for (let row = 0; row < rows; row++) {
      const y = map.ground_y + 26 + row * 70;
      for (let i = 0; i < map.width / 70; i++) {
        const x = i * 70 + rng() * 60;
        const w = 10 + rng() * 16;
        ctx.beginPath();
        ctx.ellipse(x, y + rng() * 26, w, 3.5, 0, 0, Math.PI * 2);
        ctx.fill();
      }
    }
  }

  #drawPlatforms(map) {
    const ctx = this.ctx;
    for (const platform of map.platforms ?? []) {
      ctx.fillStyle = shade(map.theme.ground, -8);
      roundRect(ctx, platform.x, platform.y, platform.w, platform.h, 6);
      ctx.fillStyle = shade(map.theme.ground, 26);
      roundRect(ctx, platform.x, platform.y, platform.w, 4, 2);
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

      ctx.fillStyle = plot.state === 'empty' ? '#6b4b30' : '#7a5a3a';
      roundRect(ctx, x - 42, y - 16, 84, 20, 6);
      ctx.fillStyle = 'rgba(0,0,0,.16)';
      roundRect(ctx, x - 42, y - 16, 84, 5, 3);

      if (plot.state === 'empty') return;
      const crop = this.content.cropsById.get(plot.crop_id);
      if (!crop) return;

      const ready = plot.state === 'mature';
      const progress = ready ? 1 : (plot.stage + 1) / crop.stages;
      const height = 12 + progress * 42;
      const sway = Math.sin(time * 2 + index) * (2 + progress * 2);

      ctx.strokeStyle = crop.palette[1];
      ctx.lineWidth = 4;
      ctx.beginPath();
      ctx.moveTo(x, y - 14);
      ctx.quadraticCurveTo(x + sway, y - 14 - height / 2, x + sway, y - 14 - height);
      ctx.stroke();

      ctx.fillStyle = crop.palette[0];
      const size = 5 + progress * 9;
      ctx.beginPath();
      ctx.arc(x + sway, y - 16 - height, size, 0, Math.PI * 2);
      ctx.fill();

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
      ctx.fillStyle = highlight ? shade(map.theme.accent, 30) : map.theme.accent;
      roundRect(ctx, object.x - object.w / 2, object.y - object.h, object.w, object.h, 8);
      ctx.fillStyle = 'rgba(255,255,255,.18)';
      roundRect(ctx, object.x - object.w / 2, object.y - object.h, object.w, 8, 4);
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
export function shade(hex, amount) {
  const value = hex.replace('#', '');
  const num = parseInt(value.length === 3 ? value.split('').map((c) => c + c).join('') : value, 16);
  const clamp = (v) => Math.max(0, Math.min(255, v));
  const r = clamp((num >> 16) + amount);
  const g = clamp(((num >> 8) & 0xff) + amount);
  const b = clamp((num & 0xff) + amount);
  return `#${((r << 16) | (g << 8) | b).toString(16).padStart(6, '0')}`;
}
