// ===== Skin: bộ trang phục trọn gói =====
// Mặc skin -> thay TOÀN BỘ hình dạng nhân vật (tóc/áo/quần/mũ...) chứ không phải từng món.
// Bộ ghép từ trang phục cùng tên trong data Avatar (xem docs/ASSETS.md).

// Bậc hiếm đúng kiểu Ảo Hoá của GunPow — CHỈ để phân màu nhãn cho đẹp,
// skin không cộng chỉ số gì cả.
export type SkinRank = 'thuong' | 'dungsi' | 'suthi' | 'master';
export const SKIN_RANKS: Record<SkinRank, { name: string; color: string }> = {
  thuong: { name: 'Thường', color: '#8ce99a' },
  dungsi: { name: 'Dũng Sĩ', color: '#74c0fc' },
  suthi: { name: 'Sử Thi', color: '#cc5de8' },
  master: { name: 'Master', color: '#ffa94d' }
};

export interface SkinDef {
  id: string;
  name: string;
  gender: number;                 // 0 unisex, 1 nam, 2 nữ
  /** bộ ghép từ part Avatar — bỏ trống nếu skin dùng ảnh nguyên khối */
  parts: { hair?: number; shirt?: number; pant?: number; hat?: number; glasses?: number };
  /** skin vẽ nguyên hình (Pack4): một ảnh thay cả nhân vật */
  art?: { url: string; w: number; h: number };
  priceXu: number;
  rank?: SkinRank;
}

/** Bậc của bộ skin — bộ nào chưa ghi thì suy ra từ giá. */
export function skinRank(sk: SkinDef): SkinRank {
  if (sk.rank) return sk.rank;
  if (sk.priceXu >= 30000) return 'master';
  if (sk.priceXu >= 15000) return 'suthi';
  if (sk.priceXu >= 5000) return 'dungsi';
  return 'thuong';
}


// Skin bây giờ CHỈ có loại nguyên hình lấy từ Pack4 — mấy bộ ghép part Avatar
// cũ đã bỏ. Skin không bán ở shop, sau này phát qua sự kiện / gacha.
export const SKINS: Record<string, SkinDef> = {};

// ===== Skin nguyên hình từ Pack4 (Anime-Chibi) =====
// Mỗi bộ trong pack là một skeleton Spine; scripts/spine_pose.py dựng tư thế
// gốc ra một ảnh rồi cắt vào public/assets/skin/p4. Skin loại này KHÔNG ghép
// part Avatar mà thay nguyên hình nhân vật.
import P4 from './skins-p4.json';

const P4_SIZE = P4 as unknown as Record<string, [number, number]>;
const p4Ids = Object.keys(P4_SIZE).sort();
p4Ids.forEach((sid, i) => {
  const [w, h] = P4_SIZE[sid];
  // pack không kèm bảng tên nên đặt theo số thứ tự, giữ id gốc để tra ngược
  SKINS[`p4_${sid}`] = {
    id: `p4_${sid}`, name: `Ảo Hoá #${String(i + 1).padStart(2, '0')}`, gender: 0,
    parts: {}, art: { url: `assets/skin/p4/${sid}.webp`, w, h },
    priceXu: 0, rank: 'master'
  };
});

export const SKIN_LIST = Object.values(SKINS);
export function skinOf(id?: string): SkinDef | undefined { return id ? SKINS[id] : undefined; }

/** Ảnh nguyên hình của skin đang mặc (nếu có). */
export function skinArt(id?: string) { return id ? SKINS[id]?.art : undefined; }
