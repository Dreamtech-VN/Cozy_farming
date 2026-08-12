# Hướng dẫn nối client Unity vào server (cho người mới hoàn toàn)

Server đã xong 20 giai đoạn (xem `README.md`), nhưng **client Unity CHƯA
được bắt đầu** — repo này hiện chỉ có code server Java. Tài liệu này
hướng dẫn bạn tạo project Unity mới và nối nó vào server có sẵn, kể cả
nếu bạn chưa từng làm việc với REST API trong Unity bao giờ.

## 0. Những điều BẮT BUỘC phải hiểu trước khi code

1. **Server dùng REST API thuần qua HTTP, KHÔNG dùng WebSocket/Socket.IO
   /Photon gì cả.** Mọi request là `GET`/`POST` bình thường, trả về
   JSON. Muốn "cập nhật liên tục" (sảnh, chat, PvP...) thì Unity phải tự
   **gọi lại API định kỳ (polling)** — không có server tự đẩy tin về.
2. **Toàn bộ ID vật phẩm/tầng/màn chơi đều lấy TRỰC TIẾP từ server, không
   tự đoán.** Ví dụ danh sách vật phẩm làm đẹp gọi `GET
   /api/cosmetics/catalog`, không hardcode trong Unity — vì server có
   thể thêm/đổi vật phẩm sau này.
3. **Trang phục lúc tạo nhân vật (`hairId`/`topId`/`bottomId`) là số
   nguyên TỰ DO** — server chưa có catalog thật cho phần này (khác với
   hệ cosmetic mở rộng ở Giai đoạn 11 đã có catalog đàng hoàng). Nghĩa là
   **bên Unity phải tự định nghĩa** "id nào ứng với sprite/prefab nào"
   (xem mục 4).
4. **Bàn cờ match-3 (`board`) là mảng số 8x8, mỗi số 0-5 tương ứng 1 màu
   gem** — Unity tự vẽ, tự chọn màu/sprite cho từng số (xem mục 7).

## 1. Cài đặt project Unity

1. Cài Unity Hub, tạo project mới, template **2D** (đủ cho game match-3
   này) hoặc 3D nếu game bạn định làm khác — không ảnh hưởng tới phần
   networking.
2. Cài package xử lý JSON — Unity có `JsonUtility` sẵn nhưng KHÔNG đọc
   được JSON dạng mảng ở gốc (`[...]`, ví dụ danh sách guild) và không
   đọc được field `null`/nullable đúng cách. Dùng **Newtonsoft Json**
   (gói chính chủ Unity, không phải bên thứ 3 lạ):
   - Window → Package Manager → nút `+` → "Add package by name" →
     gõ `com.unity.nuget.newtonsoft-json` → Add.

## 2. Cấu trúc thư mục gợi ý (theo từng tính năng server đã làm)

```
Assets/
  Scripts/
    Network/
      ApiClient.cs          <-- lớp gọi HTTP dùng chung, xem mục 3
      ApiException.cs
    Auth/                    <-- Giai đoạn 2: đăng ký/đăng nhập/khách/Google/Apple
    Character/               <-- Giai đoạn 3 + 11: tạo nhân vật, cosmetic
    Lobby/                   <-- Giai đoạn 4: sảnh
    Chat/                    <-- Giai đoạn 5
    Settings/                <-- Giai đoạn 6
    Social/                  <-- Giai đoạn 7-10: bạn bè, quà tặng, kết hôn
    Progression/             <-- Giai đoạn 9: level, ví
    Battle/                  <-- Giai đoạn 12-15, 17, 19-20: match-3 core + mọi mode
      Engine/                    (vẽ bàn cờ, hiệu ứng combo/chain/critical)
    Guild/                   <-- Giai đoạn 16-18: guild, guild boss
    Pvp/                     <-- Giai đoạn 20
  Sprites/
    Board/                   <-- 6 sprite màu gem (index 0-5, xem mục 7)
    Character/
      Hair/ Top/ Bottom/         (tự đặt tên file theo id bạn tự quy ước)
    Cosmetics/
      Eyes/ Avatar/ AvatarFrame/ Title/ Emote/ Hat/ Shirt/ Pants/ Shoes/ Pet/ Skin/
```

