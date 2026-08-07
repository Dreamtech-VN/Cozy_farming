# GunPow Mobi — asset client

Asset client game trích ra từ `Server.7z` của release
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
`swap` 6 G), filesystem XFS. Asset nằm trong LV `home`, ở các gói cập nhật
client `/home/www/update/{android,ios}/*.zip` — bốn gói này đã được giải nén
vào `client/` bên dưới.

### Cách trích xuất

```sh
7z x -p<password> Server.7z                       # giải nén VM
qemu-img convert -O raw "GunPowM PGaming.vmdk" disk.raw
# LV home: offset 7518289920, size 18668847104 (tính từ metadata LVM)
# XFS đọc bằng dissect.xfs (kernel container không có module xfs)
```

## Cấu trúc

```
client/
  android/
    resources/       lua
    resources_vn/    armatures/, image/, lua/
  ios/
    resources/       dat
    resources_vn/    dat/
MANIFEST.tsv         danh sách đầy đủ: đường dẫn, kích thước, SHA-256
```

Cây thư mục giữ nguyên như trong gói update — đây là đường dẫn game dùng để
load asset lúc chạy, đổi đi thì file mất ngữ cảnh.

Tổng cộng **4 490 file / 95.9 MB**, file lớn nhất 5.25 MB.

| Loại | Số file | Dung lượng |
|---|---:|---:|
| `.dat` (data client iOS) | 2 003 | 39.34 MB |
| `.pkm` (texture ETC1) | 1 536 | 36.33 MB |
| `.xml` | 904 | 8.99 MB |
| `.lua` (logic + bảng số liệu) | 6 | 10.29 MB |
| `.json` (armature/Spine) | 18 | 0.88 MB |
| `.atlas`, `.plist`, còn lại | 23 | 0.05 MB |

Ảnh dùng định dạng ETC1 (`.pkm`), kênh alpha tách riêng thành file
`*_alpha.pkm` đi kèm.

## Không đưa vào repo

Máy ảo còn nhiều thứ khác, nhưng chúng không phải asset nên bị bỏ:

| Nội dung | Dung lượng | Lý do |
|---|---:|---|
| `ddd2/` — game server Java | ~48 MB | mã và config server, không phải asset |
| `www/` — portal PHP | ~5 MB | web đăng ký / nạp thẻ, kèm thư viện frontend bên thứ ba |
| `redis/*/data/*.aof`, `*.rdb` | ~72 MB | dữ liệu runtime, chứa dữ liệu người chơi |
| `www/update/*/*.zip` | ~33 MB | trùng nội dung — đã giải nén vào `client/` |
| LV `root` | — | hệ điều hành CentOS 7 |

## ⚠️ Credentials trong file release

Các file cấu hình trong máy ảo chứa mật khẩu plaintext — mật khẩu MySQL `root`,
Redis, `serverpassword` giữa các server, SMTP, thông tin cổng thanh toán
GameBank, secret_key các kênh phát hành và mã GM portal.

Những file đó **không** nằm trong repo này. Nhưng bản gốc vẫn tải công khai
được từ release `Test`, nên cần đổi toàn bộ mật khẩu trên và cân nhắc gỡ
release xuống.
