/** Các panel gameplay: nhiệm vụ, túi đồ, nông trại, bạn bè, chat, nhân vật, shop. */
import { el, showPanel, toast, emptyState, confirmAction, closePanel, rerenderPanel } from './ui.js';
import { t, formatNumber, formatDuration } from '../core/i18n.js';
import { drawAreaMap, drawWorldAtlas } from './map_draw.js';
import { buildMenuPanel } from './hud_menu.js';
import { i18n } from '../core/i18n.js';
import { settings, GRAPHICS_PRESETS } from '../core/settings.js';
import { audio } from '../core/audio.js';

const itemName = (game, itemId) => t(game.content.itemsById.get(itemId)?.name_key ?? itemId);
const cosmeticName = (game, itemId) => t(game.content.avatarItemsById.get(itemId)?.name_key ?? itemId);

export function openQuests(game) {
  showPanel('Nhiệm vụ', async (body, rerender) => {
    body.append(emptyState('Đang tải…'));
    const { quests } = await game.api.get('/v1/quests');
    body.replaceChildren();
    if (quests.length === 0) { body.append(emptyState('Chưa có nhiệm vụ nào.')); return; }

    for (const quest of quests) {
      const done = quest.state === 'completed';
      const claimed = quest.state === 'claimed';
      const progress = quest.objectives.map((o) => `${o.current}/${o.count}`).join(' · ');
      body.append(el('div', { class: 'row' }, [
        el('div', { class: 'grow' }, [
          el('div', { class: 'title', text: t(quest.name_key) }),
          el('div', { class: 'sub', text: `${t(quest.desc_key)} — ${progress}` }),
        ]),
        el('span', { class: `tag ${claimed ? 'done' : ''}`, text: QUEST_TYPE[quest.type] ?? quest.type }),
        claimed
          ? el('span', { class: 'tag done', text: 'Đã nhận' })
          : el('button', {
              class: 'primary', type: 'button', text: 'Nhận thưởng', disabled: !done,
              onClick: async () => {
                try {
                  await game.api.post(`/v1/quests/${quest.quest_id}/claim`, {});
                  toast('Đã nhận thưởng', 'good');
                  await game.refreshPlayer();
                  await game.refreshQuests();
                  rerender();
                } catch (err) { toast(err.message, 'bad'); }
              },
            }),
      ]));
    }
  }, { key: 'quests' });
}

const QUEST_TYPE = { main: 'Cốt truyện', side: 'Phụ', daily: 'Hằng ngày', weekly: 'Hằng tuần', event: 'Sự kiện' };

export function openInventory(game) {
  showPanel('Túi đồ', async (body, rerender) => {
    body.append(emptyState('Đang tải…'));
    const data = await game.api.get('/v1/player/inventory');
    body.replaceChildren();
    if (data.items.length === 0) { body.append(emptyState('Túi đồ trống.')); return; }

    const grid = el('div', { class: 'grid' });
    for (const item of data.items) {
      grid.append(el('div', {
        class: 'cell', role: 'button', tabindex: '0',
        onClick: () => showItemActions(game, item, rerender),
      }, [
        el('div', { text: itemName(game, item.item_id) }),
        el('div', { class: 'qty', text: `×${item.quantity}` }),
      ]));
    }
    body.append(grid);
  }, { key: 'inventory' });
}

function showItemActions(game, item, refresh) {
  const sellable = item.sell_price > 0;
  showPanel(itemName(game, item.item_id), (body) => {
    body.append(el('p', { class: 'sub', text: `Đang có: ${item.quantity}` }));
    if (sellable) {
      body.append(el('p', { class: 'sub', text: `Giá bán: ${formatNumber(item.sell_price)} xu / cái` }));
      const input = el('input', { type: 'number', min: '1', max: String(item.quantity), value: '1' });
      body.append(el('div', { class: 'field' }, [el('label', { text: 'Số lượng bán' }), input]));
      body.append(el('button', {
        class: 'primary', type: 'button', text: 'Bán',
        onClick: async () => {
          const quantity = Math.max(1, Math.min(item.quantity, Number(input.value) || 1));
          if (!(await confirmAction(`Bán ${quantity} ${itemName(game, item.item_id)}?`))) return;
          try {
            const result = await game.api.post('/v1/shops/sell', { item_id: item.item_id, quantity });
            toast(`+${formatNumber(result.gain)} xu`, 'good');
            await game.refreshPlayer();
            openInventory(game);
          } catch (err) { toast(err.message, 'bad'); }
        },
      }));
    } else {
      body.append(emptyState('Vật phẩm này không bán được.'));
    }
  });
}