## 3. Lớp gọi API dùng chung

Tất cả tính năng đều gọi qua 1 lớp networking chung, tránh viết lặp code
`UnityWebRequest` ở mọi nơi.

```csharp
// Assets/Scripts/Network/ApiClient.cs
using System;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using UnityEngine;
using UnityEngine.Networking;

public static class ApiClient
{
    // Đổi sang địa chỉ server thật khi build (localhost chỉ dùng lúc dev trong Editor).
    public static string BaseUrl = "http://localhost:8080";

    public static async Task<T> GetAsync<T>(string path)
    {
        using var req = UnityWebRequest.Get(BaseUrl + path);
        await SendAsync(req);
        return JsonConvert.DeserializeObject<T>(req.downloadHandler.text);
    }

    public static async Task<T> PostAsync<T>(string path, object body)
    {
        string json = JsonConvert.SerializeObject(body);
        using var req = new UnityWebRequest(BaseUrl + path, "POST");
        byte[] bodyRaw = Encoding.UTF8.GetBytes(json);
        req.uploadHandler = new UploadHandlerRaw(bodyRaw);
        req.downloadHandler = new DownloadHandlerBuffer();
        req.SetRequestHeader("Content-Type", "application/json");
        await SendAsync(req);
        return JsonConvert.DeserializeObject<T>(req.downloadHandler.text);
    }

    private static async Task SendAsync(UnityWebRequest req)
    {
        var op = req.SendWebRequest();
        while (!op.isDone) await Task.Yield();

        if (req.result != UnityWebRequest.Result.Success)
        {
            // Server luôn trả lỗi dạng JSON {"error": "..."} — xem JsonHttp.java bên server.
            string message = req.downloadHandler != null ? req.downloadHandler.text : req.error;
            throw new ApiException((int)req.responseCode, message);
        }
    }
}
```

```csharp
// Assets/Scripts/Network/ApiException.cs
using System;

public class ApiException : Exception
{
    public int StatusCode { get; }
    public ApiException(int statusCode, string message) : base(message)
    {
        StatusCode = statusCode;
    }
}
```

> Mọi handler lỗi phía server trả `{"error": "lý do bằng tiếng Việt"}` —
> parse ra để hiện thẳng cho người chơi, không cần tự dịch mã lỗi.

## 4. Đăng ký/đăng nhập (Giai đoạn 2)

```csharp
[Serializable]
public class GuestLoginRequest { public string guestToken; }

[Serializable]
public class UserResponse
{
    public int id;
    public string username;
    public string guestToken;
    public string googleId;
    public string appleId;
    public string displayName;
}

public async Task<UserResponse> LoginAsGuest(string savedToken)
{
    var res = await ApiClient.PostAsync<UserResponse>(
        "/api/auth/guest", new GuestLoginRequest { guestToken = savedToken });
    PlayerPrefs.SetString("guestToken", res.guestToken); // lưu lại để lần sau vào đúng tài khoản
    return res;
}
```

Lưu `userId` trả về (từ response đăng nhập/đăng ký nào cũng có field
`id`) vào 1 nơi dùng chung cho cả phiên chơi (ví dụ 1 class `Session`
tĩnh) — HẦU HẾT API sau này đều cần gửi `userId` lên.

## 5. Tạo nhân vật + trang phục cơ bản (Giai đoạn 3)

```csharp
[Serializable]
public class CreateCharacterRequest
{
    public int userId;
    public string name;
    public int gender;   // 0 = nam, 1 = nữ
    public int hairId;
    public int topId;
    public int bottomId;
}
```

