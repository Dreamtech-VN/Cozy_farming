/**
 * Đồng hồ thế giới phía client (doc 03).
 * Server là nguồn sự thật; client chỉ hỏi lại theo chu kỳ rồi tự chạy tiếp giữa
 * hai lần hỏi, nên đồng hồ không giật mà cũng không cần poll mỗi giây.
 */
export class WorldClock {
  constructor(api) {
    this.api = api;
    this.state = null;
    this.fetchedAt = 0;
  }

  async refresh(mapId) {
    this.state = await this.api.get(`/v1/world/clock?map_id=${encodeURIComponent(mapId)}`);
    this.fetchedAt = performance.now();
    return this.state;
  }

  /** Phút trong ngày ở thời điểm hiện tại, suy ra từ mốc server + thời gian đã trôi. */
  now() {
    if (!this.state) return null;
    const elapsedMs = performance.now() - this.fetchedAt;
    const minutesPerMs = 1440 / (this.state.real_minutes_per_day * 60_000);
    const minute = Math.floor((this.state.minute_of_day + elapsedMs * minutesPerMs) % 1440);
    return {
      ...this.state,
      minute_of_day: minute,
      clock: `${String(Math.floor(minute / 60)).padStart(2, '0')}:${String(minute % 60).padStart(2, '0')}`,
    };
  }
}

/** Icon theo giai đoạn trong ngày. */
export function phaseIcon(phase) {
  if (phase === 'night') {
    return `<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M20 14.5A8.5 8.5 0 0 1 9.5 4a8.5 8.5 0 1 0 10.5 10.5z" fill="#dfe9ff" stroke="#95a7cc" stroke-width="1.3" stroke-linejoin="round"/></svg>`;
  }
  if (phase === 'dawn' || phase === 'dusk') {
    const color = phase === 'dawn' ? '#ffd98a' : '#ffb072';
    return `<svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M4 17h16" stroke="#f0a35a" stroke-width="1.8" stroke-linecap="round"/>
      <path d="M12 6.5a6 6 0 0 1 6 6H6a6 6 0 0 1 6-6z" fill="${color}" stroke="#e08b3c" stroke-width="1.3" stroke-linejoin="round"/>
      <path d="M12 2.5v2M4.6 5.6l1.4 1.4M19.4 5.6 18 7" stroke="#f0a35a" stroke-width="1.6" stroke-linecap="round"/>
    </svg>`;
  }
  return `<svg viewBox="0 0 24 24" aria-hidden="true">
    <circle cx="12" cy="12" r="5" fill="#ffd45e" stroke="#e8a318" stroke-width="1.3"/>
    <g stroke="#ffd45e" stroke-width="1.8" stroke-linecap="round">
      <path d="M12 2v2.6M12 19.4V22M2 12h2.6M19.4 12H22M4.9 4.9l1.9 1.9M17.2 17.2l1.9 1.9M19.1 4.9l-1.9 1.9M6.8 17.2l-1.9 1.9"/>
    </g>
  </svg>`;
}

/** Icon theo kiểu thời tiết. */
export function weatherIcon(weather) {
  const cloud = `<path d="M7 17h9.5a3.5 3.5 0 0 0 .3-7A5.5 5.5 0 0 0 6.3 11 3 3 0 0 0 7 17z" fill="#e8eef6" stroke="#9fb0c4" stroke-width="1.3" stroke-linejoin="round"/>`;
  if (weather === 'rain') {
    return `<svg viewBox="0 0 24 24" aria-hidden="true">${cloud}
      <g stroke="#69b6e8" stroke-width="1.8" stroke-linecap="round"><path d="M9 19l-1 2.5M13 19l-1 2.5M17 19l-1 2.5"/></g></svg>`;
  }
  if (weather === 'storm') {
    return `<svg viewBox="0 0 24 24" aria-hidden="true">${cloud}
      <path d="M13 18l-3.4 4.4h2.6L11 26l4.4-5.2h-2.6z" fill="#ffd45e" stroke="#e8a318" stroke-width="1.1" stroke-linejoin="round"/>
      <g stroke="#69b6e8" stroke-width="1.7" stroke-linecap="round"><path d="M8 19l-.8 2.2M18 19l-.8 2.2"/></g></svg>`;
  }
  if (weather === 'cloudy') {
    return `<svg viewBox="0 0 24 24" aria-hidden="true">${cloud}</svg>`;
  }
  return `<svg viewBox="0 0 24 24" aria-hidden="true">
    <circle cx="12" cy="12" r="5" fill="#ffd45e" stroke="#e8a318" stroke-width="1.3"/>
    <g stroke="#ffd45e" stroke-width="1.8" stroke-linecap="round">
      <path d="M12 2v2.6M12 19.4V22M2 12h2.6M19.4 12H22M4.9 4.9l1.9 1.9M17.2 17.2l1.9 1.9M19.1 4.9l-1.9 1.9M6.8 17.2l-1.9 1.9"/>
    </g>
  </svg>`;
}
