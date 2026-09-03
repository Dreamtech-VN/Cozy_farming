/**
 * Lưới nút chức năng trên HUD (doc 12 — world là trung tâm, UI là overlay).
 * Mỗi nút là icon + nhãn, dựng từ một bảng khai báo nên thêm tính năng mới chỉ
 * cần thêm một dòng.
 */
import { el, closePanel } from './ui.js';

/**
 * Icon là ảnh thật trong bộ Cozy UI Pack (xem client/assets/ATTRIBUTION.md).
 * Trước đây vẽ bằng SVG nét nên nhìn khô so với mẫu; có bộ art thật rồi thì
 * dùng thẳng, khỏi mô phỏng bằng nét vẽ.
 */
export const icon = (name) =>
  `<img src="/assets/icons/${name}.png" alt="" width="128" height="128" draggable="false">`;

function button(item, game) {
  return el('button', {
    class: 'icon-btn', type: 'button', 'data-key': item.key, title: item.title ?? item.label,
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
  // Hàng dưới phải đúng 4 nút như mẫu; Bạn bè đã có nút riêng cạnh khung chat.
  const bottom = [
    { key: 'quests', icon: 'quest', label: 'Nhiệm vụ', run: handlers.quests },
    { key: 'inventory', icon: 'bag', label: 'Túi đồ', run: handlers.inventory },
    { key: 'farm', icon: 'home', label: 'Nông trại', run: handlers.farm },
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
