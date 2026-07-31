import { S, save, addStat, addItem, removeItem, todayStr } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import type { ChatMessage, Friend, MailMessage } from '@/core/types';
import { item } from '@/data/items';

// ===== Xã hội (chế độ offline: bạn NPC + chat bot; giao thức online xem docs/SERVER_PROTOCOL.md) =====

const NPC_FRIENDS: Omit<Friend, 'online'>[] = [
  { id: 'f_mai', name: 'Cô Mai', level: 12, npc: true },
  { id: 'f_hung', name: 'Chú Hùng', level: 20, npc: true },
  { id: 'f_lan', name: 'Chị Lan', level: 15, npc: true },
  { id: 'f_tuan', name: 'Bé Tuấn', level: 3, npc: true },
  { id: 'f_bien', name: 'Ông Biển', level: 30, npc: true },
  { id: 'f_thay', name: 'Thầy Giáo', level: 25, npc: true }
];

const chatLog: ChatMessage[] = [];
export function getChatLog(): ChatMessage[] { return chatLog; }

export function pushChat(m: ChatMessage) {
  chatLog.push(m);
  if (chatLog.length > 200) chatLog.shift();
  bus.emit(EV.CHAT, m);
}

const BOT_REPLIES = [
  'Hôm nay thời tiết đẹp ghê!', 'Ai đi câu cá không?', 'Mình vừa thu hoạch cả vườn dâu',
  'Có ai bán trứng gà không?', 'Tối nay tiệc ở nhà mình nha!', 'Mới thắng ván caro, vui quá!',
  'Ruộng nhà bạn đẹp thế~', 'Chăm chỉ lên nào các nông dân ơi!'
];

export function initSocial() {
  // chat bot khu vực cho vui (offline)
  window.setInterval(() => {
    if (Math.random() < 0.4) {
      const f = NPC_FRIENDS[Math.floor(Math.random() * NPC_FRIENDS.length)];
      pushChat({ channel: 'public', from: f.name, text: BOT_REPLIES[Math.floor(Math.random() * BOT_REPLIES.length)], at: Date.now() });
    }
  }, 25_000);
  pushChat({ channel: 'system', from: 'Hệ thống', text: 'Chào mừng đến với Sunny Town! Gõ chat để trò chuyện.', at: Date.now() });
}

export function sendChat(channel: ChatMessage['channel'], text: string, to?: string) {
  if (!text.trim()) return;
  pushChat({ channel, from: S.player.name, to, text: text.trim(), at: Date.now() });
  addStat('chats_sent');
  // NPC trả lời chat riêng
  if (channel === 'private' && to) {
    window.setTimeout(() => {
      pushChat({ channel: 'private', from: to, to: S.player.name, text: 'Ừa mình đây, có gì hông?', at: Date.now() });
    }, 1200 + Math.random() * 1500);
  }
}

// Tin nhắn thoại: game chưa có server nên tin chỉ nằm ở máy mình,
// không truyền sang người chơi khác được.
export function sendVoice(channel: ChatMessage['channel'], voice: string, dur: number, to?: string) {
  pushChat({ channel, from: S.player.name, to, text: '', at: Date.now(), voice, dur });
  addStat('chats_sent');
}

// ===== Người chơi khác đang ở ngoài map (offline: mô phỏng) =====
const ROAMERS: Omit<Friend, 'online'>[] = [
  { id: 'p_kem', name: 'KemDau', level: 8 },
  { id: 'p_bo', name: 'BoSua99', level: 14 },
  { id: 'p_na', name: 'NaNa', level: 21 },
  { id: 'p_tom', name: 'TomHum', level: 6 },
  { id: 'p_min', name: 'MinMin', level: 17 },
  { id: 'p_bap', name: 'BapRang', level: 11 }
];

// danh sách người chơi xuất hiện ở 1 khu (ổn định theo tên khu)
export function roamersIn(zoneId: string, n = 3): Friend[] {
  let seed = 0;
  for (const c of zoneId) seed = (seed * 31 + c.charCodeAt(0)) % 997;
  const out: Friend[] = [];
  for (let i = 0; i < n; i++) {
    const f = ROAMERS[(seed + i * 3) % ROAMERS.length];
    if (!S.social.blocked.includes(f.id)) out.push({ ...f, online: true });
  }
  return out;
}

