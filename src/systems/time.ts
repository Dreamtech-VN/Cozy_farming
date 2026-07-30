import { bus, EV } from '@/core/events';

// ===== Ngày/đêm + thời tiết + mùa =====
// Chu kỳ ngày trong game = 24 phút thực (1 phút thực = 1 giờ game).

export type Weather = 'sunny' | 'rain' | 'cloudy';

let weather: Weather = 'sunny';
let weatherTimer = 0;

export function gameHour(): number {
  const mins = Date.now() / 60_000;
  return (8 + mins) % 24; // bắt đầu buổi sáng
}

export function isNight(): boolean {
  const h = gameHour();
  return h >= 19 || h < 5;
}

// 0 = giữa trưa sáng rực, 1 = nửa đêm tối nhất
export function darkness(): number {
  const h = gameHour();
  if (h >= 7 && h < 17) return 0;
  if (h >= 17 && h < 20) return (h - 17) / 3 * 0.7;
  if (h >= 5 && h < 7) return (7 - h) / 2 * 0.7;
  return 0.7;
}

export function currentWeather(): Weather { return weather; }

export function season(): { id: string; name: string; icon: string } {
  const m = new Date().getMonth() + 1;
  if (m >= 3 && m <= 5) return { id: 'spring', name: 'Xuân', icon: 'w_flower' };
  if (m >= 6 && m <= 8) return { id: 'summer', name: 'Hạ', icon: 'w_sunny' };
  if (m >= 9 && m <= 11) return { id: 'fall', name: 'Thu', icon: 'w_leaf' };
  return { id: 'winter', name: 'Đông', icon: 'w_snow' };
}

export function initTime() {
  rollWeather();
  window.setInterval(() => {
    weatherTimer++;
    if (weatherTimer >= 5) { weatherTimer = 0; rollWeather(); }
    bus.emit(EV.TIME_TICK);
  }, 60_000);
}

function rollWeather() {
  const r = Math.random();
  const next: Weather = r < 0.6 ? 'sunny' : r < 0.85 ? 'cloudy' : 'rain';
  if (next !== weather) {
    weather = next;
    bus.emit(EV.TIME_TICK);
  }
}

// tên icon (xem ICON_SRC trong ui/kit.ts) — không dùng emoji
export const WEATHER_ICON: Record<Weather, string> = { sunny: 'w_sunny', rain: 'w_rain', cloudy: 'w_cloudy' };
