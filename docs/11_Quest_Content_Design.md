# 11. QUEST & CONTENT DESIGN

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Quest types

- Main
- Side
- Daily
- Weekly
- Event
- Achievement

## Quest structure

- quest_id
- type
- prerequisites
- objective
- progress
- reward
- unlock
- dialogue_id

## Objectives

- Collect
- Harvest
- Win Match-3
- Visit
- Craft
- Talk
- Reach level
- Buy item

## Content pacing

Main quest giới thiệu hệ thống; side quest tạo resource; daily/weekly tạo retention; event tạo content giới hạn.

## Dialogue

Dialogue dùng localization key, speaker ID, emotion/portrait metadata và branch data nếu cần.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
