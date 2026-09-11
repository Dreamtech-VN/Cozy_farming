/**
 * Thẻ hướng dẫn người mới trên HUD.
 *
 * Chỉ hiện ĐÚNG MỘT việc đang phải làm, không phải danh sách. Người mới đã ngợp
 * vì màn hình có mười mấy nút; đưa thêm một danh sách sáu gạch đầu dòng là họ
 * đọc lướt rồi bỏ qua hết.
 *
 * Server giữ tiến trình (xem `domain/onboarding.js`), client chỉ báo "vừa làm
 * việc này" rồi vẽ lại theo bước server trả về. Client KHÔNG tự quyết bước nào
 * tiếp theo: hai bên cùng suy ra thì kiểu gì cũng có lúc lệch, mà lệch ở đây
 * nghĩa là người chơi kẹt ở một bước đã làm xong.
 */
import { t } from '../core/i18n.js';
import { audio } from '../core/audio.js';

const card = () => document.getElementById('onboarding-card');

/** Vẽ lại thẻ. `step` là null khi đã xong hoặc đã bỏ qua — ẩn hẳn. */
export function renderOnboarding(game, step, { index, total } = {}) {
  const node = card();
  if (!node) return;
  if (!step) { node.classList.add('hidden'); node.replaceChildren(); return; }

  node.classList.remove('hidden');
  node.replaceChildren();

  const head = document.createElement('div');
  head.className = 'ob-head';
  head.append('Hướng dẫn');
  if (index != null && total != null) {
    const counter = document.createElement('span');
    counter.className = 'ob-step';
    counter.textContent = `${index + 1}/${total}`;
    head.append(counter);
  }

  const name = document.createElement('div');
  name.className = 'ob-name';
  name.textContent = t(step.name_key);

  const desc = document.createElement('div');
  desc.className = 'ob-desc';
  desc.textContent = t(step.desc_key);

  const skip = document.createElement('button');
  skip.className = 'ob-skip';
  skip.type = 'button';
  skip.textContent = 'Bỏ qua hướng dẫn';
  skip.addEventListener('click', () => game.skipOnboarding());

  node.append(head, name, desc, skip);
}

/** Kêu một tiếng khi xong một bước — cùng tiếng với mọi việc hoàn tất khác. */
export function onboardingDone() { audio.success(); }
