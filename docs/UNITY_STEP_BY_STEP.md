# MyZoo — Dựng client Unity từng bước

Hướng dẫn thao tác cụ thể trong Unity: tạo GameObject nào, gắn component gì, script dán vào đâu. Làm theo thứ tự từ trên xuống, mỗi phần xong là bấm Play kiểm tra được ngay.

- Muốn biết **API trả gì**: `docs/SETUP_GUIDE.md` phần C.
- Muốn biết **screen có gì, nút nào làm gì**: `docs/SCREEN_GUIDE.md`.
- File này trả lời: **làm sao dựng ra nó trong Unity**.

Toàn bộ script bên dưới là code thật, dán vào là chạy. Lưu ý: mình viết chuẩn theo API server nhưng chưa biên dịch được trong Unity (môi trường không có Unity Editor), nên gặp lỗi vặt lúc compile là bình thường — báo mình sửa.

---

# PHẦN 0 — Chuẩn bị project (làm 1 lần)

## 0.1. Tạo project

Unity Hub → New Project → **2D (Built-in Render Pipeline)** → tên `MyZooClient`.

## 0.2. Cài Newtonsoft Json (bắt buộc)

Window → Package Manager → nút **+** → **Add package by name** → gõ:

```
com.unity.nuget.newtonsoft-json
```

**Vì sao bắt buộc:** kho đồ trong game (`storage`, `warehouse`) là object khoá động kiểu `{"wheat":3,"carrot":2}`. `JsonUtility` có sẵn của Unity **không đọc được** dạng này. Newtonsoft đọc thẳng thành `Dictionary<string,int>`.

## 0.3. Player Settings

Edit → Project Settings → Player:

| Mục | Giá trị |
|---|---|
| Resolution → Default Orientation | **Landscape Left** |
| Allowed Orientations | tick Landscape Left + Landscape Right, **bỏ tick** cả 2 Portrait |
| Other Settings → Allow downloads over HTTP | **Always allowed** (khi dev với HTTP; bỏ khi đã có HTTPS) |
| Other Settings → Api Compatibility Level | .NET Standard 2.1 |

## 0.4. Cấu trúc thư mục

Trong `Assets/` tạo: `Scripts/`, `Scripts/Screens/`, `Prefabs/`, `Sprites/`, `Scenes/`.

## 0.5. Canvas gốc

Scene mới tên `Main` (lưu vào `Assets/Scenes/`). Trong Hierarchy:

1. Chuột phải → UI → **Canvas**. Chọn Canvas:
   - Canvas → Render Mode: **Screen Space - Overlay**
   - Canvas Scaler → UI Scale Mode: **Scale With Screen Size**
   - Reference Resolution: **X = 960, Y = 540**
   - Screen Match Mode: **Match Width Or Height**, Match = **0.5**
2. Unity tự thêm **EventSystem** — giữ nguyên.

Cây Hierarchy mục tiêu (dựng dần ở các phần sau):

```
Main (scene)
├── Canvas
│   ├── Screens
│   │   ├── S01_Splash
│   │   ├── S02_Login
│   │   ├── S03_Register
│   │   ├── S06_ServerSelect
│   │   ├── S07_CharacterCreate
│   │   ├── S08_Loading
│   │   ├── S09_Lobby
│   │   ├── S10_Farm
│   │   ├── S20_Zoo
│   │   ├── S30_Missions
│   │   └── S40_Minigame
│   ├── HUD
│   └── Toast
├── EventSystem
└── App   ← GameObject rỗng, chứa script nền
```

Tạo GameObject rỗng: chuột phải Canvas → Create Empty, đặt tên `Screens`. Với mỗi screen: chuột phải `Screens` → Create Empty → đặt tên như trên. Mỗi screen GameObject phải **stretch full màn**: chọn nó → Add Component → **Rect Transform** (nếu chưa có, dùng UI → Panel rồi xoá Image) → ở ô Anchor Presets bấm giữ **Alt + Shift** rồi chọn ô góc dưới phải (stretch-stretch) để Left/Top/Right/Bottom = 0.

**Mẹo:** thay vì tạo tay, dựng 1 screen xong thì Ctrl+D nhân bản rồi sửa — nhanh hơn nhiều.

---

# PHẦN 1 — Sáu script nền

Tạo trong `Assets/Scripts/`. Đây là phần dùng lại cho mọi screen, làm kỹ 1 lần.

> ⚠️ **Tạo đủ cả 6 file rồi hãy kiểm tra**: `Dto.cs`, `Api.cs`, `App.cs`, `ScreenManager.cs`, `Toast.cs`, `Hud.cs`.
> Chúng gọi lẫn nhau, nên khi mới tạo được vài file thì Console sẽ có **lỗi đỏ** kiểu
> `The name 'Hud' does not exist in the current context` — **bình thường**, tạo nốt là hết.
>
> Chừng nào còn lỗi đỏ, Unity giữ nguyên bản biên dịch cũ: **Inspector sẽ không hiện các ô** như Base Url,
> dù bạn đã dán code đúng. Thấy Inspector chỉ có mỗi dòng `Script` → mở Console xem lỗi trước, đừng dán lại code.

## 1.1. `Dto.cs` — khai báo dữ liệu server trả về

```csharp
using System.Collections.Generic;

namespace MyZoo
{
    public class ApiError { public string error; }

    public class LoginResult
    {
        public int playerId;
        public string guestToken;     // chỉ có ở đăng nhập khách
        public string sessionToken;
        public bool isNew;
        public string name;
        public string serverId;
        public bool needsCharacter;   // chỉ có ở register/login
    }

    public class Wallets { public long VANG; public long KC; }

    public class Profile
    {
        public int playerId;
        public string name, avatar, serverId;
        public bool hasAccount;
        public int farmXp, farmLevel, zooXp, zooLevel;
        public Wallets wallets;
    }

    public class ServerInfo
    {
        public string id, name, region, status, population;
        public bool recommended;
    }
    public class ServerList { public List<ServerInfo> servers; }

    public class GameConfigDto
    {
        public string gameVersion, minClientVersion, maintenanceMessage;
        public bool maintenance;
        public long serverTime;
    }

    public class CropDef
    {
        public string id, name;
        public long seedCost, sellPrice;
        public int growthSeconds, yieldMin, yieldMax, xp, minFarmLevel;
    }
    public class SpeciesDef
    {
        public string id, name, rarity;
        public long cost;
        public List<string> diet;
        public int appeal, minZooLevel;
    }
    public class HabitatTypeDef
    {
        public string id, name;
        public long cost;
        public int capacity, minZooLevel;
    }
    public class Catalog
    {
        public List<CropDef> crops;
        public List<SpeciesDef> species;
        public List<HabitatTypeDef> habitatTypes;
        public int plotCount;
    }

    public class Plot
    {
        public int plotIndex;
        public string state;        // EMPTY | GROWING | READY
        public string cropId;
        public long plantedAt, readyAt;
    }
    public class FarmView
    {
        public List<Plot> plots;
        public Dictionary<string, int> storage;
    }
    public class PlantResult { public int plotIndex; public string cropId; public long readyAt, vangBalance; }
    public class HarvestResult { public int plotIndex; public string cropId; public int yield, xp; }
    public class SellResult { public string foodId; public int quantity; public long vangEarned, vangBalance; }

    public class Animal
    {
        public int id, habitatId, appeal;
        public string speciesId, name, rarity;
        public bool fed;
    }
    public class Habitat
    {
        public int id, capacity;
        public string typeId, name;
        public List<Animal> animals;
    }
    public class ZooView
    {
        public List<Habitat> habitats;
        public Dictionary<string, int> warehouse;
        public bool isOpen;
        public double foodCoverage;
        public int totalAppeal;
        public long pendingVang;
    }
    public class BuyResult { public int id; public long vangBalance; }
    public class FeedResult { public int habitatId, animalsFed; public Dictionary<string, int> warehouse; }
    public class CollectResult { public long vangEarned, vangBalance; public int zooXp; }

    public class Mission
    {
        public string id, name;
        public int target, progress;
        public long rewardVang;
        public bool claimed;
    }
    public class ClaimResult { public string missionId; public long rewardVang, vangBalance; }
    public class CheckinResult { public string day; public int streak; public long rewardVang, vangBalance; }

    public class MinigameSession
    {
        public string sessionId;
        public long seed, vangPerLine;
        public int movesAllowed, maxLines;
    }
    public class MinigameResult
    {
        public string sessionId;
        public int linesCounted;
        public long vangReward, vangBalance;
        public bool newlyFinished;
    }

    public class Snapshot
    {
        public Profile me;
        public FarmView farm;
        public ZooView zoo;
        public List<Mission> missions;
    }
}
```