export function openFarm(game) {
  showPanel('Nông trại', async (body, rerender) => {
    body.append(emptyState('Đang tải…'));
    const [farm, inventory] = await Promise.all([
      game.api.get('/v1/farm'),
      game.api.get('/v1/player/inventory'),
    ]);
    game.farm = farm;
    body.replaceChildren();

    body.append(el('div', { class: 'row' }, [
      el('div', { class: 'grow' }, [
        el('div', { class: 'title', text: `Nông trại cấp ${farm.level}` }),
        el('div', { class: 'sub', text: `${farm.plot_count} ô đất · ${farm.xp}/${farm.xp_to_next} XP` }),
      ]),
      farm.next_unlock
        ? el('button', {
            class: 'ghost', type: 'button',
            text: `Mở rộng (${formatNumber(farm.next_unlock.coin)} xu)`,
            onClick: async () => {
              if (!(await confirmAction(`Mở rộng lên ${farm.next_unlock.plots} ô với ${formatNumber(farm.next_unlock.coin)} xu?`))) return;
              try {
                await game.api.post('/v1/farm/expand', {});
                toast('Đã mở rộng nông trại', 'good');
                await game.refreshPlayer();
                rerender();
              } catch (err) { toast(err.message, 'bad'); }
            },
          })
        : el('span', { class: 'tag done', text: 'Tối đa' }),
    ]));

    const seeds = inventory.items.filter((i) => i.category === 'seed' && i.quantity > 0);
    for (const plot of farm.plots) {
      const crop = plot.crop_id ? game.content.cropsById.get(plot.crop_id) : null;
      const label = plot.state === 'empty'
        ? 'Ô trống'
        : `${t(crop.name_key)} — ${plot.state === 'mature' ? 'sẵn sàng thu hoạch' : `còn ${formatDuration(plot.seconds_left)}`}`;

      body.append(el('div', { class: 'row' }, [
        el('div', { class: 'grow' }, [
          el('div', { class: 'title', text: `Ô ${plot.slot_index + 1}` }),
          el('div', { class: 'sub', text: label }),
        ]),
        plot.state === 'mature'
          ? el('button', {
              class: 'primary', type: 'button', text: 'Thu hoạch',
              onClick: () => harvest(game, plot.plot_id, rerender),
            })
          : plot.state === 'empty'
            ? el('button', {
                class: 'ghost', type: 'button', text: 'Gieo hạt',
                disabled: seeds.length === 0,
                onClick: () => openSeedPicker(game, plot, seeds, rerender),
              })
            : el('span', { class: 'tag', text: `Giai đoạn ${plot.stage + 1}` }),
      ]));
    }

    if (seeds.length === 0) body.append(emptyState('Hết hạt giống — ghé tiệm hạt giống ở làng nông trại.'));
  }, { key: 'farm' });
}

function openSeedPicker(game, plot, seeds, refresh) {
  showPanel('Chọn hạt giống', (body) => {
    const grid = el('div', { class: 'grid' });
    for (const seed of seeds) {
      const crop = game.content.cropsById.get(seed.ref?.crop_id);
      if (!crop) continue;
      grid.append(el('div', {
        class: 'cell', role: 'button', tabindex: '0',
        onClick: async () => {
          try {
            await game.api.post('/v1/farm/plant', { plot_id: plot.plot_id, crop_id: crop.crop_id });
            toast(`Đã gieo ${t(crop.name_key)}`, 'good');
            openFarm(game);
          } catch (err) { toast(err.message, 'bad'); }
        },
      }, [
        el('div', { text: t(crop.name_key) }),
        el('div', { class: 'sub', text: formatDuration(crop.growth_seconds) }),
        el('div', { class: 'qty', text: `×${seed.quantity}` }),
      ]));
    }
    body.append(grid);
  });
}

export async function harvest(game, plotId, refresh) {
  try {
    const result = await game.api.post('/v1/farm/harvest', { plot_id: plotId });
    const gained = result.harvested.map((h) => `${h.count} ${itemName(game, h.item_id)}`).join(', ');
    toast(`Thu hoạch: ${gained}`, 'good');
    await game.refreshPlayer();
    await game.refreshFarm();
    await game.refreshQuests();
    refresh?.();
  } catch (err) {
    toast(err.message, 'bad');
  }
}

