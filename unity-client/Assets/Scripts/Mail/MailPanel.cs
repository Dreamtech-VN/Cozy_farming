using System.Linq;
using UnityEngine;
using UnityEngine.UI;

// Hộp thư: list thư, bấm 1 thư -> đánh dấu đã đọc + nhận thưởng (nếu có).
public class MailPanel : MonoBehaviour
{
    [SerializeField] private Transform mailListContent;
    [SerializeField] private Button mailButtonPrefab;
    [SerializeField] private Text detailText;
    [SerializeField] private Text errorText;

    private void OnEnable()
    {
        _ = Refresh();
    }

    public async System.Threading.Tasks.Task Refresh()
    {
        errorText.text = "";
        foreach (Transform child in mailListContent) Destroy(child.gameObject);

        var mails = await MailService.List();
        foreach (var mail in mails)
        {
            var btn = Instantiate(mailButtonPrefab, mailListContent);
            string unread = mail.readAt == null ? "● " : "";
            string hasReward = mail.rewards != null && mail.rewards.Count > 0 && mail.claimedAt == null ? " [có quà]" : "";
            btn.GetComponentInChildren<Text>().text = $"{unread}{mail.title}{hasReward}";
            btn.onClick.AddListener(() => _ = OnMailClicked(mail));
        }
    }

    private async System.Threading.Tasks.Task OnMailClicked(MailViewResponse mail)
    {
        detailText.text = $"{mail.title}\n\n{mail.body}";
        try
        {
            if (mail.readAt == null)
            {
                await MailService.MarkRead(mail.id);
            }
            if (mail.rewards != null && mail.rewards.Count > 0 && mail.claimedAt == null)
            {
                var claim = await MailService.Claim(mail.id);
                string granted = string.Join(", ", claim.granted.Select(g => $"{g.itemName} x{g.quantity}"));
                detailText.text += $"\n\nĐã nhận: {granted}";
                ProgressionHud.RequestRefresh();
            }
            await Refresh();
        }
        catch (ApiException e)
        {
            errorText.text = $"Lỗi xử lý thư ({e.StatusCode}): {e.Message}";
        }
    }
}
