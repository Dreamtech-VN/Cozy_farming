// ===== Màn hình đăng nhập + chọn máy chủ (trên nền title) =====
// Bản offline: "đăng nhập" chỉ lưu tài khoản trên máy (localStorage),
// nút Google/Apple là chỗ gắn SDK thật khi có server.

import { h, root } from './kit';

const ACC_KEY = 'cozy_account';
const SRV_KEY = 'cozy_server';

interface Account { type: 'account' | 'google' | 'apple'; name: string }

export interface ServerDef { id: string; n: number; name: string; status: 'new' | 'normal' | 'full' }
export interface ClusterDef { id: number; name: string; servers: ServerDef[] }

// Danh sách máy chủ chia cụm, mỗi cụm tối đa 20 server (mock — sau này lấy từ server)
const SV_NAMES = ['Nông Trại Xanh', 'Đồng Cỏ Hoa', 'Hồ Sen', 'Vườn Đào', 'Suối Mơ', 'Rừng Thông', 'Bãi Dâu', 'Cánh Diều', 'Trăng Non', 'Gió Đồng', 'Nắng Mai', 'Mưa Ngâu', 'Hoa Cải', 'Lúa Vàng', 'Cầu Vồng', 'Sao Đêm', 'Mây Trắng', 'Chuồn Chuồn', 'Đom Đóm', 'Hương Quê'];
const TOTAL_SERVERS = 48;
export const CLUSTERS: ClusterDef[] = [];
for (let n = 1; n <= TOTAL_SERVERS; n++) {
  const ci = Math.floor((n - 1) / 20);
  if (!CLUSTERS[ci]) CLUSTERS[ci] = { id: ci + 1, name: `Cụm ${ci + 1}`, servers: [] };
  const status: ServerDef['status'] = n > TOTAL_SERVERS - 2 ? 'new' : ci === 0 ? 'full' : 'normal';
  CLUSTERS[ci].servers.push({ id: `s${n}`, n, name: `S${n} - ${SV_NAMES[(n - 1) % SV_NAMES.length]}`, status });
}
export const SERVERS: ServerDef[] = CLUSTERS.flatMap(c => c.servers);
const STATUS_LBL: Record<ServerDef['status'], [string, string]> = {
  new: ['Mới', '#51cf66'], normal: ['Ổn định', '#ffd43b'], full: ['Đông', '#ff8787']
};

// SVG logo chính chủ (nhúng thẳng để không phụ thuộc mạng, nét trên mọi màn hình)
const GOOGLE_G = `<svg class="lg-logo" viewBox="0 0 48 48"><path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/><path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/><path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/><path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/></svg>`;
const APPLE_LOGO = `<svg class="lg-logo" viewBox="0 0 384 512"><path fill="#fff" d="M318.7 268.7c-.2-36.7 16.4-64.4 50-84.8-18.8-26.9-47.2-41.7-84.7-44.6-35.5-2.8-74.3 20.7-88.5 20.7-15 0-49.4-19.7-76.4-19.7C63.3 141.2 4 184.8 4 273.5q0 39.3 14.4 81.2c12.8 36.7 59 126.7 107.2 125.2 25.2-.6 43-17.9 75.8-17.9 31.8 0 48.3 17.9 76.4 17.9 48.6-.7 90.4-82.5 102.6-119.3-65.2-30.7-61.7-90-61.7-91.9zm-56.6-164.2c27.3-32.4 24.8-61.9 24-72.5-24.1 1.4-52 16.4-67.9 34.9-17.5 19.8-27.8 44.3-25.6 71.9 26.1 2 49.9-11.4 69.5-34.3z"/></svg>`;