Vì `hairId`/`topId`/`bottomId` không có catalog thật từ server, bạn tự
quy ước bảng ánh xạ trong Unity, ví dụ:

```csharp
public static class OutfitAssets
{
    // Tự định nghĩa — id nào cũng được, miễn khớp giữa lúc tạo nhân vật
    // và lúc vẽ nhân vật ở nơi khác (sảnh, PvP...).
    public static readonly Dictionary<int, Sprite> HairSprites = new();
    public static readonly Dictionary<int, Sprite> TopSprites = new();
    public static readonly Dictionary<int, Sprite> BottomSprites = new();
}
```
Gán sprite vào các Dictionary này lúc khởi động game (kéo thả trong
Inspector qua 1 `ScriptableObject` liệt kê id↔sprite, hoặc load theo tên
file `hair_{id}.png` trong `Resources/`).

## 6. Sảnh + Chat (Giai đoạn 4-5) — polling

Sảnh và chat đều theo đúng 1 kiểu: gửi heartbeat/tin nhắn, rồi poll lấy
danh sách mới định kỳ.

```csharp
public class LobbyController : MonoBehaviour
{
    private float heartbeatTimer;
    private const float HeartbeatInterval = 1.5f; // server coi "online" nếu heartbeat trong 15s gần nhất

    void Update()
    {
        heartbeatTimer += Time.deltaTime;
        if (heartbeatTimer >= HeartbeatInterval)
        {
            heartbeatTimer = 0;
            _ = SendHeartbeat();
        }
    }

    async Task SendHeartbeat()
    {
        await ApiClient.PostAsync<object>("/api/lobby/heartbeat", new {
            userId = Session.UserId, x = transform.position.x, y = transform.position.y
        });
        var players = await ApiClient.GetAsync<List<LobbyPlayerView>>("/api/lobby/players");
        // ... cập nhật vị trí/hình các nhân vật khác trong sảnh
    }
}
```

Chat: giữ biến `lastSeenId = 0`, mỗi lần poll gọi
`GET /api/chat/recent?sinceId={lastSeenId}&limit=50`, cập nhật
`lastSeenId` bằng `id` lớn nhất nhận được — TUYỆT ĐỐI không lọc theo
thời gian (máy client/server có thể lệch giờ).

## 7. Vẽ bàn cờ match-3 (Giai đoạn 12 trở đi) — PHẦN QUAN TRỌNG NHẤT

Mọi chế độ chơi (Story, Daily/Weekly Challenge, Dungeon, Tower, Guild
Boss, World Boss, PvP) đều dùng CHUNG 1 bộ endpoint:
`swap`/`ultimate`/`state` — chỉ khác cách BẮT ĐẦU trận (`story/start`,
`dungeon/start`, `guild/boss/attack`...). Vậy nên chỉ cần viết 1 màn
hình chiến đấu chung, tái sử dụng cho mọi mode.

### 7.1. Model khớp với `BattleStateView` bên server

```csharp
[Serializable]
public class BattleStateView
{
    public string battleId;
    public int userId;
    public string mode;      // "STORY", "DUNGEON", "GUILD_BOSS", "PVP", ...
    public int? levelId;
    public string status;    // "ONGOING", "WON", "LOST"
    public int[][] board;    // 8x8, mỗi ô 0-5 = màu gem
    public int playerHp, playerHpMax, enemyHp, enemyHpMax;
    public int mana, manaMax, comboCount;
    public List<string> activeEffects; // "PLAYER_DAMAGE_UP", "PLAYER_MANA_DOWN"
    public bool matched, critical;
    public int chainLevels, damageDealt, manaGained;
    public bool enemyCountered;
    public int enemyCounterDamage;
    public bool rewardGranted;
    public int rewardExp, rewardGold;
    public int? floorIndex, totalFloors; // chỉ có giá trị ở Dungeon/Tower
    public bool floorCleared;
    public int totalDamageDealt; // dùng cho Guild/World Boss/PvP report
}
```

