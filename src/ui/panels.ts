import { registerPanel, openPanel, getGame, refreshHotbar } from './UIManager';
import { h, openWindow, btn, fmt, iconOf, spr, chibiPreview, chibiHead, charFace, charHeadOnly, avatarEl, squareThumb, uiIcon, priceHtml, priceBtn, iconUrl, titlePlaque } from './kit';
import { AVATAR_PICS, avatarPicUrl, isUploadedPic } from '@/data/avatars';
import { FOODS, FOOD_LIST, type FoodDef } from '@/data/foods';
import { orderList, canDeliver, deliver, dropOrder, haveOf, orderName } from '@/systems/orders';
import { pond, POND_CAP, FRIES, FRY_LIST, isGrown, remainMin, stockFry, netFish } from '@/systems/fishfarm';
import { countOf, takeFrom, listOf, type StoreKind } from '@/systems/farmstore';
import { cookingFood, cookRemain, canCook, startCook, collectCook, cancelCook } from '@/systems/cooking';
import { S, save, spend, addCoins, addRubies, addItem, removeItem, itemCount, addStat, resetSave, equipTool, toolLevel, equipHandItem, unequipTool, allocateStat, STAT_NAMES, STAT_KEYS } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { ITEMS, item } from '@/data/items';
import { CROPS, CROP_LIST } from '@/data/crops';
import { ANIMAL_LIST, ANIMALS, BARN_CAPACITY, BARN_UPGRADE_COST } from '@/data/animals';
import { FISH_LIST, RODS, RARITY_COLOR, RARITY_NAME, FISHES } from '@/data/fish';
import { chibiList, chibiPriceXu, CHIBI_PARTS, partStats, equipStats, formatStats } from '@/data/chibi';
import { handItemId } from '@/data/handitems';
import { SKIN_LIST, SKINS, type SkinDef } from '@/data/skins';
import { FURNITURE, FURNITURE_LIST, HOUSE_LEVELS, WALLPAPERS, FLOORS } from '@/data/furniture';
import { SHOPS } from '@/data/shops';
import { QUESTS, TITLES, ACHIEVEMENTS } from '@/data/quests';
import { ZONE_LIST, ZONES } from '@/data/zones';
import { WHEEL, LOGIN_REWARDS, CHECKIN_MILESTONES, activeEvents } from '@/data/meta';
import { TOOL_LIST, TOOLS, toolUpgradeAt, toolIconSize } from '@/data/tools';
import { PET_LIST, PETS, ownsPet, petBonus, petUrl } from '@/data/pets';
import * as farming from '@/systems/farming';
import * as livestock from '@/systems/livestock';
import { buyRod, addToAquarium } from '@/systems/fishing';
import { claimQuest, activeQuestList, grantReward } from '@/systems/quests';
import { suggestedFriends, addFriend, removeFriend, blockPlayer, reportPlayer, giveGift, sendChat, sendVoice, getChatLog, claimMail, leaderboard, affinityOf, addAffinity, affinityLabel } from '@/systems/social';
import { claimLogin, checkinToday, spinWheel, grantWheel, wheelSpinsLeft, loginRewardToday } from '@/systems/meta';
import { upgradeHouse, setWallpaper, setFloor, throwParty } from '@/systems/housing';
import { sfx, startBgm, stopBgm } from '@/core/audio';
import type { Reward } from '@/data/quests';

// giá bán thực nhận (vẹt lanh lợi +10%)
function sellPrice(base: number, qty = 1): number {
  return Math.round(base * qty * (1 + petBonus('parrot')));
}

function rewardText(r: Reward): string {
  const parts: string[] = [];
  if (r.coins) parts.push(priceHtml(r.coins));
  if (r.rubies) parts.push(priceHtml(0, r.rubies));
  if (r.exp) parts.push(`<img class="cur" src="assets/ui/pack/icon_level.png">${r.exp}`);
  if (r.items) for (const [id, q] of Object.entries(r.items)) parts.push(`${item(id).name} x${q}`);
  if (r.title) parts.push(`<img class="cur" src="assets/ui/pack/icon_trophy.png">${TITLES[r.title]?.name}`);
  return parts.join(' ');
}

// nút nhỏ chỉ có icon (thay cho nút emoji)
function iconBtn(icon: string, title: string, cls: string, onClick: () => void): HTMLButtonElement {
  const b = h('button', `btn ${cls} btn-ico`);
  b.title = title;
  b.append(uiIcon(icon, 18));
  b.onclick = onClick;
  return b;
}

function worldScene(): any {
  return getGame().scene.getScene('World');
}

// Kho nông sản chứa nhiều loại id: cây trồng, `food_*` (món nấu), `fish_*` (cá
// nuôi) và item chăn nuôi (trứng/sữa/thịt/len). Gom cách đọc tên & ảnh về một chỗ
// để kho, bếp và bảng đơn hàng luôn hiển thị giống nhau.
export function produceName(id: string): string {
  if (id.startsWith('food_')) return FOODS[id.slice(5)]?.name ?? id;
  if (id.startsWith('fish_')) return FRIES[id.slice(5)]?.name ?? id;
  return CROPS[id]?.name ?? ITEMS[id]?.name ?? id;
}
export function produceIcon(id: string, size = 40): HTMLElement {
  if (id.startsWith('food_')) return produceIcon(FOODS[id.slice(5)]?.icon ?? 'carrot', size);
  if (id.startsWith('fish_')) return uiIcon('fish', size);
  if (CROPS[id]) return iconOf(item(`crop_${id}`), size);
  if (ITEMS[id]) return iconOf(item(id), size);
  return uiIcon('plant', size);
}
export function produceSell(id: string): number {
  if (id.startsWith('food_')) return FOODS[id.slice(5)]?.sell ?? 0;
  if (id.startsWith('fish_')) return (FRIES[id.slice(5)]?.price ?? 100) * 2;
  return CROPS[id]?.sellPrice ?? ITEMS[id]?.sell ?? 0;
}

