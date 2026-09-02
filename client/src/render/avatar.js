/**
 * Vẽ avatar chibi 2D side-view theo layer (doc 04 + doc 05).
 * Mỗi cosmetic là một layer riêng, vẽ theo layer_order lấy từ content — thêm
 * item mới chỉ cần thêm data, không sửa code render.
 */
const AVATAR_HEIGHT = 96;

/**
 * Tra màu của cosmetic đang mặc ở một slot.
 * `palette` cho phép ghi đè trực tiếp bằng màu (NPC dùng đường này vì NPC không
 * có tủ đồ, chỉ có bảng màu khai báo trong data map).
 */
function colorOf(content, equipment, slot, fallback, palette) {
  if (palette?.[slot]) return palette[slot];
  const itemId = equipment?.[slot];
  const item = itemId ? content.avatarItemsById.get(itemId) : null;
  return item?.colors?.[0] ?? fallback;
}

/**
 * @param ctx canvas 2d context, đã dịch gốc toạ độ về chân nhân vật.
 * @param options.state idle | walk | run | jump | sit | farm
 * @param options.phase 0..1 — pha animation, dùng cho bước chân và nhún người.
 */
export function drawAvatar(ctx, content, { equipment, palette = null, facing = 1, state = 'idle', phase = 0, scale = 1, nickname = null, emote = null }) {
  const skin = colorOf(content, equipment, 'body', '#f3c9a5', palette);
  const eyes = colorOf(content, equipment, 'face', '#2b2b33', palette);
  const hair = colorOf(content, equipment, 'hair', '#3a2c26', palette);
  const top = colorOf(content, equipment, 'top', '#4a86c8', palette);
  const bottom = colorOf(content, equipment, 'bottom', '#3d4c66', palette);
  const shoes = colorOf(content, equipment, 'shoes', '#2f2f36', palette);
  const hat = equipment?.hat ? colorOf(content, equipment, 'hat', '#dcc07a', palette) : null;
  const accessory = equipment?.accessory ? colorOf(content, equipment, 'accessory', '#d8534f', palette) : null;
  const back = equipment?.back ? colorOf(content, equipment, 'back', '#8a6a45', palette) : null;

  const moving = state === 'walk' || state === 'run';
  const swing = moving ? Math.sin(phase * Math.PI * 2) : 0;
  const bob = moving ? Math.abs(Math.cos(phase * Math.PI * 2)) * 2 : 0;
  const crouch = state === 'sit' ? 10 : state === 'farm' ? 6 : 0;

  ctx.save();
  ctx.scale(facing * scale, scale);
  ctx.translate(0, -crouch);

  // Bóng đổ giữ nhân vật "dính" xuống đất (doc 05 — silhouette rõ).
  ctx.globalAlpha = 0.22;
  ctx.fillStyle = '#000';
  ctx.beginPath();
  ctx.ellipse(0, crouch, 17, 5, 0, 0, Math.PI * 2);
  ctx.fill();
  ctx.globalAlpha = 1;

  const y = -bob;

  if (back) { // back item
    ctx.fillStyle = back;
    roundRect(ctx, -16, y - 62, 13, 26, 5);
  }

  // Chân
  ctx.fillStyle = bottom;
  roundRect(ctx, -11 + swing * 4, y - 34, 10, 24, 4);
  roundRect(ctx, 1 - swing * 4, y - 34, 10, 24, 4);
  ctx.fillStyle = shoes;
  roundRect(ctx, -12 + swing * 4, y - 12, 12, 10, 4);
  roundRect(ctx, 0 - swing * 4, y - 12, 12, 10, 4);

  // Thân + tay
  ctx.fillStyle = top;
  roundRect(ctx, -14, y - 62, 28, 30, 8);
  ctx.fillStyle = skin;
  const armSwing = state === 'farm' ? -14 : swing * 6;
  roundRect(ctx, -19, y - 58 + armSwing, 8, 20, 4);
  roundRect(ctx, 11, y - 58 - armSwing, 8, 20, 4);

  // Đầu
  ctx.fillStyle = skin;
  roundRect(ctx, -15, y - 92, 30, 32, 12);

  // Mắt (chỉ vẽ phía đang nhìn — chibi side-view)
  ctx.fillStyle = eyes;
  ctx.beginPath();
  ctx.ellipse(6, y - 76, 2.4, 3.2, 0, 0, Math.PI * 2);
  ctx.fill();
  ctx.beginPath();
  ctx.ellipse(-2, y - 76, 2.4, 3.2, 0, 0, Math.PI * 2);
  ctx.fill();

  // Tóc — vẽ sau đầu để không bị đè
  ctx.fillStyle = hair;
  ctx.beginPath();
  ctx.moveTo(-16, y - 74);
  ctx.quadraticCurveTo(-17, y - 96, 0, y - 96);
  ctx.quadraticCurveTo(17, y - 96, 16, y - 72);
  ctx.lineTo(11, y - 78);
  ctx.quadraticCurveTo(2, y - 88, -12, y - 82);
  ctx.closePath();
  ctx.fill();

  if (accessory) { // khăn quàng
    ctx.fillStyle = accessory;
    roundRect(ctx, -13, y - 64, 26, 7, 3);
  }
  if (hat) {
    ctx.fillStyle = hat;
    roundRect(ctx, -20, y - 96, 40, 7, 3);
    roundRect(ctx, -13, y - 106, 26, 12, 5);
  }

  ctx.restore();

  if (nickname) {
    ctx.save();
    ctx.scale(scale, scale);
    ctx.font = '600 12px system-ui, sans-serif';
    ctx.textAlign = 'center';
    ctx.lineWidth = 3;
    ctx.strokeStyle = 'rgba(0,0,0,.65)';
    ctx.strokeText(nickname, 0, -AVATAR_HEIGHT - 12);
    ctx.fillStyle = '#eef6ef';
    ctx.fillText(nickname, 0, -AVATAR_HEIGHT - 12);
    ctx.restore();
  }

  if (emote) {
    ctx.save();
    ctx.scale(scale, scale);
    ctx.fillStyle = 'rgba(16,26,22,.9)';
    roundRect(ctx, -18, -AVATAR_HEIGHT - 44, 36, 24, 8);
    ctx.fillStyle = '#f2c94c';
    ctx.font = '600 13px system-ui, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText(emote, 0, -AVATAR_HEIGHT - 27);
    ctx.restore();
  }
}

export function roundRect(ctx, x, y, w, h, r) {
  const radius = Math.min(r, w / 2, h / 2);
  ctx.beginPath();
  ctx.moveTo(x + radius, y);
  ctx.arcTo(x + w, y, x + w, y + h, radius);
  ctx.arcTo(x + w, y + h, x, y + h, radius);
  ctx.arcTo(x, y + h, x, y, radius);
  ctx.arcTo(x, y, x + w, y, radius);
  ctx.closePath();
  ctx.fill();
}

export { AVATAR_HEIGHT };
