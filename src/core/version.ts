// Phiên bản game — đổi số này khi update để client "tải lại tài nguyên"
export const GAME_VERSION = '0.3.0';
export const RES_VERSION_KEY = 'cozy_res_v';

// đã tải tài nguyên cho phiên bản này chưa (người chơi cũ + không update -> tải nhanh)
export function resFresh(): boolean {
  try { return localStorage.getItem(RES_VERSION_KEY) === GAME_VERSION; } catch { return false; }
}
export function markResLoaded() {
  try { localStorage.setItem(RES_VERSION_KEY, GAME_VERSION); } catch { /* ignore */ }
}
