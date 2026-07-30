import { S } from './save';

// Âm thanh tổng hợp bằng WebAudio (chưa có file nhạc trong asset pack).
// Khi mua thêm pack nhạc, thay bằng Phaser sound — API giữ nguyên.
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

export const sfx = {
  click: () => beep(660, 0.05, 'square', 0.05),
  coin: () => { beep(880, 0.07, 'triangle'); setTimeout(() => beep(1320, 0.1, 'triangle'), 60); },
  plant: () => beep(330, 0.09, 'sine'),
  water: () => beep(440, 0.15, 'sine', 0.05),
  harvest: () => { beep(523, 0.07); setTimeout(() => beep(659, 0.07), 70); setTimeout(() => beep(784, 0.12), 140); },
  error: () => beep(180, 0.15, 'sawtooth', 0.06),
  splash: () => beep(240, 0.2, 'sine', 0.07),
  win: () => [523, 659, 784, 1047].forEach((f, i) => setTimeout(() => beep(f, 0.12, 'triangle'), i * 110)),
  lose: () => [400, 350, 300].forEach((f, i) => setTimeout(() => beep(f, 0.15, 'sawtooth', 0.05), i * 130))
};

// Nhạc nền ambient nhẹ bằng oscillator (placeholder)
let bgmNodes: { stop(): void } | undefined;
export function startBgm() {
  if (!S.settings.music || bgmNodes) return;
  try {
    const a = ac();
    const g = a.createGain();
    g.gain.value = 0.02;
    g.connect(a.destination);
    const notes = [261.6, 329.6, 392.0, 523.3, 392.0, 329.6];
    let i = 0;
    const timer = window.setInterval(() => {
      if (!S.settings.music) return;
      const o = a.createOscillator();
      const eg = a.createGain();
      o.type = 'sine'; o.frequency.value = notes[i % notes.length] / 2;
      eg.gain.setValueAtTime(0.9, a.currentTime);
      eg.gain.exponentialRampToValueAtTime(0.001, a.currentTime + 1.8);
      o.connect(eg).connect(g);
      o.start(); o.stop(a.currentTime + 1.9);
      i++;
    }, 2000);
    bgmNodes = { stop: () => { window.clearInterval(timer); g.disconnect(); } };
  } catch { /* ignore */ }
}
export function stopBgm() {
  bgmNodes?.stop(); bgmNodes = undefined;
}