export function openShop(game, shopId) {
  showPanel(t(game.content.shopsById?.get(shopId)?.name_key ?? 'Cửa hàng'), async (body, rerender) => {
    body.append(emptyState('Đang tải…'));
    const shop = await game.api.get(`/v1/shops/${shopId}`);
    body.replaceChildren();
    body.previousElementSibling?.querySelector('h2')?.replaceChildren(t(shop.name_key));

    for (const entry of shop.entries) {
      const name = entry.item_id ? itemName(game, entry.item_id) : cosmeticName(game, entry.avatar_item_id);
      const limitText = entry.limit_per_day > 0 ? ` · ${entry.bought_today}/${entry.limit_per_day} hôm nay` : '';
      body.append(el('div', { class: 'row' }, [
        el('div', { class: 'grow' }, [
          el('div', { class: 'title', text: name }),
          el('div', { class: 'sub', text: `${formatNumber(entry.price)} ${t(`currency.${entry.currency}`)}${limitText}` }),
        ]),
        entry.locked
          ? el('span', { class: 'tag locked', text: `Cấp ${entry.unlock_level}` })
          : el('button', {
              class: 'primary', type: 'button', text: 'Mua',
              onClick: async () => {
                if (!(await confirmAction(`Mua ${name} với ${formatNumber(entry.price)} ${t(`currency.${entry.currency}`)}?`))) return;
                try {
                  await game.api.post(`/v1/shops/${shopId}/purchase`, { entry_id: entry.entry_id, quantity: 1 });
                  toast('Mua thành công', 'good');
                  await game.refreshPlayer();
                  rerender();
                } catch (err) { toast(err.message, 'bad'); }
              },
            }),
      ]));
    }
  });
}

/**
 * Popup bản đồ khu vực hiện tại, kèm nút mở bản đồ thành phố (doc 03, doc 12).
 * Bản đồ chỉ để xem: di chuyển giữa các map vẫn phải đi qua portal.
 */
export function openAreaMap(game) {
  const map = game.currentMap;
  if (!map) return;

  showPanel(t(map.name_key), (body) => {
    const canvas = el('canvas', { class: 'map-view' });
    canvas.style.cssText = 'width:100%;aspect-ratio:16/7';
    body.append(canvas);

    body.append(el('div', { class: 'map-legend' }, [
      el('span', {}, [el('i', { style: 'background:#7fc98a' }), el('span', { text: 'Bạn' })]),
      el('span', {}, [el('i', { style: 'background:#e9f2ea' }), el('span', { text: 'Người chơi khác' })]),
      el('span', {}, [el('i', { style: 'background:#f2c94c' }), el('span', { text: 'NPC' })]),
      el('span', {}, [el('i', { style: 'background:#7ad3f0' }), el('span', { text: 'Cổng dịch chuyển' })]),
    ]));

    body.append(el('div', { class: 'row' }, [
      el('div', { class: 'grow' }, [
        el('div', { class: 'sub', text: `${map.map_type} · rộng ${formatNumber(map.width)} · sức chứa ${map.player_capacity} người mỗi khu` }),
      ]),
      // Đổi khu không còn nút riêng trên HUD; đặt ở đây vì đổi khu là đổi bản
      // sao của ĐÚNG map đang xem.
      el('button', { class: 'ghost', type: 'button', text: 'Đổi khu', onClick: () => openChannelPicker(game) }),
      el('button', { class: 'primary', type: 'button', text: 'Bản đồ thành phố', onClick: () => openWorldAtlas(game) }),
    ]));

    // Vẽ sau một nhịp để canvas đã có kích thước thật từ CSS.
    requestAnimationFrame(() => {
      const redraw = () => drawAreaMap(canvas, map, {
        self: game.self,
        players: [...game.players.values()],
        detail: true,
      });
      redraw();
      const timer = setInterval(() => (canvas.isConnected ? redraw() : clearInterval(timer)), 500);
    });
  });
}

/** Bản đồ thành phố: toàn bộ map và các cổng nối giữa chúng. */
export function openWorldAtlas(game) {
  showPanel('Bản đồ thành phố', async (body) => {
    body.append(emptyState('Đang tải…'));
    const atlas = await game.api.get('/v1/world/atlas');
    body.replaceChildren();

    const canvas = el('canvas', { class: 'map-view' });
    canvas.style.cssText = 'width:100%;aspect-ratio:16/9';
    body.append(canvas);
    body.append(el('p', { class: 'sub', style: 'margin:10px 0 0', text: 'Đường nối là cổng dịch chuyển giữa các khu vực. Muốn sang khu vực khác thì đi tới cổng trong game.' }));

    requestAnimationFrame(() => drawWorldAtlas(canvas, atlas, game.currentMap?.map_id));
    addEventListener('resize', () => {
      if (canvas.isConnected) drawWorldAtlas(canvas, atlas, game.currentMap?.map_id);
    }, { once: true });
  });
}

/**
 * Chọn khu (doc 03/16). Dùng lưới thay cho dropdown: 20 lựa chọn kèm sĩ số và
 * mức đông — thông tin này không nhét vừa một thẻ <option> để đọc nhanh được.
 */