export function registerAllPanels() {

  // ================= Hộp thoại chung =================
  registerPanel('dialog', (data: { title: string; text: string; actions?: { icon: string; label: string; ui?: string; cb: () => void }[] }) => {
    const { body, close } = openWindow(data.title, { size: 'small' });
    const txt = h('div');
    txt.style.whiteSpace = 'pre-line';
    txt.textContent = data.text;
    body.append(txt);
    const bar = h('div');
    bar.style.cssText = 'display:flex;gap:8px;margin-top:12px;flex-wrap:wrap';
    for (const a of data.actions ?? []) {
      const b = btn(a.label, 'gold', () => { close(); a.cb(); });
      if (a.ui) b.prepend(uiIcon(a.ui, 18));
      else if (a.icon) b.prepend(document.createTextNode(a.icon + ' '));
      b.style.display = 'inline-flex'; b.style.alignItems = 'center'; b.style.gap = '5px';
      bar.append(b);
    }
    bar.append(btn('Đóng', '', close));
    body.append(bar);
  });

  // ================= Kho đồ =================
  // sức chứa túi đồ (ô trống vẫn hiện để nhìn ra còn bao nhiêu chỗ)
  const BAG_CAP = 100;

  // sắp xếp: gom theo loại rồi theo tên
  function sortBag() {
    const KIND_ORDER = ['tool', 'seed', 'crop', 'product', 'food', 'fish', 'material', 'furniture', 'deco', 'gift', 'special'];
    const ord = (k: string) => { const i = KIND_ORDER.indexOf(k); return i < 0 ? 99 : i; };
    const rows = Object.entries(S.inventory).sort((a, b) => {
      const da = item(a[0]), db = item(b[0]);
      return ord(da.kind) - ord(db.kind) || da.name.localeCompare(db.name, 'vi');
    });
    S.inventory = Object.fromEntries(rows);
    save();
    toast('Đã sắp xếp túi đồ.', 'inventory');
  }

  const BAG_TABS: [string, (k: string) => boolean][] = [
    ['Tất cả', () => true],
    ['Trang bị', k => k === 'tool'],
    ['Nông sản', k => ['crop', 'seed', 'product'].includes(k)],
    ['Cá', k => k === 'fish'],
    ['Nội thất', k => ['furniture', 'deco'].includes(k)],
    ['Khác', k => ['gift', 'material', 'food', 'special'].includes(k)]
  ];

  // Nông cụ cũng nằm trong túi (kind ảo 'tool'); đồ cầm tay ở tủ đồ
  interface BagEntry { kind: string; name: string; qty: number; node: () => HTMLElement; equipped: boolean; onClick: () => void }

  function bagEntries(close: () => void): BagEntry[] {
    const out: BagEntry[] = [];
    for (const t of TOOL_LIST) {
      if (toolLevel(t.id) <= 0) continue;
      const on = S.hotbar.includes(t.id);
      out.push({
        kind: 'tool', name: t.name, qty: 0, equipped: on,
        node: () => { const d = h('div'); d.append(spr(t.url, 0, 0, t.w, t.h, toolIconSize(t, 62))); return d; },
        onClick: () => {
          if (on) unequipTool(S.hotbar.indexOf(t.id));
          else equipTool(t.id);
        }
      });
    }
    for (const [id, qty] of Object.entries(S.inventory)) {
      const def = item(id);
      // đồ cầm tay đã chuyển hẳn sang tủ đồ (tab Quần áo), không bày trong túi nữa
      if (def.meta?.handPart) continue;
      out.push({
        kind: def.kind, name: def.name, qty, equipped: false,
        node: () => iconOf(def, 58),
        onClick: () => itemActions(id, close)
      });
    }
    return out;
  }

  // Lưới túi đồ dùng chung cho panel Kho đồ và tab Túi đồ trong màn Nhân vật
  function renderBag(box: HTMLElement, close: () => void, redraw: () => void) {
    let tab = 0;
    const draw = () => {
      box.innerHTML = '';
      const hub = h('div', 'ch-wrap bag-hub');
      const wrap = h('div', 'bag-wrap');
      const side = h('div', 'ch-side');
      BAG_TABS.forEach(([name], i) => {
        const t = h('button', `ch-tab ${i === tab ? 'active' : ''}`, name);
        t.onclick = () => { sfx.click(); tab = i; draw(); };
        side.append(t);
      });

      const all = bagEntries(close);
      const list = all.filter(e => BAG_TABS[tab][1](e.kind));
      const grid = h('div', 'bag');
      for (const e of list) {
        const c = h('button', `bag-slot ${e.equipped ? 'on' : ''}`);
        c.append(e.node());
        if (e.qty > 1) c.append(h('div', 'qty', `x${e.qty}`));
        if (e.equipped) c.append(h('div', 'bag-on', 'Đang dùng'));
        c.title = e.name;
        c.onclick = () => { sfx.click(); e.onClick(); redraw(); };
        grid.append(c);
      }
      for (let i = list.length; i < BAG_CAP; i++) grid.append(h('div', 'bag-slot empty'));

      const scroll = h('div', 'bag-scroll');
      scroll.append(grid);
      const foot = h('div', 'bag-foot');
      foot.append(h('div', 'bag-count', `Số ô sử dụng: ${all.length}/${BAG_CAP}`));
      foot.append(btn('Sắp xếp', 'gold', () => { sortBag(); sfx.click(); draw(); }));
      wrap.append(scroll, foot);
      hub.append(wrap, side);
      box.append(hub);
    };
    draw();
    return draw;
  }

  registerPanel('inventory', () => {
    const { body, win, close } = openWindow('Túi đồ', { size: 'large' });
    win.classList.add('win-bag');
    let redraw = () => {};
    redraw = renderBag(body, close, () => redraw());
    bus.on(EV.INVENTORY, () => redraw());
  });

  function itemActions(id: string, closeParent: () => void) {
    const def = item(id);
    const acts: { icon: string; ui?: string; label: string; cb: () => void }[] = [];
    if (def.sell > 0) {
      acts.push({
        icon: '', label: `Bán 1 (+${sellPrice(def.sell)} xu)`, cb: () => {
          if (removeItem(id)) { const g = sellPrice(def.sell); S.wallet.coins += g; S.stats['coins_earned'] = (S.stats['coins_earned'] ?? 0) + g; bus.emit(EV.WALLET); addStat('daily_sold'); if (def.kind === 'crop') addStat('sold_crops'); sfx.coin(); save(); }
        }
      });
      const qty = itemCount(id);
      if (qty > 1) acts.push({
        icon: '', label: `Bán hết x${qty} (+${sellPrice(def.sell, qty)} xu)`, cb: () => {
          if (removeItem(id, qty)) { const g = sellPrice(def.sell, qty); S.wallet.coins += g; S.stats['coins_earned'] = (S.stats['coins_earned'] ?? 0) + g; bus.emit(EV.WALLET); addStat('daily_sold', qty); if (def.kind === 'crop') addStat('sold_crops', qty); sfx.coin(); save(); }
        }
      });
    }
    if (def.kind === 'gift' || def.kind === 'crop' || def.kind === 'food') {
      acts.push({ icon: '', ui: 'gift', label: 'Tặng bạn bè', cb: () => pickFriendToGift(id) });
    }
    if (def.meta?.furniture) {
      acts.push({ icon: '', ui: 'house', label: 'Đặt trong nhà', cb: () => { closeParent(); bus.emit('world:place', id); } });
    }
    if (def.kind === 'fish') {
      acts.push({ icon: '', ui: 'fish', label: 'Thả vào hồ cá nhà', cb: () => addToAquarium(id) });
    }
    if (def.kind === 'tool' && id.startsWith('tool_')) {
      acts.push({ icon: '', ui: 'hoe', label: 'Gắn lên thanh nông cụ', cb: () => equipTool(id.slice(5)) });
      acts.push({ icon: '', ui: 'rank', label: 'Nâng cấp nông cụ', cb: () => openPanel('toolupgrade') });
    }
    if (def.id === 'food_cake') {
      acts.push({ icon: '', ui: 'gift', label: 'Mở tiệc tại nhà', cb: () => { if (throwParty()) { closeParent(); } } });
    }
    openPanel('dialog', { title: def.name, text: def.desc ?? `Giá bán: ${def.sell} xu`, actions: acts });
  }

  function pickFriendToGift(itemId: string) {
    const { body, close } = openWindow('Tặng cho ai?', { size: 'small' });
    if (!S.social.friends.length) body.append(h('div', 'hint', 'Chưa có bạn bè — mở panel Bạn bè để kết bạn nhé!'));
    for (const f of S.social.friends) {
      const r = h('div', 'row');
      r.innerHTML = `<div class="grow"><div class="t1"></div><div class="t2">Lv.${f.level}</div></div>`;
      (r.querySelector('.t1') as HTMLElement).textContent = f.name;
      r.append(btn('Tặng', 'gold', () => { giveGift(f.id, itemId); close(); }));
      body.append(r);
    }
  }

  // ================= Chọn hạt giống =================
  registerPanel('seedpicker', (data: { plot: number }) => {
    const { body, close } = openWindow('Trồng gì đây?', { size: 'small' });
    const grid = h('div', 'grid');
    let has = false;
    for (const c of CROP_LIST) {
      const qty = countOf('seeds', c.id);
      if (qty <= 0) continue;
      has = true;
      const cell = h('div', 'cell');
      cell.append(iconOf(item(`seed_${c.id}`)), h('div', 'nm', c.name), h('div', 'qty', `x${qty}`), h('div', 'pr', `${c.growMin} phút`));
      cell.onclick = () => { farming.plant(data.plot, c.id); close(); };
      grid.append(cell);
    }
    if (!has) {
      body.append(h('div', 'hint', 'Kho không còn hạt giống. Mua ở tiệm Cô Mai (Nông trại) nhé!'));
      body.append(btn('Mở tiệm hạt giống', 'gold', () => { close(); openPanel('shop', { shopId: 'shop_seed' }); }));
    }
    body.append(grid);
  });

  // ================= Ao nuôi cá (Lttt: nuôi, không phải câu) =================
  registerPanel('fishfarm', () => {
    const { body, tabs } = openWindow('Ao nuôi cá', { size: 'large' });
    const content = h('div');
    let tab = 0;

    const render = () => {
      content.innerHTML = '';
      if (tab === 0) {
        const list = pond();
        content.append(h('div', 'hint',
          `Đang nuôi ${list.length}/${POND_CAP} con. Cá lớn thì vớt lên, cất vào kho nông trại.`));
        if (!list.length) { content.append(h('div', 'hint', 'Ao đang trống — sang tab "Mua cá giống" để thả cá.')); return; }
        const grid = h('div', 'grid grid-shop');
        for (const f of list) {
          const def = FRIES[f.type];
          const done = isGrown(f);
          const cell = h('div', `cell cell-lg ${done ? 'owned' : ''}`);
          cell.append(uiIcon('fish', 44), h('div', 'nm', def?.name ?? f.type));
          cell.append(h('div', 'pr', done ? 'Đã lớn!' : `Còn ${remainMin(f)} phút`));
          if (done) cell.append(btn('Vớt cá', 'gold', () => { netFish(f.id); render(); }));
          grid.append(cell);
        }
        content.append(grid);
      } else {
        content.append(h('div', 'hint', 'Mua cá giống thả xuống ao, đợi lớn rồi vớt.'));
        const grid = h('div', 'grid grid-shop');
        for (const d of FRY_LIST) {
          const cell = h('div', 'cell cell-lg');
          cell.append(uiIcon('fish', 44), h('div', 'nm', d.name));
          cell.append(h('div', 'pr', `${d.growMin} phút · ${d.qty[0]}-${d.qty[1]} con`));
          cell.append(priceBtn(d.price, 'gold', () => { if (stockFry(d.id)) { tab = 0; render(); } }));
          grid.append(cell);
        }
        content.append(grid);
      }
    };
    tabs(['Ao cá', 'Mua cá giống'], i => { tab = i; render(); });
    body.append(content);
    render();
  });

  // ================= Bảng đơn hàng (kiểu Hay Day) =================
  registerPanel('orders', () => {
    const { body, win } = openWindow('Đơn hàng', { size: 'large' });
    win.classList.add('win-orders');
    let sel = '';

    const wrap = h('div', 'od-wrap');
    const boardCol = h('div', 'od-board');
    const sideCol = h('div', 'od-side');
    wrap.append(boardCol, sideCol);
    body.append(wrap);

    const lineRow = (l: { id: string; qty: number }) => {
      const have = haveOf(l);
      const cell = h('div', `od-ing ${have >= l.qty ? 'ok' : 'miss'}`);
      const art = h('div', 'od-ing-art'); art.append(produceIcon(l.id, 40));
      cell.append(art, h('div', 'od-ing-n', `${have}/${l.qty}`));
      cell.title = orderName(l.id);
      return cell;
    };

    // ảnh đại diện người đặt: vòng tròn chữ cái đầu, màu suy ra từ tên
    const placeAva = (name: string, size = 46): HTMLElement => {
      const d = h('div', 'od-ava');
      let hsh = 0;
      for (let i = 0; i < name.length; i++) hsh = (hsh * 131 + name.charCodeAt(i) * 977) % 100000;
      const parts = name.trim().split(/\s+/);
      const ini = parts.length > 1 ? parts[0][0] + parts[parts.length - 1][0] : parts[0].slice(0, 2);
      d.style.cssText = `width:${size}px;height:${size}px;font-size:${Math.round(size * 0.36)}px;`
        + `background:hsl(${hsh % 360} 55% ${40 + (hsh >> 3) % 12}%);`;
      d.textContent = ini.toUpperCase();
      return d;
    };

    const renderSide = () => {
      sideCol.innerHTML = '';
      const o = orderList().find(x => x.id === sel);
      if (!o) {
        const e = h('div', 'od-empty');
        const im = document.createElement('img'); im.src = 'assets/ui/inv/note.png';
        e.append(im, h('div', '', 'Chọn một tờ đơn bên trái để xem chi tiết và giao hàng.'));
        sideCol.append(e);
        return;
      }
      // ----- đầu: ai đặt -----
      const head = h('div', 'od-head');
      head.append(placeAva(o.place));
      const hi = h('div', 'grow');
      hi.append(h('div', 'od-side-title', o.place),
                h('div', 'od-side-sub', o.visitor ? 'Khách ghé tận nông trại' : 'Đặt hàng từ xa'));
      head.append(hi);
      sideCol.append(head);
      if (o.visitor) sideCol.append(h('div', 'od-visit', 'Khách tới tận nơi nên thưởng cao hơn — giao sớm kẻo khách về!'));

      // ----- hàng cần giao -----
      const done = o.lines.filter(l => haveOf(l) >= l.qty).length;
      const cap = h('div', 'od-cap');
      cap.append(h('span', '', 'Hàng cần giao'), h('span', 'od-cap-n', `${done}/${o.lines.length}`));
      sideCol.append(cap);
      const ing = h('div', 'od-ings');
      for (const l of o.lines) ing.append(lineRow(l));
      sideCol.append(ing);

      // ----- danh sách từng món cho rõ tên + còn thiếu bao nhiêu -----
      const list = h('div', 'od-list');
      for (const l of o.lines) {
        const have = haveOf(l);
        const r = h('div', `od-line ${have >= l.qty ? 'ok' : ''}`);
        r.append(h('span', 'od-line-nm', orderName(l.id)));
        r.append(h('span', 'od-line-n', have >= l.qty ? 'đủ' : `còn thiếu ${l.qty - have}`));
        list.append(r);
      }
      sideCol.append(list);

      // ----- thưởng -----
      sideCol.append(h('div', 'od-cap', 'Phần thưởng'));
      const pay = h('div', 'od-pay');
      const c1 = h('div', 'od-pay-item'); c1.append(uiIcon('coin', 24), h('span', '', fmt(o.coins)));
      const c2 = h('div', 'od-pay-item'); c2.append(uiIcon('level', 24), h('span', '', `${o.exp} EXP`));
      pay.append(c1, c2);
      sideCol.append(pay);

      const ok = canDeliver(o);
      const bar = h('div', 'od-actions');
      bar.append(btn(ok ? 'Giao hàng' : 'Chưa đủ hàng', ok ? 'gold' : '', () => {
        if (deliver(o.id)) { sel = ''; render(); }
      }));
      bar.append(btn('Bỏ đơn', '', () => { if (dropOrder(o.id)) { sel = ''; render(); } }));
      sideCol.append(bar);
    };

    const render = () => {
      boardCol.innerHTML = '';
      for (const o of orderList()) {
        const ok = canDeliver(o);
        const note = h('div', `od-note ${sel === o.id ? 'sel' : ''} ${o.visitor ? 'visit' : ''}`);
        note.append(h('div', 'od-place', o.place));
        // hàng cần giao hiện ngay trên tờ giấy (kiểu Hay Day) chứ không phải chỉ tiền
        const goods = h('div', 'od-note-goods');
        for (const l of o.lines) {
          const g = h('div', `od-goods ${haveOf(l) >= l.qty ? 'ok' : ''}`);
          g.append(produceIcon(l.id, 30), h('div', 'od-goods-n', `${l.qty}`));
          g.title = orderName(l.id);
          goods.append(g);
        }
        note.append(goods);
        const row = h('div', 'od-note-pay');
        row.append(uiIcon('coin', 16), h('span', '', fmt(o.coins)));
        note.append(row);
        const row2 = h('div', 'od-note-pay');
        row2.append(uiIcon('level', 16), h('span', '', `${o.exp}`));
        if (ok) {
          const tick = document.createElement('img');
          tick.src = 'assets/ui/inv/check.png'; tick.className = 'od-tick';
          row2.append(tick);
        }
        note.append(row2);
        note.onclick = () => { sfx.click(); sel = o.id; render(); };
        boardCol.append(note);
      }
      renderSide();
    };
    render();
  });

  // ================= Kho nông trại (Lttt: tách khỏi túi đồ) =================
  registerPanel('warehouse', () => {
    const { body, tabs, win } = openWindow('Kho nông trại', { size: 'large' });
    win.classList.add('win-wh');
    const content = h('div', 'wh-wrap');
    const KINDS: [StoreKind, string][] = [['produce', 'Nông sản'], ['seeds', 'Hạt giống'], ['fert', 'Phân bón']];

    const nameOf = (kind: StoreKind, id: string) =>
      kind === 'fert' ? 'Phân bón' : kind === 'seeds' ? (CROPS[id]?.name ?? id) : produceName(id);
    const iconFor = (kind: StoreKind, id: string) =>
      kind === 'fert' ? uiIcon('fertilizer', 46)
        : kind === 'seeds' ? iconOf(item(`seed_${id}`), 46) : produceIcon(id, 46);
    const sellOf = (kind: StoreKind, id: string) => kind === 'produce' ? produceSell(id) : 0;

    const render = (kind: StoreKind) => {
      content.innerHTML = '';
      const rows = listOf(kind);
      const head = h('div', 'wh-head');
      head.append(h('div', 'wh-hint', kind === 'produce'
        ? 'Nông sản, trứng/sữa/thịt từ chuồng, cá nuôi và món đã nấu đều cất ở đây.'
        : kind === 'seeds' ? 'Hạt giống dùng để gieo ngoài ruộng.' : 'Phân bón giúp cây nhanh lớn và khỏe hơn.'));
      head.append(h('div', 'wh-total', `${rows.reduce((a, [, n]) => a + n, 0)} món`));
      content.append(head);
      if (!rows.length) { content.append(h('div', 'wh-empty', 'Ngăn này đang trống.')); return; }
      const grid = h('div', 'wh-grid');
      for (const [id, qty] of rows) {
        const cell = h('div', 'wh-cell');
        const art = h('div', 'wh-art'); art.append(iconFor(kind, id));
        cell.append(art, h('div', 'wh-name', nameOf(kind, id)), h('div', 'wh-qty', `${qty}`));
        const price = sellOf(kind, id);
        if (price > 0) {
          const b = priceBtn(price, 'gold', () => {
            if (!takeFrom(kind, id, 1)) return;
            addCoins(price); sfx.coin(); addStat('sold');
            toast(`Bán 1 ${nameOf(kind, id)} +${price} xu`, 'coin');
            render(kind);
          });
          b.prepend(document.createTextNode('Bán '));
          b.classList.add('wh-sell');
          cell.append(b);
        } else {
          cell.append(h('div', 'wh-nosell', kind === 'seeds' ? 'Đem gieo' : 'Đem bón'));
        }
        grid.append(cell);
      }
      content.append(grid);
    };

    tabs(KINDS.map(k => k[1]), i => render(KINDS[i][0]));
    body.append(content);
    render('produce');
  });

  // ================= Nhà bếp (Lttt: 1 món/lượt, có đếm giờ) =================
  registerPanel('kitchen', () => {
    const { body, win } = openWindow('Nhà bếp', { size: 'large' });
    win.classList.add('win-kitchen');
    const content = h('div', 'kt-wrap');
    let timer = 0;
    let sel = FOOD_LIST[0]?.id ?? '';

    const stove = h('div', 'kt-stove');
    const listCol = h('div', 'kt-list');
    content.append(stove, listCol);

    // ô nguyên liệu — dùng chung cho lúc đang nấu và lúc xem trước
    const ingBox = (f: FoodDef, live: boolean) => {
      const wrap = h('div', 'kt-sec');
      wrap.append(h('div', 'kt-sec-cap', 'Nguyên liệu'));
      const ing = h('div', 'kt-ings');
      for (const [id, n] of f.material) {
        const have = live ? n : countOf('produce', id);
        const box = h('div', `kt-ing ${have >= n ? 'ok' : 'miss'}`);
        const art = h('div', 'kt-ing-art'); art.append(produceIcon(id, 34));
        box.append(art, h('div', 'kt-ing-n', live ? `x${n}` : `${have}/${n}`));
        box.title = produceName(id);
        ing.append(box);
      }
      wrap.append(ing);
      return wrap;
    };

    const renderStove = () => {
      stove.innerHTML = '';
      const cur = cookingFood();
      const f = cur ?? FOODS[sel];
      stove.append(h('div', 'kt-cap', cur ? (cookRemain() > 0 ? 'ĐANG NẤU' : 'ĐÃ XONG!') : 'BẾP ĐANG RẢNH'));
      if (!f) { stove.append(h('div', 'kt-empty', 'Chọn một món ở danh sách bên phải.')); return; }

      const art = h('div', `kt-art ${cur && cookRemain() > 0 ? 'cooking' : ''}`);
      art.append(produceIcon(f.icon, 66));
      stove.append(art);
      stove.append(h('div', 'kt-name', f.name));

      if (cur) {
        const left = cookRemain();
        const pct = Math.max(0, Math.min(100, (1 - left / (cur.cookMin * 60)) * 100));
        const bar = h('div', 'kt-bar');
        const fill = h('div', 'kt-bar-fill'); fill.style.width = `${pct}%`;
        bar.append(fill);
        stove.append(bar);
        const mm = Math.floor(left / 60), ss = left % 60;
        stove.append(h('div', `kt-time ${left > 0 ? '' : 'done'}`,
          left > 0 ? `Còn ${mm}:${String(ss).padStart(2, '0')}` : 'Món đã chín, vào lấy thôi!'));
        stove.append(ingBox(cur, true));
        const bar2 = h('div', 'kt-act');
        bar2.append(left > 0
          ? btn('Hủy nấu', '', () => { cancelCook(); render(); })
          : btn('Lấy món', 'gold', () => { collectCook(); render(); }));
        stove.append(bar2);
        return;
      }

      stove.append(h('div', 'kt-time', `${f.cookMin} phút · bán ${f.sell} xu · +${f.exp} EXP`));
      stove.append(ingBox(f, false));
      const ok = canCook(f);
      const bar2 = h('div', 'kt-act');
      bar2.append(btn(ok ? 'Bắt đầu nấu' : 'Thiếu nguyên liệu', ok ? 'gold' : '', () => {
        if (startCook(f.id)) render();
      }));
      stove.append(bar2);
    };

    const renderList = () => {
      listCol.innerHTML = '';
      listCol.append(h('div', 'kt-list-cap', 'Công thức'));
      for (const f of FOOD_LIST) {
        const ok = canCook(f);
        const row = h('div', `kt-row ${sel === f.id ? 'sel' : ''}`);
        const ic = h('div', 'kt-row-art'); ic.append(produceIcon(f.icon, 34));
        row.append(ic);
        const info = h('div', 'grow');
        info.append(h('div', 'kt-row-name', f.name),
                    h('div', 'kt-row-sub', `${f.cookMin} phút · ${f.sell} xu`));
        row.append(info);
        if (ok) row.append(h('span', 'kt-ok', '✔'));
        row.onclick = () => { sfx.click(); sel = f.id; render(); };
        listCol.append(row);
      }
    };

    const render = () => { renderStove(); renderList(); };
    body.append(content);
    render();
    timer = window.setInterval(() => { if (cookingFood()) renderStove(); }, 1000);
    body.addEventListener('DOMNodeRemoved', () => clearInterval(timer), { once: true });
  });

  // ================= Shop =================
  // Shop nằm ở map nào thì phải đến map đó mới mở được (như đi chợ thật)
  const SHOP_ZONE: Record<string, string> = {
    shop_seed: 'farm', shop_general: 'town', shop_house: 'town',
    shop_fishing: 'beach', shop_fashion: 'mall', shop_gift: 'mall',
    fishingshop: 'beach', toolupgrade: 'town', fashionshop: 'mall', petshop: 'town',
    houseshop: 'town', animalshop: 'farm',
    shop_barber: 'mall', shop_salon: 'mall', barbershop: 'mall', salonshop: 'mall'
  };
  function atShopZone(key: string, name: string): boolean {
    const z = SHOP_ZONE[key];
    if (!z || S.zone === z) return true;
    toast(`${name} nằm ở ${ZONES[z]?.name ?? z} — bắt xe buýt tới đó nhé!`, 'bus');
    sfx.error();
    return false;
  }

  registerPanel('shop', (data: { shopId: string }) => {
    const shop = SHOPS[data.shopId];
    if (!shop) return;
    if (!atShopZone(shop.id, shop.name)) return;
    if (shop.special === 'fashion') return openPanel('fashionshop');
    if (shop.special === 'house') return openPanel('houseshop');
    if (shop.special === 'fishing') return openPanel('fishingshop');
    if (shop.special === 'barber') return openPanel('barbershop');
    if (shop.special === 'salon') return openPanel('salonshop');

    const { body, tabs } = openWindow(shop.name);
    let mode = 0;
    const render = () => {
      body.innerHTML = '';
      const grid = h('div', 'grid');
      if (mode === 0) {
        for (const id of shop.items) {
          const def = item(id);
          const cell = h('div', 'cell');
          const priceEl = h('div', 'pr');
          priceEl.innerHTML = priceHtml(def.buy ?? 0);
          cell.append(iconOf(def), h('div', 'nm', def.name), priceEl);
          cell.onclick = () => {
            if (spend(def.buy ?? 0)) {
              addItem(id); sfx.coin(); toast(`Đã mua ${def.name}`, def.icon);
            }
          };
          grid.append(cell);
        }
      } else {
        const sellable = Object.entries(S.inventory).filter(([id]) => shop.buysKinds.includes(item(id).kind) && item(id).sell > 0);
        if (!sellable.length) body.append(h('div', 'hint', 'Không có gì để bán ở đây.'));
        for (const [id, qty] of sellable) {
          const def = item(id);
          const cell = h('div', 'cell');
          const prEl = h('div', 'pr');
          prEl.innerHTML = '+' + priceHtml(sellPrice(def.sell));
          cell.append(iconOf(def), h('div', 'nm', def.name), h('div', 'qty', `x${qty}`), prEl);
          cell.onclick = () => {
            if (removeItem(id)) {
              const g = sellPrice(def.sell);
              S.wallet.coins += g;
              S.stats['coins_earned'] = (S.stats['coins_earned'] ?? 0) + g;
              addStat('daily_sold'); if (def.kind === 'crop') addStat('sold_crops');
              bus.emit(EV.WALLET); sfx.coin(); save(); render();
            }
          };
          grid.append(cell);
        }
      }
      body.append(grid);
      // bách hóa có quầy nâng cấp nông cụ
      if (mode === 0 && shop.id === 'shop_general') {
        body.append(btn('Nâng cấp nông cụ', 'blue', () => openPanel('toolupgrade')));
      }
    };
    tabs(['Mua', 'Bán'], i => { mode = i; render(); });
    render();
  });

  // ---- Tiệm câu: shop riêng — cần câu + mồi câu + vợt ----
  registerPanel('fishingshop', () => {
    if (!atShopZone('fishingshop', 'Tiệm câu Ông Biển')) return;
    const { body, tabs } = openWindow('Tiệm câu Ông Biển');
    let tab = 0;
    const render = () => {
      body.innerHTML = '';
      if (tab === 0) {
        for (const rod of RODS) {
          const r = h('div', 'row');
          const owned = S.tools.rod >= rod.tier;
          const ic = h('div');
          ic.append(spr(TOOLS.rod.url, 0, 0, TOOLS.rod.w, TOOLS.rod.h, 34));
          r.append(ic);
          const info = h('div', 'grow');
          info.innerHTML = `<div class="t1">${rod.name}${S.tools.rod === rod.tier ? ' <span class="tl-lv">Đang dùng</span>' : ''}</div><div class="t2">+${Math.round(rod.bonus * 100)}% tỉ lệ cá hiếm</div>`;
          r.append(info);
          r.append(owned ? btn('Đã có', '', undefined) : priceBtn(rod.price, 'gold', () => { if (buyRod(rod.tier)) render(); }));
          body.append(r);
        }
      } else if (tab === 1) {
        for (const id of ['bait_worm', 'bait_shrimp', 'bait_vip']) {
          const def = item(id);
          const r = h('div', 'row');
          const ic = h('div'); ic.append(iconOf(def, 30)); r.append(ic);
          const info = h('div', 'grow');
          info.innerHTML = `<div class="t1">${def.name} <span class="qty">x${itemCount(id)}</span></div><div class="t2">${def.desc}</div>`;
          r.append(info);
          r.append(priceBtn(def.buy ?? 0, 'gold', () => {
            if (spend(def.buy ?? 0)) { addItem(id); sfx.coin(); render(); }
          }));
          body.append(r);
        }
        body.append(h('div', 'hint', 'Khi thả câu sẽ tự móc mồi xịn nhất trong túi.'));
      }
    };
    tabs(['Cần câu', 'Mồi câu'], i => { tab = i; render(); });
    render();
  });

  // ---- shop thời trang chibi (part Avatar) ----
  // [nhãn, z, icon UI]
  const CHIBI_TABS: [string, number, string][] = [
    ['Skin', -1, 'star'], ['Áo', 20, 'shirt'], ['Quần', 10, 'pants'],
    ['Mũ', 60, 'hat'], ['Kính', 65, 'glasses'], ['Cầm tay', 70, 'candy']
  ];

  // ảnh nhân vật mặc trọn bộ skin (xem trước)
  function skinFace(sk: SkinDef, size = 74): HTMLElement {
    const base = S.player.chibi;
    const look: any = { ...(base ?? { gender: sk.gender, eyes: 4 }), skin: sk.id, hand: 0 };
    return charFace(look, size);
  }

  registerPanel('fashionshop', () => {
    if (!atShopZone('fashionshop', 'Thời trang Cô Trang')) return;
    const { body, tabs } = openWindow('Thời trang Cô Trang', { size: 'large' });
    let tab = 0;
    const render = () => {
      body.innerHTML = '';
      const z = CHIBI_TABS[tab][1];
      const g = S.player.chibi?.gender ?? 0;
      const grid = h('div', 'grid');
      // ----- tab Skin: bán trọn bộ -----
      if (z === -1) {
        grid.className = 'grid grid-shop';
        for (const sk of SKIN_LIST) {
          if (sk.gender && g && sk.gender !== g) continue;
          const owned = S.skins.includes(sk.id);
          const cell = h('div', `cell cell-lg ${owned ? 'owned' : ''}`);
          const art = h('div', 'cell-art');
          art.append(skinFace(sk, 78));
          const prEl = h('div', 'pr');
          if (owned) prEl.textContent = 'Đã có';
          else prEl.innerHTML = priceHtml(sk.priceXu);
          cell.append(art, h('div', 'nm', sk.name), prEl);
          cell.onclick = () => openPanel('skintry', { skin: sk, owned, onDone: render });
          grid.append(cell);
        }
        body.append(grid);
        return;
      }

      const isHand = z === 70;
      grid.className = 'grid grid-shop';
      for (const p of chibiList(z, g)) {
        // đồ cầm tay: mua về nằm trong túi đồ; đồ mặc: vào tủ đồ
        const owned = isHand ? itemCount(handItemId(p.id)) > 0 : S.chibiWardrobe.includes(p.id);
        const cell = h('div', `cell cell-lg ${owned ? 'owned' : ''}`);
        const xu = chibiPriceXu(p);
        const prEl = h('div', 'pr');
        if (owned && !isHand) prEl.textContent = 'Đã có';
        else prEl.innerHTML = priceHtml(xu);
        const art = h('div', 'cell-art');
        art.append(chibiPreview(p.id, 74));
        // ô trong shop chỉ hiện icon + tên + giá; chỉ số xem ở bảng chi tiết
        cell.append(art, h('div', 'nm', p.name), prEl);
        // bấm vào để xem thử trước khi mua
        cell.onclick = () => openPanel('tryon', { part: p, z, isHand, owned, onDone: render });
        grid.append(cell);
      }
      body.append(grid);
    };
    tabs(CHIBI_TABS.map(c => c[0]), i => { tab = i; render(); }, CHIBI_TABS.map(c => c[2]));
    render();
  });

  // ================= Tiệm cắt tóc & Viện thẩm mỹ =================
  // Đổi kiểu tóc / đôi mắt ngay tại ghế: kiểu đã làm rồi thì đổi miễn phí,
  // kiểu mới phải trả tiền cho thợ.
  // tên part mắt trong data Avatar không dấu -> hiển thị lại cho tử tế
  const EYE_NAME: Record<string, string> = {
    'đen': 'Mắt đen', 'xanh': 'Mắt xanh', 'tím nhạt': 'Mắt tím nhạt',
    'Mat Buon': 'Mắt buồn', 'Mat Vui': 'Mắt vui', 'Mat nhay': 'Mắt nháy',
    'Mat gian': 'Mắt giận', 'Mat khoc': 'Mắt khóc', 'Mat cuoi to': 'Mắt cười to',
    'Mat le luoi': 'Mắt lè lưỡi', 'Mat xau ho': 'Mắt xấu hổ', 'Mat chay mau': 'Mắt chảy máu'
  };
  const partLabel = (z: number, name: string) =>
    z === 40 ? (EYE_NAME[name] ?? name.replace(/^Mat\b/i, 'Mắt')) : name;

  function openStylist(cfg: { panel: string; shopKey: string; title: string; z: number; key: 'hair' | 'eyes'; hint: string }) {
    if (!atShopZone(cfg.shopKey, cfg.title)) return;
    const look = S.player.chibi;
    if (!look) return;
    const { body, win } = openWindow(cfg.title, { size: 'large' });
    win.classList.add('win-shop');
    const render = () => {
      body.innerHTML = '';
      body.classList.add('wd-body');
      const wrap = h('div', 'wd-wrap');

      const left = h('div', 'wd-left stylist-left');
      const mid = h('div', 'wd-char');
      mid.append(charFace(look, 190), h('div', 'wd-char-name', S.player.name));
      left.append(mid);

      const right = h('div', 'wd-right');
      right.append(h('div', 'hint', cfg.hint));
      const card = h('div', 'wd-card');
      const grid = h('div', 'wd-grid');
      const cur = look[cfg.key];
      for (const p of chibiList(cfg.z, look.gender)) {
        const done = S.chibiWardrobe.includes(p.id) || p.id === cur;
        const on = cur === p.id;
        const cell = h('button', `wd-item ${on ? 'active' : ''}`);
        cell.append(chibiHead(p.id, 40, cfg.z), h('div', 'nm', partLabel(cfg.z, p.name)));
        const xu = chibiPriceXu(p);
        const pr = h('div', 'pr');
        if (on) pr.textContent = 'Đang dùng';
        else if (done) pr.textContent = 'Đổi lại';
        else pr.innerHTML = priceHtml(xu);
        cell.append(pr);
        // đã sở hữu thì đổi luôn; chưa có thì mở bảng chi tiết (xem chỉ số rồi mới mua)
        cell.onclick = () => {
          sfx.click();
          if (on) return;
          if (done) {
            look[cfg.key] = p.id;
            save(); bus.emit(EV.APPEARANCE);
            toast(cfg.key === 'hair' ? `Đã đổi kiểu tóc: ${p.name}` : `Đã đổi ${partLabel(40, p.name).toLowerCase()}`, 'wardrobe');
            render();
            return;
          }
          openPanel('tryon', { part: p, z: cfg.z, isHand: false, owned: false, onDone: render });
        };
        grid.append(cell);
      }
      card.append(grid);
      right.append(card);
      wrap.append(left, right);
      body.append(wrap);
    };
    render();
  }

  registerPanel('barbershop', () => openStylist({
    panel: 'barbershop', shopKey: 'shop_barber', title: 'Tiệm cắt tóc Anh Phong',
    z: 50, key: 'hair', hint: 'Chọn kiểu tóc — kiểu đã cắt rồi đổi lại miễn phí.'
  }));
  registerPanel('salonshop', () => openStylist({
    panel: 'salonshop', shopKey: 'shop_salon', title: 'Viện thẩm mỹ Cô Diễm',
    z: 40, key: 'eyes', hint: 'Chọn đôi mắt / biểu cảm — kiểu đã làm rồi đổi lại miễn phí.'
  }));

  // ---- xem thử SKIN trọn bộ ----
  registerPanel('skintry', (data: { skin: SkinDef; owned: boolean; onDone?: () => void }) => {
    const { skin: sk, owned, onDone } = data;
    const { body, close } = openWindow(sk.name, { size: 'small' });
    const look = S.player.chibi;

    const wrap = h('div', 'tryon');
    const before = h('div', 'tryon-char');
    before.append(charFace(look ? { ...look, skin: undefined } as any : undefined, 150), h('div', 'tryon-cap', 'Hiện tại'));
    const after = h('div', 'tryon-char');
    after.append(skinFace(sk, 150), h('div', 'tryon-cap', 'Mặc skin'));
    wrap.append(before, after);
    body.append(wrap);

    const info = h('div', 'tryon-info');
    info.innerHTML = owned ? '<b>Bạn đã sở hữu skin này</b>'
      : `Trọn bộ • Giá: ${priceHtml(sk.priceXu)}`;
    body.append(info);

    const bar = h('div');
    bar.style.cssText = 'display:flex;gap:8px;margin-top:10px;flex-wrap:wrap;justify-content:center';
    const wear = () => {
      if (!look) return;
      look.skin = sk.id; save(); bus.emit(EV.APPEARANCE);
      toast(`Đã mặc skin ${sk.name}!`, '');
      onDone?.(); close();
    };
    if (owned) bar.append(btn('Mặc ngay', 'gold', wear));
    else bar.append(btn('Mua & mặc', 'gold', () => {
      const ok = spend(sk.priceXu);
      if (!ok) return;
      S.skins.push(sk.id); addStat('fashion_bought'); sfx.coin();
      wear();
    }));
    bar.append(btn('Đóng', '', close));
    body.append(bar);
  });

  // ---- xem thử trang phục trước khi mua ----
  registerPanel('tryon', (data: { part: any; z: number; isHand: boolean; owned: boolean; onDone?: () => void }) => {
    const { part: p, z, isHand, owned, onDone } = data;
    const { body, close } = openWindow(p.name, { size: 'small' });
    const look = S.player.chibi;
    const xu = chibiPriceXu(p);

    const wrap = h('div', 'tryon');
    // trái: nhân vật đang mặc thử  |  phải: món đồ phóng to
    const left = h('div', 'tryon-char');
    const KEY: Record<number, keyof typeof look> = { 10: 'pant', 20: 'shirt', 40: 'eyes', 50: 'hair', 60: 'hat', 65: 'glasses', 70: 'hand' } as any;
    const preview = look ? { ...look, [KEY[z]]: p.id } as any : undefined;
    left.append(charFace(preview, 170), h('div', 'tryon-cap', 'Mặc thử'));
    const right = h('div', 'tryon-art');
    right.append(chibiPreview(p.id, 120));
    wrap.append(left, right);
    body.append(wrap);

    const info = h('div', 'tryon-info');
    const ps = partStats(p);
    const statsLine = ps ? ` · ${formatStats(ps).join(' ')}` : '';
    info.innerHTML = owned && !isHand
      ? `<b>Bạn đã sở hữu món này</b>${statsLine}`
      : `Giá: ${priceHtml(xu)}${statsLine}`;
    body.append(info);

    const bar = h('div');
    bar.style.cssText = 'display:flex;gap:8px;margin-top:10px;flex-wrap:wrap;justify-content:center';
    if (owned && !isHand) {
      bar.append(btn('Mặc ngay', 'gold', () => {
        if (look) { (look as any)[KEY[z]] = p.id; save(); bus.emit(EV.APPEARANCE); toast(`Đã mặc ${p.name}`, ''); }
        close();
      }));
    } else {
      bar.append(btn(`Mua`, 'gold', () => {
        if (!spend(xu)) return;
        if (isHand) {
          addItem(handItemId(p.id));
          toast(`Đã mua ${p.name}! Mở Túi đồ -> Dùng để đưa xuống ô trang bị.`, '');
        } else {
          S.chibiWardrobe.push(p.id);
          if (look) { (look as any)[KEY[z]] = p.id; bus.emit(EV.APPEARANCE); }
          toast(`Đã mua và mặc ${p.name}!`, '');
        }
        save(); addStat('fashion_bought'); sfx.coin();
        onDone?.(); close();
      }));
    }
    bar.append(btn('Đóng', '', close));
    body.append(bar);
  });

  // ---- shop nhà & nội thất ----
  registerPanel('houseshop', () => {
    if (!atShopZone('houseshop', 'Nhà đất Chị Lan')) return;
    const { body, tabs } = openWindow('Nhà đất Chị Lan', { size: 'large' });
    let tab = 0;
    const render = () => {
      body.innerHTML = '';
      if (tab === 0) {
        // nhà
        if (!S.house.owned) {
          const lv = HOUSE_LEVELS[0];
          const r = h('div', 'row');
          r.innerHTML = `<img class="ico-img" src="assets/ui/act/house.png"><div class="grow"><div class="t1">${lv.name}</div><div class="t2">Ngôi nhà đầu tiên của bạn!</div></div>`;
          r.append(priceBtn(lv.price, 'gold', () => import('@/systems/housing').then(hh => { if (hh.buyHouse()) render(); })));
          body.append(r);
        } else if (S.house.level < HOUSE_LEVELS.length) {
          const next = HOUSE_LEVELS[S.house.level];
          const r = h('div', 'row');
          r.innerHTML = `<img class="ico-img" src="assets/ui/act/house.png"><div class="grow"><div class="t1">Nâng cấp: ${next.name}</div><div class="t2">Phòng rộng hơn (${next.size}x${next.size})</div></div>`;
          r.append(btn(`${next.price} xu`, 'gold', () => { if (upgradeHouse()) render(); }));
          body.append(r);
        } else {
          body.append(h('div', 'hint', 'Nhà của bạn đã là Biệt thự xịn nhất rồi!'));
        }
        if (S.house.owned) {
          body.append(h('div', 'sep'));
          body.append(h('div', 'lbl', 'Giấy dán tường'));
          const sw1 = h('div', 'swatches');
          WALLPAPERS.forEach((c, i) => {
            const s = h('div', `sw ${S.house.wallpaper === i ? 'active' : ''}`);
            s.style.background = `#${c.toString(16).padStart(6, '0')}`;
            s.onclick = () => { setWallpaper(i); render(); };
            sw1.append(s);
          });
          body.append(sw1);
          const floorLbl = h('div', 'lbl', 'Sàn nhà');
          floorLbl.style.marginTop = '8px';
          body.append(floorLbl);
          const sw2 = h('div', 'swatches');
          FLOORS.forEach((c, i) => {
            const s = h('div', `sw ${S.house.floor === i ? 'active' : ''}`);
            s.style.background = `#${c.toString(16).padStart(6, '0')}`;
            s.onclick = () => { setFloor(i); render(); };
            sw2.append(s);
          });
          body.append(sw2);
        }
      } else {
        const grid = h('div', 'grid');
        for (const f of FURNITURE_LIST) {
          const cell = h('div', 'cell');
          const price = priceHtml(f.price);
          cell.innerHTML = `<div class="ico">${f.icon}</div><div class="nm"></div><div class="pr">${price}</div>`;
          (cell.querySelector('.nm') as HTMLElement).textContent = f.name;
          cell.onclick = () => {
            const ok = spend(f.price);
            if (ok) { addItem(f.id); toast(`Đã mua ${f.name} — vào Kho đồ để đặt trong nhà.`, f.icon); }
          };
          grid.append(cell);
        }
        body.append(grid);
      }
    };
    tabs(['Nhà & Trang trí', 'Nội thất'], i => { tab = i; render(); });
    render();
  });

  // ---- shop vật nuôi ----
  // ================= Chuồng thú (vào chuồng rồi mới mua/nâng cấp) =================
  registerPanel('animalshop', () => {
    if (!atShopZone('animalshop', 'Chuồng thú')) return;
    const { body } = openWindow('Chuồng thú', { size: 'normal' });
    const render = () => {
      body.innerHTML = '';
      const lv = S.livestock.barnLevel;
      body.append(h('div', 'hint', lv === 0
        ? 'Chuồng trống — mua con đầu tiên là chuồng tự dựng ở Nông trại.'
        : `Chuồng cấp ${lv} · ${S.livestock.animals.length}/${livestock.barnCapacity()} con`));

      // đang nuôi
      for (const a of S.livestock.animals) {
        const def = ANIMALS[a.type];
        if (!def) continue;
        const r = h('div', 'row');
        r.append(spr(`assets/animals/${def.sheet}`, 0, def.frameH * 2, def.frameW, def.frameH, 40));
        const info = h('div', 'grow');
        info.innerHTML = `<div class="t1">${def.name}</div><div class="t2">${livestock.isHungry(a) ? 'Đang đói — cho ăn để có sản phẩm' : 'Khoẻ mạnh'}</div>`;
        r.append(info);
        body.append(r);
      }

      // nâng cấp chuồng
      if (lv > 0 && lv < 3) {
        const up = h('div', 'row');
        up.append(uiIcon('barn', 30));
        const ui2 = h('div', 'grow');
        ui2.innerHTML = `<div class="t1">Nâng chuồng lên cấp ${lv + 1}</div><div class="t2">Chứa tối đa ${BARN_CAPACITY[lv + 1]} con</div>`;
        up.append(ui2, priceBtn(BARN_UPGRADE_COST[lv], 'gold', () => {
          if (livestock.upgradeBarn()) { render(); worldScene()?.scene?.restart(); }
        }));
        body.append(up);
      }

      body.append(h('div', 'lbl', 'Mua vật nuôi'));
      for (const a of ANIMAL_LIST) {
        const r = h('div', 'row');
        r.append(spr(`assets/animals/${a.sheet}`, 0, a.frameH * 2, a.frameW, a.frameH, 44));
        r.innerHTML += `<div class="grow"><div class="t1">${a.name}</div><div class="t2">Cho ra ${item(a.product).name} mỗi ${a.produceMin} phút sau khi ăn</div></div>`;
        r.append(priceBtn(a.price, 'gold', () => {
          if (livestock.buyAnimal(a.id)) { render(); worldScene()?.scene?.restart(); }
        }));
        body.append(r);
      }
    };
    render();
  });

  registerPanel('quests', () => {
    const { body, tabs } = openWindow('Nhiệm vụ');
    let tab = 0;
    const render = () => {
      body.innerHTML = '';
      if (tab === 0) {
        const list = activeQuestList();
        if (!list.length) body.append(h('div', 'hint', 'Không có nhiệm vụ nào — quay lại vào ngày mai nhé!'));
        for (const qi of list) {
          const r = h('div', 'row');
          const pct = Math.round(qi.progress / qi.def.target * 100);
          r.innerHTML = `
            <img class="ico-img" src="assets/ui/pack/icon_${qi.def.type === 'daily' ? 'daily' : 'quest'}.png">
            <div class="grow">
              <div class="t1"></div><div class="t2"></div>
              <div class="progress" style="margin-top:4px"><div style="width:${pct}%"></div></div>
              <div class="t2">${qi.progress}/${qi.def.target} · Thưởng: ${rewardText(qi.def.reward)}</div>
            </div>`;
          (r.querySelector('.t1') as HTMLElement).textContent = qi.def.name;
          (r.querySelector('.t2') as HTMLElement).textContent = qi.def.desc;
          if (qi.done && !qi.claimed) r.append(btn('Nhận thưởng', 'gold', () => { claimQuest(qi.def.id); render(); }));
          body.append(r);
        }
      } else {
        for (const a of ACHIEVEMENTS) {
          const got = S.achievements.includes(a.id);
          const prog = Math.min(S.stats[a.stat] ?? 0, a.target);
          const r = h('div', 'row');
          r.style.opacity = got ? '1' : '.8';
          r.innerHTML = `
            <img class="ico-img" src="assets/ui/pack/icon_${got ? 'trophy' : 'quest'}.png">
            <div class="grow">
              <div class="t1"></div><div class="t2"></div>
              <div class="progress" style="margin-top:4px"><div style="width:${Math.round(prog / a.target * 100)}%"></div></div>
              <div class="t2">${prog}/${a.target} · ${rewardText(a.reward)}</div>
            </div>`;
          (r.querySelector('.t1') as HTMLElement).textContent = a.name;
          (r.querySelector('.t2') as HTMLElement).textContent = a.desc;
          body.append(r);
        }
      }
    };
    tabs(['Nhiệm vụ', 'Thành tựu'], i => { tab = i; render(); });
    render();
  });

  // ================= Hồ sơ & Tủ đồ & Danh hiệu =================
  // ================= Nhân vật: hub có cột tab dọc bên phải (kiểu GunPow) =================
  // [id, tên, icon trong assets/ui/inv]
  const CH_SECTIONS: [string, string, string][] = [
    ['wardrobe', 'Quần áo', 'ic_shirt'], ['skin', 'Skin', 'ic_skin'], ['title', 'Danh hiệu', 'ic_level']
  ];

  // Tủ đồ dựng theo đúng mẫu Inventory của Cozy UI Pack: tab dán trên nóc,
  // thân là tấm modal nét đứt, KHÔNG dùng khung gỗ chung của các popup khác.
  function openCharHub(sec = 'wardrobe') {
    const { body, win } = openWindow('', { size: 'large' });
    win.classList.add('win-wardrobe');
    win.querySelector('.win-head')?.remove();

    const tabBar = h('div', 'wr-tabs');
    win.insertBefore(tabBar, body);

    const draw = () => {
      tabBar.innerHTML = '';
      for (const [id, name, ico] of CH_SECTIONS) {
        const t = h('button', `wr-tab ${sec === id ? 'on' : ''}`);
        const im = document.createElement('img'); im.src = `assets/ui/inv/${ico}.png`;
        t.append(im);
        if (sec === id) t.append(h('span', '', name));
        t.title = name;
        t.onclick = () => { sfx.click(); sec = id; draw(); };
        tabBar.append(t);
      }
      body.innerHTML = '';
      body.className = 'win-body ch-body';
      const main = h('div', 'ch-main');
      body.append(main);
      openCharHubRefresh = draw;
      if (sec === 'wardrobe') openWardrobe(main);
      else if (sec === 'skin') openWardrobe(main, 'skin');
      else renderTitles(main, draw);
    };
    draw();
  }

  function renderTitles(box: HTMLElement, redraw: () => void) {
    box.append(h('div', 'hint', 'Bấm vào một danh hiệu để xem chi tiết và đeo lên. Danh hiệu xám là chưa mở khoá.'));
    const card = h('div', 'wd-card');
    const grid = h('div', 'title-grid');
    for (const id of Object.keys(TITLES)) {
      const t = TITLES[id];
      const owned = S.player.titles.includes(id);
      const on = S.player.title === id;
      const c = h('button', `title-row ${on ? 'active' : ''} ${owned ? '' : 'locked'}`);
      const src = h('div', 'tt-src', t.source);
      const mid = h('div', 'tt-mid');
      const nm = h('div', 'tt-name'); nm.textContent = `【${t.name}】`;
      nm.style.color = owned ? t.color : '#9b8a72';
      mid.append(nm, h('div', 'tt-how', t.how));
      const tick = h('div', 'tt-tick');
      if (on) tick.append(uiIcon('check', 18));
      c.append(src, mid, tick);
      c.onclick = () => { sfx.click(); openTitleDetail(id, redraw); };
      grid.append(c);
    }
    card.append(grid);
    box.append(card);
  }

  // chi tiết 1 danh hiệu: xem trước dạng ảnh (như hiện trên đầu nhân vật) + nút đeo
  function openTitleDetail(id: string, redraw: () => void) {
    const t = TITLES[id];
    const owned = S.player.titles.includes(id);
    const on = S.player.title === id;
    const { body, close } = openWindow('Danh hiệu', { size: 'small' });

    const prev = h('div', 'tt-prev');
    prev.append(titlePlaque(t.name, t.color, 2));
    body.append(prev);
    body.append(h('div', 'tt-prev-cap', 'Hiển thị trên đầu nhân vật'));

    const info = h('div', 'tt-detail');
    info.innerHTML = `<div class="row"><div class="grow t2">Nguồn</div><div class="t1">${t.source}</div></div>` +
      `<div class="row"><div class="grow t2">Điều kiện</div></div>` +
      `<div class="t1 tt-how-full"></div>` +
      `<div class="row"><div class="grow t2">Trạng thái</div><div class="t1">${owned ? (on ? 'Đang đeo' : 'Đã mở khoá') : 'Chưa mở khoá'}</div></div>`;
    (info.querySelector('.tt-how-full') as HTMLElement).textContent = t.how;
    body.append(info);

    const bar = h('div'); bar.style.cssText = 'display:flex;gap:8px;justify-content:center;margin-top:10px';
    if (!owned) bar.append(btn('Chưa mở khoá', '', undefined));
    else if (on) bar.append(btn('Đang đeo', '', undefined));
    else bar.append(btn('Đeo danh hiệu', 'gold', () => {
      S.player.title = id; save(); bus.emit(EV.STATE_CHANGED); close(); redraw();
      toast(`Đã đeo danh hiệu 【${t.name}】`, 'rank');
    }));
    body.append(bar);
  }

  let openCharHubRefresh: () => void = () => {};

  function renderCharInfo(body: HTMLElement) {
        const t = TITLES[S.player.title];
        const need = S.player.level * 100;
        const pct = Math.round(S.player.exp / need * 100);
        const info = h('div', 'pf-card');
        info.innerHTML = `
          <div id="pf-face"></div>
          <div class="pf-meta">
            <div class="pf-name" id="pf-name"></div>
            <div class="pf-title" style="color:${t?.color}">「${t?.name}」</div>
            <div class="pf-sub">
              <span class="pf-lv">Cấp ${S.player.level}</span>
              <span>${S.player.gender === 'male' ? 'Nam' : 'Nữ'}</span>
            </div>
            <div class="pf-exp">
              <div class="pf-exp-bar"><div class="pf-exp-fill" style="width:${pct}%"></div></div>
              <span class="pf-exp-num">${fmt(S.player.exp)}/${fmt(need)}</span>
            </div>
          </div>`;
        (info.querySelector('#pf-name') as HTMLElement).textContent = S.player.name;
        const faceBox = info.querySelector('#pf-face') as HTMLElement;
        faceBox.className = 'pf-face-box';
        faceBox.append(avatarEl(64));
        const avaBtn = h('button', 'pf-ava-btn', 'Đổi ảnh');
        avaBtn.onclick = () => { sfx.click(); openPanel('avatarpick'); };
        faceBox.append(avaBtn);
        body.append(info);

        const cs = S.player.charStats;
        const eq = S.player.chibi ? equipStats(S.player.chibi) : { health: 0, intellect: 0, strength: 0, agility: 0, charm: 0 } as import('@/core/types').CharStats;
        const statHead = h('div', 'pf-stat-head');
        statHead.innerHTML = `<span class="t1">Chỉ số nhân vật</span>`;
        if (S.player.statPoints > 0) {
          const badge = h('span', 'pf-sp-badge', `${S.player.statPoints} điểm`);
          statHead.append(badge);
        }
        body.append(statHead);

        const render = () => {
          statGrid.innerHTML = '';
          for (const key of STAT_KEYS) {
            const row = h('div', 'pf-stat-row');
            const base = cs[key];
            const bonus = eq[key];
            const total = base + bonus;
            const maxBar = 100;
            const basePct = Math.min(base / maxBar * 100, 100);
            const totalPct = Math.min(total / maxBar * 100, 100);
            row.innerHTML = `<div class="pf-stat-name">${STAT_NAMES[key]}</div>` +
              `<div class="pf-stat-bar"><div class="pf-stat-fill pf-eq" style="width:${totalPct}%"></div><div class="pf-stat-fill pf-base" style="width:${basePct}%"></div></div>` +
              `<div class="pf-stat-val">${total}${bonus > 0 ? `<span class="pf-bonus">(+${bonus})</span>` : ''}</div>`;
            if (S.player.statPoints > 0) {
              const plus = h('button', 'pf-stat-plus', '+');
              plus.onclick = () => {
                if (allocateStat(key)) { sfx.click(); render(); }
              };
              row.append(plus);
            }
            statGrid.append(row);
          }
          if (S.player.statPoints > 0) {
            statHead.querySelector('.pf-sp-badge')?.remove();
            const badge = h('span', 'pf-sp-badge', `${S.player.statPoints} điểm`);
            statHead.append(badge);
          } else {
            statHead.querySelector('.pf-sp-badge')?.remove();
          }
        };
        const statGrid = h('div', 'pf-stat-grid');
        body.append(statGrid);
        render();

        body.append(h('div', 'pf-sec-head', 'Thành tích'));
        const statsBox = h('div', 'pf-tiles');
        const rows: [string, string, number][] = [
          ['basket', 'Thu hoạch', S.stats['harvested'] ?? 0],
          ['fish', 'Cá đã câu', S.stats['fish_caught'] ?? 0],
          ['coin', 'Xu kiếm được', S.stats['coins_earned'] ?? 0],
          ['rank', 'Thành tựu', S.achievements.length],
          ['minigame', 'Thắng minigame', S.minigames.caroWins + S.minigames.xiangqiWins + S.minigames.rpsWins]
        ];
        for (const [ico, lbl, v] of rows) {
          const d = h('div', 'pf-tile');
          d.append(uiIcon(ico, 24));
          const txt = h('div', 'pf-tile-txt');
          txt.append(h('div', 'pf-tile-val', fmt(v)), h('div', 'pf-tile-lbl', lbl));
          d.append(txt);
          statsBox.append(d);
        }
        body.append(statsBox);
  }

  registerPanel('profile', () => { const { body } = openWindow('Hồ sơ cá nhân'); renderCharInfo(body); });

  // ===== Đổi ảnh đại diện: ảnh có sẵn / đầu nhân vật / ảnh tự tải lên =====
  registerPanel('avatarpick', () => {
    const { body, close, tabs } = openWindow('Đổi ảnh đại diện', { size: 'small' });
    const look = S.player.chibi;
    const content = h('div');

    const apply = (pic: string | undefined) => {
      S.player.avatarPic = pic;
      save(true); sfx.click();
      bus.emit(EV.STATE_CHANGED);
      // hồ sơ đang mở phía sau không tự dựng lại -> thay ảnh tại chỗ
      const box = document.querySelector('.pf-face-box');
      box?.firstElementChild?.replaceWith(avatarEl(56));
      toast(pic ? 'Đã đổi ảnh đại diện!' : 'Đã gỡ ảnh — dùng lại đầu nhân vật.', 'check');
      close();
    };

    // --- tab 1: 35 ảnh dựng sẵn (bấm lại ảnh đang chọn = gỡ, quay về đầu nhân vật) ---
    const renderPack = () => {
      content.innerHTML = '';
      content.append(h('div', 'hint',
        'Chọn một ảnh đại diện. Bấm lại đúng ảnh đang dùng để gỡ và hiện lại đầu nhân vật.'));
      const grid = h('div', 'ava-grid');
      for (const id of AVATAR_PICS) {
        const mine = S.player.avatarPic === `pack:${id}`;
        const cell = h('div', `ava-cell ${mine ? 'active' : ''}`);
        const img = document.createElement('img');
        img.src = avatarPicUrl(id);
        img.draggable = false;
        img.style.cssText = 'width:100%;height:100%;object-fit:cover;display:block';
        cell.append(img);
        cell.onclick = () => apply(mine ? undefined : `pack:${id}`);
        grid.append(cell);
      }
      content.append(grid);
    };

    // --- tab 2: tải ảnh từ máy ---
    const renderUpload = () => {
      content.innerHTML = '';
      content.append(h('div', 'hint', 'Chọn ảnh từ máy — ảnh sẽ được cắt vuông và thu về 128×128.'));
      const prev = h('div', 'ava-up-prev');
      if (isUploadedPic(S.player.avatarPic)) {
        const cur = document.createElement('img');
        cur.src = S.player.avatarPic!;
        prev.append(cur);
      }
      const file = h('input') as HTMLInputElement;
      file.type = 'file';
      file.accept = 'image/*';
      file.style.display = 'none';
      let picked = '';
      const okBtn = btn('Dùng ảnh này', 'gold', () => { if (picked) apply(picked); });
      okBtn.style.display = 'none';
      file.onchange = () => {
        const f = file.files?.[0];
        if (!f) return;
        if (f.size > 8 * 1024 * 1024) { toast('Ảnh quá lớn — tối đa 8MB', 'alert'); return; }
        const fr = new FileReader();
        fr.onload = () => {
          const im = new Image();
          im.onload = () => {
            picked = squareThumb(im, 128);
            prev.innerHTML = '';
            const p = document.createElement('img');
            p.src = picked;
            prev.append(p);
            okBtn.style.display = '';
          };
          im.onerror = () => toast('Không đọc được ảnh này', 'alert');
          im.src = String(fr.result);
        };
        fr.onerror = () => toast('Không đọc được tệp', 'alert');
        fr.readAsDataURL(f);
      };
      const row = h('div');
      row.style.cssText = 'display:flex;gap:8px;justify-content:center;margin-top:10px';
      row.append(btn('Chọn ảnh...', 'blue', () => file.click()), okBtn);
      if (isUploadedPic(S.player.avatarPic)) {
        row.append(btn('Gỡ ảnh', '', () => apply(undefined)));
      }
      content.append(prev, row, file);
    };

    tabs(['Có sẵn', 'Tải lên'], i => { if (i === 0) renderPack(); else renderUpload(); });
    body.append(content);
    renderPack();
  });
  registerPanel('wardrobe', () => openCharHub('wardrobe'));


  // ================= Tiệm thú cưng =================
  registerPanel('petshop', () => {
    if (!atShopZone('petshop', 'Tiệm thú cưng')) return;
    const { body } = openWindow('Tiệm thú cưng');
    const render = () => {
      body.innerHTML = '';
      body.append(h('div', 'hint', 'Mỗi bé có một công dụng riêng — nuôi được cả ba!'));
      for (const p of PET_LIST) {
        const r = h('div', 'row');
        const ic = h('div');
        ic.append(spr(petUrl(p.id), 0, 0, p.frameW, p.frameH, 44));
        r.append(ic);
        const info = h('div', 'grow');
        info.innerHTML = `<div class="t1">${p.name}</div><div class="t2">${p.perk}</div>`;
        r.append(info);
        if (ownsPet(p.id)) {
          r.append(btn('Đã nuôi', '', undefined));
        } else {
          r.append(priceBtn(p.price, 'gold', () => {
            if (!spend(p.price)) return;
            S.pets.push(p.id);
            if (!S.activePet) S.activePet = p.id;
            save(true); sfx.coin();
            toast(`${p.name} đã về nhà bạn! Nhà thú cưng đã dựng ở Nông trại.`, p.icon);
            bus.emit(EV.ZONE);
            render();
          }));
        }
        body.append(r);
      }
    };
    render();
  });

  // ================= Thú cưng của tôi =================
  registerPanel('petbag', () => {
    const { body } = openWindow('Thú cưng của tôi');
    const render = () => {
      body.innerHTML = '';
      if (!S.pets?.length) {
        body.append(h('div', 'hint', 'Chưa nuôi bé nào — ghé Tiệm thú cưng ở Thành phố nhé!'));
        return;
      }
      for (const id of S.pets) {
        const p = PETS[id];
        if (!p) continue;
        const active = S.activePet === id;
        const r = h('div', `row ${active ? 'row-active' : ''}`);
        const ic = h('div');
        ic.append(spr(petUrl(id), 0, 0, p.frameW, p.frameH, 44));
        r.append(ic);
        const info = h('div', 'grow');
        info.innerHTML = `<div class="t1">${p.name}${active ? ' <span class="tl-lv">đang theo</span>' : ''}</div><div class="t2">${p.perkFull}</div>`;
        r.append(info);
        r.append(btn(active ? 'Cất về nhà' : 'Cho ra ngoài', active ? '' : 'gold', () => {
          S.activePet = active ? undefined : id;
          save(true);
          toast(active ? `${p.name} về nhà nghỉ.` : `${p.name} đi cùng bạn!`, p.icon);
          bus.emit(EV.ZONE);
          render();
        }));
        body.append(r);
      }
      body.append(h('div', 'hint', 'Bấm vào thú cưng ngoài map để dắt đi dạo / vuốt ve.'));
    };
    render();
  });


  // ================= Chạm vào người chơi khác =================
  registerPanel('playermenu', (data: { friend: { id: string; name: string; level: number } }) => {
    const f = data.friend;
    const { body, close } = openWindow(f.name, { size: 'small' });
    const render = () => {
      body.innerHTML = '';
      const aff = affinityOf(f.id);
      const isFriend = S.social.friends.some(x => x.id === f.id);
      const head = h('div', 'row');
      head.innerHTML = `<div class="grow"><div class="t1">${f.name} <span class="tl-lv">Lv.${f.level}</span></div>` +
        `<div class="t2">Thiện cảm: ${aff}/100 · ${affinityLabel(aff)}${isFriend ? ' · Bạn bè' : ''}</div></div>`;
      body.append(head);
      const bar = h('div', 'aff-bar');
      const fill = h('div', 'aff-fill'); fill.style.width = `${aff}%`;
      bar.append(fill); body.append(bar);

      const grid = h('div', 'wd-grid');
      const cell = (icon: string, label: string, cb: () => void) => {
        const c = h('button', 'wd-item');
        c.append(uiIcon(icon, 30), h('div', 'nm', label));
        c.onclick = () => { sfx.click(); cb(); };
        grid.append(c);
      };
      cell('person', 'Thông tin', () => openPanel('dialog', {
        title: f.name,
        text: `Cấp độ: ${f.level}\nThiện cảm: ${aff}/100 (${affinityLabel(aff)})\n${isFriend ? 'Đã là bạn bè của bạn.' : 'Chưa kết bạn.'}`
      }));
      if (!isFriend) cell('group', 'Kết bạn', () => { addFriend({ ...f, online: true }); addAffinity(f.id, 10); render(); });
      cell('chat', 'Nhắn tin', () => { close(); openPanel('chat', { to: f.name }); });
      cell('runner', 'Hành động', () => { close(); openPanel('playeract', { friend: f }); });
      cell('gift', 'Tặng quà', () => { close(); openPanel('playergift', { friend: f }); });
      cell('close', 'Chặn / Báo cáo', () => openPanel('dialog', {
        title: f.name,
        text: 'Bạn muốn làm gì với người chơi này?',
        actions: [
          { icon: '', ui: 'close', label: 'Chặn', cb: () => { blockPlayer(f.id, f.name); close(); } },
          { icon: '', ui: 'mail', label: 'Báo cáo', cb: () => reportPlayer(f.id, f.name) }
        ]
      }));
      body.append(grid);
    };
    render();
  });

  // ---- hành động thân mật với người chơi ----
  // [icon, tên, lời thoại, thiện cảm, animation]
  const PLAYER_ACTS: [string, string, string, number, string][] = [
    ['act_kiss', 'Hôn', '{a} hôn {b} một cái', 6, 'kiss'],
    ['act_hug', 'Ôm', '{a} ôm {b} thật chặt', 5, 'hug'],
    ['act_kick', 'Đá đít', '{a} đá đít {b} một phát', -3, 'kick'],
    ['act_pat', 'An ủi', '{a} vỗ vai an ủi {b}', 4, 'pat']
  ];
  registerPanel('playeract', (data: { friend: { id: string; name: string } }) => {
    const f = data.friend;
    const { body, close } = openWindow(`Hành động với ${f.name}`, { size: 'small' });
    const grid = h('div', 'wd-grid');
    for (const [icon, label, tpl, aff, kind] of PLAYER_ACTS) {
      const c = h('button', 'wd-item');
      c.append(uiIcon(icon, 40), h('div', 'nm', label),
        h('div', 'pr', `${aff > 0 ? '+' : ''}${aff} thiện cảm`));
      c.onclick = () => {
        sfx.click();
        addAffinity(f.id, aff);
        const msg = tpl.replace('{a}', S.player.name).replace('{b}', f.name);
        close();
        // diễn hành động ngay trong game
        bus.emit('world:playeract', { id: f.id, name: f.name, kind, icon, text: msg, aff });
      };
      grid.append(c);
    }
    body.append(grid);
  });

  // ---- tặng quà tăng thiện cảm ----
  registerPanel('playergift', (data: { friend: { id: string; name: string } }) => {
    const f = data.friend;
    const { body, close } = openWindow(`Tặng quà cho ${f.name}`, { size: 'small' });
    const grid = h('div', 'grid');
    const giftable = Object.entries(S.inventory).filter(([id]) => {
      const k = item(id).kind;
      return k === 'gift' || k === 'crop' || k === 'food' || k === 'fish';
    });
    if (!giftable.length) {
      body.append(h('div', 'hint', 'Chưa có gì để tặng — mua quà ở Tiệm quà (Khu mua sắm) nhé!'));
      return;
    }
    for (const [id, qty] of giftable) {
      const def = item(id);
      const aff = def.kind === 'gift' ? 12 : def.kind === 'fish' ? 6 : 4;
      const c = h('div', 'cell');
      c.append(iconOf(def), h('div', 'nm', def.name), h('div', 'qty', `x${qty}`), h('div', 'pr', `+${aff} thiện cảm`));
      c.onclick = () => {
        if (!removeItem(id)) return;
        addAffinity(f.id, aff);
        addStat('gifts_sent');
        sfx.coin(); save();
        toast(`Đã tặng ${def.name} cho ${f.name} (+${aff} thiện cảm)`, 'gift');
        close();
      };
      grid.append(c);
    }
    body.append(grid);
  });

  // ================= Nâng cấp nông cụ =================
  registerPanel('toolupgrade', () => {
    if (!atShopZone('toolupgrade', 'Quầy nâng cấp nông cụ (Bách hóa)')) return;
    const { body } = openWindow('Nâng cấp nông cụ');
    const render = () => {
      body.innerHTML = '';
      for (const tid of ['hoe', 'can', 'basket']) {
        const t = TOOLS[tid];
        const lv = toolLevel(tid);
        const cur = toolUpgradeAt(tid, lv);
        const next = toolUpgradeAt(tid, lv + 1);
        const r = h('div', 'row');
        const ic = h('div');
        ic.append(spr(t.url, 0, 0, t.w, t.h, 34));
        const info = h('div', 'grow');
        if (lv <= 0) {
          info.innerHTML = `<div class="t1">${t.name} — chưa sở hữu</div><div class="t2">Mua ở gian hàng nông cụ của Bách hóa trước nhé.</div>`;
          r.append(ic, info);
        } else {
          info.innerHTML = `<div class="t1">${cur?.name ?? t.name} <span class="tl-lv">Lv.${lv}</span></div><div class="t2">${cur?.desc ?? ''}${next ? `<br>➜ ${next.name}: ${next.desc}` : ''}</div>`;
          r.append(ic, info);
          if (next) {
            r.append(btn(`${next.price} xu`, 'gold', () => {
              if (!spend(next.price)) return;
              if (tid === 'hoe') S.tools.hoe = next.level;
              else if (tid === 'can') S.tools.can = next.level;
              else S.tools.basket = next.level;
              save(); sfx.coin(); toast(`Nâng thành ${next.name}!`, 'rank');
              bus.emit('hotbar:changed');
              render();
            }));
          } else r.append(btn('MAX', '', undefined));
        }
        body.append(r);
      }
    };
    render();
  });

  // Tủ đồ kiểu GunPow: trái là nhân vật giữa các ô trang bị, phải là lưới đồ chia tab
  // sức chứa mỗi ngăn tủ đồ
  const WD_CAP = 100;

  function openWardrobe(body: HTMLElement, mode: 'wear' | 'skin' = 'wear') {
    const look = S.player.chibi;
    if (!look) return;
    const apply = () => { save(); bus.emit(EV.APPEARANCE); };

    type SlotKey = 'pant' | 'shirt' | 'hair' | 'eyes' | 'hat' | 'glasses' | 'hand' | 'skin';
    // [icon UI, nhãn, z, khoá, tuỳ chọn]   z = -1 -> ô Skin trọn bộ
    // Xếp 3 ô mỗi bên nhân vật đúng như mẫu của pack: trái mũ/kính/tóc,
    // phải áo/quần/đồ cầm tay. Mắt vẫn để ở viện thẩm mỹ.
    const ALL: [string, string, number, SlotKey, boolean][] = [
      ['hat', 'Mũ', 60, 'hat', true],
      ['glasses', 'Kính', 65, 'glasses', true],
      ['hair', 'Tóc', 50, 'hair', false],
      ['shirt', 'Áo', 20, 'shirt', false],
      ['pants', 'Quần', 10, 'pant', false],
      ['hand', 'Cầm tay', 70, 'hand', true]
    ];
    // Skin là mục riêng ở cột tab dọc nên không nằm chung dải tab ngang
    const SLOTS: [string, string, number, SlotKey, boolean][] =
      mode === 'skin' ? [['wardrobe', 'Skin', -1, 'skin', true]] : ALL;
    let tab = 0;

    const render = () => {
      body.innerHTML = '';
      body.classList.add('wd-body');
      const wrap = h('div', 'wd-wrap');

      // ----- trái: nhân vật + ô trang bị xung quanh -----
      const left = h('div', 'wd-left');
      const colL = h('div', 'wd-slot-col');
      const colR = h('div', 'wd-slot-col');
      SLOTS.forEach(([ico, name, z, key], i) => {
        if (mode === 'skin') return;                       // mục Skin không cần cột ô trang bị
        const cell = h('button', `wd-slot eq-${key} ${i === tab ? 'active' : ''}`);
        const cur = look[key];
        if (z === -1) {
          const sk = look.skin ? SKINS[look.skin] : undefined;
          if (sk) cell.append(skinFace(sk, 34)); else cell.append(uiIcon(ico, 28));
        } else if (cur) cell.append(z <= 20 || z === 70 ? chibiPreview(cur as number, 34) : chibiHead(cur as number, 34, z));
        else cell.classList.add('empty');            // ô trống dùng ảnh mờ sẵn của pack
        cell.append(h('span', 'wd-slot-name', name));
        cell.title = name;
        cell.onclick = () => { sfx.click(); tab = i; render(); };
        // chia đôi cho hai cột hai bên nhân vật
        (i < Math.ceil(SLOTS.length / 2) ? colL : colR).append(cell);
      });
      const mid = h('div', 'wd-char');
      mid.append(charFace(look, 200));
      const nameRow = h('div', 'wd-name-row');
      const lv = h('div', 'wd-lv'); lv.textContent = `${S.player.level}`;
      const nm = h('div', 'wd-name'); nm.textContent = S.player.name;
      nameRow.append(lv, nm);
      const body2 = h('div', 'wd-left-body');
      body2.append(colL, mid, colR);
      left.append(nameRow, body2);
      if (mode !== 'skin') {
        // dưới khung nhân vật là các thanh chỉ số (điểm cộng + điểm do quần áo)
        const eq = equipStats(look);
        const bars = h('div', 'wd-stats-box');
        const max = Math.max(10, ...STAT_KEYS.map(k => S.player.charStats[k] + eq[k]));
        for (const k of STAT_KEYS) {
          const base = S.player.charStats[k], bonus = eq[k];
          const row = h('div', 'wd-stat');
          row.append(h('span', 'wd-stat-nm', STAT_NAMES[k]));
          const bar = h('div', 'wd-stat-bar');
          const f1 = h('div', 'wd-stat-f'); f1.style.width = `${(base / max) * 100}%`;
          const f2 = h('div', 'wd-stat-f2'); f2.style.width = `${(bonus / max) * 100}%`;
          bar.append(f1, f2);
          row.append(bar);
          row.append(h('span', 'wd-stat-n', bonus ? `${base}+${bonus}` : `${base}`));
          row.title = `${STAT_NAMES[k]}: ${base} gốc${bonus ? ` + ${bonus} từ quần áo` : ''}`;
          bars.append(row);
        }
        left.append(bars);
      }

      // ----- phải: chia tab + card lưới ô (có cả ô trống như tủ đồ game) -----
      const right = h('div', 'wd-right');
      if (SLOTS.length > 1) {
        // dải chip icon kiểu Cozy UI Pack: chọn cái nào thì có khung góc bao quanh
        const tabBar = h('div', 'wd-chips');
        SLOTS.forEach(([, name2, , key2], i) => {
          const t = h('button', `wd-chip ${i === tab ? 'on' : ''}`);
          const ic = document.createElement('img');
          ic.src = `assets/ui/inv/ic_${key2 === 'pant' ? 'pants' : key2}.png`;
          ic.alt = name2;
          t.append(ic);
          t.title = name2;
          t.onclick = () => { sfx.click(); tab = i; render(); };
          tabBar.append(t);
        });
        right.append(tabBar);
      }

      const [, , z, key, optional] = SLOTS[tab];
      const card = h('div', 'wd-card');
      const grid = h('div', 'wd-grid');

      // ----- ô Skin: chọn trọn bộ đã sở hữu -----
      if (z === -1) {
        grid.className = 'wd-grid skin-grid';
        // hiện toàn bộ skin hệ thống có; bộ chưa sở hữu để xám
        for (const sk of SKIN_LIST) {
          const owned = S.skins.includes(sk.id);
          const on = look.skin === sk.id;
          const cell2 = h('button', `skin-card ${on ? 'active' : ''} ${owned ? '' : 'locked'}`);
          const art = h('div', 'skin-art'); art.append(skinFace(sk, 96));
          cell2.append(art, h('div', 'nm', sk.name));
          if (on) cell2.append(h('div', 'skin-on', 'Đang mặc'));
          else if (!owned) cell2.append(h('div', 'skin-lock', 'Chưa có'));
          cell2.onclick = () => {
            sfx.click();
            if (!owned) { toast(`${sk.name} chưa sở hữu — mua ở tab Skin của Thời trang Cô Trang.`, 'shop'); return; }
            look.skin = on ? undefined : sk.id; apply(); render();
          };
          grid.append(cell2);
        }
        card.append(grid);
        right.append(h('div', 'hint', S.skins.length ? 'Mặc skin sẽ thay toàn bộ trang phục — bấm lại bộ đang mặc để cởi ra.' : 'Chưa có skin nào — mua trọn bộ ở tab Skin của Thời trang Cô Trang!'));
        right.append(card);
        wrap.append(left, right);
        body.append(wrap);
        return;
      }
      const pk = key as Exclude<SlotKey, 'skin'>;
      const cur = (look as any)[pk] as number;
      // đồ cầm tay là vật phẩm trong túi, các loại còn lại nằm trong tủ quần áo
      const ownedOf = (pid: number) => pk === 'hand'
        ? itemCount(handItemId(pid)) > 0 : S.chibiWardrobe.includes(pid);
      const owned = chibiList(z, look.gender).filter(p => ownedOf(p.id) || p.id === cur);
      let cells = 0;
      for (const p of owned) {
        const on = cur === p.id;
        const cell = h('button', `wd-item ${on ? 'active' : ''}`);
        const box = h('div', 'wd-item-box');
        box.append(z <= 20 || z === 70 ? chibiPreview(p.id, 44) : chibiHead(p.id, 40, z));
        cell.append(box);
        cell.title = p.name;
        cell.onclick = () => { (look as any)[pk] = on && optional ? 0 : p.id; apply(); render(); };
        grid.append(cell); cells++;
      }
      // lấp cho đủ sức chứa tủ đồ, ô trống để trống
      for (let i = cells; i < WD_CAP; i++) {
        const e = h('div', 'wd-item wd-empty'); e.append(h('div', 'wd-item-box')); grid.append(e);
      }
      card.append(grid);
      const wearing = owned.find(p2 => p2.id === cur);
      right.append(h('div', 'wd-note', !owned.length
        ? 'Chưa có món nào — ghé shop thời trang ở Khu mua sắm!'
        : wearing ? `Đang mặc: ${wearing.name}${optional ? ' — bấm lại để cởi' : ''}`
                  : `Đang có ${owned.length} món, bấm để mặc`));
      right.append(card);

      wrap.append(left, right);
      body.append(wrap);
    };
    render();
  }


  function colorSwatches(n: number, active: number, onPick: (i: number) => void, names?: string[]): HTMLElement {
    const HAIR_HEX = ['#2b2b2b', '#e6c25a', '#8a5a33', '#c49a6c', '#b3592e', '#2e8b6f', '#4caf50', '#9aa5b1', '#c6a3e0', '#2c3e70', '#f7a3c2', '#8e44ad', '#c0392b', '#39c2c9'];
    const wrap = h('div', 'swatches');
    wrap.style.marginTop = '5px';
    for (let i = 0; i < n; i++) {
      const s = h('div', `sw ${active === i ? 'active' : ''}`);
      s.style.background = HAIR_HEX[i % HAIR_HEX.length];
      s.title = names?.[i] ?? `Màu ${i + 1}`;
      s.onclick = () => { onPick(i); wrap.querySelectorAll('.sw').forEach(x => x.classList.remove('active')); s.classList.add('active'); };
      wrap.append(s);
    }
    return wrap;
  }

  // ================= Bản đồ thế giới (ảnh world map Avatar, bấm để di chuyển) =================
  // vị trí các khu trên ảnh minimap (%) — khớp với ảnh minimap.png
  const MAP_POS: Record<string, { x: number; y: number }> = {
    house: { x: 10, y: 8 },       // khu nhà mái đỏ góc trái trên
    school: { x: 33, y: 12 },     // dãy nhà trường trên giữa
    beach: { x: 56, y: 9 },       // hồ lớn phía trên phải
    town: { x: 44, y: 30 },       // khu phố trung tâm
    gamecenter: { x: 48, y: 42 }, // cao ốc trung tâm
    mall: { x: 66, y: 34 },       // khu thương mại bên phải
    park: { x: 26, y: 48 },       // công viên đài phun nước bên trái
    pond: { x: 82, y: 88 },       // hồ nhỏ góc dưới phải
    farm: { x: 56, y: 80 }        // đồng ruộng dưới giữa
  };

  registerPanel('map', () => {
    const { body, win, close } = openWindow('Bản đồ thế giới', { size: 'large' });
    win.classList.add('win-map');
    const wrap = h('div', 'map-wrap');
    const inner = h('div', 'map-inner');
    const img = document.createElement('img');
    img.src = 'assets/lttt/minimap.png';
    img.draggable = false;
    inner.append(img);

    // marker các khu
    const hereId = S.zone;
    for (const z of ZONE_LIST) {
      const pos = MAP_POS[z.id];
      if (!pos) continue;
      const m = h('div', `map-marker ${hereId === z.id ? 'here' : ''}`);
      m.style.left = pos.x + '%';
      m.style.top = pos.y + '%';
      m.innerHTML = `<div class="sign"><img src="assets/ui/act/zone_${z.id}.png"></div><div class="tag"></div>`;
      (m.querySelector('.tag') as HTMLElement).textContent = z.name;
      m.onclick = () => {
        sfx.click();
        close();
        const w = worldScene();
        if (w?.travel) w.travel(z.id);
      };
      inner.append(m);
    }
    wrap.append(inner);
    body.append(wrap);

    // drag/pan + pinch zoom
    let scale = 1, tx = 0, ty = 0;
    let dragging = false, startX = 0, startY = 0, startTx = 0, startTy = 0;
    let initDist = 0, initScale = 1;
    const clamp = () => {
      const maxT = Math.max(0, (scale - 1) * 50);
      tx = Math.max(-maxT, Math.min(maxT, tx));
      ty = Math.max(-maxT, Math.min(maxT, ty));
    };
    const apply = () => { clamp(); inner.style.transform = `translate(${tx}%, ${ty}%) scale(${scale})`; };

    wrap.addEventListener('pointerdown', e => {
      if ((e.target as HTMLElement).closest('.map-marker')) return;
      dragging = true; startX = e.clientX; startY = e.clientY; startTx = tx; startTy = ty;
      wrap.setPointerCapture(e.pointerId);
    });
    wrap.addEventListener('pointermove', e => {
      if (!dragging) return;
      const dx = (e.clientX - startX) / wrap.clientWidth * 100;
      const dy = (e.clientY - startY) / wrap.clientHeight * 100;
      tx = startTx + dx; ty = startTy + dy; apply();
    });
    wrap.addEventListener('pointerup', () => { dragging = false; });
    wrap.addEventListener('pointercancel', () => { dragging = false; });

    wrap.addEventListener('touchstart', e => {
      if (e.touches.length === 2) {
        const d = Math.hypot(e.touches[0].clientX - e.touches[1].clientX, e.touches[0].clientY - e.touches[1].clientY);
        initDist = d; initScale = scale;
      }
    }, { passive: true });
    wrap.addEventListener('touchmove', e => {
      if (e.touches.length === 2) {
        const d = Math.hypot(e.touches[0].clientX - e.touches[1].clientX, e.touches[0].clientY - e.touches[1].clientY);
        scale = Math.max(1, Math.min(3, initScale * (d / initDist)));
        apply();
      }
    }, { passive: true });

    wrap.addEventListener('wheel', e => {
      e.preventDefault();
      scale = Math.max(1, Math.min(3, scale - e.deltaY * 0.002));
      apply();
    }, { passive: false });
  });

  // ================= Bạn bè =================
  registerPanel('social', () => {
    const { body, tabs } = openWindow('Bạn bè');
    let tab = 0;
    const render = () => {
      body.innerHTML = '';
      if (tab === 0) {
        if (!S.social.friends.length) body.append(h('div', 'hint', 'Chưa có bạn — qua tab Gợi ý để kết bạn!'));
        for (const f of S.social.friends) {
          const r = h('div', 'row');
          r.innerHTML = `<div class="onl ${f.online ? 'on' : ''}"></div><div class="grow"><div class="t1"></div><div class="t2">Lv.${f.level}${f.npc ? ' · NPC' : ''}</div></div>`;
          (r.querySelector('.t1') as HTMLElement).textContent = f.name;
          r.append(
            iconBtn('chat', 'Nhắn tin', 'mini blue', () => openPanel('chat', { to: f.name })),
            iconBtn('gift', 'Tặng quà', 'mini gold', () => pickGiftFor(f.id)),
            iconBtn('house', 'Mời ghé nhà', 'mini', () => toast(`${f.name} mời bạn ghé nhà chơi khi nào rảnh nha!`, 'house')),
            iconBtn('close', 'Chặn', 'mini red', () => { blockPlayer(f.id, f.name); render(); }),
            iconBtn('alert', 'Báo cáo', 'mini red', () => reportPlayer(f.id, f.name)),
            iconBtn('close', 'Xoá bạn', 'mini red', () => { removeFriend(f.id); render(); })
          );
          body.append(r);
        }
      } else {
        const sug = suggestedFriends();
        if (!sug.length) body.append(h('div', 'hint', 'Hết người để gợi ý rồi!'));
        for (const f of sug) {
          const r = h('div', 'row');
          r.innerHTML = `<img class="ico-img" src="assets/ui/av/person.png"><div class="grow"><div class="t1"></div><div class="t2">Lv.${f.level}</div></div>`;
          (r.querySelector('.t1') as HTMLElement).textContent = f.name;
          r.append(btn('Kết bạn', 'gold', () => { addFriend(f); render(); }));
          body.append(r);
        }
      }
    };
    tabs(['Bạn bè', 'Gợi ý'], i => { tab = i; render(); });
    render();
  });

  function pickGiftFor(friendId: string) {
    const { body, close } = openWindow('Chọn quà', { size: 'small' });
    const giftable = Object.entries(S.inventory).filter(([id]) => ['gift', 'crop', 'food'].includes(item(id).kind));
    if (!giftable.length) body.append(h('div', 'hint', 'Không có gì để tặng — mua quà ở Tiệm quà (Khu mua sắm).'));
    const grid = h('div', 'grid');
    for (const [id, qty] of giftable) {
      const def = item(id);
      const cell = h('div', 'cell');
      cell.append(iconOf(def), h('div', 'nm', def.name), h('div', 'qty', `x${qty}`));
      cell.onclick = () => { giveGift(friendId, id); close(); };
      grid.append(cell);
    }
    body.append(grid);
  }

  // ================= Chat =================
  registerPanel('chat', (data?: { to?: string }) => {
    // Chat KHÔNG dùng khung gỗ chung như các popup khác — nó là bảng chat
    // tối, neo góc dưới trái để vẫn nhìn được thế giới phía sau. Tin nhắn vẽ
    // kiểu bong bóng có ảnh đại diện, tin của mình dạt sang phải.
    const mini = document.getElementById('chat-mini');
    if (mini) mini.style.visibility = 'hidden';
    const { body, win, close } = openWindow('', {
      size: 'small',
      onClose: () => { if (mini) mini.style.visibility = ''; }
    });
    win.classList.add('win-chat');
    (win.parentElement as HTMLElement)?.classList.add('chat-backdrop');
    win.querySelector('.win-head')?.remove();

    let channel: 'public' | 'area' | 'private' = data?.to ? 'private' : 'public';
    let privateTo = data?.to ?? S.social.friends[0]?.name ?? '';

    // ----- đầu bảng -----
    const head = h('div', 'cw-head');
    const hAva = h('div', 'cw-head-ava'); hAva.append(avatarEl(30));
    const hTxt = h('div', 'grow');
    hTxt.append(h('div', 'cw-head-name', S.player.name || 'Bạn'));
    const online = 1 + S.social.friends.filter(f => f.online).length;
    hTxt.append(h('div', 'cw-head-sub', `${online} người đang trực tuyến`));
    const closeX = h('button', 'cw-x', '✕');
    closeX.onclick = close;
    head.append(hAva, hTxt, closeX);

    // ----- kênh -----
    const chanBar = h('div', 'cw-tabs');
    const chans: ['public' | 'area' | 'private', string][] =
      [['public', 'Tổng'], ['area', 'Gần'], ['private', 'Riêng']];

    // ----- chọn người nhận khi chat riêng -----
    const toBar = h('div', 'cw-to');
    const renderTo = () => {
      toBar.innerHTML = '';
      toBar.style.display = channel === 'private' ? '' : 'none';
      if (channel !== 'private') return;
      const list = S.social.friends;
      if (!list.length) { toBar.append(h('div', 'cw-to-empty', 'Chưa có bạn nào — kết bạn ở mục Bạn bè.')); return; }
      for (const f of list) {
        const c = h('button', `cw-chip ${privateTo === f.name ? 'on' : ''}`);
        c.append(nameAva(f.name, 20), h('span', '', f.name));
        if (f.online) c.append(h('span', 'cw-dot'));
        c.onclick = () => { sfx.click(); privateTo = f.name; renderTo(); renderLog(); };
        toBar.append(c);
      }
    };

    // ảnh đại diện người khác: vòng tròn chữ cái đầu, màu suy ra từ tên
    function nameAva(name: string, size = 30): HTMLElement {
      const d = h('div', 'cw-ava');
      let hsh = 0;
      for (let i = 0; i < name.length; i++) hsh = (hsh * 131 + name.charCodeAt(i) * 977) % 100000;
      // tên hai chữ thì lấy 2 chữ cái đầu cho khỏi trùng (Cô Mai / Chú Hùng)
      const parts = name.trim().split(/\s+/);
      const ini = (parts.length > 1 ? parts[0][0] + parts[parts.length - 1][0] : parts[0].slice(0, 2));
      d.style.cssText = `width:${size}px;height:${size}px;font-size:${Math.round(size * 0.38)}px;`
        + `background:hsl(${hsh % 360} 55% ${38 + (hsh >> 3) % 14}%);`;
      d.textContent = ini.toUpperCase();
      return d;
    }

    const log = h('div', 'cw-log');
    const hhmm = (t: number) => new Date(t).toLocaleTimeString('vi', { hour: '2-digit', minute: '2-digit' });

    const voiceBtn = (m: { voice?: string; dur?: number }) => {
      const play = h('button', 'cw-voice');
      play.append(h('span', 'cw-voice-ico'), h('span', 'cw-voice-wave'), h('span', '', `${m.dur ?? 0}"`));
      let au: HTMLAudioElement | undefined;
      play.onclick = () => {
        if (au && !au.paused) { au.pause(); au.currentTime = 0; play.classList.remove('playing'); return; }
        au = new Audio(m.voice);
        play.classList.add('playing');
        au.onended = () => play.classList.remove('playing');
        void au.play().catch(() => play.classList.remove('playing'));
      };
      return play;
    };

    const renderLog = () => {
      log.innerHTML = '';
      const list = getChatLog().filter(m =>
        m.channel === 'system' ||
        (channel === 'private'
          ? m.channel === 'private' && (m.from === privateTo || m.to === privateTo || m.from === S.player.name)
          : m.channel === channel));
      if (!list.length) {
        log.append(h('div', 'cw-empty', channel === 'private' && !privateTo
          ? 'Chọn một người bạn để nhắn riêng.' : 'Chưa có tin nhắn nào — nói gì đó đi!'));
        return;
      }
      let lastFrom = '';
      for (const m of list) {
        if (m.channel === 'system') {
          log.append(h('div', 'cw-sys', m.text));
          lastFrom = '';
          continue;
        }
        const mine = m.from === S.player.name;
        const row = h('div', `cw-row ${mine ? 'me' : ''}`);
        const same = m.from === lastFrom;                    // gộp tin liên tiếp cùng người
        if (same) row.classList.add('cont');
        const avaSlot = h('div', 'cw-ava-slot');
        if (!same) avaSlot.append(mine ? avatarEl(30) : nameAva(m.from, 30));
        const col = h('div', 'cw-col');
        if (!same && !mine) col.append(h('div', 'cw-name', m.from));
        const bubble = h('div', `cw-bubble ch-${m.channel}`);
        if (m.voice) bubble.append(voiceBtn(m)); else bubble.append(h('span', '', m.text));
        bubble.append(h('span', 'cw-t', hhmm(m.at)));
        col.append(bubble);
        row.append(avaSlot, col);
        log.append(row);
        lastFrom = m.from;
      }
      log.scrollTop = log.scrollHeight;
    };

    for (const [id, lbl] of chans) {
      const c = h('button', `cw-tab ${channel === id ? 'active' : ''}`, lbl);
      c.onclick = () => {
        sfx.click();
        channel = id;
        chanBar.querySelectorAll('.cw-tab').forEach(x => x.classList.remove('active'));
        c.classList.add('active');
        renderTo(); renderLog();
      };
      chanBar.append(c);
    }

    // ----- ô nhập -----
    const inputBar = h('div', 'cw-input-row');
    const inp = h('input', 'cw-input') as HTMLInputElement;
    inp.placeholder = 'Nhập tin nhắn...';
    inp.maxLength = 120;
    const sendBtn = h('button', 'cw-send');
    sendBtn.innerHTML = '<svg viewBox="0 0 24 24" width="18" height="18" aria-hidden="true">'
      + '<path d="M4 12h13M11 6l6 6-6 6" fill="none" stroke="#3a2a10" stroke-width="3"'
      + ' stroke-linecap="round" stroke-linejoin="round"/></svg>';
    sendBtn.title = 'Gửi';
    const doSend = () => {
      const text = inp.value.trim();
      if (!text) return;
      if (channel === 'private' && !privateTo) { toast('Chọn người nhận đã nhé.', 'alert'); return; }
      sendChat(channel, text, channel === 'private' ? privateTo : undefined);
      // nói Tổng/Gần thì hiện bong bóng trên đầu nhân vật
      if (channel !== 'private') bus.emit('world:say', text);
      inp.value = '';
      renderLog();
    };
    sendBtn.onclick = doSend;
    inp.onkeydown = e => { if (e.key === 'Enter') doSend(); e.stopPropagation(); };

    // ----- tin nhắn thoại -----
    // Game chưa có server nên tin thoại chỉ nằm ở máy mình, không gửi được
    // sang người chơi khác; ghi bằng MediaRecorder, giới hạn 15 giây.
    const micBtn = h('button', 'cw-mic');
    micBtn.innerHTML = '<svg viewBox="0 0 24 24" width="17" height="17" aria-hidden="true">'
      + '<rect x="9" y="3" width="6" height="11" rx="3" fill="currentColor"/>'
      + '<path d="M5 11a7 7 0 0 0 14 0M12 18v3" fill="none" stroke="currentColor"'
      + ' stroke-width="2" stroke-linecap="round"/></svg>';
    micBtn.title = 'Bấm để ghi âm';
    let rec: MediaRecorder | undefined;
    let recTimer = 0, startedAt = 0, tick = 0;
    const recLabel = h('div', 'cw-rec');

    const stopRec = () => {
      if (rec && rec.state === 'recording') rec.stop();
      window.clearTimeout(recTimer);
      window.clearInterval(tick);
      recLabel.classList.remove('on');
    };
    const startRec = async () => {
      if (!navigator.mediaDevices?.getUserMedia || typeof MediaRecorder === 'undefined') {
        toast('Thiết bị không hỗ trợ ghi âm.', 'alert'); return;
      }
      try {
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
        const chunks: Blob[] = [];
        rec = new MediaRecorder(stream);
        startedAt = Date.now();
        rec.ondataavailable = e => { if (e.data.size) chunks.push(e.data); };
        rec.onstop = () => {
          stream.getTracks().forEach(t => t.stop());
          micBtn.classList.remove('rec');
          const dur = Math.max(1, Math.round((Date.now() - startedAt) / 1000));
          const blob = new Blob(chunks, { type: rec?.mimeType || 'audio/webm' });
          const fr = new FileReader();
          fr.onload = () => {
            sendVoice(channel, String(fr.result), dur, channel === 'private' ? privateTo : undefined);
            renderLog();
          };
          fr.readAsDataURL(blob);
        };
        rec.start();
        micBtn.classList.add('rec');
        recLabel.classList.add('on');
        tick = window.setInterval(() => {
          recLabel.textContent = `Đang ghi âm ${Math.round((Date.now() - startedAt) / 1000)}s — bấm lại để gửi`;
        }, 200);
        recTimer = window.setTimeout(stopRec, 15000);   // tự dừng sau 15s
      } catch {
        toast('Không truy cập được micro.', 'alert');
      }
    };
    micBtn.onclick = () => {
      if (rec && rec.state === 'recording') stopRec(); else void startRec();
    };

    inputBar.append(micBtn, inp, sendBtn);

    body.append(head, chanBar, toBar, log, recLabel, inputBar);
    renderTo();
    renderLog();
    setTimeout(() => inp.focus(), 50);
    bus.on(EV.CHAT, renderLog);
  });

  // ================= Thư =================
  registerPanel('mail', () => {
    const { body } = openWindow('Hộp thư');
    const render = () => {
      body.innerHTML = '';
      if (!S.mail.length) body.append(h('div', 'hint', 'Hộp thư trống.'));
      for (const m of S.mail) {
        const r = h('div', 'row');
        r.innerHTML = `<img class="ico-img" src="assets/ui/pack/icon_mail.png"${m.read ? ' style="opacity:.5"' : ''}>
          <div class="grow"><div class="t1"></div><div class="t2"></div><div class="t2" style="white-space:pre-wrap"></div></div>`;
        (r.querySelector('.t1') as HTMLElement).textContent = m.subject;
        (r.querySelectorAll('.t2')[0] as HTMLElement).textContent = `Từ: ${m.from} · ${new Date(m.at).toLocaleString('vi')}`;
        (r.querySelectorAll('.t2')[1] as HTMLElement).textContent = m.body;
        if (m.attachments && !m.claimed) {
          const a = m.attachments;
          const parts: string[] = [];
          if (a.coins) parts.push(priceHtml(a.coins));
          if (a.rubies) parts.push(priceHtml(0, a.rubies));
          if (a.itemId) parts.push(`${item(a.itemId).icon}x${a.qty ?? 1}`);
          const cb = btn('', 'gold', () => { claimMail(m.id); sfx.coin(); render(); });
          cb.innerHTML = `Nhận ${parts.join(' ')}`;
          r.append(cb);
        }
        if (!m.read) { m.read = true; save(); }
        body.append(r);
      }
      bus.emit(EV.STATE_CHANGED);
    };
    render();
  });

  // ================= Điểm danh / quà ngày =================
  registerPanel('daily', () => {
    const { body, tabs } = openWindow('Quà mỗi ngày');
    let tab = 0;
    const render = () => {
      body.innerHTML = '';
      if (tab === 0) {
        body.append(h('div', 't1', `Chuỗi đăng nhập: ${S.daily.streak} ngày`));
        const grid = h('div', 'grid');
        LOGIN_REWARDS.forEach((r, i) => {
          const idx = (Math.max(1, S.daily.streak) - 1) % LOGIN_REWARDS.length;
          const cell = h('div', `cell ${i === idx ? 'selected' : ''} ${i < idx || (i === idx && S.daily.loginClaimed) ? 'owned' : ''}`);
          cell.innerHTML = `<img class="ico-img" src="assets/ui/act/gift.png"><div class="nm">Ngày ${i + 1}</div><div class="pr">${rewardText(r)}</div>`;
          grid.append(cell);
        });
        body.append(grid);
        const b = btn('', 'gold', () => { claimLogin(); render(); });
        b.innerHTML = S.daily.loginClaimed ? 'Đã nhận hôm nay' : `Nhận quà: ${rewardText(loginRewardToday())}`;
        b.disabled = S.daily.loginClaimed;
        b.style.marginTop = '10px';
        body.append(b);
      } else if (tab === 1) {
        const today = new Date().getDate();
        body.append(h('div', 't1', `Điểm danh tháng này: ${S.daily.checkinDays.length} ngày`));
        const checked = S.daily.checkinDays.includes(today);
        const b = btn(checked ? 'Hôm nay đã điểm danh' : 'Điểm danh hôm nay (+100 xu)', 'gold', () => { checkinToday(); render(); });
        b.disabled = checked;
        body.append(b);
        body.append(h('div', 'sep'));
        for (const m of CHECKIN_MILESTONES) {
          const r = h('div', 'row');
          const got = S.daily.checkinDays.length >= m.days;
          r.innerHTML = `<img class="ico-img" src="assets/ui/pack/icon_${got ? 'check' : 'calendar'}.png"><div class="grow"><div class="t1">Mốc ${m.days} ngày</div><div class="t2">${rewardText(m.reward)}</div></div>`;
          r.style.opacity = got ? '1' : '.6';
          body.append(r);
        }
      } else {
        const evs = activeEvents();
        if (!evs.length) body.append(h('div', 'hint', 'Chưa có sự kiện nào trong tháng này.'));
        for (const e of evs) {
          const r = h('div', 'row');
          r.innerHTML = `<div class="grow"><div class="t1">${e.name}</div><div class="t2">${e.desc}</div></div><div class="t2">Đang diễn ra</div>`;
          r.prepend(uiIcon(e.icon, 26));
          body.append(r);
        }
        body.append(h('div', 'sep'));
        body.append(h('div', 'hint', 'Sự kiện cả năm: Tết · Valentine · Lễ hội biển · Trung Thu · Halloween · Noel · Sinh nhật game'));
      }
    };
    tabs(['Đăng nhập', 'Điểm danh', 'Sự kiện'], i => { tab = i; render(); });
    render();
  });

  // ================= Vòng quay =================
  registerPanel('wheel', () => {
    const { body } = openWindow('Vòng quay may mắn', { size: 'small' });
    const wrap = h('div', 'wheel-wrap');
    const size = 240;
    const cv = document.createElement('canvas');
    cv.width = size; cv.height = size; cv.id = 'wheel';
    const ctx = cv.getContext('2d')!;
    const colors = ['#5c8a2a', '#ffd43b', '#4dabf7', '#ff8787', '#b197fc', '#63e6be', '#ffa94d', '#f783ac'];
    const n = WHEEL.length;
    for (let i = 0; i < n; i++) {
      ctx.beginPath();
      ctx.moveTo(size / 2, size / 2);
      ctx.arc(size / 2, size / 2, size / 2 - 4, (i / n) * Math.PI * 2 - Math.PI / 2, ((i + 1) / n) * Math.PI * 2 - Math.PI / 2);
      ctx.fillStyle = colors[i % colors.length];
      ctx.fill();
      ctx.save();
      ctx.translate(size / 2, size / 2);
      ctx.rotate((i + 0.5) / n * Math.PI * 2 - Math.PI / 2);
      // icon phần thưởng: ảnh thật, vẽ khi tải xong
      const im = new Image();
      im.src = iconUrl(WHEEL[i].icon);
      const ang = (i + 0.5) / n * Math.PI * 2 - Math.PI / 2;
      im.onload = () => {
        ctx.save();
        ctx.translate(size / 2, size / 2);
        ctx.rotate(ang);
        ctx.imageSmoothingEnabled = false;
        const k = 22 / Math.max(im.width, im.height);
        ctx.drawImage(im, size / 2 - 30 - im.width * k / 2, -im.height * k / 2, im.width * k, im.height * k);
        ctx.restore();
      };
      ctx.restore();
    }
    const pointer = h('div', 'wheel-pointer');
    pointer.style.cssText = 'margin-bottom:-6px;z-index:2';
    const info = h('div', 'hint', `Lượt còn lại: ${wheelSpinsLeft()} (1 free/ngày, thêm bằng vé)`);
    let spinning = false;
    const spinBtn = btn('QUAY!', 'gold', () => {
      if (spinning) return;
      const res = spinWheel();
      if (!res) return;
      spinning = true;
      const target = 360 * 5 + (360 - (res.index + 0.5) / n * 360);
      cv.style.transform = `rotate(${target}deg)`;
      setTimeout(() => {
        grantWheel(res.index);
        spinning = false;
        cv.style.transition = 'none';
        cv.style.transform = `rotate(${target % 360}deg)`;
        setTimeout(() => { cv.style.transition = ''; }, 50);
        info.textContent = `Lượt còn lại: ${wheelSpinsLeft()}`;
      }, 4200);
    });
    wrap.append(pointer, cv, spinBtn, info);
    body.append(wrap);
  });

  // ================= Sưu tập =================
  registerPanel('collections', () => {
    const { body, tabs } = openWindow('Bộ sưu tập', { size: 'large' });
    let tab = 0;
    const render = () => {
      body.innerHTML = '';
      const grid = h('div', 'grid');
      if (tab === 0) {
        body.append(h('div', 't2', `Đã sưu tập ${S.collections.fish.length}/${FISH_LIST.length} loài cá`));
        for (const f of FISH_LIST) {
          const got = S.collections.fish.includes(f.id);
          const cell = h('div', `cell ${got ? '' : 'locked'}`);
          cell.append(iconOf(item(f.id)), h('div', 'nm', got ? f.name : '???'));
          const pr = h('div', 'pr', RARITY_NAME[f.rarity]);
          pr.style.color = RARITY_COLOR[f.rarity];
          cell.append(pr);
          grid.append(cell);
        }
      } else {
        body.append(h('div', 't2', `Đã trồng ${S.collections.crops.length}/${CROP_LIST.length} loại cây`));
        for (const c of CROP_LIST) {
          const got = S.collections.crops.includes(c.id);
          const cell = h('div', `cell ${got ? '' : 'locked'}`);
          cell.append(iconOf(item(`crop_${c.id}`)), h('div', 'nm', got ? c.name : '???'));
          grid.append(cell);
        }
      }
      body.append(grid);
    };
    tabs(['Cá', 'Nông sản'], i => { tab = i; render(); });
    render();
  });

  // ================= Xếp hạng =================
  registerPanel('ranking', () => {
    const { body } = openWindow('Bảng xếp hạng', { size: 'small' });
    leaderboard().forEach((r, i) => {
      const row = h('div', 'row');
      if (r.me) row.style.borderLeft = '4px solid #ffd43b';
      row.innerHTML = `<div class="rk-no">${i + 1}</div>
        <div class="grow"><div class="t1"></div></div><div class="t2">Lv.${r.level} · <img class="cur" src="assets/ui/pack/icon_coin.png">${fmt(r.coins)}</div>`;
      (row.querySelector('.t1') as HTMLElement).textContent = r.name + (r.me ? ' (bạn)' : '');
      body.append(row);
    });
  });

  // ================= Biểu cảm =================
  registerPanel('emotes', () => {
    const { body, close } = openWindow('Biểu cảm', { size: 'small' });

    // dùng đúng sheet emoticons.png của asset pack (lưới 16px, 5 cột x 6 hàng)
    const grid = h('div', 'grid');
    for (let i = 0; i < 30; i++) {
      const cell = h('div', 'cell');
      cell.append(spr('assets/char/emoticons.png', (i % 5) * 16, Math.floor(i / 5) * 16, 16, 16, 36));
      cell.onclick = () => { bus.emit('world:emote', i); close(); };
      grid.append(cell);
    }
    body.append(grid);
  });


  // ================= Nạp (demo) =================
  registerPanel('topup', () => {
    const { body } = openWindow('Nạp Ruby', { size: 'small' });
    body.append(h('div', 'hint', 'Bản demo offline: nhận ruby ngay. Khi ra mắt sẽ nối cổng thanh toán (IAP/thẻ).'));
    const packs = [
      { rubies: 50, price: '20.000đ' },
      { rubies: 150, price: '50.000đ' },
      { rubies: 400, price: '100.000đ' },
      { rubies: 1000, price: '200.000đ' }
    ];
    for (const p of packs) {
      const r = h('div', 'row');
      r.innerHTML = `<img class="ico-img" src="assets/ui/pack/icon_ruby.png"><div class="grow"><div class="t1">${p.rubies} Ruby</div><div class="t2">${p.price}</div></div>`;
      r.append(btn('Nhận (demo)', 'gold', () => { addRubies(p.rubies); toast(`+${p.rubies} ruby!`, 'ruby'); sfx.coin(); }));
      body.append(r);
    }
  });

  // ================= Cài đặt =================
  registerPanel('settings', () => {
    const { body } = openWindow('Cài đặt', { size: 'small' });
    const mkToggle = (label: string, get: () => boolean, set: (v: boolean) => void) => {
      const r = h('div', 'row');
      r.innerHTML = `<div class="grow t1">${label}</div>`;
      const b = btn(get() ? 'BẬT' : 'TẮT', get() ? 'gold' : '', () => {
        set(!get()); save();
        b.textContent = get() ? 'BẬT' : 'TẮT';
        b.className = `btn ${get() ? 'gold' : ''}`;
      });
      r.append(b);
      body.append(r);
    };
    mkToggle('Nhạc nền', () => S.settings.music, v => { S.settings.music = v; v ? startBgm() : stopBgm(); });
    mkToggle('Hiệu ứng âm thanh', () => S.settings.sfx, v => { S.settings.sfx = v; });
    body.append(h('div', 'sep'));
    body.append(btn('Toàn màn hình', 'blue', () => {
      if (document.fullscreenElement) document.exitFullscreen();
      else document.documentElement.requestFullscreen?.();
    }));
    const del = btn('Xóa save & chơi lại từ đầu', 'red', () => {
      if (confirm('Chắc chắn xóa toàn bộ dữ liệu chơi?')) {
        resetSave();
        location.reload();
      }
    });
    del.style.marginTop = '8px';
    body.append(del);
    body.append(h('div', 'hint', 'Sunny Town v0.1 — làm bằng Phaser 3 + TypeScript'));
  });
}
