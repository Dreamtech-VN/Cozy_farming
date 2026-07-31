// ===== Ảnh đại diện dựng sẵn =====
// Pack "Cute Avatars" (craftpix.net) — 35 ảnh 128x128, xem docs/ASSETS.md.
// Người chơi cũng có thể tự tải ảnh lên (lưu dạng data URL trong save).

export const AVATAR_PICS: string[] =
  Array.from({ length: 35 }, (_, i) => String(i + 1).padStart(2, '0'));

export function avatarPicUrl(id: string): string {
  return `assets/avatar/${id}.png`;
}

// Giá trị lưu trong save.player.avatarPic:
//   'pack:07'   -> ảnh trong pack
//   'data:...'  -> ảnh người chơi tự tải lên
export function isUploadedPic(v: string | undefined): boolean {
  return !!v && v.startsWith('data:');
}
export function picSrc(v: string): string {
  return v.startsWith('pack:') ? avatarPicUrl(v.slice(5)) : v;
}
