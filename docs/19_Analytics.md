# 19. ANALYTICS DESIGN

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Core KPIs

- DAU
- WAU
- MAU
- D1/D7/D30 retention
- Session length
- Sessions/day
- Conversion
- ARPU
- ARPPU
- LTV
- Churn

## Gameplay events

- login
- map_enter
- farm_plant
- farm_harvest
- match_start
- match_win
- match_loss
- quest_complete
- item_obtained
- item_spent

## Social events

- friend_request
- friend_accept
- chat_sent
- gift_sent
- home_visit
- report

## Economy telemetry

Theo dõi source/sink theo currency, item generation, spending, inflation và bất thường.

## Privacy

Chỉ thu thập dữ liệu cần thiết, có retention policy và cơ chế xóa/ẩn dữ liệu theo yêu cầu pháp lý.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