export function openChannelPicker(game) {
  const map = game.currentMap;
  if (!map || map.instance_policy === 'owner') return;

  showPanel('Chọn khu', async (body, rerender) => {
    body.append(emptyState('Đang tải…'));
    let data;
    try {
      data = await game.api.get(`/v1/maps/${map.map_id}/channels`);
    } catch (err) {
      body.replaceChildren(emptyState(err.message));
      return;
    }
    body.replaceChildren();

    body.append(el('p', { class: 'sub', style: 'margin:0 0 10px', text: `${t(map.name_key)} — mỗi khu là một bản sao riêng của khu vực, sức chứa ${map.player_capacity} người.` }));

    const grid = el('div', { class: 'channel-grid' });
    for (const info of data.channels) {
      const ratio = info.capacity > 0 ? info.players / info.capacity : 0;
      const full = info.players >= info.capacity;
      const current = info.channel === game.channel;
      const color = ratio >= 1 ? '#e0576f' : ratio >= 0.7 ? '#e0a33f' : '#7fc98a';

      grid.append(el('button', {
        class: 'channel-tile', type: 'button',
        'aria-current': current ? 'true' : 'false',
        disabled: full && !current,
        onClick: async () => {
          if (current) { closePanel(); return; }
          try {
            await game.enterMap(map.map_id, 'spawn_default', info.channel);
            toast(`Đã chuyển sang khu ${info.channel}`, 'good');
            closePanel();
          } catch (err) {
            toast(err.message, 'bad');
            rerender();
          }
        },
      }, [
        el('span', { class: 'n', text: `Khu ${info.channel}` }),
        el('span', { class: 'load' }, [el('i', { style: `width:${Math.min(100, ratio * 100)}%;background:${color}` })]),
        el('span', { class: 'count', text: current ? `${info.players}/${info.capacity} · ở đây` : `${info.players}/${info.capacity}` }),
      ]));
    }
    body.append(grid);
  });
}

export function openSocial(game) {
  showPanel('Bạn bè', async (body, rerender) => {
    body.append(emptyState('Đang tải…'));
    const data = await game.api.get('/v1/friends');
    body.replaceChildren();

    const input = el('input', { type: 'text', placeholder: 'Nickname người chơi', maxlength: '16' });
    body.append(el('div', { class: 'field' }, [el('label', { text: 'Kết bạn' }), input]));
    body.append(el('button', {
      class: 'primary', type: 'button', text: 'Gửi lời mời',
      onClick: async () => {
        try {
          await game.api.post('/v1/friends/requests', { nickname: input.value.trim() });
          toast('Đã gửi lời mời', 'good');
          rerender();
        } catch (err) { toast(err.message, 'bad'); }
      },
    }));

    if (data.incoming.length > 0) {
      body.append(el('h3', { text: 'Lời mời đến', style: 'margin:16px 0 4px;font-size:14px' }));
      for (const person of data.incoming) {
        body.append(el('div', { class: 'row' }, [
          el('div', { class: 'grow' }, [el('div', { class: 'title', text: person.nickname }), el('div', { class: 'sub', text: `Cấp ${person.level}` })]),
          el('button', {
            class: 'primary', type: 'button', text: 'Chấp nhận',
            onClick: async () => {
              try { await game.api.post(`/v1/friends/${person.id}/accept`, {}); toast('Đã kết bạn', 'good'); rerender(); }
              catch (err) { toast(err.message, 'bad'); }
            },
          }),
        ]));
      }
    }

    body.append(el('h3', { text: 'Danh sách bạn', style: 'margin:16px 0 4px;font-size:14px' }));
    if (data.friends.length === 0) { body.append(emptyState('Chưa có bạn nào.')); return; }
    for (const friend of data.friends) {
      body.append(el('div', { class: 'row' }, [
        el('div', { class: 'grow' }, [
          el('div', { class: 'title', text: friend.nickname }),
          el('div', { class: 'sub', text: `Cấp ${friend.level} · ${t(game.content.mapsById.get(friend.last_map_id)?.name_key ?? '')}` }),
        ]),
        el('button', {
          class: 'ghost', type: 'button', text: 'Nhắn',
          // Chat riêng gửi thẳng từ đây; kênh map/thế giới đã có khung chat dưới màn hình.
          onClick: () => openPrivateChat(game, friend),
        }),
      ]));
    }
  }, { key: 'social' });
}

