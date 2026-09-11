/**
 * Phản hồi khi hành động: số bay lên, chớp sáng khi lên cấp, bụi khi thu hoạch.
 *
 * Game trước đây báo mọi thứ bằng toast ở góc màn hình. Toast nói ĐÚNG nhưng nói
 * sai chỗ: mắt đang nhìn luống cây thì cái được báo lại hiện ở góc trên, nên
 * hành động và kết quả rời nhau ra, bấm mà không thấy "ăn". Số bay lên ngay trên
 * đầu nhân vật thì nối lại được hai thứ ấy.
 *
 * Hiệu ứng vẽ ở TOẠ ĐỘ THẾ GIỚI, cùng phép biến hình với nhân vật: camera đi thì
 * nó đi theo, neo đúng chỗ vừa xảy ra chuyện. Vẽ ở toạ độ màn hình thì số sẽ
 * trôi ngang khi người chơi đi, nhìn như nó bay theo mình chứ không phải bay lên
 * từ luống cây.
 *
 * Không giữ mảng hạt cho từng hiệu ứng. Mỗi mục chỉ nhớ điểm xuất phát và mốc
 * thời gian, còn lại tính thẳng từ `time` — cùng cách `#drawRain` đang làm.
 *
 * Đồng hồ lấy từ chính vòng vẽ và lớp này tự nhớ lấy. Chỗ gọi `pop` nằm ngoài
 * vòng vẽ (panel, chỗ làm mới hồ sơ) nên không cầm đồng hồ ấy; để chúng tự lấy
 * `performance.now()` là sai gốc — game đếm giờ từ lúc VÀO THẾ GIỚI, còn
 * `performance.now()` đếm từ lúc mở trang, lệch nhau bao nhiêu tuỳ người chơi
 * ngồi ở màn đăng nhập bao lâu. Lệch gốc thì tuổi hiệu ứng tính ra âm, số bay
 * vọt khỏi màn hình ngay khung đầu — mất hẳn, mà không báo lỗi gì.
 */

/** Bao lâu thì một số bay hết vòng đời, tính bằng giây. */
const LIFE = 1.25;
/** Bay lên bao nhiêu pixel thế giới trong cả vòng đời. */
const RISE = 46;
/** Xếp chồng: hai mục nảy cùng lúc thì mục sau lùi xuống chừng này để khỏi đè. */
const STACK = 22;

const KIND = {
  coin: { colour: '#ffd66b', edge: '#6b4a10' },
  gem: { colour: '#c9a6ff', edge: '#3d2a66' },
  xp: { colour: '#9fe6a0', edge: '#1f4a24' },
  item: { colour: '#eaf2ea', edge: '#243028' },
  level: { colour: '#ffe9a8', edge: '#6b4a10' },
};

export class Fx {
  #items = [];
  #lastAt = 0;
  #stack = 0;
  /** Giờ của khung vẽ gần nhất. Nguồn thời gian DUY NHẤT của cả lớp này. */
  #now = 0;

  /**
   * Thêm một số bay lên.
   * @param kind khoá trong `KIND` — quyết định màu, để mắt phân biệt được xu với
   *   XP mà không phải đọc chữ.
   */
  pop(x, y, text, kind = 'coin') {
    const time = this.#now;
    // Nhiều thứ cùng nảy một lúc là chuyện thường: thu hoạch cho cả nông sản lẫn
    // XP lẫn xu. Không xếp chồng thì ba con số nằm đè lên nhau thành một vệt.
    this.#stack = time - this.#lastAt < 0.25 ? this.#stack + 1 : 0;
    this.#lastAt = time;
    this.#items.push({ x, y: y + this.#stack * STACK, text, kind, born: time });
    if (this.#items.length > 40) this.#items.splice(0, this.#items.length - 40);
  }

  /** Vòng sáng lan ra, dùng cho lên cấp và thu hoạch. */
  burst(x, y, tint = '#ffe9a8') {
    this.#items.push({ x, y, burst: true, tint, born: this.#now });
  }

  get busy() { return this.#items.length > 0; }

  /** Vẽ trong hệ toạ độ THẾ GIỚI — gọi bên trong phép biến hình của camera. */
  draw(ctx, time) {
    this.#now = time;
    if (!this.#items.length) return;
    let alive = 0;
    for (const item of this.#items) {
      const age = (time - item.born) / LIFE;
      if (age >= 1) continue;
      this.#items[alive++] = item;
      if (item.burst) { this.#drawBurst(ctx, item, age); continue; }
      this.#drawPop(ctx, item, age);
    }
    this.#items.length = alive;
  }

  #drawPop(ctx, item, age) {
    // Bật lên nhanh rồi chậm dần: nảy đều tăm tắp nhìn ra máy móc, không ra "ăn".
    const rise = RISE * (1 - (1 - age) ** 2);
    const fade = age < 0.7 ? 1 : 1 - (age - 0.7) / 0.3;
    const { colour, edge } = KIND[item.kind] ?? KIND.coin;
    ctx.save();
    ctx.globalAlpha = fade;
    ctx.font = '700 17px system-ui, sans-serif';
    ctx.textAlign = 'center';
    ctx.lineJoin = 'round';
    ctx.lineWidth = 4;
    ctx.strokeStyle = edge;
    ctx.strokeText(item.text, item.x, item.y - rise);
    ctx.fillStyle = colour;
    ctx.fillText(item.text, item.x, item.y - rise);
    ctx.restore();
  }

  #drawBurst(ctx, item, age) {
    const r = 10 + age * 46;
    ctx.save();
    ctx.globalAlpha = (1 - age) * 0.7;
    ctx.strokeStyle = item.tint;
    ctx.lineWidth = 3 * (1 - age) + 1;
    ctx.beginPath();
    ctx.arc(item.x, item.y, r, 0, Math.PI * 2);
    ctx.stroke();
    ctx.restore();
  }
}

export const fx = new Fx();
