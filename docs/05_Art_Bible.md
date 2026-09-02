# 05. ART BIBLE

> 2D Social MMO – Farming + Social + Match-3

Version 0.1 • 2026-09-02

## Document Control

| Project | 2D Social MMO – Farming + Social + Match-3 |
| --- | --- |
| Version | 0.1 |
| Status | Draft / Living Document |
| Owner | Game Production |
| Update rule | Mọi thay đổi hệ thống phải cập nhật tài liệu và changelog tương ứng. |

## Art direction

2D chibi side-view, thân thiện, màu sắc rõ, silhouette dễ nhận biết, môi trường có nhiều lớp chiều sâu nhưng vẫn đọc được gameplay.

## Character rules

- Tỷ lệ đầu/thân thống nhất.
- Các layer phải khớp anchor.
- Animation có timing nhất quán.
- Không để accessory che mặt nếu không chủ ý.

## Environment

Map dùng tile/prop modular; foreground, midground, background tách lớp. Collision và visual phải được quản lý riêng.

## UI

UI đồng nhất với thế giới 2D: icon rõ, typography dễ đọc trên mobile, trạng thái button đầy đủ.

## Asset pipeline

- Source
- Review
- Export
- Atlas
- Import
- Validation
- Build

## Quality gates

Không asset nào vào production nếu thiếu ID, metadata, thumbnail/reference, kích thước chuẩn hoặc collision/anchor cần thiết.

## Nguyên tắc mở rộng

Tài liệu này là living document. Khi thêm hệ thống hoặc content mới, phải xác định ID/data schema, dependencies, nguồn/sink tài nguyên, client/server ownership, analytics events, QA cases và tác động tới LiveOps.

## Changelog

| Version | Date | Change |
| --- | --- | --- |
| 0.1 | 2026-09-02 | Initial project documentation baseline. |
