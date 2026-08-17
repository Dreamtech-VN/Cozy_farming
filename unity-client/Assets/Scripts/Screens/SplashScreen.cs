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

        void Start()
        {
            if (retryButton != null)
                retryButton.onClick.AddListener(delegate { StartCoroutine(Boot()); });
        }

        void OnEnable() { StartCoroutine(Boot()); }

        IEnumerator Boot()
        {
            if (retryButton != null) retryButton.gameObject.SetActive(false);
            if (versionText != null) versionText.text = "v" + clientVersion;
            SetStatus("Đang kiểm tra máy chủ...", 0.2f);

            GameConfigDto config = null;
            string error = null;
            yield return Api.I.GetConfig(delegate (GameConfigDto c) { config = c; }, delegate (string e) { error = e; });

            if (config == null)
            {
                SetStatus("Không kết nối được máy chủ.\n" + error, 0f);
                if (retryButton != null) retryButton.gameObject.SetActive(true);
                yield break;
            }

            if (config.maintenance)
            {
                SetStatus(config.maintenanceMessage, 0f);
                if (retryButton != null) retryButton.gameObject.SetActive(true);
                yield break;
            }

            if (IsOlder(clientVersion, config.minClientVersion))
            {
                SetStatus("Cần cập nhật phiên bản mới để chơi tiếp.", 0f);
                yield break;
            }

            // Bù lệch đồng hồ máy người chơi so với server
            Api.I.ServerTimeOffset = config.serverTime - System.DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
            SetStatus("Đang đăng nhập...", 0.5f);

            if (!Api.I.HasToken)
            {
                ScreenManager.I.Show("S02_Login");
                yield break;
            }

            Profile me = null;
            yield return Api.I.GetMe(delegate (Profile p) { me = p; }, delegate (string e) { error = e; });
            SetStatus("", 1f);

            if (me == null)
            {
                ScreenManager.I.Show("S02_Login");
                yield break;
            }
            App.I.Me = me;
            ScreenManager.I.Show(string.IsNullOrEmpty(me.name) ? "S06_ServerSelect" : "S08_Loading");
        }

        void SetStatus(string message, float progress)
        {
            if (statusText != null) statusText.text = message;
            if (progressBar != null) progressBar.fillAmount = progress;
        }

        public static bool IsOlder(string a, string b)
        {
            if (string.IsNullOrEmpty(a) || string.IsNullOrEmpty(b)) return false;
            string[] x = a.Split('.'), y = b.Split('.');
            int n = Mathf.Min(x.Length, y.Length);
            for (int i = 0; i < n; i++)
            {
                int xi, yi;
                if (!int.TryParse(x[i], out xi) || !int.TryParse(y[i], out yi)) return false;
                if (xi != yi) return xi < yi;
            }
            return false;
        }
    }
}
