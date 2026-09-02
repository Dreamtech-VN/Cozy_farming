# 15. API SPECIFICATION

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Auth

- POST /v1/auth/login
- POST /v1/auth/refresh
- POST /v1/auth/logout

## Player

- GET /v1/player/profile
- PATCH /v1/player/profile
- GET /v1/player/inventory

## World

- GET /v1/maps
- GET /v1/maps/{mapId}
- POST /v1/maps/{mapId}/enter

## Farm

- GET /v1/farm
- POST /v1/farm/plant
- POST /v1/farm/harvest

## Match-3

- POST /v1/matches
- POST /v1/matches/{id}/actions
- POST /v1/matches/{id}/finish

## Social

- GET /v1/friends
- POST /v1/friends/requests
- POST /v1/friends/{id}/accept
- POST /v1/chat/messages

## API rules

- Versioned routes
- JWT/session auth
- Idempotency keys for grants/purchases
- Validation
- Rate limit
- Standard error envelope

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
