# 12. UX/UI DESIGN DOCUMENT

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Navigation

World là trung tâm. UI overlay cung cấp profile, inventory, quest, chat, shop và notifications.

## Core screens

- Login
- Character creation
- World
- Map transition
- Profile
- Inventory
- Farm HUD
- Match-3 HUD
- Quest
- Social
- Shop
- Settings

## Interaction rules

- Touch target đủ lớn
- Một hành động chính mỗi screen
- Confirm cho hành động mất tài nguyên
- Loading rõ ràng
- Error có recovery

## Responsive

MVP ưu tiên mobile portrait nhưng kiến trúc layout cho phép desktop/web.

## States

- Default
- Pressed
- Disabled
- Loading
- Success
- Error
- Empty
- Locked

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
