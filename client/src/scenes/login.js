/**
 * Màn đăng nhập và tạo tài khoản.
 *
 * Chỉ lo TÀI KHOẢN. Tên nhân vật và chọn nhân vật nằm ở màn riêng sau khi chọn
 * server — nhân vật thuộc về một server cụ thể, hỏi ở đây là khoá cứng người
 * chơi vào server đầu tiên họ gặp.
 */
import { el, showOverlay, hideOverlay, bindSubmit, toast } from '../ui/ui.js';

/** Ô nhập có biểu tượng bên trái, và nút hiện/ẩn cho ô mật khẩu. */
function field(icon, attrs, { reveal = false } = {}) {
  const input = el('input', attrs);
  const kids = [el('span', { class: 'in-icon', text: icon }), input];
  if (reveal) {
    // Nút hiện mật khẩu: gõ sai trên bàn phím ảo là chuyện thường, không cho
    // xem lại thì chỉ còn cách xoá hết gõ lại.
    const eye = el('button', {
      class: 'in-eye', type: 'button', 'aria-label': 'Hiện mật khẩu', 'aria-pressed': 'false',
      text: '🙈',
      onClick: () => {
        const shown = input.type === 'text';
        input.type = shown ? 'password' : 'text';
        eye.textContent = shown ? '🙈' : '👁';
        eye.setAttribute('aria-pressed', String(!shown));
        eye.setAttribute('aria-label', shown ? 'Hiện mật khẩu' : 'Ẩn mật khẩu');
      },
    });
    kids.push(eye);
  }
  return { row: el('div', { class: 'in-row' }, kids), input };
}

function checkbox(labelNode, checked = false) {
  const box = el('input', { type: 'checkbox' });
  box.checked = checked;
  return { node: el('label', { class: 'check' }, [box, labelNode]), box };
}

/**
 * Ba nút đăng nhập mạng xã hội. Nhà cung cấp nào chưa cấu hình thì để MỜ và nói
 * rõ vì sao — bày nút bấm vào không có gì xảy ra thì tệ hơn là không bày.
 */
function socialRow(providers) {
  const list = [
    ['google', 'Google', 'G'],
    ['facebook', 'Facebook', 'f'],
    ['apple', 'Apple', ''],
  ];
  return el('div', { class: 'social' }, [
    el('div', { class: 'social-sep' }, [el('span', { text: 'hoặc tiếp tục với' })]),
    el('div', { class: 'social-row' }, list.map(([id, label, mark]) => {
      const ready = providers.includes(id);
      return el('button', {
        class: `social-btn s-${id}`,
        type: 'button',
        disabled: !ready,
        title: ready ? `Đăng nhập bằng ${label}` : `${label} chưa được cấu hình trên máy chủ này`,
        onClick: () => toast(`Đăng nhập bằng ${label} chưa mở`, 'warn'),
      }, [el('span', { class: 'social-mark', text: mark }), el('span', { text: label })]);
    })),
  ]);
}

async function fetchProviders(game) {
  try {
    const res = await game.api.get('/v1/auth/providers');
    return res.providers ?? [];
  } catch {
    return [];
  }
}

