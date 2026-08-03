// ===== Màn hình đăng nhập + chọn máy chủ (trên nền title) =====
// Bản offline: "đăng nhập" chỉ lưu tài khoản trên máy (localStorage),
// nút Google/Apple là chỗ gắn SDK thật khi có server.

import { h, root } from './kit';
import { toast } from '@/core/events';
import { GAME_VERSION, RES_VERSION_KEY } from '@/core/version';

const ACC_KEY = 'cozy_account';
const SRV_KEY = 'cozy_server';
const TOS_KEY = 'cozy_tos_ok';
const ACCOUNTS_KEY = 'cozy_accounts';   // sổ tài khoản tên/mật khẩu tạo trên máy

interface Account { type: 'account' | 'google' | 'apple' | 'facebook' | 'guest'; name: string }

// Sổ tài khoản offline: tên -> {hash mật khẩu, mã khôi phục}. hash() bên dưới
// CHỈ để chặn gõ sai mật khẩu trên máy — không phải mã hoá an toàn, vì chưa
// có server thật (theo đúng ghi chú đầu file). Khi nối server thật, thay toàn
// bộ khối account/password này bằng gọi API, form giữ nguyên không đổi.
interface StoredAccount { hash: string; recovery: string; createdAt: number }

function getAccounts(): Record<string, StoredAccount> {
  try { return JSON.parse(localStorage.getItem(ACCOUNTS_KEY) || '{}'); } catch { return {}; }
}
function saveAccounts(a: Record<string, StoredAccount>) {
  try { localStorage.setItem(ACCOUNTS_KEY, JSON.stringify(a)); } catch { /* ignore */ }
}
// djb2 — đủ để so khớp mật khẩu offline, KHÔNG dùng cho bảo mật thật
function hashPass(s: string): string {
  let h = 5381;
  for (let i = 0; i < s.length; i++) h = ((h << 5) + h + s.charCodeAt(i)) >>> 0;
  return h.toString(36);
}
// mã khôi phục dạng XXXX-XXXX, bỏ ký tự dễ nhầm (0/O, 1/I)
function genRecoveryCode(): string {
  const AB = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  const part = () => Array.from({ length: 4 }, () => AB[Math.floor(Math.random() * AB.length)]).join('');
  return `${part()}-${part()}`;
}

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
const USER_ICON = `<svg class="lg-logo" viewBox="0 0 448 512"><path fill="#fff" d="M224 256a128 128 0 1 0 0-256 128 128 0 1 0 0 256zm-45.7 48C79.8 304 0 383.8 0 482.3 0 498.7 13.3 512 29.7 512l388.6 0c16.4 0 29.7-13.3 29.7-29.7 0-98.5-79.8-178.3-178.3-178.3l-91.4 0z"/></svg>`;
const LOCK_ICON = `<svg class="lg-logo" viewBox="0 0 448 512"><path fill="#fff" d="M144 128v64H304V128c0-44.2-35.8-80-80-80s-80 35.8-80 80zM80 192V128C80 57.3 137.3 0 208 0s128 57.3 128 128v64h16c35.3 0 64 28.7 64 64V448c0 35.3-28.7 64-64 64H64c-35.3 0-64-28.7-64-64V256c0-35.3 28.7-64 64-64H80z"/></svg>`;
const FB_LOGO = `<svg class="lg-logo" viewBox="0 0 320 512"><path fill="#fff" d="M279.1 288l14.2-92.7h-88.9v-60.1c0-25.4 12.4-50.1 52.2-50.1h40.4V6.3S260.4 0 225.4 0c-73.2 0-121 44.4-121 124.7v70.6H22.9V288h81.5v224h100.2V288z"/></svg>`;
const GUEST_ICON = `<svg class="lg-logo" viewBox="0 0 640 512"><path fill="#fff" d="M480 96H160C71.6 96 0 167.6 0 256s71.6 160 160 160c38.9 0 74.5-13.9 102.3-37 12.3-10.2 27.6-15 43-15h29.4c15.4 0 30.7 4.8 43 15 27.8 23.1 63.4 37 102.3 37 88.4 0 160-71.6 160-160S568.4 96 480 96zM240 276c0 6.6-5.4 12-12 12h-52v52c0 6.6-5.4 12-12 12h-40c-6.6 0-12-5.4-12-12v-52H60c-6.6 0-12-5.4-12-12v-40c0-6.6 5.4-12 12-12h52v-52c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v52h52c6.6 0 12 5.4 12 12v40zm168 44a40 40 0 1 1 0-80 40 40 0 1 1 0 80zm64-84a40 40 0 1 1 0-80 40 40 0 1 1 0 80z"/></svg>`;
const BELL_ICON = `<svg viewBox="0 0 448 512"><path fill="#fff" d="M224 512c35.32 0 63.97-28.65 63.97-64H160.03c0 35.35 28.65 64 63.97 64zm215.39-149.71c-19.32-20.76-55.47-51.99-55.47-154.29 0-77.7-54.48-139.9-127.94-155.16V32c0-17.67-14.32-32-31.98-32s-31.98 14.33-31.98 32v20.84C118.56 68.1 64.08 130.3 64.08 208c0 102.3-36.15 133.53-55.47 154.29-6 6.45-8.66 14.16-8.61 21.71.11 16.4 12.98 32 32.1 32h383.8c19.12 0 32-15.6 32.1-32 .05-7.55-2.61-15.27-8.61-21.71z"/></svg>`;
const TRASH_ICON = `<svg viewBox="0 0 448 512"><path fill="#fff" d="M135.2 17.7L128 32H32C14.3 32 0 46.3 0 64s14.3 32 32 32h384c17.7 0 32-14.3 32-32s-14.3-32-32-32h-96l-7.2-14.3C307.4 6.8 296.3 0 284.2 0H163.8c-12.1 0-23.2 6.8-28.6 17.7zM416 128H32L53.2 467c1.6 25.3 22.6 45 47.9 45h245.8c25.3 0 46.3-19.7 47.9-45L416 128z"/></svg>`;
// mắt mở/nhắm dựng bằng hình khối cơ bản (ellipse + circle + line chéo) cho chắc ăn, không lệ thuộc path phức tạp
const EYE_ICON = `<svg viewBox="0 0 24 16" fill="none" stroke="currentColor" stroke-width="1.6"><ellipse cx="12" cy="8" rx="10.5" ry="7"/><circle cx="12" cy="8" r="3" fill="currentColor" stroke="none"/></svg>`;
const EYE_SLASH_ICON = `<svg viewBox="0 0 24 16" fill="none" stroke="currentColor" stroke-width="1.6"><ellipse cx="12" cy="8" rx="10.5" ry="7"/><circle cx="12" cy="8" r="3" fill="currentColor" stroke="none"/><line x1="2" y1="15" x2="22" y2="1"/></svg>`;

