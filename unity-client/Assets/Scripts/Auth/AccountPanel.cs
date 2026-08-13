using UnityEngine;
using UnityEngine.UI;

// Panel tài khoản: nâng cấp guest thành tài khoản có mật khẩu (giữ nguyên
// dữ liệu chơi), hoặc đăng nhập tài khoản khác. Đăng nhập Google/Apple cần
// SDK OAuth riêng — chưa nối ở đây.
public class AccountPanel : MonoBehaviour
{
    [SerializeField] private InputField usernameInput;
    [SerializeField] private InputField passwordInput;
    [SerializeField] private Button upgradeButton;
    [SerializeField] private Button loginButton;
    [SerializeField] private Text statusText;

    private void OnEnable()
    {
        upgradeButton.onClick.AddListener(OnUpgradeClicked);
        loginButton.onClick.AddListener(OnLoginClicked);
        statusText.text = $"Đang chơi bằng user #{Session.UserId}";
    }

    private void OnDisable()
    {
        upgradeButton.onClick.RemoveAllListeners();
        loginButton.onClick.RemoveAllListeners();
    }

    private async void OnUpgradeClicked()
    {
        try
        {
            var res = await AccountService.UpgradeGuest(usernameInput.text.Trim(), passwordInput.text);
            statusText.text = $"Đã gắn tài khoản '{res.username}' — từ giờ đăng nhập được bằng mật khẩu";
        }
        catch (ApiException e)
        {
            statusText.text = $"Không nâng cấp được ({e.StatusCode}): {e.Message}";
        }
    }

    private async void OnLoginClicked()
    {
        try
        {
            var res = await AccountService.Login(usernameInput.text.Trim(), passwordInput.text);
            statusText.text = $"Đã đăng nhập '{res.username}' (user #{res.userId}) — khởi động lại luồng chơi để nạp dữ liệu mới";
        }
        catch (ApiException e)
        {
            statusText.text = $"Không đăng nhập được ({e.StatusCode}): {e.Message}";
        }
    }
}
