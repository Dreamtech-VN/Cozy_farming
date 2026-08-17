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
            submitButton.onClick.AddListener(delegate { StartCoroutine(DoRegister()); });
            backLink.onClick.AddListener(delegate { ScreenManager.I.Show("S02_Login"); });
        }

        void OnEnable() { if (errorText != null) errorText.text = ""; }

        IEnumerator DoRegister()
        {
            errorText.text = "";
            if (passwordInput.text != confirmInput.text) { errorText.text = "Hai ô mật khẩu chưa khớp"; yield break; }
            if (termsToggle != null && !termsToggle.isOn) { errorText.text = "Cần đồng ý điều khoản"; yield break; }

            submitButton.interactable = false;
            // Đang chơi khách mà đăng ký => gửi kèm guestToken để GIỮ NGUYÊN tiến độ
            bool keepProgress = !string.IsNullOrEmpty(Api.I.GuestToken);
            yield return Api.I.Register(usernameInput.text, passwordInput.text, keepProgress,
                delegate (LoginResult r)
                {
                    Api.I.SaveTokens(r.sessionToken, null);
                    ScreenManager.I.Show(r.needsCharacter ? "S06_ServerSelect" : "S08_Loading");
                },
                delegate (string e) { errorText.text = e; });
            submitButton.interactable = true;
        }
    }
}
