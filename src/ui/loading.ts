// ===== Màn chờ khi vào game (dùng chung key art với màn đăng nhập) =====
import { h, root } from './kit';

let cover: HTMLElement | undefined;

export function showLoading(text = 'Đang vào Sunny Town...') {
  if (cover) return;
  cover = h('div', 'load-cover');
  const box = h('div', 'load-box');
  box.append(h('div', 'load-spin'), h('div', 'load-txt', text));
  cover.append(box);
  root().append(cover);
}

export function hideLoading() {
  if (!cover) return;
  const c = cover;
  cover = undefined;
  c.classList.add('load-out');
  window.setTimeout(() => c.remove(), 420);
}