## 1.2. `Api.cs` — lớp gọi server

File **duy nhất** nói chuyện với server. Mọi screen về sau chỉ gọi `Api.I.Plant(...)`, không tự viết code mạng.

**Làm theo 4 bước:**

1. Cửa sổ **Project** → chuột phải `Assets/Scripts` → **Create → C# Script** → đặt tên chính xác là `Api`. *(Tên file phải trùng tên class, sai là lỗi biên dịch ngay.)*
2. Double-click file → **xoá sạch** nội dung mẫu → dán code dưới đây → Ctrl+S. Quay lại Unity, đợi nó biên dịch xong (vòng xoay nhỏ góc phải dưới).
3. Cửa sổ **Hierarchy** → chuột phải vùng trống → **Create Empty** → đổi tên thành `App`. *(Script kiểu MonoBehaviour phải nằm trên một GameObject mới chạy được.)*
4. Chọn `App` → kéo file `Api.cs` thả vào **Inspector** (hoặc **Add Component** → gõ "Api"). Inspector sẽ hiện ô **Base Url** — đây là chỗ đổi địa chỉ khi lên VPS, **không cần sửa code**.

**Giải thích mấy chỗ hay thắc mắc trong code:**

| Trong code | Nghĩa là gì |
|---|---|
| `public static Api I` + `Awake() => I = this` | Singleton — nhờ nó mọi script gọi được `Api.I.Xxx()` mà không phải kéo thả tham chiếu |
| `IEnumerator` + `yield return` | Coroutine: chờ mạng trả lời mà không làm đơ game. Bên gọi luôn viết `StartCoroutine(Api.I.GetMe(...))` |
| 2 tham số `ok` và `fail` | Thành công chạy `ok`, lỗi chạy `fail`. Thường truyền `Toast.Show` cho `fail` là đủ — server đã trả thông báo tiếng Việt |
| `ApplyHeaders` và `NewId()` | Tự gắn token và tự sinh `requestId`, nên **từng screen không phải nhớ 2 quy ước đó nữa** |

**Kiểm tra bước này chạy đúng** (chưa cần dựng UI): tạo thêm `TestApi.cs`, gắn vào cùng GameObject `App`:

```csharp
using UnityEngine;
using MyZoo;

public class TestApi : MonoBehaviour
{
    void Start() => StartCoroutine(Api.I.GetConfig(
        c => Debug.Log("Server OK, phiên bản " + c.gameVersion),
        e => Debug.LogError("Lỗi: " + e)));
}
```

Bật server rồi bấm **Play** — Console hiện `Server OK, phiên bản 0.1.0` là xong. Xoá script test rồi làm tiếp 1.3.

```csharp
using System;
using System.Collections;
using System.Text;
using Newtonsoft.Json;
using UnityEngine;
using UnityEngine.Networking;

namespace MyZoo
{
    public class Api : MonoBehaviour
    {
        public static Api I;   // truy cập từ mọi screen: Api.I.Xxx(...)

        [Header("Đổi khi lên VPS")]
        public string baseUrl = "http://localhost:8080";

        public string SessionToken { get; private set; }
        public string GuestToken { get; private set; }
        public long ServerTimeOffset { get; set; }   // serverTime - thời gian máy

        void Awake()
        {
            I = this;
            SessionToken = PlayerPrefs.GetString("sessionToken", "");
            GuestToken = PlayerPrefs.GetString("guestToken", "");
        }

        public long Now => DateTimeOffset.UtcNow.ToUnixTimeMilliseconds() + ServerTimeOffset;

        public void SaveTokens(string session, string guest)
        {
            if (!string.IsNullOrEmpty(session)) { SessionToken = session; PlayerPrefs.SetString("sessionToken", session); }
            if (!string.IsNullOrEmpty(guest)) { GuestToken = guest; PlayerPrefs.SetString("guestToken", guest); }
            PlayerPrefs.Save();
        }

        public void ClearSession()
        {
            SessionToken = "";
            PlayerPrefs.DeleteKey("sessionToken");
            PlayerPrefs.Save();
        }

        // ---------- API công khai ----------
        public IEnumerator GetConfig(Action<GameConfigDto> ok, Action<string> fail) => Get("/v1/config", ok, fail);
        public IEnumerator GetServers(Action<ServerList> ok, Action<string> fail) => Get("/v1/servers", ok, fail);
        public IEnumerator GetCatalog(Action<Catalog> ok, Action<string> fail) => Get("/v1/catalog", ok, fail);
        public IEnumerator GetMe(Action<Profile> ok, Action<string> fail) => Get("/v1/me", ok, fail);
        public IEnumerator GetSnapshot(Action<Snapshot> ok, Action<string> fail) => Get("/v1/world/snapshot", ok, fail);
        public IEnumerator GetFarm(Action<FarmView> ok, Action<string> fail) => Get("/v1/farm", ok, fail);
        public IEnumerator GetZoo(Action<ZooView> ok, Action<string> fail) => Get("/v1/zoo", ok, fail);
        public IEnumerator GetMissions(Action<System.Collections.Generic.List<Mission>> ok, Action<string> fail)
            => Get("/v1/missions", ok, fail);

        public IEnumerator LoginGuest(Action<LoginResult> ok, Action<string> fail)
            => Post("/v1/auth/guest", new { guestToken = GuestToken }, ok, fail);
        public IEnumerator Login(string username, string password, Action<LoginResult> ok, Action<string> fail)
            => Post("/v1/auth/login", new { username, password }, ok, fail);
        public IEnumerator Register(string username, string password, bool keepGuestProgress,
                                    Action<LoginResult> ok, Action<string> fail)
            => Post("/v1/auth/register",
                    new { username, password, guestToken = keepGuestProgress ? GuestToken : null }, ok, fail);
        public IEnumerator Logout(Action<object> ok, Action<string> fail)
            => Post("/v1/auth/logout", new { }, ok, fail);

        public IEnumerator SelectServer(string serverId, Action<Profile> ok, Action<string> fail)
            => Post("/v1/servers/select", new { serverId, requestId = NewId() }, ok, fail);
        public IEnumerator CreateCharacter(string name, string avatar, Action<Profile> ok, Action<string> fail)
            => Post("/v1/players", new { name, avatar, requestId = NewId() }, ok, fail);

        public IEnumerator Plant(int plotIndex, string cropId, Action<PlantResult> ok, Action<string> fail)
            => Post("/v1/farm/plant", new { plotIndex, cropId, requestId = NewId() }, ok, fail);
        public IEnumerator Harvest(int plotIndex, Action<HarvestResult> ok, Action<string> fail)
            => Post("/v1/farm/harvest", new { plotIndex, requestId = NewId() }, ok, fail);
        public IEnumerator Sell(string foodId, int quantity, Action<SellResult> ok, Action<string> fail)
            => Post("/v1/farm/sell", new { foodId, quantity, requestId = NewId() }, ok, fail);

        public IEnumerator BuyHabitat(string typeId, Action<BuyResult> ok, Action<string> fail)
            => Post("/v1/zoo/habitats", new { typeId, requestId = NewId() }, ok, fail);
        public IEnumerator BuyAnimal(int habitatId, string speciesId, Action<BuyResult> ok, Action<string> fail)
            => Post("/v1/zoo/animals", new { habitatId, speciesId, requestId = NewId() }, ok, fail);
        public IEnumerator Deliver(string foodId, int quantity, Action<object> ok, Action<string> fail)
            => Post("/v1/zoo/deliver", new { foodId, quantity, requestId = NewId() }, ok, fail);
        public IEnumerator Feed(int habitatId, Action<FeedResult> ok, Action<string> fail)
            => Post("/v1/zoo/feed", new { habitatId, requestId = NewId() }, ok, fail);
        public IEnumerator OpenZoo(Action<ZooView> ok, Action<string> fail)
            => Post("/v1/zoo/open", new { requestId = NewId() }, ok, fail);
        public IEnumerator CloseZoo(Action<CollectResult> ok, Action<string> fail)
            => Post("/v1/zoo/close", new { requestId = NewId() }, ok, fail);
        public IEnumerator Collect(Action<CollectResult> ok, Action<string> fail)
            => Post("/v1/zoo/collect", new { requestId = NewId() }, ok, fail);

        public IEnumerator ClaimMission(string missionId, Action<ClaimResult> ok, Action<string> fail)
            => Post("/v1/missions/claim", new { missionId, requestId = NewId() }, ok, fail);
        public IEnumerator Checkin(Action<CheckinResult> ok, Action<string> fail)
            => Post("/v1/daily/checkin", new { requestId = NewId() }, ok, fail);

        public IEnumerator StartMinigame(Action<MinigameSession> ok, Action<string> fail)
            => Post("/v1/minigames/session", new { requestId = NewId() }, ok, fail);
        public IEnumerator FinishMinigame(string sessionId, int linesMade, Action<MinigameResult> ok, Action<string> fail)
            => Post("/v1/minigames/finish", new { sessionId, linesMade, requestId = NewId() }, ok, fail);

        // ---------- lõi ----------
        static string NewId() => Guid.NewGuid().ToString();

        IEnumerator Get<T>(string path, Action<T> ok, Action<string> fail)
        {
            using var req = UnityWebRequest.Get(baseUrl + path);
            ApplyHeaders(req);
            yield return req.SendWebRequest();
            Handle(req, ok, fail);
        }

        IEnumerator Post<T>(string path, object body, Action<T> ok, Action<string> fail)
        {
            string json = JsonConvert.SerializeObject(body);
            using var req = new UnityWebRequest(baseUrl + path, "POST");
            req.uploadHandler = new UploadHandlerRaw(Encoding.UTF8.GetBytes(json));
            req.downloadHandler = new DownloadHandlerBuffer();
            req.SetRequestHeader("Content-Type", "application/json");
            ApplyHeaders(req);
            yield return req.SendWebRequest();
            Handle(req, ok, fail);
        }

        void ApplyHeaders(UnityWebRequest req)
        {
            string token = !string.IsNullOrEmpty(SessionToken) ? SessionToken : GuestToken;
            if (!string.IsNullOrEmpty(token)) req.SetRequestHeader("X-Session-Token", token);
        }

        void Handle<T>(UnityWebRequest req, Action<T> ok, Action<string> fail)
        {
            string body = req.downloadHandler != null ? req.downloadHandler.text : "";
            if (req.result == UnityWebRequest.Result.Success)
            {
                try { ok(typeof(T) == typeof(object) ? default : JsonConvert.DeserializeObject<T>(body)); }
                catch (Exception e) { fail("Lỗi đọc dữ liệu: " + e.Message); }
                return;
            }
            if (req.responseCode == 401) { ClearSession(); }
            string message = req.error;
            try
            {
                var err = JsonConvert.DeserializeObject<ApiError>(body);
                if (err != null && !string.IsNullOrEmpty(err.error)) message = err.error;
            }
            catch { }
            fail(message);
        }
    }
}
```