function getAccount(): Account | null {
  try { return JSON.parse(localStorage.getItem(ACC_KEY) || 'null'); } catch { return null; }
}
function setAccount(a: Account | null) {
  try { a ? localStorage.setItem(ACC_KEY, JSON.stringify(a)) : localStorage.removeItem(ACC_KEY); } catch { /* ignore */ }
}
function getServer(): string {
  try { return localStorage.getItem(SRV_KEY) || ''; } catch { return ''; }
}

// Hiện flow: cổng "Vào game" (đồng ý điều khoản) -> (đăng nhập nếu chưa có
// tài khoản) -> chọn máy chủ -> Bắt đầu. Cổng chỉ hiện 1 lần lúc mở app;
// đã có tài khoản từ trước thì bấm Vào game là sang thẳng chọn máy chủ.
export function showLoginFlow(onStart: () => void) {
  const wrap = h('div', 'login-wrap');
  root().append(wrap);
  const done = () => { wrap.remove(); onStart(); };

  // Trong lúc chưa có tài khoản: 3 màn con luân phiên (đăng nhập / đăng ký /
  // quên mật khẩu) — nhớ view hiện tại để link "Đăng ký ngay"/"Quên mật khẩu?"
  // chuyển màn tại chỗ, không văng ra ngoài.
  let authView: 'login' | 'register' | 'forgot' = 'login';

  const renderAuth = () => {
    wrap.innerHTML = '';
    wrap.classList.remove('anchor-bottom');   // form đăng nhập canh giữa; chọn server thì canh dưới (renderServer tự thêm lại)
    const acc = getAccount();
    // đăng xuất ("Đổi tài khoản") phải về lại màn đăng nhập, không kẹt ở
    // đăng ký/quên mật khẩu nếu người chơi vừa đi qua 2 màn đó trước lúc đăng nhập
    if (acc) { renderServer(wrap, acc, () => { authView = 'login'; renderAuth(); }, done); return; }
    const goto = (v: typeof authView) => { authView = v; renderAuth(); };
    const loginAs = (a: Account) => { setAccount(a); renderAuth(); };
    if (authView === 'register') renderRegister(wrap, loginAs, () => goto('login'));
    else if (authView === 'forgot') renderForgot(wrap, () => goto('login'));
    else renderLogin(wrap, loginAs, () => goto('register'), () => goto('forgot'));
  };

  renderGate(wrap, renderAuth);
}

