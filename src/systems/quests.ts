import { S, save, addCoins, addItem, addExp, todayStr } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { QUESTS, DAILY_POOL, ACHIEVEMENTS, type QuestDef, type Reward } from '@/data/quests';
import { sfx } from '@/core/audio';

export function grantReward(r: Reward) {
  if (r.coins) { addCoins(r.coins); S.stats['coins_earned'] = (S.stats['coins_earned'] ?? 0) + r.coins; }
  // Lượng là tiền nạp -> nhiệm vụ / điểm danh / vòng quay không phát lượng nữa.
  // Reward.rubies chỉ còn để hiện trong bảng mô tả của các gói nạp.
  if (r.exp) addExp(r.exp);
  if (r.items) for (const [id, qty] of Object.entries(r.items)) addItem(id, qty);
  if (r.title && !S.player.titles.includes(r.title)) {
    S.player.titles.push(r.title);
    toast('Danh hiệu mới!', 'rank');
  }
  save();
}

export function initQuests() {
  // bắt đầu chuỗi tân thủ nếu chưa có
  if (!S.quests.completed.includes('tut_till') && !(('tut_till') in S.quests.active)) {
    S.quests.active['tut_till'] = 0;
  }
  refreshDailyQuests();
  bus.on(EV.STAT, onStat);
}

export function refreshDailyQuests() {
  const today = todayStr();
  if (S.daily.dailyQuestDate === today) return;
  S.daily.dailyQuestDate = today;
  // reset chỉ số daily_*
  for (const k of Object.keys(S.stats)) if (k.startsWith('daily_')) S.stats[k] = 0;
  // gỡ nhiệm vụ ngày cũ
  for (const id of S.daily.dailyQuests) {
    delete S.quests.active[id];
    S.quests.completed = S.quests.completed.filter(c => c !== id);
    S.quests.claimed = S.quests.claimed.filter(c => c !== id);
  }
  // random 3 nhiệm vụ mới
  const pool = [...DAILY_POOL];
  const picked: string[] = [];
  while (picked.length < 3 && pool.length) {
    picked.push(pool.splice(Math.floor(Math.random() * pool.length), 1)[0]);
  }
  S.daily.dailyQuests = picked;
  for (const id of picked) S.quests.active[id] = 0;
  save();
}

function onStat(key: string) {
  let changed = false;
  // nhiệm vụ đang nhận
  for (const id of Object.keys(S.quests.active)) {
    const def = QUESTS[id];
    if (!def || def.stat !== key) continue;
    S.quests.active[id] = S.stats[key] ?? 0;
    if (S.quests.active[id] >= def.target && !S.quests.completed.includes(id)) {
      S.quests.completed.push(id);
      toast(`Hoàn thành: ${def.name} — vào Nhiệm vụ nhận thưởng!`, 'check');
      sfx.win();
      changed = true;
    }
  }
  // thành tựu (tự động theo dõi tất cả)
  for (const a of ACHIEVEMENTS) {
    if (a.stat !== key || S.achievements.includes(a.id)) continue;
    if ((S.stats[key] ?? 0) >= a.target) {
      S.achievements.push(a.id);
      grantReward(a.reward);
      toast(`Thành tựu: ${a.name}!`, 'rank');
      sfx.win();
      changed = true;
    }
  }
  if (changed) { save(); }
  bus.emit(EV.QUEST);
}

export function claimQuest(id: string): boolean {
  const def = QUESTS[id];
  if (!def || !S.quests.completed.includes(id) || S.quests.claimed.includes(id)) return false;
  S.quests.claimed.push(id);
  delete S.quests.active[id];
  grantReward(def.reward);
  sfx.coin();
  // mở nhiệm vụ kế tiếp trong chuỗi
  if (def.chain && !S.quests.completed.includes(def.chain)) {
    S.quests.active[def.chain] = S.stats[QUESTS[def.chain].stat] ?? 0;
    const next = QUESTS[def.chain];
    // nếu chỉ số đã đạt sẵn thì đánh dấu hoàn thành luôn
    if (S.quests.active[def.chain] >= next.target) S.quests.completed.push(def.chain);
    toast(`Nhiệm vụ mới: ${next.name}`, 'quest');
  }
  save(); bus.emit(EV.QUEST);
  return true;
}

export function activeQuestList(): { def: QuestDef; progress: number; done: boolean; claimed: boolean }[] {
  const out: { def: QuestDef; progress: number; done: boolean; claimed: boolean }[] = [];
  for (const id of Object.keys(S.quests.active)) {
    const def = QUESTS[id];
    if (!def) continue;
    out.push({
      def,
      progress: Math.min(S.stats[def.stat] ?? 0, def.target),
      done: S.quests.completed.includes(id),
      claimed: S.quests.claimed.includes(id)
    });
  }
  // nhiệm vụ đã xong chưa nhận lên đầu
  return out.sort((a, b) => Number(b.done && !b.claimed) - Number(a.done && !a.claimed));
}