## 1.3. `App.cs` — trạng thái dùng chung

Nơi giữ dữ liệu đang chơi (hồ sơ, nông trại, sở thú, nhiệm vụ) để các screen dùng chung, khỏi gọi API lại.

Tạo file `App.cs` như bước 1.2 rồi **Add Component vào đúng GameObject `App`** (cùng chỗ với `Api`).

```csharp
using System.Collections.Generic;
using UnityEngine;

namespace MyZoo
{
    public class App : MonoBehaviour
    {
        public static App I;

        public Catalog Catalog;
        public Profile Me;
        public FarmView Farm;
        public ZooView Zoo;
        public List<Mission> Missions = new();

        void Awake() => I = this;

        public void Apply(Snapshot s)
        {
            Me = s.me; Farm = s.farm; Zoo = s.zoo; Missions = s.missions;
            Hud.I?.Refresh();
        }

        public CropDef Crop(string id) => Catalog.crops.Find(c => c.id == id);
        public SpeciesDef Species(string id) => Catalog.species.Find(s => s.id == id);
        public HabitatTypeDef HabitatType(string id) => Catalog.habitatTypes.Find(h => h.id == id);

        // Chấm đỏ trên các nút ở sảnh
        public bool HasReadyCrop() => Farm?.plots?.Exists(p => p.state == "READY") ?? false;
        public bool ZooNeedsAttention() =>
            Zoo != null && (Zoo.pendingVang > 0 || Zoo.habitats.Exists(h => h.animals.Exists(a => !a.fed)));
        public bool HasClaimableMission() => Missions.Exists(m => m.progress >= m.target && !m.claimed);
    }
}
```

## 1.4. `ScreenManager.cs` + `Toast.cs`

`ScreenManager` lo bật/tắt screen; `Toast` hiện thông báo ngắn ở đáy màn.

Tạo `ScreenManager.cs` → Add Component vào GameObject `App`.

**Không cần làm gì trong Inspector**: nếu bạn đặt tên GameObject đúng là `Screens` và `HUD` (như sơ đồ ở mục 0.5), script tự tìm ra chúng lúc chạy. Muốn dùng tên khác thì mới phải gán tay vào 2 ô `Screens Root` / `Hud`.

**Ba cách gán một ô kiểu kéo-thả trong Unity** (áp dụng cho mọi ô object ở các bước sau):

| Cách | Thao tác |
|---|---|
| Kéo chuột | Chọn `App` trong Hierarchy trước. Rồi **bấm giữ** chuột lên `Screens` trong Hierarchy, **giữ nguyên tay** rê sang ô trong Inspector, ô sáng viền xanh mới thả. *(Đừng click chọn `Screens` trước khi kéo — click là Inspector nhảy sang object đó, mất chỗ thả.)* |
| Nút tròn ⊙ | Bấm hình tròn nhỏ ở mép phải ô → cửa sổ **Select GameObject** hiện ra → gõ tên → **double-click** kết quả. Không phải kéo gì. |
| Để trống | Với `ScreenManager`, cứ để trống — script tự tìm theo tên. |

```csharp
using System.Collections.Generic;
using UnityEngine;

namespace MyZoo
{
    public class ScreenManager : MonoBehaviour
    {
        public static ScreenManager I;

        [Tooltip("Để trống thì tự tìm GameObject tên 'Screens'")]
        public Transform screensRoot;
        [Tooltip("Để trống thì tự tìm GameObject tên 'HUD'")]
        public GameObject hud;

        readonly List<GameObject> screens = new();

        void Awake()
        {
            I = this;

            // Để trống 2 ô trong Inspector cũng chạy: tự tìm theo tên GameObject.
            if (screensRoot == null)
            {
                var found = GameObject.Find("Screens");
                if (found == null)
                {
                    Debug.LogError("Không thấy GameObject tên 'Screens'. Tạo nó trong Canvas (mục 0.5), "
                                 + "hoặc gán thủ công vào ô Screens Root.");
                    return;
                }
                screensRoot = found.transform;
            }
            if (hud == null) hud = GameObject.Find("HUD");

            // Tự gom mọi screen con — khỏi kéo thả từng cái, thêm screen mới cũng không cần sửa Inspector
            foreach (Transform child in screensRoot) screens.Add(child.gameObject);
        }

        public void Show(string screenName, bool showHud = false)
        {
            bool found = false;
            foreach (var s in screens)
            {
                bool match = s.name == screenName;
                s.SetActive(match);
                found |= match;
            }
            if (!found) Debug.LogError($"Không tìm thấy screen '{screenName}' — sai tên GameObject?");
            if (hud) hud.SetActive(showHud);
        }
    }
}
```

**Lưu ý:** tên GameObject phải khớp **chính xác** chuỗi truyền vào `Show()` (`S02_Login`, `S10_Farm`…). Gõ sai một ký tự thì màn hình sẽ đen thui — nên script có sẵn dòng `Debug.LogError` báo tên nào không tìm thấy.

Toast: tạo UI → Panel tên `Toast` (anchor giữa-dưới, cao 60, rộng 500), bên trong 1 Text tên `Label`. Gắn script:

```csharp
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class Toast : MonoBehaviour
    {
        public static Toast I;
        public Text label;
        CanvasGroup group;

        void Awake()
        {
            I = this;
            group = GetComponent<CanvasGroup>() ?? gameObject.AddComponent<CanvasGroup>();
            group.alpha = 0;
        }

        public static void Show(string message)
        {
            if (I == null) { Debug.Log(message); return; }
            I.StopAllCoroutines();
            I.StartCoroutine(I.Run(message));
        }

        IEnumerator Run(string message)
        {
            label.text = message;
            group.alpha = 1;
            yield return new WaitForSeconds(2.5f);
            while (group.alpha > 0) { group.alpha -= Time.deltaTime * 2; yield return null; }
        }
    }
}
```

