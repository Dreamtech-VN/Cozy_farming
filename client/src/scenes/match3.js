/**
 * Màn Match-3 (doc 07 + doc 12).
 * Client chỉ vẽ board mà server trả về và gửi swap; mọi phán quyết ở server.
 */
import { el, showOverlay, hideOverlay, toast } from '../ui/ui.js';
import { t, formatNumber } from '../core/i18n.js';

const CELL = 40;
const GAP = 4;

export class Match3Scene {
  constructor(game) {
    this.game = game;
    this.match = null;
    this.selected = null;
    this.busy = false;
    this.flash = new Map();
  }

  async start(levelId) {
    try {
      this.match = await this.game.api.post('/v1/matches', { level_id: levelId });
    } catch (err) {
      toast(err.message, 'bad');
      return;
    }
    this.selected = null;
    this.level = this.game.content.levelsById.get(levelId);
    this.enemyMaxHp = this.match.enemy.max_hp ?? this.match.enemy.hp;
    this.#buildUi();
    this.#draw();
  }

  #buildUi() {
    this.canvas = el('canvas', { class: 'm3-board', width: 8 * (CELL + GAP), height: 8 * (CELL + GAP) });
    this.canvas.style.cssText = 'width:100%;max-width:360px;aspect-ratio:1;touch-action:manipulation;border-radius:12px';
    this.canvas.addEventListener('pointerdown', (event) => this.#onPointer(event));

    this.enemyBar = el('div', { style: 'height:10px;background:#35513f;border-radius:999px;overflow:hidden' }, [
      el('div', { style: 'height:100%;width:100%;background:#e0576f;transition:width .25s' }),
    ]);
    this.stats = el('div', { style: 'display:flex;justify-content:space-between;font-size:13px;color:#a8c0ae;margin:6px 0' });

    const card = el('div', { class: 'card' }, [
      el('h1', { text: t(this.level.name_key) }),
      el('p', { class: 'lead', text: `${t(this.level.enemy.name_key)} — ghép 3 ô cùng màu để tấn công` }),
      this.enemyBar,
      this.stats,
      el('div', { style: 'display:flex;justify-content:center' }, [this.canvas]),
      el('div', { class: 'actions' }, [
        el('button', {
          class: 'ghost', type: 'button', text: 'Bỏ trận',
          onClick: () => this.#abandon(),
        }),
      ]),
    ]);
    showOverlay(card);
  }

  #draw() {
    const ctx = this.canvas.getContext('2d');
    const board = this.match.board;
    const colors = Object.fromEntries(this.game.content.tileTypes.map((tile) => [tile.tile_id, tile.color]));

    ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    for (let y = 0; y < board.height; y++) {
      for (let x = 0; x < board.width; x++) {
        const cell = board.cells[y * board.width + x];
        const px = x * (CELL + GAP) + GAP / 2;
        const py = y * (CELL + GAP) + GAP / 2;

        ctx.fillStyle = 'rgba(255,255,255,.05)';
        ctx.fillRect(px, py, CELL, CELL);
        if (!cell?.t) continue;

        const selected = this.selected && this.selected.x === x && this.selected.y === y;
        ctx.fillStyle = colors[cell.t] ?? '#888';
        ctx.beginPath();
        ctx.roundRect(px + 3, py + 3, CELL - 6, CELL - 6, cell.s ? 6 : 10);
        ctx.fill();

        if (cell.s) { // special tile — viền sáng cho dễ nhận biết
          ctx.strokeStyle = '#fff';
          ctx.lineWidth = 2.5;
          ctx.stroke();
          ctx.fillStyle = 'rgba(255,255,255,.85)';
          ctx.font = '600 11px system-ui';
          ctx.textAlign = 'center';
          ctx.fillText(SPECIAL_GLYPH[cell.s] ?? '*', px + CELL / 2, py + CELL / 2 + 4);
        }
        if (selected) {
          ctx.strokeStyle = '#fff';
          ctx.lineWidth = 3;
          ctx.strokeRect(px + 1, py + 1, CELL - 2, CELL - 2);
        }
      }
    }

