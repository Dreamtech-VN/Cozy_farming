/**
 * Đồng hồ thế giới và thời tiết (doc 03 — weather/day-night flags của map).
 *
 * Hai thứ này phải giống nhau với mọi người chơi trong cùng một khu, nên chúng
 * được SUY RA từ thời gian thật chứ không lưu state: cùng một mốc thời gian và
 * cùng map_id thì luôn ra cùng kết quả. Không có bảng nào phải ghi, không có gì
 * để lệch giữa các tiến trình khi scale ngang.
 */
import { createRng } from '../lib/rng.js';

const MINUTES_PER_DAY = 1440;

/** Phút thứ mấy trong ngày game, ứng với thời điểm thật `now`. */
export function minuteOfDay(cycle, now) {
  const cycleMs = cycle.real_minutes_per_day * 60_000;
  return Math.floor(((now % cycleMs) / cycleMs) * MINUTES_PER_DAY);
}

/** Giai đoạn trong ngày. `to` nhỏ hơn `from` nghĩa là khoảng vắt qua nửa đêm. */
export function phaseAt(cycle, minute) {
  for (const phase of cycle.phases) {
    const wraps = phase.to <= phase.from;
    const inside = wraps
      ? minute >= phase.from || minute < phase.to
      : minute >= phase.from && minute < phase.to;
    if (inside) return phase;
  }
  return cycle.phases[0];
}

/** Số phút còn lại của giai đoạn hiện tại. */
function minutesLeftInPhase(phase, minute) {
  const left = (phase.to - minute + MINUTES_PER_DAY) % MINUTES_PER_DAY;
  return left === 0 ? MINUTES_PER_DAY : left;
}

const hashString = (value) => {
  let hash = 2166136261;
  for (const ch of value) hash = Math.imul(hash ^ ch.charCodeAt(0), 16777619);
  return hash >>> 0;
};

/** Bốc thời tiết theo trọng số, xác định từ (map_id, số thứ tự lát thời gian). */
export function weatherAt(config, mapId, now) {
  const slotMs = config.slot_minutes * 60_000;
  const slot = Math.floor(now / slotMs);
  const rng = createRng((hashString(`${mapId}#${slot}`)) >>> 0);

  const total = config.types.reduce((sum, type) => sum + type.weight, 0);
  let roll = rng() * total;
  let picked = config.types[config.types.length - 1];
  for (const type of config.types) {
    roll -= type.weight;
    if (roll <= 0) { picked = type; break; }
  }
  return {
    ...picked,
    slot,
    seconds_left: Math.ceil((slotMs - (now % slotMs)) / 1000),
  };
}

/** Trạng thái thế giới đầy đủ cho một map tại một thời điểm. */
export function worldState(content, mapId, now = Date.now()) {
  const cycle = content.world.day_cycle;
  const minute = minuteOfDay(cycle, now);
  const phase = phaseAt(cycle, minute);
  const weather = weatherAt(content.world.weather, mapId, now);

  return {
    server_time: now,
    /** Nhịp một ngày game, để client tự chạy đồng hồ giữa hai lần hỏi server. */
    real_minutes_per_day: cycle.real_minutes_per_day,
    minute_of_day: minute,
    clock: `${String(Math.floor(minute / 60)).padStart(2, '0')}:${String(minute % 60).padStart(2, '0')}`,
    phase: phase.id,
    phase_name_key: phase.name_key,
    is_night: phase.id === 'night',
    phase_minutes_left: minutesLeftInPhase(phase, minute),
    weather: {
      id: weather.id,
      name_key: weather.name_key,
      seconds_left: weather.seconds_left,
    },
  };
}