**Từ giờ mọi lỗi API chỉ cần:** `err => Toast.Show(err)` — server đã trả thông báo tiếng Việt sẵn.

---


## 1.5. `Hud.cs` — thanh thông tin trên cùng

Tạo file `Hud.cs` như các bước trên. Phần GameObject/UI có thể dựng sau — nhưng **file phải tồn tại ngay**, vì `App.cs` ở bước 1.3 có gọi tới nó.

Tạo `Canvas → HUD` (Create Empty, anchor stretch ngang, cao 44, ghim đỉnh màn). Bên trong thêm bằng UI → Text (hoặc TextMeshPro nếu quen):

```
HUD  (Horizontal Layout Group, Padding 10, Spacing 12)
├── NameText     (Text)
├── VangText     (Text)  "🪙 1.000"
├── KcText       (Text)
├── FarmLvText   (Text)  "🌾 Lv1"
├── ZooLvText    (Text)  "🦁 Lv1"
└── BackButton   (Button) — hiện khi ở S10/S20/S30, bấm về S09
```

```csharp
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class Hud : MonoBehaviour
    {
        public static Hud I;
        public Text nameText, vangText, kcText, farmLvText, zooLvText;
        public Button backButton;

        void Awake()
        {
            I = this;
            backButton.onClick.AddListener(() => ScreenManager.I.Show("S09_Lobby", true));
        }

        public void Refresh()
        {
            var me = App.I.Me;
            if (me == null) return;
            nameText.text = string.IsNullOrEmpty(me.name) ? "Khách" : me.name;
            vangText.text = "🪙 " + me.wallets.VANG.ToString("N0");
            kcText.text = "💎 " + me.wallets.KC.ToString("N0");
            farmLvText.text = "🌾 Lv" + me.farmLevel;
            zooLvText.text = "🦁 Lv" + me.zooLevel;
        }

        // Gọi sau mỗi hành động: response đã có số dư mới, không cần gọi lại /v1/me
        public void SetVang(long vang)
        {
            App.I.Me.wallets.VANG = vang;
            Refresh();
        }
    }
}
```


---

# PHẦN 2 — Dựng từng screen

## S01_Splash

**Hierarchy:**
```
S01_Splash
├── Bg          (Image, stretch full, màu xanh lá đậm)
├── Logo        (Image, giữa trên)
├── StatusText  (Text, giữa dưới, "Đang kết nối...")
├── ProgressBar (Image, Type = Filled, Fill Method = Horizontal)
├── VersionText (Text, góc dưới phải, cỡ 12)
└── RetryButton (Button, giữa, mặc định tắt SetActive(false))
```

```csharp
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class SplashScreen : MonoBehaviour
    {
        public Text statusText, versionText;
        public Image progressBar;
        public Button retryButton;
        public string clientVersion = "0.1.0";

        void OnEnable()
        {
            retryButton.gameObject.SetActive(false);
            retryButton.onClick.RemoveAllListeners();
            retryButton.onClick.AddListener(() => StartCoroutine(Boot()));
            StartCoroutine(Boot());
        }

        IEnumerator Boot()
        {
            Fail(null);
            statusText.text = "Đang kiểm tra máy chủ...";
            progressBar.fillAmount = 0.2f;
            versionText.text = "v" + clientVersion;

            GameConfigDto config = null;
            yield return Api.I.GetConfig(c => config = c, Fail);
            if (config == null) yield break;

            if (config.maintenance)
            {
                statusText.text = config.maintenanceMessage;
                retryButton.gameObject.SetActive(true);
                yield break;
            }
            if (IsOlder(clientVersion, config.minClientVersion))
            {
                statusText.text = "Cần cập nhật phiên bản mới để chơi tiếp.";
                yield break;
            }

            // Bù lệch đồng hồ máy người chơi
            Api.I.ServerTimeOffset = config.serverTime - System.DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
            progressBar.fillAmount = 0.5f;

            if (string.IsNullOrEmpty(Api.I.SessionToken) && string.IsNullOrEmpty(Api.I.GuestToken))
            {
                ScreenManager.I.Show("S02_Login");
                yield break;
            }

            statusText.text = "Đang đăng nhập...";
            Profile me = null;
            string error = null;
            yield return Api.I.GetMe(p => me = p, e => error = e);
            progressBar.fillAmount = 1f;

            if (me == null)
            {
                Debug.Log("Auto-login thất bại: " + error);
                ScreenManager.I.Show("S02_Login");
                yield break;
            }
            App.I.Me = me;
            ScreenManager.I.Show(string.IsNullOrEmpty(me.name) ? "S06_ServerSelect" : "S08_Loading");
        }

        void Fail(string error)
        {
            if (error == null) return;
            statusText.text = "Không kết nối được máy chủ.\n" + error;
            retryButton.gameObject.SetActive(true);
        }

        static bool IsOlder(string a, string b)
        {
            var x = a.Split('.'); var y = b.Split('.');
            for (int i = 0; i < Mathf.Min(x.Length, y.Length); i++)
            {
                int xi = int.Parse(x[i]), yi = int.Parse(y[i]);
                if (xi != yi) return xi < yi;
            }
            return false;
        }
    }
}
```

**Wire:** chọn `S01_Splash` → Add Component → `SplashScreen` → kéo StatusText/VersionText/ProgressBar/RetryButton vào các ô tương ứng trong Inspector.

## S02_Login

**Hierarchy:**
```
S02_Login
├── Bg
├── Logo
├── UsernameInput  (InputField)
├── PasswordInput  (InputField, Content Type = Password)
├── LoginButton    (Button + Text "Đăng nhập")
├── GuestButton    (Button + Text "Chơi ngay")
├── RegisterLink   (Button + Text "Chưa có tài khoản? Đăng ký")
└── ErrorText      (Text, màu đỏ, dưới ô mật khẩu)
```

```csharp
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class LoginScreen : MonoBehaviour
    {
        public InputField usernameInput, passwordInput;
        public Button loginButton, guestButton, registerLink;
        public Text errorText;

        void Start()
        {
            loginButton.onClick.AddListener(() => StartCoroutine(DoLogin()));
            guestButton.onClick.AddListener(() => StartCoroutine(DoGuest()));
            registerLink.onClick.AddListener(() => ScreenManager.I.Show("S03_Register"));
        }

        void OnEnable() => errorText.text = "";

        IEnumerator DoLogin()
        {
            errorText.text = "";
            SetBusy(true);
            yield return Api.I.Login(usernameInput.text, passwordInput.text, OnLogged, e => errorText.text = e);
            SetBusy(false);
        }

        IEnumerator DoGuest()
        {
            SetBusy(true);
            yield return Api.I.LoginGuest(OnLogged, e => errorText.text = e);
            SetBusy(false);
        }

        void OnLogged(LoginResult r)
        {
            Api.I.SaveTokens(r.sessionToken, r.guestToken);
            bool needCharacter = string.IsNullOrEmpty(r.name);
            ScreenManager.I.Show(needCharacter ? "S06_ServerSelect" : "S08_Loading");
        }

        void SetBusy(bool busy)
        {
            loginButton.interactable = !busy;
            guestButton.interactable = !busy;
        }
    }
}
```

## S03_Register

Giống S02, thêm ô `ConfirmInput` và checkbox điều khoản.

```csharp
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class RegisterScreen : MonoBehaviour
    {
        public InputField usernameInput, passwordInput, confirmInput;
        public Toggle termsToggle;
        public Button submitButton, backLink;
        public Text errorText;

        void Start()
        {
            submitButton.onClick.AddListener(() => StartCoroutine(DoRegister()));
            backLink.onClick.AddListener(() => ScreenManager.I.Show("S02_Login"));
        }

        IEnumerator DoRegister()
        {
            errorText.text = "";
            if (passwordInput.text != confirmInput.text) { errorText.text = "Hai ô mật khẩu chưa khớp"; yield break; }
            if (!termsToggle.isOn) { errorText.text = "Cần đồng ý điều khoản"; yield break; }

            submitButton.interactable = false;
            // Đang chơi khách mà đăng ký => gửi kèm guestToken để GIỮ NGUYÊN tiến độ
            bool keepProgress = !string.IsNullOrEmpty(Api.I.GuestToken);
            yield return Api.I.Register(usernameInput.text, passwordInput.text, keepProgress, r =>
            {
                Api.I.SaveTokens(r.sessionToken, null);
                ScreenManager.I.Show(r.needsCharacter ? "S06_ServerSelect" : "S08_Loading");
            }, e => errorText.text = e);
            submitButton.interactable = true;
        }
    }
}
```

