/**
 * Thiết lập máy khách (doc 12 — người chơi tự chỉnh được trải nghiệm).
 *
 * Lưu ở localStorage vì đây là lựa chọn của TỪNG máy, không phải state của tài
 * khoản: cùng một tài khoản chơi trên máy yếu và máy mạnh cần mức đồ hoạ khác
 * nhau. Ngôn ngữ cũng vậy nên để chung ở đây.
 */
const KEY = 'cozy.settings.v1';

export const GRAPHICS_PRESETS = {
  low: { label: 'Thấp', maxDpr: 1, weather: false, otherNames: false, fpsCap: 30 },
  medium: { label: 'Vừa', maxDpr: 1.5, weather: true, otherNames: true, fpsCap: 60 },
  high: { label: 'Cao', maxDpr: 2, weather: true, otherNames: true, fpsCap: 60 },
};

const DEFAULTS = {
  graphics: { preset: 'high', weather: true, otherNames: true, fpsCap: 60 },
  audio: { master: 0.8, music: 0.6, sfx: 0.8, muted: false },
  locale: 'vi',
};

const clamp01 = (n, fallback) => (Number.isFinite(n) ? Math.min(1, Math.max(0, n)) : fallback);

function sanitize(raw) {
  const graphics = { ...DEFAULTS.graphics, ...(raw?.graphics ?? {}) };
  if (!GRAPHICS_PRESETS[graphics.preset]) graphics.preset = DEFAULTS.graphics.preset;
  graphics.weather = graphics.weather !== false;
  graphics.otherNames = graphics.otherNames !== false;
  graphics.fpsCap = graphics.fpsCap === 30 ? 30 : 60;

  const audio = { ...DEFAULTS.audio, ...(raw?.audio ?? {}) };
  audio.master = clamp01(audio.master, DEFAULTS.audio.master);
  audio.music = clamp01(audio.music, DEFAULTS.audio.music);
  audio.sfx = clamp01(audio.sfx, DEFAULTS.audio.sfx);
  audio.muted = audio.muted === true;

  return { graphics, audio, locale: raw?.locale === 'en' ? 'en' : 'vi' };
}

class Settings extends EventTarget {
  constructor() {
    super();
    let raw = null;
    try { raw = JSON.parse(localStorage.getItem(KEY) ?? 'null'); } catch { /* storage bị chặn */ }
    this.value = sanitize(raw);
  }

  /** Preset chỉ là điểm khởi đầu; ba công tắc bên dưới vẫn chỉnh riêng được. */
  applyPreset(preset) {
    const spec = GRAPHICS_PRESETS[preset];
    if (!spec) return;
    this.patch({ graphics: { preset, weather: spec.weather, otherNames: spec.otherNames, fpsCap: spec.fpsCap } });
  }

  get maxDpr() { return GRAPHICS_PRESETS[this.value.graphics.preset].maxDpr; }

  patch(partial) {
    this.value = sanitize({
      ...this.value,
      ...partial,
      graphics: { ...this.value.graphics, ...(partial.graphics ?? {}) },
      audio: { ...this.value.audio, ...(partial.audio ?? {}) },
    });
    try { localStorage.setItem(KEY, JSON.stringify(this.value)); } catch { /* bỏ qua */ }
    this.dispatchEvent(new CustomEvent('change', { detail: this.value }));
  }
}

export const settings = new Settings();
