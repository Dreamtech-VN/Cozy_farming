/**
 * WebSocket server tối giản theo RFC 6455 (doc 16).
 * Viết tay để giữ server zero-dependency; chỉ hỗ trợ đúng những gì game cần:
 * text frame, ping/pong, close, và fragmentation.
 */
import { createHash } from 'node:crypto';
import { EventEmitter } from 'node:events';
import { logger } from '../lib/logger.js';

const GUID = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11';
const MAX_FRAME_BYTES = 64 * 1024;

const OP = { CONT: 0x0, TEXT: 0x1, BINARY: 0x2, CLOSE: 0x8, PING: 0x9, PONG: 0xa };

export class WebSocketConnection extends EventEmitter {
  constructor(socket) {
    super();
    this.socket = socket;
    this.closed = false;
    this.buffer = Buffer.alloc(0);
    this.fragments = [];
    this.fragmentOpcode = null;
    this.isAlive = true;

    socket.on('data', (chunk) => this.#onData(chunk));
    socket.on('close', () => this.#onClose());
    socket.on('error', (err) => {
      logger.debug('websocket socket error', { error: err.message });
      this.#onClose();
    });
  }

  #onClose() {
    if (this.closed) return;
    this.closed = true;
    this.emit('close');
  }

  #onData(chunk) {
    this.buffer = this.buffer.length === 0 ? chunk : Buffer.concat([this.buffer, chunk]);
    for (;;) {
      const frame = this.#readFrame();
      if (!frame) break;
      this.#handleFrame(frame);
      if (this.closed) break;
    }
  }

  /** Đọc một frame trọn vẹn từ buffer, hoặc null nếu chưa đủ byte. */
  #readFrame() {
    const buf = this.buffer;
    if (buf.length < 2) return null;

    const fin = (buf[0] & 0x80) !== 0;
    const opcode = buf[0] & 0x0f;
    const masked = (buf[1] & 0x80) !== 0;
    let length = buf[1] & 0x7f;
    let offset = 2;

    if (length === 126) {
      if (buf.length < offset + 2) return null;
      length = buf.readUInt16BE(offset);
      offset += 2;
    } else if (length === 127) {
      if (buf.length < offset + 8) return null;
      const big = buf.readBigUInt64BE(offset);
      if (big > BigInt(MAX_FRAME_BYTES)) { this.close(1009, 'frame quá lớn'); return null; }
      length = Number(big);
      offset += 8;
    }
    if (length > MAX_FRAME_BYTES) { this.close(1009, 'frame quá lớn'); return null; }

    let mask = null;
    if (masked) {
      if (buf.length < offset + 4) return null;
      mask = buf.subarray(offset, offset + 4);
      offset += 4;
    }
    if (buf.length < offset + length) return null;

    const payload = Buffer.from(buf.subarray(offset, offset + length));
    if (mask) for (let i = 0; i < payload.length; i++) payload[i] ^= mask[i % 4];
    this.buffer = buf.subarray(offset + length);
    return { fin, opcode, payload };
  }

  #handleFrame(frame) {
    switch (frame.opcode) {
      case OP.PING:
        this.#send(OP.PONG, frame.payload);
        return;
      case OP.PONG:
        this.isAlive = true;
        return;
      case OP.CLOSE:
        this.close(1000, 'closed by peer');
        return;
      case OP.CONT:
        if (this.fragmentOpcode === null) return;
        this.fragments.push(frame.payload);
        break;
      case OP.TEXT:
      case OP.BINARY:
        this.fragmentOpcode = frame.opcode;
        this.fragments = [frame.payload];
        break;
      default:
        this.close(1003, 'opcode không hỗ trợ');
        return;
    }

    if (!frame.fin) return;
    const payload = Buffer.concat(this.fragments);
    const opcode = this.fragmentOpcode;
    this.fragments = [];
    this.fragmentOpcode = null;
    if (opcode !== OP.TEXT) return;

    let message;
    try {
      message = JSON.parse(payload.toString('utf8'));
    } catch {
      this.sendJson({ type: 'error', error: { code: 'bad_request', message: 'payload phải là JSON' } });
      return;
    }
    this.emit('message', message);
  }

  #send(opcode, payload) {
    if (this.closed || this.socket.destroyed) return;
    const length = payload.length;
    let header;
    if (length < 126) {
      header = Buffer.alloc(2);
      header[1] = length;
    } else if (length < 65536) {
      header = Buffer.alloc(4);
      header[1] = 126;
      header.writeUInt16BE(length, 2);
    } else {
      header = Buffer.alloc(10);
      header[1] = 127;
      header.writeBigUInt64BE(BigInt(length), 2);
    }
    header[0] = 0x80 | opcode;
    this.socket.write(Buffer.concat([header, payload]));
  }

  sendJson(value) {
    this.#send(OP.TEXT, Buffer.from(JSON.stringify(value), 'utf8'));
  }

  ping() {
    this.isAlive = false;
    this.#send(OP.PING, Buffer.alloc(0));
  }

  close(code = 1000, reason = '') {
    if (this.closed) return;
    const payload = Buffer.alloc(2 + Buffer.byteLength(reason));
    payload.writeUInt16BE(code, 0);
    payload.write(reason, 2);
    this.#send(OP.CLOSE, payload);
    this.socket.end();
    this.#onClose();
  }
}

/** Gắn xử lý upgrade vào http server; onConnection nhận (conn, url). */
export function attachWebSocket(httpServer, onConnection) {
  httpServer.on('upgrade', (req, socket) => {
    const key = req.headers['sec-websocket-key'];
    if (req.headers.upgrade?.toLowerCase() !== 'websocket' || !key) {
      socket.write('HTTP/1.1 400 Bad Request\r\n\r\n');
      socket.destroy();
      return;
    }
    const accept = createHash('sha1').update(key + GUID).digest('base64');
    socket.write(
      'HTTP/1.1 101 Switching Protocols\r\n' +
      'Upgrade: websocket\r\n' +
      'Connection: Upgrade\r\n' +
      `Sec-WebSocket-Accept: ${accept}\r\n\r\n`
    );
    socket.setNoDelay(true);
    const url = new URL(req.url, `http://${req.headers.host ?? 'localhost'}`);
    onConnection(new WebSocketConnection(socket), url);
  });
}
