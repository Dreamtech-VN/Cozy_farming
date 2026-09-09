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
    const [tiles, props, crops] = await Promise.all([
      load(meta.tiles.file), load(meta.props.file), load(meta.crops.file),
    ]);
    this.images = { tiles, props, crops };
    this.load = load;
    this.propIndex = new Map(meta.props.names.map((name, i) => [name, i]));
    this.cropIndex = new Map(meta.crops.kinds.map((name, i) => [name, i]));
    this.ready = true;

    // Trang nhân vật tải ngay: màn tạo tài khoản có ô xem trước nhân vật, mà
    // nó hiện ra TRƯỚC màn chờ tải. Không có trang này thì ô xem trước rơi về
    // hình khối dự phòng, người chơi chọn nhân vật mà không thấy mặt.
    this.ensurePage('chars');
  }

  /** Tổng số byte của mọi trang art, biết trước nên thanh tiến độ chạy đều. */
  get totalBytes() {
    return Object.values(this.meta?.sprites?.pages ?? {}).reduce((sum, p) => sum + (p.bytes ?? 0), 0);
  }

  /**
   * Tải TOÀN BỘ trang art, báo tiến độ theo số byte thật.
   *
   * Dùng fetch + đọc theo luồng chứ không phải `new Image()`: thẻ Image không
   * báo được đã tải bao nhiêu, nên chỉ làm được vòng xoay giả — người chơi
   * không biết còn phải chờ bao lâu, mà ở đây là hơn 20 MB.
   *
   * @param onProgress ({ loaded, total }) → gọi mỗi lần nhận thêm dữ liệu.
   */
  async preloadAll(onProgress) {
    const pages = Object.entries(this.meta?.sprites?.pages ?? {});
    if (!pages.length) return;
    const total = this.totalBytes;
    let loaded = 0;
    const report = () => onProgress?.({ loaded, total });
    report();

    await Promise.all(pages.map(async ([page, info]) => {
      if (this.#pageImages.has(page)) { loaded += info.bytes ?? 0; report(); return; }
      // Trang đã đang tải dở (trang nhân vật khởi động sớm cho ô xem trước ở màn
      // tạo tài khoản) thì CHỜ lượt tải đó, đừng tải lần nữa — tải hai lần là
      // mất thêm đúng bằng dung lượng trang.
      const inFlight = this.#pages.get(page);
      if (inFlight) {
        await inFlight;
        loaded += info.bytes ?? 0;
        report();
        return;
      }
      try {
        const res = await fetch(`${BASE}/${info.file}`);
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        const chunks = [];
        // Không có body đọc theo luồng thì vẫn tải được, chỉ là tiến độ nhảy
        // một phát ở cuối — vẫn hơn là hỏng.
        if (res.body?.getReader) {
          const reader = res.body.getReader();
          for (;;) {
            const { done, value } = await reader.read();
            if (done) break;
            chunks.push(value);
            loaded += value.length;
            report();
          }
        } else {
          chunks.push(new Uint8Array(await res.arrayBuffer()));
          loaded += info.bytes ?? 0;
          report();
        }
        const blob = new Blob(chunks, { type: 'image/png' });
        this.#pageImages.set(page, await blobToImage(blob));
        this.#pages.set(page, Promise.resolve(this.#pageImages.get(page)));
      } catch (error) {
        // Thiếu một trang thì cảnh về lại art sinh bằng code, không chặn vào game.
        console.warn(`không tải được trang art "${page}":`, error.message);
        loaded += info.bytes ?? 0;
        report();
      }
    }));
  }

  /**
   * Nạp một trang art vẽ sẵn, nhớ lại lời hứa để gọi nhiều lần không tải lại.
   *
   * Trang ngoài trời 7 MB, trang nội thất 15 MB. Nạp hết ngay từ đầu là bắt
   * người chơi tải 22 MB trước khi vào được game, mà phần lớn không dùng tới:
   * đang đứng ngoài phố thì không cần cái tủ lạnh.
   */
  ensurePage(page) {
    const info = this.meta?.sprites?.pages?.[page];
    if (!info) return Promise.resolve(null);
    let pending = this.#pages.get(page);
    if (pending) return pending;
    pending = this.load(info.file)
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

  /**
   * Một ô tileset, vẽ phóng to `scale` lần tại (x, y).
   *
   * `bleed` nới ô ra mấy pixel về phía dưới-phải để hai ô cạnh nhau chồng lên
   * nhau: camera đứng ở toạ độ lẻ nên mỗi ô rơi vào nửa pixel, vẽ đúng khít thì
   * giữa hai ô hở một khe sáng. Chỉ dùng được với tile đã khâu mép liền.
   */
  tile(ctx, index, x, y, scale, bleed = 0) {
    const size = this.meta.tiles.size;
    const out = size * scale + bleed;
    ctx.drawImage(this.images.tiles, index * size, 0, size, size, x, y, out, out);
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

  /**
   * Vẽ sprite nhân vật, neo ĐÁY GIỮA, cao đúng `height` px.
   *
   * Khác `sprite()` ở chỗ quy theo chiều cao truyền vào chứ không theo bội số
   * của một đơn vị chung: nhân vật phải cao đúng bằng nhau dù file gốc mỗi
   * người một cỡ (đứa bé 96px, ông già 130px).
   *
   * @param transform { bob, lean, squash } — biến hình cho hoạt ảnh, xem
   *   avatar.js. Art chỉ có MỘT khung đứng nên chuyển động phải nặn từ đây.
   */
  character(ctx, name, x, groundY, height, transform = null) {
    const rect = this.meta?.sprites?.index?.[name];
    if (!rect) return false;
    const img = this.#pageImages.get(rect.page);
    if (!img) { this.ensurePage(rect.page); return false; }
    const k = height / rect.h;
    const w = rect.w * k;
    const { bob = 0, lean = 0, squash = 1 } = transform ?? {};
    ctx.save();
    // Gốc biến hình đặt ở CHÂN: nhún người thì đầu hạ xuống còn chân đứng yên,
    // đặt gốc ở giữa thì chân lún vào đất.
    ctx.translate(x, groundY + bob);
    if (lean) ctx.rotate(lean);
    if (squash !== 1) ctx.scale(1 / squash, squash);
    ctx.drawImage(img, rect.x, rect.y, rect.w, rect.h, -w / 2, -height, w, height);
    ctx.restore();
    return true;
  }

  /**
   * Ô sprite kèm ẢNH TRANG chứa nó — cho chỗ cần tự vẽ lấy thay vì gọi `sprite`.
   *
   * Ghép nhân vật từ nhiều mảnh (thân, mặt, tóc) phải tự tính vị trí từng mảnh
   * theo mảnh khác, nên không dùng được các hàm vẽ sẵn ở trên: chúng đều neo
   * đáy giữa của riêng mảnh đó.
   *
   * @returns {{rect, img}|null} null khi chưa có art — trang được nạp ngầm.
   */
  part(name) {
    const rect = this.meta?.sprites?.index?.[name];
    if (!rect) return null;
    const img = this.#pageImages.get(rect.page);
    if (!img) { this.ensurePage(rect.page); return null; }
    return { rect, img };
  }

  /**
   * Lời hứa cho trang chứa sprite này, nếu nó CHƯA sẵn sàng; null nếu đã có.
   *
   * Dành cho chỗ vẽ đúng một lần (chân dung trên HUD): không có vòng lặp nào vẽ
   * lại hộ, nên phải tự đăng ký vẽ lại khi art tới nơi.
   */
  pendingFor(name) {
    const rect = this.meta?.sprites?.index?.[name];
    if (!rect || this.#pageImages.has(rect.page)) return null;
    return this.ensurePage(rect.page);
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

}

/**
 * Blob → ảnh vẽ được. `createImageBitmap` giải mã ngoài luồng chính nên không
 * làm khựng khung hình; trình duyệt nào không có thì quay về đường object URL.
 */
async function blobToImage(blob) {
  if (typeof createImageBitmap === 'function') {
    try { return await createImageBitmap(blob); } catch { /* rơi xuống dưới */ }
  }
  const url = URL.createObjectURL(blob);
  try {
    const img = new Image();
    await new Promise((resolve, reject) => {
      img.onload = resolve;
      img.onerror = () => reject(new Error('giải mã ảnh hỏng'));
      img.src = url;
    });
    return img;
  } finally {
    URL.revokeObjectURL(url);
  }
}

export const atlas = new Atlas();
