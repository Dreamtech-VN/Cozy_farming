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
            loginButton.onClick.AddListener(delegate { StartCoroutine(DoLogin()); });
            guestButton.onClick.AddListener(delegate { StartCoroutine(DoGuest()); });
            registerLink.onClick.AddListener(delegate { ScreenManager.I.Show("S03_Register"); });
        }

        void OnEnable() { if (errorText != null) errorText.text = ""; }

        IEnumerator DoLogin()
        {
            errorText.text = "";
            SetBusy(true);
            yield return Api.I.Login(usernameInput.text, passwordInput.text, OnLogged, Fail);
            SetBusy(false);
        }

        IEnumerator DoGuest()
        {
            errorText.text = "";
            SetBusy(true);
            yield return Api.I.LoginGuest(OnLogged, Fail);
            SetBusy(false);
        }

        void OnLogged(LoginResult r)
        {
            Api.I.SaveTokens(r.sessionToken, r.guestToken);
            ScreenManager.I.Show(string.IsNullOrEmpty(r.name) ? "S06_ServerSelect" : "S08_Loading");
        }

        void Fail(string message) { errorText.text = message; }

        void SetBusy(bool busy)
        {
            loginButton.interactable = !busy;
            guestButton.interactable = !busy;
        }
    }
}
