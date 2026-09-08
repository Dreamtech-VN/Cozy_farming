/**
 * Nạp tileset và sprite sheet sinh bởi tools/gen-art.mjs.
 *
 * Vẽ sprite pixel lên canvas phải TẮT khử răng cưa, không thì mỗi ô bị nội suy
 * mờ và lem cả pixel của ô bên cạnh trong sheet.
 */
const BASE = '/assets/world';

// Art vẽ sẵn mỗi vật một cỡ. Quy hết về chiều cao chuẩn này rồi mới nhân tỉ lệ
// của lớp, nên `scale: 2` nghĩa như nhau dù là cái ghế hay toà nhà — nếu lấy
// thẳng pixel gốc thì toà nhà 232px và cái nón 40px lệch nhau gần 6 lần.
const SPRITE_UNIT = 64;

class Atlas {
  constructor() {
    this.ready = false;
    this.images = {};
  }

  async load() {
    const meta = await fetch(`${BASE}/atlas.json`).then((r) => r.json());
    this.meta = meta;
    const load = (file) => new Promise((resolve, reject) => {
      const img = new Image();
      img.onload = () => resolve(img);
      img.onerror = () => reject(new Error(`không nạp được ${file}`));
      img.src = `${BASE}/${file}`;
    });
    // Art sinh bằng code chỉ vài chục KB, chờ được. Trang art vẽ sẵn thì nặng
    // vài MB — chờ nó xong mới cho vào game là bắt người chơi nhìn màn hình
    // trắng. Nạp nền, và vì `prop()` đã tự rơi về art sinh bằng code khi chưa
    // có sprite nên thế giới vẽ được ngay rồi tự đẹp lên khi trang tới nơi.
    const [tiles, props, crops, parts] = await Promise.all([
      load(meta.tiles.file), load(meta.props.file), load(meta.crops.file), load(meta.parts.file),
    ]);
    this.images = { tiles, props, crops, parts };
    this.load = load;
    this.partIndex = new Map(meta.parts.names.map((name, i) => [name, i]));
    this.propIndex = new Map(meta.props.names.map((name, i) => [name, i]));
    this.cropIndex = new Map(meta.crops.kinds.map((name, i) => [name, i]));
    this.ready = true;

    // Trang art vẽ sẵn nạp riêng, theo nhu cầu — xem loadPage().
    this.ensurePage('outdoor');
  }

