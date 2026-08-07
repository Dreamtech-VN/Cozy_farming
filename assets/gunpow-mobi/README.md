# GunPow Mobi — asset trích xuất

Nội dung trong thư mục này được trích ra từ asset `Server.7z` của release
[`Test`](https://github.com/Dreamtech-VN/Cozy_farming/releases/tag/Test).

> **Lưu ý:** đây là asset của **GunPow Mobi** (game Cocos2d-x, bản địa hoá tiếng Việt),
> không phải của Cozy Farming. Giữ ở đây làm tài liệu tham khảo.

## Nguồn gốc

`Server.7z` (1.17 GB, AES-256) không chứa asset trực tiếp — bên trong là một
máy ảo VMware:

| File | Kích thước |
|---|---|
| `Server/GunPowM PGaming.vmdk` | 3.74 GB (ổ đĩa ảo 60 GB, `monolithicSparse`) |
| `Server/GunPowM PGaming.vmx` | 3 082 B |

VM chạy CentOS 7, đĩa dùng LVM (VG `centos`: `root` 35.6 G, `home` 17.4 G,
`swap` 6 G), filesystem XFS. Asset nằm trong LV `home`, gồm hai phần:

- `/home/ddd2/` — game server Java (channel, s1, redis cluster)
- `/home/www/` — web portal PHP (đăng ký, nạp thẻ, giftcode, admin) kèm các gói
  cập nhật client

Các gói `/home/www/update/{android,ios}/*.zip` chính là **asset client game**;
chúng đã được giải nén sẵn vào `client/` bên dưới.

### Cách trích xuất

```sh
7z x -p<password> Server.7z                       # giải nén VM
qemu-img convert -O raw "GunPowM PGaming.vmdk" disk.raw
# LV home: offset 7518289920, size 18668847104 (tính từ metadata LVM)
# XFS đọc bằng dissect.xfs (kernel container không có module xfs)
```

## Cấu trúc

```
client/                 asset client game (đã giải nén từ các gói update)
  android/              resources/, resources_vn/ — .pkm, .lua, .atlas, .json, .plist
  ios/                  resources/, resources_vn/ — .dat
server/                 config + script + jar của game server
  channel/              channelserver, ipdmain
  s1/                   battleManage, battleServer, chatServer, dispatchServer,
                        friendServer, playerServer, roomServer, transactionServer,
                        worldServer
  serverLib/            cache.jar, empirenetprotocol.jar, netprotocol.jar, reloadserver.jar
  redis/                file cấu hình cluster (gameredis 8091-9094, ipdredis 8071-9074)
web/                    mã nguồn portal PHP + tài nguyên giao diện
MANIFEST.tsv            danh sách đầy đủ: đường dẫn, kích thước, SHA-256
```

Tổng cộng **4 796 file / 109.3 MB**.

| Loại | Số file | Dung lượng |
|---|---:|---:|
| `.dat` (data client iOS) | 2 003 | 39.34 MB |
| `.pkm` (texture ETC1) | 1 536 | 36.33 MB |
| `.xml` | 921 | 10.63 MB |
| `.jar` (server game) | 15 | 6.36 MB |
| `.js` | 34 | 1.27 MB |
| `.json` (armature/Spine) | 18 | 0.88 MB |
| `.lua` (logic + bảng số liệu) | 6 | 10.19 MB |
| còn lại | 263 | 4.30 MB |

## Đã lược bỏ

Những phần sau **không** được đưa vào repo:

| Nội dung | Dung lượng | Lý do |
|---|---:|---|
| `ddd2/redis/*/data/*.aof`, `*.rdb` | ~72 MB | dữ liệu runtime, chứa dữ liệu người chơi |
| `ddd2/lib/*.jar` | ~32 MB | thư viện Maven bên thứ ba (Spring, Hibernate, …) |
| `redis-server`, `redis-cli` | ~21 MB | binary Redis chuẩn |
| `*.log`, `*.pid` | ~1.5 MB | log và pid runtime |
| `www/update/*/*.zip` | ~33 MB | trùng nội dung — đã giải nén vào `client/` |
| Phần còn lại của LV `root` | — | hệ điều hành CentOS 7, không phải asset |

## Credentials đã che

Các file cấu hình gốc chứa mật khẩu ở dạng plaintext. **33 dòng** đã được thay
bằng `__REDACTED__` trước khi commit, gồm:

- mật khẩu MySQL `root`
- mật khẩu Redis và `serverpassword` giữa các server
- mật khẩu SMTP
- `merchant_id` / `api_user` / `api_password` của cổng thanh toán GameBank
- 8 `secret_key` của các kênh phát hành
- mã GM của portal

Xem `MANIFEST.tsv` để đối chiếu checksum. Bản gốc chưa che vẫn nằm trong file
release — repo này là public, nên **cần đổi toàn bộ mật khẩu trên và cân nhắc
gỡ release `Test`**.