function getAccount(): Account | null {
  try { return JSON.parse(localStorage.getItem(ACC_KEY) || 'null'); } catch { return null; }
}
function setAccount(a: Account | null) {
  try { a ? localStorage.setItem(ACC_KEY, JSON.stringify(a)) : localStorage.removeItem(ACC_KEY); } catch { /* ignore */ }
}
function getServer(): string {
  try { return localStorage.getItem(SRV_KEY) || ''; } catch { return ''; }
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

  // nút Google / Apple theo đúng style nút đăng nhập chính chủ
  const ggBtn = h('button', 'lg-btn lg-google');
  ggBtn.innerHTML = `${GOOGLE_G}<span>Đăng nhập bằng Google</span>`;
  ggBtn.onclick = () => loginAs({ type: 'google', name: 'Người chơi Google' });

  const apBtn = h('button', 'lg-btn lg-apple');
  apBtn.innerHTML = `${APPLE_LOGO}<span>Đăng nhập bằng Apple</span>`;
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

  // server mới nhất làm mặc định cho người chưa chọn
  let picked = getServer();
  if (!SERVERS.some(s => s.id === picked)) picked = SERVERS[SERVERS.length - 1].id;

  const svRow = h('div', 'sv-row');
  const paint = () => {
    const cur = SERVERS.find(s => s.id === picked) || SERVERS[0];
    const [, color] = STATUS_LBL[cur.status];
    svRow.innerHTML = `<span class="sv-dot" style="background:${color}"></span><span class="sv-name">${cur.name}</span><span class="sv-change">Nhấp đổi</span>`;
  };
  svRow.onclick = () => openServerPopup(picked, id => {
    picked = id;
    try { localStorage.setItem(SRV_KEY, picked); } catch { /* ignore */ }
    paint();
  });
  paint();

  const start = h('button', 'lg-start', 'Bắt đầu');
  start.onclick = done;

  box.append(svRow, start);
  wrap.append(box);
}

// Popup chọn máy chủ: trái là cột tab cụm (mới trên, cũ dưới), phải là lưới tối đa 20 server của cụm
function openServerPopup(picked: string, onPick: (id: string) => void) {
  const backdrop = h('div', 'sv-pop-backdrop');
  backdrop.onclick = e => { if (e.target === backdrop) backdrop.remove(); };
  const pop = h('div', 'sv-pop');
  backdrop.append(pop);

  const head = h('div', 'sv-pop-head');
  head.append(h('div', '', 'Chọn máy chủ'));
  const close = h('button', 'win-close', '✕');
  close.onclick = () => backdrop.remove();
  head.append(close);

  const bodyRow = h('div', 'sv-pop-body');
  const tabs = h('div', 'sv-tabs');
  const grid = h('div', 'sv-grid');
  bodyRow.append(tabs, grid);
  pop.append(head, bodyRow);

  // cụm chứa server đang chọn mở trước; danh sách tab: cụm mới nằm trên
  let curCluster = CLUSTERS.find(c => c.servers.some(s => s.id === picked))?.id ?? CLUSTERS[CLUSTERS.length - 1].id;

  const paintGrid = () => {
    grid.innerHTML = '';
    const c = CLUSTERS.find(x => x.id === curCluster)!;
    for (const s of c.servers) {
      const [lbl, color] = STATUS_LBL[s.status];
      const it = h('div', `sv-cell ${s.id === picked ? 'active' : ''}`);
      it.innerHTML = `<span class="sv-dot" style="background:${color}"></span><span class="sv-name">${s.name}</span><span class="sv-tag" style="color:${color}">${lbl}</span>`;
      it.onclick = () => { onPick(s.id); backdrop.remove(); };
      grid.append(it);
    }
  };
  const paintTabs = () => {
    tabs.innerHTML = '';
    for (const c of [...CLUSTERS].reverse()) {  // mới trên, cũ dưới
      const newest = c.id === CLUSTERS.length;
      const t = h('div', `sv-tab ${c.id === curCluster ? 'active' : ''}`);
      t.innerHTML = `<b>${c.name}</b><span>${newest ? '✨ Mới' : `S${c.servers[0].n}-S${c.servers[c.servers.length - 1].n}`}</span>`;
      t.onclick = () => { curCluster = c.id; paintTabs(); paintGrid(); };
      tabs.append(t);
    }
  };
  paintTabs(); paintGrid();
  root().append(backdrop);
}
