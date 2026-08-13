using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;

// Panel gom 3 mode "đánh chung 1 con trùm rồi BẮT BUỘC report": World Boss,
// Guild Boss, Guild War. Quên gọi report là sát thương KHÔNG được cộng vào
// HP/điểm chung (server không tự đồng bộ) — panel này tự report ngay khi
// trận cá nhân kết thúc, không phụ thuộc người chơi bấm gì thêm.
public class BossBattlePanel : MonoBehaviour
{
    private enum BossMode { WorldBoss, GuildBoss, GuildWar }

    [SerializeField] private Button worldBossButton;
    [SerializeField] private Button guildBossButton;
    [SerializeField] private Button guildWarButton;
    [SerializeField] private Text statusText;

    [SerializeField] private GameObject battlePanel;
    [SerializeField] private BoardRenderer boardRenderer;
    [SerializeField] private BattleHud battleHud;

    private BossMode currentMode;
    private bool reported;

    private async void OnEnable()
    {
        worldBossButton.onClick.AddListener(() => _ = StartBoss(BossMode.WorldBoss));
        guildBossButton.onClick.AddListener(() => _ = StartBoss(BossMode.GuildBoss));
        guildWarButton.onClick.AddListener(() => _ = StartBoss(BossMode.GuildWar));
        await RefreshStatus();
    }

    private void OnDisable()
    {
        worldBossButton.onClick.RemoveAllListeners();
        guildBossButton.onClick.RemoveAllListeners();
        guildWarButton.onClick.RemoveAllListeners();
        BattleEvents.StateUpdated -= OnBattleStateUpdated;
    }

    private async Task RefreshStatus()
    {
        try
        {
            var worldBoss = await BossService.WorldBossStatus();
            statusText.text = $"Trùm thế giới: {worldBoss.remainingHp}/{worldBoss.poolMaxHp} HP";
        }
        catch (ApiException e)
        {
            statusText.text = $"Không lấy được trạng thái trùm ({e.StatusCode})";
        }
    }

    private async Task StartBoss(BossMode mode)
    {
        statusText.text = "";
        try
        {
            currentMode = mode;
            reported = false;
            var state = mode switch
            {
                BossMode.WorldBoss => await BossService.WorldBossAttack(),
                BossMode.GuildBoss => await BossService.GuildBossAttack(),
                _ => await BossService.GuildWarAttack(),
            };
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
            statusText.text = $"Không đánh được ({e.StatusCode}): {e.Message}";
        }
    }

    private async void OnBattleStateUpdated(BattleStateView state)
    {
        bool isBossMode = state.mode == "WORLD_BOSS" || state.mode == "GUILD_BOSS" || state.mode == "GUILD_WAR";
        if (!isBossMode || state.status == "ONGOING" || reported) return;

        reported = true;
        BattleEvents.StateUpdated -= OnBattleStateUpdated;
        await ReportResult(state);
    }

    private async Task ReportResult(BattleStateView state)
    {
        battlePanel.SetActive(false);
        gameObject.SetActive(true);
        try
        {
            switch (currentMode)
            {
                case BossMode.WorldBoss:
                {
                    var report = await BossService.WorldBossReport(state.battleId);
                    statusText.text = $"Đã cộng {report.damageApplied} sát thương vào trùm thế giới"
                        + (report.poolDepleted ? $" — TRÙM GỤC! +{report.rewardExp} exp, +{report.rewardGold} vàng" : "");
                    break;
                }
                case BossMode.GuildBoss:
                {
                    var report = await BossService.GuildBossReport(state.battleId);
                    statusText.text = $"Đã cộng {report.damageApplied} sát thương vào trùm guild"
                        + (report.poolDepleted ? $" — TRÙM GỤC! +{report.rewardExp} exp, +{report.rewardGold} vàng" : "");
                    break;
                }
                default:
                {
                    var war = await BossService.GuildWarReport(state.battleId);
                    statusText.text = $"Guild War: {war.scoreA} - {war.scoreB}";
                    break;
                }
            }
            ProgressionHud.RequestRefresh();
        }
        catch (ApiException e)
        {
            statusText.text = $"Lỗi nộp kết quả ({e.StatusCode}): {e.Message}";
        }
        await RefreshStatus();
    }
}
