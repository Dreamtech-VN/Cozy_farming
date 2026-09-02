# 09. ECONOMY DESIGN

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Currencies

- Coin: currency phổ thông
- Gem: premium currency
- Energy: activity resource
- Event token: currency giới hạn theo event

## Sources

- Farm
- Quest
- Match-3
- Daily
- Achievement
- Event
- Social rewards

## Sinks

- Upgrade
- Shop
- Craft
- Cosmetic
- Speed-up
- Entry fee nếu cần
- Event shop

## Nguyên tắc

Mọi currency phải có source và sink. Premium currency không được phép tự sinh từ client.

## Inflation control

- Daily/weekly sinks
- Reward tuning
- Item binding
- Trade tax nếu có
- Event currency expiration

## Balancing

Tất cả giá trị nằm trong config/table; dùng simulator/analytics để kiểm tra tốc độ tích lũy.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
