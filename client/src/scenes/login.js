/** Màn đăng nhập + tạo nhân vật (doc 12 — Login, Character creation). */
import { el, showOverlay, hideOverlay } from '../ui/ui.js';
import { t } from '../core/i18n.js';
import { drawAvatar } from '../render/avatar.js';

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

  const card = el('div', { class: 'card' }, [
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
  showOverlay(card);
}

export function showRegister(game) {
  const error = el('div', { class: 'error hidden' });
  const username = el('input', { type: 'text', autocomplete: 'username', placeholder: '3–20 ký tự, chữ và số' });
  const password = el('input', { type: 'password', autocomplete: 'new-password', placeholder: 'tối thiểu 8 ký tự' });
  const nickname = el('input', { type: 'text', maxlength: '16', placeholder: 'tên hiển thị trong game' });

  // Chọn ngoại hình: mỗi slot lấy đúng các cosmetic mặc định từ content (doc 04).
  const defaults = game.content.avatarItems.filter((item) => item.unlock.type === 'default');
  const slots = ['body', 'face', 'hair', 'top', 'bottom', 'shoes'];
  const appearance = {};
  for (const slot of slots) appearance[slot] = defaults.find((item) => item.slot === slot)?.item_id;

  const preview = el('canvas', { width: 200, height: 260 });
  preview.style.cssText = 'width:150px;height:195px;display:block;margin:0 auto 12px';

  const drawPreview = () => {
    const ctx = preview.getContext('2d');
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.clearRect(0, 0, preview.width, preview.height);
    ctx.translate(preview.width / 2, preview.height - 24);
    ctx.scale(1.7, 1.7);
    drawAvatar(ctx, game.content, { equipment: appearance, facing: 1, state: 'idle', phase: 0 });
  };

  const pickers = slots.map((slot) => {
    const options = defaults.filter((item) => item.slot === slot);
    if (options.length <= 1) return null;
    const row = el('div', { class: 'swatches' }, options.map((item) =>
      el('button', {
        class: 'swatch', type: 'button', title: t(item.name_key),
        style: `background:${item.colors[0]}`,
        'aria-pressed': appearance[slot] === item.item_id ? 'true' : 'false',
        onClick: (event) => {
          appearance[slot] = item.item_id;
          for (const sibling of event.currentTarget.parentElement.children) sibling.setAttribute('aria-pressed', 'false');
          event.currentTarget.setAttribute('aria-pressed', 'true');
          drawPreview();
        },
      })));
    return el('div', { class: 'field' }, [el('label', { text: SLOT_LABEL[slot] }), row]);
  }).filter(Boolean);

  const submit = async () => {
    error.classList.add('hidden');
    try {
      const session = await game.api.post('/v1/auth/register', {
        username: username.value.trim(),
        password: password.value,
        nickname: nickname.value.trim(),
        appearance,
      });
      game.api.setSession(session);
      hideOverlay();
      await game.enterGame();
    } catch (err) {
      error.textContent = err.message;
      error.classList.remove('hidden');
    }
  };

  showOverlay(el('div', { class: 'card' }, [
    el('h1', { text: 'Tạo nhân vật' }),
    el('p', { class: 'lead', text: 'Chọn ngoại hình khởi đầu — bạn có thể đổi lại bất cứ lúc nào trong game.' }),
    error,
    preview,
    el('div', { class: 'field' }, [el('label', { text: 'Tên đăng nhập' }), username]),
    el('div', { class: 'field' }, [el('label', { text: 'Mật khẩu' }), password]),
    el('div', { class: 'field' }, [el('label', { text: 'Nickname' }), nickname]),
    ...pickers,
    el('div', { class: 'actions' }, [
      el('button', { class: 'ghost', type: 'button', text: 'Đã có tài khoản', onClick: () => showLogin(game) }),
      el('button', { class: 'primary', type: 'button', text: 'Bắt đầu chơi', onClick: submit }),
    ]),
  ]));
  drawPreview();
}

const SLOT_LABEL = { body: 'Màu da', face: 'Mắt', hair: 'Tóc', top: 'Áo', bottom: 'Quần', shoes: 'Giày' };