// Cụm nút icon dọc góc phải trên: Thông báo + Xoá bộ nhớ đệm (+ Tài khoản
// tuỳ màn). Dùng chung cho cổng vào game và màn chọn máy chủ. Mỗi nút có
// chữ chú thích kế icon để không đoán mò biểu tượng.
function iconStack(wrap: HTMLElement, extra?: { icon: string; title: string; onClick: () => void }) {
  const stack = h('div', 'gate-icons');

  // chữ chú thích nằm RIÊNG bên dưới nút tròn, không dính chung khối với icon
  const mk = (icon: string, label: string, onClick: () => void) => {
    const item = h('div', 'gate-icon-item');
    const b = h('button', 'gate-icon-btn');
    b.innerHTML = icon;
    b.onclick = onClick;
    item.append(b, h('span', 'gate-icon-label', label));
    return item;
  };

  const bellBtn = mk(BELL_ICON, 'Thông báo', () => openNoticePopup());
  const trashBtn = mk(TRASH_ICON, 'Xoá bộ nhớ đệm', () => {
    try { localStorage.removeItem(RES_VERSION_KEY); } catch { /* ignore */ }
    toast('Đã xoá bộ nhớ đệm, đang tải lại...', '');
    setTimeout(() => location.reload(), 500);
  });

  stack.append(bellBtn, trashBtn);
  if (extra) stack.append(mk(extra.icon, extra.title, extra.onClick));
  wrap.append(stack);
}

function openNoticePopup() {
  const backdrop = h('div', 'sv-pop-backdrop');
  backdrop.onclick = e => { if (e.target === backdrop) backdrop.remove(); };
  const pop = h('div', 'sv-pop notice-pop');
  const head = h('div', 'sv-pop-head');
  head.append(h('div', '', 'Thông báo'));
  const close = h('button', 'win-close', '✕');
  close.onclick = () => backdrop.remove();
  head.append(close);
  const body = h('div', 'notice-body');
  body.append(
    noticeItem(`Sunny Town v${GAME_VERSION}`, 'Ra mắt hệ thú cưng, sửa lỗi cảm ứng khi chạm nhân vật/thú, thêm intro studio.'),
    noticeItem('Chào mừng đến Sunny Town!', 'Ghé nông trại, nuôi thú, đi câu cá và khám phá thị trấn cùng bạn bè.')
  );
  pop.append(head, body);
  backdrop.append(pop);
  root().append(backdrop);
}
function noticeItem(title: string, text: string): HTMLElement {
  const it = h('div', 'notice-item');
  it.append(h('div', 'notice-title', title), h('div', 'notice-text', text));
  return it;
}

