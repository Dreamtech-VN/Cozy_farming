# 18. CONTENT PIPELINE

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Mục tiêu

Artist/designer có thể thêm content mới mà không sửa core code.

## Pipeline

- Create source
- Assign ID
- Metadata
- Validation
- Export
- Import
- QA
- Publish

## Data schemas

- Item
- Crop
- NPC
- Map
- Quest
- Reward
- Shop
- Event
- Match-3 level

## Validation

- Duplicate IDs
- Missing references
- Invalid ranges
- Missing assets
- Localization gaps
- Circular prerequisites

## Versioning

Content package có version; production publish cần changelog và rollback plan.

## Tooling

Khuyến nghị có content editor/admin panel để designer quản lý item, crop, quest, shop và event.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