### 7.2. Bắt đầu trận (ví dụ Story)

```csharp
var start = await ApiClient.PostAsync<BattleStateView>(
    "/api/battle/story/start", new { userId = Session.UserId, levelId = 1 });
DrawBoard(start.board);
UpdateHud(start);
```

Các mode khác chỉ đổi endpoint bắt đầu, ví dụ:
- Dungeon: `POST /api/battle/dungeon/start` {userId, dungeonId}
- Tower: `POST /api/battle/tower/start` {userId, towerId}
- Daily/Weekly Challenge: `POST /api/battle/challenge/start` {userId, type}
- Guild Boss: `POST /api/guild/boss/attack` {userId}
- World Boss: `POST /api/world-boss/attack` {userId}
- PvP: `POST /api/pvp/match/start` {userId, matchId} (phải ghép cặp
  trước — xem mục 9)

### 7.3. Vẽ bàn cờ — ánh xạ số 0-5 sang sprite gem

```csharp
public class BoardRenderer : MonoBehaviour
{
    [SerializeField] private Sprite[] gemSprites = new Sprite[6]; // kéo 6 sprite vào Inspector, ĐÚNG THỨ TỰ index 0-5
    [SerializeField] private GameObject tilePrefab;
    [SerializeField] private Transform boardRoot;

    private GameObject[,] tiles = new GameObject[8, 8];

    public void DrawBoard(int[][] board)
    {
        for (int r = 0; r < 8; r++)
        for (int c = 0; c < 8; c++)
        {
            int colorIndex = board[r][c]; // 0-5
            if (tiles[r, c] == null)
                tiles[r, c] = Instantiate(tilePrefab, boardRoot);
            tiles[r, c].transform.localPosition = new Vector3(c, -r, 0);
            tiles[r, c].GetComponent<SpriteRenderer>().sprite = gemSprites[colorIndex];
        }
    }
}
```

Server KHÔNG quy định gem màu gì ứng với số nào — bạn tự chọn 6 sprite
gem bất kỳ, gán đúng thứ tự vào mảng `gemSprites`, miễn NHẤT QUÁN trong
suốt game.

### 7.4. Người chơi đổi 2 ô (swap)

```csharp
public async Task OnPlayerSwap(int r1, int c1, int r2, int c2)
{
    var result = await ApiClient.PostAsync<BattleStateView>("/api/battle/swap", new {
        userId = Session.UserId, battleId = currentBattleId, r1, c1, r2, c2
    });
    DrawBoard(result.board);
    UpdateHud(result);

    if (result.matched)
    {
        if (result.critical) PlayCriticalEffect();
        if (result.chainLevels > 1) PlayChainEffect(result.chainLevels);
        ShowDamagePopup(result.damageDealt);
    }
    if (result.enemyCountered) PlayEnemyCounterEffect(result.enemyCounterDamage);

    if (result.status != "ONGOING")
        OnBattleEnded(result); // xem mục 7.6
}
```
Chỉ gửi 2 ô LIỀN KỀ (`|r1-r2| + |c1-c2| == 1`) — server tự chặn nếu
không hợp lệ (400) hoặc không tạo ra khớp nào (vẫn 200 nhưng
`matched = false`, đồng thời reset combo).

### 7.5. Dùng chiêu cuối (ultimate)

```csharp
var result = await ApiClient.PostAsync<BattleStateView>(
    "/api/battle/ultimate", new { userId = Session.UserId, battleId = currentBattleId });
```
Chỉ gọi được khi `mana >= manaMax` (server trả lỗi 400 nếu chưa đủ, nên
disable nút ultimate ở UI khi `mana < manaMax`).

