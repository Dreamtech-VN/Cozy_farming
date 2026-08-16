# Hướng dẫn dựng client Unity và nối với server MyZoo

Server là nguồn sự thật duy nhất: client chỉ gửi ý định và vẽ kết quả. Không tính giá tiền, thời gian chín, thưởng ở client.

## 1. Chạy server trước

```bash
cd server && mvn package
java -jar target/myzoo-server-0.1.0-SNAPSHOT.jar
# Server: http://localhost:8080  — mở trình duyệt vào đây có client web để đối chiếu hành vi
```

Cần JDK 21 + Maven. Không cần cài DB (H2 tự tạo file `myzoo-data.mv.db`).

## 2. Tạo project Unity

- **Unity 6 LTS (6000.0.x)** hoặc 2022.3 LTS. Template **2D (URP hoặc Built-in đều được)**.
- Player Settings → Resolution: **Landscape Left + Landscape Right** (game màn hình ngang), Default là 16:9 (thiết kế gốc 960×540).
- Không cần package mạng nào thêm — dùng `UnityWebRequest` có sẵn. JSON dùng `JsonUtility` (đủ cho API này) hoặc Newtonsoft nếu team quen.

## 3. Địa chỉ server theo môi trường chạy

| Chạy ở đâu | BASE_URL |
|---|---|
| Unity Editor / build PC cùng máy server | `http://localhost:8080` |
| Android Emulator | `http://10.0.2.2:8080` |
| iOS Simulator | `http://localhost:8080` |
| Điện thoại thật cùng Wi-Fi | `http://<IP máy chạy server>:8080` |
| Production | `https://domain-cua-ban` |

Cho phép HTTP khi dev:
- **Android**: Player Settings → Other Settings → **Allow downloads over HTTP: Always** (hoặc `usesCleartextTraffic` trong manifest tuỳ chỉnh).
- **iOS**: build ra Xcode rồi thêm vào Info.plist `NSAppTransportSecurity → NSAllowsArbitraryLoads = YES` (chỉ khi dev; production dùng HTTPS).

## 4. Ba quy ước bắt buộc khi gọi API

1. **Đăng nhập khách**: `POST /v1/auth/guest` với body `{"guestToken": "<token cũ hoặc null>"}`. Server trả `playerId`, `guestToken`, `isNew`, `name`. **Lưu `guestToken` bằng `PlayerPrefs`** — đó là tài khoản của người chơi, mất token là mất acc.
2. **Header `X-Guest-Token`**: mọi request sau đăng nhập phải gắn header này. Thiếu/sai → 401.
3. **`requestId` idempotent**: mọi POST thay đổi dữ liệu (trồng, thu hoạch, mua, bán, cho ăn, thu tiền, claim...) gửi kèm `"requestId": "<GUID mới>"` trong body. Rớt mạng cứ retry **cùng requestId** — server trả đúng response cũ, không bao giờ trừ tiền/cộng thưởng 2 lần. Chỉ tạo GUID mới khi là hành động mới.

## 5. Bảng endpoint

Tất cả trả JSON camelCase; timestamp là **epoch milliseconds**; lỗi trả `{"error": "thông báo tiếng Việt"}` kèm HTTP status.

| Method & path | Body (ngoài requestId) | Trả về / ghi chú |
|---|---|---|
| `POST /v1/auth/guest` | `guestToken?` | `playerId, guestToken, isNew, name` — không cần header |
| `GET /v1/me` | — | `name, farmXp, farmLevel, zooXp, zooLevel, wallets{VANG,KC}` |
| `POST /v1/players/name` | `name` (2-20 ký tự) | 409 nếu trùng tên |
| `GET /v1/catalog` | — | `crops[] (seedCost, growthSeconds, yieldMin/Max, xp, sellPrice, minFarmLevel)`, `species[] (cost, diet[], appeal, rarity, minZooLevel)`, `habitatTypes[] (cost, capacity, minZooLevel)`, `plotCount` — tải 1 lần lúc boot, đừng hardcode số liệu |
| `GET /v1/farm` | — | `plots[48] {plotIndex, state: EMPTY/GROWING/READY, cropId, plantedAt, readyAt}`, `storage{}` |
| `POST /v1/farm/plant` | `plotIndex, cropId` | 402 thiếu Vàng, 403 thiếu level, 409 ô có cây |
| `POST /v1/farm/harvest` | `plotIndex` | `yield, xp`; 409 chưa chín — client hiển thị đếm ngược từ `readyAt` nhưng server mới là trọng tài |
| `POST /v1/farm/sell` | `foodId, quantity` | `vangEarned, vangBalance`; 409 không đủ hàng |
| `GET /v1/zoo` | — | `habitats[]{id, typeId, capacity, animals[]{id, speciesId, fed, appeal}}`, `warehouse{}`, `isOpen`, `foodCoverage`, `totalAppeal`, `pendingVang` |
| `POST /v1/zoo/habitats` | `typeId` | trả `id` chuồng mới; 403 thiếu Zoo level |
| `POST /v1/zoo/animals` | `habitatId, speciesId` | 409 chuồng đầy; 403 thiếu level |
| `POST /v1/zoo/deliver` | `foodId, quantity` | chuyển kho farm → kho zoo |
| `POST /v1/zoo/feed` | `habitatId` | cho cả chuồng ăn; mỗi con đói ăn 1 food hợp khẩu phần (`species.diet`); thú "no" 4 tiếng |
| `POST /v1/zoo/open` / `close` | — | mở cần ≥1 thú; close tự thu tiền trước khi đóng |
| `POST /v1/zoo/collect` | — | `vangEarned = floor(tổng appeal thú no × 10/giờ, trần 8h)`, `zooXp` |
| `GET /v1/missions` | — | 6 nhiệm vụ ngày `{id, name, target, progress, rewardVang, claimed}` — tiến độ server tự ghi, client chỉ hiển thị |
| `POST /v1/missions/claim` | `missionId` | 409 chưa xong/đã nhận |
| `POST /v1/daily/checkin` | — | `streak, rewardVang`; 409 hôm nay điểm danh rồi |
| `POST /v1/minigames/session` | — | `sessionId, seed, movesAllowed, maxLines, vangPerLine` — **sinh bàn chơi từ `seed`** để server tái lập được |
| `POST /v1/minigames/finish` | `sessionId, linesMade` | server kẹp `linesMade ≤ maxLines`; gọi lại cùng session trả kết quả cũ, không thưởng thêm |