/** Sự kiện và mùa đang chạy (doc 17 — LiveOps). */
/** Hộp thoại nhắn riêng cho một người bạn (doc 08 — private message). */
export function openPrivateChat(game, friend) {
  const log = el('div', { id: 'chat-log' });
  const input = el('input', { type: 'text', maxlength: '200', placeholder: `Nhắn cho ${friend.nickname}…` });

  const append = (message) => {
    log.append(el('div', { class: 'line' }, [
      el('span', { class: 'who', text: `${message.sender_nickname}: ` }),
      el('span', { text: message.body }),
    ]));
    log.scrollTop = log.scrollHeight;
  };

  const send = async () => {
    const body = input.value.trim();
    if (!body) return;
    input.value = '';
    try {
      const message = await game.api.post('/v1/chat/messages', { channel: 'private', to: friend.nickname, body });
      append(message);
    } catch (err) { toast(err.message, 'bad'); }
  };

  showPanel(friend.nickname, async (body) => {
    body.append(log);
    try {
      const data = await game.api.get(`/v1/chat/messages?channel=private&scope_id=${encodeURIComponent(friend.id)}`);
      for (const message of data.messages) append(message);
    } catch (err) {
      log.append(el('div', { class: 'line system', text: err.message }));
    }
  }, {
    footer: el('div', { class: 'chat-input' }, [
      input,
      el('button', { class: 'primary', type: 'button', text: 'Gửi', onClick: send }),
    ]),
  });
  input.addEventListener('keydown', (event) => { if (event.key === 'Enter') send(); });
}

/** Sự kiện và mùa đang chạy (doc 17 — LiveOps). */
export function openLiveOps(game) {
  showPanel('Sự kiện', async (body) => {
    body.append(emptyState('Đang tải…'));
    const config = await game.api.get('/v1/liveops/config');
    body.replaceChildren();

    const now = Date.now();
    const fmt = (iso) => new Date(iso).toLocaleDateString('vi-VN');

    for (const season of config.seasons ?? []) {
      body.append(el('div', { class: 'row' }, [
        el('div', { class: 'grow' }, [
          el('div', { class: 'title', text: t(season.name_key) }),
          el('div', { class: 'sub', text: `Mùa · ${fmt(season.starts_at)} – ${fmt(season.ends_at)}` }),
        ]),
        el('span', { class: 'tag done', text: `${season.pass_tiers.length} mốc` }),
      ]));
    }

    if ((config.events ?? []).length === 0) {
      body.append(emptyState('Chưa có sự kiện nào đang chạy.'));
    }
    for (const event of config.events ?? []) {
      const started = Date.parse(event.starts_at) <= now;
      body.append(el('div', { class: 'row' }, [
        el('div', { class: 'grow' }, [
          el('div', { class: 'title', text: t(event.name_key) }),
          el('div', { class: 'sub', text: `${fmt(event.starts_at)} – ${fmt(event.ends_at)}` }),
        ]),
        el('span', { class: `tag ${started ? 'done' : ''}`.trim(), text: started ? 'Đang diễn ra' : 'Sắp tới' }),
      ]));
    }

    const flags = Object.entries(config.feature_flags ?? {}).filter(([, on]) => on);
    if (flags.length > 0) {
      body.append(el('h3', { text: 'Tính năng đang bật', style: 'margin:14px 0 4px;font-size:14px' }));
      body.append(el('div', { class: 'sub', text: flags.map(([name]) => name).join(', ') }));
    }
  });
}

export function openProfile(game) {
  showPanel('Nhân vật', async (body, rerender) => {
    body.append(emptyState('Đang tải…'));
    const profile = await game.api.get('/v1/player/profile');
    body.replaceChildren();

    body.append(el('div', { class: 'row' }, [
      el('div', { class: 'grow' }, [
        el('div', { class: 'title', text: profile.nickname }),
        el('div', { class: 'sub', text: `Cấp ${profile.level} · ${formatNumber(profile.xp)} XP` }),
      ]),
    ]));

    const owned = new Set(profile.wardrobe);
    const bySlot = new Map();
    for (const item of game.content.avatarItems) {
      if (!owned.has(item.item_id)) continue;
      if (!bySlot.has(item.slot)) bySlot.set(item.slot, []);
      bySlot.get(item.slot).push(item);
    }

    for (const [slot, items] of bySlot) {
      body.append(el('h3', { text: SLOT_NAME[slot] ?? slot, style: 'margin:14px 0 4px;font-size:14px' }));
      const grid = el('div', { class: 'grid' });
      for (const item of items) {
        const equipped = profile.equipment[slot] === item.item_id;
        grid.append(el('div', {
          class: `cell ${equipped ? 'selected' : ''}`.trim(), role: 'button', tabindex: '0',
          onClick: async () => {
            try {
              await game.api.patch('/v1/player/profile', { equipment: { [slot]: item.item_id } });
              await game.refreshPlayer();
              rerender();
            } catch (err) { toast(err.message, 'bad'); }
          },
        }, [
          el('div', { style: `height:22px;border-radius:6px;background:${item.colors[0]};margin-bottom:5px` }),
          el('div', { text: t(item.name_key) }),
        ]));
      }
      body.append(grid);
    }
  }, { key: 'profile' });
}

