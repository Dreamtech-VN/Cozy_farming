# 23. LOCALIZATION DESIGN

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Ngôn ngữ

- Vietnamese
- English
- Chinese
- Korean
- Japanese
- Russian – optional

## Key-based text

Không hard-code text gameplay. Dùng localization_key và parameter placeholders.

## Text types

- UI
- Quest
- NPC dialogue
- Item
- Shop
- System messages
- Push notifications

## Variables

Ví dụ: quest.progress, item.name, player.nickname; formatter phải hỗ trợ pluralization và locale.

## Asset localization

Một số banner/icon có text cần variant theo locale; ưu tiên text UI có thể dịch được.

## QA

Kiểm tra overflow, font fallback, line break, plural, date/time/currency format.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
