// ===== Nông cụ trang bị trên thanh nhanh (hotbar) =====
// Icon style chibi Avatar (assets/chibi/tools) — cuốc/bình/giỏ/cần/vợt lấy từ
// icon item Avatar (xem docs/ASSETS.md, chỉ dùng dev/test), rìu/xẻng vẽ theo cùng style.

export interface ToolDef {
  id: string;
  name: string;
  icon: string;            // emoji dự phòng
  url: string;             // icon chibi
  w: number;               // kích thước ảnh icon
  h: number;
}

export const TOOLS: Record<string, ToolDef> = {
  hoe: { id: 'hoe', name: 'Cuốc', icon: '⛏️', url: 'assets/chibi/tools/hoe.png', w: 46, h: 46 },
  can: { id: 'can', name: 'Bình tưới', icon: '💧', url: 'assets/chibi/tools/can.png', w: 34, h: 38 },
  basket: { id: 'basket', name: 'Giỏ thu hoạch', icon: '🧺', url: 'assets/chibi/tools/basket.png', w: 48, h: 46 },
  rod: { id: 'rod', name: 'Cần câu', icon: '🎣', url: 'assets/chibi/tools/rod.png', w: 60, h: 28 },
  net: { id: 'net', name: 'Vợt côn trùng', icon: '🥅', url: 'assets/chibi/tools/net.png', w: 48, h: 46 },
  axe: { id: 'axe', name: 'Rìu', icon: '🪓', url: 'assets/chibi/tools/axe.png', w: 46, h: 46 },
  shovel: { id: 'shovel', name: 'Xẻng', icon: '🦯', url: 'assets/chibi/tools/shovel.png', w: 46, h: 46 }
};

export const TOOL_LIST = Object.values(TOOLS);
export const DEFAULT_HOTBAR = ['hoe', 'can', '', '', ''];

// icon vừa khít ô vuông `box` px (giữ tỉ lệ theo cạnh dài)
export function toolIconSize(t: ToolDef, box: number): number {
  return t.w >= t.h ? box : Math.round(box * t.w / t.h);
}
