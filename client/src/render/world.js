/**
 * Render map 2D side-view (doc 03 + doc 05).
 * Tách lớp background / midground / foreground, camera bám player,
 * mọi hình vẽ đều sinh theo data của map nên thêm map mới không cần sửa code.
 */
import { drawAvatar, roundRect } from './avatar.js';
import { fx } from './fx.js';
import { t } from '../core/i18n.js';
import { settings } from '../core/settings.js';
import { atlas } from './atlas.js';

/**
 * Ô đất trên màn hình rộng bao nhiêu pixel.
 *
 * Buộc theo cỡ MÀN HÌNH chứ không phải theo cỡ ô trong file: tileset sinh bằng
 * code là ô 16px, tileset cắt từ art vẽ sẵn là ô 48px — chốt một con số phóng
 * thì đổi bảng art là mặt đất to gấp ba.
 */
// Bóng nhân vật. Hẹp và tròn hơn bóng công trình vì người đứng chân chụm, và
// nhạt hơn vì thân người mảnh, che ít nắng hơn cái mái trạm.
const AVATAR_FOOT = 40;
const CHARACTER_SHADOW = { tone: 0.58, soft: 2.4, flat: 0.32 };

const TILE_PX = 48;
/**
 * Mặt đất mặc định: bãi cỏ với mặt cắt đất bên dưới.
 *
 * Map khai `ground` trong maps.json thì dùng khai báo đó. Ba tầng, kể từ trên
 * xuống: `floor` lát kín dải ĐI ĐƯỢC, `edge` đúng MỘT hàng ở `ground_y` (mép
 * trước của dải), `below` phủ nốt phần còn lại xuống hết khung nhìn.
 *
 * Nhờ ba tầng này mà một thị trấn lát đá và một cánh đồng cỏ dùng chung một
 * đoạn code: thị trấn khai lòng đường + viền đá + vệ cỏ, cánh đồng khai cỏ +
 * mép cỏ + đất.
 */
