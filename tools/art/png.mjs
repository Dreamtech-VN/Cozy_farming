/**
 * Bộ mã hoá PNG tối giản và một canvas pixel nhỏ.
 *
 * Dự án không có dependency (doc 21) nên không dùng thư viện ảnh: PNG chỉ gồm
 * chữ ký + IHDR + IDAT (zlib của các dòng quét đã lọc) + IEND, mà zlib thì Node
 * có sẵn.
 */
import { deflateSync, inflateSync } from 'node:zlib';

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
    const stride = this.width * 4;
    const raw = Buffer.alloc(this.height * (stride + 1));
    const lines = [Buffer.alloc(stride), Buffer.alloc(stride), Buffer.alloc(stride), Buffer.alloc(stride), Buffer.alloc(stride)];
    let prev = Buffer.alloc(stride);

    for (let y = 0; y < this.height; y++) {
      const cur = Buffer.from(this.data.buffer, y * stride, stride);
      // Chọn bộ lọc theo từng dòng. Trước đây luôn dùng filter 0 (None), tức là
      // ghi thẳng giá trị pixel — với art chuyển màu mềm thì mỗi pixel một trị
      // khác nhau, deflate gần như không nén được gì. Bộ lọc lấy hiệu so với
      // pixel bên trái/bên trên biến vùng chuyển màu thành một dãy số gần 0.
      let best = 0;
      let bestScore = Infinity;
      for (let f = 0; f < 5; f++) {
        const out = lines[f];
        let score = 0;
        for (let x = 0; x < stride; x++) {
          const a = x >= 4 ? cur[x - 4] : 0;
          const b = prev[x];
          const c = x >= 4 ? prev[x - 4] : 0;
          let v;
          if (f === 0) v = cur[x];
          else if (f === 1) v = cur[x] - a;
          else if (f === 2) v = cur[x] - b;
          else if (f === 3) v = cur[x] - ((a + b) >> 1);
          else {
            const p = a + b - c;
            const pa = Math.abs(p - a); const pb = Math.abs(p - b); const pc = Math.abs(p - c);
            v = cur[x] - (pa <= pb && pa <= pc ? a : pb <= pc ? b : c);
          }
          out[x] = v & 0xff;
          // Tổng độ lớn tuyệt đối — cách ước lượng chuẩn trong đặc tả PNG,
          // xấp xỉ tốt cho "dòng này deflate sẽ nén được tới đâu".
          score += out[x] < 128 ? out[x] : 256 - out[x];
        }
        if (score < bestScore) { bestScore = score; best = f; }
      }
      const rowStart = y * (stride + 1);
      raw[rowStart] = best;
      lines[best].copy(raw, rowStart + 1);
      prev = cur;
    }

    const ihdr = Buffer.alloc(13);
    ihdr.writeUInt32BE(this.width, 0);
    ihdr.writeUInt32BE(this.height, 4);
    ihdr[8] = 8; ihdr[9] = 6; ihdr[10] = 0; ihdr[11] = 0; ihdr[12] = 0;
    return Buffer.concat([
      Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
      chunk('IHDR', ihdr),
      chunk('IDAT', deflateSync(raw, { level: 9 })),
      chunk('IEND', Buffer.alloc(0)),
    ]);
  }
}

/**
 * Đọc PNG về mảng RGBA.
 *
 * Chỉ cần cho khâu nhập art: ảnh sinh bằng model luôn là 8 bit, không xen kẽ.
 * Không xử lý bitDepth 16 và interlace Adam7 — gặp thì báo lỗi rõ ràng thay vì
 * trả về ảnh sai lặng lẽ.
 */
export function readPng(buffer) {
  if (buffer.readUInt32BE(0) !== 0x89504e47) throw new Error('không phải file PNG');
  let i = 8;
  let width = 0; let height = 0; let depth = 0; let colorType = 0; let interlace = 0;
  let palette = null; let transparency = null;
  const idat = [];
  while (i < buffer.length) {
    const length = buffer.readUInt32BE(i);
    const type = buffer.toString('ascii', i + 4, i + 8);
    const data = buffer.subarray(i + 8, i + 8 + length);
    if (type === 'IHDR') {
      width = data.readUInt32BE(0);
      height = data.readUInt32BE(4);
      depth = data[8]; colorType = data[9]; interlace = data[12];
    } else if (type === 'PLTE') palette = data;
    else if (type === 'tRNS') transparency = data;
    else if (type === 'IDAT') idat.push(data);
    else if (type === 'IEND') break;
    i += 12 + length;
  }
  if (depth !== 8) throw new Error(`chỉ đọc được PNG 8 bit, file này ${depth} bit`);
  if (interlace !== 0) throw new Error('không đọc được PNG xen kẽ (Adam7)');

  const channels = { 0: 1, 2: 3, 3: 1, 4: 2, 6: 4 }[colorType];
  if (!channels) throw new Error(`colorType ${colorType} không hỗ trợ`);
  const bpp = channels;
  const stride = width * bpp;
  const raw = inflateSync(Buffer.concat(idat));
  const lines = Buffer.alloc(height * stride);

  // Bỏ lọc từng dòng. Mỗi dòng có một byte đầu cho biết kiểu lọc; công thức
  // theo đúng mục 9 của đặc tả PNG.
  for (let y = 0; y < height; y++) {
    const filter = raw[y * (stride + 1)];
    const src = y * (stride + 1) + 1;
    const dst = y * stride;
    const up = dst - stride;
    for (let x = 0; x < stride; x++) {
      const a = x >= bpp ? lines[dst + x - bpp] : 0;
      const b = y > 0 ? lines[up + x] : 0;
      const c = x >= bpp && y > 0 ? lines[up + x - bpp] : 0;
      const v = raw[src + x];
      let out;
      if (filter === 0) out = v;
      else if (filter === 1) out = v + a;
      else if (filter === 2) out = v + b;
      else if (filter === 3) out = v + ((a + b) >> 1);
      else if (filter === 4) {
        const p = a + b - c;
        const pa = Math.abs(p - a); const pb = Math.abs(p - b); const pc = Math.abs(p - c);
        out = v + (pa <= pb && pa <= pc ? a : pb <= pc ? b : c);
      } else throw new Error(`kiểu lọc ${filter} không hợp lệ ở dòng ${y}`);
      lines[dst + x] = out & 0xff;
    }
  }

  const data = new Uint8Array(width * height * 4);
  for (let p = 0; p < width * height; p++) {
    const s = p * bpp; const d = p * 4;
    if (colorType === 6) { data[d] = lines[s]; data[d + 1] = lines[s + 1]; data[d + 2] = lines[s + 2]; data[d + 3] = lines[s + 3]; }
    else if (colorType === 2) { data[d] = lines[s]; data[d + 1] = lines[s + 1]; data[d + 2] = lines[s + 2]; data[d + 3] = 255; }
    else if (colorType === 0) { data[d] = data[d + 1] = data[d + 2] = lines[s]; data[d + 3] = 255; }
    else if (colorType === 4) { data[d] = data[d + 1] = data[d + 2] = lines[s]; data[d + 3] = lines[s + 1]; }
    else if (colorType === 3) {
      const idx = lines[s];
      data[d] = palette[idx * 3]; data[d + 1] = palette[idx * 3 + 1]; data[d + 2] = palette[idx * 3 + 2];
      data[d + 3] = transparency && idx < transparency.length ? transparency[idx] : 255;
    }
  }
  return { width, height, data };
}
