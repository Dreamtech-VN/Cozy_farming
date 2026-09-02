# 13. TECHNICAL DESIGN DOCUMENT

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Kiến trúc

Client game engine + API gateway + realtime service + domain services + database + cache + object storage + analytics.

## Client

- Rendering
- Input
- UI
- Local cache
- Network client
- Asset manager
- State manager

## Backend domains

- Auth
- Player
- World/Map
- Inventory
- Farming
- Match-3
- Social
- Chat
- Quest
- Economy
- Shop
- LiveOps

## Authoritative server

Server quyết định inventory, currency, progression, battle result và timestamps quan trọng.

## Data-driven

Item, crop, quest, map, NPC, reward, shop và event phải đọc từ config/data schema.

## Scalability

Tách stateless API khỏi stateful realtime. Map instance có thể scale ngang.

## Observability

- Structured logs
- Metrics
- Tracing
- Crash reporting
- Admin audit

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
