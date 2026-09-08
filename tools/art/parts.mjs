/**
 * Sprite paperdoll cho nhân vật.
 *
 * Cấu trúc lấy theo cách các client MMO 2D đời J2ME làm: THÂN quy định N khung
 * hình, mỗi món trang bị cung cấp hình riêng cho ĐÚNG N khung đó rồi xếp theo
 * zOrder. Nhờ vậy thêm một cái mũ là thêm data, không đụng vào code vẽ.
 *
 * Khác biệt ở đây: thay vì chép tay dx/dy cho từng khung (dễ lệch), mọi bộ phận
 * đều đọc chung một `rig(frame)` — cùng một bộ toạ độ khớp xương. Tay áo không
 * thể trôi khỏi cánh tay vì cả hai lấy cùng một con số.
 *
 * Art vẽ bằng THANG XÁM để client nhân màu (multiply) lúc chạy: một sprite áo
 * phục vụ mọi màu áo, vẫn giữ nguyên khối sáng–tối chứ không bẹt thành một mảng
 * màu như cách tô lại toàn bộ pixel.
 */

export const PART_W = 40;
export const PART_H = 64;
export const PART_FRAMES = 6;

// Vạch đất tính từ ĐÁY ô. Ô cao hơn thân là cố ý: mũ vẽ cao hơn đỉnh đầu, mà
// Pixels.set chỉ cắt theo mép ảnh chứ không theo ô, nên thiếu khoảng hở là mũ
// tràn sang hàng trên và bám vào chân của bộ phận kế bên.
export const PART_GROUND = 2;
// Chiều cao thân thật (gót tới đỉnh đầu) — client lấy số này để quy ra tỉ lệ vẽ.
export const PART_BODY_H = 54;

// Thang xám: nhân với màu C ra C, C×0.78, C×0.59 — đủ ba bậc mà không tự chọn
// hộ người chơi sắc độ nào.
const L = [255, 255, 255, 255];
const B = [200, 200, 200, 255];
const D = [150, 150, 150, 255];
const K = [96, 96, 96, 255]; // viền/nếp gấp

/** Khung 0–1 đứng yên (thở), 2–5 là chu kỳ đi. */
const FRAMES = [
  { bob: 0, swing: 0 },
  { bob: -1, swing: 0 },
  { bob: 0, swing: 1 },
  { bob: -1, swing: 0 },
  { bob: 0, swing: -1 },
  { bob: -1, swing: 0 },
];

/**
 * Bộ khớp xương. Trả về toạ độ tuyệt đối trong ô sprite, đã cộng gốc ô, nên
 * hàm vẽ không phải tự cộng offset lần nữa.
 */
function rig(ox, oy, frame) {
  const { bob, swing } = FRAMES[frame];
  const cx = ox + PART_W / 2;
  const ground = oy + PART_H - PART_GROUND;
  const y = bob;
  return {
    cx, ground, swing,
    legBackX: cx - 5 - swing * 3,
    legFrontX: cx + 1 + swing * 3,
    legTop: ground - 20 + y,
    legH: 15,
    footY: ground - 5 + y,
    torso: { x: cx - 8, y: ground - 36 + y, w: 16, h: 17 },
    armBackX: cx - 12 + swing * 2,
    armFrontX: cx + 7 - swing * 2,
    armTop: ground - 34 + y,
    armH: 14,
    head: { cx, cy: ground - 44 + y, rx: 11, ry: 10 },
  };
}

/** Hộp bo góc nhẹ — dùng cho thân và món đồ có dáng vuông. */
function box(px, x, y, w, h, r, tone) {
  px.rect(x + r, y, w - r * 2, h, tone);
  px.rect(x, y + r, w, h - r * 2, tone);
  px.ellipse(x + r, y + r, r, r, tone);
  px.ellipse(x + w - r - 1, y + r, r, r, tone);
  px.ellipse(x + r, y + h - r - 1, r, r, tone);
  px.ellipse(x + w - r - 1, y + h - r - 1, r, r, tone);
}

