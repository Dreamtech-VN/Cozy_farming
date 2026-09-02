# 03. WORLD DESIGN DOCUMENT

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Kiến trúc thế giới

World gồm các map 2D side-view liên kết bằng portal/transition. Map có thể là public map, private instance hoặc event instance.

## Nhóm map

- City: Plaza, Shopping Street, Cafe, Park, Arcade
- Residential: Neighborhood, Player Home
- Farming: Farm Village, Forest, Lake, Orchard
- Adventure: Forest, Desert, Ice, Volcano, Dungeon
- Event: Summer, Halloween, Christmas, Festival

## Map specification

- map_id
- map_type
- width/height
- spawn_points
- portals
- NPCs
- interactive_objects
- collision
- player_capacity
- instance_policy
- weather/day-night flags

## Di chuyển

Player chạy trái/phải trong mặt phẳng 2D; camera bám theo player. Có collision, trigger, portal và interaction range.

## Public vs instance

City và social hubs ưu tiên public instance; farm/home ưu tiên private instance; PvE/PvP Match-3 dùng battle instance.

## Mở rộng

Thêm map mới bằng data + asset + server config; core movement/networking không thay đổi.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