/** Energy không còn trên HUD (HUD chỉ hiện xu và ngọc), nên hiện ở nơi tiêu nó. */
export function energyLine(game) {
  const energy = game.profile?.wallet?.energy ?? 0;
  return el('div', { class: 'row' }, [
    el('span', { class: 'dot energy' }),
    el('div', { class: 'grow' }, [
      el('div', { class: 'title', text: 'Năng lượng' }),
      el('div', { class: 'sub', text: 'Hồi lại theo thời gian, dùng để vào trận Match-3.' }),
    ]),
    el('span', { class: 'tag done', text: formatNumber(energy) }),
  ]);
}

const SLOT_NAME = {
  body: 'Da', face: 'Khuôn mặt', hair: 'Tóc', top: 'Áo',
  bottom: 'Quần', shoes: 'Giày', hat: 'Mũ', accessory: 'Phụ kiện', back: 'Đồ sau lưng',
};

export { closePanel };

/** Bảng Menu: thả ngay dưới nút Menu, không nhảy ra giữa màn hình. */
export function openMenu(game, handlers, anchor) {
  showPanel('Menu', (body) => buildMenuPanel(game, body, handlers, { mail: game.mailUnread > 0 }),
    { key: 'menu', compact: true, anchor });
}

/** Hòm thư (doc 08). */
export function openMail(game) {
  showPanel('Thư', async (body, rerender) => {
    body.append(emptyState('Đang tải…'));
    const data = await game.api.get('/v1/mails');
    game.setMailCounts(data);
    body.replaceChildren();
    if (data.mails.length === 0) { body.append(emptyState('Hòm thư trống.')); return; }

    for (const mail of data.mails) {
      const claimable = mail.has_attachments && !mail.claimed;
      body.append(el('div', { class: `row mail ${mail.read ? '' : 'unread'}`.trim() }, [
        el('div', { class: 'grow' }, [
          el('div', { class: 'title' }, [
            mail.read ? null : el('i', { class: 'mail-dot' }),
            el('span', { text: t(mail.subject_key) }),
          ]),
          el('div', { class: 'sub', text: t(mail.body_key) }),
          mail.has_attachments
            ? el('div', { class: 'sub', text: `Quà: ${describeReward(game, mail.attachments)}` })
            : null,
        ]),
        claimable
          ? el('button', {
              class: 'primary', type: 'button', text: 'Nhận',
              onClick: async () => {
                try {
                  await game.api.post(`/v1/mails/${mail.mail_id}/claim`, {});
                  toast('Đã nhận quà', 'good');
                  audio.success();
                  await game.refreshPlayer();
                  rerender();
                } catch (err) { toast(err.message, 'bad'); }
              },
            })
          : el('button', {
              class: 'ghost', type: 'button', text: 'Xoá',
              onClick: async () => {
                try {
                  await game.api.del(`/v1/mails/${mail.mail_id}`);
                  rerender();
                } catch (err) { toast(err.message, 'bad'); }
              },
            }),
      ]));

      // Mở panel là coi như đã đọc; không bắt bấm thêm một nút nữa.
      if (!mail.read) game.api.post(`/v1/mails/${mail.mail_id}/read`, {}).catch(() => {});
    }
  }, { key: 'mail' });
}

/** Mô tả quà đính kèm bằng một dòng chữ. */
function describeReward(game, reward) {
  const parts = [];
  for (const [currencyId, amount] of Object.entries(reward.currencies ?? {})) {
    parts.push(`${formatNumber(amount)} ${t(game.content.currenciesById?.get(currencyId)?.name_key ?? currencyId)}`);
  }
  for (const entry of reward.items ?? []) parts.push(`${itemName(game, entry.item_id)} ×${entry.count}`);
  for (const cosmetic of reward.avatar_items ?? []) parts.push(cosmeticName(game, cosmetic));
  return parts.join(' · ');
}

/** Cài đặt: Đồ hoạ / Âm thanh / Tài khoản. */
const SETTINGS_TABS = [
  { key: 'graphics', label: 'Đồ hoạ' },
  { key: 'audio', label: 'Âm thanh' },
  { key: 'account', label: 'Tài khoản' },
];
let settingsTab = 'graphics';

const PROVIDER_LABEL = { google: 'Google', facebook: 'Facebook', apple: 'Apple' };

export function openSettings(game) {
  showPanel('Cài đặt', (body, rerender) => {
    // Tab xếp dọc bên trái: nhóm cài đặt sẽ còn dài ra, hàng ngang hết chỗ ngay.
    const rail = el('div', { class: 'tab-rail' }, SETTINGS_TABS.map((tab) => el('button', {
      class: 'tab', type: 'button',
      'aria-selected': tab.key === settingsTab ? 'true' : 'false',
      text: tab.label,
      onClick: () => { settingsTab = tab.key; rerender(); },
    })));
    const pane = el('div', { class: 'tab-pane' });
    body.append(el('div', { class: 'tab-layout' }, [rail, pane]));
    if (settingsTab === 'graphics') graphicsTab(pane);
    else if (settingsTab === 'audio') audioTab(pane);
    else accountTab(game, pane, rerender);
  }, { key: 'settings', fullscreen: true });
}