## S06_ServerSelect

**Hierarchy:**
```
S06_ServerSelect
├── Title       (Text "Chọn máy chủ")
└── ScrollView  (UI → Scroll View)
    └── Viewport/Content  (Vertical Layout Group + Content Size Fitter: Vertical = Preferred Size)
```

Tạo prefab **ServerCard**: UI → Button, cao 70, bên trong 3 Text (`NameText`, `StatusText`, `PopulationText`) + 1 Image `RecommendBadge`. Kéo vào `Assets/Prefabs/`.

```csharp
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class ServerCard : MonoBehaviour
    {
        public Text nameText, statusText, populationText;
        public GameObject recommendBadge;
        public Button button;

        public void Bind(ServerInfo info, System.Action<ServerInfo> onPick)
        {
            nameText.text = info.name;
            populationText.text = info.population == "SMOOTH" ? "Mượt" : "Đông";
            recommendBadge.SetActive(info.recommended);

            bool joinable = info.status == "ONLINE";
            statusText.text = info.status switch
            {
                "ONLINE" => "<color=#4CAF50>● Hoạt động</color>",
                "FULL" => "<color=#FFC107>● Đầy</color>",
                "MAINTENANCE" => "<color=#9E9E9E>● Bảo trì</color>",
                _ => "<color=#9E9E9E>🔒 Khoá</color>"
            };
            button.interactable = joinable;
            button.onClick.RemoveAllListeners();
            if (joinable) button.onClick.AddListener(() => onPick(info));
        }
    }
}
```

```csharp
using System.Collections;
using UnityEngine;

namespace MyZoo
{
    public class ServerSelectScreen : MonoBehaviour
    {
        public Transform content;        // Viewport/Content của ScrollView
        public ServerCard cardPrefab;

        void OnEnable() => StartCoroutine(Load());

        IEnumerator Load()
        {
            foreach (Transform child in content) Destroy(child.gameObject);
            yield return Api.I.GetServers(list =>
            {
                foreach (var info in list.servers)
                    Instantiate(cardPrefab, content).Bind(info, Pick);
            }, Toast.Show);
        }

        void Pick(ServerInfo info) => StartCoroutine(Select(info));

        IEnumerator Select(ServerInfo info)
        {
            yield return Api.I.SelectServer(info.id, profile =>
            {
                App.I.Me = profile;
                ScreenManager.I.Show(string.IsNullOrEmpty(profile.name) ? "S07_CharacterCreate" : "S08_Loading");
            }, Toast.Show);
        }
    }
}
```

## S07_CharacterCreate

**Hierarchy:**
```
S07_CharacterCreate
├── Preview      (Image — sprite nhân vật đang chọn)
├── PrevButton   (Button "◀")
├── NextButton   (Button "▶")
├── NameInput    (InputField, Character Limit = 20)
├── RandomButton (Button "🎲")
├── ErrorText    (Text đỏ)
└── StartButton  (Button "Vào game")
```

```csharp
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class CharacterCreateScreen : MonoBehaviour
    {
        [System.Serializable] public class Look { public string id; public Sprite sprite; }

        public Look[] looks;             // tự thêm trong Inspector: farmer_1, farmer_2, keeper_1...
        public Image preview;
        public Button prevButton, nextButton, randomButton, startButton;
        public InputField nameInput;
        public Text errorText;

        static readonly string[] FirstParts = { "Nông", "Bé", "Cô", "Anh", "Chú" };
        static readonly string[] LastParts = { "Vui", "Xinh", "Bí Ngô", "Cà Rốt", "Mây" };

        int index;

        void Start()
        {
            prevButton.onClick.AddListener(() => Move(-1));
            nextButton.onClick.AddListener(() => Move(1));
            randomButton.onClick.AddListener(RandomName);
            startButton.onClick.AddListener(() => StartCoroutine(Create()));
            Move(0);
        }

        void Move(int delta)
        {
            index = (index + delta + looks.Length) % looks.Length;
            preview.sprite = looks[index].sprite;
        }

        void RandomName() =>
            nameInput.text = FirstParts[Random.Range(0, FirstParts.Length)] + " " +
                             LastParts[Random.Range(0, LastParts.Length)] + " " + Random.Range(1, 99);

        IEnumerator Create()
        {
            errorText.text = "";
            string name = nameInput.text.Trim();
            if (name.Length < 2) { errorText.text = "Tên phải từ 2 ký tự"; yield break; }

            startButton.interactable = false;
            yield return Api.I.CreateCharacter(name, looks[index].id, profile =>
            {
                App.I.Me = profile;
                ScreenManager.I.Show("S08_Loading");
            }, e => errorText.text = e);   // 409 trùng tên hiện ngay đây, KHÔNG đóng screen
            startButton.interactable = true;
        }
    }
}
```

## S08_Loading

```
S08_Loading
├── Artwork      (Image full màn)
├── ProgressBar  (Image Filled)
└── TipText      (Text — mẹo chơi)
```

```csharp
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class LoadingScreen : MonoBehaviour
    {
        public Image progressBar;
        public Text tipText;

        static readonly string[] Tips = {
            "Thú được cho ăn mới hút khách tham quan.",
            "Cỏ khô rẻ và lớn nhanh — hợp để nuôi cừu.",
            "Zoo chỉ tích tiền tối đa 8 tiếng, nhớ vào thu thường xuyên!",
            "Đăng ký tài khoản để không mất tiến độ khi đổi máy."
        };

        void OnEnable()
        {
            tipText.text = Tips[Random.Range(0, Tips.Length)];
            StartCoroutine(Load());
        }

        IEnumerator Load()
        {
            progressBar.fillAmount = 0.1f;
            if (App.I.Catalog == null)
                yield return Api.I.GetCatalog(c => App.I.Catalog = c, Toast.Show);

            progressBar.fillAmount = 0.6f;
            bool done = false;
            yield return Api.I.GetSnapshot(s => { App.I.Apply(s); done = true; }, Toast.Show);

            progressBar.fillAmount = 1f;
            if (done) ScreenManager.I.Show("S09_Lobby", true);
        }
    }
}
```

## S09_Lobby

```
S09_Lobby
├── Bg
├── CharacterImage
├── FarmButton      (Button lớn) └── RedDot (Image nhỏ đỏ, góc phải trên)
├── ZooButton       (Button lớn) └── RedDot
├── MinigameButton  (Button lớn)
├── MissionButton   (Button lớn) └── RedDot
├── CheckinButton   (Button)
└── SettingsButton  (Button)
```

```csharp
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class LobbyScreen : MonoBehaviour
    {
        public Button farmButton, zooButton, minigameButton, missionButton, checkinButton, settingsButton;
        public GameObject farmDot, zooDot, missionDot;

        void Start()
        {
            farmButton.onClick.AddListener(() => ScreenManager.I.Show("S10_Farm", true));
            zooButton.onClick.AddListener(() => ScreenManager.I.Show("S20_Zoo", true));
            minigameButton.onClick.AddListener(() => ScreenManager.I.Show("S40_Minigame", true));
            missionButton.onClick.AddListener(() => ScreenManager.I.Show("S30_Missions", true));
            checkinButton.onClick.AddListener(() => StartCoroutine(DoCheckin()));
        }

        void OnEnable()
        {
            Hud.I.Refresh();
            RefreshDots();
        }

        public void RefreshDots()
        {
            farmDot.SetActive(App.I.HasReadyCrop());
            zooDot.SetActive(App.I.ZooNeedsAttention());
            missionDot.SetActive(App.I.HasClaimableMission());
        }

        IEnumerator DoCheckin()
        {
            checkinButton.interactable = false;
            yield return Api.I.Checkin(r =>
            {
                Toast.Show($"Điểm danh ngày {r.streak}: +🪙{r.rewardVang}");
                Hud.I.SetVang(r.vangBalance);
            }, e => Toast.Show(e));   // 409 = hôm nay nhận rồi
            checkinButton.interactable = true;
        }

        // Quay lại app sau khi minimize → làm mới toàn bộ
        void OnApplicationFocus(bool focus)
        {
            if (focus && gameObject.activeInHierarchy) StartCoroutine(Refresh());
        }

        IEnumerator Refresh()
        {
            yield return Api.I.GetSnapshot(s => { App.I.Apply(s); RefreshDots(); }, _ => { });
        }
    }
}
```

