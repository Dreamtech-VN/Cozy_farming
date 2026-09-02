/**
 * Bản đồ (doc 03, doc 12).
 * Map là 2D side-view nên bản đồ khu vực là một dải ngang: mặt đất, bệ đứng,
 * portal, NPC và vị trí người chơi. Mọi thứ vẽ từ data của map nên thêm map mới
 * không phải sửa gì ở đây.
 */
import { t } from '../core/i18n.js';

const COLORS = {
  ground: '#4d7f52',
  platform: '#6f9a6a',
  portal: '#7ad3f0',
  npc: '#f2c94c',
  other: '#e9f2ea',
  self: '#7fc98a',
  locked: '#6a5252',
};

/**
 * Đưa toạ độ thế giới vào khung canvas.
 * Co giãn hai trục ĐỘC LẬP: map side-view rất rộng (2400×720), giữ đúng tỉ lệ thì
 * dải đất mỏng như sợi chỉ trong ô minimap. Đây là sơ đồ định hướng, không phải
 * ảnh thu nhỏ, nên lấp đầy khung dễ đọc hơn là đúng tỉ lệ.
 */
function fitTransform(canvas, map, padding) {
  // Chỉ lấy dải có nội dung theo chiều dọc. Map cao 720 nhưng mặt đất ở 600 nên
  // hơn 80% chiều cao là trời trống — vẽ cả vào bản đồ thì chỉ tổ phí khung.
  const highest = Math.min(map.ground_y - 40, ...(map.platforms ?? []).map((p) => p.y - 30));
  const top = Math.max(0, Math.min(highest, map.ground_y - 260));
  const bottom = Math.min(map.height, map.ground_y + 70);
  const span = Math.max(1, bottom - top);

  const scaleX = (canvas.width - padding * 2) / map.width;
  const scaleY = (canvas.height - padding * 2) / span;
  return {
    scale: scaleX,
    scaleY,
    x: (value) => padding + value * scaleX,
    y: (value) => padding + (value - top) * scaleY,
  };
}

/**
 * Vẽ bản đồ khu vực. `detail` bật nhãn cho portal và NPC (dùng ở popup),
 * tắt ở minimap trên HUD cho gọn.
 */
export function drawAreaMap(canvas, map, { self, players = [], detail = false } = {}) {
  const dpr = Math.min(devicePixelRatio || 1, 2);
  const cssWidth = canvas.clientWidth || canvas.width;
  const cssHeight = canvas.clientHeight || canvas.height;
  if (canvas.width !== Math.round(cssWidth * dpr)) {
    canvas.width = Math.round(cssWidth * dpr);
    canvas.height = Math.round(cssHeight * dpr);
  }

  const ctx = canvas.getContext('2d');
  ctx.setTransform(1, 0, 0, 1, 0, 0);
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  const padding = detail ? 22 * dpr : 8 * dpr;
  const fit = fitTransform(canvas, map, padding);
  const dot = (detail ? 5 : 3) * dpr;

  // Nền trời của map để bản đồ nhận diện được theo màu khu vực.
  ctx.fillStyle = map.theme.sky[1];
  ctx.globalAlpha = 0.34;
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.globalAlpha = 1;

  // Mặt đất
  ctx.fillStyle = COLORS.ground;
  ctx.fillRect(fit.x(0), fit.y(map.ground_y), map.width * fit.scale,
    Math.max(4 * dpr, (map.height - map.ground_y) * fit.scaleY));

  for (const platform of map.platforms ?? []) {
    ctx.fillStyle = COLORS.platform;
    ctx.fillRect(fit.x(platform.x), fit.y(platform.y), platform.w * fit.scale,
      Math.max(3 * dpr, platform.h * fit.scaleY));
  }

  ctx.textAlign = 'center';
  ctx.font = `600 ${11 * dpr}px system-ui, sans-serif`;

  // Giữ nhãn nằm trong khung: portal ở sát mép map hay bị cắt mất chữ.
  const labelX = (value, text) => {
    const half = ctx.measureText(text).width / 2 + 2 * dpr;
    return Math.max(half, Math.min(canvas.width - half, value));
  };

  for (const portal of map.portals) {
    ctx.fillStyle = COLORS.portal;
    ctx.fillRect(fit.x(portal.x) - dot, fit.y(portal.y - portal.h), dot * 2,
      Math.max(6 * dpr, portal.h * fit.scaleY));
    if (detail) {
      const label = t(portal.label_key);
      ctx.fillStyle = COLORS.portal;
      ctx.fillText(label, labelX(fit.x(portal.x), label), fit.y(portal.y - portal.h) - 6 * dpr);
    }
  }

  for (const npc of map.npcs) {
    ctx.fillStyle = COLORS.npc;
    ctx.beginPath();
    ctx.arc(fit.x(npc.x), fit.y(npc.y) - dot, dot, 0, Math.PI * 2);
    ctx.fill();
    if (detail) {
      const label = t(npc.name_key);
      ctx.fillText(label, labelX(fit.x(npc.x), label), fit.y(npc.y) + 16 * dpr);
    }
  }

  for (const player of players) {
    ctx.fillStyle = COLORS.other;
    ctx.beginPath();
    ctx.arc(fit.x(player.x), fit.y(player.y) - dot, dot * 0.85, 0, Math.PI * 2);
    ctx.fill();
  }

  if (self) {
    const x = fit.x(self.x);
    const y = fit.y(self.y) - dot;
    ctx.fillStyle = COLORS.self;
    ctx.beginPath();
    ctx.arc(x, y, dot * 1.3, 0, Math.PI * 2);
    ctx.fill();
    ctx.strokeStyle = 'rgba(255,255,255,.9)';
    ctx.lineWidth = 1.5 * dpr;
    ctx.beginPath();
    ctx.arc(x, y, dot * 2.2, 0, Math.PI * 2);
    ctx.stroke();
  }
}

