/**
 * Màn nhân vật, hiện SAU khi chọn server.
 *
 * Nhân vật thuộc về một server cụ thể, nên phải hỏi server trước rồi mới tới
 * nhân vật — gộp vào bước đăng ký là khoá cứng người chơi vào server đầu tiên
 * họ gặp.
 *
 * Một màn lo hai việc: chưa có nhân vật thì hiện bàn tạo, có rồi thì hiện thẻ
 * nhân vật để bấm vào chơi. Tách hai màn thì phần lớn giao diện lặp lại y hệt.
 */
import { el, showOverlay, hideOverlay, bindSubmit } from '../ui/ui.js';
import { atlas } from '../render/atlas.js';
import { drawLook, drawThumb, lookOptions, defaultLook, randomLook, SKIN_TONES, EYE_COLOURS } from '../render/paperdoll.js';

const GENDERS = [
  { id: 'a', code: 'm', label: 'Nam', icon: 'male' },
  { id: 'b', code: 'f', label: 'Nữ', icon: 'female' },
];

const genderOf = (bodyType) => GENDERS.find((g) => g.id === bodyType) ?? GENDERS[0];

/**
 * Tâm vòng gạch trong tranh nền, đo trên chính file create.png.
 *
 * Vị trí vòng gạch trên màn hình đổi theo bề ngang khung nhìn — đặt nhân vật
 * bằng một con số CSS cố định thì màn cỡ khác là lệch ra khỏi vòng ngay. Tính
 * theo đúng cách phủ của CSS: `100% auto` neo đáy, tức là tranh kéo vừa bề
 * ngang, cao theo tỉ lệ, dính đáy.
 */
const PLAZA = { w: 640, h: 208, x: 273, y: 186 };

function plazaPointIn(box) {
  const s = box.width / PLAZA.w;
  return {
    x: PLAZA.x * s,
    y: box.height - PLAZA.h * s + PLAZA.y * s,
  };
}

/**
 * Khung xem trước nhân vật.
 *
 * Vẽ bằng canvas chứ không ghép thẻ <img> chồng nhau: đổi tông da phải sửa
 * từng pixel, mà ba mảnh còn phải căn theo mốc đo được trong atlas.
 */
// Nhân vật cao bao nhiêu so với tranh nền, đo trên bản mẫu: cao chừng 37% bề
// ngang tranh. Buộc vào tranh chứ không đặt một số pixel cố định — tranh phủ
// theo bề ngang nên màn rộng hơn là tranh to hơn, nhân vật phải to theo.
const CHAR_OF_BG = 0.37;

