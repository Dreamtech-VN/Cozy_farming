using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;

// Gắn vào panel PvP, độc lập với GameBootstrap (tự thêm nút mở panel này).
// Luồng: vào hàng chờ -> ghép cặp (ngay hoặc poll) -> đấu (dùng lại
// BoardRenderer/BattleHud của màn Battle chung) -> hết lượt/HP -> tự nộp
// điểm -> đợi đối thủ report nốt -> hiện kết quả thắng/thua/hoà.
public class PvpPanel : MonoBehaviour
{
    [SerializeField] private GameObject queuePanel;
    [SerializeField] private Text queueStatusText;
    [SerializeField] private Button joinButton;

    [SerializeField] private GameObject battlePanel;
    [SerializeField] private BoardRenderer boardRenderer;
    [SerializeField] private BattleHud battleHud;

    [SerializeField] private GameObject resultPanel;
    [SerializeField] private Text resultText;

    private string currentMatchId;

    private void OnEnable()
    {
        joinButton.onClick.AddListener(OnJoinClicked);
        resultPanel.SetActive(false);
        battlePanel.SetActive(false);
        queuePanel.SetActive(true);
    }

    private void OnDisable()
    {
        joinButton.onClick.RemoveListener(OnJoinClicked);
        BattleEvents.StateUpdated -= OnBattleStateUpdated;
    }

    private async void OnJoinClicked()
    {
        joinButton.interactable = false;
        queueStatusText.text = "Đang vào hàng chờ...";

        var join = await PvpService.JoinQueue();
        string matchId = join.matched ? join.matchId : await PollUntilMatched();
        await StartPvpBattle(matchId);
    }

    private async Task<string> PollUntilMatched()
    {
        queueStatusText.text = "Đang tìm đối thủ...";
        while (true)
        {
            await Task.Delay(2000); // poll mỗi 2 giây, đủ nhanh mà không spam server
            var mine = await PvpService.GetMyMatchOrNull();
            // So với LastPvpMatchId để không nhận nhầm trận PvP CŨ đã report xong (match/my trả
            // về trận gần nhất kể cả đã kết thúc, không tự phân biệt "mới ghép" hay "cũ còn sót").
            if (mine != null && mine.matchId != Session.LastPvpMatchId)
            {
                return mine.matchId;
            }
        }
    }

    private async Task StartPvpBattle(string matchId)
    {
        currentMatchId = matchId;
        queuePanel.SetActive(false);
        resultPanel.SetActive(false);
        battlePanel.SetActive(true);

        var state = await PvpService.StartMatch(matchId);
        Session.BattleId = state.battleId;
        boardRenderer.DrawBoard(state.board);
        battleHud.Render(state);
        BattleEvents.RaiseStateUpdated(state);

        BattleEvents.StateUpdated += OnBattleStateUpdated;
    }

    private async void OnBattleStateUpdated(BattleStateView state)
    {
        // BattleEvents dùng chung cho mọi mode — chỉ xử lý khi đúng trận PvP đang theo dõi.
        if (state.mode != "PVP" || state.status == "ONGOING") return;
        BattleEvents.StateUpdated -= OnBattleStateUpdated;
        await ReportAndShowResult(state.battleId);
    }

    private async Task ReportAndShowResult(string battleId)
    {
        battlePanel.SetActive(false);
        resultPanel.SetActive(true);
        resultText.text = "Đang nộp kết quả...";

        var report = await PvpService.ReportScore(currentMatchId, battleId);
        while (report.status != "RESOLVED")
        {
            resultText.text = "Đã đánh xong, đang đợi đối thủ nộp kết quả...";
            await Task.Delay(2000);
            report = await PvpService.GetMatchStatus(currentMatchId);
        }

        Session.LastPvpMatchId = currentMatchId;
        if (report.winnerUserId == null)
            resultText.text = "Hoà!";
        else if (report.winnerUserId == Session.UserId)
            resultText.text = "Thắng!";
        else
            resultText.text = "Thua trận PvP này rồi...";

        joinButton.interactable = true;
        queuePanel.SetActive(true);
    }
}