/** Một hàng thiết lập: tiêu đề + mô tả bên trái, phần điều khiển bên phải. */
const settingRow = (title, hint, control) => el('div', { class: 'row' }, [
  el('div', { class: 'grow' }, [
    el('div', { class: 'title', text: title }),
    hint ? el('div', { class: 'sub', text: hint }) : null,
  ]),
  control,
]);

const toggle = (on, onChange) => el('button', {
  class: `switch ${on ? 'on' : ''}`.trim(), type: 'button',
  role: 'switch', 'aria-checked': on ? 'true' : 'false',
  onClick: () => onChange(!on),
}, [el('i')]);

function graphicsTab(pane) {
  const g = settings.value.graphics;

  pane.append(settingRow('Mức đồ hoạ', null,
    el('div', { class: 'seg' }, Object.entries(GRAPHICS_PRESETS).map(([key, spec]) => el('button', {
      class: 'seg-btn', type: 'button', text: spec.label,
      'aria-pressed': g.preset === key ? 'true' : 'false',
      onClick: () => { settings.applyPreset(key); rerenderPanel(); },
    })))));

  pane.append(settingRow('Hiệu ứng thời tiết', null,
    toggle(g.weather, (on) => { settings.patch({ graphics: { weather: on } }); rerenderPanel(); })));

  pane.append(settingRow('Hiện tên người chơi khác', null,
    toggle(g.otherNames, (on) => { settings.patch({ graphics: { otherNames: on } }); rerenderPanel(); })));

  pane.append(settingRow('Giới hạn khung hình', null,
    el('div', { class: 'seg' }, [30, 60].map((fps) => el('button', {
      class: 'seg-btn', type: 'button', text: `${fps} FPS`,
      'aria-pressed': g.fpsCap === fps ? 'true' : 'false',
      onClick: () => { settings.patch({ graphics: { fpsCap: fps } }); rerenderPanel(); },
    })))));
}

function audioTab(pane) {
  const a = settings.value.audio;

  pane.append(settingRow('Tắt tiếng', null,
    toggle(a.muted, (on) => { settings.patch({ audio: { muted: on } }); rerenderPanel(); })));

  const slider = (label, hint, key, preview) => {
    const value = el('span', { class: 'slider-value', text: `${Math.round(a[key] * 100)}%` });
    const input = el('input', {
      type: 'range', min: '0', max: '100', step: '5',
      value: String(Math.round(a[key] * 100)),
      disabled: a.muted,
    });
    // input để nghe ngay khi kéo; change để nghe thử sau khi thả tay.
    input.addEventListener('input', () => {
      value.textContent = `${input.value}%`;
      settings.patch({ audio: { [key]: Number(input.value) / 100 } });
    });
    input.addEventListener('change', preview);
    return settingRow(label, hint, el('div', { class: 'slider' }, [input, value]));
  };

  pane.append(slider('Âm lượng chung', null, 'master', () => audio.success()));
  pane.append(slider('Nhạc nền', null, 'music', () => audio.previewMusic()));
  pane.append(slider('Hiệu ứng', null, 'sfx', () => audio.click()));
}