function stage(get, { width = 300, height = 400, onPlaza = false } = {}) {
  const canvas = el('canvas', { width: width * 2, height: height * 2, class: 'cc-stage' });
  let box = { w: width, h: height, charH: height - 60 };
  const draw = () => {
    const dpr = 2;
    if (canvas.width !== Math.round(box.w * dpr)) {
      canvas.width = Math.round(box.w * dpr);
      canvas.height = Math.round(box.h * dpr);
      canvas.style.width = `${box.w}px`;
      canvas.style.height = `${box.h}px`;
    }
    const ctx = canvas.getContext('2d');
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    ctx.clearRect(0, 0, box.w, box.h);
    const { w: width, h: height } = box;
    const groundY = height - 26;

    // Bóng đổ dưới chân: không có thì nhân vật như dán lên tranh nền.
    ctx.save();
    ctx.translate(width / 2, groundY);
    ctx.scale(1, 0.18);
    ctx.beginPath();
    ctx.arc(0, 0, width * 0.2, 0, Math.PI * 2);
    ctx.fillStyle = 'rgba(46, 66, 42, .18)';
    ctx.fill();
    ctx.restore();

    if (!drawLook(ctx, atlas, get(), { x: width / 2, groundY, height: box.charH })) {
      // Art chưa tới nơi: vẽ lại khi trang tải xong, không có vòng lặp nào lo hộ.
      atlas.ensurePage('parts')?.then(draw);
    }
  };
  draw();

  // Đứng đúng giữa vòng gạch: quy chân nhân vật về điểm vừa tính trong toạ độ
  // của khung nền, rồi đổi sang toạ độ của thẻ cha.
  const place = () => {
    if (!canvas.isConnected) return false;
    const stageBox = canvas.parentElement.getBoundingClientRect();
    const overlay = document.getElementById('overlay');
    const backdrop = overlay.getBoundingClientRect();
    const point = plazaPointIn(backdrop);
    // Mép trên của tranh nền, để dải trời nối lên trên kết thúc đúng chỗ đó.
    overlay.style.setProperty('--bg-top', `${backdrop.height - PLAZA.h * (backdrop.width / PLAZA.w)}px`);
    // Cỡ khung vẽ bám theo cỡ nhân vật, chừa chỗ cho tóc dựng và bóng đổ.
    const charH = backdrop.width * CHAR_OF_BG;
    box = { w: Math.round(charH * 0.9), h: Math.round(charH + 40), charH };
    draw();
    canvas.style.left = `${backdrop.left - stageBox.left + point.x - box.w / 2}px`;
    canvas.style.top = `${backdrop.top - stageBox.top + point.y - (box.h - 26)}px`;
    return true;
  };
  if (onPlaza) {
    canvas.classList.add('on-plaza');
    place();
    // Đổi cỡ cửa sổ là vòng gạch chạy chỗ khác, phải đặt lại. Tự gỡ khi màn
    // đóng — màn ngoài game không có chỗ nào dọn dẹp hộ.
    const onResize = () => { if (!place()) removeEventListener('resize', onResize); };
    addEventListener('resize', onResize);
    requestAnimationFrame(place);
  }
  return { canvas, draw, place };
}

/** Một hàng lựa chọn: ô xem trước cuộn ngang, hai nút mũi tên hai đầu. */
function chooser(label, names, { selected, onPick, thumb, perPage = 4 }) {
  let start = 0;
  const cells = el('div', { class: 'cc-cells' });
  const arrow = (dir) => el('button', {
    class: `cc-arrow ${dir < 0 ? 'left' : 'right'}`, type: 'button',
    'aria-label': dir < 0 ? `${label}: lùi lại` : `${label}: xem tiếp`,
    onClick: () => {
      // Cuộn vòng: danh sách ngắn, đi tới cuối rồi chặn lại thì nút chết mà
      // không rõ vì sao.
      start = (start + dir * perPage + names.length) % names.length;
      render();
    },
  }, [el('i', { class: `ico ico-caret-${dir < 0 ? 'left' : 'right'}` })]);

  const render = () => {
    const shown = Array.from({ length: Math.min(perPage, names.length) },
      (_, i) => names[(start + i) % names.length]);
    cells.replaceChildren(...shown.map((name) => {
      const canvas = el('canvas', { width: 128, height: 128 });
      const paint = () => {
        const ctx = canvas.getContext('2d');
        ctx.setTransform(2, 0, 0, 2, 0, 0);
        ctx.clearRect(0, 0, 64, 64);
        if (!thumb(ctx, name, { x: 2, y: 2, w: 60, h: 60 })) atlas.ensurePage('parts')?.then(paint);
      };
      paint();
      return el('button', {
        class: 'cc-cell', type: 'button', role: 'radio',
        'aria-checked': name === selected() ? 'true' : 'false',
        'aria-label': name,
        onClick: () => { onPick(name); refresh(); },
      }, [canvas]);
    }));
  };
  const refresh = () => {
    for (const cell of cells.children) {
      cell.setAttribute('aria-checked', cell.getAttribute('aria-label') === selected() ? 'true' : 'false');
    }
  };
  render();

  return {
    node: el('div', { class: 'cc-row' }, [
      el('span', { class: 'cc-label', text: label }),
      el('div', { class: 'cc-strip' }, [arrow(-1), cells, arrow(1)]),
    ]),
    refresh,
    rebuild: (next) => { names = next; start = 0; render(); },
  };
}

