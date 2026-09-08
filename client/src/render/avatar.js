/**
 * Vẽ nhân vật từ art vẽ sẵn (doc 04 + doc 05).
 *
 * Art chỉ có MỘT khung đứng cho mỗi nhân vật, không phải dải khung đi. Nên
 * chuyển động nặn bằng phép biến hình trên chính khung đó: nhún người, nghiêng
 * theo bước, và ép–giãn nhẹ. Cách này quen thuộc trong game 2D dùng sprite đơn,
 * và ở cỡ chibi thì đọc ra "đang đi" rõ hơn người ta tưởng.
 *
 * Vẫn giữ bản vẽ bằng hình khối làm đường lui: màn đăng nhập dựng avatar trước
 * khi trang art kịp tải xong.
 */
import { atlas } from './atlas.js';
import { drawLook } from './paperdoll.js';

const AVATAR_HEIGHT = 96;

const DEFAULT_COLOUR = {
  body: '#f3c9a5', face: '#2b2b33', hair: '#3a2c26', top: '#4a86c8',
  bottom: '#3d4c66', shoes: '#2f2f36', hat: '#dcc07a', accessory: '#d8534f', back: '#8a6a45',
};

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
 * Biến hình theo trạng thái. Trả về { bob, lean, squash } cho atlas.character().
 *
 * Ba thành phần cùng chạy trên một pha:
 *  - bob: nhún lên xuống hai nhịp mỗi bước, đây là thứ đọc ra "đang đi".
 *  - squash: chạm đất thì bè ra, bật lên thì thon lại — giữ thể tích nên
 *    người không bị phồng to.
 *  - lean: nghiêng nhẹ về trước, cho cảm giác có đà.
 */
function transformFor(state, phase) {
  if (state === 'walk' || state === 'run') {
    const heavy = state === 'run';
    const step = Math.sin(phase * Math.PI * 4);      // hai nhịp mỗi chu kỳ
    const lift = Math.abs(step);
    return {
      bob: -lift * (heavy ? 5 : 3),
      squash: 1 + lift * (heavy ? 0.05 : 0.03),
      lean: step * (heavy ? 0.05 : 0.03),
    };
  }
  if (state === 'sit') return { bob: 0, squash: 0.86, lean: 0 };
  if (state === 'farm') return { bob: 0, squash: 0.94, lean: 0.1 };
  // Đứng yên vẫn phải thở, không thì nhìn như game đơ.
  return { bob: 0, squash: 1 + Math.sin(phase * Math.PI * 2) * 0.008, lean: 0 };
}

/** Sprite của nhân vật: NPC khai trong data map, người chơi theo giới tính. */
function spriteOf({ sprite, bodyType }) {
  if (sprite) return sprite;
  return bodyType === 'b' ? 'hero_girl' : 'hero_boy';
}

/**
 * @param ctx canvas 2d context, đã dịch gốc toạ độ về chân nhân vật.
 * @param options.state idle | walk | run | sit | farm
 * @param options.phase 0..1 — pha animation.
 * @param options.sprite tên sprite nhân vật; bỏ trống thì suy từ trang phục.
 */
export function drawAvatar(ctx, content, options) {
  const { facing = 1, scale = 1, nickname = null, emote = null, state = 'idle', phase = 0 } = options;

  ctx.save();
  ctx.scale(scale, scale);
  // Bóng đổ vẽ ở đây, không nướng vào sprite: bóng phải nằm yên dưới chân khi
  // người nhún lên, nướng vào sprite là bóng nhún theo.
  ctx.globalAlpha = 0.22;
  ctx.fillStyle = '#000';
  ctx.beginPath();
  ctx.ellipse(0, 0, 17, 5, 0, 0, Math.PI * 2);
  ctx.fill();
  ctx.globalAlpha = 1;
  ctx.restore();

  let drawn = false;
  const look = options.appearance;
  if (look?.outfit && look?.face) {
    // Nhân vật do người chơi tự ghép: vẽ lại từ ba mảnh chứ không có sprite
    // dựng sẵn nào cả. Biến hình phải tự áp ở đây vì drawLook chỉ biết vẽ
    // đứng yên — cùng công thức với atlas.character(), gốc đặt ở CHÂN.
    const { bob = 0, lean = 0, squash = 1 } = transformFor(state, phase);
    ctx.save();
    ctx.scale(facing * scale, scale);
    ctx.translate(0, bob);
    if (lean) ctx.rotate(lean);
    if (squash !== 1) ctx.scale(1 / squash, squash);
    drawn = drawLook(ctx, atlas, look, { x: 0, groundY: 0, height: AVATAR_HEIGHT });
    ctx.restore();
  }
  const name = spriteOf(options);
  if (!drawn && atlas.hasSprite(name)) {
    ctx.save();
    ctx.scale(facing * scale, scale);
    drawn = atlas.character(ctx, name, 0, 0, AVATAR_HEIGHT, transformFor(state, phase));
    ctx.restore();
  }
  if (!drawn) drawShapes(ctx, content, options);

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

function drawShapes(ctx, content, { equipment, palette = null, facing = 1, state = 'idle', phase = 0, scale = 1 }) {
  const skin = colorOf(content, equipment, 'body', DEFAULT_COLOUR.body, palette);
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

  // Chân dung vẽ đúng một lần lúc cập nhật HUD. Nếu art nhân vật chưa tải xong
  // thì lần vẽ đó rơi vào bản dự phòng rồi nằm im mãi — phải tự hẹn vẽ lại.
  // Nhân vật ghép nằm ở trang art khác với sprite dựng sẵn, nên chờ đúng trang
  // của thứ SẼ vẽ, không thì chân dung đứng im ở hình dự phòng.
  atlas.pendingFor(options.appearance?.outfit ?? spriteOf(options))?.then(() => drawAvatarPortrait(canvas, content, options));
}
