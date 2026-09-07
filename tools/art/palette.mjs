/**
 * Bảng màu giới hạn cho toàn bộ art trong game.
 *
 * Ít màu buộc phải quyết định rõ ràng hơn, và quan trọng hơn là mọi thứ trong
 * cảnh nhìn ra CÙNG một thế giới. Mỗi chất liệu có đúng ba bậc: sáng (mặt hứng
 * sáng), gốc, tối (mặt khuất và viền dưới).
 */
const hex = (s) => [parseInt(s.slice(1, 3), 16), parseInt(s.slice(3, 5), 16), parseInt(s.slice(5, 7), 16), 255];

export const P = {
  none: null,

  grassLight: hex('#8fd45c'), grass: hex('#6ab543'), grassDark: hex('#4a8f31'),
  dirtLight:  hex('#b9855a'), dirt:  hex('#96653d'), dirtDark:  hex('#6f4728'),
  stoneLight: hex('#c9c2b4'), stone: hex('#a49b8c'), stoneDark: hex('#7c7365'),
  woodLight:  hex('#c58b52'), wood:  hex('#9c6437'), woodDark:  hex('#6d4423'),
  leafLight:  hex('#5fbf57'), leaf:  hex('#3f9c41'), leafDark:  hex('#2b7331'),
  waterLight: hex('#7fd4ee'), water: hex('#49b0d8'), waterDark: hex('#2b86ae'),
  roofLight:  hex('#e2665f'), roof:  hex('#c34840'), roofDark:  hex('#96322c'),
  wallLight:  hex('#fbe6c4'), wall:  hex('#eccfa2'), wallDark:  hex('#c9a97c'),
  cropLight:  hex('#ffd45e'), crop:  hex('#f2ae2e'), cropDark:  hex('#c9821b'),
  flowerA: hex('#ff8fb1'), flowerB: hex('#fff0a5'), flowerC: hex('#b98cf0'),
  shadow: [40, 30, 20, 60],
  outline: hex('#3a2a1e'),
};