> `userId` là **bắt buộc** ở cả `swap`, `ultimate`, và `GET
> /api/battle/state?battleId=&userId=` (không có ở phiên bản tài liệu
> cũ) — server xác nhận `battleId` thuộc đúng người gọi, trả `403` nếu
> không khớp (chặn trường hợp ai đó có được `battleId` của người khác
> thì chơi/xem trộm được trận đấu).

### 7.6. Trận kết thúc

- `status == "WON"`: hiện màn thắng, đọc `rewardExp`/`rewardGold` để
  hiện thưởng. Với Dungeon/Tower, nếu `floorCleared == true` mà
  `status` vẫn `"ONGOING"` nghĩa là mới qua 1 tầng — hiện hiệu ứng "qua
  tầng" rồi tiếp tục vẽ bàn cờ mới (server tự sinh), KHÔNG phải kết thúc
  trận.
- `status == "LOST"`: hiện màn thua. Riêng **PvP**, `LOST` không có
  nghĩa "thua thật" — chỉ là hết lượt (20 lượt), phải gọi tiếp
  `match/report` để biết ai thắng thật (xem mục 9).
- Với **Guild Boss/World Boss**, sau khi trận cá nhân kết thúc (WON/
  LOST đều được), PHẢI gọi thêm `POST /api/guild/boss/report` (hoặc
  `/api/world-boss/report`) {userId, battleId} để đồng bộ sát thương
  vào HP chung — không tự động, quên gọi là mất công sức đã đánh.

## 8. Hệ nhân vật mở rộng / cosmetic (Giai đoạn 11)

Khác mục 5 (trang phục lúc tạo, tự quy ước id), hệ cosmetic có CATALOG
THẬT lấy từ server — LUÔN gọi `GET /api/cosmetics/catalog` lúc vào game,
đừng hardcode danh sách trong Unity. Bảng dưới đây là dữ liệu MVP HIỆN
TẠI (tham khảo, có thể server thêm mới sau — luôn ưu tiên dữ liệu gọi
từ API):

| id | loại (`type`) | tên (`name`) |
|---|---|---|
| 1-3 | EYES | eyes_default, eyes_round, eyes_sharp |
| 10-11 | AVATAR | avatar_default, avatar_smile |
| 20-21 | AVATAR_FRAME | frame_bronze, frame_gold |
| 30-31 | TITLE | title_newbie, title_veteran |
| 40-41 | EMOTE | emote_wave, emote_laugh |
| 50-51 | HAT | hat_straw, hat_crown |
| 60 | SHIRT | shirt_casual |
| 70 | PANTS | pants_casual |
| 80 | SHOES | shoes_sneaker |
| 90-91 | PET | pet_cat, pet_dog |
| 100 | SKIN | skin_default |

Đặt tên file sprite trong Unity trùng với cột `name` ở trên (ví dụ
`Assets/Sprites/Cosmetics/Hat/hat_crown.png`) để có thể load bằng
`Resources.Load<Sprite>($"Cosmetics/Hat/{def.name}")` mà không cần
Dictionary thủ công.

Luồng trang bị:
```csharp
// 1. Lấy catalog + vật phẩm đã sở hữu
var catalog = await ApiClient.GetAsync<List<CosmeticDef>>("/api/cosmetics/catalog");
var owned = await ApiClient.GetAsync<List<int>>($"/api/cosmetics/owned?userId={Session.UserId}");

// 2. Trang bị 1 vật phẩm đã sở hữu vào đúng ô (slot = tên type, VIẾT HOA)
await ApiClient.PostAsync<CharacterAppearance>("/api/character/appearance/equip", new {
    userId = Session.UserId, slot = "HAT", itemId = 51
});

// 3. Lấy trạng thái đang trang bị để vẽ nhân vật (gọi lại bất cứ khi nào cần vẽ, ví dụ vào sảnh)
var appearance = await ApiClient.GetAsync<CharacterAppearance>(
    $"/api/character/appearance?userId={Session.UserId}");
```

## 9. PvP (Giai đoạn 20) — LUỒNG RIÊNG, đọc kỹ

