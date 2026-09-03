/**
 * Khung chat cố định ở dưới giữa màn hình (doc 08 — communication).
 * Luôn thấy vài dòng gần nhất và ô nhập, không phải mở panel mới chat được.
 */
import { el, toast } from './ui.js';
import { openSocial, openSettings } from './panels.js';
import { markActiveMenu, icon } from './hud_menu.js';

const MAX_LINES = 40;

/** Nhãn kênh dùng cho cả nút đổi kênh lẫn chip trước tên người gửi. */
const SCOPE_LABEL = { map: 'Khu', world: 'Thế giới', private: 'Riêng' };

export class ChatDock {
  constructor(game) {
    this.game = game;
    this.root = document.getElementById('chat-dock');
    this.stream = document.getElementById('chat-stream');
    this.input = document.getElementById('chat-input');
    this.scopePill = document.getElementById('chat-scope');
    this.form = document.getElementById('chat-entry');
    this.scope = 'map';

    this.form.addEventListener('submit', (event) => {
      event.preventDefault();
      this.#send();
    });
    // Enter để gửi, Esc để nhả focus về game.
    this.input.addEventListener('keydown', (event) => {
      if (event.key === 'Escape') this.input.blur();
      event.stopPropagation();
    });
    // Một nút đổi kênh qua lại, hiện đúng kênh đang dùng — mẫu dùng đúng kiểu
    // này, và cũng đỡ một menu hệ thống so với <select>.
    this.scopePill.addEventListener('click', () => {
      this.scope = this.scope === 'map' ? 'world' : 'map';
      this.scopePill.dataset.scope = this.scope;
      this.scopePill.textContent = SCOPE_LABEL[this.scope];
      this.loadHistory();
    });
    document.getElementById('chat-emote').addEventListener('click', () => this.#openEmotes());
    // Hai nút cạnh chat dùng chung kiểu icon với HUD nên dựng nội dung ở đây.
    const sideButton = (id, key, iconName, label, run) => {
      const node = document.getElementById(id);
      node.dataset.key = key;
      node.replaceChildren(
        el('span', { class: 'icon-btn-face', html: icon(iconName) }),
        el('span', { class: 'icon-btn-label', text: label }),
      );
      node.addEventListener('click', run);
    };
    sideButton('chat-settings', 'settings', 'settings', 'Cài đặt',
      () => { openSettings(this.game); markActiveMenu('settings'); });
    sideButton('chat-friends', 'social', 'friends', 'Bạn bè',
      () => { openSocial(this.game); markActiveMenu('social'); });
  }

  show() { this.root.classList.remove('hidden'); }

  /** Nạp lịch sử của kênh đang chọn. */
  async loadHistory() {
    const channel = this.scope;
    const scopeId = channel === 'map' ? this.game.currentMap?.map_id : null;
    this.stream.replaceChildren();
    try {
      const query = new URLSearchParams({ channel, limit: '20', ...(scopeId ? { scope_id: scopeId } : {}) });
      const data = await this.game.api.get(`/v1/chat/messages?${query}`);
      for (const message of data.messages) this.append(message, false);
    } catch {
      this.system('Không tải được lịch sử chat.');
    }
  }

  append(message, notify = true) {
    const mine = message.sender_id === this.game.characterId;
    this.stream.append(el('div', { class: `chat-line ${mine ? 'mine' : ''}`.trim() }, [
      el('span', { class: `ch-tag c-${message.channel}`, text: SCOPE_LABEL[message.channel] ?? message.channel }),
      el('span', { class: 'who', text: `${message.sender_nickname}: ` }),
      el('span', { text: message.body }),
    ]));
    while (this.stream.childElementCount > MAX_LINES) this.stream.firstElementChild.remove();
    this.stream.scrollTop = this.stream.scrollHeight;

    // Chỉ nhắc bằng toast khi khung chat đang thu gọn, tránh nhân đôi thông tin.
    if (notify && !mine && this.root.classList.contains('collapsed')) {
      toast(`${message.sender_nickname}: ${message.body}`);
    }
  }

  system(text) {
    this.stream.append(el('div', { class: 'chat-line system', text }));
    this.stream.scrollTop = this.stream.scrollHeight;
  }

  async #send() {
    const body = this.input.value.trim();
    if (!body) return;
    this.input.value = '';
    const channel = this.scope;
    try {
      if (channel === 'map') this.game.realtime.send({ type: 'chat', body });
      else await this.game.api.post('/v1/chat/messages', { channel, body });
    } catch (err) {
      toast(err.message, 'bad');
    }
  }

  #openEmotes() {
    const list = this.game.content.emotes ?? [];
    const bar = el('div', { class: 'emote-bar' }, list.map((emote) =>
      el('button', {
        class: 'emote-btn', type: 'button', title: emote.name_key,
        text: emote.glyph,
        onClick: () => {
          this.game.realtime.send({ type: 'emote', emote_id: emote.emote_id });
          bar.remove();
        },
      })));
    const existing = this.root.querySelector('.emote-bar');
    if (existing) { existing.remove(); return; }
    this.root.prepend(bar);
  }
}
