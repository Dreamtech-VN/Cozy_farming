import { S } from './save';

// Âm thanh dùng file .ogg lấy từ repo Lttt (xem docs/ASSETS.md).
// Pack2 (SuperRetroRanch) KHÔNG kèm âm thanh — chỉ có crops/icons/water.
// Trình duyệt chặn phát tiếng trước khi người dùng chạm màn hình, nên phần
// tổng hợp bằng WebAudio vẫn giữ lại làm phương án dự phòng khi file lỗi.
let ctx: AudioContext | undefined;
function ac(): AudioContext {
  if (!ctx) ctx = new AudioContext();
  return ctx;
}

function beep(freq: number, dur = 0.08, type: OscillatorType = 'sine', gain = 0.08) {
  if (!S.settings.sfx) return;
  try {
    const a = ac();
    const o = a.createOscillator();
    const g = a.createGain();
    o.type = type; o.frequency.value = freq;
    g.gain.setValueAtTime(gain, a.currentTime);
    g.gain.exponentialRampToValueAtTime(0.0001, a.currentTime + dur);
    o.connect(g).connect(a.destination);
    o.start(); o.stop(a.currentTime + dur);
  } catch { /* audio bị chặn trước khi user tương tác */ }
}

// ===== Hiệu ứng bằng file =====
const SFX_URL: Record<string, string> = {
  click: 'assets/sfx/click.ogg',
  coin: 'assets/sfx/coin.ogg',
  plant: 'assets/sfx/plant.ogg',
  water: 'assets/sfx/water.ogg',
  harvest: 'assets/sfx/harvest.ogg',
  buy: 'assets/sfx/buy.ogg',
  fish: 'assets/sfx/fish.ogg',
  splash: 'assets/sfx/splash.ogg',
  chicken: 'assets/sfx/chicken.ogg',
  cow: 'assets/sfx/cow.ogg',
  pig: 'assets/sfx/pig.ogg',
  dog: 'assets/sfx/dog.ogg'
};

const buffers: Record<string, AudioBuffer> = {};
const failed = new Set<string>();

// Tải sẵn toàn bộ hiệu ứng (file nhỏ, tổng ~170KB) để bấm là kêu ngay.
export async function preloadSfx(): Promise<void> {
  await Promise.all(Object.entries(SFX_URL).map(async ([k, url]) => {
    try {
      const res = await fetch(url);
      if (!res.ok) throw new Error(String(res.status));
      buffers[k] = await ac().decodeAudioData(await res.arrayBuffer());
    } catch {
      failed.add(k);   // thiếu file -> dùng beep thay
    }
  }));
}

function playFile(key: string, vol = 0.7): boolean {
  if (!S.settings.sfx || !buffers[key]) return false;
  try {
    const a = ac();
    if (a.state === 'suspended') void a.resume();
    const src = a.createBufferSource();
    const g = a.createGain();
    g.gain.value = vol;
    src.buffer = buffers[key];
    src.connect(g).connect(a.destination);
    src.start();
    return true;
  } catch {
    return false;
  }
}

export const sfx = {
  click: () => { if (!playFile('click', 0.5)) beep(660, 0.05, 'square', 0.05); },
  coin: () => {
    if (playFile('coin')) return;
    beep(880, 0.07, 'triangle'); setTimeout(() => beep(1320, 0.1, 'triangle'), 60);
  },
  buy: () => { if (!playFile('buy')) beep(880, 0.09, 'triangle'); },
  plant: () => { if (!playFile('plant')) beep(330, 0.09, 'sine'); },
  water: () => { if (!playFile('water')) beep(440, 0.15, 'sine', 0.05); },
  harvest: () => {
    if (playFile('harvest')) return;
    beep(523, 0.07); setTimeout(() => beep(659, 0.07), 70); setTimeout(() => beep(784, 0.12), 140);
  },
  fish: () => { if (!playFile('fish')) beep(523, 0.1, 'triangle'); },
  splash: () => { if (!playFile('splash')) beep(240, 0.2, 'sine', 0.07); },
  chicken: () => playFile('chicken'),
  cow: () => playFile('cow'),
  pig: () => playFile('pig'),
  dog: () => playFile('dog'),
  error: () => beep(180, 0.15, 'sawtooth', 0.06),
  win: () => [523, 659, 784, 1047].forEach((f, i) => setTimeout(() => beep(f, 0.12, 'triangle'), i * 110)),
  lose: () => [400, 350, 300].forEach((f, i) => setTimeout(() => beep(f, 0.15, 'sawtooth', 0.05), i * 130))
};

// ===== Nhạc nền theo khu =====
const BGM_URL: Record<string, string> = {
  town: 'assets/bgm/town.ogg',
  house: 'assets/bgm/house.ogg',
  shop: 'assets/bgm/shop.ogg',
  pond: 'assets/bgm/pond.ogg'
};

let bgmEl: HTMLAudioElement | undefined;
let bgmKey = '';

export function playBgm(key: string) {
  if (!BGM_URL[key]) return;
  if (bgmKey === key && bgmEl && !bgmEl.paused) return;
  stopBgm();
  if (!S.settings.music) { bgmKey = key; return; }
  try {
    const el = new Audio(BGM_URL[key]);
    el.loop = true;
    el.volume = 0.35;
    void el.play().catch(() => { /* chờ user chạm màn hình */ });
    bgmEl = el;
    bgmKey = key;
  } catch { /* ignore */ }
}

export function startBgm() { playBgm(bgmKey || 'town'); }

// Mỗi khu một nền nhạc; khu chưa có nhạc riêng thì dùng nhạc thị trấn.
const ZONE_BGM: Record<string, string> = {
  pond: 'pond', beach: 'pond',
  house: 'house', school: 'house',
  town: 'town', mall: 'shop', gamecenter: 'shop'
};
export function bgmForZone(zoneId: string) {
  playBgm(ZONE_BGM[zoneId] ?? 'town');
}

export function stopBgm() {
  if (bgmEl) { bgmEl.pause(); bgmEl.src = ''; }
  bgmEl = undefined;
}
