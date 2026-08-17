# MyZoo — Hướng dẫn setup toàn bộ: server local (VSCode) → server VPS → client Unity

Đọc theo thứ tự: **Phần A** chạy server trên máy mình bằng VSCode, **Phần B** đưa server lên VPS, **Phần C** build client Unity và nối vào server.

Nguyên tắc xuyên suốt: server là nguồn sự thật duy nhất — client chỉ gửi ý định và vẽ kết quả, không tự tính tiền/thời gian/thưởng.

---

# PHẦN A — Server local bằng VSCode

## A1. Cài công cụ (1 lần)

| Công cụ | Windows | macOS | Ubuntu/Debian |
|---|---|---|---|
| **JDK 21** | [Adoptium Temurin 21](https://adoptium.net) (chọn .msi, tick "Set JAVA_HOME") | `brew install temurin@21` | `sudo apt install openjdk-21-jdk` |
| **Maven** | Tải [maven.apache.org](https://maven.apache.org/download.cgi), giải nén, thêm `bin` vào PATH — hoặc `choco install maven` | `brew install maven` | `sudo apt install maven` |
| **Git** | [git-scm.com](https://git-scm.com) | có sẵn | `sudo apt install git` |
| **VSCode** | [code.visualstudio.com](https://code.visualstudio.com) | như bên | như bên |

Kiểm tra: mở terminal mới, chạy `java -version` (phải ra 21.x) và `mvn -version`.

## A2. Mở project trong VSCode

1. Clone repo:
   ```bash
   git clone https://github.com/Dreamtech-VN/Cozy_farming.git
   cd Cozy_farming
   ```
2. Mở VSCode: `code .` (hoặc File → Open Folder).
3. VSCode sẽ gợi ý cài **Extension Pack for Java** (repo đã khai báo trong `.vscode/extensions.json`) — bấm Install. Đợi góc dưới phải hết quay (Java Language Server load project Maven trong `server/`).

## A3. Chạy server — 3 cách, chọn 1

**Cách 1 — nút Run của VSCode (khuyên dùng khi dev):**
Mở `server/src/main/java/vn/dreamtech/myzoo/server/Main.java` → bấm nút **Run** phía trên hàm `main` (hoặc F5 để Debug — đặt breakpoint được). Cấu hình sẵn trong `.vscode/launch.json`.

**Cách 2 — Task VSCode:**
`Ctrl+Shift+B` (⇧⌘B trên Mac) chạy task **Build server (mvn package)**. Menu Terminal → Run Task có thêm **Test server** và **Chạy server (jar)**.

**Cách 3 — terminal thuần:**
```bash
cd server && mvn package          # lần đầu hơi lâu vì tải dependency
cd .. && java -jar server/target/myzoo-server-0.1.0-SNAPSHOT.jar
```

Server chạy tại **http://localhost:8080**. Không cần cài database — H2 tự tạo file `myzoo-data.mv.db` cạnh chỗ chạy lệnh và tự dựng schema.

## A4. Kiểm tra server sống

```bash
curl http://localhost:8080/health
# {"status":"ok"}
```

Mở trình duyệt vào `http://localhost:8080` — có sẵn **client web mẫu** (đầy đủ farm/zoo/minigame). Dùng nó làm chuẩn đối chiếu hành vi khi client Unity của bạn có gì đó sai.

Biến môi trường tuỳ chọn: `SERVER_PORT` (mặc định 8080) · `CLIENT_DIR` (thư mục client web, mặc định `client`) · `DB_URL`/`DB_USER`/`DB_PASSWORD` (chuyển sang MySQL) · `VOICE_DIR` (thư mục chứa file ghi âm của chat, mặc định `myzoo-voice` cạnh chỗ chạy server — trên VPS nên trỏ vào ổ có backup).

Reset sạch dữ liệu dev: tắt server, xoá `myzoo-data.mv.db`, chạy lại.

## A5. Chạy test

```bash
cd server && mvn test    # 50 test, dùng H2 in-memory + fake time, chạy trong vài giây
```

---

# PHẦN B — Đưa server lên VPS

Hướng dẫn cho VPS Ubuntu 22.04/24.04 (DigitalOcean, Vultr, AWS Lightsail, Viettel/FPT Cloud... đều như nhau). Gói 1 CPU / 1GB RAM là dư cho giai đoạn test.

## B1. Kết nối VPS bằng VSCode (Remote-SSH)

1. Cài extension **Remote - SSH** (đã nằm trong recommendations của repo).
2. `Ctrl+Shift+P` → **Remote-SSH: Connect to Host** → nhập `user@ip-vps` (lần đầu chọn Add New Host để lưu).
3. Cửa sổ VSCode mới mở ra chính là VPS — terminal, file explorer đều thao tác trực tiếp trên VPS. Các bước dưới gõ trong terminal đó (hoặc SSH thường cũng được).

## B2. Chuẩn bị VPS (1 lần)

```bash
# 1. Cài Java runtime (chỉ cần JRE nếu build ở máy local)
sudo apt update && sudo apt install -y openjdk-21-jre-headless

# 2. Tạo user riêng + thư mục
sudo useradd -r -m -d /opt/myzoo myzoo
sudo mkdir -p /opt/myzoo/client
sudo chown -R myzoo:myzoo /opt/myzoo

# 3. Firewall: mở SSH + cổng game (hoặc chỉ 80/443 nếu dùng Nginx ở B5)
sudo ufw allow OpenSSH
sudo ufw allow 8080/tcp
sudo ufw enable
```

## B3. Cài service systemd (1 lần)

File mẫu có sẵn trong repo tại `ops/myzoo.service`:

```bash
sudo cp ops/myzoo.service /etc/systemd/system/myzoo.service
sudo systemctl daemon-reload
sudo systemctl enable myzoo
```

Service tự chạy lại khi crash và tự khởi động cùng VPS. Sửa cổng/DB bằng cách edit file service rồi `sudo systemctl daemon-reload && sudo systemctl restart myzoo`.

Cho phép user deploy restart service không cần mật khẩu (thay `ten-user` bằng user SSH của bạn):

```bash
echo 'ten-user ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart myzoo' | sudo tee /etc/sudoers.d/myzoo
```

## B4. Deploy — mỗi lần cập nhật code

**Cách 1 — script có sẵn (build ở máy local, đẩy jar lên):**

```bash
./ops/deploy.sh user@ip-vps
```

Script build jar, scp lên VPS, rsync thư mục `client/`, restart service và tự gọi `/health` xác nhận sống. (Windows: chạy trong Git Bash hoặc WSL.)

**Cách 2 — build ngay trên VPS:**

```bash
sudo apt install -y maven git
git clone https://github.com/Dreamtech-VN/Cozy_farming.git && cd Cozy_farming
mvn -f server/pom.xml -DskipTests package
sudo cp server/target/myzoo-server-*-SNAPSHOT.jar /opt/myzoo/myzoo-server.jar
sudo cp -r client/* /opt/myzoo/client/
sudo systemctl restart myzoo
```

**Kiểm tra:**

```bash
systemctl status myzoo               # phải là active (running)
curl http://localhost:8080/health    # trên VPS
journalctl -u myzoo -f               # xem log realtime
```

Từ máy ngoài: mở `http://ip-vps:8080` — thấy client web là thành công.

## B5. (Khuyên dùng khi ra mắt) HTTPS bằng Nginx + Certbot

Cần 1 domain trỏ A record về IP VPS. Sau đó:

```bash
sudo apt install -y nginx certbot python3-certbot-nginx

sudo tee /etc/nginx/sites-available/myzoo <<'NGINX'
server {
    listen 80;
    server_name game.ten-mien-cua-ban.com;
    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
NGINX
sudo ln -s /etc/nginx/sites-available/myzoo /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

sudo certbot --nginx -d game.ten-mien-cua-ban.com   # tự cài chứng chỉ + tự gia hạn
```

Xong thì đóng cổng 8080 với bên ngoài (`sudo ufw delete allow 8080/tcp`, thêm `sudo ufw allow 'Nginx Full'`) — client trỏ vào `https://game.ten-mien-cua-ban.com`, hết cần nới HTTP cleartext trên mobile.

## B6. (Tuỳ chọn) Chuyển H2 → MySQL cho production

H2 file đủ cho dev/test nhỏ. Khi cần MySQL:

```bash
sudo apt install -y mysql-server
sudo mysql -e "CREATE DATABASE myzoo CHARACTER SET utf8mb4;
CREATE USER 'myzoo'@'localhost' IDENTIFIED BY 'doi-mat-khau-nay';
GRANT ALL ON myzoo.* TO 'myzoo'@'localhost';"
```

Bỏ comment 3 dòng `DB_*` trong `/etc/systemd/system/myzoo.service`, sửa mật khẩu, rồi `sudo systemctl daemon-reload && sudo systemctl restart myzoo`. Schema tự tạo khi boot, không cần chạy SQL tay. (Dữ liệu H2 cũ không tự chuyển — làm việc này trước khi có người chơi thật.)

---

# PHẦN C — Build client Unity và nối server

## C1. Tạo project

- **Unity 6 LTS (6000.0.x)** hoặc 2022.3 LTS (client cũ của repo từng dùng 2022.3.21f1). Template **2D**.
- Player Settings → Resolution and Presentation: chỉ tick **Landscape Left + Landscape Right** (game màn hình ngang, thiết kế gốc 960×540, tỉ lệ 16:9).
- Không cần package nào — dùng `UnityWebRequest` + `JsonUtility` có sẵn (API trả mảng thay vì map khoá động nên `JsonUtility` đọc được hết).
- **Nhanh nhất: dùng project dựng sẵn** tại `unity-client/` — xem `unity-client/README.md`, copy `Assets` vào project mới rồi bấm menu **MyZoo → Dựng scene**.

## C2. BASE_URL theo môi trường

| Client chạy ở đâu | BASE_URL |
|---|---|
| Unity Editor / build PC, server local | `http://localhost:8080` |
| Android Emulator, server local | `http://10.0.2.2:8080` (KHÔNG phải localhost) |
| iOS Simulator, server local | `http://localhost:8080` |
| Điện thoại thật cùng Wi-Fi với máy dev | `http://<IP LAN máy dev>:8080` (xem IP: `ipconfig`/`ifconfig`) |
| **VPS phần B** | `http://ip-vps:8080` — hoặc `https://game.ten-mien-cua-ban.com` nếu đã làm B5 |

Dev bằng HTTP thì phải nới cleartext:
- **Android**: Player Settings → Other Settings → **Allow downloads over HTTP: Always**.
- **iOS**: sau khi build ra Xcode, thêm vào Info.plist: `NSAppTransportSecurity` → `NSAllowsArbitraryLoads = YES`.
- Đã có HTTPS (B5) thì bỏ qua bước này.

Đặt BASE_URL ở 1 nơi duy nhất (field trên component hoặc ScriptableObject config) để đổi local ↔ VPS không phải sửa code.

## C3. Ba quy ước bắt buộc của API

1. **Đăng nhập** — 3 cách, cách nào cũng trả về `sessionToken`:
   - Khách: `POST /v1/auth/guest {guestToken?}` → thêm `guestToken` (credential thiết bị, **lưu PlayerPrefs** để tự vào lại và để nâng cấp tài khoản sau).
   - Đăng ký: `POST /v1/auth/register {username, password, guestToken?}` — gửi kèm `guestToken` để giữ nguyên tiến độ đang chơi khách.
   - Đăng nhập: `POST /v1/auth/login {username, password}`.
2. **Header `X-Session-Token`** gắn vào mọi request sau đăng nhập (header cũ `X-Guest-Token` vẫn được chấp nhận cho token thiết bị). Thiếu/sai → 401.
3. **`requestId` idempotent**: mọi POST thay đổi dữ liệu gửi kèm `"requestId": "<GUID>"`. Rớt mạng → gửi lại **y nguyên body cũ** (cùng GUID): server trả đúng response cũ, không bao giờ trừ tiền/cộng thưởng 2 lần. Hành động mới mới sinh GUID mới.

## C4. Bảng endpoint

JSON camelCase, timestamp là **epoch milliseconds**, lỗi trả `{"error": "thông báo tiếng Việt"}` — hiển thị thẳng cho người chơi được.

| Method & path | Body (ngoài requestId) | Trả về / ghi chú |
|---|---|---|
| `GET /v1/config` | — | `gameVersion, minClientVersion, maintenance, maintenanceMessage, serverTime` — không cần token; khi bảo trì mọi endpoint khác trả 503 |
| `GET /v1/servers` | — | `servers[] {id, name, region, status, population, recommended}` — không cần token |
| `POST /v1/servers/select` | `serverId` | gắn người chơi vào máy chủ; 404 sai id, 409 máy chủ không nhận |
| `POST /v1/auth/guest` | `guestToken?` | `playerId, guestToken, sessionToken, isNew, name, serverId` — không cần token |
| `POST /v1/auth/register` | `username, password, guestToken?` | `accountId, playerId, sessionToken, name, serverId, needsCharacter`; gửi `guestToken` để giữ tiến độ khách; 409 trùng tên đăng nhập |
| `POST /v1/auth/login` | `username, password` | như trên; 401 sai thông tin, 403 tài khoản bị khoá |
| `POST /v1/auth/logout` | — | huỷ session hiện tại |
| `POST /v1/auth/password` | `password, newPassword` | đổi mật khẩu; 401 sai mật khẩu cũ |
| `POST /v1/players` | `name, avatar?` | tạo nhân vật; 400 tên sai luật, 409 trùng tên |
| `GET /v1/world/snapshot` | — | gộp `{me, farm, zoo, missions}` — dùng lúc vào game thay vì gọi lẻ |
| `GET /v1/me` | — | `name, avatar, serverId, hasAccount, farmXp, farmLevel, zooXp, zooLevel, wallets{VANG,KC}` |
| `POST /v1/players/name` | `name` (2-20 ký tự) | đổi tên sau khi đã tạo nhân vật; 409 nếu trùng |
| `GET /v1/catalog` | — | `crops[]` (seedCost, growthSeconds, yieldMin/Max, xp, sellPrice, minFarmLevel), `species[]` (cost, diet[], appeal, rarity, minZooLevel), `habitatTypes[]`, `products[]`, `decors[]`, `recipes[]`, `games[]`, `plotCount` — tải 1 lần lúc boot, đừng hardcode số liệu |
| `GET /v1/farm` | — | `plots[48] {plotIndex, state EMPTY/GROWING/READY, cropId, plantedAt, readyAt}`, `storage[] {foodId, quantity}` |
| `POST /v1/farm/plant` | `plotIndex, cropId` | 402 thiếu Vàng · 403 thiếu level · 409 ô có cây |
| `POST /v1/farm/harvest` | `plotIndex` | `yield, xp`; 409 chưa chín — client đếm ngược từ `readyAt`, server là trọng tài |
| `POST /v1/farm/sell` | `foodId, quantity` | `vangEarned, vangBalance`; 409 thiếu hàng |
| `GET /v1/zoo` | — | `habitats[]{id, typeId, capacity, animals[]{id, speciesId, fed, appeal}}`, `warehouse[] {foodId, quantity}`, `isOpen`, `foodCoverage`, `totalAppeal`, `pendingVang` |
| `POST /v1/zoo/habitats` | `typeId` | trả `id` chuồng; 403 thiếu Zoo level |
| `POST /v1/zoo/animals` | `habitatId, speciesId` | 409 chuồng đầy · 403 thiếu level |
| `POST /v1/zoo/deliver` | `foodId, quantity` | chuyển kho farm → kho zoo |
| `POST /v1/zoo/feed` | `habitatId` | mỗi con đói ăn 1 food hợp `species.diet`; no 4 tiếng |
| `POST /v1/zoo/open` / `close` | — | mở cần ≥1 thú; close tự thu tiền trước |
| `POST /v1/zoo/collect` | — | `vangEarned = floor(tổng appeal thú no × 10/giờ, trần 8h)`, `zooXp` |
| `GET /v1/missions` | — | `{missions: [{id, name, target, progress, rewardVang, claimed}]}` — tiến độ server tự ghi |
| `POST /v1/missions/claim` | `missionId` | 409 chưa xong/đã nhận |
| `POST /v1/daily/checkin` | — | `streak, rewardVang`; 409 đã điểm danh hôm nay |
| `GET /v1/friends` | — | `friends[]`, `incoming[]`, `outgoing[]`, `helpsLeftToday` |
| `POST /v1/friends/request` | `friendName` | 404 không có tên đó, 409 đã là bạn/đã mời |
| `POST /v1/friends/accept` | `friendId` | 404 không có lời mời |
| `POST /v1/friends/remove` | `friendId` | dùng cho cả từ chối lời mời và huỷ kết bạn |
| `GET /v1/friends/visit?friendId=` | — | xem nông trại + sở thú của bạn (chỉ đọc), kèm `canHelp` |
| `POST /v1/friends/help` | `friendId` | +60 Vàng cho mình, +30 cho bạn; mỗi người 1 lần/ngày, tối đa 10 lượt/ngày |
| `GET /v1/leaderboard?type=zoo\|farm` | — | `rows[] {rank, playerId, name, zooLevel, farmLevel, score}` |
| `GET /v1/mails` | — | `{mails: [{id, title, body, rewardVang, rewardKc, rewardFoodId, rewardFoodQty, claimed, expiresAt}]}` — thư hết hạn tự ẩn (30 ngày) |
| `POST /v1/mails/claim` | `mailId` | nhận quà; 409 nếu đã nhận hoặc hết hạn |
| `POST /v1/mails/claim-all` | — | `{claimed: n}` |
| `POST /v1/giftcodes/redeem` | `code` | quà gửi vào hộp thư; 409 đã dùng/hết lượt/hết hạn, 404 mã sai |
| `GET /v1/achievements` | — | `{achievements: [...]}` — tích luỹ trọn đời, **không reset** như nhiệm vụ ngày |
| `POST /v1/achievements/claim` | `achievementId` | 409 chưa xong hoặc đã nhận |
| `GET /v1/collection` | — | `{species: [{speciesId, name, rarity, appeal, owned, firstOwnedAt}]}` |
| `GET /v1/shop` | — | `{items: [{id, name, description, currency VANG\|KC, price, type, param, value}], kcPacks: [...]}` |
| `POST /v1/shop/purchase` | `itemId, quantity?` | trừ **đúng một loại tiền** theo `currency` của món; 402 thiếu tiền |
| `GET /v1/inventory` | — | `{items: [{itemId, name, description, type, quantity}]}` |
| `POST /v1/items/use` | `itemId, plotIndex?` | `FOOD` → cộng thẳng kho nông trại; `GROW_BOOST` → cần `plotIndex`, làm chín ngay ô đang lớn. Dùng hỏng thì **tự hoàn lại vật phẩm** |
| `POST /v1/shop/topup` | `packId` | nạp Kim Cương **giả lập** (chưa nối cổng thật), vẫn ghi sổ cái `TOPUP_MOCK` |
| `GET /v1/processing` | — | `{slots: [{id, name, outputFoodId, readyAt, ready}], maxSlots, storage[]}` |
| `POST /v1/processing/start` | `recipeId` | trừ nguyên liệu, đặt `ready_at`; 409 thiếu nguyên liệu/hết lò, 403 thiếu level |
| `POST /v1/processing/collect` | `slotId` | 409 chưa xong, 404 đã thu |
| `POST /v1/zoo/decors` | `habitatId, decorId` | trang trí chuồng; 409 đã có món đó, 403 thiếu Zoo level |

**Chat** (kênh `WORLD` · `PRIVATE` · `SYSTEM`; loại nội dung `TEXT` · `STICKER` · `GIF` · `VOICE`, emoji đi kèm trong `TEXT`):

| Method & path | Body / query | Ghi chú |
|---|---|---|
| `GET /v1/chat/catalog` | — | `{stickers[], gifs[], maxTextLength}` — sticker/GIF **chỉ lấy từ danh mục này**, client không gửi URL tự do |
| `GET /v1/chat/world?sinceId=&limit=` | — | `{messages[], ban}` — kèm cả tin `SYSTEM`; đã lọc bỏ người mình mute/block |
| `GET /v1/chat/private?playerId=&sinceId=` | — | Hội thoại 2 chiều với 1 người |
| `POST /v1/chat/send` | `channel, type, text?, refId?, targetId?` | 422 nội dung bị chặn (kèm lý do), 429 gửi quá nhanh/trùng lặp, 403 bị cấm chat hoặc bị chặn, 404 sticker/GIF không có trong danh mục |
| `POST /v1/chat/voice` | `voiceBase64, durationMs` | Tối đa 200 KB / 30 giây → `{voiceId}`; gửi tiếp bằng `type=VOICE, refId=voiceId` |
| `GET /v1/chat/voice?voiceId=` | — | Trả **bytes thô**. Chỉ nghe được nếu tin đã đăng ở kênh thế giới, hoặc mình là 1 trong 2 phía của tin riêng |
| `GET /v1/chat/relations` | — | `{muted[], blocked[]}` |
| `POST /v1/chat/relations` | `targetId, mode` (`MUTE` \| `BLOCK` \| `NONE`) | `MUTE` chỉ ẩn tin ở kênh chung; `BLOCK` chặn luôn tin riêng |
| `POST /v1/chat/report` | `messageId, reason?` | 409 nếu đã báo cáo tin đó rồi |

Luật kiểm duyệt chạy ở server: chặn link/số điện thoại/nội dung rao bán — lừa đảo, chặn từ cấm (đã bỏ dấu và bỏ ký tự chèn giữa nên `d.m`, `n g u` không lách được), che từ nhẹ bằng `***`, giới hạn 1 giây/tin · 5 tin trong 10 giây · không lặp lại tin trong 30 giây. Vi phạm 3 lần trong 10 phút thì **tự động cấm chat 15 phút**.

| Method & path | Body | Dùng để |
|---|---|---|
| `POST /v1/admin/chat/delete` | `messageId` | Xoá tin — người chơi thấy "(tin nhắn đã bị xoá)", log admin vẫn giữ nội dung gốc |
| `POST /v1/admin/chat/ban` | `targetPlayerId, minutes, reason?` | `minutes ≤ 0` là gỡ cấm |
| `POST /v1/admin/chat/announce` | `text` | Đăng thông báo hệ thống vào kênh chung |
| `GET /v1/admin/chat/log` | `?channel=&sinceId=&limit=` | Lịch sử chat đầy đủ để tra cứu |
| `GET /v1/admin/chat/reports` | `?limit=` | Danh sách tin bị báo cáo |

> Ảnh động và sticker an toàn **theo cấu trúc**: server chỉ phát nội dung trong danh mục có sẵn nên không có đường nào đẩy ảnh NSFW vào game. Ngược lại, **voice không tự lọc được** — chỉ có báo cáo + admin xem lại, nên bật voice ở server công khai thì cần người trực.

> **Hai loại tiền tách bạch** (spec): mỗi món chỉ mua bằng đúng một loại tiền, và **không có endpoint nào đổi Kim Cương ↔ Vàng**.

**Endpoint vận hành** (chỉ bật khi đặt biến môi trường `ADMIN_TOKEN`, gửi kèm header `X-Admin-Token`; không đặt biến thì trả 404 như không tồn tại):

| Method & path | Body | Dùng để |
|---|---|---|
| `POST /v1/admin/mail` | `targetPlayerId, title, body?, rewardVang?, rewardKc?, foodId?, quantity?` | Gửi thư/đền bù cho 1 người chơi |
| `POST /v1/admin/giftcode` | `code, rewardVang?, rewardKc?, foodId?, quantity?, maxUses?, expiresDays?` | Tạo mã quà tặng |
| `POST /v1/minigames/session` | `gameType` (`MATCH3` \| `MEMORY`) | `sessionId, gameType, seed, movesAllowed, maxScore, vangPerScore` — sinh bàn từ `seed` |
| `POST /v1/minigames/finish` | `sessionId, score` | server kẹp `score ≤ maxScore` theo luật từng game; gọi lại cùng session trả kết quả cũ |

Mã lỗi: `401` sai token/sai mật khẩu · `402` thiếu tiền · `403` thiếu level hoặc bị khoá · `404` không tồn tại · `409` sai trạng thái · `503` bảo trì.

## C5. Lớp gọi API mẫu (`Assets/Scripts/MyZooApi.cs`)

```csharp
using System;
using System.Collections;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

public class MyZooApi : MonoBehaviour
{
    [SerializeField] string baseUrl = "http://localhost:8080"; // đổi khi lên VPS
    string token;

    [Serializable] public class GuestLogin { public int playerId; public string guestToken; public string sessionToken; public bool isNew; public string name; public string serverId; }
    [Serializable] public class Wallets { public long VANG; public long KC; }
    [Serializable] public class Profile { public int playerId; public string name, avatar, serverId; public bool hasAccount; public int farmXp, farmLevel, zooXp, zooLevel; public Wallets wallets; }
    [Serializable] public class ApiError { public string error; }
    // Khai báo thêm DTO theo bảng C4 — field trùng tên JSON là JsonUtility tự map.

    public IEnumerator Login(Action<GuestLogin> ok, Action<string> fail)
    {
        string saved = PlayerPrefs.GetString("guestToken", "");
        string body = string.IsNullOrEmpty(saved) ? "{}" : "{\"guestToken\":\"" + saved + "\"}";
        yield return Post("/v1/auth/guest", body, json =>
        {
            var login = JsonUtility.FromJson<GuestLogin>(json);
            token = login.sessionToken;
            PlayerPrefs.SetString("sessionToken", token);
            PlayerPrefs.SetString("guestToken", login.guestToken);
            PlayerPrefs.Save();
            ok(login);
        }, fail);
    }

    public IEnumerator GetMe(Action<Profile> ok, Action<string> fail)
        => Get("/v1/me", json => ok(JsonUtility.FromJson<Profile>(json)), fail);

    public IEnumerator Plant(int plotIndex, string cropId, Action<string> ok, Action<string> fail)
        => Post("/v1/farm/plant",
            $"{{\"plotIndex\":{plotIndex},\"cropId\":\"{cropId}\",\"requestId\":\"{Guid.NewGuid()}\"}}", ok, fail);

    // ---- lõi HTTP ----
    IEnumerator Get(string path, Action<string> ok, Action<string> fail)
    {
        using var req = UnityWebRequest.Get(baseUrl + path);
        if (token != null) req.SetRequestHeader("X-Session-Token", token);
        yield return req.SendWebRequest();
        Handle(req, ok, fail);
    }

    IEnumerator Post(string path, string jsonBody, Action<string> ok, Action<string> fail)
    {
        using var req = new UnityWebRequest(baseUrl + path, "POST");
        req.uploadHandler = new UploadHandlerRaw(Encoding.UTF8.GetBytes(jsonBody));
        req.downloadHandler = new DownloadHandlerBuffer();
        req.SetRequestHeader("Content-Type", "application/json");
        if (token != null) req.SetRequestHeader("X-Session-Token", token);
        yield return req.SendWebRequest();
        Handle(req, ok, fail);
    }

    void Handle(UnityWebRequest req, Action<string> ok, Action<string> fail)
    {
        string body = req.downloadHandler?.text ?? "";
        if (req.result == UnityWebRequest.Result.Success) ok(body);
        else
        {
            var err = string.IsNullOrEmpty(body) ? null : JsonUtility.FromJson<ApiError>(body);
            fail(err != null && !string.IsNullOrEmpty(err.error) ? err.error : req.error);
        }
    }
}
```

Test nhanh trong Editor: gắn `MyZooApi` vào 1 GameObject, script khác gọi `StartCoroutine(api.Login(l => Debug.Log(l.playerId), Debug.LogError))` → Console ra playerId là thông xong.

## C6. Luồng màn hình gợi ý (khớp client web mẫu)

1. **Boot**: Login → `GET /v1/catalog` (cache suốt phiên) → `GET /v1/me` + `/v1/farm` + `/v1/zoo` → `name` null thì popup đặt tên.
2. **Farm**: vẽ 48 ô từ `plots`; GROWING đếm ngược `readyAt - now`; hết giờ đổi hình READY tại client, còn thu hoạch để server xác nhận.
3. **Zoo**: chuồng/thú từ `habitats`; badge đói khi `fed == false`; nút thu tiền hiện `pendingVang`.
4. **Refresh**: mọi response mutation đã trả sẵn số dư/kho mới; ngoài ra poll `/v1/farm` + `/v1/zoo` mỗi 10-15s.
5. **Minigame**: nhận `seed` → sinh bàn 6×6 bằng PRNG từ seed (client web dùng mulberry32 — xem `client/app.js`) → xong gửi `linesMade`.

## C7. Build ra máy thật

- **Android**: File → Build Settings → Android → Switch Platform → Build (APK để test, AAB khi lên store). Nhớ mục C2 về HTTP.
- **iOS**: Build ra Xcode project → mở bằng Xcode trên macOS → ký bằng Apple ID → Run lên máy. Nhớ ATS nếu còn HTTP.
- Sprite pixel-art tạm của dự án (`client/assets/sprites.png` + toạ độ trong `sprites.json`): import với **Filter Mode = Point**, **Compression = None** nếu muốn dùng trước khi có asset riêng.

## C8. Checklist hay quên

- [ ] Lưu `sessionToken` (và `guestToken` nếu chơi khách) vào PlayerPrefs ngay sau login
- [ ] GUID mới mỗi hành động — GIỮ NGUYÊN GUID khi retry
- [ ] Android Emulator dùng `10.0.2.2`, không phải `localhost`
- [ ] Hiển thị lỗi từ field `error`, đừng tự đoán
- [ ] Đếm ngược theo epoch millis của server, không tin đồng hồ máy người chơi
- [ ] Lên production: HTTPS (phần B5) rồi bỏ nới cleartext
