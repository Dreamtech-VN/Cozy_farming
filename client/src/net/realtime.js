/**
 * Kênh realtime (doc 16). Client dự đoán chuyển động cục bộ và gửi vị trí;
 * server có quyền sửa lại. Tự kết nối lại với backoff khi rớt mạng.
 */
export class Realtime extends EventTarget {
  constructor(api) {
    super();
    this.api = api;
    this.socket = null;
    this.instanceId = null;
    this.attempt = 0;
    this.closedByUs = false;
    this.sendTimer = null;
    this.pending = null;
  }

  connect(instanceId) {
    this.instanceId = instanceId;
    this.closedByUs = false;
    this.#open();
  }

  #open() {
    const protocol = location.protocol === 'https:' ? 'wss' : 'ws';
    const url = `${protocol}://${location.host}/ws?instance=${encodeURIComponent(this.instanceId)}&token=${encodeURIComponent(this.api.token)}`;
    const socket = new WebSocket(url);
    this.socket = socket;

    socket.addEventListener('open', () => {
      this.attempt = 0;
      this.dispatchEvent(new CustomEvent('status', { detail: { connected: true } }));
    });
    socket.addEventListener('message', (event) => {
      let message;
      try { message = JSON.parse(event.data); } catch { return; }
      this.dispatchEvent(new CustomEvent(message.type, { detail: message }));
      this.dispatchEvent(new CustomEvent('*', { detail: message }));
    });
    socket.addEventListener('close', () => {
      // Socket cũ đóng muộn sau khi đã mở socket mới (đổi map): bỏ qua, nếu không
      // nó sẽ tự kết nối lại và tạo kết nối trùng khiến server đá phiên đang dùng.
      if (this.socket !== socket) return;
      this.dispatchEvent(new CustomEvent('status', { detail: { connected: false } }));
      if (this.closedByUs) return;
      this.attempt += 1;
      const delay = Math.min(15000, 500 * 2 ** Math.min(this.attempt, 5));
      setTimeout(() => this.#open(), delay);
    });
    socket.addEventListener('error', () => socket.close());
  }

  send(message) {
    if (this.socket?.readyState === WebSocket.OPEN) this.socket.send(JSON.stringify(message));
  }

  /** Gộp cập nhật vị trí lại, tối đa ~15 gói/giây (doc 16 — tiết kiệm băng thông). */
  sendMove(state) {
    this.pending = { type: 'move', ...state };
    if (this.sendTimer) return;
    this.sendTimer = setTimeout(() => {
      this.sendTimer = null;
      if (this.pending) { this.send(this.pending); this.pending = null; }
    }, 66);
  }

  close() {
    this.closedByUs = true;
    this.socket?.close();
  }
}
