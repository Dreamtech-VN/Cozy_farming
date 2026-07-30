// Hệ số độ phân giải render: canvas dựng ở 960x540 * RES rồi FIT ra màn hình.
// Màn hình retina (DPR >= 2) render gấp đôi -> pixel art sắc nét, không nhòe.
export const RES = Math.min(2, Math.max(1, Math.round((typeof window !== 'undefined' ? window.devicePixelRatio : 1) || 1)));
