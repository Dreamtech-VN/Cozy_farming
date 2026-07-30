// ===== Màn hình đăng nhập + chọn máy chủ (trên nền title) =====
// Bản offline: "đăng nhập" chỉ lưu tài khoản trên máy (localStorage),
// nút Google/Apple là chỗ gắn SDK thật khi có server.

import { h, root } from './kit';

const ACC_KEY = 'cozy_account';
const SRV_KEY = 'cozy_server';

interface Account { type: 'account' | 'google' | 'apple'; name: string }

export interface ServerDef { id: string; name: string; status: 'new' | 'normal' | 'full' }
export const SERVERS: ServerDef[] = [
  { id: 's1', name: 'S1 - Nông Trại Xanh', status: 'new' },
  { id: 's2', name: 'S2 - Đồng Cỏ Hoa', status: 'normal' },
  { id: 's3', name: 'S3 - Hồ Sen', status: 'full' }
];
const STATUS_LBL: Record<ServerDef['status'], [string, string]> = {
  new: ['Mới', '#51cf66'], normal: ['Ổn định', '#ffd43b'], full: ['Đông', '#ff8787']
};

function getAccount(): Account | null {
  try { return JSON.parse(localStorage.getItem(ACC_KEY) || 'null'); } catch { return null; }
}
function setAccount(a: Account | null) {
  try { a ? localStorage.setItem(ACC_KEY, JSON.stringify(a)) : localStorage.removeItem(ACC_KEY); } catch { /* ignore */ }
}
function getServer(): string {
  try { return localStorage.getItem(SRV_KEY) || 's1'; } catch { return 's1'; }
}

// Hiện flow: (đăng nhập nếu chưa có tài khoản) -> chọn máy chủ -> Bắt đầu
export function showLoginFlow(onStart: () => void) {
  const wrap = h('div', 'login-wrap');
  root().append(wrap);
  const done = () => { wrap.remove(); onStart(); };

  const render = () => {
    wrap.innerHTML = '';
    const acc = getAccount();
    acc ? renderServer(wrap, acc, render, done) : renderLogin(wrap, render);
  };
  render();
}

function renderLogin(wrap: HTMLElement, rerender: () => void) {
  const box = h('div', 'login-box');
  box.append(h('div', 'login-head', 'Đăng nhập'));
  const body = h('div', 'login-body');
  box.append(body);

  const loginAs = (a: Account) => { setAccount(a); rerender(); };

  // --- Tài khoản (form tên + mật khẩu, lưu trên máy) ---
  const accBtn = h('button', 'lg-btn lg-acc', '👤  Tài khoản');
  const form = h('div', 'lg-form');
  form.style.display = 'none';
  const user = h('input', 'ui-input') as HTMLInputElement;
  user.placeholder = 'Tên tài khoản'; user.maxLength = 16;
  const pass = h('input', 'ui-input') as HTMLInputElement;
  pass.placeholder = 'Mật khẩu'; pass.type = 'password'; pass.maxLength = 24;
  const go = h('button', 'lg-btn lg-acc', 'Đăng nhập / Đăng ký');
  const err = h('div', 'lg-err', '');
  go.onclick = () => {
    const u = user.value.trim();
    if (u.length < 3 || pass.value.length < 3) { err.textContent = 'Tên và mật khẩu tối thiểu 3 ký tự'; return; }
    loginAs({ type: 'account', name: u });
  };
  form.append(user, pass, err, go);
  accBtn.onclick = () => { form.style.display = form.style.display === 'none' ? 'flex' : 'none'; };

  const ggBtn = h('button', 'lg-btn lg-google');
  ggBtn.innerHTML = '<span class="gg-g">G</span>  Google';
  ggBtn.onclick = () => loginAs({ type: 'google', name: 'Người chơi Google' });

  const apBtn = h('button', 'lg-btn lg-apple', '🍎  Apple');
  apBtn.onclick = () => loginAs({ type: 'apple', name: 'Người chơi Apple' });

  body.append(accBtn, form, ggBtn, apBtn,
    h('div', 'lg-note', 'Bản chơi offline — tài khoản lưu trên thiết bị'));
  wrap.append(box);
}

function renderServer(wrap: HTMLElement, acc: Account, rerender: () => void, done: () => void) {
  // nút quay lại = đăng xuất (như GunPow)
  const back = h('button', 'lg-back', '↩');
  back.title = 'Đổi tài khoản';
  back.onclick = () => { setAccount(null); rerender(); };
  wrap.append(back);

  const box = h('div', 'server-box');
  box.append(h('div', 'sv-hello', `Xin chào, ${acc.name}`));

  let picked = getServer();
  let open = false;
  const svRow = h('div', 'sv-row');
  const svList = h('div', 'sv-list');
  const paint = () => {
    const cur = SERVERS.find(s => s.id === picked) || SERVERS[0];
    const [lbl, color] = STATUS_LBL[cur.status];
    svRow.innerHTML = `<span class="sv-dot" style="background:${color}"></span><span class="sv-name">${cur.name}</span><span class="sv-change">Nhấp đổi</span>`;
    svList.innerHTML = '';
    svList.style.display = open ? 'flex' : 'none';
    if (open) {
      for (const s of SERVERS) {
        const [l2, c2] = STATUS_LBL[s.status];
        const it = h('div', `sv-item ${s.id === picked ? 'active' : ''}`);
        it.innerHTML = `<span class="sv-dot" style="background:${c2}"></span><span class="sv-name">${s.name}</span><span class="sv-tag" style="color:${c2}">${l2}</span>`;
        it.onclick = () => {
          picked = s.id; open = false;
          try { localStorage.setItem(SRV_KEY, picked); } catch { /* ignore */ }
          paint();
        };
        svList.append(it);
      }
    }
  };
  svRow.onclick = () => { open = !open; paint(); };
  paint();

  const start = h('button', 'lg-start', 'Bắt đầu');
  start.onclick = done;

  box.append(svRow, svList, start);
  wrap.append(box);
}
