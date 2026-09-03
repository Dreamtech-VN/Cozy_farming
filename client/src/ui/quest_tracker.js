/**
 * Bảng theo dõi nhiệm vụ trên HUD (doc 11, doc 12 — world là trung tâm, UI là overlay).
 * Chỉ hiện vài nhiệm vụ đang làm; danh sách đầy đủ vẫn ở panel Nhiệm vụ.
 */
import { el, toast } from './ui.js';
import { t } from '../core/i18n.js';

const MAX_ROWS = 4;

/** Cốt truyện trước, rồi phụ, rồi hằng ngày/tuần — thứ tự người chơi quan tâm. */
const TYPE_ORDER = { main: 0, side: 1, daily: 2, weekly: 3, event: 4, achievement: 5 };

const TYPE_LABEL = { main: 'Cốt truyện', side: 'Phụ', daily: 'Hằng ngày', weekly: 'Hằng tuần', event: 'Sự kiện', achievement: 'Thành tựu' };

/** Tab lọc theo nhóm loại nhiệm vụ. */
const TABS = [
  { key: 'main', label: 'Chính', types: ['main'] },
  { key: 'side', label: 'Phụ', types: ['side', 'event', 'achievement'] },
  { key: 'daily', label: 'Ngày', types: ['daily', 'weekly'] },
];

/** Tab đang chọn và trạng thái thu gọn được nhớ giữa các lần vẽ lại. */
const state = { tab: 'main', collapsed: false };

/** Nhiệm vụ đã hoàn thành nhưng chưa nhận thưởng phải lên đầu. */
function pickVisible(quests, tab) {
  const types = TABS.find((t) => t.key === tab)?.types ?? [];
  return quests
    .filter((quest) => quest.state !== 'claimed' && types.includes(quest.type))
    .sort((a, b) => {
      const done = (b.state === 'completed') - (a.state === 'completed');
      if (done !== 0) return done;
      return (TYPE_ORDER[a.type] ?? 9) - (TYPE_ORDER[b.type] ?? 9);
    })
    .slice(0, MAX_ROWS);
}

/** Số mục chưa nhận của mỗi tab, để chấm báo trên tab. */
const pendingByTab = (quests) => Object.fromEntries(TABS.map((tab) => [
  tab.key,
  quests.filter((q) => q.state === 'completed' && tab.types.includes(q.type)).length,
]));

const progressOf = (quest) => {
  const current = quest.objectives.reduce((sum, o) => sum + Math.min(o.current, o.count), 0);
  const total = quest.objectives.reduce((sum, o) => sum + o.count, 0);
  return { current, total, ratio: total > 0 ? current / total : 0 };
};

export function renderQuestTracker(game, quests, { onOpen, onClaim }) {
  const root = document.getElementById('quest-tracker');
  const open = quests.filter((q) => q.state !== 'claimed');

  if (open.length === 0) {
    root.classList.add('hidden');
    root.replaceChildren();
    return;
  }

  // Tab rỗng thì tự nhảy sang tab đầu tiên còn việc, khỏi hiện bảng trống trơn.
  if (pickVisible(quests, state.tab).length === 0) {
    state.tab = TABS.find((tab) => pickVisible(quests, tab.key).length > 0)?.key ?? state.tab;
  }
  const visible = pickVisible(quests, state.tab);
  const pending = pendingByTab(quests);

  const redraw = () => renderQuestTracker(game, quests, { onOpen, onClaim });

  root.classList.remove('hidden');
  root.classList.toggle('collapsed', state.collapsed);
  root.replaceChildren(
    el('div', { class: 'qt-tabs' }, [
      ...TABS.map((tab) => el('button', {
        class: 'qt-tab', type: 'button',
        'aria-selected': tab.key === state.tab ? 'true' : 'false',
        onClick: () => { state.tab = tab.key; redraw(); },
      }, [
        el('span', { text: tab.label }),
        pending[tab.key] > 0 ? el('i', { class: 'qt-dot' }) : null,
      ])),
      el('button', {
        class: 'qt-collapse', type: 'button',
        title: state.collapsed ? 'Mở rộng' : 'Thu gọn',
        text: state.collapsed ? '›' : '‹',
        onClick: () => { state.collapsed = !state.collapsed; redraw(); },
      }),
    ]),
    el('div', { class: 'qt-body' }, [
      ...visible.map((quest) => {
      const progress = progressOf(quest);
      const done = quest.state === 'completed';
      return el('div', { class: `qt-row ${done ? 'done' : ''}`.trim() }, [
        // Tên và tiến độ cùng một dòng; mô tả xuống dòng riêng để cửa sổ thấp
        // ẩn được cả dòng mô tả mà không mất chỗ nhận thưởng.
        el('div', { class: 'qt-line' }, [
          el('span', { class: `qt-tag t-${quest.type}`, text: `[${TYPE_LABEL[quest.type] ?? quest.type}]` }),
          el('span', { class: 'qt-name', text: t(quest.name_key) }),
          done
            ? el('button', {
                class: 'qt-claim', type: 'button', text: 'Nhận',
                onClick: (event) => { event.stopPropagation(); onClaim(quest.quest_id); },
              })
            : el('span', { class: 'qt-count', text: `${progress.current}/${progress.total}` }),
        ]),
        el('div', { class: 'qt-sub' }, [el('span', { class: 'qt-desc', text: t(quest.desc_key) })]),
        el('span', { class: 'qt-bar' }, [el('i', { style: `width:${Math.round(progress.ratio * 100)}%` })]),
      ]);
      }),
      el('button', { class: 'qt-more', type: 'button', text: 'Xem tất cả nhiệm vụ', onClick: onOpen }),
    ]),
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