// ===== Thiện cảm =====
export function affinityOf(id: string): number {
  return S.social.affinity?.[id] ?? 0;
}
export function addAffinity(id: string, n: number) {
  if (!S.social.affinity) S.social.affinity = {};
  S.social.affinity[id] = Math.min(100, affinityOf(id) + n);
  save(); bus.emit(EV.STATE_CHANGED);
}
export function affinityLabel(v: number): string {
  return v >= 80 ? 'Tri kỷ' : v >= 50 ? 'Thân thiết' : v >= 20 ? 'Quen biết' : 'Người lạ';
}

export function suggestedFriends(): Friend[] {
  return NPC_FRIENDS
    .filter(f => !S.social.friends.some(x => x.id === f.id) && !S.social.blocked.includes(f.id))
    .map(f => ({ ...f, online: Math.random() > 0.3 }));
}

export function addFriend(f: Friend): boolean {
  if (S.social.friends.some(x => x.id === f.id)) return false;
  S.social.friends.push({ ...f, online: true });
  addStat('friends_added');
  save(); bus.emit(EV.STATE_CHANGED);
  toast(`Đã kết bạn với ${f.name}!`, 'group');
  return true;
}

export function removeFriend(id: string) {
  S.social.friends = S.social.friends.filter(f => f.id !== id);
  save(); bus.emit(EV.STATE_CHANGED);
}

export function blockPlayer(id: string, name: string) {
  if (!S.social.blocked.includes(id)) S.social.blocked.push(id);
  removeFriend(id);
  toast(`Đã chặn ${name}.`, 'close');
  save();
}

export function reportPlayer(id: string, name: string) {
  if (!S.social.reported.includes(id)) S.social.reported.push(id);
  toast(`Đã gửi báo cáo về ${name}. Cảm ơn bạn!`, 'alert');
  save();
}

export function giveGift(friendId: string, itemId: string): boolean {
  const f = S.social.friends.find(x => x.id === friendId);
  if (!f) return false;
  if (!removeItem(itemId)) { toast('Không có vật phẩm này.'); return false; }
  addStat('gifts_given'); addStat('daily_gifted');
  toast(`Đã tặng ${item(itemId).name} cho ${f.name}!`, 'gift');
  // bạn NPC gửi quà lại qua thư
  window.setTimeout(() => {
    sendMail({
      from: f.name, subject: 'Cảm ơn bạn!',
      body: `Cảm ơn món quà của bạn nha! Gửi bạn chút quà quê ~ ${f.name}`,
      attachments: { coins: 50 + Math.floor(Math.random() * 100) }
    });
  }, 3000);
  return true;
}

// ===== Thư =====
export function sendMail(m: Omit<MailMessage, 'id' | 'read' | 'claimed' | 'at'>) {
  S.mail.unshift({ ...m, id: `m${Date.now()}${Math.floor(Math.random() * 999)}`, read: false, claimed: false, at: Date.now() });
  if (S.mail.length > 50) S.mail.pop();
  save(); bus.emit(EV.STATE_CHANGED);
  toast('Bạn có thư mới!', 'mail');
}

export function claimMail(id: string): boolean {
  const m = S.mail.find(x => x.id === id);
  if (!m || m.claimed || !m.attachments) return false;
  m.claimed = true; m.read = true;
  const a = m.attachments;
  if (a.coins) { S.wallet.coins += a.coins; bus.emit(EV.WALLET); }
  if (a.rubies) { S.wallet.rubies += a.rubies; bus.emit(EV.WALLET); }
  if (a.itemId) addItem(a.itemId, a.qty ?? 1);
  save(); bus.emit(EV.STATE_CHANGED);
  return true;
}

// ===== Bảng xếp hạng (offline: NPC + người chơi) =====
export function leaderboard(): { name: string; level: number; coins: number; me?: boolean }[] {
  const rows = NPC_FRIENDS.map(f => ({
    name: f.name, level: f.level,
    coins: f.level * 1000 + (f.id.length * 137) % 900
  }));
  rows.push({ name: S.player.name || 'Bạn', level: S.player.level, coins: S.wallet.coins });
  return rows.sort((a, b) => b.level - a.level || b.coins - a.coins)
    .map(r => ({ ...r, me: r.name === (S.player.name || 'Bạn') }));
}
