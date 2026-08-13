using System.Linq;
using UnityEngine;
using UnityEngine.UI;

// Panel gom các tiện ích nhỏ: nhập giftcode, bảng sự kiện, cài đặt
// (thông báo đẩy + quyền riêng tư), gửi report hỗ trợ.
public class MiscPanel : MonoBehaviour
{
    [Header("Giftcode")]
    [SerializeField] private InputField giftcodeInput;
    [SerializeField] private Button redeemButton;

    [Header("Sự kiện")]
    [SerializeField] private Text eventBoardText;

    [Header("Cài đặt")]
    [SerializeField] private Toggle pushToggle;
    [SerializeField] private Toggle friendRequestToggle; // on = EVERYONE, off = NOBODY

    [Header("Hỗ trợ")]
    [SerializeField] private InputField supportInput;
    [SerializeField] private Button supportButton;

    [SerializeField] private Text statusText;

    private bool applyingSettings; // chặn callback toggle bắn ngược lúc đang nạp giá trị từ server

    private void OnEnable()
    {
        redeemButton.onClick.AddListener(OnRedeemClicked);
        supportButton.onClick.AddListener(OnSupportClicked);
        pushToggle.onValueChanged.AddListener(OnSettingsChanged);
        friendRequestToggle.onValueChanged.AddListener(OnSettingsChanged);
        _ = Refresh();
    }

    private void OnDisable()
    {
        redeemButton.onClick.RemoveAllListeners();
        supportButton.onClick.RemoveAllListeners();
        pushToggle.onValueChanged.RemoveAllListeners();
        friendRequestToggle.onValueChanged.RemoveAllListeners();
    }

    private async System.Threading.Tasks.Task Refresh()
    {
        statusText.text = "";
        try
        {
            var events = await EventBoardService.GetBoard();
            eventBoardText.text = events.Count == 0
                ? "Chưa có sự kiện nào đang chạy"
                : string.Join("\n", events.Select(e => $"• {e.title}: {e.description}"));

            applyingSettings = true;
            var settings = await SettingsService.Get();
            pushToggle.isOn = settings.pushNotifications;
            friendRequestToggle.isOn = settings.friendRequestPrivacy == "EVERYONE";
            applyingSettings = false;
        }
        catch (ApiException e)
        {
            statusText.text = $"Lỗi tải dữ liệu ({e.StatusCode}): {e.Message}";
        }
    }

    private async void OnRedeemClicked()
    {
        string code = giftcodeInput.text.Trim();
        if (code.Length == 0) return;
        try
        {
            var mail = await GiftcodeService.Redeem(code);
            giftcodeInput.text = "";
            statusText.text = $"Nhập code thành công — phần thưởng đã gửi vào hộp thư: {mail.title}";
        }
        catch (ApiException e)
        {
            statusText.text = $"Code không dùng được ({e.StatusCode}): {e.Message}";
        }
    }

    private async void OnSettingsChanged(bool _)
    {
        if (applyingSettings) return;
        try
        {
            await SettingsService.Update(
                pushNotifications: pushToggle.isOn,
                friendRequestPrivacy: friendRequestToggle.isOn ? "EVERYONE" : "NOBODY");
        }
        catch (ApiException e)
        {
            statusText.text = $"Không lưu được cài đặt ({e.StatusCode}): {e.Message}";
        }
    }

    private async void OnSupportClicked()
    {
        string message = supportInput.text.Trim();
        if (message.Length == 0) return;
        try
        {
            await SupportService.Report("contact", message); // server chỉ nhận "bug" hoặc "contact"
            supportInput.text = "";
            statusText.text = "Đã gửi report cho đội hỗ trợ";
        }
        catch (ApiException e)
        {
            statusText.text = $"Không gửi được report ({e.StatusCode}): {e.Message}";
        }
    }
}
