/** Các panel gameplay: nhiệm vụ, túi đồ, nông trại, bạn bè, chat, nhân vật, shop. */
import { el, showPanel, toast, emptyState, confirmAction, closePanel } from './ui.js';
import { t, formatNumber, formatDuration } from '../core/i18n.js';
import { drawAreaMap, drawWorldAtlas } from './minimap.js';

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
        el('button', { class: 'ghost', type: 'button', text: 'Nhắn', onClick: () => openChat(game, { channel: 'private', to: friend.nickname }) }),
      ]));
    }
  }, { key: 'social' });
}

export function openChat(game, options = {}) {
  const state = { channel: options.channel ?? 'map', to: options.to ?? '' };
  const log = el('div', { id: 'chat-log' });
  const input = el('input', { type: 'text', placeholder: 'Nhập tin nhắn…', maxlength: '200' });

  const append = (message) => {
    log.append(el('div', { class: 'line' }, [
      el('span', { class: 'who', text: `${message.sender_nickname}: ` }),
      el('span', { text: message.body }),
    ]));
    log.scrollTop = log.scrollHeight;
  };

  const send = async () => {
    const text = input.value.trim();
    if (!text) return;
    input.value = '';
    try {
      if (state.channel === 'map') {
        game.realtime.send({ type: 'chat', body: text });
      } else {
        await game.api.post('/v1/chat/messages', {
          channel: state.channel,
          body: text,
          ...(state.channel === 'private' ? { to: state.to } : {}),
        });
      }
    } catch (err) { toast(err.message, 'bad'); }
  };

  const { body } = showPanel('Chat', async (panelBody) => {
    const select = el('select', {
      onChange: (event) => { state.channel = event.target.value; load(); },
    }, [
      el('option', { value: 'map', text: 'Trong map' }),
      el('option', { value: 'world', text: 'Thế giới' }),
      ...(state.to ? [el('option', { value: 'private', text: `Riêng với ${state.to}` })] : []),
    ]);
    select.value = state.channel;
    panelBody.append(el('div', { class: 'field' }, [el('label', { text: 'Kênh' }), select]));
    panelBody.append(log);

    const load = async () => {
      log.replaceChildren();
      try {
        const scope = state.channel === 'map' ? game.currentMap?.map_id
          : state.channel === 'private' ? game.friendIdByNickname?.get(state.to)
            : null;
        const query = new URLSearchParams({ channel: state.channel, ...(scope ? { scope_id: scope } : {}) });
        const data = await game.api.get(`/v1/chat/messages?${query}`);
        for (const message of data.messages) append(message);
      } catch (err) {
        log.append(el('div', { class: 'line system', text: err.message }));
      }
    };
    await load();
  }, {
    key: 'chat',
    footer: el('div', { class: 'chat-input' }, [
      input,
      el('button', { class: 'primary', type: 'button', text: 'Gửi', onClick: send }),
    ]),
  });

  input.addEventListener('keydown', (event) => { if (event.key === 'Enter') send(); });
  game.chatSink = (message) => {
    if (state.channel === 'map' && message.channel !== 'map') return;
    if (state.channel === 'world' && message.channel !== 'world') return;
    append(message);
  };
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
