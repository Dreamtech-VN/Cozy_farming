# 22. SECURITY & ANTI-CHEAT

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Threat model

- Modified client
- Packet replay
- Fake rewards
- Speed hack
- Inventory tampering
- Purchase fraud
- Spam/bot

## Server authority

Client không được tự quyết định currency, inventory, quest completion, battle result hoặc timestamps.

## Validation

- Range checks
- State checks
- Ownership checks
- Cooldown checks
- Replay/idempotency protection

## Account security

- Secure sessions
- Refresh token rotation
- Rate limit
- Device/session management
- Suspicious login alerts

## Moderation

- Report
- Mute
- Block
- Chat filters
- Admin audit log
- Penalty escalation

## Monitoring

Phát hiện transaction bất thường, tốc độ thao tác phi tự nhiên, reward spikes và account farming.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
