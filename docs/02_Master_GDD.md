# 02. MASTER GAME DESIGN DOCUMENT

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Core loop

- Thu hoạch/nhận tài nguyên
- Sản xuất hoặc nâng cấp
- Chơi Match-3
- Nhận reward
- Nâng avatar/farm
- Khám phá map
- Social interaction
- Lặp lại

## Player progression

Level người chơi mở khóa map, crop, building, cosmetic, pet, Match-3 content và tính năng social. Progression phải có soft cap để content mới có đất phát triển.

## Các hệ thống

- Character/Avatar
- Inventory
- Farming
- Crafting
- Match-3
- Quest
- Social
- Housing
- Shop
- Pet
- Events
- Seasons
- Rank
- Economy

## Nguyên tắc thiết kế

- Mỗi hệ thống phải phục vụ core loop.
- Feature mới phải có nguồn tài nguyên, sink và mục tiêu rõ ràng.
- Content ưu tiên data-driven.
- Social interaction phải có lợi ích nhưng không ép buộc.

## MVP

- Avatar 2D
- 1 thành phố
- 1 khu farm
- 10–15 crop
- Inventory
- Basic NPC/quest
- Chat + friend
- Match-3 PvE
- Shop
- Basic analytics

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
