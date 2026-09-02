/** Localization theo key (doc 23). Không hard-code text gameplay trong code. */
export class I18n {
  constructor() {
    this.locale = 'vi';
    this.strings = {};
    this.fallback = {};
  }

  async load(api, locale) {
    const table = await api.get(`/v1/locales/${locale}`);
    this.locale = table.locale;
    this.strings = table.strings;
    if (locale !== 'vi') {
      try { this.fallback = (await api.get('/v1/locales/vi')).strings; } catch { this.fallback = {}; }
    }
  }

  t(key, params = {}) {
    if (!key) return '';
    const template = this.strings[key] ?? this.fallback[key] ?? key;
    return template.replace(/\{(\w+)\}/g, (_, name) => (name in params ? String(params[name]) : `{${name}}`));
  }
}

export const i18n = new I18n();
export const t = (key, params) => i18n.t(key, params);

/** Định dạng thời gian còn lại cho cây trồng / cooldown. */
export function formatDuration(seconds) {
  if (seconds <= 0) return '0s';
  const h = Math.floor(seconds / 3600);
  const m = Math.floor((seconds % 3600) / 60);
  const s = Math.floor(seconds % 60);
  if (h > 0) return `${h}h ${m}m`;
  if (m > 0) return `${m}m ${s}s`;
  return `${s}s`;
}

export const formatNumber = (value) => new Intl.NumberFormat('vi-VN').format(Math.round(value));