/**
 * Bản đồ thành phố: mỗi map là một node, mỗi portal là một cạnh.
 * Bố cục xếp theo nhóm map (City / Farming / Adventure / Event) nên thêm map mới
 * chỉ cần khai báo `group` trong data.
 */
export function drawWorldAtlas(canvas, atlas, currentMapId) {
  const dpr = Math.min(devicePixelRatio || 1, 2);
  const cssWidth = canvas.clientWidth || canvas.width;
  const cssHeight = canvas.clientHeight || canvas.height;
  canvas.width = Math.round(cssWidth * dpr);
  canvas.height = Math.round(cssHeight * dpr);

  const ctx = canvas.getContext('2d');
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  ctx.clearRect(0, 0, cssWidth, cssHeight);

  const groups = [...new Set(atlas.maps.map((m) => m.group))];
  const nodes = new Map();
  const columnWidth = cssWidth / groups.length;

  groups.forEach((group, columnIndex) => {
    const inGroup = atlas.maps.filter((m) => m.group === group);
    inGroup.forEach((map, rowIndex) => {
      nodes.set(map.map_id, {
        map,
        x: columnWidth * (columnIndex + 0.5),
        y: 46 + (rowIndex + 0.5) * ((cssHeight - 60) / inGroup.length),
      });
    });
    ctx.fillStyle = '#a8c0ae';
    ctx.font = '600 12px system-ui, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText(group, columnWidth * (columnIndex + 0.5), 22);
  });

  // Cạnh trước, node sau, để đường nối không đè lên nhãn.
  ctx.strokeStyle = 'rgba(127, 201, 138, .45)';
  ctx.lineWidth = 1.5;
  for (const node of nodes.values()) {
    for (const link of node.map.links) {
      const target = nodes.get(link.to);
      if (!target) continue;
      ctx.beginPath();
      ctx.moveTo(node.x, node.y);
      ctx.lineTo(target.x, target.y);
      ctx.stroke();
    }
  }

  for (const node of nodes.values()) {
    const current = node.map.map_id === currentMapId;
    const width = Math.min(columnWidth - 16, 132);
    const height = 34;
    const x = node.x - width / 2;
    const y = node.y - height / 2;

    ctx.fillStyle = node.map.locked ? '#2a2320' : current ? '#2f5f42' : '#24382f';
    ctx.strokeStyle = current ? '#7fc98a' : node.map.locked ? '#6a5252' : '#35513f';
    ctx.lineWidth = current ? 2 : 1;
    ctx.beginPath();
    ctx.roundRect(x, y, width, height, 9);
    ctx.fill();
    ctx.stroke();

    ctx.fillStyle = node.map.locked ? '#9a8577' : '#eef6ef';
    ctx.font = `${current ? '700' : '500'} 12px system-ui, sans-serif`;
    ctx.textAlign = 'center';
    const label = t(node.map.name_key);
    ctx.fillText(label.length > 16 ? `${label.slice(0, 15)}…` : label, node.x, node.y + 1);

    if (node.map.locked) {
      ctx.fillStyle = '#c98b8b';
      ctx.font = '600 10px system-ui, sans-serif';
      ctx.fillText(`cần cấp ${node.map.unlock_level}`, node.x, node.y + 13);
    } else if (current) {
      ctx.fillStyle = '#7fc98a';
      ctx.font = '600 10px system-ui, sans-serif';
      ctx.fillText('đang ở đây', node.x, node.y + 13);
    }
  }
}

export { COLORS as MAP_COLORS };
