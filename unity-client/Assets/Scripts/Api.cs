using System;
using System.Collections;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace MyZoo
{
    public class Api : MonoBehaviour
    {
        public static Api I;

        [Header("Đổi khi lên VPS. Android Emulator dùng http://10.0.2.2:8080")]
        public string baseUrl = "http://localhost:8080";

        public string SessionToken { get; private set; }
        public string GuestToken { get; private set; }
        public long ServerTimeOffset { get; set; }

        void Awake()
        {
            I = this;
            SessionToken = PlayerPrefs.GetString("sessionToken", "");
            GuestToken = PlayerPrefs.GetString("guestToken", "");
        }

        public long Now => DateTimeOffset.UtcNow.ToUnixTimeMilliseconds() + ServerTimeOffset;
        public bool HasToken => !string.IsNullOrEmpty(SessionToken) || !string.IsNullOrEmpty(GuestToken);

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

        // ---------- GET ----------
        public IEnumerator GetConfig(Action<GameConfigDto> ok, Action<string> fail) { return Get("/v1/config", ok, fail); }
        public IEnumerator GetServers(Action<ServerList> ok, Action<string> fail) { return Get("/v1/servers", ok, fail); }
        public IEnumerator GetCatalog(Action<Catalog> ok, Action<string> fail) { return Get("/v1/catalog", ok, fail); }
        public IEnumerator GetMe(Action<Profile> ok, Action<string> fail) { return Get("/v1/me", ok, fail); }
        public IEnumerator GetSnapshot(Action<Snapshot> ok, Action<string> fail) { return Get("/v1/world/snapshot", ok, fail); }
        public IEnumerator GetFarm(Action<FarmView> ok, Action<string> fail) { return Get("/v1/farm", ok, fail); }
        public IEnumerator GetZoo(Action<ZooView> ok, Action<string> fail) { return Get("/v1/zoo", ok, fail); }
        public IEnumerator GetMissions(Action<MissionList> ok, Action<string> fail) { return Get("/v1/missions", ok, fail); }

        // ---------- Tài khoản ----------
        public IEnumerator LoginGuest(Action<LoginResult> ok, Action<string> fail)
        {
            return Post("/v1/auth/guest", "{" + Str("guestToken", GuestToken) + "}", ok, fail);
        }

        public IEnumerator Login(string username, string password, Action<LoginResult> ok, Action<string> fail)
        {
            return Post("/v1/auth/login", "{" + Str("username", username) + "," + Str("password", password) + "}", ok, fail);
        }

        public IEnumerator Register(string username, string password, bool keepGuestProgress,
                                    Action<LoginResult> ok, Action<string> fail)
        {
            string body = "{" + Str("username", username) + "," + Str("password", password);
            if (keepGuestProgress && !string.IsNullOrEmpty(GuestToken)) body += "," + Str("guestToken", GuestToken);
            return Post("/v1/auth/register", body + "}", ok, fail);
        }

        public IEnumerator Logout(Action<OkResult> ok, Action<string> fail) { return Post("/v1/auth/logout", "{}", ok, fail); }

        public IEnumerator ChangePassword(string oldPassword, string newPassword, Action<OkResult> ok, Action<string> fail)
        {
            return Post("/v1/auth/password",
                "{" + Str("password", oldPassword) + "," + Str("newPassword", newPassword) + "}", ok, fail);
        }

        public IEnumerator SelectServer(string serverId, Action<Profile> ok, Action<string> fail)
        {
            return Post("/v1/servers/select", "{" + Str("serverId", serverId) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator CreateCharacter(string name, string avatar, Action<Profile> ok, Action<string> fail)
        {
            return Post("/v1/players", "{" + Str("name", name) + "," + Str("avatar", avatar) + "," + Req() + "}", ok, fail);
        }

        // ---------- Farm ----------
        public IEnumerator Plant(int plotIndex, string cropId, Action<PlantResult> ok, Action<string> fail)
        {
            return Post("/v1/farm/plant", "{" + Num("plotIndex", plotIndex) + "," + Str("cropId", cropId) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator Harvest(int plotIndex, Action<HarvestResult> ok, Action<string> fail)
        {
            return Post("/v1/farm/harvest", "{" + Num("plotIndex", plotIndex) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator Sell(string foodId, int quantity, Action<SellResult> ok, Action<string> fail)
        {
            return Post("/v1/farm/sell", "{" + Str("foodId", foodId) + "," + Num("quantity", quantity) + "," + Req() + "}", ok, fail);
        }

        // ---------- Zoo ----------
        public IEnumerator BuyHabitat(string typeId, Action<BuyResult> ok, Action<string> fail)
        {
            return Post("/v1/zoo/habitats", "{" + Str("typeId", typeId) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator BuyAnimal(int habitatId, string speciesId, Action<BuyResult> ok, Action<string> fail)
        {
            return Post("/v1/zoo/animals", "{" + Num("habitatId", habitatId) + "," + Str("speciesId", speciesId) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator Deliver(string foodId, int quantity, Action<DeliverResult> ok, Action<string> fail)
        {
            return Post("/v1/zoo/deliver", "{" + Str("foodId", foodId) + "," + Num("quantity", quantity) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator Feed(int habitatId, Action<FeedResult> ok, Action<string> fail)
        {
            return Post("/v1/zoo/feed", "{" + Num("habitatId", habitatId) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator OpenZoo(Action<ZooView> ok, Action<string> fail) { return Post("/v1/zoo/open", "{" + Req() + "}", ok, fail); }
        public IEnumerator CloseZoo(Action<CollectResult> ok, Action<string> fail) { return Post("/v1/zoo/close", "{" + Req() + "}", ok, fail); }
        public IEnumerator Collect(Action<CollectResult> ok, Action<string> fail) { return Post("/v1/zoo/collect", "{" + Req() + "}", ok, fail); }

        // ---------- Bạn bè ----------
        public IEnumerator GetFriends(Action<FriendsView> ok, Action<string> fail) { return Get("/v1/friends", ok, fail); }

        public IEnumerator SendFriendRequest(string friendName, Action<FriendsView> ok, Action<string> fail)
        {
            return Post("/v1/friends/request", "{" + Str("friendName", friendName) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator AcceptFriend(int friendId, Action<FriendsView> ok, Action<string> fail)
        {
            return Post("/v1/friends/accept", "{" + Num("friendId", friendId) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator RemoveFriend(int friendId, Action<FriendsView> ok, Action<string> fail)
        {
            return Post("/v1/friends/remove", "{" + Num("friendId", friendId) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator VisitFriend(int friendId, Action<VisitView> ok, Action<string> fail)
        {
            return Get("/v1/friends/visit?friendId=" + friendId, ok, fail);
        }

        public IEnumerator HelpFriend(int friendId, Action<HelpResult> ok, Action<string> fail)
        {
            return Post("/v1/friends/help", "{" + Num("friendId", friendId) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator GetLeaderboard(string type, Action<Leaderboard> ok, Action<string> fail)
        {
            return Get("/v1/leaderboard?type=" + type, ok, fail);
        }

        // ---------- Hộp thư / quà ----------
        public IEnumerator GetMails(Action<MailList> ok, Action<string> fail) { return Get("/v1/mails", ok, fail); }

        public IEnumerator ClaimMail(long mailId, Action<MailClaimResult> ok, Action<string> fail)
        {
            return Post("/v1/mails/claim", "{" + Num("mailId", mailId) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator ClaimAllMails(Action<ClaimAllResult> ok, Action<string> fail)
        {
            return Post("/v1/mails/claim-all", "{" + Req() + "}", ok, fail);
        }

        public IEnumerator RedeemGiftcode(string code, Action<RedeemResult> ok, Action<string> fail)
        {
            return Post("/v1/giftcodes/redeem", "{" + Str("code", code) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator GetAchievements(Action<AchievementList> ok, Action<string> fail)
        {
            return Get("/v1/achievements", ok, fail);
        }

        public IEnumerator ClaimAchievement(string achievementId, Action<AchievementClaimResult> ok, Action<string> fail)
        {
            return Post("/v1/achievements/claim", "{" + Str("achievementId", achievementId) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator GetCollection(Action<CollectionList> ok, Action<string> fail)
        {
            return Get("/v1/collection", ok, fail);
        }

        // ---------- Nhiệm vụ / minigame ----------
        public IEnumerator ClaimMission(string missionId, Action<ClaimResult> ok, Action<string> fail)
        {
            return Post("/v1/missions/claim", "{" + Str("missionId", missionId) + "," + Req() + "}", ok, fail);
        }

        public IEnumerator Checkin(Action<CheckinResult> ok, Action<string> fail) { return Post("/v1/daily/checkin", "{" + Req() + "}", ok, fail); }

        public IEnumerator StartMinigame(Action<MinigameSession> ok, Action<string> fail)
        {
            return Post("/v1/minigames/session", "{" + Req() + "}", ok, fail);
        }

        public IEnumerator FinishMinigame(string sessionId, int linesMade, Action<MinigameResult> ok, Action<string> fail)
        {
            return Post("/v1/minigames/finish", "{" + Str("sessionId", sessionId) + "," + Num("linesMade", linesMade) + "," + Req() + "}", ok, fail);
        }

        // ---------- Dựng JSON ----------
        static string Req() { return Str("requestId", Guid.NewGuid().ToString()); }
        static string Num(string key, long value) { return "\"" + key + "\":" + value; }
        static string Str(string key, string value)
        {
            return "\"" + key + "\":" + (value == null ? "null" : "\"" + Escape(value) + "\"");
        }

        static string Escape(string s)
        {
            var sb = new StringBuilder(s.Length + 8);
            foreach (char c in s)
            {
                switch (c)
                {
                    case '"': sb.Append("\\\""); break;
                    case '\\': sb.Append("\\\\"); break;
                    case '\n': sb.Append("\\n"); break;
                    case '\r': sb.Append("\\r"); break;
                    case '\t': sb.Append("\\t"); break;
                    default:
                        if (c < 0x20) sb.Append("\\u").Append(((int)c).ToString("x4"));
                        else sb.Append(c);
                        break;
                }
            }
            return sb.ToString();
        }

        // ---------- Lõi HTTP ----------
        IEnumerator Get<T>(string path, Action<T> ok, Action<string> fail) where T : class
        {
            using (var req = UnityWebRequest.Get(baseUrl + path))
            {
                ApplyHeaders(req);
                yield return req.SendWebRequest();
                Handle(req, ok, fail);
            }
        }

        IEnumerator Post<T>(string path, string jsonBody, Action<T> ok, Action<string> fail) where T : class
        {
            using (var req = new UnityWebRequest(baseUrl + path, "POST"))
            {
                req.uploadHandler = new UploadHandlerRaw(Encoding.UTF8.GetBytes(jsonBody));
                req.downloadHandler = new DownloadHandlerBuffer();
                req.SetRequestHeader("Content-Type", "application/json");
                ApplyHeaders(req);
                yield return req.SendWebRequest();
                Handle(req, ok, fail);
            }
        }

        void ApplyHeaders(UnityWebRequest req)
        {
            string token = !string.IsNullOrEmpty(SessionToken) ? SessionToken : GuestToken;
            if (!string.IsNullOrEmpty(token)) req.SetRequestHeader("X-Session-Token", token);
        }

        void Handle<T>(UnityWebRequest req, Action<T> ok, Action<string> fail) where T : class
        {
            string body = req.downloadHandler != null ? req.downloadHandler.text : "";
            bool success =
#if UNITY_2020_2_OR_NEWER
                req.result == UnityWebRequest.Result.Success;
#else
                !req.isNetworkError && !req.isHttpError;
#endif
            if (success)
            {
                try { ok(JsonUtility.FromJson<T>(body)); }
                catch (Exception e) { fail("Lỗi đọc dữ liệu: " + e.Message); }
                return;
            }

            if (req.responseCode == 401) ClearSession();

            string message = string.IsNullOrEmpty(req.error) ? "Không kết nối được máy chủ" : req.error;
            if (!string.IsNullOrEmpty(body))
            {
                try
                {
                    var err = JsonUtility.FromJson<ApiError>(body);
                    if (err != null && !string.IsNullOrEmpty(err.error)) message = err.error;
                }
                catch { }
            }
            fail(message);
        }
    }
}
