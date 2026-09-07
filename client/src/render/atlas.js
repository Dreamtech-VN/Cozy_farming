/**
 * Nạp tileset và sprite sheet sinh bởi tools/gen-art.mjs.
 *
 * Vẽ sprite pixel lên canvas phải TẮT khử răng cưa, không thì mỗi ô bị nội suy
 * mờ và lem cả pixel của ô bên cạnh trong sheet.
 */
const BASE = '/assets/world';

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
    const [tiles, props, crops] = await Promise.all([
      load(meta.tiles.file), load(meta.props.file), load(meta.crops.file),
    ]);
    this.images = { tiles, props, crops };
    this.propIndex = new Map(meta.props.names.map((name, i) => [name, i]));
    this.cropIndex = new Map(meta.crops.kinds.map((name, i) => [name, i]));
    this.ready = true;
  }

  /** Một ô tileset, vẽ phóng to `scale` lần tại (x, y). */
  tile(ctx, index, x, y, scale) {
    const size = this.meta.tiles.size;
    ctx.drawImage(this.images.tiles, index * size, 0, size, size, x, y, size * scale, size * scale);
  }

  /** Prop neo ở ĐÁY GIỮA: mọi thứ trong side-view đều đứng trên mặt đất. */
  prop(ctx, name, x, groundY, scale = 1) {
    const index = this.propIndex.get(name);
    if (index === undefined) return;
    const { cell, cols } = this.meta.props;
    const sx = (index % cols) * cell;
    const sy = Math.floor(index / cols) * cell;
    const size = cell * scale;
    ctx.drawImage(this.images.props, sx, sy, cell, cell, x - size / 2, groundY - size, size, size);
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

export const atlas = new Atlas();