function accountTab(game, pane, rerender) {
  pane.append(emptyState('Đang tải…'));
  game.api.get('/v1/account').then((account) => {
    pane.replaceChildren();

    pane.append(settingRow('Tên đăng nhập', null, el('span', { class: 'tag', text: account.username })));

    // --- Liên kết mạng xã hội ---
    for (const entry of account.providers) {
      pane.append(settingRow(`Liên kết ${PROVIDER_LABEL[entry.provider]}`, null,
        entry.configured
          ? el('button', {
              class: entry.linked ? 'ghost' : 'primary', type: 'button',
              text: entry.linked ? 'Gỡ' : 'Liên kết',
              onClick: () => linkProvider(game, entry, rerender),
            })
          : el('span', { class: 'tag', text: 'Chưa hỗ trợ' })));
    }

    // --- Đổi mật khẩu ---
    const current = el('input', { type: 'password', autocomplete: 'current-password', placeholder: 'Mật khẩu hiện tại' });
    const next = el('input', { type: 'password', autocomplete: 'new-password', placeholder: 'Mật khẩu mới, tối thiểu 8 ký tự' });
    pane.append(el('div', { class: 'block' }, [
      el('div', { class: 'title', text: 'Đổi mật khẩu' }),
      current, next,
      el('button', {
        class: 'primary', type: 'button', text: 'Đổi mật khẩu',
        onClick: async () => {
          try {
            await game.api.post('/v1/auth/password', {
              current_password: current.value, new_password: next.value,
            });
            toast('Đã đổi mật khẩu, hãy đăng nhập lại', 'good');
            await game.logout();
          } catch (err) { toast(err.message, 'bad'); }
        },
      }),
    ]));

    // --- Giftcode ---
    const code = el('input', { type: 'text', maxlength: '16', placeholder: 'Nhập mã, ví dụ COZY2026' });
    pane.append(el('div', { class: 'block' }, [
      el('div', { class: 'title', text: 'Đổi giftcode' }),
      code,
      el('button', {
        class: 'primary', type: 'button', text: 'Đổi mã',
        onClick: async () => {
          try {
            await game.api.post('/v1/giftcodes/redeem', { code: code.value.trim() });
            toast('Đã nhận quà từ mã', 'good');
            audio.success();
            code.value = '';
            await game.refreshPlayer();
          } catch (err) { toast(err.message, 'bad'); }
        },
      }),
    ]));

    // --- Đổi server ---
    pane.append(settingRow('Server', null,
      account.servers.length > 1
        ? el('div', { class: 'seg' }, account.servers.map((server) => el('button', {
            class: 'seg-btn', type: 'button', text: server.name,
            'aria-pressed': location.origin === server.url ? 'true' : 'false',
            onClick: () => { location.href = server.url; },
          })))
        : el('span', { class: 'tag', text: account.servers[0]?.name ?? 'Mặc định' })));

    // --- Ngôn ngữ ---
    pane.append(settingRow('Ngôn ngữ', null,
      el('div', { class: 'seg' }, [['vi', 'Tiếng Việt'], ['en', 'English']].map(([locale, label]) => el('button', {
        class: 'seg-btn', type: 'button', text: label,
        'aria-pressed': i18n.locale === locale ? 'true' : 'false',
        onClick: async () => {
          try {
            await i18n.load(game.api, locale);
            settings.patch({ locale });
            await game.refreshQuests();
            rerender();
          } catch (err) { toast(err.message, 'bad'); }
        },
      })))));

    pane.append(settingRow('Phiên bản nội dung', null, el('span', { class: 'tag', text: game.content?.version ?? '—' })));

    pane.append(el('button', {
      class: 'ghost', type: 'button', text: 'Đăng xuất',
      onClick: async () => {
        if (!(await confirmAction('Đăng xuất khỏi tài khoản này?'))) return;
        await game.logout();
      },
    }));
  }).catch((err) => {
    pane.replaceChildren(emptyState(err.message));
  });
}

/**
 * Liên kết mạng xã hội cần luồng OAuth của từng nhà cung cấp. Server chỉ nhận
 * provider_user_id ĐÃ xác minh, nên chỗ này chỉ chạy khi server báo provider đó
 * đã cấu hình; chưa cấu hình thì UI không hiện nút.
 */
async function linkProvider(game, entry, rerender) {
  try {
    if (entry.linked) {
      if (!(await confirmAction(`Gỡ liên kết ${PROVIDER_LABEL[entry.provider]}?`))) return;
      await game.api.del(`/v1/account/links/${entry.provider}`);
      toast('Đã gỡ liên kết', 'good');
    } else {
      const token = await requestOauthToken(entry.provider);
      await game.api.post('/v1/account/links', { provider: entry.provider, provider_user_id: token });
      toast('Đã liên kết', 'good');
    }
    rerender();
  } catch (err) { toast(err.message, 'bad'); }
}

/**
 * Mở cửa sổ đăng nhập của nhà cung cấp và chờ nó postMessage lại id đã xác minh.
 * Endpoint /auth/oauth/<provider> do server dựng khi có client id + secret.
 */
function requestOauthToken(provider) {
  return new Promise((resolve, reject) => {
    const popup = open(`/auth/oauth/${provider}`, 'oauth', 'width=480,height=640');
    if (!popup) { reject(new Error('Trình duyệt chặn cửa sổ đăng nhập')); return; }

    const timer = setInterval(() => {
      if (popup.closed) { cleanup(); reject(new Error('Đã huỷ đăng nhập')); }
    }, 500);
    const onMessage = (event) => {
      if (event.origin !== location.origin || event.data?.type !== 'oauth') return;
      cleanup();
      popup.close();
      if (event.data.provider_user_id) resolve(event.data.provider_user_id);
      else reject(new Error(event.data.error ?? 'Đăng nhập thất bại'));
    };
    const cleanup = () => { clearInterval(timer); removeEventListener('message', onMessage); };
    addEventListener('message', onMessage);
  });
}

