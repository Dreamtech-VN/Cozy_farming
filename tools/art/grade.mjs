/**
 * Nắn tông cho bộ art PROP về đúng dải sáng của TRANH NỀN.
 *
 * Bộ prop và tranh nền là hai bộ art khác nhau, vẽ khác tay. Ghép vào một khung
 * hình thì lộ ra ngay: công trình với trạm xe buýt trông như dán đè lên tranh
 * chứ không đứng trong tranh. Đo mới biết chỗ vênh nằm ở đâu.
 *
 * Đo trên tranh nền, chỉ lấy phần NHÂN TẠO (gạch, gỗ, hàng rào — bỏ cây cỏ, bỏ
 * trời, bỏ nền lát), vì đấy mới là thứ cùng loại với công trình:
 *
 *     tối(p5)=32   giữa=119   sáng(p95)=202   bão hoà giữa=0.28
 *
 * Cả bộ prop (trang outdoor + indoor gộp lại):
 *
 *     tối(p5)=9    giữa=94    sáng(p95)=212   bão hoà giữa=0.57
 *
 * Chỗ vênh nặng nhất là VÙNG TỐI: 9 so với 32. Tranh nền không có chỗ nào đen
 * tới thế — nó vẽ bóng bằng màu xanh xám chứ không dìm về đen. Bộ prop dìm thật,
 * nên cạnh nào cũng gắt, vật nào cũng nặng, nhìn ra ngay là hai lớp khác nhau.
 * Không một sprite nào trong bộ nằm trong dải của tranh: chỗ tối của chúng chạy
 * từ 3 tới 19.
 *
 * Bão hoà thì KHÔNG kéo về 0.28. Con số ấy đo trên gạch với gỗ với hàng rào —
 * toàn thứ vốn nhạt màu — chứ tranh nền không có cái mái hiên đỏ hay tủ hoa nào
 * để mà so. Ép cả bộ prop xuống 0.28 là bạc màu hết mái hiên tiệm bánh, thị trấn
 * hoá ra xám ngoét. Chỉ ép phần NGỌN: dưới 0.5 để yên, trên 0.5 nén lại, nên
 * trạm xe buýt (0.26, vốn đã khớp) không bị đụng tới mà mái hiên rực nhất cũng
 * dịu xuống.
 *
 * Áp cho từng MẢNH đã cắt chứ không cho cả tấm: cả tấm còn nền chưa gỡ, nắn vào
 * đó là đổi luôn màu nền rồi phép dò nền đo trượt.
 */

/** Dải sáng của tranh nền, phần nhân tạo. */
const FLOOR = 32;
const CEIL = 202;
/** Dải sáng của bộ prop. */
const SRC_FLOOR = 9;
const SRC_SPAN = 203;
/**
 * Sau khi kéo hai đầu về dải tranh nền, điểm GIỮA vẫn lệch: 94 kéo tuyến tính ra
 * 100, mà tranh nền nằm ở 119. Nên bẻ thêm một nhịp gamma cho trung gian lên
 * đúng chỗ — thiếu nhịp này thì hết bóng đen nhưng cả vật vẫn xỉn hơn tranh.
 * 0.769 = ln((119−32)/170) / ln((94−9)/203).
 */
const GAMMA = 0.769;
/** Ngưỡng và mức nén của phần bão hoà vượt ngọn. */
const SAT_KNEE = 0.5;
const SAT_SQUEEZE = 0.55;

const clamp = (v, lo, hi) => (v < lo ? lo : v > hi ? hi : v);

/** Nắn một mảnh đã cắt. Sửa thẳng vào `data`, chỉ đụng pixel còn đục. */
export function gradeToMap({ w, h, data }) {
  for (let i = 0; i < w * h * 4; i += 4) {
    if (data[i + 3] < 8) continue;
    const r = data[i], g = data[i + 1], b = data[i + 2];
    const lum = 0.299 * r + 0.587 * g + 0.114 * b;
    if (lum < 1) continue;

    const n = clamp((lum - SRC_FLOOR) / SRC_SPAN, 0, 1);
    const target = FLOOR + (CEIL - FLOOR) * n ** GAMMA;

    // Nén bão hoà quanh mức xám của chính pixel, nên đổi độ tươi mà không đổi
    // sắc: kéo thẳng từng kênh về phía nhau là ngả màu.
    const max = Math.max(r, g, b);
    const sat = max ? (max - Math.min(r, g, b)) / max : 0;
    const keep = sat > SAT_KNEE ? (SAT_KNEE + (sat - SAT_KNEE) * SAT_SQUEEZE) / sat : 1;

    // Đưa về tông đích bằng phép NHÂN, giữ nguyên tỉ lệ giữa ba kênh.
    const k = target / lum;
    for (let c = 0; c < 3; c++) {
      const v = data[i + c];
      data[i + c] = Math.round(clamp((lum + (v - lum) * keep) * k, 0, 255));
    }
  }
}
