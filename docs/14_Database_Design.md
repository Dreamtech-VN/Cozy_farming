# 14. DATABASE DESIGN

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Core tables

- users
- characters
- character_items
- inventories
- items
- maps
- map_objects
- farms
- farm_plots
- crops
- quests
- quest_progress
- matches
- match_results
- friends
- messages
- shops
- transactions
- currencies
- events
- seasons

## ID strategy

UUID hoặc snowflake-like IDs cho entity phân tán; không expose sequence nhạy cảm nếu không cần.

## Indexes

- users: login identifiers
- inventory: player_id + item_id
- friends: user pair
- messages: conversation + created_at
- transactions: player_id + created_at

## Consistency

Transaction/economy operations cần atomicity và idempotency. Read-heavy data có thể cache.

## Retention

Log/chat/audit có retention policy; dữ liệu game cần backup và migration versioning.

## ERD principle

Player là root entity; character, inventory, farm, social và progression liên kết bằng immutable IDs.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
