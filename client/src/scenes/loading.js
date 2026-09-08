/**
 * Màn chờ tải tài nguyên.
 *
 * Bộ art nặng hơn 20 MB. Vào thẳng rồi để cảnh vật hiện dần trông như game lỗi,
 * nên chặn ở đây tới khi tải xong — nhưng phải cho thấy CÒN BAO LÂU: thanh chạy
 * theo số byte thật, không phải vòng xoay đoán mò.
 *
 * Bố cục bám đúng bản mẫu: chữ và thanh nằm thẳng trên tranh, không bọc trong
 * thẻ. Đặt trùng chỗ thanh vẽ chết trong tranh nên nó bị che, khỏi cần phủ mờ
 * mạnh tay.
 */
import { el, showOverlay, hideOverlay } from '../ui/ui.js';
import { atlas } from '../render/atlas.js';

const mb = (bytes) => (bytes / 1024 / 1024).toFixed(1);

const TIPS = [
  'Kết bạn và cùng dựng nên thị trấn của riêng bạn!',
  'Cây trồng lâu thì lời nhiều hơn, cây nhanh thì được nhiều kinh nghiệm hơn.',
  'Điểm danh mỗi ngày để nhận thưởng, bỏ một ngày là chuỗi tính lại từ đầu.',
  'Bấm vào ảnh đại diện để xem và thay đồ cho nhân vật.',
];

export async function showLoading() {
  const total = atlas.totalBytes;
  if (!total) return;

  const bar = el('div', { class: 'load-fill' });
  const pct = el('span', { class: 'load-pct', text: '0%' });
  const size = el('span', { class: 'load-size', text: `0 / ${mb(total)} MB` });
  const track = el('div', {
    class: 'load-track',
    role: 'progressbar',
    'aria-label': 'Tiến độ tải tài nguyên',
    'aria-valuemin': '0',
    'aria-valuemax': '100',
    'aria-valuenow': '0',
  }, [bar]);

  showOverlay(el('div', { class: 'load-hud' }, [
    el('div', { class: 'load-row' }, [
      el('span', { class: 'load-label', text: 'Đang tải…' }),
      pct,
    ]),
    track,
    el('div', { class: 'load-foot' }, [
      el('span', { class: 'load-tip', text: `💡 ${TIPS[Math.floor(Math.random() * TIPS.length)]}` }),
      size,
    ]),
  ]), { backdrop: 'loading' });

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