/** Ống tròn đầu — dùng cho tay, chân. */
function capsule(px, x, y, w, h, tone) {
  // Bán kính phải kẹp theo cả chiều cao: hình thấp hơn rộng (đôi giày) mà lấy
  // r = w/2 thì hai chỏm tròn nằm chồng ra ngoài ô, tràn sang hàng bên cạnh
  // trên sheet — Pixels chỉ cắt theo mép ảnh chứ không theo ô.
  const r = Math.max(1, Math.min(w >> 1, h >> 1));
  px.rect(x, y + r, w, h - r * 2, tone);
  px.ellipse(x + w / 2 - 0.5, y + r, r, r, tone);
  px.ellipse(x + w / 2 - 0.5, y + h - r - 1, r, r, tone);
}

function body(px, r) {
  // Bóng đổ KHÔNG nằm trong sprite: sprite thân bị nhân với màu da lúc chạy,
  // bóng lọt vào đây sẽ thành vũng màu da. Bóng do renderer vẽ riêng.
  // Chân sau vẽ trước để chân trước đè lên — tạo chiều sâu ở góc nghiêng.
  capsule(px, r.legBackX, r.legTop, 6, r.legH, D);
  capsule(px, r.armBackX, r.armTop, 5, r.armH, D);
  box(px, r.torso.x, r.torso.y, r.torso.w, r.torso.h, 4, B);
  capsule(px, r.legFrontX, r.legTop, 6, r.legH, B);
  px.ellipse(r.head.cx, r.head.cy, r.head.rx, r.head.ry, B);
  px.ellipse(r.head.cx - 3, r.head.cy - 4, 6, 4, L); // vệt sáng trán
  capsule(px, r.armFrontX, r.armTop, 5, r.armH, L);
}

function face(px, r) {
  const { cx, cy } = r.head;
  px.ellipse(cx + 4, cy - 1, 1.6, 2.2, K);
  px.ellipse(cx - 2, cy - 1, 1.6, 2.2, K);
  px.ellipse(cx + 6.5, cy + 3, 2.2, 1.4, [255, 150, 150, 90]);
  px.ellipse(cx - 4.5, cy + 3, 2.2, 1.4, [255, 150, 150, 90]);
  px.rect(cx, cy + 4, 3, 1, K); // miệng
}

function pants(px, r, long) {
  const h = long ? r.legH - 1 : 7;
  capsule(px, r.legBackX - 1, r.legTop - 2, 8, h + 2, D);
  capsule(px, r.legFrontX - 1, r.legTop - 2, 8, h + 2, B);
  px.rect(r.torso.x, r.legTop - 3, r.torso.w, 3, D); // cạp
}

function shoes(px, r) {
  capsule(px, r.legBackX - 2, r.footY, 9, 6, D);
  capsule(px, r.legFrontX - 2, r.footY, 9, 6, B);
}

function tee(px, r) {
  const t = r.torso;
  box(px, t.x - 1, t.y - 1, t.w + 2, t.h - 2, 4, B);
  capsule(px, r.armBackX - 1, r.armTop - 1, 7, 7, D);   // tay áo sau
  capsule(px, r.armFrontX - 1, r.armTop - 1, 7, 7, L);  // tay áo trước
  px.rect(t.x + 2, t.y - 1, t.w - 4, 2, D);             // cổ áo
}

function dress(px, r) {
  const t = r.torso;
  box(px, t.x - 1, t.y - 1, t.w + 2, t.h - 2, 4, B);
  capsule(px, r.armBackX - 1, r.armTop - 1, 7, 6, D);
  capsule(px, r.armFrontX - 1, r.armTop - 1, 7, 6, L);
  // Chân váy loe: hai bậc thay vì một hình thang trơn, ở cỡ nhỏ đọc rõ hơn.
  px.rect(t.x - 2, t.y + t.h - 4, t.w + 4, 4, B);
  px.rect(t.x - 4 + r.swing, t.y + t.h, t.w + 8, 5, D);
  px.rect(t.x - 3 + r.swing, t.y + t.h, t.w + 6, 2, L);
}

function scarf(px, r) {
  const t = r.torso;
  px.rect(t.x, t.y - 1, t.w, 4, B);
  px.rect(t.x + t.w - 4 + r.swing, t.y + 2, 4, 7, D); // đuôi khăn bay theo bước
  px.rect(t.x + 1, t.y - 1, t.w - 2, 1, L);
}