Mã lỗi chung: `401` sai token · `402` thiếu tiền · `403` thiếu level · `404` không tồn tại · `409` sai trạng thái (chưa chín, đã nhận, chuồng đầy...). Cứ hiển thị thẳng `error` cho người chơi — thông báo đã là tiếng Việt.

## 6. Lớp gọi API mẫu (kéo vào project là dùng)

`Assets/Scripts/MyZooApi.cs` — dùng coroutine + `JsonUtility`, không phụ thuộc gì khác:

```csharp
using System;
using System.Collections;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

public class MyZooApi : MonoBehaviour
{
    public string baseUrl = "http://localhost:8080";
    string token;

    [Serializable] public class GuestLogin { public int playerId; public string guestToken; public bool isNew; public string name; }
    [Serializable] public class Wallets { public long VANG; public long KC; }
    [Serializable] public class Profile { public int playerId; public string name; public int farmXp, farmLevel, zooXp, zooLevel; public Wallets wallets; }
    [Serializable] public class ApiError { public string error; }
    // ... khai báo thêm DTO cho farm/zoo/missions theo bảng endpoint (field trùng tên JSON là JsonUtility tự map)

    public IEnumerator Login(Action<GuestLogin> ok, Action<string> fail)
    {
        string saved = PlayerPrefs.GetString("guestToken", "");
        string body = string.IsNullOrEmpty(saved) ? "{}" : "{\"guestToken\":\"" + saved + "\"}";
        yield return Post("/v1/auth/guest", body, json =>
        {
            var login = JsonUtility.FromJson<GuestLogin>(json);
            token = login.guestToken;
            PlayerPrefs.SetString("guestToken", token);
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
        if (token != null) req.SetRequestHeader("X-Guest-Token", token);
        yield return req.SendWebRequest();
        Handle(req, ok, fail);
    }

    IEnumerator Post(string path, string jsonBody, Action<string> ok, Action<string> fail)
    {
        using var req = new UnityWebRequest(baseUrl + path, "POST");
        req.uploadHandler = new UploadHandlerRaw(Encoding.UTF8.GetBytes(jsonBody));
        req.downloadHandler = new DownloadHandlerBuffer();
        req.SetRequestHeader("Content-Type", "application/json");
        if (token != null) req.SetRequestHeader("X-Guest-Token", token);
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

Mẹo retry idempotent: khi một hành động fail vì mạng, giữ nguyên chuỗi JSON body (đã chứa `requestId`) và gửi lại y nguyên — an toàn tuyệt đối.

## 7. Luồng màn hình gợi ý (khớp client web mẫu)

1. **Boot**: `Login` → `GET /v1/catalog` (cache) → `GET /v1/me` + `/v1/farm` + `/v1/zoo` song song → nếu `name` null thì hiện popup đặt tên.
2. **Farm**: vẽ 48 ô từ `plots`; ô GROWING hiện đếm ngược `readyAt - now`; hết giờ đổi hình READY (không cần gọi server để đổi hình — nhưng thu hoạch thì server kiểm tra lại).
3. **Zoo**: vẽ chuồng/thú từ `habitats`; badge đói khi `fed == false`; nút thu tiền hiện `pendingVang`.
4. **Polling**: refresh `/v1/farm` + `/v1/zoo` mỗi 10-15s hoặc sau mỗi hành động (mọi response mutation đã trả sẵn số dư/kho mới để đỡ gọi lại).
5. **Minigame**: nhận `seed` → sinh bàn 6×6 bằng PRNG từ seed (client web dùng mulberry32 — xem `client/app.js`) → chơi xong gửi `linesMade`.

## 8. Sprite tạm

`client/assets/sprites.png` + `sprites.json` (toạ độ từng sprite) là bộ pixel-art gốc của dự án, dùng tạm được trong Unity: import với **Filter Mode = Point (no filter)**, **Compression = None**, cắt sprite theo toạ độ trong JSON (Sprite Editor hoặc script import). Thay bằng asset riêng của bạn lúc nào cũng được — server không biết gì về hình ảnh.

## 9. Checklist hay quên

- [ ] Lưu `guestToken` vào `PlayerPrefs` ngay sau login đầu tiên
- [ ] GUID mới cho mỗi hành động, GIỮ NGUYÊN GUID khi retry
- [ ] Hiển thị lỗi 402/403/409 từ field `error` thay vì tự đoán
- [ ] Đếm ngược dùng epoch millis từ server, đừng tin đồng hồ máy người chơi cho logic
- [ ] Android/iOS dev: nới HTTP cleartext (mục 3), production chuyển HTTPS