export async function showLogin(game) {
  const providers = await fetchProviders(game);
  const error = el('div', { class: 'error hidden' });
  const id = field('✉', { type: 'text', autocomplete: 'username', placeholder: 'Email hoặc tên đăng nhập' });
  const pass = field('🔒', { type: 'password', autocomplete: 'current-password', placeholder: 'Mật khẩu' }, { reveal: true });
  const remember = checkbox(el('span', { text: 'Ghi nhớ đăng nhập' }), true);

  const go = el('button', { class: 'primary big-cta', type: 'button', text: 'Đăng nhập' });
  const submit = async () => {
    error.classList.add('hidden');
    try {
      const session = await game.api.post('/v1/auth/login', {
        username: id.input.value.trim(),
        password: pass.input.value,
      });
      game.api.setSession(session, { remember: remember.box.checked });
      hideOverlay();
      await game.enterGame();
    } catch (err) {
      error.textContent = err.message;
      error.classList.remove('hidden');
    }
  };
  bindSubmit(go, submit);
  pass.input.addEventListener('keydown', (event) => { if (event.key === 'Enter') go.click(); });

  showOverlay(el('div', { class: 'card entry' }, [
    el('h1', { text: '🌿 Chào mừng trở lại! 🌿' }),
    el('p', { class: 'lead', text: 'Đăng nhập để tiếp tục hành trình ở Sunny Town.' }),
    id.row,
    pass.row,
    el('div', { class: 'row-between' }, [
      remember.node,
      el('button', {
        class: 'link', type: 'button', text: 'Quên mật khẩu?',
        // Chưa có đường khôi phục: gửi email cần hạ tầng mail mà máy chủ chưa
        // nối. Nói thẳng còn hơn mở một biểu mẫu không dẫn tới đâu.
        onClick: () => toast('Khôi phục mật khẩu chưa mở — hãy liên hệ hỗ trợ', 'warn'),
      }),
    ]),
    error,
    go,
    socialRow(providers),
    el('p', { class: 'foot-link' }, [
      el('span', { text: 'Chưa có tài khoản? ' }),
      el('button', { class: 'link', type: 'button', text: 'Đăng ký', onClick: () => showRegister(game) }),
    ]),
  ]), { backdrop: 'entry' });
  id.input.focus();
}

export async function showRegister(game) {
  const providers = await fetchProviders(game);
  const error = el('div', { class: 'error hidden' });
  const username = field('👤', { type: 'text', autocomplete: 'username', placeholder: 'Tên đăng nhập' });
  const email = field('✉', { type: 'email', autocomplete: 'email', placeholder: 'Email (không bắt buộc)' });
  const pass = field('🔒', { type: 'password', autocomplete: 'new-password', placeholder: 'Mật khẩu' }, { reveal: true });
  const confirm = field('🔒', { type: 'password', autocomplete: 'new-password', placeholder: 'Nhập lại mật khẩu' }, { reveal: true });
  const terms = checkbox(el('span', {}, [
    el('span', { text: 'Tôi đồng ý với ' }),
    el('button', { class: 'link', type: 'button', text: 'Điều khoản', onClick: () => toast('Trang điều khoản chưa có', 'warn') }),
    el('span', { text: ' và ' }),
    el('button', { class: 'link', type: 'button', text: 'Chính sách riêng tư', onClick: () => toast('Trang chính sách chưa có', 'warn') }),
  ]), true);

  const go = el('button', { class: 'primary big-cta', type: 'button', text: 'Đăng ký' });
  const submit = async () => {
    error.classList.add('hidden');
    const fail = (message) => { error.textContent = message; error.classList.remove('hidden'); };
    // Kiểm ngay tại chỗ hai điều kiện máy chủ không biết: hai ô mật khẩu phải
    // khớp, và phải tích đồng ý điều khoản.
    if (pass.input.value !== confirm.input.value) return fail('Hai ô mật khẩu không khớp');
    if (!terms.box.checked) return fail('Cần đồng ý điều khoản để tiếp tục');
    try {
      const session = await game.api.post('/v1/auth/register', {
        username: username.input.value.trim(),
        password: pass.input.value,
        email: email.input.value.trim() || undefined,
      });
      game.api.setSession(session, { remember: true });
      hideOverlay();
      await game.enterGame();
    } catch (err) {
      fail(err.message);
    }
  };
  bindSubmit(go, submit);

  showOverlay(el('div', { class: 'card entry' }, [
    el('h1', { text: '🌿 Tạo tài khoản 🌿' }),
    el('p', { class: 'lead', text: 'Gia nhập Sunny Town và bắt đầu hành trình.' }),
    username.row,
    email.row,
    pass.row,
    confirm.row,
    terms.node,
    error,
    go,
    socialRow(providers),
    el('p', { class: 'foot-link' }, [
      el('span', { text: 'Đã có tài khoản? ' }),
      el('button', { class: 'link', type: 'button', text: 'Đăng nhập', onClick: () => showLogin(game) }),
    ]),
  ]), { backdrop: 'entry' });
  username.input.focus();
}
