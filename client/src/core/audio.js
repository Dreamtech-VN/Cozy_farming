/**
 * Bus âm thanh (doc 12). Game chưa có file nhạc/hiệu ứng nào, nên bus này tự
 * tổng hợp tiếng bằng WebAudio: không cần asset mà thanh âm lượng vẫn điều
 * khiển tiếng thật, và khi có file thật thì chỉ việc nối vào đúng gain node.
 *
 * AudioContext chỉ được tạo sau thao tác đầu tiên của người dùng — trình duyệt
 * chặn phát tiếng trước đó.
 */
import { settings } from './settings.js';

class AudioBus {
  constructor() {
    this.ctx = null;
    settings.addEventListener('change', () => this.#applyVolumes());
  }

  #ensure() {
    if (this.ctx) return this.ctx;
    const Ctor = globalThis.AudioContext ?? globalThis.webkitAudioContext;
    if (!Ctor) return null;
    this.ctx = new Ctor();
    this.master = this.ctx.createGain();
    this.master.connect(this.ctx.destination);
    this.music = this.ctx.createGain();
    this.sfx = this.ctx.createGain();
    this.music.connect(this.master);
    this.sfx.connect(this.master);
    this.#applyVolumes();
    return this.ctx;
  }

  #applyVolumes() {
    if (!this.ctx) return;
    const { master, music, sfx, muted } = settings.value.audio;
    this.master.gain.value = muted ? 0 : master;
    this.music.gain.value = music;
    this.sfx.gain.value = sfx;
  }

  /** Một tiếng "tick" ngắn cho thao tác giao diện. */
  click() { this.#blip(660, 0.06, 'sfx'); }
  /** Tiếng báo tích cực: nhận thưởng, mua bán thành công. */
  success() { this.#blip(880, 0.12, 'sfx'); }
  /** Nghe thử khi kéo thanh âm lượng nhạc. */
  previewMusic() { this.#blip(440, 0.3, 'music'); }

  #blip(frequency, seconds, channel) {
    const ctx = this.#ensure();
    if (!ctx || settings.value.audio.muted) return;
    if (ctx.state === 'suspended') ctx.resume();

    const osc = ctx.createOscillator();
    const env = ctx.createGain();
    osc.type = 'sine';
    osc.frequency.value = frequency;
    // Bao biên độ tắt dần, không thì nghe ra tiếng "cụp" ở cuối nốt.
    env.gain.setValueAtTime(0.0001, ctx.currentTime);
    env.gain.exponentialRampToValueAtTime(0.3, ctx.currentTime + 0.01);
    env.gain.exponentialRampToValueAtTime(0.0001, ctx.currentTime + seconds);
    osc.connect(env);
    env.connect(channel === 'music' ? this.music : this.sfx);
    osc.start();
    osc.stop(ctx.currentTime + seconds + 0.02);
  }
}

export const audio = new AudioBus();