const GROUND = {
  floor: ['grass_fill_a', 'grass_fill_b'],
  edge: ['grass_top_a', 'grass_top_b', 'grass_top_c'],
  below: ['dirt_a', 'dirt_b'],
};

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
  // Cảnh vật lớp giữa đứng ở MÉP SAU của dải đi được, không phải mép trước:
  // như vậy mọi vị trí người chơi đứng được đều ở phía trước nó, khỏi phải xen
  // nhân vật vào giữa dãy nhà theo độ sâu.
  mid:       { factor: 0.55, slot: 300, anchor: 'walkBack', baseY: 0, kinds: ['house', 'stall', 'tree_big', 'tree_small', 'haystack'], scale: [1.8, 2.6], skip: 0.2, haze: 0.1 },
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
  setMap(map) {
    this.map = map;
    // Nạp trước trang art chứa cảnh vật của map này. Không gọi thì sprite chỉ
    // hiện ra sau khi đã thử vẽ hụt một lần, tức là trễ mất một khung hình.
    atlas.ensureFor([
      ...(map?.scenery ? Object.values(map.scenery).flat() : []),
      // Trạm xe buýt nằm ở trang art khác cảnh vật của map, mà nó là lối RA
      // khỏi map: nạp hụt trang là người chơi đứng trước một khoảng trống.
      ...(map?.portals ?? []).map((portal) => portal.sprite).filter(Boolean),
    ]);
  }

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
   * Thu thêm một lần nữa cho vừa bức TRANH NỀN, nếu map có.
   *
   * `scale` ở trên quy khung nhìn theo chiều cao MAP; tranh nền lại cao hơn thế
   * (768 so với 720), nên vẫn cụt mất trời hoặc mất lòng đường. `zoom` thu nốt
   * phần chênh, và thu cả cảnh chứ không riêng bức tranh — nhà, người, vật đều
   * phải nhỏ theo, không thì người to bằng cả toà nhà.
   */
  zoom = 1;

  /**
   * Nhân vật đứng ở khoảng 76% chiều cao khung nhìn — tức camera đặt cao hơn và
   * chúc xuống. Để thấp hơn (66% như trước) thì gần một phần ba màn hình phía
   * dưới chỉ còn nền đất trống, trong khi nhà cửa và cây phía trên bị cắt ngọn.
   */
  get anchorY() { return this.viewHeight * 0.76; }

  /** Bề rộng khung nhìn quy về TOẠ ĐỘ THẾ GIỚI — thu nhỏ thì nhìn được rộng hơn. */
  get worldWidth() { return this.viewWidth / this.zoom; }

  followCamera(map, target) {
    const halfW = this.viewWidth / 2;
    this.camera.x = map.width < this.viewWidth ? map.width / 2 : Math.max(halfW, Math.min(map.width - halfW, target.x));

    // Camera dọc neo vào MÉP TRƯỚC của dải đất, KHÔNG bám người chơi.
    //
    // Trục dọc giờ là chiều sâu chứ không phải độ cao: bám theo thì đi lùi vào
    // trong làm cả thế giới trôi xuống và nhân vật lơ lửng giữa trời. Neo cố
    // định thì dải đất đứng yên, người chơi đi lùi chỉ nhỏ lại và lùi lên trong
    // khung — đúng cảm giác đi sâu vào trong.
    //
    // Map có tranh nền thì neo vào MÉP TRÊN CỦA TRANH, và thu cả cảnh lại vừa
    // đúng chiều cao khung nhìn. Bức tranh vẽ trọn một cảnh từ trời xuống tận
    // lòng đường, nên phải thấy hết: neo vào mép trước như map thường thì lòng
    // đường tụt xuống dưới thanh chat.
    const spec = map.backdrop;
    if (spec) {
      const height = spec.height ?? 768;
      this.zoom = Math.min(1, this.viewHeight / height);
      this.camera.y = map.ground_y - spec.ground + this.anchorY / this.zoom;
      return;
    }
    this.zoom = 1;
    this.camera.y = Math.max(this.anchorY - 40, map.ground_y);
  }

  render(map, { players, self, farm, hintTarget, guide, time }) {
    const ctx = this.ctx;
    const scale = this.scale;
    ctx.setTransform(this.dpr * scale, 0, 0, this.dpr * scale, 0, 0);
    ctx.clearRect(0, 0, this.viewWidth, this.viewHeight);

    this.#drawSky(map);

    ctx.save();
    // Thu/phóng quanh điểm neo, rồi mới dịch về camera: như vậy mọi thứ vẽ sau
    // đây — tranh nền, nhà, người — cùng thu một tỉ lệ, không ai lệch ai.
    ctx.translate(this.viewWidth / 2, this.anchorY);
    ctx.scale(this.zoom, this.zoom);
    ctx.translate(-this.camera.x, -this.camera.y);

    // Map có tranh nền vẽ liền thì bức tranh lo hết: trời, đồi, hàng cây, mặt
    // đất. Không có thì dựng bằng code như cũ.
    const backdrop = this.#drawBackdrop(map);
    if (!backdrop) {
      this.#drawBackground(map, time);
      this.#drawGround(map);
    }
    // Nhà cửa dựng trên mép sau của sàn, nên vẽ sau sàn — vẽ trước thì sàn phủ
    // lên và cắt cụt chân nhà.
    // Lớp cảnh rải theo lưới băm chỉ dùng cho map dựng bằng code. Map có tranh
    // nền thì cây cối, hàng rào, bồn hoa đã nằm trong tranh — rải thêm một lớp
    // nữa lên trên là hai bộ cảnh chồng nhau.
    if (backdrop) this.#drawBackdropSlots(map);
    else this.#drawLayer(map, 'mid', time);
    if (farm) this.#drawFarm(map, farm, time);
    this.#drawObjects(map, hintTarget);
    this.#drawPortals(map, hintTarget);
    this.#drawNpcs(map, hintTarget, time);

    // Xếp theo y: ai đứng gần mép trước thì vẽ sau, che người phía sau.
    const everyone = [...players, self].sort((a, b) => a.y - b.y);
    for (const player of everyone) {
      this.#groundShadow(player.x, player.y, AVATAR_FOOT * depthScale(map, player.y), CHARACTER_SHADOW);
      ctx.save();
      ctx.translate(player.x, player.y);
      drawAvatar(ctx, this.content, {
        scale: depthScale(map, player.y),
        equipment: player.equipment,
        bodyType: player.bodyType,
        appearance: player.appearance,
        facing: player.facing,
        state: player.state,
        phase: player.phase ?? 0,
        // Ẩn tên người khác giúp màn hình đỡ rối ở khu đông người.
        nickname: player === self || settings.value.graphics.otherNames ? player.nickname : null,
        emote: player.emote,
      });
      ctx.restore();
    }

    // Phản hồi vẽ SAU người và vật nhưng TRƯỚC lớp tiền cảnh: số phải nổi lên
    // trên nhân vật mới đọc được, nhưng vẫn phải bị bụi cây tiền cảnh che như
    // mọi thứ khác, không thì nó nổi lềnh bềnh ngoài thế giới.
    fx.draw(ctx, time);

    if (!backdrop) {
      this.#drawForeground(map);
      // Lớp tiền cảnh lướt qua sát camera, vẽ sau cùng và không hề chặn thao tác.
      this.#drawLayer(map, 'fore', time);
    }
    ctx.restore();

    this.#drawGuide(map, guide, time);
    this.#drawWorldMood(time);
  }

  /**
   * Mũi tên chỉ nơi cần tới cho nhiệm vụ đang làm.
   *
   * Bảng nhiệm vụ nói "nói chuyện với bác Tư" — người mới không biết bác Tư đứng
   * map nào, mà map nào cũng phải bắt xe buýt mới sang được. Thiếu mũi tên thì
   * bước đầu tiên của game đã là một câu đố về địa lý.
   *
   * Server đã giải sẵn thành chỗ phải đi NGAY TRÊN MAP ĐANG ĐỨNG (xem
   * `domain/guide.js`): cùng map thì là chính mục tiêu, khác map thì là cái trạm
   * xe buýt bắt đầu đường đi. Ở đây chỉ còn việc vẽ.
   *
   * Vẽ ở toạ độ MÀN HÌNH, không phải toạ độ thế giới: khi đích nằm ngoài khung
   * nhìn thì mũi tên phải nằm ở MÉP MÀN HÌNH mà chỉ ra ngoài — mốc ấy là mốc
   * màn hình, không có nghĩa gì trong thế giới.
   */
  #drawGuide(map, guide, time) {
    const x = guide?.step?.x;
    if (x == null) return;                       // "cứ ở map này là được": không có gì để chỉ
    const ctx = this.ctx;
    const screenX = this.viewWidth / 2 + (x - this.camera.x) * this.zoom;
    const bob = Math.sin(time * 3.4) * 5;
    const margin = 34;
    const offLeft = screenX < margin;
    const offRight = screenX > this.viewWidth - margin;
    const px = offLeft ? margin : offRight ? this.viewWidth - margin : screenX;
    // Đích trong khung thì mũi tên treo trên đầu nó và chúc xuống; ngoài khung
    // thì nằm ở mép và chỉ ngang ra phía phải đi.
    const py = offLeft || offRight ? this.anchorY - 40 : this.anchorY - 150 + bob;
    const angle = offLeft ? Math.PI / 2 : offRight ? -Math.PI / 2 : 0;

    ctx.save();
    ctx.translate(px, py + (offLeft || offRight ? bob : 0));
    ctx.rotate(angle);
    ctx.beginPath();
    ctx.moveTo(0, 14);
    ctx.lineTo(-11, -8);
    ctx.lineTo(11, -8);
    ctx.closePath();
    ctx.fillStyle = '#f2c94c';
    ctx.strokeStyle = 'rgba(30,24,10,.85)';
    ctx.lineWidth = 2.5;
    ctx.fill();
    ctx.stroke();
    ctx.restore();

    // Ngoài khung thì kèm chữ: mũi tên trơ ở mép không nói được là đi tới đâu.
    if (!offLeft && !offRight) return;
    const label = guide.step.portal_id ? t(guide.target.name_key) : t(guide.target.label_key ?? guide.target.name_key);
    ctx.save();
    ctx.font = '700 12px system-ui, sans-serif';
    ctx.textAlign = offLeft ? 'left' : 'right';
    ctx.fillStyle = 'rgba(20,16,8,.72)';
    const width = ctx.measureText(label).width + 14;
    const bx = offLeft ? margin - 12 : this.viewWidth - margin - width + 12;
    roundRect(ctx, bx, py + 18, width, 20, 7);
    ctx.fillStyle = '#ffe9a8';
    ctx.fillText(label, offLeft ? bx + 7 : bx + width - 7, py + 32);
    ctx.restore();
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
   * TRANH NỀN vẽ liền, lát ngang suốt bề rộng map.
   *
   * Map dựng theo lối này thì trời, hàng cây, quảng trường, vỉa hè, lòng đường
   * đã nằm sẵn trong MỘT bức vẽ, đúng tỉ lệ với nhau — khỏi phải ghép từng dải
   * rồi ướm cho khớp. Bù lại nó chỉ lát được theo chiều ngang, nên bức vẽ phải
   * nối liền được hai mép.
   *
   * `ground` là dòng nào trong tranh ứng với `ground_y` của map — mốc duy nhất
   * cần khai, vì mọi thứ khác trong tranh đã đúng chỗ so với dòng ấy rồi.
   *
   * @returns true nếu đã vẽ; false thì chỗ gọi vẽ nền sinh bằng code như cũ.
   */
  #drawBackdrop(map) {
    const spec = map.backdrop;
    if (!spec) return false;
    const part = atlas.part(spec.sprite);
    if (!part) return false;
    const ctx = this.ctx;
    const { rect, img } = part;
    const top = map.ground_y - spec.ground;
    const viewLeft = this.camera.x - this.worldWidth / 2;
    const viewTop = this.camera.y - this.anchorY;
    const from = Math.floor((viewLeft - this.worldWidth) / rect.w) * rect.w;
    const to = viewLeft + this.worldWidth + rect.w;

    // Trên và dưới bức vẽ: kéo dài bằng chính màu của hàng pixel đầu và cuối.
    // Khung nhìn cao hơn bức vẽ là chuyện thường (bức 768, màn 900), mà để hở
    // là lộ ra một vạch nền trắng ngay trên nóc trời.
    ctx.fillStyle = spec.above ?? map.theme.sky[0];
    ctx.fillRect(viewLeft - 40, viewTop - 40, this.worldWidth + 80, top - viewTop + 41);
    ctx.fillStyle = spec.below ?? map.theme.ground;
    ctx.fillRect(viewLeft - 40, top + rect.h - 1, this.worldWidth + 80, this.viewHeight + 80);

    for (let x = from; x < to; x += rect.w) {
      ctx.drawImage(img, rect.x, rect.y, rect.w, rect.h, x, top, rect.w + 1, rect.h);
    }
    return true;
  }

  /**
   * Nhà đặt vào Ô CHỪA SẴN của tranh nền.
   *
   * Bức tranh có mấy khung nét đứt trắng — bộ art chừa chỗ để nhét công trình
   * vào. Không nhét thì mấy cái khung ấy phơi ra giữa map. Nên chỗ đặt nhà là
   * mốc ĐỌC TỪ TRANH (`slots`, toạ độ trong tranh), không phải rải theo lưới
   * băm như mấy lớp cảnh sinh bằng code — rải lưới thì nhà rơi lệch khỏi khung.
   *
   * Tranh lát ngang bao nhiêu lần thì ô cũng lặp bấy nhiêu, nhưng CHỌN nhà theo
   * số thứ tự ô trên cả map, nên đi hết phố không thấy ba cái nhà lặp lại.
   */
  #drawBackdropSlots(map) {
    const spec = map.backdrop;
    if (!spec?.slots?.length || !atlas.ready) return;
    const part = atlas.part(spec.sprite);
    if (!part) return;
    const ctx = this.ctx;
    const span = part.rect.w;
    const top = map.ground_y - spec.ground;
    // Ô chừa sẵn chỉ hợp với CÔNG TRÌNH. Lớp `mid` trộn cả bồn hoa, cột đèn,
    // đài phun — nhét một cái bồn hoa phóng to bằng cả toà nhà vào ô là lộ ngay.
    const kinds = map.scenery?.slots ?? this.#kindsFor(map, 'mid');
    const viewLeft = this.camera.x - this.worldWidth / 2;
    const from = Math.floor((viewLeft - span) / span);
    const to = Math.ceil((viewLeft + this.worldWidth) / span);

    for (let tile = from; tile <= to; tile++) {
      spec.slots.forEach((slot, i) => {
        const id = tile * spec.slots.length + i;
        const pick = Math.abs(hashString(`${map.map_id}|slot|${id}`));
        const kind = kinds[pick % kinds.length];
        const rect = atlas.meta?.sprites?.index?.[kind];
        if (!rect) return;
        // Quy cỡ theo BỀ NGANG ô: ô chừa sẵn rộng bao nhiêu thì nhà rộng bấy
        // nhiêu, cao thấp mặc nó. Quy theo chiều cao thì nhà thấp để hở hai bên
        // khung, nhà cao thì trùm ra ngoài.
        const scale = (slot.w / rect.w) * (rect.h / 64);
        atlas.prop(ctx, kind, tile * span + slot.x + slot.w / 2, top + slot.y, scale);
      });
    }
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
        : spec.anchor === 'walkBack'
          ? map.ground_y - (map.walk_depth ?? 0)
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
    // Lớp giữa KHÔNG vẽ ở đây: nó đứng ở mép sau của dải đi được, tức là đứng
    // TRÊN mặt sàn, nên phải vẽ sau mặt sàn. Xem render().
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

    // Mặt sàn phải phủ HẾT dải đi được, không chỉ một vạch ở ground_y: dải sâu
    // 150px mà chỉ vẽ cỏ ở mép trước thì người chơi đi lùi vào trong sẽ đứng
    // lửng lơ trên nền trời.
    const walk = map.walk_depth ?? 0;
    const top = map.ground_y - walk;

    if (!atlas.ready) {
      ctx.fillStyle = map.theme.ground;
      ctx.fillRect(-200, top, map.width + 400, depth + walk);
      return;
    }

    // Lát tile theo lưới: một hàng tile "mặt cỏ" ở trên, còn lại là đất. Chỉ vẽ
    // phần lọt vào khung nhìn — map rộng 2600px mà lát hết thì mỗi khung tốn
    // hàng nghìn lệnh drawImage vô ích.
    // camera.x/y là TÂM khung nhìn (xem followCamera), không phải mép trái/trên
    // — lấy nhầm là nửa màn hình bên trái không được lát tile nào.
    const scale = TILE_PX / atlas.meta.tiles.size;
    const size = TILE_PX;
    const viewLeft = this.camera.x - this.worldWidth / 2;
    const viewBottom = this.camera.y + (this.viewHeight - this.anchorY);
    const left = Math.floor((viewLeft - size) / size) * size;
    const right = viewLeft + this.viewWidth + size;
    // Số hàng phủ dải đi được, làm tròn LÊN để mép sau không hở một vệt.
    const floorRows = Math.ceil(walk / size);
    const rows = floorRows + Math.ceil(depth / size);
    const seed = hashString(map.map_id);
    const startY = map.ground_y - floorRows * size;
    // Tra tile theo TÊN một lần ở đây, không tra trong vòng lặp: mỗi khung lát
    // vài trăm ô, tra tên từng ô là quét lại mảng tên vài trăm lần.
    const recipe = { ...GROUND, ...(map.ground ?? {}) };
    const band = (names) => names.map((n) => atlas.tileIndex(n)).filter((i) => i >= 0);
    const floor = band(recipe.floor);
    const edge = band(recipe.edge);
    const below = band(recipe.below);
    if (!floor.length || !edge.length || !below.length) return;

    for (let x = left; x < right; x += size) {
      const col = Math.round(x / size);
      for (let row = 0; row < rows; row++) {
        const y = startY + row * size;
        if (y > viewBottom + size) break;
        const pick = Math.abs(hashString(`${seed}:${col}:${row}`));
        const set = row < floorRows ? floor : row === floorRows ? edge : below;
        const index = set[pick % set.length];
        // Vẽ TRÙM RA 1px: camera đứng ở toạ độ lẻ nên mỗi ô rơi vào nửa pixel,
        // vẽ đúng khít thì giữa hai ô hở một khe sáng thấy cả nền trời. Tile đã
        // khâu mép liền nên chồng nhau 1px không thấy gì.
        atlas.tile(ctx, index, x, y, scale, 1);
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
        const size = atlas.spriteSize(object.sprite, object.scale ?? 2);
        if (size) this.#groundShadow(object.x, object.y + 4, size.w * 1.14);
        // Vật đang trong tầm tương tác thì sáng lên, thay cho đổi màu tô.
        ctx.save();
        if (highlight) { ctx.shadowColor = 'rgba(255,232,150,.95)'; ctx.shadowBlur = 18; }
        atlas.prop(ctx, object.sprite, object.x, object.y + 4, object.scale ?? 2);
        ctx.restore();
        continue;
      }
      // Không có hình lui bằng khối màu nữa. Mọi vật trong map đều có art thật,
      // và bài test chặn ngay nếu ai khai một tên sprite không có trong atlas —
      // vẽ một cái hộp bo góc thay thế chỉ khiến lỗi ấy lọt ra tới người chơi.
    }
  }

  /**
   * Bóng đổ dưới chân vật đứng trên nền.
   *
   * Thiếu nó thì vật nào cũng như dán lên sàn — sprite sạch, màu đúng tông, mà
   * vẫn không đứng trong tranh. Mọi vật vẽ sẵn trong tranh nền đều có bóng.
   *
   * Hình dạng đo từ CÁI GHẾ và BỒN HOA trong tranh nền, vì chúng cũng là vật
   * đứng chân trên nền lát như trạm xe buýt: bóng rộng hơn vật chừng 1.2 lần,
   * nông (sâu bằng ~5% bề rộng), làm nền tối còn khoảng 0.6, lõi tối khá đều rồi
   * mới tắt nhanh ở rìa.
   *
   * KHÔNG lấy bóng CÂY làm mẫu dù cây cũng có bóng: tán cây ở trên cao nên bóng
   * nó loang rộng 50px mà chỉ tối còn 0.84 — mượn số ấy cho trạm là ra một vệt
   * mờ chứ không ra chỗ chân chạm đất.
   *
   * Vẽ bằng phép NHÂN lên chính mặt nền chứ không tô một vệt xám đè lên: tô đè
   * thì bóng mang màu mình tự đặt, trên nền lát xám thì tạm được, sang map nền
   * cỏ là lộ ngay. Nhân thì nền nào cũng tối đi đúng chừng ấy phần.
   */
  #groundShadow(x, groundY, width, { tone = 0.4, soft = 3, flat = 0.05 } = {}) {
    const ctx = this.ctx;
    const rx = width / 2;
    // `flat` là tỉ lệ sâu/rộng. Vật bè ra như trạm xe buýt thì bóng gần như một
    // vệt (0.05); người đứng thẳng chân chụm thì bóng gần tròn (0.3).
    const depth = width * flat;
    ctx.save();
    ctx.globalCompositeOperation = 'multiply';
    // Tâm bóng nằm DƯỚI chỗ chân chạm, không phải trùng. Bóng ghế trong tranh
    // nền trải trọn từ chỗ chân chạm xuống dưới, không có tí nào ở phía trên.
    // Đặt trùng chân thì nửa bóng chui vào trong trạm — mà trạm nay đã nhìn
    // xuyên được, nên nó hiện ra thành vệt tối lơ lửng sau tấm kính.
    ctx.translate(x, groundY + depth * 0.5);
    ctx.scale(1, depth / rx);
    const fade = ctx.createRadialGradient(0, 0, 0, 0, 0, rx);
    for (const d of [0, 0.25, 0.5, 0.7, 0.85, 1]) {
      const k = 1 - (1 - tone) * (1 - d ** soft);
      const v = Math.round(k * 255);
      fade.addColorStop(d, `rgb(${v},${v},${v})`);
    }
    ctx.fillStyle = fade;
    ctx.beginPath();
    ctx.arc(0, 0, rx, 0, Math.PI * 2);
    ctx.fill();
    ctx.restore();
  }

  /**
   * Chỗ sang map khác là một TRẠM XE BUÝT, không phải vệt sáng vô hình.
   *
   * Trước đây chỗ này vẽ một viên thuốc bán trong xanh lơ: người chơi không đoán
   * ra đấy là gì, mà nó cũng chẳng ăn nhập với tranh nền vẽ tay. Trạm xe buýt
   * thì tự nó nói ra công dụng — thấy mái trạm là biết đứng vào đấy để đi nơi
   * khác, khỏi cần chú thích.
   *
   * `portal.sprite` khai trong data map để mỗi cửa ngõ sau này thay art riêng
   * được (bến đò trong rừng chẳng hạn); chưa có art thì lui về viên thuốc cũ
   * chứ không bỏ trống, vì mất dấu là mất luôn đường ra khỏi map.
   */
  #drawPortals(map, hintTarget) {
    const ctx = this.ctx;
    for (const portal of map.portals) {
      const highlight = hintTarget?.id === portal.portal_id;
      const size = portal.sprite && atlas.ready ? atlas.spriteSize(portal.sprite, portal.scale ?? 2) : null;
      if (size) this.#groundShadow(portal.x, portal.y, size.w * 1.14);
      const drawn = size && (() => {
        ctx.save();
        if (highlight) { ctx.shadowColor = 'rgba(255,232,150,.95)'; ctx.shadowBlur = 18; }
        const ok = atlas.sprite(ctx, portal.sprite, portal.x, portal.y, portal.scale ?? 2);
        ctx.restore();
        return ok;
      })();

      // Nhãn treo trên NÓC TRẠM, không phải trên khung tương tác: mái trạm cao
      // hơn khung nên tính theo khung là chữ nằm đè lên mái.
      const top = drawn ? (portal.scale ?? 2) * 64 : portal.h;   // art chưa tải xong thì treo nhãn theo khung
      ctx.font = '600 12px system-ui, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillStyle = '#0e1a15';
      ctx.fillText(t(portal.label_key), portal.x, portal.y - top - 8);
    }
  }

  #drawNpcs(map, hintTarget, time) {
    const ctx = this.ctx;
    for (const npc of map.npcs) {
      this.#groundShadow(npc.x, npc.y, AVATAR_FOOT * depthScale(map, npc.y), CHARACTER_SHADOW);
      ctx.save();
      ctx.translate(npc.x, npc.y);
      // NPC không có tủ đồ: sprite khai thẳng trong data map. `palette` giữ lại
      // cho đường lui vẽ bằng hình khối khi art chưa tải xong.
      drawAvatar(ctx, this.content, {
        scale: depthScale(map, npc.y),
        sprite: npc.sprite,
        equipment: {},
        palette: { body: npc.palette[0], top: npc.palette[1], hair: npc.palette[2] },
        facing: -1,
        state: 'idle',
        // Mỗi NPC lệch pha thở một chút, không thì cả map phập phồng cùng nhịp.
        phase: (time * 0.35 + npc.x * 0.01) % 1,
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
    const x = ((clientX - rect.left) / scale - this.viewWidth / 2) / this.zoom + this.camera.x;
    const y = ((clientY - rect.top) / scale - this.anchorY) / this.zoom + this.camera.y;
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
/**
 * Thu nhỏ theo chiều sâu: đứng càng lùi vào trong thì càng nhỏ.
 *
 * Không có nó thì đi lùi vào trong nhìn như trượt ngang trên kính — mắt không
 * đọc ra chiều sâu, chỉ thấy nhân vật đổi chỗ. 12% là đủ để cảm được mà không
 * làm nhân vật ở mép sau bé như đồ chơi.
 */
export function depthScale(map, y) {
  const depth = map.walk_depth ?? 0;
  if (!depth) return 1;
  const back = (map.ground_y - y) / depth;
  return 1 - Math.max(0, Math.min(1, back)) * 0.12;
}

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
