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
  // ảnh 19_sickle là cái LIỀM nên tên phải là Liềm (trước gọi "Giỏ thu hoạch"
  // mà vẽ cái liềm). Công dụng vẫn là gặt nhanh cây chín gần nhất.
  basket: { id: 'basket', name: 'Liềm gặt', icon: '', url: 'assets/farm/chibi/19_sickle.png', w: 50, h: 62 },
  rod: { id: 'rod', name: 'Cần câu', icon: '🎣', url: 'assets/fishing/rod.png', w: 16, h: 16 },
  net: { id: 'net', name: 'Vợt côn trùng', icon: '🥅', url: 'assets/chibi/tools/net.png', w: 48, h: 46 },
  axe: { id: 'axe', name: 'Rìu', icon: '', url: 'assets/farm/chibi/20_axe.png', w: 58, h: 62 }
};

export const TOOL_LIST = Object.values(TOOLS);

// 4 nông cụ cơ bản LUÔN nằm sẵn trên thanh, không gỡ ra được — đi làm đồng là
// có đủ cuốc/tưới/gặt/chặt, khỏi phải vào túi gắn từng cái.
export const FIXED_TOOLS = ['hoe', 'can', 'basket', 'axe'];
export const DEFAULT_HOTBAR = [...FIXED_TOOLS, ''];

// ===== Nâng cấp nông cụ (tăng chỉ số) =====
// Cần câu & vợt không nâng tại chỗ — mua loại xịn hơn ở tiệm câu Ông Biển (RODS/NETS).
//
// Nâng cấp không chỉ tốn xu: phải gom đủ NGUYÊN LIỆU (gỗ chặt cây, đá đập đống
// đá ngoài đồng) và còn có TỈ LỆ THÀNH CÔNG — hỏng thì mất nguyên liệu, cấp
// giữ nguyên. `rate` là tỉ lệ ăn của lần nâng lên chính cấp đó.
export interface ToolUpgrade {
  level: number; name: string; price: number; desc: string; bonus: number;
  mats?: Record<string, number>;   // nguyên liệu cần, theo id vật phẩm
  rate?: number;                   // tỉ lệ thành công 0..1
}
export const TOOL_UPGRADES: Record<string, ToolUpgrade[]> = {
  hoe: [
    { level: 1, name: 'Cuốc gỗ', price: 0, desc: 'Cuốc đất cơ bản', bonus: 0 },
    { level: 2, name: 'Cuốc sắt', price: 800, desc: '15% nhặt lại hạt giống ngẫu nhiên khi cuốc đất', bonus: 0.15,
      mats: { wood: 8, stone: 5 }, rate: 0.8 },
    { level: 3, name: 'Cuốc vàng', price: 2500, desc: '30% nhặt lại hạt giống ngẫu nhiên khi cuốc đất', bonus: 0.3,
      mats: { wood: 18, stone: 14 }, rate: 0.55 }
  ],
  can: [
    { level: 1, name: 'Bình tưới thiếc', price: 0, desc: 'Tưới cây cơ bản', bonus: 0 },
    { level: 2, name: 'Bình tưới đồng', price: 600, desc: 'Cây đã tưới lớn nhanh thêm 10%', bonus: 0.1,
      mats: { stone: 6 }, rate: 0.85 },
    { level: 3, name: 'Bình tưới vàng', price: 2000, desc: 'Cây đã tưới lớn nhanh thêm 20%', bonus: 0.2,
      mats: { stone: 15, wood: 8 }, rate: 0.6 }
  ],
  basket: [
    { level: 1, name: 'Liềm sắt', price: 0, desc: 'Thu hoạch cơ bản', bonus: 0 },
    { level: 2, name: 'Liềm thép', price: 1200, desc: '15% cơ hội +1 nông sản khi thu hoạch', bonus: 0.15,
      mats: { wood: 6, stone: 8 }, rate: 0.75 },
    { level: 3, name: 'Liềm vàng', price: 4000, desc: '35% cơ hội +1 nông sản khi thu hoạch', bonus: 0.35,
      mats: { wood: 14, stone: 20 }, rate: 0.5 }
  ],
  axe: [
    { level: 1, name: 'Rìu đá', price: 0, desc: 'Chặt cây cơ bản', bonus: 0 },
    { level: 2, name: 'Rìu sắt', price: 900, desc: 'Chặt cây ra thêm 15% gỗ', bonus: 0.15,
      mats: { wood: 10, stone: 6 }, rate: 0.8 },
    { level: 3, name: 'Rìu vàng', price: 3000, desc: 'Chặt cây ra thêm 35% gỗ', bonus: 0.35,
      mats: { wood: 22, stone: 16 }, rate: 0.55 }
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
