/** Màn đăng nhập + tạo nhân vật (doc 12 — Login, Character creation). */
import { el, showOverlay, hideOverlay, bindSubmit } from '../ui/ui.js';
import { t } from '../core/i18n.js';

export function showLogin(game) {
  const error = el('div', { class: 'error hidden' });
  const username = el('input', { type: 'text', autocomplete: 'username', placeholder: 'tên đăng nhập' });
  const password = el('input', { type: 'password', autocomplete: 'current-password', placeholder: '••••••••' });

  const fail = (message) => { error.textContent = message; error.classList.remove('hidden'); };

  const submit = async () => {
    error.classList.add('hidden');
    try {
      const session = await game.api.post('/v1/auth/login', {
        username: username.value.trim(),
        password: password.value,
      });
      game.api.setSession(session);
      hideOverlay();
      await game.enterGame();
    } catch (err) {
      fail(err.message);
    }
  };

  const card = el('div', { class: 'card entry' }, [
    el('h1', { text: 'Chào mừng trở lại' }),
    el('p', { class: 'lead', text: 'Đăng nhập để vào thế giới và chăm sóc nông trại của bạn.' }),
    error,
    el('div', { class: 'field' }, [el('label', { text: 'Tên đăng nhập' }), username]),
    el('div', { class: 'field' }, [el('label', { text: 'Mật khẩu' }), password]),
    el('div', { class: 'actions' }, [
      el('button', { class: 'ghost', type: 'button', text: 'Tạo tài khoản', onClick: () => showRegister(game) }),
      el('button', { class: 'primary', type: 'button', text: 'Đăng nhập', onClick: submit }),
    ]),
  ]);

  password.addEventListener('keydown', (event) => { if (event.key === 'Enter') submit(); });
  showOverlay(card, { backdrop: 'entry' });
}

/**
 * Đăng ký chỉ tạo TÀI KHOẢN.
 *
 * Tên nhân vật và chọn nhân vật chuyển sang màn riêng sau khi chọn server —
 * nhân vật thuộc về một server cụ thể, hỏi ở đây là khoá cứng người chơi vào
 * server đầu tiên họ gặp.
 */
export function showRegister(game) {
  const error = el('div', { class: 'error hidden' });
  const username = el('input', { type: 'text', autocomplete: 'username', placeholder: '3–20 ký tự, chữ và số' });
  const password = el('input', { type: 'password', autocomplete: 'new-password', placeholder: 'tối thiểu 8 ký tự' });

  const submit = async () => {
    error.classList.add('hidden');
    try {
      const session = await game.api.post('/v1/auth/register', {
        username: username.value.trim(),
        password: password.value,
      });
      game.api.setSession(session);
      hideOverlay();
      await game.enterGame();
    } catch (err) {
      error.textContent = err.message;
      error.classList.remove('hidden');
    }
  };

  const start = el('button', { class: 'primary', type: 'button', text: 'Tạo tài khoản' });
  bindSubmit(start, submit);

  showOverlay(el('div', { class: 'card entry' }, [
    el('h1', { text: 'Tạo tài khoản' }),
    el('p', { class: 'lead', text: 'Đặt tên đăng nhập và mật khẩu để bắt đầu.' }),
    el('div', { class: 'field' }, [el('label', { text: 'Tên đăng nhập' }), username]),
    el('div', { class: 'field' }, [el('label', { text: 'Mật khẩu' }), password]),
    error,
    el('div', { class: 'actions' }, [
      el('button', { type: 'button', text: 'Đã có tài khoản', onClick: () => showLogin(game) }),
      start,
    ]),
  ]), { backdrop: 'entry' });
  username.focus();
}
