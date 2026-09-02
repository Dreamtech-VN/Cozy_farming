# 04. CHARACTER DESIGN DOCUMENT

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

Avatar phải có nhận diện rõ ràng, dễ tùy biến và phù hợp pipeline sprite 2D.

## Layer

- Body
- Face
- Hair
- Top
- Bottom
- Shoes
- Hat
- Accessory
- Back item
- Pet
- Effect

## State

- Idle
- Walk
- Run
- Interact
- Sit
- Jump
- Emote
- Farm action
- Battle transition

## Direction

MVP dùng trái/phải; kiến trúc dữ liệu cho phép mở rộng thêm hướng hoặc animation state mà không đổi item system.

## Customization

Mỗi item có item_id, slot, rarity, gender/body compatibility, asset references, unlock condition và cosmetic tags.

## Naming

character_<state>_<direction>_<variant>; outfit_<slot>_<id>; emote_<id>. Không dùng tên file phụ thuộc ngôn ngữ.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