PvP không đấu trực tiếp cùng lúc (server không có WebSocket) — 2 người
ghép cặp rồi mỗi bên tự đấu độc lập, xong so điểm.

```csharp
// 1. Vào hàng chờ — người thứ 2 vào sẽ được ghép NGAY (matched = true kèm matchId)
var join = await ApiClient.PostAsync<QueueJoinView>(
    "/api/pvp/queue/join", new { userId = Session.UserId });

if (!join.matched)
{
    // Người thứ 1 phải TỰ POLL để biết khi nào được ghép — không có gì "đẩy" thông báo về
    string matchId = await PollUntilMatched();
}

// 2. Bắt đầu trận cá nhân (dùng board/swap/ultimate y hệt mục 7)
var battle = await ApiClient.PostAsync<BattleStateView>(
    "/api/pvp/match/start", new { userId = Session.UserId, matchId });

// 3. ... chơi hết 20 lượt (status chuyển "LOST" nghĩa là hết lượt, KHÔNG phải thua) ...

// 4. Nộp điểm — trận CHỈ resolve khi CẢ HAI bên đã report
var report = await ApiClient.PostAsync<PvpMatchView>("/api/pvp/match/report", new {
    userId = Session.UserId, matchId, battleId = battle.battleId
});
if (report.status == "RESOLVED")
{
    // report.winnerUserId == null -> hoà; so với Session.UserId để biết thắng/thua
}
```

```csharp
async Task<string> PollUntilMatched()
{
    while (true)
    {
        await Task.Delay(2000); // poll mỗi 2 giây, đủ nhanh mà không spam server
        try
        {
            var mine = await ApiClient.GetAsync<PvpMatchView>($"/api/pvp/match/my?userId={Session.UserId}");
            return mine.matchId;
        }
        catch (ApiException e) when (e.StatusCode == 404) { /* chưa ghép, thử lại */ }
    }
}
```

## 10. Guild (Giai đoạn 16-18)

Luồng cơ bản: `GET /api/guild/list` (danh sách guild + số thành viên) →
`POST /api/guild/join` {userId, guildId} → `GET /api/guild/my?userId=`
(guild hiện tại + danh sách thành viên). Đấu Guild Boss dùng lại y hệt
màn hình chiến đấu ở mục 7 (`POST /api/guild/boss/attack` để bắt đầu,
`POST /api/guild/boss/report` để nộp kết quả — xem thêm mục 7.6).

## 11. Danh sách endpoint đầy đủ

Xem `README.md` (cùng thư mục) — mỗi giai đoạn đều liệt kê ĐẦY ĐỦ
endpoint + giải thích ngay dưới tiêu đề giai đoạn đó, kèm lý do thiết
kế (vì sao chặn trường hợp nào, mặc định ra sao...). Đọc trước khi tích
hợp phần nào để hiểu đúng hành vi server, tránh đoán sai.

## 12. Mẹo debug khi Unity gọi API bị lỗi

1. Test API bằng `curl`/Postman TRƯỚC (xem `SETUP.md` mục 6) — nếu API
   tự nó đã lỗi thì lỗi không nằm ở code Unity.
2. Log nguyên văn response lỗi (`ApiException.Message`) ra Console —
   server luôn trả lý do bằng tiếng Việt dễ đọc, không phải mã lỗi khó
   hiểu.
3. CORS: nếu build ra WebGL và chạy khác domain với server, cần thêm
   CORS header phía server (hiện server CHƯA cấu hình CORS vì server
   này nhắm tới client Unity gọi trực tiếp qua HTTP, không phải trình
   duyệt web) — build Desktop/Mobile/Editor thì không gặp vấn đề này.
4. Nhớ đổi `ApiClient.BaseUrl` sang địa chỉ server thật trước khi build
   bản phát hành — mặc định đang trỏ `localhost` chỉ để test trong
   Editor.
