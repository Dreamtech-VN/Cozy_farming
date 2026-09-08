/**
 * Màn nhân vật, hiện SAU khi chọn server.
 *
 * Nhân vật thuộc về một server cụ thể, nên phải hỏi server trước rồi mới tới
 * nhân vật — gộp vào bước đăng ký là khoá cứng người chơi vào server đầu tiên
 * họ gặp.
 *
 * Một màn lo hai việc: chưa có nhân vật thì hiện form tạo, có rồi thì hiện thẻ
 * nhân vật để bấm vào chơi. Tách hai màn thì phần lớn giao diện lặp lại y hệt.
 */
import { el, showOverlay, hideOverlay, bindSubmit } from '../ui/ui.js';
import { drawAvatar } from '../render/avatar.js';

const HEROES = [{ id: 'a', label: 'Bạn nam' }, { id: 'b', label: 'Bạn nữ' }];

function previewCanvas(game, get) {
  const canvas = el('canvas', { width: 220, height: 280, class: 'hero-preview' });
  const draw = () => {
    const ctx = canvas.getContext('2d');
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.translate(canvas.width / 2, canvas.height - 20);
    ctx.scale(2.2, 2.2);
    drawAvatar(ctx, game.content, { bodyType: get(), facing: 1, state: 'idle', phase: 0 });
  };
  draw();
  return { canvas, draw };
}

export function showCharacterScreen(game, characters) {
  return new Promise((resolve) => {
    if (characters.length) {
      const c = characters[0];
      const { canvas } = previewCanvas(game, () => c.body_type);
      showOverlay(el('div', { class: 'char-pick' }, [
        canvas,
        el('div', { class: 'char-card' }, [
          el('strong', { class: 'char-name', text: c.nickname }),
          el('span', { class: 'char-meta', text: `Cấp ${c.level}` }),
        ]),
        el('button', {
          class: 'primary server-start', type: 'button', text: 'Vào game',
          onClick: () => { hideOverlay(); resolve(null); },
        }),
      ]), { backdrop: 'character' });
      return;
    }

    let bodyType = 'a';
    const nickname = el('input', { type: 'text', maxlength: '16', placeholder: 'tên hiển thị trong game' });
    const error = el('div', { class: 'error hidden' });
    const { canvas, draw } = previewCanvas(game, () => bodyType);

    const picker = el('div', { class: 'hero-picker', role: 'radiogroup', 'aria-label': 'Chọn nhân vật' },
      HEROES.map((hero) => el('button', {
        class: 'hero-option', type: 'button', role: 'radio', text: hero.label,
        'aria-checked': bodyType === hero.id ? 'true' : 'false',
        onClick: (event) => {
          bodyType = hero.id;
          for (const sibling of event.currentTarget.parentElement.children) sibling.setAttribute('aria-checked', 'false');
          event.currentTarget.setAttribute('aria-checked', 'true');
          draw();
        },
      })));

    const create = el('button', { class: 'primary server-start', type: 'button', text: 'Tạo nhân vật' });
    bindSubmit(create, async () => {
      error.classList.add('hidden');
      try {
        const made = await game.api.post('/v1/characters', {
          nickname: nickname.value.trim(),
          appearance: { body_type: bodyType },
        });
        // Token cũ chưa gắn nhân vật nào, phải thay bằng phiên mới.
        game.api.setSession(made.session);
        hideOverlay();
        resolve(made.character);
      } catch (err) {
        error.textContent = err.message;
        error.classList.remove('hidden');
      }
    });

    showOverlay(el('div', { class: 'char-pick' }, [
      canvas,
      picker,
      el('div', { class: 'field' }, [el('label', { text: 'Tên nhân vật' }), nickname]),
      error,
      create,
    ]), { backdrop: 'character' });
    nickname.focus();
  });
}
