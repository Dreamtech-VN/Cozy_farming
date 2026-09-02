# 07. MATCH-3 DESIGN DOCUMENT

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

Match-3 là gameplay activity có chiều sâu, có PvE trước và PvP sau.

## Board

MVP 8x8 hoặc 7x8; tile type được cấu hình bằng data. Board generation phải kiểm tra playable state.

## Core rules

- Swap adjacent tiles
- Match 3+
- Clear
- Cascade
- Special tile
- Combo
- Turn/action resolution

## Special tiles

- Line clear
- Area clear
- Color clear
- Hybrid combination

## PvE

Enemy có HP, attack pattern và mechanic. Hoàn thành battle cho reward và progression.

## PvP

Server authoritative; hai người chơi tạo áp lực lên nhau thông qua damage/obstacle/score tùy mode.

## Difficulty

Difficulty table điều chỉnh board modifiers, enemy stats, move count, objective và reward.

## Anti-cheat

Client gửi action hợp lệ; server xác thực board state, turn, cooldown và reward.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