## S10_Farm

**Hierarchy:**
```
S10_Farm
├── Bg
├── PlotGrid     (Grid Layout Group: Cell Size 92×74, Spacing 4×4, Constraint = Fixed Column Count 8)
├── StoragePanel
│   └── Content  (Horizontal Layout Group)  — mỗi loại nông sản 1 dòng
└── CropPickerPanel  (P11, mặc định tắt)
    ├── Title
    ├── Content  (Vertical Layout Group)
    └── CloseButton
```

Prefab **PlotCell** (Button, 92×74): bên trong `CropImage` (Image), `TimerText` (Text nhỏ), `ProgressBar` (Image Filled), `ReadyGlow` (Image).

```csharp
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class PlotCell : MonoBehaviour
    {
        public Image cropImage, progressBar, readyGlow;
        public Text timerText;
        public Button button;

        Plot plot;
        System.Action<Plot> onClick;

        public void Bind(Plot p, Sprite cropSprite, Sprite sproutSprite, System.Action<Plot> handler)
        {
            plot = p; onClick = handler;
            button.onClick.RemoveAllListeners();
            button.onClick.AddListener(() => onClick(plot));

            bool empty = p.state == "EMPTY";
            bool ready = p.state == "READY";
            cropImage.gameObject.SetActive(!empty);
            readyGlow.gameObject.SetActive(ready);
            progressBar.gameObject.SetActive(p.state == "GROWING");
            timerText.gameObject.SetActive(p.state == "GROWING");
            if (!empty) cropImage.sprite = ready ? cropSprite : sproutSprite;
        }

        void Update()
        {
            if (plot == null || plot.state != "GROWING") return;
            long now = Api.I.Now;
            long total = plot.readyAt - plot.plantedAt;
            long left = plot.readyAt - now;
            if (left <= 0)
            {
                plot.state = "READY";                      // tự đổi hình, không cần gọi server
                readyGlow.gameObject.SetActive(true);
                progressBar.gameObject.SetActive(false);
                timerText.gameObject.SetActive(false);
                return;
            }
            progressBar.fillAmount = 1f - (float)left / total;
            timerText.text = Format(left / 1000);
        }

        public static string Format(long sec) =>
            sec >= 3600 ? $"{sec / 3600}h{(sec % 3600) / 60}p" :
            sec >= 60 ? $"{sec / 60}p{sec % 60}s" : $"{sec}s";
    }
}
```

```csharp
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class FarmScreen : MonoBehaviour
    {
        public Transform plotGrid, storageContent, cropPickerContent;
        public PlotCell plotPrefab;
        public GameObject cropPickerPanel;
        public Button cropRowPrefab, storageRowPrefab;   // Button có Text bên trong
        public Sprite sproutSprite;
        public Sprite[] cropSprites;                     // đặt tên trùng cropId trong Inspector
        readonly List<PlotCell> cells = new();
        int pickingPlot;

        void OnEnable()
        {
            cropPickerPanel.SetActive(false);
            BuildGrid();
            RefreshStorage();
        }

        Sprite CropSprite(string cropId)
        {
            foreach (var s in cropSprites) if (s.name == cropId) return s;
            return sproutSprite;
        }

        void BuildGrid()
        {
            if (cells.Count == 0)
                for (int i = 0; i < App.I.Farm.plots.Count; i++)
                    cells.Add(Instantiate(plotPrefab, plotGrid));

            for (int i = 0; i < cells.Count; i++)
            {
                var plot = App.I.Farm.plots[i];
                cells[i].Bind(plot, CropSprite(plot.cropId), sproutSprite, OnPlotClicked);
            }
        }

        void OnPlotClicked(Plot plot)
        {
            if (plot.state == "EMPTY") OpenPicker(plot.plotIndex);
            else if (plot.state == "READY") StartCoroutine(DoHarvest(plot.plotIndex));
            else Toast.Show($"Còn {PlotCell.Format((plot.readyAt - Api.I.Now) / 1000)} nữa chín");
        }

        // ---- P11: panel chọn cây ----
        void OpenPicker(int plotIndex)
        {
            pickingPlot = plotIndex;
            cropPickerPanel.SetActive(true);
            foreach (Transform child in cropPickerContent) Destroy(child.gameObject);

            foreach (var crop in App.I.Catalog.crops)
            {
                var row = Instantiate(cropRowPrefab, cropPickerContent);
                bool locked = App.I.Me.farmLevel < crop.minFarmLevel;
                row.GetComponentInChildren<Text>().text = locked
                    ? $"{crop.name} — 🔒 Cần Farm Lv{crop.minFarmLevel}"
                    : $"{crop.name} — 🪙{crop.seedCost} · {PlotCell.Format(crop.growthSeconds)}";
                row.interactable = !locked;
                string cropId = crop.id;
                row.onClick.AddListener(() => StartCoroutine(DoPlant(cropId)));
            }
        }

        IEnumerator DoPlant(string cropId)
        {
            cropPickerPanel.SetActive(false);
            yield return Api.I.Plant(pickingPlot, cropId, r =>
            {
                var plot = App.I.Farm.plots[r.plotIndex];
                plot.state = "GROWING";
                plot.cropId = r.cropId;
                plot.plantedAt = Api.I.Now;
                plot.readyAt = r.readyAt;
                Hud.I.SetVang(r.vangBalance);
                BuildGrid();
            }, Toast.Show);
        }

        IEnumerator DoHarvest(int plotIndex)
        {
            yield return Api.I.Harvest(plotIndex, r =>
            {
                Toast.Show($"Thu hoạch {r.yield} {App.I.Crop(r.cropId).name} (+{r.xp} XP)");
                var plot = App.I.Farm.plots[plotIndex];
                plot.state = "EMPTY"; plot.cropId = null;
                App.I.Farm.storage.TryGetValue(r.cropId, out int have);
                App.I.Farm.storage[r.cropId] = have + r.yield;
                BuildGrid();
                RefreshStorage();
            }, Toast.Show);
        }

        // ---- kho + bán ----
        void RefreshStorage()
        {
            foreach (Transform child in storageContent) Destroy(child.gameObject);
            foreach (var pair in App.I.Farm.storage)
            {
                if (pair.Value <= 0) continue;
                var crop = App.I.Crop(pair.Key);
                var row = Instantiate(storageRowPrefab, storageContent);
                row.GetComponentInChildren<Text>().text = $"{crop.name} ×{pair.Value}\nBán 🪙{crop.sellPrice}";
                string foodId = pair.Key;
                int quantity = pair.Value;
                row.onClick.AddListener(() => StartCoroutine(DoSell(foodId, quantity)));
            }
        }

        IEnumerator DoSell(string foodId, int quantity)
        {
            yield return Api.I.Sell(foodId, quantity, r =>
            {
                Toast.Show($"Bán được 🪙{r.vangEarned}");
                App.I.Farm.storage[foodId] = 0;
                Hud.I.SetVang(r.vangBalance);
                RefreshStorage();
            }, Toast.Show);
        }
    }
}
```

## S20_Zoo

**Hierarchy:**
```
S20_Zoo
├── Bg
├── StatusPanel      (Text: mở/đóng, độ hấp dẫn, % no, tiền chờ thu)
├── HabitatGrid      (Grid Layout Group: Cell 236×130, 3 cột)
├── ActionButton     (Button lớn góc phải dưới — đổi chữ theo trạng thái)
├── ManagePanel      (P21, tắt mặc định: xây chuồng + chuyển thức ăn)
└── HabitatPanel     (P22, tắt mặc định: cho ăn + mua thú)
```

