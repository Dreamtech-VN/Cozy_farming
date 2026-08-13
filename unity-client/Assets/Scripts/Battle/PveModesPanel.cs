using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;

// Panel gom các mode PvE ngoài Story: Adventure, Event Puzzle, Dungeon,
// Tower, Daily/Weekly Challenge. Dùng lại đúng battlePanel/boardRenderer/
// battleHud của màn Battle chung (kéo cùng reference như PvpPanel).
public class PveModesPanel : MonoBehaviour
{
    [SerializeField] private Transform modeListContent;
    [SerializeField] private Button modeButtonPrefab;
    [SerializeField] private Text errorText;

    [SerializeField] private GameObject battlePanel;
    [SerializeField] private BoardRenderer boardRenderer;
    [SerializeField] private BattleHud battleHud;

    private async void OnEnable()
    {
        await Refresh();
    }

    public async Task Refresh()
    {
        errorText.text = "";
        foreach (Transform child in modeListContent) Destroy(child.gameObject);

        var adventures = await BattleService.ListAdventureLevels();
        foreach (var level in adventures)
        {
            AddButton($"[Adventure] {level.name} — HP {level.enemyHp}", () => BattleService.StartAdventure(level.id));
        }

        var events = await BattleService.ListEventPuzzles();
        foreach (var ev in events)
        {
            AddButton($"[Sự kiện] {ev.name} — HP {ev.enemyHp}", () => BattleService.StartEventPuzzle(ev.id));
        }

        var dungeons = await BattleService.ListDungeons();
        foreach (var dungeon in dungeons)
        {
            AddButton($"[Dungeon] {dungeon.name} — {dungeon.floors.Count} tầng", () => BattleService.StartDungeon(dungeon.id));
        }

        var towers = await BattleService.ListTowers();
        foreach (var tower in towers)
        {
            AddButton($"[Tháp] {tower.name} — tối đa {tower.maxFloors} tầng", () => BattleService.StartTower(tower.id));
        }

        foreach (string type in new[] { "DAILY", "WEEKLY" })
        {
            var status = await BattleService.GetChallengeStatus(type);
            string label = status.available
                ? $"[Thử thách] {type}"
                : $"[Thử thách] {type} — chờ {status.cooldownRemainingMs / 60000} phút";
            string capturedType = type;
            AddButton(label, () => BattleService.StartChallenge(capturedType), status.available);
        }
    }

    private void AddButton(string label, System.Func<Task<BattleStateView>> start, bool interactable = true)
    {
        var btn = Instantiate(modeButtonPrefab, modeListContent);
        btn.GetComponentInChildren<Text>().text = label;
        btn.interactable = interactable;
        btn.onClick.AddListener(() => _ = StartBattle(start));
    }

    private async Task StartBattle(System.Func<Task<BattleStateView>> start)
    {
        try
        {
            var state = await start();
            Session.BattleId = state.battleId;
            gameObject.SetActive(false);
            battlePanel.SetActive(true);
            boardRenderer.DrawBoard(state.board);
            battleHud.Render(state);
            BattleEvents.RaiseStateUpdated(state);
        }
        catch (ApiException e)
        {
            errorText.text = $"Không bắt đầu được ({e.StatusCode}): {e.Message}";
        }
    }
}
