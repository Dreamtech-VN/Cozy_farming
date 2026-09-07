#!/usr/bin/env node
/**
 * Sinh tileset và sprite sheet cho thế giới, ghi ra client/assets/world/.
 *
 * Art là CODE chứ không phải file nhị phân rơi vào repo: sửa một màu trong
 * palette là chạy lại lệnh này, mọi thứ đồng bộ ngay, và diff vẫn đọc được.
 */
import { writeFileSync, mkdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { Pixels } from './art/png.mjs';
import { drawTiles, TILE, TILE_NAMES } from './art/tiles.mjs';
import { drawProps, CELL, PROP_NAMES, PROP_COLS } from './art/props.mjs';
import { drawCrops, CROP_CELL, CROP_STAGES } from './art/crops.mjs';

const OUT = join(process.cwd(), 'client', 'assets', 'world');
mkdirSync(OUT, { recursive: true });

const write = (name, px) => {
  const png = px.toPng();
  writeFileSync(join(OUT, name), png);
  return `${name.padEnd(12)} ${String(px.width).padStart(4)}×${String(px.height).padEnd(4)} ${(png.length / 1024).toFixed(1)} KB`;
};

const tiles = new Pixels(TILE_NAMES.length * TILE, TILE);
drawTiles(tiles);

const propRows = Math.ceil(PROP_NAMES.length / PROP_COLS);
const props = new Pixels(PROP_COLS * CELL, propRows * CELL);
drawProps(props);

// Đọc thẳng content: một cây mới trong crops.json là có sprite ngay.
const cropContent = JSON.parse(readFileSync(join(process.cwd(), 'data', 'content', 'crops.json'), 'utf8')).crops;
const crops = new Pixels(CROP_STAGES * CROP_CELL, cropContent.length * CROP_CELL);
drawCrops(crops, cropContent);

console.log(write('tiles.png', tiles));
console.log(write('props.png', props));
console.log(write('crops.png', crops));

// Bản kê để client biết ô nào là gì mà không phải chép cứng chỉ số.
const atlas = {
  comment: 'Sinh bằng tools/gen-art.mjs — đừng sửa tay, sửa trong tools/art/ rồi chạy npm run art.',
  tiles: { file: 'tiles.png', size: TILE, names: TILE_NAMES },
  props: { file: 'props.png', cell: CELL, cols: PROP_COLS, names: PROP_NAMES },
  crops: { file: 'crops.png', cell: CROP_CELL, stages: CROP_STAGES, kinds: cropContent.map((c) => c.crop_id) },
};
writeFileSync(join(OUT, 'atlas.json'), JSON.stringify(atlas, null, 2) + '\n');
console.log('atlas.json   bản kê ô');