// Cổng vào game: nền key art, nút Vào game to giữa dưới + ô tích điều khoản
function renderGate(wrap: HTMLElement, onEnter: () => void) {
  wrap.classList.add('anchor-bottom');
  iconStack(wrap);

  const box = h('div', 'gate-box');
  const tosOk = (() => { try { return localStorage.getItem(TOS_KEY) === '1'; } catch { return false; } })();

  const row = h('div', 'gate-tos');
  const check = h('button', `gate-check ${tosOk ? 'on' : ''}`);
  check.type = 'button';
  check.setAttribute('aria-label', 'Đồng ý điều khoản dịch vụ');
  const label = h('span', 'gate-tos-label', 'Tôi đồng ý với ');
  const link = h('a', 'gate-tos-link', 'Điều khoản dịch vụ');
  link.href = '#';
  link.onclick = (e) => { e.preventDefault(); toast('Chơi vui vẻ, chăm sóc nông trại và đối xử tốt với người chơi khác nhé!', ''); };
  label.append(link);
  check.onclick = () => {
    check.classList.toggle('on');
    try { localStorage.setItem(TOS_KEY, check.classList.contains('on') ? '1' : '0'); } catch { /* ignore */ }
  };
  row.append(check, label);

  const start = h('button', 'gate-start', 'VÀO GAME');
  start.onclick = () => {
    if (!check.classList.contains('on')) {
      check.classList.add('shake');
      setTimeout(() => check.classList.remove('shake'), 400);
      toast('Vui lòng đồng ý điều khoản dịch vụ trước khi vào game', '');
      return;
    }
    onEnter();
  };

  box.append(start, row);
  wrap.append(box);
}

// tạo cặp ô nhập chuẩn (icon + input), dùng chung cho cả 3 form login/register/forgot
function mkField(icon: string, placeholder: string, type = 'text'): [HTMLElement, HTMLInputElement] {
  const wrap = h('div', 'lg-inputwrap');
  wrap.innerHTML = icon;
  const input = h('input', 'ui-input') as HTMLInputElement;
  input.placeholder = placeholder; input.maxLength = 24; input.type = type;
  wrap.append(input);
  return [wrap, input];
}
// nút ẩn/hiện mật khẩu, gắn liền sau input password
function mkEyeBtn(pass: HTMLInputElement, wrap: HTMLElement) {
  const eyeBtn = h('button', 'lg-eye');
  eyeBtn.type = 'button';
  eyeBtn.innerHTML = EYE_ICON;
  eyeBtn.onclick = () => {
    const showing = pass.type === 'text';
    pass.type = showing ? 'password' : 'text';
    eyeBtn.innerHTML = showing ? EYE_ICON : EYE_SLASH_ICON;
  };
  wrap.append(eyeBtn);
}

