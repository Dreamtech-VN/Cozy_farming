/**
 * Màn chờ tải tài nguyên.
 *
 * Bộ art nặng hơn 20 MB. Vào thẳng rồi để cảnh vật hiện dần trông như game lỗi,
 * nên chặn ở đây tới khi tải xong — nhưng phải cho thấy CÒN BAO LÂU: thanh chạy
 * theo số byte thật, không phải vòng xoay đoán mò.
 */
import { el, showOverlay, hideOverlay } from '../ui/ui.js';
import { atlas } from '../render/atlas.js';

const mb = (bytes) => (bytes / 1024 / 1024).toFixed(1);

export async function showLoading() {
  const total = atlas.totalBytes;
  if (!total) return;

  const bar = el('div', { class: 'progress-fill' });
  const pct = el('strong', { text: '0%' });
  const size = el('span', { class: 'progress-size', text: `0 / ${mb(total)} MB` });
  const track = el('div', {
    class: 'progress-track',
    role: 'progressbar',
    'aria-label': 'Tiến độ tải tài nguyên',
    'aria-valuemin': '0',
    'aria-valuemax': '100',
    'aria-valuenow': '0',
  }, [bar]);

  showOverlay(el('div', { class: 'card entry loading-card' }, [
    el('h1', { text: 'Đang tải thế giới' }),
    el('p', { class: 'lead', text: 'Tải xong một lần, lần sau vào sẽ nhanh vì trình duyệt giữ lại.' }),
    track,
    el('div', { class: 'progress-row' }, [pct, size]),
  ]), { backdrop: 'splash' });

  await atlas.preloadAll(({ loaded, total: all }) => {
    const ratio = all ? Math.min(1, loaded / all) : 1;
    const percent = Math.round(ratio * 100);
    bar.style.width = `${percent}%`;
    pct.textContent = `${percent}%`;
    size.textContent = `${mb(loaded)} / ${mb(all)} MB`;
    track.setAttribute('aria-valuenow', String(percent));
  });

  hideOverlay();
}
