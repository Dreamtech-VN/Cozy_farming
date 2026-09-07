/**
 * Bộ mã hoá PNG tối giản và một canvas pixel nhỏ.
 *
 * Dự án không có dependency (doc 21) nên không dùng thư viện ảnh: PNG chỉ gồm
 * chữ ký + IHDR + IDAT (zlib của các dòng quét đã lọc) + IEND, mà zlib thì Node
 * có sẵn.
 */
import { deflateSync } from 'node:zlib';

const CRC_TABLE = (() => {
  const table = new Int32Array(256);
  for (let n = 0; n < 256; n++) {
    let c = n;
    for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
    table[n] = c;
  }
  return table;
})();

const crc32 = (buf) => {
  let c = 0xffffffff;
  for (const byte of buf) c = CRC_TABLE[(c ^ byte) & 0xff] ^ (c >>> 8);
  return (c ^ 0xffffffff) >>> 0;
};

const chunk = (type, data) => {
  const head = Buffer.alloc(8);
  head.writeUInt32BE(data.length, 0);
  head.write(type, 4, 'ascii');
  const crc = Buffer.alloc(4);
  crc.writeUInt32BE(crc32(Buffer.concat([Buffer.from(type, 'ascii'), data])), 0);
  return Buffer.concat([head, data, crc]);
};

/** Canvas RGBA thao tác thẳng trên từng pixel. */
export class Pixels {
  constructor(width, height) {
    this.width = width;
    this.height = height;
    this.data = new Uint8Array(width * height * 4);
  }

  set(x, y, rgba) {
    x |= 0; y |= 0;
    if (!rgba || x < 0 || y < 0 || x >= this.width || y >= this.height) return;
    const [r, g, b, a = 255] = rgba;
    const i = (y * this.width + x) * 4;
    if (a === 255) { this.data[i] = r; this.data[i + 1] = g; this.data[i + 2] = b; this.data[i + 3] = 255; return; }
    // Trộn alpha để nét mềm ở rìa lá cây không đè phẳng lên nền.
    const src = a / 255;
    const dst = this.data[i + 3] / 255;
    const out = src + dst * (1 - src);
    if (out === 0) return;
    this.data[i] = (r * src + this.data[i] * dst * (1 - src)) / out;
    this.data[i + 1] = (g * src + this.data[i + 1] * dst * (1 - src)) / out;
    this.data[i + 2] = (b * src + this.data[i + 2] * dst * (1 - src)) / out;
    this.data[i + 3] = out * 255;
  }

  rect(x, y, w, h, rgba) {
    for (let dy = 0; dy < h; dy++) for (let dx = 0; dx < w; dx++) this.set(x + dx, y + dy, rgba);
  }

  /** Hình tròn/elip đặc, dùng cho tán lá và đá. */
  ellipse(cx, cy, rx, ry, rgba) {
    for (let y = Math.floor(cy - ry); y <= Math.ceil(cy + ry); y++) {
      for (let x = Math.floor(cx - rx); x <= Math.ceil(cx + rx); x++) {
        const nx = (x + 0.5 - cx) / rx;
        const ny = (y + 0.5 - cy) / ry;
        if (nx * nx + ny * ny <= 1) this.set(x, y, rgba);
      }
    }
  }

  /** Vẽ theo một bản đồ ký tự — dễ đọc và sửa hơn hàng loạt lệnh toạ độ. */
  stamp(x, y, rows, palette) {
    rows.forEach((row, dy) => {
      [...row].forEach((ch, dx) => {
        const rgba = palette[ch];
        if (rgba) this.set(x + dx, y + dy, rgba);
      });
    });
  }

  toPng() {
    const raw = Buffer.alloc(this.height * (this.width * 4 + 1));
    for (let y = 0; y < this.height; y++) {
      const rowStart = y * (this.width * 4 + 1);
      raw[rowStart] = 0; // filter type 0 (None)
      Buffer.from(this.data.buffer, y * this.width * 4, this.width * 4).copy(raw, rowStart + 1);
    }
    const ihdr = Buffer.alloc(13);
    ihdr.writeUInt32BE(this.width, 0);
    ihdr.writeUInt32BE(this.height, 4);
    ihdr[8] = 8;   // bit depth
    ihdr[9] = 6;   // colour type: RGBA
    return Buffer.concat([
      Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
      chunk('IHDR', ihdr),
      chunk('IDAT', deflateSync(raw, { level: 9 })),
      chunk('IEND', Buffer.alloc(0)),
    ]);
  }
}