function renderLogin(wrap: HTMLElement, loginAs: (a: Account) => void, goRegister: () => void, goForgot: () => void) {
  const box = h('div', 'login-box login-box2');
  const head = h('div', 'login-head2');
  head.innerHTML = '<span class="lg-arrow">»</span> Chào mừng trở lại! <span class="lg-arrow">«</span>';
  const sub = h('div', 'lg-sub', 'Đăng nhập để tiếp tục hành trình của bạn');
  const body = h('div', 'login-body');
  box.append(head, sub, body);

  const [userWrap, user] = mkField(USER_ICON, 'Tên đăng nhập');
  const [passWrap, pass] = mkField(LOCK_ICON, 'Mật khẩu', 'password');
  mkEyeBtn(pass, passWrap);

  const forgotRow = h('div', 'lg-forgot-row');
  const forgot = h('a', 'lg-forgot', 'Quên mật khẩu?');
  forgot.href = '#';
  forgot.onclick = (e) => { e.preventDefault(); goForgot(); };
  forgotRow.append(forgot);

  const err = h('div', 'lg-err', '');
  const go = h('button', 'lg-start-btn', 'ĐĂNG NHẬP');
  go.onclick = () => {
    const u = user.value.trim();
    if (!u || !pass.value) { err.textContent = 'Nhập đủ tên đăng nhập và mật khẩu'; return; }
    const acc = getAccounts()[u.toLowerCase()];
    if (!acc) { err.textContent = 'Tài khoản chưa tồn tại — bấm "Đăng ký ngay" bên dưới'; return; }
    if (acc.hash !== hashPass(pass.value)) { err.textContent = 'Sai mật khẩu'; return; }
    loginAs({ type: 'account', name: u });
  };
  [user, pass].forEach(el => el.onkeydown = e => { if (e.key === 'Enter') go.click(); });

  const orRow = h('div', 'lg-or'); orRow.innerHTML = '<span></span><b>HOẶC</b><span></span>';

  // Google / Facebook / Apple / Khách: tên tài khoản tự lấy từ hồ sơ (như SDK
  // thật trả về), bản offline: ưu tiên tên nhân vật đã lưu, chưa có thì sinh
  // tên và giữ nguyên cho lần sau
  const autoName = (type: 'google' | 'apple' | 'facebook' | 'guest'): string => {
    try {
      const sv = JSON.parse(localStorage.getItem('cozy_farming_save_v1') || 'null');
      if (sv?.player?.name) return sv.player.name;
    } catch { /* ignore */ }
    const k = `cozy_${type}_name`;
    const pfx: Record<typeof type, string> = { google: 'GG', apple: 'AP', facebook: 'FB', guest: 'KH' };
    try {
      const old = localStorage.getItem(k);
      if (old) return old;
      const n = `${pfx[type]}${Math.floor(1000 + Math.random() * 9000)}`;
      localStorage.setItem(k, n);
      return n;
    } catch {
      return `${pfx[type]}0000`;
    }
  };

  const socialRow = h('div', 'lg-social-row');
  const mkSocial = (cls: string, icon: string, title: string, type: 'google' | 'apple' | 'facebook' | 'guest') => {
    const b = h('button', `lg-social-btn ${cls}`);
    b.title = title;
    b.innerHTML = icon;
    b.onclick = () => loginAs({ type, name: autoName(type) });
    return b;
  };
  socialRow.append(
    mkSocial('lg-s-google', GOOGLE_G, 'Đăng nhập bằng Google', 'google'),
    mkSocial('lg-s-fb', FB_LOGO, 'Đăng nhập bằng Facebook', 'facebook'),
    mkSocial('lg-s-apple', APPLE_LOGO, 'Đăng nhập bằng Apple', 'apple'),
    mkSocial('lg-s-guest', GUEST_ICON, 'Chơi luôn không cần đăng nhập', 'guest')
  );

  const regRow = h('div', 'lg-note');
  regRow.append(document.createTextNode('Chưa có tài khoản? '));
  const regLink = h('a', 'gate-tos-link', 'Đăng ký ngay');
  regLink.href = '#';
  regLink.onclick = (e) => { e.preventDefault(); goRegister(); };
  regRow.append(regLink);

  body.append(userWrap, passWrap, forgotRow, err, go, orRow, socialRow, regRow);
  wrap.append(box);
}

