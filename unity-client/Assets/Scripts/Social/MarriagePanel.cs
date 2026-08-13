using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;

// Panel hôn nhân: xem trạng thái, cầu hôn theo userId (nhẫn mua bằng vàng),
// ly hôn, nhận thưởng duo-quest, và đấu co-op (dùng lại màn battle chung,
// BẮT BUỘC report sau trận giống boss — quên là mất điểm thân mật).
public class MarriagePanel : MonoBehaviour
{
    [SerializeField] private Text statusText;
    [SerializeField] private InputField proposeInput;
    [SerializeField] private Button proposeButton;
    [SerializeField] private Button divorceButton;
    [SerializeField] private Button duoQuestButton;
    [SerializeField] private Button coopBattleButton;
    [SerializeField] private Text errorText;

    [SerializeField] private GameObject battlePanel;
    [SerializeField] private BoardRenderer boardRenderer;
    [SerializeField] private BattleHud battleHud;

    private bool reported;

    private void OnEnable()
    {
        proposeButton.onClick.AddListener(OnProposeClicked);
        divorceButton.onClick.AddListener(OnDivorceClicked);
        duoQuestButton.onClick.AddListener(OnDuoQuestClicked);
        coopBattleButton.onClick.AddListener(() => _ = OnCoopBattleClicked());
        _ = Refresh();
    }

    private void OnDisable()
    {
        proposeButton.onClick.RemoveAllListeners();
        divorceButton.onClick.RemoveAllListeners();
        duoQuestButton.onClick.RemoveAllListeners();
        coopBattleButton.onClick.RemoveAllListeners();
        BattleEvents.StateUpdated -= OnBattleStateUpdated;
    }

    public async Task Refresh()
    {
        errorText.text = "";
        try
        {
            var status = await MarriageService.Status();
            statusText.text = status.married
                ? $"Đã kết hôn với user #{status.spouseUserId}"
                : "Chưa kết hôn";
            divorceButton.interactable = status.married;
            duoQuestButton.interactable = status.married;
            coopBattleButton.interactable = status.married;
        }
        catch (ApiException e)
        {
            statusText.text = $"Không lấy được trạng thái ({e.StatusCode})";
        }
    }

    private async void OnProposeClicked()
    {
        if (!int.TryParse(proposeInput.text.Trim(), out int toUserId))
        {
            errorText.text = "Nhập userId (số) của người muốn cầu hôn";
            return;
        }
        try
        {
            await MarriageService.Propose(toUserId, "GOLD");
            errorText.text = "Đã gửi lời cầu hôn (nhẫn mua bằng vàng)";
            ProgressionHud.RequestRefresh();
        }
        catch (ApiException e)
        {
            errorText.text = $"Không cầu hôn được ({e.StatusCode}): {e.Message}";
        }
    }

    private async void OnDivorceClicked()
    {
        try
        {
            await MarriageService.Divorce();
            await Refresh();
        }
        catch (ApiException e)
        {
            errorText.text = $"Không ly hôn được ({e.StatusCode}): {e.Message}";
        }
    }

    private async void OnDuoQuestClicked()
    {
        try
        {
            var res = await MarriageService.ClaimDuoQuest();
            errorText.text = res.awarded
                ? $"+{res.intimacyPoints} điểm thân mật"
                : $"Chưa nhận được: {res.reason}";
        }
        catch (ApiException e)
        {
            errorText.text = $"Không nhận được ({e.StatusCode}): {e.Message}";
        }
    }

    private async Task OnCoopBattleClicked()
    {
        try
        {
            reported = false;
            var state = await MarriageService.StartCoopBattle();
            Session.BattleId = state.battleId;
            gameObject.SetActive(false);
            battlePanel.SetActive(true);
            boardRenderer.DrawBoard(state.board);
            battleHud.Render(state);
            BattleEvents.RaiseStateUpdated(state);
            BattleEvents.StateUpdated += OnBattleStateUpdated;
        }
        catch (ApiException e)
        {
            errorText.text = $"Không bắt đầu được ({e.StatusCode}): {e.Message}";
        }
    }

    private async void OnBattleStateUpdated(BattleStateView state)
    {
        if (state.mode != "MARRIAGE_COOP" || state.status == "ONGOING" || reported) return;
        reported = true;
        BattleEvents.StateUpdated -= OnBattleStateUpdated;

        battlePanel.SetActive(false);
        gameObject.SetActive(true);
        try
        {
            var report = await MarriageService.ReportCoopBattle(state.battleId);
            errorText.text = report.bonusAwarded
                ? $"Đấu co-op xong: {report.damageDealt} sát thương, +{report.intimacyPoints} thân mật"
                : $"Đấu co-op xong: {report.damageDealt} sát thương";
        }
        catch (ApiException e)
        {
            errorText.text = $"Lỗi nộp kết quả co-op ({e.StatusCode}): {e.Message}";
        }
        await Refresh();
    }
}
