import { registerPanel, openPanel, getGame } from './UIManager';
import { h, openWindow, btn, fmt, iconOf, spr, wearPreview, charFace } from './kit';
import { S, save, spend, addRubies, addItem, removeItem, itemCount, addStat, resetSave } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { ITEMS, item } from '@/data/items';
import { CROPS, CROP_LIST } from '@/data/crops';
import { ANIMAL_LIST } from '@/data/animals';
import { FISH_LIST, RODS, RARITY_COLOR, RARITY_NAME, FISHES } from '@/data/fish';
import { INSECT_LIST, NETS, INSECTS } from '@/data/insects';
import { HAIR_STYLES, CLOTHES, ACCESSORIES, accSlot, HAIR_COLOR_NAMES, CLOTH_COLOR_NAMES } from '@/data/clothing';
import { FURNITURE, FURNITURE_LIST, HOUSE_LEVELS, WALLPAPERS, FLOORS } from '@/data/furniture';
import { SHOPS } from '@/data/shops';
import { QUESTS, TITLES, ACHIEVEMENTS } from '@/data/quests';
import { ZONE_LIST } from '@/data/zones';
import { WHEEL, LOGIN_REWARDS, CHECKIN_MILESTONES, activeEvents } from '@/data/meta';
import { VEHICLES } from '@/data/vehicles';
import * as farming from '@/systems/farming';
import * as livestock from '@/systems/livestock';
import { buyRod, addToAquarium } from '@/systems/fishing';
import { claimQuest, activeQuestList, grantReward } from '@/systems/quests';
import { suggestedFriends, addFriend, removeFriend, blockPlayer, reportPlayer, giveGift, sendChat, getChatLog, claimMail, leaderboard } from '@/systems/social';
import { claimLogin, checkinToday, spinWheel, grantWheel, wheelSpinsLeft, loginRewardToday } from '@/systems/meta';
import { upgradeHouse, setWallpaper, setFloor, throwParty } from '@/systems/housing';
import { sfx, startBgm, stopBgm } from '@/core/audio';
import type { Reward } from '@/data/quests';

function rewardText(r: Reward): string {
  const parts: string[] = [];
  if (r.coins) parts.push(`🪙${r.coins}`);
  if (r.rubies) parts.push(`💎${r.rubies}`);
  if (r.exp) parts.push(`⭐${r.exp}`);
  if (r.items) for (const [id, q] of Object.entries(r.items)) parts.push(`${item(id).icon}x${q}`);
  if (r.title) parts.push(`🏅${TITLES[r.title]?.name}`);
  return parts.join(' ');
}

function worldScene(): any {
  return getGame().scene.getScene('World');
}

