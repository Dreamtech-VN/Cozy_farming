// ===== Nông cụ trang bị trên thanh nhanh (hotbar) =====
// Cuốc / bình tưới / rìu / liềm dùng Cloverframe Cozy Farm pack (assets/farm/cf).
// Cần câu / vợt / xẻng vẫn dùng icon style chibi Avatar (xem docs/ASSETS.md).

export interface ToolDef {
  id: string;
  name: string;
  icon: string;            // emoji dự phòng
  url: string;             // icon chibi
  w: number;               // kích thước ảnh icon
  h: number;
}

export const TOOLS: Record<string, ToolDef> = {
  hoe: { id: 'hoe', name: 'Cuốc', icon: '', url: 'assets/farm/chibi/18_hoe.png', w: 52, h: 62 },
  can: { id: 'can', name: 'Bình tưới', icon: '', url: 'assets/farm/chibi/17_watering_can.png', w: 62, h: 50 },
  basket: { id: 'basket', name: 'Giỏ thu hoạch', icon: '', url: 'assets/farm/chibi/19_sickle.png', w: 50, h: 62 },
  rod: { id: 'rod', name: 'Cần câu', icon: '🎣', url: 'assets/chibi/tools/rod.png', w: 60, h: 28 },
  net: { id: 'net', name: 'Vợt côn trùng', icon: '🥅', url: 'assets/chibi/tools/net.png', w: 48, h: 46 },
  axe: { id: 'axe', name: 'Rìu', icon: '', url: 'assets/farm/chibi/20_axe.png', w: 58, h: 62 }
};

export const TOOL_LIST = Object.values(TOOLS);
export const DEFAULT_HOTBAR = ['hoe', 'can', '', '', ''];

// ===== Nâng cấp nông cụ (tăng chỉ số) =====
// Cần câu & vợt không nâng tại chỗ — mua loại xịn hơn ở tiệm câu Ông Biển (RODS/NETS).
export interface ToolUpgrade { level: number; name: string; price: number; desc: string; bonus: number }
export const TOOL_UPGRADES: Record<string, ToolUpgrade[]> = {
  hoe: [
    { level: 1, name: 'Cuốc gỗ', price: 0, desc: 'Cuốc đất cơ bản', bonus: 0 },
    { level: 2, name: 'Cuốc sắt', price: 800, desc: '15% nhặt lại hạt giống ngẫu nhiên khi cuốc đất', bonus: 0.15 },
    { level: 3, name: 'Cuốc vàng', price: 2500, desc: '30% nhặt lại hạt giống ngẫu nhiên khi cuốc đất', bonus: 0.3 }
  ],
  can: [
    { level: 1, name: 'Bình tưới thiếc', price: 0, desc: 'Tưới cây cơ bản', bonus: 0 },
    { level: 2, name: 'Bình tưới đồng', price: 600, desc: 'Cây đã tưới lớn nhanh thêm 10%', bonus: 0.1 },
    { level: 3, name: 'Bình tưới vàng', price: 2000, desc: 'Cây đã tưới lớn nhanh thêm 20%', bonus: 0.2 }
  ],
  basket: [
    { level: 1, name: 'Giỏ mây', price: 0, desc: 'Thu hoạch cơ bản', bonus: 0 },
    { level: 2, name: 'Giỏ chắc chắn', price: 1200, desc: '15% cơ hội +1 nông sản khi thu hoạch', bonus: 0.15 },
    { level: 3, name: 'Giỏ hoàng kim', price: 4000, desc: '35% cơ hội +1 nông sản khi thu hoạch', bonus: 0.35 }
  ]
};

export function toolUpgradeAt(tool: string, level: number): ToolUpgrade | undefined {
  return TOOL_UPGRADES[tool]?.find(u => u.level === level);
}
export function toolBonus(tool: string, level: number): number {
  return toolUpgradeAt(tool, level)?.bonus ?? 0;
}

// icon vừa khít ô vuông `box` px (giữ tỉ lệ theo cạnh dài)
export function toolIconSize(t: ToolDef, box: number): number {
  return t.w >= t.h ? box : Math.round(box * t.w / t.h);
}