function showExisting(game, character, resolve) {
  const look = character.appearance ?? null;
  const { canvas } = stage(() => look ?? defaultLook(atlas, genderOf(character.body_type).code),
    { width: 200, height: 260 });
  showOverlay(el('div', { class: 'char-pick' }, [
    canvas,
    el('div', { class: 'char-card' }, [
      el('strong', { class: 'char-name', text: character.nickname }),
      el('span', { class: 'char-meta', text: `Cấp ${character.level}` }),
    ]),
    el('button', {
      class: 'primary server-start', type: 'button', text: 'Vào game',
      onClick: () => { hideOverlay(); resolve(null); },
    }),
  ]), { backdrop: 'character' });
}

export function showCharacterScreen(game, characters) {
  return new Promise((resolve) => {
    if (characters.length) return showExisting(game, characters[0], resolve);

    let look = defaultLook(atlas, 'm');
    const preview = stage(() => look, { onPlaza: true });
    const error = el('div', { class: 'error hidden' });
    const nickname = el('input', {
      type: 'text', maxlength: '16', class: 'cc-name',
      placeholder: 'Nhập tên nhân vật…', 'aria-label': 'Tên nhân vật',
    });

    const rows = {
      hair: chooser('Kiểu tóc', [], {
        selected: () => look.hair,
        onPick: (name) => { look = { ...look, hair: name }; preview.draw(); },
        thumb: (ctx, name, box) => drawThumb(ctx, atlas, name,
          { ...box, face: look.face, skin: look.skin, eyes: look.eyes }),
      }),
      outfit: chooser('Trang phục', [], {
        selected: () => look.outfit,
        onPick: (name) => { look = { ...look, outfit: name }; preview.draw(); },
        thumb: (ctx, name, box) => drawThumb(ctx, atlas, name, { ...box, skin: look.skin }),
      }),
    };

    /** Hàng ô màu: dùng chung cho màu da và màu mắt. */
    const swatches = (label, colours, get, set) => el('div',
      { class: 'cc-skins', role: 'radiogroup', 'aria-label': label },
      colours.map(({ hex, name }, i) => el('button', {
        class: 'cc-skin', type: 'button', role: 'radio', style: `--tone:${hex}`,
        'aria-checked': i === get() ? 'true' : 'false', 'aria-label': name, title: name,
        onClick: (event) => {
          set(i);
          for (const sibling of event.currentTarget.parentElement.children) sibling.setAttribute('aria-checked', 'false');
          event.currentTarget.setAttribute('aria-checked', 'true');
          preview.draw();
          repaintChoosers();
        },
      })));

    const skinRow = swatches('Màu da',
      SKIN_TONES.map((hex, i) => ({ hex, name: `Màu da ${i + 1}` })),
      () => look.skin, (i) => { look = { ...look, skin: i }; });
    const eyeRow = swatches('Màu mắt',
      EYE_COLOURS.map(({ hex, label }) => ({ hex, name: label })),
      () => look.eyes, (i) => { look = { ...look, eyes: i }; });

    const repaintChoosers = () => {
      const options = lookOptions(atlas, look.gender);
      rows.hair.rebuild(options.hair);
      rows.outfit.rebuild(options.outfit);
    };

    const applyLook = (next) => {
      look = next;
      repaintChoosers();
      for (const [i, node] of [...skinRow.children].entries()) {
        node.setAttribute('aria-checked', i === look.skin ? 'true' : 'false');
      }
      for (const [i, node] of [...eyeRow.children].entries()) {
        node.setAttribute('aria-checked', i === look.eyes ? 'true' : 'false');
      }
      preview.draw();
    };

    const genderPicker = el('div', { class: 'cc-gender', role: 'radiogroup', 'aria-label': 'Giới tính' },
      GENDERS.map((g) => el('button', {
        class: `cc-sex s-${g.code}`, type: 'button', role: 'radio',
        'aria-checked': g.code === look.gender ? 'true' : 'false',
        onClick: (event) => {
          if (g.code === look.gender) return;
          for (const sibling of event.currentTarget.parentElement.children) sibling.setAttribute('aria-checked', 'false');
          event.currentTarget.setAttribute('aria-checked', 'true');
          // Mảnh art của hai giới không dùng chung được, nên đổi giới là dựng
          // lại cả bộ chứ không giữ lựa chọn cũ.
          applyLook(defaultLook(atlas, g.code));
        },
        // Vòng tròn là cái BỌC ngoài, không phải nền của icon: `.ico` tô bằng
        // mask nên đặt nền lên chính nó thì nền cũng bị mask nốt, còn lại mỗi
        // nét vẽ.
      }, [el('span', { class: 'cc-orb' }, [el('i', { class: `ico ico-${g.icon}` })]), el('span', { text: g.label })])));

    const create = el('button', { class: 'primary cc-go', type: 'button', text: 'Đến thị trấn' });
    bindSubmit(create, async () => {
      error.classList.add('hidden');
      try {
        const made = await game.api.post('/v1/characters', {
          nickname: nickname.value.trim(),
          appearance: {
            body_type: GENDERS.find((g) => g.code === look.gender).id,
            face: look.face, hair: look.hair, outfit: look.outfit,
            skin: look.skin, eyes: look.eyes,
          },
        });
        // Token cũ chưa gắn nhân vật nào, phải thay bằng phiên mới.
        game.api.setSession(made.session);
        hideOverlay();
        resolve(made.character);
      } catch (err) {
        error.textContent = err.message;
        error.classList.remove('hidden');
      }
    });

    showOverlay(el('div', { class: 'char-create' }, [
      el('div', { class: 'cc-left' }, [
        el('div', { class: 'cc-signs' }, [
          el('h1', { class: 'cc-title', text: 'Tạo nhân vật' }),
          el('p', { class: 'cc-step', text: 'Chọn ngoại hình và đặt tên' }),
        ]),
        genderPicker,
        preview.canvas,
      ]),
      // Nút vào game nằm NGOÀI bảng chọn: nó không phải một lựa chọn ngoại
      // hình, nó là bước tiếp theo — nhét chung vào bảng thì nó trôi theo phần
      // cuộn của bảng và lẫn vào đám ô chọn.
      el('div', { class: 'cc-side' }, [
        el('div', { class: 'cc-panel' }, [
          el('h2', { text: 'Chọn ngoại hình' }),
          rows.hair.node,
          el('div', { class: 'cc-row' }, [el('span', { class: 'cc-label', text: 'Màu mắt' }), eyeRow]),
          el('div', { class: 'cc-row' }, [el('span', { class: 'cc-label', text: 'Màu da' }), skinRow]),
          rows.outfit.node,
          el('div', { class: 'cc-name-row' }, [
            nickname,
            el('button', {
              class: 'cc-dice', type: 'button', 'aria-label': 'Ngoại hình ngẫu nhiên',
              onClick: () => applyLook(randomLook(atlas, look.gender)),
            }, [el('i', { class: 'ico ico-dice' })]),
          ]),
        ]),
        error,
        create,
      ]),
    ]), { backdrop: 'character', logo: false });

    // Trang art nhân vật có thể chưa về; dựng danh sách lại khi nó tới nơi.
    if (!lookOptions(atlas, 'm').face.length) atlas.ensurePage('parts')?.then(() => applyLook(defaultLook(atlas, look.gender)));
    else repaintChoosers();
    nickname.focus();
  });
}
