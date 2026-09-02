# 20. QA & TESTING PLAN

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Test layers

- Unit
- Integration
- API
- Gameplay
- UI
- Multiplayer
- Load
- Security
- Regression

## Critical test cases

- Purchase grant
- Inventory transaction
- Farm harvest
- Quest reward
- Match result
- PvP disconnect
- Reconnect
- Chat moderation

## Bug severity

- S0 Blocker
- S1 Critical
- S2 Major
- S3 Minor
- S4 Cosmetic

## Release gates

Không release nếu có S0/S1 chưa được xử lý hoặc economy transaction không có test coverage phù hợp.

## Compatibility

Kiểm thử nhiều độ phân giải, FPS, network latency, reconnect, background/foreground và low-memory.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
