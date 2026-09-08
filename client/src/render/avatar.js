/**
 * Vẽ nhân vật theo kiểu paperdoll: thân quy định 6 khung hình, mỗi món trang bị
 * có sprite riêng cho đúng 6 khung đó, xếp theo zOrder khai báo trong atlas
 * (doc 04 + doc 05). Thêm món mới = thêm data, không sửa code vẽ.
 *
 * Sprite vẽ bằng thang xám rồi nhân với màu của món đồ lúc chạy, nên một bộ
 * sprite phục vụ mọi màu mà vẫn giữ khối sáng–tối.
 *
 * Vẫn giữ bản vẽ bằng hình khối làm đường lui: atlas nạp bất đồng bộ, và màn
 * hình đăng nhập dựng avatar trước khi thế giới kịp nạp xong.
 */
import { atlas } from './atlas.js';

const AVATAR_HEIGHT = 96;

// Tỉ lệ tính từ CHIỀU CAO THÂN trong atlas, không phải chiều cao ô: ô có chừa
// khoảng hở phía trên cho mũ, lấy nhầm là nhân vật bị lùn đi.
const partScale = () => AVATAR_HEIGHT / (atlas.meta?.parts?.bodyH ?? 54);

const DEFAULT_PART = { body: 'body', face: 'face', hair: 'hair_short', top: 'top_tee', bottom: 'bottom_long', shoes: 'shoes' };
const DEFAULT_COLOUR = {
  body: '#f3c9a5', face: '#2b2b33', hair: '#3a2c26', top: '#4a86c8',
  bottom: '#3d4c66', shoes: '#2f2f36', hat: '#dcc07a', accessory: '#d8534f', back: '#8a6a45',
};

// Slot nào không mặc gì thì vẫn phải vẽ (không ai đi chơi mà thiếu thân hoặc
// tóc); slot phụ kiện thì để trống là đúng.
const REQUIRED_SLOTS = ['back', 'body', 'bottom', 'shoes', 'top', 'face', 'hair', 'hat', 'accessory'];

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

function partOf(content, equipment, slot) {
  const itemId = equipment?.[slot];
  const item = itemId ? content.avatarItemsById.get(itemId) : null;
  return item?.part ?? DEFAULT_PART[slot] ?? null;
}

/** Khung hình theo trạng thái: 0–1 đứng yên, 2–5 chu kỳ đi. */
function frameFor(state, phase) {
  if (state === 'walk' || state === 'run') return 2 + Math.floor(phase * 4) % 4;
  return phase % 1 < 0.5 ? 0 : 1;
}

/**
 * @param ctx canvas 2d context, đã dịch gốc toạ độ về chân nhân vật.
 * @param options.state idle | walk | run | jump | sit | farm
 * @param options.phase 0..1 — pha animation, dùng cho bước chân và nhún người.
 */
export function drawAvatar(ctx, content, options) {
  const { facing = 1, scale = 1, nickname = null, emote = null } = options;

  ctx.save();
  ctx.scale(scale, scale);
  // Bóng đổ vẽ ở đây chứ không nướng vào sprite: sprite thân bị nhân với màu da
  // nên bóng lọt vào đó sẽ thành vũng màu da.
  ctx.globalAlpha = 0.22;
  ctx.fillStyle = '#000';
  ctx.beginPath();
  ctx.ellipse(0, 0, 17, 5, 0, 0, Math.PI * 2);
  ctx.fill();
  ctx.globalAlpha = 1;
  ctx.restore();

  if (atlas.ready) drawPaperdoll(ctx, content, options);
  else drawShapes(ctx, content, options);

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

function drawPaperdoll(ctx, content, { equipment, palette = null, facing = 1, state = 'idle', phase = 0, scale = 1 }) {
  const frame = frameFor(state, phase);
  // Ngồi và làm ruộng chưa có khung riêng; hạ người xuống cho khác tư thế đứng
  // thay vì vẽ y hệt rồi để người chơi tưởng game đơ.
  const crouch = state === 'sit' ? 10 : state === 'farm' ? 6 : 0;

  const wearing = [];
  for (const slot of REQUIRED_SLOTS) {
    const part = partOf(content, equipment, slot);
    if (!part) continue;
    // Mũ/phụ kiện/đồ lưng chỉ vẽ khi thực sự mặc.
    if (!DEFAULT_PART[slot] && !equipment?.[slot] && !palette?.[slot]) continue;
    wearing.push({ part, colour: colorOf(content, equipment, slot, DEFAULT_COLOUR[slot], palette) });
  }

  ctx.save();
  ctx.imageSmoothingEnabled = false;
  ctx.scale(facing * scale, scale);
  ctx.translate(0, -crouch);
  const order = atlas.partOrder(wearing.map((w) => w.part));
  for (const name of order) {
    const w = wearing.find((item) => item.part === name);
    atlas.part(ctx, name, w.colour, frame, 0, 0, partScale());
  }
  ctx.restore();
}

function drawShapes(ctx, content, { equipment, palette = null, facing = 1, state = 'idle', phase = 0, scale = 1 }) {
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

  // Má hồng + miệng: chân dung trên HUD phóng khuôn mặt khá to, chỉ hai chấm mắt
  // thì trông trơ.
  ctx.fillStyle = 'rgba(224, 122, 122, .35)';
  ctx.beginPath();
  ctx.ellipse(9, y - 70, 3.6, 2.4, 0, 0, Math.PI * 2);
  ctx.ellipse(-5, y - 70, 3.6, 2.4, 0, 0, Math.PI * 2);
  ctx.fill();

  ctx.strokeStyle = eyes;
  ctx.lineWidth = 1.4;
  ctx.lineCap = 'round';
  ctx.beginPath();
  ctx.arc(2, y - 70, 4.2, Math.PI * 0.15, Math.PI * 0.85);
  ctx.stroke();

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

/**
 * Vẽ chân dung (đầu + vai) vào một canvas riêng — dùng cho góc thông tin nhân
 * vật trên HUD. Dùng lại đúng hàm vẽ avatar trong thế giới nên đổi cosmetic là
 * chân dung đổi theo, không phải duy trì hai bộ hình.
 */
export function drawAvatarPortrait(canvas, content, options) {
  const dpr = Math.min(devicePixelRatio || 1, 2);
  const size = canvas.clientWidth || canvas.width;
  if (canvas.width !== Math.round(size * dpr)) {
    canvas.width = Math.round(size * dpr);
    canvas.height = Math.round(size * dpr);
  }

  const ctx = canvas.getContext('2d');
  ctx.setTransform(1, 0, 0, 1, 0, 0);
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  ctx.save();
  ctx.scale(dpr, dpr);

  // Cắt tròn cho khớp khung ảnh đại diện.
  ctx.beginPath();
  ctx.arc(size / 2, size / 2, size / 2, 0, Math.PI * 2);
  ctx.clip();

  // Avatar vẽ với gốc toạ độ ở chân; đưa vùng đầu–vai (y từ -106 đến -42) lấp đầy
  // khung. Cắt cao hơn thì mất vai, chỉ còn cái đầu lơ lửng.
  const zoom = size / 64;
  ctx.translate(size / 2, zoom * 106);
  ctx.scale(zoom, zoom);
  drawAvatar(ctx, content, { ...options, facing: 1, state: 'idle', phase: 0, nickname: null, emote: null });
  ctx.restore();
}