function renderRegister(wrap: HTMLElement, loginAs: (a: Account) => void, goLogin: () => void) {
  const box = h('div', 'login-box login-box2');
  const head = h('div', 'login-head2');
  head.innerHTML = '<span class="lg-arrow">»</span> Tạo tài khoản mới <span class="lg-arrow">«</span>';
  const sub = h('div', 'lg-sub', 'Vài bước là có nông trại của riêng bạn');
  const body = h('div', 'login-body');
  box.append(head, sub, body);

  const [userWrap, user] = mkField(USER_ICON, 'Tên đăng nhập (3-24 ký tự)');
  const [passWrap, pass] = mkField(LOCK_ICON, 'Mật khẩu (tối thiểu 6 ký tự)', 'password');
  mkEyeBtn(pass, passWrap);
  const [pass2Wrap, pass2] = mkField(LOCK_ICON, 'Nhập lại mật khẩu', 'password');
  mkEyeBtn(pass2, pass2Wrap);

  const err = h('div', 'lg-err', '');
  const go = h('button', 'lg-start-btn', 'ĐĂNG KÝ');
  go.onclick = () => {
    const u = user.value.trim();
    if (u.length < 3 || u.length > 24) { err.textContent = 'Tên đăng nhập phải từ 3-24 ký tự'; return; }
    if (pass.value.length < 6) { err.textContent = 'Mật khẩu tối thiểu 6 ký tự'; return; }
    if (pass.value !== pass2.value) { err.textContent = 'Mật khẩu nhập lại không khớp'; return; }
    const accounts = getAccounts();
    const key = u.toLowerCase();
    if (accounts[key]) { err.textContent = 'Tên đăng nhập đã có người dùng — thử tên khác'; return; }
    const recovery = genRecoveryCode();
    accounts[key] = { hash: hashPass(pass.value), recovery, createdAt: Date.now() };
    saveAccounts(accounts);
    renderRecoveryReveal(wrap, u, recovery, () => loginAs({ type: 'account', name: u }));
  };
  [user, pass, pass2].forEach(el => el.onkeydown = e => { if (e.key === 'Enter') go.click(); });

  const backRow = h('div', 'lg-note');
  backRow.append(document.createTextNode('Đã có tài khoản? '));
  const backLink = h('a', 'gate-tos-link', 'Đăng nhập');
  backLink.href = '#';
  backLink.onclick = (e) => { e.preventDefault(); goLogin(); };
  backRow.append(backLink);

  body.append(userWrap, passWrap, pass2Wrap, err, go, backRow);
  wrap.append(box);
}

// Hiện đúng 1 lần ngay sau khi đăng ký: mã khôi phục dùng để lấy lại mật khẩu
// sau này (không có email/SMS thật vì chưa có server) — bắt lưu lại rồi mới cho tiếp tục.
function renderRecoveryReveal(wrap: HTMLElement, name: string, recovery: string, cont: () => void) {
  wrap.innerHTML = '';
  const box = h('div', 'login-box login-box2');
  const head = h('div', 'login-head2');
  head.innerHTML = '<span class="lg-arrow">»</span> Lưu lại mã khôi phục <span class="lg-arrow">«</span>';
  const sub = h('div', 'lg-sub', `Chào ${name}! Ghi lại mã này — dùng để lấy lại mật khẩu nếu quên, vì tài khoản chỉ lưu trên máy này.`);
  const code = h('div', 'lg-recovery-code', recovery);
  const warn = h('div', 'lg-err', 'Mất mã này = mất tài khoản, không ai khôi phục giúp được (chưa có server thật).');
  const go = h('button', 'lg-start-btn', 'TÔI ĐÃ LƯU, TIẾP TỤC');
  go.onclick = cont;
  box.append(head, sub, code, warn, go);
  wrap.append(box);
}

