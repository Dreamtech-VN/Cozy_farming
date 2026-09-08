/**
 * Màn chọn server, hiện SAU khi đăng nhập và TRƯỚC khi tải thế giới.
 *
 * Tách thành một màn riêng chứ không nhét vào Cài đặt: đổi server nghĩa là bỏ
 * phiên chơi hiện tại và vào lại từ đầu, nên nó thuộc về luồng vào game. Mục
 * "Server" trong Cài đặt quay ngược về đây thay vì tự đổi tại chỗ.
 */
import { el, showOverlay, hideOverlay } from '../ui/ui.js';

/** Khi chưa cấu hình SERVERS thì vẫn phải có một mục để chọn. */
function serverList(account) {
  const list = account?.servers ?? [];
  if (list.length) return list;
  return [{ id: 'default', name: 'Sunny-1', url: location.origin }];
}

export function showServerSelect(game, account) {
  return new Promise((resolve) => {
    const servers = serverList(account);
    let picked = servers.find((s) => s.url === location.origin) ?? servers[0];

    const label = el('strong', { class: 'server-name', text: picked.name });
    const row = el('button', {
      class: 'server-row', type: 'button',
      // Chỉ bấm được khi thật sự có nhiều server; một server mà vẫn cho bấm là
      // hứa suông.
      disabled: servers.length < 2,
      onClick: () => {
        const next = servers[(servers.indexOf(picked) + 1) % servers.length];
        picked = next;
        label.textContent = next.name;
      },
    }, [
      el('span', { class: 'server-dot' }),
      label,
      el('span', { class: 'server-hint', text: servers.length > 1 ? 'Nhấp để đổi ›' : 'Đang hoạt động' }),
    ]);

    const start = el('button', {
      class: 'primary server-start', type: 'button', text: 'Bắt đầu',
      onClick: () => {
        hideOverlay();
        // Server khác máy chủ hiện tại thì phải nạp lại trang sang đó; cùng máy
        // chủ thì đi thẳng vào game.
        if (picked.url && picked.url !== location.origin) location.href = picked.url;
        else resolve(picked);
      },
    });

    showOverlay(el('div', { class: 'server-pick' }, [row, start]), { backdrop: 'server' });
    start.focus();
  });
}
