# 06. FARMING DESIGN DOCUMENT

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Gameplay

Người chơi vào farm, chạy tới ô đất, làm đất, gieo hạt, chờ tăng trưởng, thu hoạch và đưa sản phẩm vào inventory.

## Crop state

- Empty
- Prepared
- Seeded
- Growth 1..N
- Mature
- Withered nếu có

## Data

- crop_id
- seed_item_id
- growth_seconds
- yield_table
- sell_price
- xp
- season_tags
- visual_stages

## Buildings

- Storage
- Water source
- Crafting station
- Animal pen
- Decoration

## Economy link

Crop có thể bán, dùng craft, hoàn thành quest hoặc làm nguyên liệu/booster cho Match-3.

## Offline progress

Server tính thời gian tăng trưởng dựa trên timestamp authoritative; client chỉ hiển thị trạng thái.

## Upgrade

Farm level mở thêm plot, building slot, decoration capacity và content.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