function renderForgot(wrap: HTMLElement, goLogin: () => void) {
  const box = h('div', 'login-box login-box2');
  const head = h('div', 'login-head2');
  head.innerHTML = '<span class="lg-arrow">»</span> Quên mật khẩu <span class="lg-arrow">«</span>';
  const sub = h('div', 'lg-sub', 'Nhập tên đăng nhập và mã khôi phục đã lưu lúc đăng ký');
  const body = h('div', 'login-body');
  box.append(head, sub, body);

  const [userWrap, user] = mkField(USER_ICON, 'Tên đăng nhập');
  const codeWrap = h('div', 'lg-inputwrap');
  const code = h('input', 'ui-input') as HTMLInputElement;
  code.placeholder = 'Mã khôi phục (VD: AB3D-9KX2)'; code.maxLength = 9;
  codeWrap.append(code);

  const err = h('div', 'lg-err', '');
  const next = h('button', 'lg-start-btn', 'XÁC NHẬN');
  next.onclick = () => {
    const u = user.value.trim();
    const accounts = getAccounts();
    const acc = accounts[u.toLowerCase()];
    if (!acc) { err.textContent = 'Tài khoản chưa tồn tại'; return; }
    if (acc.recovery.toUpperCase() !== code.value.trim().toUpperCase()) { err.textContent = 'Mã khôi phục không đúng'; return; }
    renderResetPassword(wrap, u, goLogin);
  };
  [user, code].forEach(el => el.onkeydown = e => { if (e.key === 'Enter') next.click(); });

  const backRow = h('div', 'lg-note');
  const backLink = h('a', 'gate-tos-link', '« Quay lại đăng nhập');
  backLink.href = '#';
  backLink.onclick = (e) => { e.preventDefault(); goLogin(); };
  backRow.append(backLink);

  body.append(userWrap, codeWrap, err, next, backRow);
  wrap.append(box);
}

function renderResetPassword(wrap: HTMLElement, name: string, goLogin: () => void) {
  wrap.innerHTML = '';
  const box = h('div', 'login-box login-box2');
  const head = h('div', 'login-head2');
  head.innerHTML = '<span class="lg-arrow">»</span> Đặt mật khẩu mới <span class="lg-arrow">«</span>';
  const sub = h('div', 'lg-sub', `Đặt mật khẩu mới cho ${name}`);
  const body = h('div', 'login-body');
  box.append(head, sub, body);

  const [passWrap, pass] = mkField(LOCK_ICON, 'Mật khẩu mới (tối thiểu 6 ký tự)', 'password');
  mkEyeBtn(pass, passWrap);
  const [pass2Wrap, pass2] = mkField(LOCK_ICON, 'Nhập lại mật khẩu mới', 'password');
  mkEyeBtn(pass2, pass2Wrap);

  const err = h('div', 'lg-err', '');
  const go = h('button', 'lg-start-btn', 'ĐẶT LẠI MẬT KHẨU');
  go.onclick = () => {
    if (pass.value.length < 6) { err.textContent = 'Mật khẩu tối thiểu 6 ký tự'; return; }
    if (pass.value !== pass2.value) { err.textContent = 'Mật khẩu nhập lại không khớp'; return; }
    const accounts = getAccounts();
    const key = name.toLowerCase();
    if (accounts[key]) accounts[key].hash = hashPass(pass.value);
    saveAccounts(accounts);
    toast('Đã đặt lại mật khẩu — đăng nhập lại nhé!', '');
    goLogin();
  };
  [pass, pass2].forEach(el => el.onkeydown = e => { if (e.key === 'Enter') go.click(); });

  body.append(passWrap, pass2Wrap, err, go);
  wrap.append(box);
}

function renderServer(wrap: HTMLElement, acc: Account, rerender: () => void, done: () => void) {
  wrap.classList.add('anchor-bottom');
  iconStack(wrap, {
    icon: USER_ICON, title: 'Đổi tài khoản',
    onClick: () => { setAccount(null); rerender(); }
  });

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

  // chữ khớp nút "VÀO GAME" ở cổng; khung chọn server nằm TRÊN nút (đúng thứ
  // tự thao tác: chọn server rồi mới bấm vào game).
  const start = h('button', 'lg-start', 'VÀO GAME');
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
      t.innerHTML = `<b>${c.name}</b><span>${newest ? 'Mới' : `S${c.servers[0].n}-S${c.servers[c.servers.length - 1].n}`}</span>`;
      t.onclick = () => { curCluster = c.id; paintTabs(); paintGrid(); };
      tabs.append(t);
    }
  };
  paintTabs(); paintGrid();
  root().append(backdrop);
}