function backpack(px, r) {
  const t = r.torso;
  capsule(px, t.x - 6, t.y + 1, 8, 14, B);
  px.rect(t.x - 6, t.y + 6, 8, 3, D);
  px.rect(t.x - 5, t.y + 2, 2, 12, L);
}

function hatStraw(px, r) {
  const { cx, cy, ry } = r.head;
  const brim = cy - ry + 3;
  px.ellipse(cx, brim, 14, 3, B);          // vành, hẹp lại để còn thấy mặt
  px.rect(cx - 14, brim - 1, 28, 2, D);
  px.ellipse(cx, brim - 4, 7, 5, L);       // chóp
  px.rect(cx - 7, brim - 3, 14, 2, D);     // dải nơ
}

function hatCap(px, r) {
  const { cx, cy, ry } = r.head;
  const band = cy - ry + 3;
  px.ellipse(cx - 1, band - 2, 10, 6, B);  // chỏm mũ
  px.rect(cx - 11, band - 2, 21, 3, B);
  px.rect(cx + 6, band, 9, 2, D);          // lưỡi trai chìa về phía mặt
  px.ellipse(cx - 4, band - 5, 4, 2, L);
}

/**
 * Tóc dựng từ các mảng CHỪA SẴN vùng mặt, không phải một ellipse phủ cả đầu.
 * Pixels không có lệnh xoá, nên phủ rồi khoét là không làm được — phải bố trí
 * sao cho ngay từ đầu không đè lên mắt mũi miệng (mặt nằm nửa phải, cy-2..cy+8).
 */
function hairCrown(px, r, backW) {
  const { cx, cy, rx, ry } = r.head;
  px.rect(cx - rx - 1, cy - ry + 1, rx * 2 + 2, 5, B);   // mái ngang đỉnh
  px.ellipse(cx, cy - ry + 3, rx, 4, B);                 // vòm chỏm
  px.rect(cx - rx - 1, cy - ry + 1, backW, 13, B);       // khối tóc sau gáy
  px.ellipse(cx + rx - 3, cy - ry + 5, 3, 4, D);         // mai bên má
  px.ellipse(cx - 4, cy - ry + 2, 5, 2, L);
}

function hairShort(px, r) {
  hairCrown(px, r, 7);
}

function hairLong(px, r) {
  const { cx, cy, rx, ry } = r.head;
  hairCrown(px, r, 8);
  capsule(px, cx - rx - 2, cy - ry + 4, 6, 20, D);       // lọn xoã sau lưng
}

function hairPony(px, r) {
  const { cx, cy, rx, ry } = r.head;
  hairCrown(px, r, 6);
  // Đuôi tóc hất theo bước chân — chi tiết nhỏ này làm dáng đi "sống" hẳn.
  capsule(px, cx - rx - 6 - r.swing, cy - ry + 4, 5, 13, D);
  px.ellipse(cx - rx - 1, cy - ry + 4, 4, 3, B);
}

/** Thứ tự trong mảng = thứ tự hàng trên sheet. zOrder mới là thứ tự vẽ. */
export const PARTS = [
  { name: 'back_pack', z: 0, draw: backpack },
  { name: 'body', z: 10, draw: body },
  { name: 'bottom_long', z: 20, draw: (px, r) => pants(px, r, true) },
  { name: 'bottom_short', z: 20, draw: (px, r) => pants(px, r, false) },
  { name: 'shoes', z: 25, draw: shoes },
  { name: 'top_tee', z: 30, draw: tee },
  { name: 'top_dress', z: 30, draw: dress },
  { name: 'face', z: 40, draw: face },
  { name: 'scarf', z: 45, draw: scarf },
  { name: 'hair_short', z: 50, draw: hairShort },
  { name: 'hair_long', z: 50, draw: hairLong },
  { name: 'hair_pony', z: 50, draw: hairPony },
  { name: 'hat_straw', z: 60, draw: hatStraw },
  { name: 'hat_cap', z: 60, draw: hatCap },
];

export function drawParts(px) {
  PARTS.forEach((part, row) => {
    for (let frame = 0; frame < PART_FRAMES; frame++) {
      part.draw(px, rig(frame * PART_W, row * PART_H, frame));
    }
  });
}
