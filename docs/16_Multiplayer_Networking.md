# 16. MULTIPLAYER & NETWORKING DESIGN

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Model

Server-authoritative for persistent game state; realtime channel for presence, movement snapshots, chat and map events.

## Map instance

Public maps can be partitioned into instances with player capacity. Private farm/home uses owner-based instance.

## Movement

Client predicts local movement; server validates bounds/collision and broadcasts authoritative state.

## Presence

- Join
- Leave
- Heartbeat
- Reconnect
- AFK
- Visibility

## Reconnect

Client requests snapshot; server restores player state and map presence.

## PvP

Battle server owns board state and validates every action. Disconnect policy and result settlement must be deterministic.

## Load

Use load tests for concurrent map users, websocket connections, chat bursts and Match-3 actions.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
