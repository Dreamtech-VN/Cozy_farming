# 10. MONETIZATION DESIGN

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Nguyên tắc

Ưu tiên cosmetic, convenience và content; bảo vệ tính công bằng của PvP.

## Products

- Outfit
- Pet cosmetic
- Emote
- Furniture
- Battle Pass
- Starter pack
- Premium currency
- Subscription/VIP nếu phù hợp

## Ads

Rewarded ads chỉ dùng cho phần thưởng tùy chọn; không làm gián đoạn gameplay core quá mức.

## Purchase flow

- Client request
- Store receipt
- Server validation
- Grant transaction
- Idempotency check
- Audit log

## Anti-fraud

Không grant item chỉ dựa trên client callback; mọi giao dịch phải có transaction ID và trạng thái server.

## Metrics

- Conversion
- ARPPU
- ARPU
- LTV
- Refund
- Purchase failure
- Offer performance

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