```csharp
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class ZooScreen : MonoBehaviour
    {
        public Transform habitatGrid, buildContent, deliverContent, speciesContent;
        public GameObject managePanel, habitatPanel;
        public Button actionButton, manageButton, feedButton;
        public Button rowPrefab;
        public HabitatCard habitatPrefab;
        public Text statusText, actionText, habitatTitle;

        Habitat selected;

        void Start()
        {
            manageButton.onClick.AddListener(OpenManage);
            feedButton.onClick.AddListener(() => StartCoroutine(DoFeed()));
        }

        void OnEnable()
        {
            managePanel.SetActive(false);
            habitatPanel.SetActive(false);
            Redraw();
        }

        void Redraw()
        {
            var zoo = App.I.Zoo;
            statusText.text =
                $"{(zoo.isOpen ? "🟢 Đang mở cửa" : "🔴 Đóng cửa")}\n" +
                $"Hấp dẫn: {zoo.totalAppeal} · No: {Mathf.RoundToInt((float)zoo.foodCoverage * 100)}%\n" +
                $"Chờ thu: 🪙{zoo.pendingVang}";

            foreach (Transform child in habitatGrid) Destroy(child.gameObject);
            foreach (var habitat in zoo.habitats)
                Instantiate(habitatPrefab, habitatGrid).Bind(habitat, OpenHabitat);

            actionText.text = zoo.isOpen ? $"Thu 🪙{zoo.pendingVang}" : "Mở cửa đón khách";
            actionButton.onClick.RemoveAllListeners();
            actionButton.onClick.AddListener(() => StartCoroutine(zoo.isOpen ? DoCollect() : DoOpen()));
        }

        IEnumerator DoOpen()
        {
            yield return Api.I.OpenZoo(z => { App.I.Zoo = z; Redraw(); }, Toast.Show);
        }

        IEnumerator DoCollect()
        {
            yield return Api.I.Collect(r =>
            {
                Toast.Show($"Thu được 🪙{r.vangEarned} (+{r.zooXp} XP)");
                Hud.I.SetVang(r.vangBalance);
            }, Toast.Show);
            yield return Api.I.GetZoo(z => { App.I.Zoo = z; Redraw(); }, Toast.Show);
        }

        // ---- P21: xây chuồng + chuyển thức ăn ----
        void OpenManage()
        {
            managePanel.SetActive(true);
            foreach (Transform child in buildContent) Destroy(child.gameObject);
            foreach (var type in App.I.Catalog.habitatTypes)
            {
                var row = Instantiate(rowPrefab, buildContent);
                bool locked = App.I.Me.zooLevel < type.minZooLevel;
                row.GetComponentInChildren<Text>().text = locked
                    ? $"{type.name} — 🔒 Cần Zoo Lv{type.minZooLevel}"
                    : $"{type.name} — 🪙{type.cost} · {type.capacity} chỗ";
                row.interactable = !locked;
                string typeId = type.id;
                row.onClick.AddListener(() => StartCoroutine(DoBuildHabitat(typeId)));
            }

            foreach (Transform child in deliverContent) Destroy(child.gameObject);
            foreach (var pair in App.I.Farm.storage)
            {
                if (pair.Value <= 0) continue;
                var row = Instantiate(rowPrefab, deliverContent);
                row.GetComponentInChildren<Text>().text = $"Chuyển {App.I.Crop(pair.Key).name} ×{pair.Value} sang Zoo";
                string foodId = pair.Key; int qty = pair.Value;
                row.onClick.AddListener(() => StartCoroutine(DoDeliver(foodId, qty)));
            }
        }

        IEnumerator DoBuildHabitat(string typeId)
        {
            managePanel.SetActive(false);
            yield return Api.I.BuyHabitat(typeId, r => Hud.I.SetVang(r.vangBalance), Toast.Show);
            yield return Api.I.GetZoo(z => { App.I.Zoo = z; Redraw(); }, Toast.Show);
        }

        IEnumerator DoDeliver(string foodId, int quantity)
        {
            managePanel.SetActive(false);
            yield return Api.I.Deliver(foodId, quantity, _ => Toast.Show("Đã chuyển sang kho Zoo"), Toast.Show);
            yield return Api.I.GetFarm(f => App.I.Farm = f, Toast.Show);
            yield return Api.I.GetZoo(z => { App.I.Zoo = z; Redraw(); }, Toast.Show);
        }

        // ---- P22: chi tiết chuồng ----
        void OpenHabitat(Habitat habitat)
        {
            selected = habitat;
            habitatPanel.SetActive(true);
            habitatTitle.text = $"{habitat.name} ({habitat.animals.Count}/{habitat.capacity})";

            foreach (Transform child in speciesContent) Destroy(child.gameObject);
            foreach (var species in App.I.Catalog.species)
            {
                var row = Instantiate(rowPrefab, speciesContent);
                bool locked = App.I.Me.zooLevel < species.minZooLevel;
                string diet = string.Join(", ", species.diet.ConvertAll(d => App.I.Crop(d).name));
                row.GetComponentInChildren<Text>().text = locked
                    ? $"{species.name} — 🔒 Cần Zoo Lv{species.minZooLevel}"
                    : $"{species.name} [{species.rarity}] hấp dẫn {species.appeal} · ăn {diet} — 🪙{species.cost}";
                row.interactable = !locked;
                string speciesId = species.id;
                row.onClick.AddListener(() => StartCoroutine(DoBuyAnimal(speciesId)));
            }
        }

        IEnumerator DoBuyAnimal(string speciesId)
        {
            habitatPanel.SetActive(false);
            yield return Api.I.BuyAnimal(selected.id, speciesId, r => Hud.I.SetVang(r.vangBalance), Toast.Show);
            yield return Api.I.GetZoo(z => { App.I.Zoo = z; Redraw(); }, Toast.Show);
        }

        IEnumerator DoFeed()
        {
            habitatPanel.SetActive(false);
            yield return Api.I.Feed(selected.id, r => Toast.Show($"Đã cho {r.animalsFed} con ăn 😋"), Toast.Show);
            yield return Api.I.GetZoo(z => { App.I.Zoo = z; Redraw(); }, Toast.Show);
        }
    }
}
```

Prefab **HabitatCard** (Button 236×130): `NameText`, `AnimalRow` (Horizontal Layout Group chứa các icon thú).

```csharp
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class HabitatCard : MonoBehaviour
    {
        public Text nameText;
        public Transform animalRow;
        public Image animalIconPrefab;
        public Button button;
        public Sprite[] animalSprites;   // tên trùng speciesId
        public Sprite hungrySprite, fedSprite;

        public void Bind(Habitat habitat, System.Action<Habitat> onClick)
        {
            nameText.text = $"{habitat.name} ({habitat.animals.Count}/{habitat.capacity})";
            foreach (Transform child in animalRow) Destroy(child.gameObject);
            foreach (var animal in habitat.animals)
            {
                var icon = Instantiate(animalIconPrefab, animalRow);
                foreach (var s in animalSprites) if (s.name == animal.speciesId) icon.sprite = s;
                var badge = Instantiate(animalIconPrefab, icon.transform);
                badge.sprite = animal.fed ? fedSprite : hungrySprite;
                badge.rectTransform.sizeDelta = new Vector2(18, 18);
                badge.rectTransform.anchoredPosition = new Vector2(16, 16);
            }
            button.onClick.RemoveAllListeners();
            button.onClick.AddListener(() => onClick(habitat));
        }
    }
}
```

## S30_Missions

```
S30_Missions
├── Title
├── ScrollView/Content   (Vertical Layout Group)
└── CheckinButton
```

```csharp
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class MissionsScreen : MonoBehaviour
    {
        public Transform content;
        public GameObject rowPrefab;    // gồm: NameText, ProgressBar(Image Filled), ProgressText, ClaimButton

        void OnEnable() => StartCoroutine(Load());

        IEnumerator Load()
        {
            yield return Api.I.GetMissions(list => { App.I.Missions = list; Redraw(); }, Toast.Show);
        }

        void Redraw()
        {
            foreach (Transform child in content) Destroy(child.gameObject);
            foreach (var mission in App.I.Missions)
            {
                var row = Instantiate(rowPrefab, content);
                row.transform.Find("NameText").GetComponent<Text>().text = mission.name;
                row.transform.Find("ProgressText").GetComponent<Text>().text = $"{mission.progress}/{mission.target}";
                row.transform.Find("ProgressBar").GetComponent<Image>().fillAmount =
                    (float)mission.progress / mission.target;

                var claim = row.transform.Find("ClaimButton").GetComponent<Button>();
                bool done = mission.progress >= mission.target;
                claim.interactable = done && !mission.claimed;
                claim.GetComponentInChildren<Text>().text =
                    mission.claimed ? "✓ Đã nhận" : done ? $"Nhận 🪙{mission.rewardVang}" : $"🪙{mission.rewardVang}";
                string missionId = mission.id;
                claim.onClick.AddListener(() => StartCoroutine(DoClaim(missionId)));
            }
        }

        IEnumerator DoClaim(string missionId)
        {
            yield return Api.I.ClaimMission(missionId, r =>
            {
                Toast.Show($"Nhận 🪙{r.rewardVang}");
                Hud.I.SetVang(r.vangBalance);
            }, Toast.Show);
            yield return Load();
        }
    }
}
```

