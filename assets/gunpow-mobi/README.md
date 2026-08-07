# GunPow Mobi — asset client

Asset client game trích ra từ `Server.7z` của release
[`Test`](https://github.com/Dreamtech-VN/Cozy_farming/releases/tag/Test).

> **Lưu ý:** đây là asset của **GunPow Mobi** (tên gốc 弹弹岛2, game Cocos2d-x,
> bản địa hoá tiếng Việt), không phải của Cozy Farming. Giữ ở đây làm tài liệu
> tham khảo.

> **Đây chỉ là bản vá, không phải game đầy đủ.** File manifest ghi
> `installversion = "1.0.0"` và hai gói `1.1.1`, `1.1.2` — tức những gì có ở đây
> là bản vá, còn bản cài gốc 1.0.0 **không nằm trong máy ảo** (không có `.apk`,
> `.ipa` hay `.obb` nào). Đối chiếu đường dẫn tài nguyên mà mã Lua gọi tới với
> file thực có: **3 737/3 908 đường dẫn bị thiếu (96%)**, gồm toàn bộ art nhân
> vật — `battle/head` (ảnh nhân vật, quái, boss), `ui/card` (thẻ nhân vật),
> `battle/pet_card` (thú cưng), `shopitems` (icon vật phẩm, 1 752 file) và
> `battle/map` (bản đồ trận). Ảnh trong `client-png/` chỉ là ảnh giao diện được
> thay ở hai bản vá đó — tất cả đều nằm dưới `image/ui/`.
>
> Muốn có art nhân vật thì cần thêm file cài đặt gốc bản 1.0.0. Ngược lại, **bảng
> số liệu game thì đầy đủ** trong `client-lua/` (`LocalData*.lua`): thông số kỹ
> năng, phụ bản, trang bị, thú cưng kèm tên tiếng Việt.

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
client/              nguyên trạng như trong gói update
  android/
    resources/       lua
    resources_vn/    armatures/, image/, lua/
  ios/
    resources/       dat
    resources_vn/    dat/
client-png/          768 ảnh PNG bung ra từ .pkm (xem bên dưới)
client-lua/          2 010 file mã nguồn Lua đã giải mã (xem bên dưới)
MANIFEST.tsv         danh sách đầy đủ: đường dẫn, kích thước, SHA-256
```

`client/` giữ nguyên cây thư mục gốc — đây là đường dẫn game dùng để load asset
lúc chạy, đổi đi thì file mất ngữ cảnh. `client-png/` và `client-lua/` soi
gương đúng cấu trúc đó, chỉ khác phần mở rộng.

Tổng cộng **7 268 file / 175.6 MB**, file lớn nhất 5.25 MB.

| Loại | Số file | Dung lượng | |
|---|---:|---:|---|
| `.dat` (Lua mã hoá, iOS) | 2 003 | 39.34 MB | `client/` |
| `.pkm` (texture ETC1) | 1 536 | 36.33 MB | `client/` |
| `.xml` (bố cục giao diện) | 904 | 8.99 MB | `client/` |
| `.lua` (mã hoá, Android) | 6 | 10.29 MB | `client/` |
| `.json` (armature/Spine) | 18 | 0.88 MB | `client/` |
| `.atlas`, `.plist`, còn lại | 23 | 0.05 MB | `client/` |
| `.png` (bung từ `.pkm`) | 768 | 30.15 MB | `client-png/` |
| `.lua` + `.xml` (đã giải mã) | 2 010 | 49.60 MB | `client-lua/` |

## Ảnh: `.pkm` và bản PNG

Ảnh trong game dùng **ETC1** — định dạng nén texture cho GPU Android. File
`.pkm` chỉ là vỏ chứa mỏng: header 16 byte (`"PKM "`, version `10`, kích thước
thật và kích thước đã đệm lên bội số 4) rồi tới dữ liệu ETC1. ETC1 nén mỗi khối
4×4 pixel xuống 64 bit — cố định 4 bit/pixel, tức 6:1 so với RGB888.

ETC1 **không lưu được kênh alpha**, nên độ trong suốt được tách ra một texture
ETC1 thứ hai dạng xám, đặt tên `*_alpha.pkm`, và ghép lại trong shader lúc vẽ.
Vì vậy 1 536 file `.pkm` thực chất chỉ là **768 ảnh**: 768 file màu + 768 file
alpha, ghép cặp đủ 768/768.

`client-png/` là 768 ảnh đó đã bung sẵn thành PNG có alpha, để xem trực tiếp
trên GitHub mà không cần công cụ. Cách tạo lại:

```python
import struct, texture2ddecoder, PIL.Image          # pip install texture2ddecoder pillow

def load(path):                                      # .pkm -> PIL.Image
    raw = open(path, 'rb').read()
    fmt, ew, eh, w, h = struct.unpack('>HHHHH', raw[6:16])
    dec = texture2ddecoder.decode_etc1(raw[16:], ew, eh)   # trả về BGRA
    return PIL.Image.frombytes('RGBA', (ew, eh), dec, 'raw', 'BGRA').crop((0, 0, w, h))

img = load('x.pkm')
img.putalpha(load('x_alpha.pkm').split()[0])         # kênh nào cũng được, R=G=B
img.save('x.png')
```

Lưu ý PNG ở đây **không** phải bản gốc trước khi nén — ETC1 nén mất dữ liệu, nên
đây là ảnh đã qua nén rồi giải nén. Dùng để xem và tham khảo, không dùng để
chỉnh sửa rồi nén lại.

## Mã Lua: cách giải mã

Toàn bộ mã nguồn Lua đều bị mã hoá — cả `.dat` phía iOS lẫn `.lua` phía Android
(file `.lua` trong `client/` mở ra là dữ liệu nhị phân, không phải mã nguồn).

Cách mã hoá là **XOR với khoá lặp 10 byte**, cộng thêm **13 byte đuôi** gắn sau
khi mã hoá — 12 byte cuối là dấu hiệu cố định `7b5b59440b0c0b5759445d7d`, giống
nhau ở mọi file. Không phải một khoá dùng chung: có **29 khoá khác nhau**, mỗi
khoá dùng cho một nhóm file.

Khoá được khôi phục bằng phân tích tần suất — độ dài khoá suy từ index of
coincidence (đỉnh rõ ở 10), rồi từng byte khoá chọn theo mô hình tần suất byte
dựng từ các file đã giải đúng. Mỗi kết quả được xác minh bằng `luac5.1 -p`:

```python
TRAILER = bytes.fromhex('7b5b59440b0c0b5759445d7d')
body = raw[:-13] if raw.endswith(TRAILER) else raw
plain = bytes(c ^ key[i % 10] for i, c in enumerate(body))
```

Danh sách 29 khoá nằm trong `keys.json`.

Kết quả: **2 009 file Lua qua được `luac5.1 -p` (0 lỗi)** và 1 file XML
(`ddd_bw.xml` — cấu hình vũ khí) parse được bằng trình đọc XML.

Vài điểm khi đọc:

- Chú thích trong mã là **tiếng Trung**; 2 006 file dùng UTF-8, riêng 3 file
  (`utils`, `DownloadManager`, `WndKidServantData`) dùng **GBK**.
- Chuỗi hiển thị đã bản địa hoá tiếng Việt — xem `LocalStrings.lua`.
- Bảng số liệu game nằm ở `LocalData*.lua` (kỹ năng, phụ bản, trang bị…), được
  xuất ra từ file Excel, đường dẫn gốc còn nguyên ở dòng đầu mỗi file.
- Bản Android và iOS là **cùng một mã nguồn**, chỉ khác khoá mã hoá.

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
