using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class SettingsScreen : MonoBehaviour
    {
        public Slider musicSlider, sfxSlider;
        public Text musicValueText, sfxValueText, accountText, versionText;
        public InputField oldPasswordInput, newPasswordInput;
        public Button changePasswordButton, backButton, logoutButton, walletButton;
        public GameObject linkPanel, passwordPanel;
        public InputField linkUsernameInput, linkPasswordInput;
        public Button linkButton;

        public const string MusicKey = "volume_music";
        public const string SfxKey = "volume_sfx";

        void Start()
        {
            musicSlider.value = PlayerPrefs.GetFloat(MusicKey, 0.7f);
            sfxSlider.value = PlayerPrefs.GetFloat(SfxKey, 1f);
            musicSlider.onValueChanged.AddListener(delegate (float v) { SetVolume(MusicKey, v); });
            sfxSlider.onValueChanged.AddListener(delegate (float v) { SetVolume(SfxKey, v); });
            ApplyVolumes();

            changePasswordButton.onClick.AddListener(delegate { StartCoroutine(ChangePassword()); });
            linkButton.onClick.AddListener(delegate { StartCoroutine(LinkAccount()); });
            logoutButton.onClick.AddListener(delegate { StartCoroutine(Logout()); });
            backButton.onClick.AddListener(delegate { ScreenManager.I.Show("S09_Lobby", true); });
            if (walletButton != null)
                walletButton.onClick.AddListener(delegate { ScreenManager.I.Show("S38_Wallet", true); });
        }

        void OnEnable()
        {
            // Tài khoản khách thì hiện khung liên kết, tài khoản thật thì hiện khung đổi mật khẩu.
            bool hasAccount = App.I.Me != null && App.I.Me.hasAccount;
            linkPanel.SetActive(!hasAccount);
            passwordPanel.SetActive(hasAccount);
            accountText.text = hasAccount
                ? "Tài khoản: " + (App.I.Me != null ? App.I.Me.name : "")
                : "Bạn đang chơi bằng tài khoản khách — mất máy là mất tiến độ. Đặt tên đăng nhập để giữ lại.";
            StartCoroutine(LoadVersion());
        }

        void SetVolume(string key, float value)
        {
            PlayerPrefs.SetFloat(key, value);
            PlayerPrefs.Save();
            ApplyVolumes();
        }

        void ApplyVolumes()
        {
            float music = PlayerPrefs.GetFloat(MusicKey, 0.7f);
            float sfx = PlayerPrefs.GetFloat(SfxKey, 1f);
            AudioListener.volume = Mathf.Max(music, sfx);
            musicValueText.text = Mathf.RoundToInt(music * 100) + "%";
            sfxValueText.text = Mathf.RoundToInt(sfx * 100) + "%";
        }

        IEnumerator LoadVersion()
        {
            yield return Api.I.GetConfig(delegate (GameConfigDto config)
            {
                versionText.text = "Phiên bản " + Application.version + " · máy chủ " + config.gameVersion;
            }, delegate (string e) { versionText.text = "Phiên bản " + Application.version; });
        }

        IEnumerator ChangePassword()
        {
            string oldPass = oldPasswordInput.text;
            string newPass = newPasswordInput.text;
            if (newPass.Length < 6) { Toast.Show("Mật khẩu mới cần từ 6 ký tự"); yield break; }

            changePasswordButton.interactable = false;
            yield return Api.I.ChangePassword(oldPass, newPass, delegate (OkResult r)
            {
                Toast.Show("Đã đổi mật khẩu");
                oldPasswordInput.text = "";
                newPasswordInput.text = "";
            }, Toast.Show);
            changePasswordButton.interactable = true;
        }

        // Khách → tài khoản thật: giữ nguyên tiến độ nhờ gửi kèm guestToken.
        IEnumerator LinkAccount()
        {
            string username = linkUsernameInput.text.Trim();
            string password = linkPasswordInput.text;
            if (username.Length < 4) { Toast.Show("Tên đăng nhập cần từ 4 ký tự"); yield break; }
            if (password.Length < 6) { Toast.Show("Mật khẩu cần từ 6 ký tự"); yield break; }

            linkButton.interactable = false;
            yield return Api.I.Register(username, password, true, delegate (LoginResult result)
            {
                Api.I.SaveTokens(result.sessionToken, result.guestToken);
                Toast.Show("Đã tạo tài khoản, tiến độ được giữ nguyên");
                linkUsernameInput.text = "";
                linkPasswordInput.text = "";
                StartCoroutine(RefreshProfile());
            }, Toast.Show);
            linkButton.interactable = true;
        }

        IEnumerator RefreshProfile()
        {
            yield return Api.I.GetMe(delegate (Profile me)
            {
                App.I.Me = me;
                App.I.Changed();
                OnEnable();
            }, delegate (string e) { });
        }

        IEnumerator Logout()
        {
            yield return Api.I.Logout(delegate (OkResult r) { }, delegate (string e) { });
            Api.I.ClearSession();
            ScreenManager.I.Show("S02_Login");
        }
    }
}
