import { S, save, todayStr, removeItem, itemCount } from '@/core/save';
import { bus, EV, toast } from '@/core/events';
import { LOGIN_REWARDS, CHECKIN_MILESTONES, WHEEL, activeEvents } from '@/data/meta';
import { grantReward } from './quests';
import { sendMail } from './social';
import { sfx } from '@/core/audio';

// ===== Đăng nhập hằng ngày, điểm danh, vòng quay =====

export function initDaily() {
  const today = todayStr();
  const month = today.slice(0, 7);
  if (S.daily.checkinMonth !== month) {
    S.daily.checkinMonth = month;
    S.daily.checkinDays = [];
  }
  if (S.daily.lastLoginDate !== today) {
    const yesterday = new Date(Date.now() - 86400_000);
    const yStr = `${yesterday.getFullYear()}-${String(yesterday.getMonth() + 1).padStart(2, '0')}-${String(yesterday.getDate()).padStart(2, '0')}`;
    S.daily.streak = S.daily.lastLoginDate === yStr ? S.daily.streak + 1 : 1;
    S.daily.lastLoginDate = today;
    S.daily.loginClaimed = false;
    S.daily.wheelDate = today;
    S.daily.wheelSpins = 0;
    if (S.daily.streak === 1 && S.mail.length === 0) {
      sendMail({
        from: 'Sunny Town',
        subject: 'Chào mừng bạn đến Sunny Town!',
        body: 'Chào bạn mới! Đây là thị trấn nhỏ xinh của chúng mình. Hãy trồng trọt, câu cá, kết bạn và khám phá nhé!\nGửi bạn chút quà khởi đầu ~',
        attachments: { coins: 2000 }
      });
    }
    for (const ev of activeEvents()) {
      sendMail({
        from: 'Ban tổ chức', subject: `${ev.icon} ${ev.name}`,
        body: `${ev.desc}\nQuà sự kiện gửi tặng bạn!`,
        attachments: { coins: 500 }
      });
    }
    save();
  }
}

export function loginRewardToday() {
  return LOGIN_REWARDS[(Math.max(1, S.daily.streak) - 1) % LOGIN_REWARDS.length];
}

export function claimLogin(): boolean {
  if (S.daily.loginClaimed) return false;
  S.daily.loginClaimed = true;
  grantReward(loginRewardToday());
  sfx.coin(); save(); bus.emit(EV.STATE_CHANGED);
  toast(`Quà đăng nhập ngày ${S.daily.streak}!`, 'gift');
  return true;
}

export function checkinToday(): boolean {
  const day = new Date().getDate();
  if (S.daily.checkinDays.includes(day)) return false;
  S.daily.checkinDays.push(day);
  grantReward({ coins: 100 });
  // mốc thưởng
  for (const m of CHECKIN_MILESTONES) {
    if (S.daily.checkinDays.length === m.days) {
      grantReward(m.reward);
      toast(`Mốc điểm danh ${m.days} ngày!`, 'rank');
    }
  }
  sfx.coin(); save(); bus.emit(EV.STATE_CHANGED);
  return true;
}

// Vòng quay: 1 lượt free/ngày, thêm lượt bằng vé lucky_ticket
export function wheelSpinsLeft(): number {
  const free = S.daily.wheelSpins === 0 ? 1 : 0;
  return free + itemCount('lucky_ticket');
}

export function spinWheel(): { index: number } | undefined {
  if (S.daily.wheelSpins > 0) {
    if (!removeItem('lucky_ticket')) { toast('Hết lượt quay — mua vé bằng ruby nhé.', 'wheel'); return undefined; }
  }
  S.daily.wheelSpins++;
  const total = WHEEL.reduce((s, w) => s + w.weight, 0);
  let r = Math.random() * total;
  let index = 0;
  for (let i = 0; i < WHEEL.length; i++) {
    r -= WHEEL[i].weight;
    if (r <= 0) { index = i; break; }
  }
  save();
  return { index };
}

export function grantWheel(index: number) {
  grantReward(WHEEL[index].reward);
  toast(`Trúng: ${WHEEL[index].label}!`, WHEEL[index].icon);
  sfx.win();
}