## S40_Minigame

```
S40_Minigame
├── HeaderText   (lượt còn lại · số hàng · thưởng dự kiến)
├── Board        (Grid Layout Group: Cell 60×60, Fixed Column Count = 6)
└── FinishButton
```

**Quan trọng:** bàn chơi phải sinh từ `seed` server cấp bằng đúng thuật toán PRNG dưới đây (mulberry32) — để server tái lập được ván chơi khi cần kiểm tra gian lận.

```csharp
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class MinigameScreen : MonoBehaviour
    {
        const int Size = 6, Kinds = 5;

        public Transform board;
        public Button cellPrefab;
        public Sprite[] fruitSprites;   // đúng 5 sprite
        public Text headerText;
        public Button finishButton;

        readonly int[] cells = new int[Size * Size];
        readonly List<Button> buttons = new();
        MinigameSession session;
        uint rngState;
        int movesLeft, lines, selected = -1;

        void Start() => finishButton.onClick.AddListener(() => StartCoroutine(Finish()));

        void OnEnable() => StartCoroutine(Begin());

        IEnumerator Begin()
        {
            yield return Api.I.StartMinigame(s =>
            {
                session = s;
                rngState = (uint)(s.seed & 0xFFFFFFFF);
                movesLeft = s.movesAllowed;
                lines = 0; selected = -1;
                for (int i = 0; i < cells.Length; i++) cells[i] = NextInt(Kinds);
                BuildBoard();
            }, Toast.Show);
        }

        // mulberry32 — phải khớp từng phép toán với client web (client/app.js).
        // Dùng double, KHÔNG dùng float: float mất chính xác nên bàn cờ sẽ lệch so với seed server.
        double NextDouble()
        {
            unchecked
            {
                rngState += 0x6D2B79F5u;
                uint t = rngState;
                t = (t ^ (t >> 15)) * (t | 1u);
                t ^= t + (t ^ (t >> 7)) * (t | 61u);
                return (t ^ (t >> 14)) / 4294967296.0;
            }
        }
        int NextInt(int max) => Mathf.Min((int)(NextDouble() * max), max - 1);

        void BuildBoard()
        {
            if (buttons.Count == 0)
                for (int i = 0; i < cells.Length; i++)
                {
                    int index = i;
                    var b = Instantiate(cellPrefab, board);
                    b.onClick.AddListener(() => OnCellClicked(index));
                    buttons.Add(b);
                }
            for (int i = 0; i < cells.Length; i++)
            {
                buttons[i].image.sprite = fruitSprites[cells[i]];
                buttons[i].transform.localScale = selected == i ? Vector3.one * 1.15f : Vector3.one;
            }
            headerText.text = $"Còn {movesLeft} lượt · {lines} hàng · dự kiến 🪙{lines * session.vangPerLine}";
        }

        void OnCellClicked(int index)
        {
            if (movesLeft <= 0) return;
            if (selected < 0) { selected = index; BuildBoard(); return; }

            int a = selected, b = index;
            selected = -1;
            bool adjacent = (Mathf.Abs(a - b) == 1 && a / Size == b / Size) || Mathf.Abs(a - b) == Size;
            if (!adjacent) { BuildBoard(); return; }

            (cells[a], cells[b]) = (cells[b], cells[a]);
            movesLeft--;
            if (Resolve() == 0) (cells[a], cells[b]) = (cells[b], cells[a]);  // không ăn thì trả lại, vẫn mất lượt
            BuildBoard();
            if (movesLeft <= 0) StartCoroutine(Finish());
        }

        int Resolve()
        {
            int total = 0;
            for (int pass = 0; pass < 10; pass++)
            {
                var kill = new HashSet<int>();
                int found = 0;
                for (int r = 0; r < Size; r++)
                    for (int c = 0; c < Size - 2; c++)
                    {
                        int i = r * Size + c;
                        if (cells[i] == cells[i + 1] && cells[i] == cells[i + 2])
                        {
                            found++;
                            int cc = c;
                            while (cc < Size && cells[r * Size + cc] == cells[i]) kill.Add(r * Size + cc++);
                            c = cc;
                        }
                    }
                for (int c = 0; c < Size; c++)
                    for (int r = 0; r < Size - 2; r++)
                    {
                        int i = r * Size + c;
                        if (cells[i] == cells[i + Size] && cells[i] == cells[i + 2 * Size])
                        {
                            found++;
                            int rr = r;
                            while (rr < Size && cells[rr * Size + c] == cells[i]) kill.Add(rr++ * Size + c);
                            r = rr;
                        }
                    }
                if (found == 0) break;
                total += found;

                for (int c = 0; c < Size; c++)
                {
                    var column = new List<int>();
                    for (int r = Size - 1; r >= 0; r--) if (!kill.Contains(r * Size + c)) column.Add(cells[r * Size + c]);
                    while (column.Count < Size) column.Add(NextInt(Kinds));
                    for (int r = Size - 1, k = 0; r >= 0; r--, k++) cells[r * Size + c] = column[k];
                }
            }
            lines += total;
            return total;
        }

        IEnumerator Finish()
        {
            finishButton.interactable = false;
            yield return Api.I.FinishMinigame(session.sessionId, lines, r =>
            {
                Toast.Show($"Nhận 🪙{r.vangReward} cho {r.linesCounted} hàng!");
                Hud.I.SetVang(r.vangBalance);
                ScreenManager.I.Show("S09_Lobby", true);
            }, Toast.Show);
            finishButton.interactable = true;
        }
    }
}
```

---

# PHẦN 3 — Chạy thử

1. Bật server: `java -jar server/target/myzoo-server-0.1.0-SNAPSHOT.jar`
2. Trong Unity, chọn GameObject `App` → ô **Base Url** để `http://localhost:8080`
3. Không cần gán gì cho `ScreenManager` nếu GameObject đã đặt đúng tên `Screens` và `HUD`
4. Bấm **Play** — phải thấy Splash → Login. Bấm **Chơi ngay** → chọn server → tạo nhân vật → vào sảnh.

**Checklist nghiệm thu:**

| Kiểm tra | Kỳ vọng |
|---|---|
| Bấm Chơi ngay 2 lần (tắt/mở lại Play) | Vào thẳng sảnh, không hỏi tạo nhân vật lại |
| Trồng cây rồi bấm ô đang lớn | Toast hiện thời gian còn lại |
| Đợi cây chín, bấm thu hoạch | Kho tăng, HUD Vàng đổi |
| Trồng cây khi hết Vàng | Toast "Không đủ Vàng" |
| Trồng Tre lúc Farm Lv1 | Nút bị khoá, ghi "Cần Farm Lv5" |
| Mở Zoo khi chưa có thú | Toast "Cần ít nhất 1 con thú" |
| Tắt server rồi bấm nút bất kỳ | Toast báo mất kết nối, app không crash |
| Đăng ký tài khoản khi đang chơi khách | Vàng và nông trại giữ nguyên |

## Lỗi hay gặp

| Hiện tượng | Nguyên nhân |
|---|---|
| Inspector chỉ hiện dòng `Script`, không có ô nào (Base Url, Screens Root…) | Project đang có **lỗi biên dịch** → Unity giữ bản cũ. Mở Console xem dòng đỏ. Hay gặp nhất: chưa tạo đủ 6 file ở Phần 1, hoặc chưa cài Newtonsoft (bước 0.2) |
| Console báo `The name 'Hud' does not exist` | Chưa tạo `Hud.cs` (bước 1.5) — `App.cs` cần nó |
| Console báo `The type or namespace 'Newtonsoft' could not be found` | Chưa cài package ở bước 0.2 |
| `JsonSerializationException` ở `storage` | Chưa cài Newtonsoft, đang dùng JsonUtility |
| Mọi request trả 401 | Chưa lưu token, hoặc gửi sai header (`X-Session-Token`) |
| Android build gọi API không được | Chưa bật Allow downloads over HTTP, hoặc dùng `localhost` thay vì `10.0.2.2` |
| Đếm ngược sai vài giây | Chưa dùng `Api.I.Now` (đã bù lệch đồng hồ) mà dùng `DateTime.Now` |
| Bấm nút 2 lần trừ tiền 2 lần | Chưa disable nút lúc chờ response (idempotency chỉ chặn khi retry **cùng** requestId) |
