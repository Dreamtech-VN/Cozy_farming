# 17. LIVEOPS DESIGN

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Framework

LiveOps cho phép mở event, shop, season, quest và map bằng configuration.

## Season

- Start/end timestamp
- Pass tiers
- Missions
- Rewards
- Leaderboard
- Season shop

## Events

Event có event_id, schedule, map/content IDs, currency, quest pool, shop pool và reward tables.

## Remote config

Feature flags và balance values có thể thay đổi server-side; thay đổi phải có audit.

## Operations

- Announcements
- Maintenance
- Compensation
- Rollback
- Emergency disable
- Customer support tools

## Cadence

MVP: daily/weekly tasks; sau launch: monthly events và seasonal content.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
