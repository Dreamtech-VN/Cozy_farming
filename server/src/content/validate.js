/**
 * Validation cho content pipeline (doc 18).
 * Bắt: duplicate ID, missing reference, giá trị ngoài khoảng hợp lệ,
 * localization gaps và circular prerequisites.
 * Trả về danh sách issue; caller quyết định fail build hay chỉ cảnh báo.
 */

const err = (rule, message) => ({ severity: 'error', rule, message });
const warn = (rule, message) => ({ severity: 'warning', rule, message });

function checkDuplicates(issues, rows, key, label) {
  const seen = new Set();
  for (const row of rows) {
    const id = row[key];
    if (id === undefined) { issues.push(err('missing_id', `${label}: có bản ghi thiếu ${key}`)); continue; }
    if (seen.has(id)) issues.push(err('duplicate_id', `${label}: ID trùng ${id}`));
    seen.add(id);
  }
}

export function validateContent(content) {
  const issues = [];

  checkDuplicates(issues, content.crops, 'crop_id', 'crops');
  checkDuplicates(issues, content.items, 'item_id', 'items');
  checkDuplicates(issues, content.avatarItems, 'item_id', 'avatar_items');
  checkDuplicates(issues, content.maps, 'map_id', 'maps');
  checkDuplicates(issues, content.levels, 'level_id', 'match3_levels');
  checkDuplicates(issues, content.quests, 'quest_id', 'quests');
  checkDuplicates(issues, content.shops, 'shop_id', 'shops');
  checkDuplicates(issues, content.giftcodes, 'code', 'giftcodes');
  checkDuplicates(issues, content.dialogues, 'dialogue_id', 'dialogues');

  const itemIds = new Set(content.items.map((i) => i.item_id));
  const avatarIds = new Set(content.avatarItems.map((i) => i.item_id));
  const cropIds = new Set(content.crops.map((c) => c.crop_id));
  const mapIds = new Set(content.maps.map((m) => m.map_id));
  const levelIds = new Set(content.levels.map((l) => l.level_id));
  const questIds = new Set(content.quests.map((q) => q.quest_id));
  const shopIds = new Set(content.shops.map((s) => s.shop_id));
  const dialogueIds = new Set(content.dialogues.map((d) => d.dialogue_id));
  const npcIds = new Set([...content.byNpc.keys()]);
  const currencyIds = new Set(content.economy.currencies.map((c) => c.currency_id));

  // --- Crop ---
  for (const crop of content.crops) {
    if (!itemIds.has(crop.seed_item_id)) issues.push(err('missing_ref', `crop ${crop.crop_id}: seed_item_id ${crop.seed_item_id} không tồn tại`));
    if (!itemIds.has(crop.product_item_id)) issues.push(err('missing_ref', `crop ${crop.crop_id}: product_item_id ${crop.product_item_id} không tồn tại`));
    if (!(crop.growth_seconds > 0)) issues.push(err('invalid_range', `crop ${crop.crop_id}: growth_seconds phải > 0`));
    if (!(crop.stages >= 2)) issues.push(err('invalid_range', `crop ${crop.crop_id}: stages phải >= 2`));
    if (!(crop.sell_price >= 0)) issues.push(err('invalid_range', `crop ${crop.crop_id}: sell_price phải >= 0`));
    for (const entry of crop.yield_table) {
      if (!itemIds.has(entry.item_id)) issues.push(err('missing_ref', `crop ${crop.crop_id}: yield item ${entry.item_id} không tồn tại`));
      if (entry.min > entry.max) issues.push(err('invalid_range', `crop ${crop.crop_id}: yield min > max`));
    }
  }

  // --- Map ---
  for (const map of content.maps) {
    if (!map.spawn_points?.length) issues.push(err('invalid_map', `map ${map.map_id}: thiếu spawn_points`));
    const spawnIds = new Set(map.spawn_points.map((s) => s.id));
    for (const spawn of map.spawn_points) {
      if (spawn.x < 0 || spawn.x > map.width) issues.push(err('invalid_range', `map ${map.map_id}: spawn ${spawn.id} nằm ngoài map`));
    }
    for (const portal of map.portals) {
      const target = content.byMap.get(portal.target_map_id);
      if (!target) { issues.push(err('missing_ref', `map ${map.map_id}: portal ${portal.portal_id} trỏ tới map không tồn tại ${portal.target_map_id}`)); continue; }
      if (!target.spawn_points.some((s) => s.id === portal.target_spawn)) {
        issues.push(err('missing_ref', `map ${map.map_id}: portal ${portal.portal_id} trỏ tới spawn không tồn tại ${portal.target_spawn}`));
      }
    }
    for (const npc of map.npcs) {
      if (npc.dialogue_id && !dialogueIds.has(npc.dialogue_id)) issues.push(err('missing_ref', `map ${map.map_id}: npc ${npc.npc_id} có dialogue_id lạ ${npc.dialogue_id}`));
      if (npc.shop_id && !shopIds.has(npc.shop_id)) issues.push(err('missing_ref', `map ${map.map_id}: npc ${npc.npc_id} có shop_id lạ ${npc.shop_id}`));
    }
    if (map.instance_policy === 'owner' && !map.farm_layout) {
      issues.push(warn('map_config', `map ${map.map_id}: instance owner nhưng không có farm_layout`));
    }
    if (!spawnIds.has('spawn_default')) issues.push(err('invalid_map', `map ${map.map_id}: thiếu spawn_default`));
  }

  if (!Number.isInteger(content.channelCount) || content.channelCount < 1 || content.channelCount > 64) {
    issues.push(err('invalid_range', `world.channel_count phải là số nguyên 1–64, đang là ${content.channelCount}`));
  }

  // --- Chu kỳ ngày & thời tiết (doc 03) ---
  const cycle = content.world?.day_cycle;
  if (!cycle) issues.push(err('missing_ref', 'world.day_cycle chưa được khai báo'));
  else {
    if (!(cycle.real_minutes_per_day > 0)) issues.push(err('invalid_range', 'world.day_cycle.real_minutes_per_day phải > 0'));
    // Các giai đoạn phải phủ kín 1440 phút, không hở và không chồng nhau.
    let covered = 0;
    for (const phase of cycle.phases ?? []) {
      for (const bound of [phase.from, phase.to]) {
        if (!Number.isInteger(bound) || bound < 0 || bound > 1439) {
          issues.push(err('invalid_range', `phase ${phase.id}: mốc ${bound} phải nằm trong 0–1439`));
        }
      }
      covered += (phase.to - phase.from + 1440) % 1440;
    }
    if (covered !== 1440) {
      issues.push(err('invalid_range', `world.day_cycle: các giai đoạn phủ ${covered} phút, phải đúng 1440`));
    }
  }

  const weather = content.world?.weather;
  if (!weather) issues.push(err('missing_ref', 'world.weather chưa được khai báo'));
  else {
    if (!(weather.slot_minutes > 0)) issues.push(err('invalid_range', 'world.weather.slot_minutes phải > 0'));
    if (!(weather.types?.length > 0)) issues.push(err('invalid_range', 'world.weather.types không được rỗng'));
    for (const type of weather.types ?? []) {
      if (!(type.weight > 0)) issues.push(err('invalid_range', `weather ${type.id}: weight phải > 0`));
    }
  }

  // --- Match-3 ---
  const tiers = new Set(content.difficultyTable.map((d) => d.tier));
  for (const level of content.levels) {
    if (!tiers.has(level.tier)) issues.push(err('missing_ref', `level ${level.level_id}: tier ${level.tier} không có trong difficulty_table`));
    if (level.board.width < 5 || level.board.height < 5) issues.push(err('invalid_range', `level ${level.level_id}: board quá nhỏ`));
    if (!(level.moves > 0)) issues.push(err('invalid_range', `level ${level.level_id}: moves phải > 0`));
    if (!(level.enemy?.hp > 0)) issues.push(err('invalid_range', `level ${level.level_id}: enemy.hp phải > 0`));
    for (const reward of [...(level.rewards.items ?? []), ...(level.first_clear_rewards?.items ?? [])]) {
      if (!itemIds.has(reward.item_id)) issues.push(err('missing_ref', `level ${level.level_id}: reward item ${reward.item_id} không tồn tại`));
    }
  }
  if (content.tileTypes.length < 5) issues.push(err('invalid_range', 'match3: cần ít nhất 5 tile type để board có thể chơi được'));

  // --- Quest ---
  for (const quest of content.quests) {
    for (const prereq of quest.prerequisites) {
      if (!questIds.has(prereq)) issues.push(err('missing_ref', `quest ${quest.quest_id}: prerequisite ${prereq} không tồn tại`));
    }
    for (const unlock of quest.unlocks ?? []) {
      if (!questIds.has(unlock)) issues.push(err('missing_ref', `quest ${quest.quest_id}: unlocks ${unlock} không tồn tại`));
    }
    if (quest.dialogue_id && !dialogueIds.has(quest.dialogue_id)) issues.push(err('missing_ref', `quest ${quest.quest_id}: dialogue_id ${quest.dialogue_id} không tồn tại`));
    for (const objective of quest.objectives) {
      if (!(objective.count > 0)) issues.push(err('invalid_range', `quest ${quest.quest_id}: objective count phải > 0`));
      const target = objective.target;
      if (target === 'any') continue;
      const ok = {
        harvest: () => cropIds.has(target),
        collect: () => itemIds.has(target),
        match3_win: () => levelIds.has(target),
        visit_map: () => mapIds.has(target),
        talk_npc: () => npcIds.has(target),
        buy_item: () => itemIds.has(target),
        reach_level: () => Number.isInteger(Number(target)) && Number(target) > 0,
      }[objective.type];
      if (!ok) issues.push(err('unknown_objective', `quest ${quest.quest_id}: objective type lạ ${objective.type}`));
      else if (!ok()) issues.push(err('missing_ref', `quest ${quest.quest_id}: objective target ${target} không tồn tại`));
    }
    for (const reward of quest.rewards.items ?? []) {
      if (!itemIds.has(reward.item_id)) issues.push(err('missing_ref', `quest ${quest.quest_id}: reward item ${reward.item_id} không tồn tại`));
    }
    for (const cosmetic of quest.rewards.avatar_items ?? []) {
      if (!avatarIds.has(cosmetic)) issues.push(err('missing_ref', `quest ${quest.quest_id}: reward cosmetic ${cosmetic} không tồn tại`));
    }
  }
  detectCycles(issues, content.quests);

  // --- Shop ---
  for (const shop of content.shops) {
    if (shop.npc_id && !npcIds.has(shop.npc_id)) issues.push(err('missing_ref', `shop ${shop.shop_id}: npc_id ${shop.npc_id} không tồn tại`));
    const entryIds = new Set();
    for (const entry of shop.entries) {
      if (entryIds.has(entry.entry_id)) issues.push(err('duplicate_id', `shop ${shop.shop_id}: entry trùng ${entry.entry_id}`));
      entryIds.add(entry.entry_id);
      if (!currencyIds.has(entry.currency)) issues.push(err('missing_ref', `shop ${shop.shop_id}: currency ${entry.currency} không tồn tại`));
      if (!(entry.price > 0)) issues.push(err('invalid_range', `shop ${shop.shop_id}: entry ${entry.entry_id} có giá <= 0`));
      const sells = entry.item_id ?? entry.avatar_item_id;
      if (!sells) issues.push(err('invalid_shop', `shop ${shop.shop_id}: entry ${entry.entry_id} không bán gì cả`));
      else if (entry.item_id && !itemIds.has(entry.item_id)) issues.push(err('missing_ref', `shop ${shop.shop_id}: item ${entry.item_id} không tồn tại`));
      else if (entry.avatar_item_id && !avatarIds.has(entry.avatar_item_id)) issues.push(err('missing_ref', `shop ${shop.shop_id}: cosmetic ${entry.avatar_item_id} không tồn tại`));
    }
  }

  // --- Giftcode ---
  for (const gift of content.giftcodes) {
    if (!/^[A-Z0-9]{4,16}$/.test(gift.code)) {
      issues.push(err('invalid_range', `giftcode ${gift.code}: mã chỉ được gồm 4–16 ký tự A–Z và 0–9`));
    }
    if (!(gift.max_uses >= 0)) issues.push(err('invalid_range', `giftcode ${gift.code}: max_uses phải >= 0`));
    for (const [currencyId] of Object.entries(gift.reward?.currencies ?? {})) {
      if (!currencyIds.has(currencyId)) issues.push(err('missing_ref', `giftcode ${gift.code}: currency ${currencyId} không tồn tại`));
    }
    for (const entry of gift.reward?.items ?? []) {
      if (!itemIds.has(entry.item_id)) issues.push(err('missing_ref', `giftcode ${gift.code}: item ${entry.item_id} không tồn tại`));
    }
    for (const cosmetic of gift.reward?.avatar_items ?? []) {
      if (!avatarIds.has(cosmetic)) issues.push(err('missing_ref', `giftcode ${gift.code}: cosmetic ${cosmetic} không tồn tại`));
    }
  }

  // --- Thư hệ thống ---
  checkDuplicates(issues, content.mails, 'mail_id', 'mails');
  for (const mail of content.mails) {
    if (!mail.subject_key || !mail.body_key) issues.push(err('invalid_range', `mail ${mail.mail_id}: thiếu subject_key hoặc body_key`));
    for (const [currencyId] of Object.entries(mail.attachments?.currencies ?? {})) {
      if (!currencyIds.has(currencyId)) issues.push(err('missing_ref', `mail ${mail.mail_id}: currency ${currencyId} không tồn tại`));
    }
    for (const entry of mail.attachments?.items ?? []) {
      if (!itemIds.has(entry.item_id)) issues.push(err('missing_ref', `mail ${mail.mail_id}: item ${entry.item_id} không tồn tại`));
    }
    for (const cosmetic of mail.attachments?.avatar_items ?? []) {
      if (!avatarIds.has(cosmetic)) issues.push(err('missing_ref', `mail ${mail.mail_id}: cosmetic ${cosmetic} không tồn tại`));
    }
  }

  // --- Economy (doc 09: mọi currency phải có source và sink) ---
  for (const currency of content.economy.currencies) {
    if (!(currency.cap > 0)) issues.push(err('invalid_range', `currency ${currency.currency_id}: cap phải > 0`));
  }
  const spendable = new Set(content.shops.flatMap((s) => s.entries.map((e) => e.currency)));
  for (const currency of ['coin', 'gem']) {
    if (!spendable.has(currency)) issues.push(warn('economy_sink', `currency ${currency} chưa có sink nào trong shop`));
  }

  // --- Localization (doc 23) ---
  issues.push(...checkLocalization(content));

  return issues;
}

