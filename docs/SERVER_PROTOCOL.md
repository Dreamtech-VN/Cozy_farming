# Giao thức server (thiết kế cho v0.3)

Client hiện chạy offline; mọi điểm cần server đã gom về các module sau:

| Module client | Hiện tại (offline) | Khi online |
|---|---|---|
| `systems/social.ts` | bạn NPC, chat bot | WebSocket rooms |
| `systems/meta.ts` | quà ngày local | server cấp quà, chống gian lận giờ |
| `core/save.ts` | localStorage | sync `GameState` lên server, server authoritative |
| `panels.ts topup` | demo cộng ruby | IAP / cổng thanh toán, server xác nhận |

## Đề xuất stack
Node.js + TypeScript (dùng chung types với client qua workspace), WebSocket (ws/uWS), Redis (presence, chat), Postgres (tài khoản, inventory).

## Message (JSON, `{t: string, d: any}`)

```
C→S: auth.login {token}
C→S: state.sync {state}            // server validate từng delta, không tin client về tiền
C→S: chat.send {channel, text, to?}
S→C: chat.msg {channel, from, text, at}
C→S: friend.add {playerId} / friend.remove / friend.block / friend.report
S→C: friend.list {friends[]}
C→S: visit.enter {playerId}        // ghé nhà/nông trại bạn
S→C: visit.state {hostState, guests[]}
C→S: trade.offer {toId, give[], want[]} / trade.accept / trade.cancel
S→C: mail.push {mail}
C→S: rank.get {board} → S→C: rank.data {rows[]}
C→S: iap.verify {receipt} → S→C: wallet.update
```

Quy tắc vàng: **server quyết định tiền tệ, vật phẩm, kết quả quay thưởng**; client chỉ hiển thị. Các hàm hệ thống (spend/addItem/spinWheel...) đã gom một chỗ nên chuyển sang gọi server là đổi ruột từng hàm, UI không đổi.
