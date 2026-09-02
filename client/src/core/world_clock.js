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

/**
 * Icon theo kiểu thời tiết.
 * Cần biết cả giai đoạn trong ngày: "trời quang" ban đêm mà vẽ mặt trời thì chip
 * đọc ra mâu thuẫn với chính con số giờ ngay bên cạnh.
 */
export function weatherIcon(weather, phase = 'day') {
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
  // Trời quang: ban đêm là trăng và sao, còn lại là mặt trời.
  if (phase === 'night') {
    return `<svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M20 14.5A8.5 8.5 0 0 1 9.5 4a8.5 8.5 0 1 0 10.5 10.5z" fill="#dfe9ff" stroke="#95a7cc" stroke-width="1.3" stroke-linejoin="round"/>
      <g fill="#fff3b0"><circle cx="18.5" cy="5.5" r="1.3"/><circle cx="21" cy="9.5" r="1"/></g>
    </svg>`;
  }
  return `<svg viewBox="0 0 24 24" aria-hidden="true">
    <circle cx="12" cy="12" r="5" fill="#ffd45e" stroke="#e8a318" stroke-width="1.3"/>
    <g stroke="#ffd45e" stroke-width="1.8" stroke-linecap="round">
      <path d="M12 2v2.6M12 19.4V22M2 12h2.6M19.4 12H22M4.9 4.9l1.9 1.9M17.2 17.2l1.9 1.9M19.1 4.9l-1.9 1.9M6.8 17.2l-1.9 1.9"/>
    </g>
  </svg>`;
}