/** Circular prerequisites giữa các quest (doc 18). */
function detectCycles(issues, quests) {
  const graph = new Map(quests.map((q) => [q.quest_id, q.prerequisites ?? []]));
  const state = new Map();
  const visit = (id, path) => {
    if (state.get(id) === 'done') return;
    if (state.get(id) === 'visiting') {
      issues.push(err('circular_prerequisite', `quest prerequisites tạo vòng lặp: ${[...path, id].join(' -> ')}`));
      return;
    }
    state.set(id, 'visiting');
    for (const next of graph.get(id) ?? []) if (graph.has(next)) visit(next, [...path, id]);
    state.set(id, 'done');
  };
  for (const id of graph.keys()) visit(id, []);
}

/** Thu thập mọi *_key trong content rồi đối chiếu với từng locale. */
export function collectLocalizationKeys(content) {
  const keys = new Set();
  const walk = (node) => {
    if (Array.isArray(node)) { node.forEach(walk); return; }
    if (!node || typeof node !== 'object') return;
    for (const [key, value] of Object.entries(node)) {
      if ((key.endsWith('_key') || key === 'lines') && value) {
        for (const v of [].concat(value)) if (typeof v === 'string') keys.add(v);
      } else walk(value);
    }
  };
  walk({
    crops: content.crops, items: content.items, avatarItems: content.avatarItems, emotes: content.emotes,
    maps: content.maps, levels: content.levels, quests: content.quests, dialogues: content.dialogues,
    shops: content.shops, economy: content.economy, liveops: content.liveops, world: content.world,
    giftcodes: content.giftcodes,
  });
  return keys;
}

function checkLocalization(content) {
  const issues = [];
  const keys = collectLocalizationKeys(content);
  const base = content.locales.vi;
  if (!base) return [err('localization', 'thiếu locale gốc vi')];
  for (const key of keys) {
    if (!(key in base.strings)) issues.push(err('localization_gap', `locale vi thiếu key ${key}`));
  }
  for (const [locale, table] of Object.entries(content.locales)) {
    if (locale === 'vi') continue;
    for (const key of keys) {
      if (!(key in table.strings)) issues.push(warn('localization_gap', `locale ${locale} thiếu key ${key}`));
    }
  }
  return issues;
}
