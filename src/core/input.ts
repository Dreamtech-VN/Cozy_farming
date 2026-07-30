// Đầu vào ảo dùng chung: joystick cảm ứng (DOM) + bàn phím đều ghi vào đây,
// WorldScene đọc mỗi frame.
export const virtualInput = {
  x: 0,          // -1..1
  y: 0,          // -1..1
  actionQueued: false // nút hành động (A) vừa bấm
};

export function queueAction() {
  virtualInput.actionQueued = true;
}

export function consumeAction(): boolean {
  const v = virtualInput.actionQueued;
  virtualInput.actionQueued = false;
  return v;
}
