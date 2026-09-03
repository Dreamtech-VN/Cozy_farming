/**
 * Bảng theo dõi nhiệm vụ trên HUD (doc 11, doc 12 — world là trung tâm, UI là overlay).
 * Chỉ hiện vài nhiệm vụ đang làm; danh sách đầy đủ vẫn ở panel Nhiệm vụ.
 */
import { el, toast } from './ui.js';
import { t } from '../core/i18n.js';

const MAX_ROWS = 3;

/** Cốt truyện trước, rồi phụ, rồi hằng ngày/tuần — thứ tự người chơi quan tâm. */
const TYPE_ORDER = { main: 0, side: 1, daily: 2, weekly: 3, event: 4, achievement: 5 };
const TYPE_LABEL = { main: 'Cốt truyện', side: 'Phụ', daily: 'Hằng ngày', weekly: 'Hằng tuần', event: 'Sự kiện' };

/** Nhiệm vụ đã hoàn thành nhưng chưa nhận thưởng phải lên đầu. */
function pickVisible(quests) {
  return quests
    .filter((quest) => quest.state !== 'claimed')
    .sort((a, b) => {
      const done = (b.state === 'completed') - (a.state === 'completed');
      if (done !== 0) return done;
      return (TYPE_ORDER[a.type] ?? 9) - (TYPE_ORDER[b.type] ?? 9);
    })
    .slice(0, MAX_ROWS);
}

const progressOf = (quest) => {
  const current = quest.objectives.reduce((sum, o) => sum + Math.min(o.current, o.count), 0);
  const total = quest.objectives.reduce((sum, o) => sum + o.count, 0);
  return { current, total, ratio: total > 0 ? current / total : 0 };
};

export function renderQuestTracker(game, quests, { onOpen, onClaim }) {
  const root = document.getElementById('quest-tracker');
  const visible = pickVisible(quests);

  if (visible.length === 0) {
    root.classList.add('hidden');
    root.replaceChildren();
    return;
  }

  root.classList.remove('hidden');
  root.replaceChildren(
    el('div', { class: 'qt-head' }, [
      el('span', { class: 'qt-title', text: 'Nhiệm vụ' }),
      el('button', { class: 'qt-more', type: 'button', text: 'Xem tất cả', onClick: onOpen }),
    ]),
    ...visible.map((quest) => {
      const progress = progressOf(quest);
      const done = quest.state === 'completed';
      return el('div', { class: `qt-row ${done ? 'done' : ''}`.trim() }, [
        el('div', { class: 'qt-line' }, [
          el('span', { class: 'qt-name', text: t(quest.name_key) }),
          el('span', { class: 'qt-tag', text: TYPE_LABEL[quest.type] ?? quest.type }),
        ]),
        el('div', { class: 'qt-line' }, [
          el('span', { class: 'qt-bar' }, [el('i', { style: `width:${Math.round(progress.ratio * 100)}%` })]),
          done
            ? el('button', {
                class: 'qt-claim', type: 'button', text: 'Nhận',
                onClick: (event) => { event.stopPropagation(); onClaim(quest.quest_id); },
              })
            : el('span', { class: 'qt-count', text: `${progress.current}/${progress.total}` }),
        ]),
      ]);
    }),
  );
}

/** Nhận thưởng ngay trên HUD, khỏi phải mở panel. */
export async function claimFromTracker(game, questId) {
  try {
    await game.api.post(`/v1/quests/${questId}/claim`, {});
    toast('Đã nhận thưởng', 'good');
    await game.refreshPlayer();
    await game.refreshQuests();
  } catch (err) {
    toast(err.message, 'bad');
  }
}
