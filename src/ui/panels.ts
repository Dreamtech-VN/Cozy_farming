import { registerPanel, openPanel, getGame, refreshHotbar } from './UIManager';
import { h, openWindow, btn, fmt, iconOf, spr, chibiPreview, chibiHead, charFace, uiIcon, priceHtml, priceBtn, iconUrl } from './kit';
import { S, save, spend, addRubies, addItem, removeItem, itemCount, addStat, resetSave, equipTool, toolLevel, equipHandItem, unequipTool } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { ITEMS, item } from '@/data/items';
import { CROPS, CROP_LIST } from '@/data/crops';
import { ANIMAL_LIST } from '@/data/animals';
import { FISH_LIST, RODS, RARITY_COLOR, RARITY_NAME, FISHES } from '@/data/fish';
import { INSECT_LIST, NETS, INSECTS } from '@/data/insects';
import { chibiList, chibiPriceXu, chibiPriceRuby, CHIBI_PARTS } from '@/data/chibi';
import { handItemId } from '@/data/handitems';
import { SKIN_LIST, SKINS, type SkinDef } from '@/data/skins';
import { FURNITURE, FURNITURE_LIST, HOUSE_LEVELS, WALLPAPERS, FLOORS } from '@/data/furniture';
import { SHOPS } from '@/data/shops';
import { QUESTS, TITLES, ACHIEVEMENTS } from '@/data/quests';
import { ZONE_LIST, ZONES } from '@/data/zones';
import { WHEEL, LOGIN_REWARDS, CHECKIN_MILESTONES, activeEvents } from '@/data/meta';
import { VEHICLES } from '@/data/vehicles';
import { TOOL_LIST, TOOLS, toolUpgradeAt, toolIconSize } from '@/data/tools';
import { PET_LIST, PETS, ownsPet, petBonus, petUrl } from '@/data/pets';
import * as farming from '@/systems/farming';
import * as livestock from '@/systems/livestock';
import { buyRod, addToAquarium } from '@/systems/fishing';
import { claimQuest, activeQuestList, grantReward } from '@/systems/quests';
import { suggestedFriends, addFriend, removeFriend, blockPlayer, reportPlayer, giveGift, sendChat, getChatLog, claimMail, leaderboard, affinityOf, addAffinity, affinityLabel } from '@/systems/social';
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
    const KIND_ORDER = ['tool', 'seed', 'crop', 'product', 'food', 'fish', 'insect', 'material', 'furniture', 'deco', 'gift', 'special'];
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
    ['Trang bị', k => k === 'tool' || k === 'hand'],
    ['Nông sản', k => ['crop', 'seed', 'product'].includes(k)],
    ['Cá & Côn trùng', k => ['fish', 'insect'].includes(k)],
    ['Nội thất', k => ['furniture', 'deco'].includes(k)],
    ['Khác', k => ['gift', 'material', 'food', 'special'].includes(k)]
  ];

  // Nông cụ & đồ cầm tay cũng nằm trong túi (kind ảo 'tool' / 'hand')
  interface BagEntry { kind: string; name: string; qty: number; node: () => HTMLElement; equipped: boolean; onClick: () => void }

  function bagEntries(close: () => void): BagEntry[] {
    const out: BagEntry[] = [];
    for (const t of TOOL_LIST) {
      if (toolLevel(t.id) <= 0) continue;
      const on = S.hotbar.includes(t.id);
      out.push({
        kind: 'tool', name: t.name, qty: 0, equipped: on,
        node: () => { const d = h('div'); d.append(spr(t.url, 0, 0, t.w, t.h, toolIconSize(t, 66))); return d; },
        onClick: () => {
          if (on) unequipTool(S.hotbar.indexOf(t.id));
          else equipTool(t.id);
        }
      });
    }
    for (const [id, qty] of Object.entries(S.inventory)) {
      const def = item(id);
      const hand = def.meta?.handPart ? Number(def.meta.handPart) : 0;
      out.push({
        kind: hand ? 'hand' : def.kind, name: def.name, qty, equipped: hand ? S.hotbar.includes(`hand:${hand}`) : false,
        node: () => hand ? chibiPreview(hand, 66) : iconOf(def, 62),
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
        if (e.equipped) c.append(h('div', 'bag-on', 'Đang gắn'));
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
    if (def.meta?.handPart) {
      acts.push({
        icon: '', ui: 'candy', label: 'Dùng (đưa xuống ô trang bị)',
        cb: () => { equipHandItem(Number(def.meta!.handPart)); }
      });
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
      const qty = itemCount(`seed_${c.id}`);
      if (qty <= 0) continue;
      has = true;
      const cell = h('div', 'cell');
      cell.append(iconOf(item(`seed_${c.id}`)), h('div', 'nm', c.name), h('div', 'qty', `x${qty}`), h('div', 'pr', `${c.growMin} phút`));
      cell.onclick = () => { farming.plant(data.plot, c.id); close(); };
      grid.append(cell);
    }
    if (!has) {
      body.append(h('div', 'hint', 'Bạn không có hạt giống nào. Mua ở tiệm Cô Mai (Nông trại) nhé!'));
      body.append(btn('Mở tiệm hạt giống', 'gold', () => { close(); openPanel('shop', { shopId: 'shop_seed' }); }));
    }
    body.append(grid);
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
          priceEl.innerHTML = priceHtml(def.rubyBuy ? 0 : (def.buy ?? 0), def.rubyBuy);
          cell.append(iconOf(def), h('div', 'nm', def.name), priceEl);
          cell.onclick = () => {
            if (def.rubyBuy ? spend(0, def.rubyBuy) : spend(def.buy ?? 0)) {
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
      } else {
        for (const net of NETS) {
          const r = h('div', 'row');
          const owned = S.tools.net >= net.tier;
          const ic = h('div');
          ic.append(spr(TOOLS.net.url, 0, 0, TOOLS.net.w, TOOLS.net.h, 34));
          r.append(ic);
          const info = h('div', 'grow');
          info.innerHTML = `<div class="t1">${net.name}</div><div class="t2">Bắt côn trùng</div>`;
          r.append(info);
          r.append(owned ? btn('Đã có', '', undefined) : priceBtn(net.price, 'gold', () => {
            if (spend(net.price)) { S.tools.net = net.tier; save(); toast(`Đã mua ${net.name}!`, 'net'); equipTool('net'); render(); }
          }));
          body.append(r);
        }
      }
    };
    tabs(['Cần câu', 'Mồi câu', 'Vợt'], i => { tab = i; render(); });
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
          else prEl.innerHTML = sk.priceRuby > 0 ? priceHtml(0, sk.priceRuby) : priceHtml(sk.priceXu);
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
        const xu = chibiPriceXu(p), ruby = chibiPriceRuby(p);
        const prEl = h('div', 'pr');
        if (owned && !isHand) prEl.textContent = 'Đã có';
        else prEl.innerHTML = ruby > 0 ? priceHtml(0, ruby) : priceHtml(xu);
        const art = h('div', 'cell-art');
        art.append(chibiPreview(p.id, 74));
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
    const { body } = openWindow(cfg.title, { size: 'large' });
    const render = () => {
      body.innerHTML = '';
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
        const xu = chibiPriceXu(p), ruby = chibiPriceRuby(p);
        const pr = h('div', 'pr');
        if (on) pr.textContent = 'Đang dùng';
        else if (done) pr.textContent = 'Đổi lại';
        else pr.innerHTML = ruby > 0 ? priceHtml(0, ruby) : priceHtml(xu);
        cell.append(pr);
        cell.onclick = () => {
          sfx.click();
          if (!on && !done) {
            if (ruby > 0) { if (!spend(0, ruby)) return; }
            else if (!spend(xu)) return;
            S.chibiWardrobe.push(p.id);
            sfx.coin();
          }
          look[cfg.key] = p.id;
          save(); bus.emit(EV.APPEARANCE);
          toast(cfg.key === 'hair' ? `Đã đổi kiểu tóc: ${p.name}` : `Đã đổi ${partLabel(40, p.name).toLowerCase()}`, 'wardrobe');
          render();
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
      : `Trọn bộ • Giá: ${sk.priceRuby > 0 ? priceHtml(0, sk.priceRuby) : priceHtml(sk.priceXu)}`;
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
      const ok = sk.priceRuby > 0 ? spend(0, sk.priceRuby) : spend(sk.priceXu);
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
    const xu = chibiPriceXu(p), ruby = chibiPriceRuby(p);

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
    info.innerHTML = owned && !isHand
      ? '<b>Bạn đã sở hữu món này</b>'
      : `Giá: ${ruby > 0 ? priceHtml(0, ruby) : priceHtml(xu)}`;
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
        const ok = ruby > 0 ? spend(0, ruby) : spend(xu);
        if (!ok) return;
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
          const price = f.rubyPrice ? priceHtml(0, f.rubyPrice) : priceHtml(f.price);
          cell.innerHTML = `<div class="ico">${f.icon}</div><div class="nm"></div><div class="pr">${price}</div>`;
          (cell.querySelector('.nm') as HTMLElement).textContent = f.name;
          cell.onclick = () => {
            const ok = f.rubyPrice ? spend(0, f.rubyPrice) : spend(f.price);
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
  registerPanel('animalshop', () => {
    if (!atShopZone('animalshop', 'Cửa hàng vật nuôi')) return;
    const { body } = openWindow('Mua vật nuôi', { size: 'small' });
    body.append(h('div', 'hint', `Chuồng cấp ${S.livestock.barnLevel}: ${S.livestock.animals.length}/${livestock.barnCapacity()} con`));
    for (const a of ANIMAL_LIST) {
      const r = h('div', 'row');
      r.append(spr(`assets/animals/${a.sheet}`, 0, 0, a.frameW, a.frameH, 36));
      r.innerHTML += `<div class="grow"><div class="t1">${a.name}</div><div class="t2">Cho ra ${item(a.product).name} mỗi ${a.produceMin} phút sau khi ăn</div></div>`;
      r.append(priceBtn(a.price, 'gold', () => {
        if (livestock.buyAnimal(a.id)) worldScene()?.scene?.restart();
      }));
      body.append(r);
    }
  });

  // ================= Nhiệm vụ / Thành tựu =================
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
  const CH_SECTIONS: [string, string][] = [
    ['wardrobe', 'Tủ đồ'], ['skin', 'Skin'], ['title', 'Danh hiệu']
  ];

  function openCharHub(sec = 'wardrobe') {
    const { body, win } = openWindow('Tủ đồ', { size: 'large' });
    win.classList.add('win-bag');            // dùng chung kiểu khung + tab dán ngoài
    const titleEl = win.querySelector('.win-head > div') as HTMLElement;
    const draw = () => {
      // tiêu đề cửa sổ luôn là tên mục đang mở ở cột tab dọc
      titleEl.textContent = CH_SECTIONS.find(c => c[0] === sec)?.[1] ?? 'Tủ đồ';
      body.innerHTML = '';
      body.className = 'win-body ch-body';
      const wrap = h('div', 'ch-wrap');
      const main = h('div', 'ch-main');
      const side = h('div', 'ch-side');
      for (const [id, name] of CH_SECTIONS) {
        const t = h('button', `ch-tab ${sec === id ? 'active' : ''}`, name);
        t.onclick = () => { sfx.click(); sec = id; draw(); };
        side.append(t);
      }
      wrap.append(main, side);
      body.append(wrap);
      openCharHubRefresh = draw;
      if (sec === 'wardrobe') openWardrobe(main);
      else if (sec === 'skin') openWardrobe(main, 'skin');
      else renderTitles(main, draw);
    };
    draw();
  }

  function renderTitles(box: HTMLElement, redraw: () => void) {
    for (const id of Object.keys(TITLES)) {
      const owned = S.player.titles.includes(id);
      const r = h('div', 'row');
      r.style.opacity = owned ? '1' : '.5';
      const ic = h('div'); ic.append(uiIcon('rank', 24));
      const info = h('div', 'grow');
      info.innerHTML = `<div class="t1" style="color:${TITLES[id].color}">${TITLES[id].name}</div>`;
      r.append(ic, info);
      if (owned) r.append(S.player.title === id
        ? btn('Đang dùng', '', undefined)
        : btn('Dùng', 'gold', () => { S.player.title = id; save(); bus.emit(EV.STATE_CHANGED); redraw(); }));
      else r.append(h('div', 't2', 'Chưa mở'));
      box.append(r);
    }
  }

  let openCharHubRefresh: () => void = () => {};

  function renderCharInfo(body: HTMLElement) {
        const t = TITLES[S.player.title];
        const info = h('div');
        info.innerHTML = `
          <div class="row"><div id="pf-face"></div><div class="grow">
            <div class="t1" id="pf-name"></div>
            <div class="t2" style="color:${t?.color}">「${t?.name}」</div>
            <div class="t2">Cấp ${S.player.level} · ${S.player.exp}/${S.player.level * 100} EXP · ${S.player.gender === 'male' ? 'Nam' : 'Nữ'}</div>
          </div></div>
          <div class="progress"><div style="width:${Math.round(S.player.exp / (S.player.level * 100) * 100)}%"></div></div>`;
        (info.querySelector('#pf-name') as HTMLElement).textContent = S.player.name;
        (info.querySelector('#pf-face') as HTMLElement).append(charFace(S.player.chibi, 56));
        body.append(info);
        const statsBox = h('div');
        statsBox.style.cssText = 'display:grid;grid-template-columns:1fr 1fr;gap:6px;margin-top:10px';
        const rows: [string, number][] = [
          ['Thu hoạch', S.stats['harvested'] ?? 0],
          ['Cá đã câu', S.stats['fish_caught'] ?? 0],
          ['Côn trùng', S.stats['insects_caught'] ?? 0],
          ['Xu kiếm được', S.stats['coins_earned'] ?? 0],
          ['Thành tựu', S.achievements.length],
          ['Thắng minigame', (S.minigames.caroWins + S.minigames.xiangqiWins + S.minigames.rpsWins)]
        ];
        for (const [lbl, v] of rows) {
          const d = h('div', 'row');
          d.innerHTML = `<div class="grow t2">${lbl}</div><div class="t1">${fmt(v)}</div>`;
          statsBox.append(d);
        }
        body.append(statsBox);
  }

  registerPanel('profile', () => { const { body } = openWindow('Hồ sơ cá nhân'); renderCharInfo(body); });
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

  // ================= Chạm vào bản thân =================
  registerPanel('selfmenu', () => {
    const { body, close } = openWindow(`${S.player.name}`, { size: 'small' });
    const face = h('div');
    face.style.cssText = 'display:flex;justify-content:center;margin-bottom:6px';
    face.append(charFace(S.player.chibi, 84));
    body.append(face);

    const grid = h('div', 'wd-grid');
    const cell = (icon: string, label: string, cb: () => void) => {
      const c = h('button', 'wd-item');
      c.append(uiIcon(icon, 32), h('div', 'nm', label));
      c.onclick = () => { sfx.click(); cb(); };
      grid.append(c);
    };
    cell('inventory', 'Túi đồ', () => { close(); openPanel('inventory'); });
    cell('runner', 'Chạy', () => { close(); bus.emit('world:selfact', 'run'); });
    cell('sit', 'Ngồi', () => { close(); bus.emit('world:selfact', 'sit'); });
    cell('lie', 'Nằm', () => { close(); bus.emit('world:selfact', 'lie'); });
    cell('pet', 'Thú cưng', () => { close(); openPanel('petbag'); });
    cell('smile', 'Biểu cảm', () => { close(); openPanel('emotes'); });
    body.append(grid);
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
    // Tóc ở tiệm cắt tóc, mắt ở viện thẩm mỹ, đồ cầm tay nằm trong túi đồ
    // (gắn thẳng xuống thanh ô ngang) nên không nằm trong tủ đồ
    const ALL: [string, string, number, SlotKey, boolean][] = [
      ['hat', 'Mũ', 60, 'hat', true],
      ['glasses', 'Kính', 65, 'glasses', true],
      ['shirt', 'Áo', 20, 'shirt', false],
      ['pants', 'Quần', 10, 'pant', false]
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
        const cell = h('button', `wd-slot ${i === tab ? 'active' : ''}`);
        const cur = look[key];
        if (z === -1) {
          const sk = look.skin ? SKINS[look.skin] : undefined;
          if (sk) cell.append(skinFace(sk, 34)); else cell.append(uiIcon(ico, 28));
        } else if (cur) cell.append(z <= 20 || z === 70 ? chibiPreview(cur as number, 34) : chibiHead(cur as number, 34, z));
        else cell.append(uiIcon(ico, 28));
        cell.append(h('span', 'wd-slot-name', name));
        cell.onclick = () => { tab = i; render(); };
        // chia đôi cho hai cột hai bên nhân vật
        (i < Math.ceil(SLOTS.length / 2) ? colL : colR).append(cell);
      });
      const mid = h('div', 'wd-char');
      mid.append(charFace(look, 190));
      mid.append(h('div', 'wd-char-name', S.player.name));
      left.append(colL, mid, colR);

      // ----- phải: chia tab + card lưới ô (có cả ô trống như tủ đồ game) -----
      const right = h('div', 'wd-right');
      if (SLOTS.length > 1) {
        const tabBar = h('div', 'wd-tabs');
        SLOTS.forEach(([ic2, name2], i) => {
          const t = h('div', `tab ${i === tab ? 'active' : ''}`);
          t.append(uiIcon(ic2, 14), h('span', '', name2));
          t.onclick = () => { tab = i; render(); };
          tabBar.append(t);
        });
        right.append(tabBar);
      }

      const [, , z, key, optional] = SLOTS[tab];
      const card = h('div', 'wd-card');
      const grid = h('div', 'wd-grid');

      // ----- ô Skin: chọn trọn bộ đã sở hữu -----
      if (z === -1) {
        let n = 0;
        for (const sid of S.skins) {
          const sk = SKINS[sid];
          if (!sk) continue;
          const on = look.skin === sid;
          const cell2 = h('button', `wd-item ${on ? 'active' : ''}`);
          cell2.append(skinFace(sk, 46), h('div', 'nm', sk.name));
          // bấm lại món đang mặc = cởi ra (ô trống nghĩa là không dùng)
          cell2.onclick = () => { look.skin = on ? undefined : sid; apply(); render(); };
          grid.append(cell2); n++;
        }
        for (let i = n; i < WD_CAP; i++) grid.append(h('div', 'wd-item wd-empty'));
        card.append(grid);
        right.append(h('div', 'hint', S.skins.length ? 'Mặc skin sẽ thay toàn bộ trang phục — bấm lại bộ đang mặc để cởi ra.' : 'Chưa có skin nào — mua trọn bộ ở tab Skin của Thời trang Cô Trang!'));
        right.append(card);
        wrap.append(left, right);
        body.append(wrap);
        return;
      }
      const pk = key as Exclude<SlotKey, 'skin'>;
      const cur = (look as any)[pk] as number;
      const owned = chibiList(z, look.gender).filter(p => S.chibiWardrobe.includes(p.id) || p.id === cur);
      let cells = 0;
      for (const p of owned) {
        const on = cur === p.id;
        const cell = h('button', `wd-item ${on ? 'active' : ''}`);
        cell.append(z <= 20 || z === 70 ? chibiPreview(p.id, 44) : chibiHead(p.id, 40, z), h('div', 'nm', p.name));
        // món tuỳ chọn (mũ/kính/đồ cầm tay): bấm lại để cởi ra, ô trống = không dùng
        cell.onclick = () => { (look as any)[pk] = on && optional ? 0 : p.id; apply(); render(); };
        grid.append(cell); cells++;
      }
      // lấp cho đủ sức chứa tủ đồ, ô trống để trống
      for (let i = cells; i < WD_CAP; i++) grid.append(h('div', 'wd-item wd-empty'));
      card.append(grid);
      right.append(h('div', 'hint', !owned.length
        ? 'Chưa có món nào — ghé shop thời trang ở Khu mua sắm!'
        : optional ? 'Bấm lại món đang mặc để cởi ra.' : `Đang có ${owned.length} món`));
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
  // vị trí các khu trên ảnh minimap (%)
  const MAP_POS: Record<string, { x: number; y: number }> = {
    house: { x: 14, y: 16 },      // khu dân cư mái đỏ
    school: { x: 38, y: 22 },     // dãy phố
    gamecenter: { x: 46, y: 42 }, // cao ốc trung tâm
    mall: { x: 63, y: 33 },       // khu thương mại
    town: { x: 55, y: 51 },       // trung tâm thành phố
    park: { x: 25, y: 50 },       // công viên đài phun nước
    beach: { x: 59, y: 12 },      // hồ lớn phía trên
    pond: { x: 22, y: 76 },       // bờ sông dưới trái
    farm: { x: 72, y: 82 }        // đồng ruộng dưới phải
  };

  registerPanel('map', () => {
    const { body, win, close } = openWindow('Bản đồ thế giới', { size: 'large' });
    win.classList.add('win-map');            // ảnh bản đồ phủ kín popup
    const wrap = h('div', 'map-wrap');
    const img = document.createElement('img');
    img.src = 'assets/lttt/minimap.png';
    img.draggable = false;
    wrap.append(img);

    // marker các khu (đứng ở cổng cũng tính là đang ở khu đó)
    const hereId = ZONES[S.zone]?.gateTo ?? S.zone;
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
      wrap.append(m);
    }
    body.append(wrap);
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
    const { body } = openWindow('Trò chuyện');
    let channel: 'public' | 'area' | 'private' = data?.to ? 'private' : 'public';
    let privateTo = data?.to ?? S.social.friends[0]?.name ?? '';

    const log = h('div');
    log.style.cssText = 'height:220px;overflow-y:auto;background:rgba(0,0,0,.3);border-radius:10px;padding:8px;font-size:12px;display:flex;flex-direction:column;gap:3px';
    const renderLog = () => {
      log.innerHTML = '';
      for (const m of getChatLog().filter(m =>
        m.channel === 'system' ||
        (channel === 'private'
          ? m.channel === 'private' && (m.from === privateTo || m.to === privateTo || m.from === S.player.name)
          : m.channel === channel))) {
        const el = h('div', `ch-${m.channel}`);
        el.textContent = `${new Date(m.at).toLocaleTimeString('vi', { hour: '2-digit', minute: '2-digit' })} ${m.from}: ${m.text}`;
        log.append(el);
      }
      log.scrollTop = log.scrollHeight;
    };

    const chanBar = h('div', 'chips');
    const chans: ['public' | 'area' | 'private', string][] = [['public', 'Tổng'], ['area', 'Gần (người ở gần)'], ['private', '🔒 Riêng']];
    for (const [id, lbl] of chans) {
      const c = h('div', `chip ${channel === id ? 'active' : ''}`, lbl);
      c.onclick = () => { channel = id; chanBar.querySelectorAll('.chip').forEach(x => x.classList.remove('active')); c.classList.add('active'); renderLog(); };
      chanBar.append(c);
    }

    const inputBar = h('div');
    inputBar.style.cssText = 'display:flex;gap:6px;margin-top:8px';
    const inp = h('input', 'ui-input') as HTMLInputElement;
    inp.placeholder = 'Nhập tin nhắn...';
    inp.maxLength = 120;
    const sendBtn = btn('Gửi', 'gold', () => {
      const text = inp.value.trim();
      if (!text) return;
      sendChat(channel, text, channel === 'private' ? privateTo : undefined);
      // nói Tổng/Gần thì hiện bong bóng trên đầu nhân vật
      if (channel !== 'private') bus.emit('world:say', text);
      inp.value = '';
      renderLog();
    });
    inp.onkeydown = e => { if (e.key === 'Enter') sendBtn.click(); e.stopPropagation(); };
    inputBar.append(inp, sendBtn);

    body.append(chanBar, log, inputBar);
    renderLog();
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
          r.append(btn(`Nhận ${parts.join(' ')}`, 'gold', () => { claimMail(m.id); sfx.coin(); render(); }));
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
      } else if (tab === 1) {
        body.append(h('div', 't2', `Đã sưu tập ${S.collections.insects.length}/${INSECT_LIST.length} loài côn trùng`));
        for (const i of INSECT_LIST) {
          const got = S.collections.insects.includes(i.id);
          const cell = h('div', `cell ${got ? '' : 'locked'}`);
          cell.innerHTML = `<div class="ico">${i.icon}</div><div class="nm">${got ? i.name : '???'}</div><div class="pr" style="color:${RARITY_COLOR[i.rarity]}">${RARITY_NAME[i.rarity]}</div>`;
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
    tabs(['Cá', 'Côn trùng', 'Nông sản'], i => { tab = i; render(); });
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

  // ================= Garage (xe cộ) =================
  registerPanel('garage', () => {
    const { body } = openWindow('Garage', { size: 'small' });
    body.append(h('div', 'hint', 'Không có xe riêng thì đi xe buýt công cộng miễn phí. Xe riêng sẽ đón bạn tại trạm và đậu ở mép đường mỗi khu.'));
    body.append(h('div', 'sep'));
    // xe buýt công cộng
    const busRow = h('div', 'row');
    busRow.append(spr('assets/vehicles/bus.png', 0, 0, 105, 48, 64));
    busRow.innerHTML += `<div class="grow"><div class="t1">Xe buýt công cộng</div><div class="t2">Miễn phí — luôn sẵn sàng</div></div>`;
    busRow.append(S.vehicle === ''
      ? btn('Đang dùng', '', undefined)
      : btn('Dùng', 'gold', () => { S.vehicle = ''; save(); openPanel('garage'); }));
    body.append(busRow);
    // xe riêng
    for (const v of Object.values(VEHICLES)) {
      const r = h('div', 'row');
      r.append(spr(`assets/vehicles/${v.id}.png`, 0, 0, v.w, v.h, 56));
      r.innerHTML += `<div class="grow"><div class="t1">${v.name}</div><div class="t2">${v.desc}</div></div>`;
      const owned = S.garage.includes(v.id);
      if (owned) {
        r.append(S.vehicle === v.id
          ? btn('Đang dùng', '', undefined)
          : btn('Dùng', 'gold', () => { S.vehicle = v.id; save(); toast(`Đã chọn ${v.name}!`, 'bus'); openPanel('garage'); }));
      } else {
        r.append(priceBtn(v.rubyPrice ? 0 : v.price, 'gold', () => {
          if (v.rubyPrice ? spend(0, v.rubyPrice) : spend(v.price)) {
            S.garage.push(v.id);
            S.vehicle = v.id;
            addStat('vehicles_bought');
            save(); sfx.win();
            toast(`Chúc mừng xe mới: ${v.name}!`, 'gift');
            openPanel('garage');
          }
        }));
      }
      body.append(r);
    }
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
    body.append(h('div', 'hint', 'Cozy Farming v0.1 — làm bằng Phaser 3 + TypeScript'));
  });
}
