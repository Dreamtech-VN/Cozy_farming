# 21. DEVOPS & INFRASTRUCTURE

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Environments

- Local
- Development
- Staging
- Production

## CI/CD

- Lint
- Unit tests
- Build client
- Build server
- Schema validation
- Deploy staging
- Smoke tests
- Production approval

## Infrastructure

- Load balancer/API gateway
- Game services
- Realtime service
- Database
- Redis/cache
- Object storage/CDN
- Monitoring

## Backup

Database backup định kỳ, point-in-time recovery nếu hạ tầng hỗ trợ, kiểm tra restore định kỳ.

## Deployment

Blue/green hoặc rolling deployment cho backend; version compatibility giữa client/server phải được kiểm soát.

## Incident

- Alert
- Triage
- Mitigation
- Rollback
- Communication
- Postmortem

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
