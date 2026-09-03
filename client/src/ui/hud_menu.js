/**
 * Lưới nút chức năng trên HUD (doc 12 — world là trung tâm, UI là overlay).
 * Mỗi nút là icon + nhãn, dựng từ một bảng khai báo nên thêm tính năng mới chỉ
 * cần thêm một dòng.
 */
import { el, closePanel } from './ui.js';

/** Icon vẽ bằng SVG nội tuyến để nét đồng bộ và đổi màu theo CSS. */
const ICONS = {
  map: `<path d="M3 6.5 9 4l6 2.5L21 4v13.5L15 20l-6-2.5L3 20z"/><path d="M9 4v13.5M15 6.5V20"/>`,
  shop: `<path d="M4 8h16l-1.2 11.2A2 2 0 0 1 16.8 21H7.2a2 2 0 0 1-2-1.8z"/><path d="M8.5 8V6a3.5 3.5 0 0 1 7 0v2"/>`,
  event: `<rect x="3.5" y="5" width="17" height="15.5" rx="2.5"/><path d="M3.5 10h17M8 3.2v3.6M16 3.2v3.6"/>`,
  // Icon tô đặc nên chỉ dùng hình KÍN; nét hở (mấy gạch ngang) tô vào thành
  // mảng loang. Hai hình thoi xếp chồng đọc ra "nhiều lớp/nhiều khu".
  channel: `<path d="M12 2.6 21.4 8 12 13.4 2.6 8z"/><path d="M12 12.2 19 16.1 12 20 5 16.1z"/>`,
  bag: `<path d="M4.5 8h15l-1 11.2a2 2 0 0 1-2 1.8H7.5a2 2 0 0 1-2-1.8z"/><path d="M9 8V6.2A3 3 0 0 1 15 6.2V8"/><path d="M9 12h6"/>`,
  home: `<path d="M3.5 11 12 4l8.5 7"/><path d="M5.5 9.6V20h13V9.6"/><path d="M10 20v-5h4v5"/>`,
  friends: `<circle cx="9" cy="8.5" r="3.4"/><path d="M3 20c0-3.3 2.7-5.6 6-5.6s6 2.3 6 5.6"/><path d="M16 5.6a3.4 3.4 0 0 1 0 6.8M17.5 14.8c2.1.7 3.5 2.6 3.5 5.2"/>`,
  dress: `<path d="M9 3.5 12 6l3-2.5 4 2.4-2 3.6-1.6-.8V20H7.6V8.7L6 9.5 4 5.9z"/>`,
  quest: `<rect x="5" y="3.5" width="14" height="17" rx="2.2"/><path d="M8.5 8.5h7M8.5 12h7M8.5 15.5h4"/>`,
};

const icon = (name) =>
  `<svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor"
        stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">${ICONS[name] ?? ''}</svg>`;

/* Mỗi chức năng một màu riêng: mẫu dùng icon nhiều màu nên người chơi nhận ra
   nút theo màu trước khi kịp đọc nhãn. Chín đĩa cùng một màu xám thì phải đọc
   từng chữ mới bấm đúng. */
const COLORS = {
  map: '#4fb0d8', shop: '#f07fa8', channel: '#9a86e0', event: '#f5a63c',
  quests: '#f2c53d', inventory: '#d99152', farm: '#69c163', social: '#5aa9e6',
  profile: '#ef7d6b',
};

function button(item, game) {
  return el('button', {
    class: 'icon-btn', type: 'button', 'data-key': item.key, title: item.title ?? item.label,
    style: `--btn-color: ${COLORS[item.key] ?? '#8fa5b8'}`,
    onClick: () => {
      const alreadyOpen = document.querySelector(`.icon-btn[data-key="${item.key}"][aria-pressed="true"]`);
      closePanel();
      if (!alreadyOpen) item.run(game);
    },
  }, [
    el('span', { class: 'icon-btn-face', html: icon(item.icon) }),
    el('span', { class: 'icon-btn-label', text: item.label }),
    el('i', { class: 'icon-btn-dot hidden' }),
  ]);
}

/**
 * @param handlers các hàm mở panel, truyền từ main.js để module này không phải
 *        biết gì về từng panel cụ thể.
 */
export function buildHudMenus(game, handlers) {
  const top = [
    { key: 'map', icon: 'map', label: 'Bản đồ', run: handlers.map },
    { key: 'shop', icon: 'shop', label: 'Cửa hàng', run: handlers.shop },
    // Nhãn phải vừa bề ngang nút; tên đầy đủ để ở tooltip.
    { key: 'channel', icon: 'channel', label: 'Đổi khu', title: 'Chuyển khu', run: handlers.channel },
    { key: 'event', icon: 'event', label: 'Sự kiện', run: handlers.event },
  ];
  const bottom = [
    { key: 'quests', icon: 'quest', label: 'Nhiệm vụ', run: handlers.quests },
    { key: 'inventory', icon: 'bag', label: 'Túi đồ', run: handlers.inventory },
    { key: 'farm', icon: 'home', label: 'Nông trại', run: handlers.farm },
    { key: 'social', icon: 'friends', label: 'Bạn bè', run: handlers.social },
    { key: 'profile', icon: 'dress', label: 'Nhân vật', run: handlers.profile },
  ];

  document.getElementById('menu-top').replaceChildren(...top.map((i) => button(i, game)));
  document.getElementById('menu-bottom').replaceChildren(...bottom.map((i) => button(i, game)));
}

/** Bật/tắt chấm đỏ báo việc trên một nút, như các icon có chấm trong mẫu. */
export function markMenuBadge(key, show) {
  const dot = document.querySelector(`.icon-btn[data-key="${key}"] .icon-btn-dot`);
  dot?.classList.toggle('hidden', !show);
}

/** Đánh dấu nút tương ứng khi panel của nó đang mở. */
export function markActiveMenu(key) {
  for (const btn of document.querySelectorAll('.icon-btn')) {
    btn.setAttribute('aria-pressed', btn.dataset.key === key ? 'true' : 'false');
  }
}
