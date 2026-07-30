import Phaser from 'phaser';

// Event bus dùng chung giữa Phaser scene và DOM UI
export const bus = new Phaser.Events.EventEmitter();

export const EV = {
  STATE_CHANGED: 'state:changed',
  WALLET: 'wallet:changed',
  INVENTORY: 'inventory:changed',
  STAT: 'stat:changed',
  QUEST: 'quest:changed',
  TOAST: 'ui:toast',
  CHAT: 'chat:message',
  ZONE: 'zone:enter',
  TIME_TICK: 'time:tick',
  OPEN_PANEL: 'ui:open',
  CLOSE_PANEL: 'ui:close',
  EMOTE: 'player:emote',
  APPEARANCE: 'player:appearance',
  HOUSE: 'house:changed',
  ACTION_HINT: 'ui:actionhint'
} as const;

export function toast(msg: string, icon = '') {
  bus.emit(EV.TOAST, { msg, icon });
}
