// ===== Skin: bộ trang phục trọn gói =====
// Mặc skin -> thay TOÀN BỘ hình dạng nhân vật (tóc/áo/quần/mũ...) chứ không phải từng món.
// Bộ ghép từ trang phục cùng tên trong data Avatar (xem docs/ASSETS.md).

export interface SkinDef {
  id: string;
  name: string;
  gender: number;                 // 0 unisex, 1 nam, 2 nữ
  parts: { hair?: number; shirt?: number; pant?: number; hat?: number; glasses?: number };
  priceXu: number;
}

export const SKINS: Record<string, SkinDef> = {
  hon_nhien: { id: 'hon_nhien', name: 'Hồn Nhiên', gender: 2, parts: { hair: 76, shirt: 77, pant: 78 }, priceXu: 1200 },
  sanh_ieu: { id: 'sanh_ieu', name: 'Sành Điệu', gender: 1, parts: { hair: 52, shirt: 53, pant: 54 }, priceXu: 25800 },
  quy_toc: { id: 'quy_toc', name: 'Quý Tộc', gender: 1, parts: { hair: 37, shirt: 38, pant: 39 }, priceXu: 6500 },
  lolita_diu_dang: { id: 'lolita_diu_dang', name: 'Lolita Dịu Dàng', gender: 2, parts: { hair: 114, shirt: 119, pant: 120 }, priceXu: 38500 },
  cong_chua_suong_mai: { id: 'cong_chua_suong_mai', name: 'Công Chúa Sương Mai', gender: 2, parts: { shirt: 691, pant: 692, hair: 693 }, priceXu: 1200 },
  vo_si: { id: 'vo_si', name: 'Võ Sĩ', gender: 1, parts: { hair: 58, shirt: 59, pant: 60 }, priceXu: 500 },
  samurai: { id: 'samurai', name: 'Samurai', gender: 0, parts: { hair: 70, shirt: 71, pant: 72 }, priceXu: 7000 },
  hiep_si: { id: 'hiep_si', name: 'Hiệp Sĩ', gender: 1, parts: { hair: 73, shirt: 74, pant: 75 }, priceXu: 21500 },
  hoang_tu_bong_em: { id: 'hoang_tu_bong_em', name: 'Hoàng Tử Bóng Đêm', gender: 1, parts: { shirt: 695, pant: 696, hair: 697 }, priceXu: 1200 },
  songoku: { id: 'songoku', name: 'Songoku', gender: 0, parts: { hair: 308, shirt: 309, pant: 310 }, priceXu: 500 },
};

export const SKIN_LIST = Object.values(SKINS);
export function skinOf(id?: string): SkinDef | undefined { return id ? SKINS[id] : undefined; }
