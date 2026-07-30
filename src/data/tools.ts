// ===== Nông cụ trang bị trên thanh nhanh (hotbar) =====

export interface ToolDef {
  id: string;
  name: string;
  icon: string;            // emoji dự phòng
  url: string;             // icon pixel 16px
}

export const TOOLS: Record<string, ToolDef> = {
  hoe: { id: 'hoe', name: 'Cuốc', icon: '⛏️', url: 'assets/farm/tool_hoe.png' },
  can: { id: 'can', name: 'Bình tưới', icon: '💧', url: 'assets/farm/tool_can.png' },
  basket: { id: 'basket', name: 'Giỏ thu hoạch', icon: '🧺', url: 'assets/farm/tool_basket.png' },
  rod: { id: 'rod', name: 'Cần câu', icon: '🎣', url: 'assets/farm/tool_rod.png' },
  net: { id: 'net', name: 'Vợt côn trùng', icon: '🥅', url: 'assets/farm/tool_net.png' },
  axe: { id: 'axe', name: 'Rìu', icon: '🪓', url: 'assets/farm/tool_axe.png' },
  shovel: { id: 'shovel', name: 'Xẻng', icon: '🦯', url: 'assets/farm/tool_shovel.png' }
};

export const TOOL_LIST = Object.values(TOOLS);
export const DEFAULT_HOTBAR = ['hoe', 'can', 'basket', 'rod', 'net'];