export function registerAllPanels() {

  // ================= Hộp thoại chung =================
  registerPanel('dialog', (data: { title: string; text: string; actions?: { icon: string; label: string; cb: () => void }[] }) => {
    const { body, close } = openWindow(data.title, { size: 'small' });
    body.append(h('div', '', data.text));
    const bar = h('div');
    bar.style.cssText = 'display:flex;gap:8px;margin-top:12px;flex-wrap:wrap';
    for (const a of data.actions ?? []) {
      bar.append(btn(`${a.icon} ${a.label}`, 'gold', () => { close(); a.cb(); }));
    }
    bar.append(btn('Đóng', '', close));
    body.append(bar);
  });

  // ================= Kho đồ =================
  registerPanel('inventory', () => {
    const { body, close, tabs } = openWindow('🎒 Kho đồ');
    const kinds = [
      ['Tất cả', () => true],
      ['Nông sản', (k: string) => ['crop', 'seed', 'product'].includes(k)],
      ['Cá & Côn trùng', (k: string) => ['fish', 'insect'].includes(k)],
      ['Nội thất', (k: string) => ['furniture', 'deco'].includes(k)],
      ['Khác', (k: string) => ['gift', 'material', 'food', 'special', 'tool'].includes(k)]
    ] as const;
    let tab = 0;
    const render = () => {
      body.innerHTML = '';
      const grid = h('div', 'grid');
      const entries = Object.entries(S.inventory).filter(([id]) => kinds[tab][1](item(id).kind) || tab === 0);
      if (!entries.length) body.append(h('div', 'hint', 'Trống trơn... đi làm việc thôi!'));
      for (const [id, qty] of entries) {
        const def = item(id);
        const c = h('div', 'cell');
        c.append(iconOf(def), h('div', 'nm', def.name), h('div', 'qty', `x${qty}`));
        c.onclick = () => itemActions(id, close);
        grid.append(c);
      }
      body.append(grid);
    };
    tabs(kinds.map(k => k[0]), i => { tab = i; render(); });
    render();
    bus.on(EV.INVENTORY, render);
  });

  function itemActions(id: string, closeParent: () => void) {
    const def = item(id);
    const acts: { icon: string; label: string; cb: () => void }[] = [];
    if (def.sell > 0) {
      acts.push({
        icon: '🪙', label: `Bán 1 (+${def.sell} xu)`, cb: () => {
          if (removeItem(id)) { S.wallet.coins += def.sell; S.stats['coins_earned'] = (S.stats['coins_earned'] ?? 0) + def.sell; bus.emit(EV.WALLET); addStat('daily_sold'); if (def.kind === 'crop') addStat('sold_crops'); sfx.coin(); save(); }
        }
      });
      const qty = itemCount(id);
      if (qty > 1) acts.push({
        icon: '💰', label: `Bán hết x${qty} (+${def.sell * qty})`, cb: () => {
          if (removeItem(id, qty)) { S.wallet.coins += def.sell * qty; S.stats['coins_earned'] = (S.stats['coins_earned'] ?? 0) + def.sell * qty; bus.emit(EV.WALLET); addStat('daily_sold', qty); if (def.kind === 'crop') addStat('sold_crops', qty); sfx.coin(); save(); }
        }
      });
    }
    if (def.kind === 'gift' || def.kind === 'crop' || def.kind === 'food') {
      acts.push({ icon: '🎁', label: 'Tặng bạn bè', cb: () => pickFriendToGift(id) });
    }
    if (def.meta?.furniture) {
      acts.push({ icon: '🏠', label: 'Đặt trong nhà', cb: () => { closeParent(); bus.emit('world:place', id); } });
    }
    if (def.kind === 'fish') {
      acts.push({ icon: '🐠', label: 'Thả vào hồ cá nhà', cb: () => addToAquarium(id) });
    }
    if (def.id === 'food_cake') {
      acts.push({ icon: '🎉', label: 'Mở tiệc tại nhà', cb: () => { if (throwParty()) { closeParent(); } } });
    }
    openPanel('dialog', { title: `${def.icon} ${def.name}`, text: def.desc ?? `Giá bán: ${def.sell} xu`, actions: acts });
  }

  function pickFriendToGift(itemId: string) {
    const { body, close } = openWindow('🎁 Tặng cho ai?', { size: 'small' });
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
    const { body, close } = openWindow('🌱 Trồng gì đây?', { size: 'small' });
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
      body.append(btn('🛒 Mở tiệm hạt giống', 'gold', () => { close(); openPanel('shop', { shopId: 'shop_seed' }); }));
    }
    body.append(grid);
  });

  // ================= Shop =================
  registerPanel('shop', (data: { shopId: string }) => {
    const shop = SHOPS[data.shopId];
    if (!shop) return;
    if (shop.special === 'fashion') return openPanel('fashionshop');
    if (shop.special === 'house') return openPanel('houseshop');
    if (shop.special === 'fishing') return openPanel('fishingshop');

    const { body, tabs } = openWindow(`${shop.icon} ${shop.name}`);
    let mode = 0;
    const render = () => {
      body.innerHTML = '';
      const grid = h('div', 'grid');
      if (mode === 0) {
        for (const id of shop.items) {
          const def = item(id);
          const cell = h('div', 'cell');
          const price = def.rubyBuy ? `💎${def.rubyBuy}` : `🪙${def.buy ?? 0}`;
          cell.append(iconOf(def), h('div', 'nm', def.name), h('div', 'pr', price));
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
          cell.append(iconOf(def), h('div', 'nm', def.name), h('div', 'qty', `x${qty}`), h('div', 'pr', `+${def.sell}🪙`));
          cell.onclick = () => {
            if (removeItem(id)) {
              S.wallet.coins += def.sell;
              S.stats['coins_earned'] = (S.stats['coins_earned'] ?? 0) + def.sell;
              addStat('daily_sold'); if (def.kind === 'crop') addStat('sold_crops');
              bus.emit(EV.WALLET); sfx.coin(); save(); render();
            }
          };
          grid.append(cell);
        }
      }
      body.append(grid);
    };
    tabs(['🛒 Mua', '🪙 Bán'], i => { mode = i; render(); });
    render();
  });

  // ---- shop cần câu / vợt ----
  registerPanel('fishingshop', () => {
    const { body } = openWindow('🎣 Tiệm câu Ông Biển', { size: 'small' });
    for (const rod of RODS) {
      const r = h('div', 'row');
      const owned = S.tools.rod >= rod.tier;
      r.innerHTML = `<div style="font-size:22px">🎣</div><div class="grow"><div class="t1">${rod.name}</div><div class="t2">+${Math.round(rod.bonus * 100)}% tỉ lệ cá hiếm</div></div>`;
      r.append(owned ? btn('Đã có', '', undefined) : btn(`🪙${rod.price}`, 'gold', () => { if (buyRod(rod.tier)) openPanel('fishingshop'); }));
      body.append(r);
    }
    body.append(h('div', 'sep'));
    for (const net of NETS) {
      const r = h('div', 'row');
      const owned = S.tools.net >= net.tier;
      r.innerHTML = `<div style="font-size:22px">🥅</div><div class="grow"><div class="t1">${net.name}</div><div class="t2">Bắt côn trùng</div></div>`;
      r.append(owned ? btn('Đã có', '', undefined) : btn(`🪙${net.price}`, 'gold', () => {
        if (spend(net.price)) { S.tools.net = net.tier; save(); toast(`Đã mua ${net.name}!`, '🥅'); openPanel('fishingshop'); }
      }));
      body.append(r);
    }
    body.append(h('div', 'hint', 'Bán cá: mở Kho đồ hoặc tab Bán ở Bách hóa.'));
  });

  // ---- shop thời trang ----
  registerPanel('fashionshop', () => {
    const { body, tabs } = openWindow('👗 Thời trang Cô Trang', { size: 'large' });
    const cats = [
      ['💇 Tóc', HAIR_STYLES, 'hair'],
      ['👕 Trang phục', CLOTHES, 'clothes'],
      ['🎩 Phụ kiện', ACCESSORIES, 'acc']
    ] as const;
    let tab = 0;
    const render = () => {
      body.innerHTML = '';
      const [, list, prefix] = cats[tab];
      const grid = h('div', 'grid');
      for (const w of list) {
        const key = `${prefix}:${w.id}`;
        const owned = S.wardrobe.includes(key);
        const cell = h('div', `cell ${owned ? 'owned' : ''}`);
        const price = w.price === 0 ? 'Miễn phí' : w.rubyPrice ? `💎${w.rubyPrice}` : `🪙${w.price}`;
        // xem trước sprite thật, kèm nhân vật nền cho dễ hình dung
        const prev = h('div');
        prev.style.cssText = 'position:relative;width:40px;height:40px';
        const base = wearPreview('base', `char${S.player.appearance.charIndex + 1}`, 0, 40);
        base.style.cssText += 'position:absolute;left:0;top:0;opacity:.45';
        const it = wearPreview(prefix, w.id, prefix === 'hair' ? S.player.appearance.hairColor : prefix === 'clothes' ? S.player.appearance.clothesColor : 0, 40);
        it.style.cssText += 'position:absolute;left:0;top:0';
        prev.append(base, it);
        cell.append(prev, h('div', 'nm', w.name), h('div', 'pr', owned ? '✅ Đã có' : price));
        cell.onclick = () => {
          if (owned) { openPanel('wardrobe'); return; }
          const ok = w.rubyPrice ? spend(0, w.rubyPrice) : spend(w.price);
          if (ok) {
            S.wardrobe.push(key); save();
            addStat('fashion_bought');
            toast(`Đã mua ${w.name}! Vào Hồ sơ > Tủ đồ để mặc.`, '👗');
            render();
          }
        };
        grid.append(cell);
      }
      body.append(grid);
    };
    tabs(cats.map(c => c[0]), i => { tab = i; render(); });
    render();
  });

  // ---- shop nhà & nội thất ----
  registerPanel('houseshop', () => {
    const { body, tabs } = openWindow('🏠 Nhà đất Chị Lan', { size: 'large' });
    let tab = 0;
    const render = () => {
      body.innerHTML = '';
      if (tab === 0) {
        // nhà
        if (!S.house.owned) {
          const lv = HOUSE_LEVELS[0];
          const r = h('div', 'row');
          r.innerHTML = `<div style="font-size:26px">🏠</div><div class="grow"><div class="t1">${lv.name}</div><div class="t2">Ngôi nhà đầu tiên của bạn!</div></div>`;
          r.append(btn(`🪙${lv.price}`, 'gold', () => import('@/systems/housing').then(hh => { if (hh.buyHouse()) render(); })));
          body.append(r);
        } else if (S.house.level < HOUSE_LEVELS.length) {
          const next = HOUSE_LEVELS[S.house.level];
          const r = h('div', 'row');
          r.innerHTML = `<div style="font-size:26px">🏡</div><div class="grow"><div class="t1">Nâng cấp: ${next.name}</div><div class="t2">Phòng rộng hơn (${next.size}x${next.size})</div></div>`;
          r.append(btn(`🪙${next.price}`, 'gold', () => { if (upgradeHouse()) render(); }));
          body.append(r);
        } else {
          body.append(h('div', 'hint', 'Nhà của bạn đã là Biệt thự xịn nhất rồi! 🎉'));
        }
        if (S.house.owned) {
          body.append(h('div', 'sep'));
          body.append(h('div', 'lbl', '🎨 Giấy dán tường'));
          const sw1 = h('div', 'swatches');
          WALLPAPERS.forEach((c, i) => {
            const s = h('div', `sw ${S.house.wallpaper === i ? 'active' : ''}`);
            s.style.background = `#${c.toString(16).padStart(6, '0')}`;
            s.onclick = () => { setWallpaper(i); render(); };
            sw1.append(s);
          });
          body.append(sw1);
          const floorLbl = h('div', 'lbl', '🪵 Sàn nhà');
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
          const price = f.rubyPrice ? `💎${f.rubyPrice}` : `🪙${f.price}`;
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
    tabs(['🏠 Nhà & Trang trí', '🛋️ Nội thất'], i => { tab = i; render(); });
    render();
  });

  // ---- shop vật nuôi ----
  registerPanel('animalshop', () => {
    const { body } = openWindow('🐔 Mua vật nuôi', { size: 'small' });
    body.append(h('div', 'hint', `Chuồng cấp ${S.livestock.barnLevel}: ${S.livestock.animals.length}/${livestock.barnCapacity()} con`));
    for (const a of ANIMAL_LIST) {
      const r = h('div', 'row');
      r.append(spr(`assets/animals/${a.sheet}`, 0, 0, a.frameW, a.frameH, 36));
      r.innerHTML += `<div class="grow"><div class="t1">${a.name}</div><div class="t2">Cho ra ${item(a.product).name} mỗi ${a.produceMin} phút sau khi ăn</div></div>`;
      r.append(btn(`🪙${a.price}`, 'gold', () => {
        if (livestock.buyAnimal(a.id)) worldScene()?.scene?.restart();
      }));
      body.append(r);
    }
  });

  // ================= Nhiệm vụ / Thành tựu =================
  registerPanel('quests', () => {
    const { body, tabs } = openWindow('📜 Nhiệm vụ');
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
            <div style="font-size:22px">${qi.def.type === 'daily' ? '☀️' : '📜'}</div>
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
            <div style="font-size:22px">${got ? '🏆' : '🔒'}</div>
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
    tabs(['📜 Nhiệm vụ', '🏆 Thành tựu'], i => { tab = i; render(); });
    render();
  });

  // ================= Hồ sơ & Tủ đồ & Danh hiệu =================
  registerPanel('profile', () => {
    const { body, tabs } = openWindow('👤 Hồ sơ cá nhân');
    let tab = 0;
    const render = () => {
      body.innerHTML = '';
      if (tab === 0) {
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
        (info.querySelector('#pf-face') as HTMLElement).append(charFace(S.player.appearance, 56));
        body.append(info);
        const statsBox = h('div');
        statsBox.style.cssText = 'display:grid;grid-template-columns:1fr 1fr;gap:6px;margin-top:10px';
        const rows: [string, number][] = [
          ['🧺 Thu hoạch', S.stats['harvested'] ?? 0],
          ['🐟 Cá đã câu', S.stats['fish_caught'] ?? 0],
          ['🦋 Côn trùng', S.stats['insects_caught'] ?? 0],
          ['🪙 Xu kiếm được', S.stats['coins_earned'] ?? 0],
          ['🏆 Thành tựu', S.achievements.length],
          ['🎮 Thắng minigame', (S.minigames.caroWins + S.minigames.xiangqiWins + S.minigames.rpsWins)]
        ];
        for (const [lbl, v] of rows) {
          const d = h('div', 'row');
          d.innerHTML = `<div class="grow t2">${lbl}</div><div class="t1">${fmt(v)}</div>`;
          statsBox.append(d);
        }
        body.append(statsBox);
      } else if (tab === 1) {
        openWardrobe(body);
      } else {
        // danh hiệu
        for (const id of Object.keys(TITLES)) {
          const owned = S.player.titles.includes(id);
          const r = h('div', 'row');
          r.style.opacity = owned ? '1' : '.5';
          r.innerHTML = `<div style="font-size:20px">🏅</div><div class="grow"><div class="t1" style="color:${TITLES[id].color}">${TITLES[id].name}</div></div>`;
          if (owned) r.append(S.player.title === id
            ? btn('Đang dùng', '', undefined)
            : btn('Dùng', 'gold', () => { S.player.title = id; save(); bus.emit(EV.STATE_CHANGED); render(); }));
          else r.append(h('div', 't2', 'Chưa mở'));
          body.append(r);
        }
      }
    };
    tabs(['📋 Thông tin', '👗 Tủ đồ', '🏅 Danh hiệu'], i => { tab = i; render(); });
    render();
  });

  registerPanel('wardrobe', () => {
    const { body } = openWindow('👗 Tủ đồ');
    openWardrobe(body);
  });

  function openWardrobe(body: HTMLElement) {
    const a = S.player.appearance;
    const apply = () => { save(); bus.emit(EV.APPEARANCE); };

    const section = (label: string) => {
      const d = h('div', 'cc-row');
      d.append(h('div', 'lbl', label));
      body.append(d);
      return d;
    };

    // tóc
    let sec = section('💇 Kiểu tóc (đã mua)');
    let chips = h('div', 'chips');
    for (const hs of HAIR_STYLES.filter(x => S.wardrobe.includes(`hair:${x.id}`))) {
      const c = h('div', `chip ${a.hairStyle === hs.id ? 'active' : ''}`);
      c.style.cssText = 'display:inline-flex;align-items:center;gap:4px';
      c.append(wearPreview('hair', hs.id, a.hairColor, 26), h('span', '', hs.name));
      c.onclick = () => { a.hairStyle = hs.id; apply(); body.innerHTML = ''; openWardrobe(body); };
      chips.append(c);
    }
    sec.append(chips);
    sec.append(colorSwatches(14, a.hairColor, i => { a.hairColor = i; apply(); }, HAIR_COLOR_NAMES));

    // trang phục
    sec = section('👕 Trang phục (đã mua)');
    chips = h('div', 'chips');
    for (const cl of CLOTHES.filter(x => S.wardrobe.includes(`clothes:${x.id}`))) {
      const c = h('div', `chip ${a.clothes === cl.id ? 'active' : ''}`);
      c.style.cssText = 'display:inline-flex;align-items:center;gap:4px';
      c.append(wearPreview('clothes', cl.id, a.clothesColor, 26), h('span', '', cl.name));
      c.onclick = () => { a.clothes = cl.id; apply(); body.innerHTML = ''; openWardrobe(body); };
      chips.append(c);
    }
    sec.append(chips);
    sec.append(colorSwatches(10, a.clothesColor, i => { a.clothesColor = i; apply(); }, CLOTH_COLOR_NAMES));

    // phụ kiện
    sec = section('🎩 Phụ kiện (đeo nhiều món khác nhóm)');
    chips = h('div', 'chips');
    for (const ac of ACCESSORIES.filter(x => S.wardrobe.includes(`acc:${x.id}`))) {
      const worn = a.acc.includes(ac.id);
      const c = h('div', `chip ${worn ? 'active' : ''}`);
      c.style.cssText = 'display:inline-flex;align-items:center;gap:4px';
      c.append(wearPreview('acc', ac.id, 0, 26), h('span', '', ac.name));
      c.onclick = () => {
        if (worn) a.acc = a.acc.filter(x => x !== ac.id);
        else {
          a.acc = a.acc.filter(x => accSlot(x) !== accSlot(ac.id));
          a.acc.push(ac.id);
        }
        apply(); body.innerHTML = ''; openWardrobe(body);
      };
      chips.append(c);
    }
    if (!chips.children.length) chips.append(h('div', 'hint', 'Chưa có phụ kiện — ghé shop thời trang ở Khu mua sắm!'));
    sec.append(chips);
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

  // ================= Bản đồ thế giới (minh họa, bấm để di chuyển) =================
  // vị trí các khu trên bản đồ (%)
  const MAP_POS: Record<string, { x: number; y: number }> = {
    gamecenter: { x: 24, y: 26 },
    school: { x: 46, y: 16 },
    mall: { x: 68, y: 24 },
    park: { x: 12, y: 56 },
    town: { x: 46, y: 50 },
    beach: { x: 88, y: 48 },
    house: { x: 60, y: 68 },
    pond: { x: 22, y: 82 },
    farm: { x: 74, y: 80 }
  };
  // các tuyến đường nối khu (vẽ gấp khúc chữ L)
  const ROADS: [string, string][] = [
    ['gamecenter', 'school'], ['school', 'mall'], ['gamecenter', 'town'],
    ['school', 'town'], ['mall', 'town'], ['mall', 'beach'], ['park', 'town'],
    ['town', 'house'], ['house', 'farm'], ['town', 'beach'], ['park', 'pond'],
    ['pond', 'farm'], ['house', 'pond']
  ];

  registerPanel('map', () => {
    const { body, close } = openWindow('🗺️ Bản đồ thế giới', { size: 'large' });
    const W = 880, H = 470;
    const wrap = h('div', 'map-wrap');
    const cv = document.createElement('canvas');
    cv.width = W; cv.height = H;
    wrap.append(cv);
    const ctx = cv.getContext('2d')!;
    const px = (id: string) => ({ x: MAP_POS[id].x / 100 * W, y: MAP_POS[id].y / 100 * H });

    // random cố định để bản đồ không nhảy hình
    let seed = 12345;
    const rnd = () => (seed = (seed * 9301 + 49297) % 233280) / 233280;

    // nền cỏ
    ctx.fillStyle = '#7ec850';
    ctx.fillRect(0, 0, W, H);
    ctx.fillStyle = '#8fd45e';
    for (let i = 0; i < 500; i++) ctx.fillRect(rnd() * W, rnd() * H, 3, 3);
    ctx.fillStyle = '#6cb840';
    for (let i = 0; i < 300; i++) ctx.fillRect(rnd() * W, rnd() * H, 4, 2);

    // sông chảy chéo (qua góc phải, xuống đáy như ảnh mẫu)
    const river = (pts: [number, number][], w: number) => {
      ctx.lineCap = 'round'; ctx.lineJoin = 'round';
      ctx.strokeStyle = '#8ed3e8'; ctx.lineWidth = w + 10;
      ctx.beginPath(); ctx.moveTo(pts[0][0], pts[0][1]);
      for (let i = 1; i < pts.length - 1; i++) ctx.quadraticCurveTo(pts[i][0], pts[i][1], (pts[i][0] + pts[i + 1][0]) / 2, (pts[i][1] + pts[i + 1][1]) / 2);
      ctx.stroke();
      ctx.strokeStyle = '#4aa5d9'; ctx.lineWidth = w;
      ctx.stroke();
    };
    river([[W * 0.55, -20], [W * 0.62, H * 0.18], [W * 0.8, H * 0.3], [W * 0.99, H * 0.34]], 26);
    river([[W * 0.35, H + 20], [W * 0.42, H * 0.86], [W * 0.55, H * 0.9], [W * 0.75, H * 1.05]], 22);

    // hồ ở công viên + hồ câu
    const lake = (x: number, y: number, rx: number, ry: number) => {
      ctx.fillStyle = '#8ed3e8'; ctx.beginPath(); ctx.ellipse(x, y, rx + 5, ry + 5, 0, 0, 7); ctx.fill();
      ctx.fillStyle = '#4aa5d9'; ctx.beginPath(); ctx.ellipse(x, y, rx, ry, 0, 0, 7); ctx.fill();
    };
    lake(W * 0.07, H * 0.72, 34, 18);
    lake(W * 0.22, H * 0.9, 46, 20);

    // đường nhựa nối các khu (gấp khúc chữ L)
    ctx.strokeStyle = '#5b6068'; ctx.lineWidth = 16; ctx.lineCap = 'round'; ctx.lineJoin = 'round';
    const roadPath = () => {
      ctx.beginPath();
      for (const [a, b] of ROADS) {
        const A = px(a), B = px(b);
        ctx.moveTo(A.x, A.y);
        ctx.lineTo(B.x, A.y);
        ctx.lineTo(B.x, B.y);
      }
    };
    roadPath(); ctx.stroke();
    // vạch kẻ trắng
    ctx.strokeStyle = '#e8e8e8'; ctx.lineWidth = 2; ctx.setLineDash([8, 10]);
    roadPath(); ctx.stroke();
    ctx.setLineDash([]);

    // cụm nhà quanh mỗi khu
    const house = (x: number, y: number, s: number) => {
      const w = 14 * s, hh = 10 * s;
      ctx.fillStyle = ['#f6edd8', '#e8d5a3', '#d8e8f5'][Math.floor(rnd() * 3)];
      ctx.fillRect(x - w / 2, y - hh, w, hh);
      ctx.fillStyle = ['#d9534f', '#4a90c4', '#8a5a33'][Math.floor(rnd() * 3)];
      ctx.beginPath(); ctx.moveTo(x - w / 2 - 2, y - hh); ctx.lineTo(x + w / 2 + 2, y - hh); ctx.lineTo(x, y - hh - 8 * s); ctx.closePath(); ctx.fill();
    };
    const tree = (x: number, y: number) => {
      ctx.fillStyle = '#4e8429'; ctx.beginPath(); ctx.arc(x, y, 6, 0, 7); ctx.fill();
      ctx.fillStyle = '#3f6d21'; ctx.beginPath(); ctx.arc(x + 3, y + 2, 4, 0, 7); ctx.fill();
    };
    for (const id of Object.keys(MAP_POS)) {
      const p = px(id);
      const n = 3 + Math.floor(rnd() * 3);
      for (let i = 0; i < n; i++) house(p.x + (rnd() * 90 - 45), p.y + (rnd() * 50 - 30), 0.9 + rnd() * 0.5);
    }
    for (let i = 0; i < 60; i++) {
      const x = rnd() * W, y = rnd() * H;
      tree(x, y);
    }
    // mây
    ctx.fillStyle = 'rgba(255,255,255,.5)';
    for (const [cx, cy, r] of [[W * 0.4, H * 0.93, 60], [W * 0.56, H * 0.97, 46], [W * 0.13, H * 0.1, 40]] as [number, number, number][]) {
      ctx.beginPath(); ctx.ellipse(cx, cy, r, r * 0.42, 0, 0, 7); ctx.fill();
    }

    // marker các khu
    for (const z of ZONE_LIST) {
      const pos = MAP_POS[z.id];
      if (!pos) continue;
      const m = h('div', `map-marker ${S.zone === z.id ? 'here' : ''}`);
      m.style.left = pos.x + '%';
      m.style.top = pos.y + '%';
      m.innerHTML = `<div class="sign">${z.icon}</div><div class="tag">${z.name}</div>`;
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
    const { body, tabs } = openWindow('👥 Bạn bè');
    let tab = 0;
    const render = () => {
      body.innerHTML = '';
      if (tab === 0) {
        if (!S.social.friends.length) body.append(h('div', 'hint', 'Chưa có bạn — qua tab Gợi ý để kết bạn!'));
        for (const f of S.social.friends) {
          const r = h('div', 'row');
          r.innerHTML = `<div style="font-size:22px">${f.online ? '🟢' : '⚪'}</div><div class="grow"><div class="t1"></div><div class="t2">Lv.${f.level}${f.npc ? ' · NPC' : ''}</div></div>`;
          (r.querySelector('.t1') as HTMLElement).textContent = f.name;
          r.append(
            btn('💬', 'mini blue', () => openPanel('chat', { to: f.name })),
            btn('🎁', 'mini gold', () => pickGiftFor(f.id)),
            btn('🏠', 'mini', () => toast(`${f.name} mời bạn ghé nhà chơi khi nào rảnh nha!`, '🏠')),
            btn('🚫', 'mini red', () => { blockPlayer(f.id, f.name); render(); }),
            btn('🚨', 'mini red', () => reportPlayer(f.id, f.name)),
            btn('✕', 'mini red', () => { removeFriend(f.id); render(); })
          );
          body.append(r);
        }
      } else {
        const sug = suggestedFriends();
        if (!sug.length) body.append(h('div', 'hint', 'Hết người để gợi ý rồi!'));
        for (const f of sug) {
          const r = h('div', 'row');
          r.innerHTML = `<div style="font-size:22px">🙋</div><div class="grow"><div class="t1"></div><div class="t2">Lv.${f.level}</div></div>`;
          (r.querySelector('.t1') as HTMLElement).textContent = f.name;
          r.append(btn('➕ Kết bạn', 'gold', () => { addFriend(f); render(); }));
          body.append(r);
        }
      }
    };
    tabs(['👥 Bạn bè', '🔍 Gợi ý'], i => { tab = i; render(); });
    render();
  });

  function pickGiftFor(friendId: string) {
    const { body, close } = openWindow('🎁 Chọn quà', { size: 'small' });
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
    const { body } = openWindow('💬 Trò chuyện');
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
    const chans: ['public' | 'area' | 'private', string][] = [['public', '🌍 Công khai'], ['area', '📍 Khu vực'], ['private', '🔒 Riêng']];
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
      sendChat(channel, inp.value, channel === 'private' ? privateTo : undefined);
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
    const { body } = openWindow('✉️ Hộp thư');
    const render = () => {
      body.innerHTML = '';
      if (!S.mail.length) body.append(h('div', 'hint', 'Hộp thư trống.'));
      for (const m of S.mail) {
        const r = h('div', 'row');
        r.innerHTML = `<div style="font-size:20px">${m.read ? '📖' : '✉️'}</div>
          <div class="grow"><div class="t1"></div><div class="t2"></div><div class="t2" style="white-space:pre-wrap"></div></div>`;
        (r.querySelector('.t1') as HTMLElement).textContent = m.subject;
        (r.querySelectorAll('.t2')[0] as HTMLElement).textContent = `Từ: ${m.from} · ${new Date(m.at).toLocaleString('vi')}`;
        (r.querySelectorAll('.t2')[1] as HTMLElement).textContent = m.body;
        if (m.attachments && !m.claimed) {
          const a = m.attachments;
          const parts: string[] = [];
          if (a.coins) parts.push(`🪙${a.coins}`);
          if (a.rubies) parts.push(`💎${a.rubies}`);
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
    const { body, tabs } = openWindow('🎁 Quà mỗi ngày');
    let tab = 0;
    const render = () => {
      body.innerHTML = '';
      if (tab === 0) {
        body.append(h('div', 't1', `Chuỗi đăng nhập: ${S.daily.streak} ngày 🔥`));
        const grid = h('div', 'grid');
        LOGIN_REWARDS.forEach((r, i) => {
          const idx = (Math.max(1, S.daily.streak) - 1) % LOGIN_REWARDS.length;
          const cell = h('div', `cell ${i === idx ? 'selected' : ''} ${i < idx || (i === idx && S.daily.loginClaimed) ? 'owned' : ''}`);
          cell.innerHTML = `<div class="ico">🎁</div><div class="nm">Ngày ${i + 1}</div><div class="pr">${rewardText(r)}</div>`;
          grid.append(cell);
        });
        body.append(grid);
        const b = btn(S.daily.loginClaimed ? '✅ Đã nhận hôm nay' : `Nhận quà: ${rewardText(loginRewardToday())}`, 'gold', () => { claimLogin(); render(); });
        b.disabled = S.daily.loginClaimed;
        b.style.marginTop = '10px';
        body.append(b);
      } else if (tab === 1) {
        const today = new Date().getDate();
        body.append(h('div', 't1', `Điểm danh tháng này: ${S.daily.checkinDays.length} ngày`));
        const checked = S.daily.checkinDays.includes(today);
        const b = btn(checked ? '✅ Hôm nay đã điểm danh' : '📅 Điểm danh hôm nay (+100 xu)', 'gold', () => { checkinToday(); render(); });
        b.disabled = checked;
        body.append(b);
        body.append(h('div', 'sep'));
        for (const m of CHECKIN_MILESTONES) {
          const r = h('div', 'row');
          const got = S.daily.checkinDays.length >= m.days;
          r.innerHTML = `<div style="font-size:20px">${got ? '✅' : '🔒'}</div><div class="grow"><div class="t1">Mốc ${m.days} ngày</div><div class="t2">${rewardText(m.reward)}</div></div>`;
          body.append(r);
        }
      } else {
        const evs = activeEvents();
        if (!evs.length) body.append(h('div', 'hint', 'Chưa có sự kiện nào trong tháng này.'));
        for (const e of evs) {
          const r = h('div', 'row');
          r.innerHTML = `<div style="font-size:24px">${e.icon}</div><div class="grow"><div class="t1">${e.name}</div><div class="t2">${e.desc}</div></div><div class="t2">Đang diễn ra 🎊</div>`;
          body.append(r);
        }
        body.append(h('div', 'sep'));
        body.append(h('div', 'hint', 'Sự kiện cả năm: 🧧 Tết · 💝 Valentine · 🏖️ Lễ hội biển · 🥮 Trung Thu · 🎃 Halloween · 🎄 Noel · 🎂 Sinh nhật game'));
      }
    };
    tabs(['🎁 Đăng nhập', '📅 Điểm danh', '🎊 Sự kiện'], i => { tab = i; render(); });
    render();
  });

  // ================= Vòng quay =================
  registerPanel('wheel', () => {
    const { body } = openWindow('🎡 Vòng quay may mắn', { size: 'small' });
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
      ctx.fillStyle = '#fff';
      ctx.font = '16px sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText(WHEEL[i].icon, size / 2 - 30, 6);
      ctx.restore();
    }
    const pointer = h('div', '', '🔻');
    pointer.style.cssText = 'font-size:24px;margin-bottom:-14px;z-index:2';
    const info = h('div', 'hint', `Lượt còn lại: ${wheelSpinsLeft()} (1 free/ngày, thêm bằng vé 🎟️)`);
    let spinning = false;
    const spinBtn = btn('🎰 QUAY!', 'gold', () => {
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
    const { body, tabs } = openWindow('📖 Bộ sưu tập', { size: 'large' });
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
    tabs(['🐟 Cá', '🦋 Côn trùng', '🌾 Nông sản'], i => { tab = i; render(); });
    render();
  });

  // ================= Xếp hạng =================
  registerPanel('ranking', () => {
    const { body } = openWindow('🏆 Bảng xếp hạng', { size: 'small' });
    leaderboard().forEach((r, i) => {
      const row = h('div', 'row');
      if (r.me) row.style.borderLeft = '4px solid #ffd43b';
      row.innerHTML = `<div style="font-size:18px;width:30px;text-align:center">${i === 0 ? '🥇' : i === 1 ? '🥈' : i === 2 ? '🥉' : i + 1}</div>
        <div class="grow"><div class="t1"></div></div><div class="t2">Lv.${r.level} · 🪙${fmt(r.coins)}</div>`;
      (row.querySelector('.t1') as HTMLElement).textContent = r.name + (r.me ? ' (bạn)' : '');
      body.append(row);
    });
  });

  // ================= Biểu cảm =================
  registerPanel('emotes', () => {
    const { body, close } = openWindow('😊 Biểu cảm', { size: 'small' });
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
    const { body } = openWindow('🚌 Garage', { size: 'small' });
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
          : btn('Dùng', 'gold', () => { S.vehicle = v.id; save(); toast(`Đã chọn ${v.name}!`, '🚗'); openPanel('garage'); }));
      } else {
        r.append(btn(v.rubyPrice ? `💎${v.rubyPrice}` : `🪙${fmt(v.price)}`, 'gold', () => {
          if (v.rubyPrice ? spend(0, v.rubyPrice) : spend(v.price)) {
            S.garage.push(v.id);
            S.vehicle = v.id;
            addStat('vehicles_bought');
            save(); sfx.win();
            toast(`Chúc mừng xe mới: ${v.name}!`, '🎉');
            openPanel('garage');
          }
        }));
      }
      body.append(r);
    }
  });

  // ================= Nạp (demo) =================
  registerPanel('topup', () => {
    const { body } = openWindow('💎 Nạp Ruby', { size: 'small' });
    body.append(h('div', 'hint', 'Bản demo offline: nhận ruby ngay. Khi ra mắt sẽ nối cổng thanh toán (IAP/thẻ).'));
    const packs = [
      { rubies: 50, price: '20.000đ', icon: '💎' },
      { rubies: 150, price: '50.000đ', icon: '💰' },
      { rubies: 400, price: '100.000đ', icon: '🎁' },
      { rubies: 1000, price: '200.000đ', icon: '👑' }
    ];
    for (const p of packs) {
      const r = h('div', 'row');
      r.innerHTML = `<div style="font-size:22px">${p.icon}</div><div class="grow"><div class="t1">${p.rubies} Ruby</div><div class="t2">${p.price}</div></div>`;
      r.append(btn('Nhận (demo)', 'gold', () => { addRubies(p.rubies); toast(`+${p.rubies} ruby!`, '💎'); sfx.coin(); }));
      body.append(r);
    }
  });

  // ================= Cài đặt =================
  registerPanel('settings', () => {
    const { body } = openWindow('⚙️ Cài đặt', { size: 'small' });
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
    mkToggle('🎵 Nhạc nền', () => S.settings.music, v => { S.settings.music = v; v ? startBgm() : stopBgm(); });
    mkToggle('🔊 Hiệu ứng âm thanh', () => S.settings.sfx, v => { S.settings.sfx = v; });
    body.append(h('div', 'sep'));
    body.append(btn('🖥️ Toàn màn hình', 'blue', () => {
      if (document.fullscreenElement) document.exitFullscreen();
      else document.documentElement.requestFullscreen?.();
    }));
    const del = btn('🗑️ Xóa save & chơi lại từ đầu', 'red', () => {
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
