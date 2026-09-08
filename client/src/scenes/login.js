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

export function showRegister(game) {
  const error = el('div', { class: 'error hidden' });
  const username = el('input', { type: 'text', autocomplete: 'username', placeholder: '3–20 ký tự, chữ và số' });
  const password = el('input', { type: 'password', autocomplete: 'new-password', placeholder: 'tối thiểu 8 ký tự' });
  const nickname = el('input', { type: 'text', maxlength: '16', placeholder: 'tên hiển thị trong game' });

  // Chọn ngoại hình: mỗi slot lấy đúng các cosmetic mặc định từ content (doc 04).
  const defaults = game.content.avatarItems.filter((item) => item.unlock.type === 'default');
  const slots = ['body', 'face', 'hair', 'top', 'bottom', 'shoes'];
  const appearance = { body_type: 'a' };
  for (const slot of slots) appearance[slot] = defaults.find((item) => item.slot === slot)?.item_id;

  const preview = el('canvas', { width: 200, height: 260 });
  preview.style.cssText = 'width:112px;height:146px;display:block;margin:0 auto 8px';

  const drawPreview = () => {
    const ctx = preview.getContext('2d');
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.clearRect(0, 0, preview.width, preview.height);
    ctx.translate(preview.width / 2, preview.height - 24);
    ctx.scale(1.7, 1.7);
    drawAvatar(ctx, game.content, {
      equipment: appearance,
      bodyType: appearance.body_type,
      facing: 1,
      state: 'idle',
      phase: 0,
    });
  };

  // Chọn nhân vật. Art là hai người vẽ sẵn nguyên bộ, không tháo rời được, nên
  // đây là lựa chọn đầu tiên chứ không phải một slot trang phục.
  const HEROES = [{ id: 'a', label: 'Bạn nam' }, { id: 'b', label: 'Bạn nữ' }];
  const heroPicker = el('div', { class: 'field' }, [
    el('label', { text: 'Nhân vật' }),
    el('div', { class: 'hero-picker', role: 'radiogroup', 'aria-label': 'Chọn nhân vật' },
      HEROES.map((hero) => el('button', {
        class: 'hero-option',
        type: 'button',
        role: 'radio',
        text: hero.label,
        'aria-checked': appearance.body_type === hero.id ? 'true' : 'false',
        onClick: (event) => {
          appearance.body_type = hero.id;
          for (const sibling of event.currentTarget.parentElement.children) sibling.setAttribute('aria-checked', 'false');
          event.currentTarget.setAttribute('aria-checked', 'true');
          drawPreview();
        },
      }))),
  ]);

  // Không còn picker màu theo slot: nhân vật là art vẽ sẵn nguyên bộ, đổi "màu
  // da" hay "màu tóc" không làm hình đổi gì cả. Để lại là lừa người chơi bấm
  // vào thứ vô tác dụng. Trang phục vẫn ghi mặc định vào `appearance` nên mô
  // hình dữ liệu không đổi, chờ khi nào có art tháo rời được thì mở lại.
  const pickers = [heroPicker];

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

  showOverlay(el('div', { class: 'card entry' }, [
    el('h1', { text: 'Tạo nhân vật' }),
    el('p', { class: 'lead', text: 'Chọn nhân vật và đặt tên để bắt đầu.' }),
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
  ]), { backdrop: 'entry' });
  drawPreview();
}

const SLOT_LABEL = { body: 'Màu da', face: 'Mắt', hair: 'Tóc', top: 'Áo', bottom: 'Quần', shoes: 'Giày' };