    const ratio = Math.max(0, this.match.enemy_hp ?? this.match.enemy.hp) / this.enemyMaxHp;
    this.enemyBar.firstChild.style.width = `${ratio * 100}%`;
    this.stats.replaceChildren(
      el('span', { text: `Lượt còn lại: ${this.match.moves_left}` }),
      el('span', { text: `Điểm: ${formatNumber(this.match.score ?? 0)}` }),
    );
  }

  #onPointer(event) {
    if (this.busy) return;
    const rect = this.canvas.getBoundingClientRect();
    const scale = this.canvas.width / rect.width;
    const x = Math.floor(((event.clientX - rect.left) * scale) / (CELL + GAP));
    const y = Math.floor(((event.clientY - rect.top) * scale) / (CELL + GAP));
    const board = this.match.board;
    if (x < 0 || y < 0 || x >= board.width || y >= board.height) return;

    if (!this.selected) {
      this.selected = { x, y };
      this.#draw();
      return;
    }
    const distance = Math.abs(this.selected.x - x) + Math.abs(this.selected.y - y);
    if (distance === 0) { this.selected = null; this.#draw(); return; }
    if (distance !== 1) { this.selected = { x, y }; this.#draw(); return; }

    const from = this.selected;
    this.selected = null;
    this.#swap(from, { x, y });
  }

  async #swap(from, to) {
    this.busy = true;
    try {
      const result = await this.game.api.post(`/v1/matches/${this.match.match_id}/actions`, {
        action: { type: 'swap', from, to },
      });
      this.match.board = result.board;
      this.match.moves_left = result.moves_left;
      this.match.enemy_hp = result.enemy_hp;
      this.match.score = result.score;
      this.#draw();

      if (result.enemy_attacked) toast(`Bị phản đòn ${result.enemy_attacked} sát thương`, 'bad');
      if (result.reshuffled) toast('Bàn cờ bí — đã xáo lại');
      if (result.state !== 'active') await this.#finish(result);
    } catch (err) {
      if (err.code === 'conflict') toast('Nước đi không hợp lệ');
      else toast(err.message, 'bad');
    } finally {
      this.busy = false;
    }
  }

  async #finish(result) {
    const settlement = result.settlement ?? {};
    const won = result.state === 'won';
    const rewards = settlement.rewards ?? {};
    const lines = [];
    if (rewards.coin) lines.push(`+${formatNumber(rewards.coin)} xu`);
    if (rewards.gem) lines.push(`+${formatNumber(rewards.gem)} ngọc`);
    if (rewards.xp) lines.push(`+${formatNumber(rewards.xp)} kinh nghiệm`);
    for (const item of rewards.items ?? []) {
      lines.push(`+${item.count} ${t(this.game.content.itemsById.get(item.item_id)?.name_key ?? item.item_id)}`);
    }

    showOverlay(el('div', { class: 'card' }, [
      el('h1', { text: won ? 'Chiến thắng!' : 'Thua rồi' }),
      el('p', { class: 'lead', text: won ? (settlement.first_clear ? 'Lần đầu vượt màn — thưởng thêm!' : 'Phần thưởng đã được cộng.') : 'Thử lại lần sau nhé.' }),
      lines.length ? el('div', {}, lines.map((line) => el('div', { class: 'row' }, [el('span', { class: 'grow', text: line })]))) : null,
      el('div', { class: 'actions' }, [
        el('button', { class: 'primary', type: 'button', text: 'Quay lại thế giới', onClick: () => this.#exit() }),
      ]),
    ]));
    await this.game.refreshPlayer();
  }

  async #abandon() {
    try {
      await this.game.api.post(`/v1/matches/${this.match.match_id}/finish`, {});
    } catch { /* trận có thể đã kết thúc */ }
    this.#exit();
  }

  #exit() {
    this.match = null;
    hideOverlay();
    this.game.resumeWorld();
  }
}

const SPECIAL_GLYPH = {
  sp_line_h: '↔',
  sp_line_v: '↕',
  sp_area: '✸',
  sp_color: '★',
};