  /**
   * Nạp một trang art vẽ sẵn, nhớ lại lời hứa để gọi nhiều lần không tải lại.
   *
   * Trang ngoài trời 7 MB, trang nội thất 15 MB. Nạp hết ngay từ đầu là bắt
   * người chơi tải 22 MB trước khi vào được game, mà phần lớn không dùng tới:
   * đang đứng ngoài phố thì không cần cái tủ lạnh.
   */
  ensurePage(page) {
    const file = this.meta?.sprites?.pages?.[page];
    if (!file) return Promise.resolve(null);
    let pending = this.#pages.get(page);
    if (pending) return pending;
    pending = this.load(file)
      .then((img) => { this.#pageImages.set(page, img); return img; })
      .catch((error) => {
        // Thiếu art vẽ sẵn thì rơi về art sinh bằng code chứ không làm vỡ cảnh.
        console.warn(`không nạp được trang art "${page}":`, error.message);
        this.#pages.delete(page);
        return null;
      });
    this.#pages.set(page, pending);
    return pending;
  }

  /** Nạp trước mọi trang chứa các sprite sắp vẽ. */
  ensureFor(names) {
    const index = this.meta?.sprites?.index;
    if (!index) return;
    const need = new Set();
    for (const name of names) {
      const entry = index[name];
      if (entry) need.add(entry.page);
    }
    for (const page of need) this.ensurePage(page);
  }

  #pages = new Map();
  #pageImages = new Map();

  /** Một ô tileset, vẽ phóng to `scale` lần tại (x, y). */
  tile(ctx, index, x, y, scale) {
    const size = this.meta.tiles.size;
    ctx.drawImage(this.images.tiles, index * size, 0, size, size, x, y, size * scale, size * scale);
  }

  /**
   * Prop neo ở ĐÁY GIỮA: mọi thứ trong side-view đều đứng trên mặt đất.
   *
   * Ưu tiên art VẼ SẴN nếu có tên đó, không thì rơi về art sinh bằng code. Nhờ
   * vậy thay art là việc thêm tên vào bản kê, không phải sửa chỗ gọi.
   */
  prop(ctx, name, x, groundY, scale = 1) {
    if (this.sprite(ctx, name, x, groundY, scale)) return;
    const index = this.propIndex.get(name);
    if (index === undefined) return;
    const { cell, cols } = this.meta.props;
    const sx = (index % cols) * cell;
    const sy = Math.floor(index / cols) * cell;
    const size = cell * scale;
    ctx.drawImage(this.images.props, sx, sy, cell, cell, x - size / 2, groundY - size, size, size);
  }

  /**
   * Vẽ một sprite art vẽ sẵn. Mỗi sprite có kích thước riêng nên tỉ lệ tính
   * theo CHIỀU CAO chuẩn, không theo ô: art vẽ sẵn không nằm trong lưới đều.
   * @returns true nếu vẽ được, false nếu không có tên này.
   */
  sprite(ctx, name, x, groundY, scale = 1) {
    const rect = this.meta?.sprites?.index?.[name];
    if (!rect) return false;
    const img = this.#pageImages.get(rect.page);
    if (!img) { this.ensurePage(rect.page); return false; }
    const k = (scale * SPRITE_UNIT) / rect.h;
    const w = rect.w * k;
    const h = rect.h * k;
    ctx.drawImage(img, rect.x, rect.y, rect.w, rect.h, x - w / 2, groundY - h, w, h);
    return true;
  }

  hasSprite(name) {
    return Boolean(this.meta?.sprites?.index?.[name]);
  }

  spriteNames() {
    return Object.keys(this.meta?.sprites?.index ?? {});
  }

  crop(ctx, kind, stage, x, groundY, scale = 1) {
    const row = this.cropIndex.get(kind);
    if (row === undefined) return;
    const { cell, stages } = this.meta.crops;
    const col = Math.max(0, Math.min(stages - 1, stage));
    const size = cell * scale;
    ctx.drawImage(this.images.crops, col * cell, row * cell, cell, cell, x - size / 2, groundY - size, size, size);
  }

  /**
   * Một hàng sprite paperdoll, đã nhân màu.
   *
   * Sprite vẽ bằng thang xám nên NHÂN (multiply) với màu người chơi chọn giữ
   * nguyên khối sáng–tối; cách cũ là tô đè toàn bộ pixel không trong suốt, làm
   * bẹt món đồ thành một mảng màu phẳng.
   *
   * Cache theo (bộ phận, màu) chứ không theo từng khung: tô một lần cả dải 6
   * khung, lúc vẽ chỉ cắt ô — đỡ hẳn số lần dựng canvas phụ.
   */
  tintedPart(name, colour) {
    const row = this.partIndex.get(name);
    if (row === undefined) return null;
    const key = `${name}|${colour}`;
    const cached = this.#tintCache.get(key);
    if (cached) return cached;

    const { w, h, frames } = this.meta.parts;
    const strip = document.createElement('canvas');
    strip.width = w * frames;
    strip.height = h;
    const c = strip.getContext('2d');
    c.imageSmoothingEnabled = false;
    c.drawImage(this.images.parts, 0, row * h, strip.width, h, 0, 0, strip.width, h);
    c.globalCompositeOperation = 'multiply';
    c.fillStyle = colour;
    c.fillRect(0, 0, strip.width, h);
    // multiply cũng nhân cả vùng trong suốt thành màu đặc, nên phải cắt lại
    // theo đúng alpha của sprite gốc.
    c.globalCompositeOperation = 'destination-in';
    c.drawImage(this.images.parts, 0, row * h, strip.width, h, 0, 0, strip.width, h);

    this.#tintCache.set(key, strip);
    return strip;
  }

  #tintCache = new Map();

  /** Vẽ một bộ phận, neo ĐÁY GIỮA tại (x, groundY). */
  part(ctx, name, colour, frame, x, groundY, scale = 1) {
    const strip = this.tintedPart(name, colour);
    if (!strip) return;
    const { w, h, frames, ground } = this.meta.parts;
    const col = ((frame % frames) + frames) % frames;
    // Vạch đất nằm cao hơn đáy ô `ground` px, nên phải trừ đúng phần đó — lấy
    // đáy ô làm chân thì nhân vật lơ lửng.
    const top = groundY - (h - ground) * scale;
    ctx.drawImage(strip, col * w, 0, w, h, x - (w * scale) / 2, top, w * scale, h * scale);
  }

  partOrder(names) {
    const z = this.meta.parts.zOrder;
    return [...names].sort((a, b) => (z[a] ?? 0) - (z[b] ?? 0));
  }
}

export const atlas = new Atlas();
