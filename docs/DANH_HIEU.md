# Danh hiệu

Toàn bộ danh hiệu đang có trong game: **35** cái, đã có ảnh nhãn: **1**.

## Làm ảnh nhãn cho một danh hiệu

1. Xuất PNG nền trong suốt, **cao 72px**, dài tuỳ chữ (mẫu `ti_seeder.png` là 423×72).
2. Đặt tên file đúng bằng cột `id` rồi bỏ vào `public/assets/title/`.
3. Mở `src/data/quests.ts`, thêm `art: true` vào cuối dòng của danh hiệu đó.

Chưa có ảnh thì game tự vẽ nhãn tạm bằng canvas theo màu ở cột Màu, không vỡ giao diện.

Nhãn hiện ở 3 chỗ: trên đầu nhân vật ngoài map, khung trái màn Nhân vật, và bảng Danh hiệu.

## Nhà Nông

| id (tên file) | Tên hiển thị | Màu | Điều kiện nhận | Đã có ảnh |
|---|---|---|---|:-:|
| `ti_seeder` | Người Gieo Mầm | `#8ce99a` | Trồng 200 hạt giống. | ✅ |
| `ti_farmer` | Nông Dân Chăm Chỉ | `#8ce99a` | Thu hoạch 100 nông sản. |  |
| `ti_harvest_king` | Mùa Vàng | `#ffd43b` | Thu hoạch 1.000 nông sản. |  |
| `ti_farm_king` | Vua Nông Trại | `#ffa94d` | Thu hoạch 5.000 nông sản. |  |
| `ti_woodman` | Tiều Phu | `#b08968` | Chặt 200 cây lấy gỗ. |  |

## Cần Thủ

| id (tên file) | Tên hiển thị | Màu | Điều kiện nhận | Đã có ảnh |
|---|---|---|---|:-:|
| `ti_angler` | Cần Thủ | `#66d9e8` | Câu được 50 con cá. |  |
| `ti_angler_pro` | Tay Câu Cứng | `#3bc9db` | Câu được 500 con cá. |  |
| `ti_fish_king` | Ngư Ông Đắc Lợi | `#22b8cf` | Câu được 2.000 con cá. |  |
| `ti_fish_master` | Bậc Thầy Câu Cá | `#15aabf` | Sưu tập đủ 30 loài cá. |  |
| `ti_pond` | Chủ Ao | `#4dabf7` | Vớt 200 con cá nuôi. |  |

## Chăn Nuôi

| id (tên file) | Tên hiển thị | Màu | Điều kiện nhận | Đã có ảnh |
|---|---|---|---|:-:|
| `ti_herder` | Người Chăn Nuôi | `#ffd8a8` | Cho vật nuôi ăn 200 lần. |  |
| `ti_rancher` | Chủ Trại | `#e8b04b` | Thu 500 sản phẩm từ vật nuôi. |  |

## Bếp Núc

| id (tên file) | Tên hiển thị | Màu | Điều kiện nhận | Đã có ảnh |
|---|---|---|---|:-:|
| `ti_chef` | Đầu Bếp | `#ff922b` | Nấu xong 300 món ăn. |  |
| `ti_courier` | Người Giao Hàng | `#b197fc` | Giao xong 30 đơn hàng. |  |
| `ti_shopkeep` | Chủ Tiệm Uy Tín | `#9775fa` | Giao xong 300 đơn hàng. |  |
| `ti_trader` | Con Buôn | `#f783ac` | Bán 2.000 vật phẩm. |  |

## Khéo Tay

| id (tên file) | Tên hiển thị | Màu | Điều kiện nhận | Đã có ảnh |
|---|---|---|---|:-:|
| `ti_smith` | Thợ Mài | `#ced4da` | Nâng cấp công cụ 20 lần. |  |
| `ti_forge_master` | Tay Nghề Cứng | `#ff6b6b` | Nâng cấp công cụ 100 lần. |  |
| `ti_starman` | Được Mùa Được Giá | `#ffe066` | Bán 1.000 nông sản. |  |
| `ti_chest` | Ăn Khế Trả Vàng | `#ffc078` | Rung cây khế 200 lần. |  |

## Giải Trí

| id (tên file) | Tên hiển thị | Màu | Điều kiện nhận | Đã có ảnh |
|---|---|---|---|:-:|
| `ti_social` | Quảng Giao | `#faa2c1` | Kết bạn với 10 người. |  |
| `ti_gifter` | Trao Yêu Thương | `#ff8787` | Tặng 100 món quà. |  |
| `ti_gamer` | Cao Thủ Mini Game | `#a9e34b` | Thắng 50 ván mini game. |  |
| `ti_caro` | Kỳ Thủ Caro | `#94d82d` | Thắng 30 ván cờ caro. |  |
| `ti_party` | Chủ Tiệc | `#ff8787` | Tổ chức 10 bữa tiệc. |  |

## Tổ Ấm

| id (tên file) | Tên hiển thị | Màu | Điều kiện nhận | Đã có ảnh |
|---|---|---|---|:-:|
| `ti_homeowner` | Chủ Nhà | `#74c0fc` | Mua nhà riêng. |  |
| `ti_mansion` | Nhà Cao Cửa Rộng | `#4dabf7` | Nâng cấp nhà 3 lần. |  |
| `ti_decor` | Tay Bày Biện | `#66d9e8` | Đặt 50 món nội thất. |  |
| `ti_veteran` | Kỳ Cựu | `#ffd43b` | Đạt cấp 30. |  |

## Sưu Tập

| id (tên file) | Tên hiển thị | Màu | Điều kiện nhận | Đã có ảnh |
|---|---|---|---|:-:|
| `ti_fashion` | Tín Đồ Thời Trang | `#f06595` | Sắm 50 món thời trang. |  |
| `ti_skinner` | Nhà Sưu Tầm Ảo Hoá | `#cc5de8` | Sở hữu 5 bộ skin. |  |
| `ti_titled` | Danh Gia Vọng Tộc | `#ffa94d` | Mở khoá 20 danh hiệu. |  |
| `ti_millionaire` | Triệu Phú | `#ffd43b` | Kiếm được tổng cộng 1.000.000 xu. |  |

## Mặc định

| id (tên file) | Tên hiển thị | Màu | Điều kiện nhận | Đã có ảnh |
|---|---|---|---|:-:|
| `title_newbie` | Tân binh | `#9aa5b1` | Có sẵn khi tạo nhân vật. |  |

## Nhiệm vụ

| id (tên file) | Tên hiển thị | Màu | Điều kiện nhận | Đã có ảnh |
|---|---|---|---|:-:|
| `title_homeowner` | Chủ nhà | `#74c0fc` | Hoàn thành nhiệm vụ "An cư lạc nghiệp" — mua nhà riêng ở Thành phố. |  |

