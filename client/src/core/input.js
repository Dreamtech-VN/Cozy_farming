/** Điều khiển bằng bàn phím. Game chạy ở màn hình ngang, không có nút cảm ứng. */
export class Input {
  constructor() {
    this.keys = { left: false, right: false, jump: false, action: false };
    this.actionPressed = false;
    this.enabled = true;

    const map = {
      ArrowLeft: 'left', KeyA: 'left',
      ArrowRight: 'right', KeyD: 'right',
      Space: 'jump', ArrowUp: 'jump', KeyW: 'jump',
      KeyE: 'action', Enter: 'action',
    };

    addEventListener('keydown', (event) => {
      if (!this.enabled || event.repeat) return;
      const target = event.target;
      if (target instanceof HTMLInputElement || target instanceof HTMLTextAreaElement) return;
      const key = map[event.code];
      if (!key) return;
      event.preventDefault();
      this.keys[key] = true;
      if (key === 'action') this.actionPressed = true;
    });

    addEventListener('keyup', (event) => {
      const key = map[event.code];
      if (key) this.keys[key] = false;
    });

    addEventListener('blur', () => { for (const key of Object.keys(this.keys)) this.keys[key] = false; });

  }

  /** Đọc-và-xoá: dùng cho hành động một lần như "tương tác". */
  consumeAction() {
    const pressed = this.actionPressed;
    this.actionPressed = false;
    return pressed;
  }
}
