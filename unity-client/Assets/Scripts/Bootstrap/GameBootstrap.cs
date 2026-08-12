using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;

// Gắn vào 1 GameObject rỗng trong scene, kéo các reference qua Inspector.
// Vòng lặp MVP: đăng nhập khách -> chọn màn Story -> vào màn hình chiến đấu.
public class GameBootstrap : MonoBehaviour
{
    [SerializeField] private GameObject characterCreatePanelObject;
    [SerializeField] private CharacterCreatePanel characterCreatePanel;
    [SerializeField] private GameObject levelSelectPanel;
    [SerializeField] private GameObject battlePanel;
    [SerializeField] private Transform levelListContent;
    [SerializeField] private Button levelButtonPrefab;
    [SerializeField] private Text statusText;
    [SerializeField] private BoardRenderer boardRenderer;
    [SerializeField] private BattleHud battleHud;

    private async void Start()
    {
        characterCreatePanelObject.SetActive(false);
        battlePanel.SetActive(false);
        levelSelectPanel.SetActive(false);
        statusText.text = "Đang đăng nhập...";

        try
        {
            await AuthService.LoginAsGuest();
        }
        catch (ApiException e)
        {
            statusText.text = $"Không đăng nhập được ({e.StatusCode}): {e.Message}\nKiểm tra server đang chạy ở {ApiClient.BaseUrl}";
            return;
        }

        var character = await CharacterService.GetMyCharacterOrNull();
        if (character == null)
        {
            ShowCharacterCreate();
            return;
        }

        await ShowLevelSelect();
    }

    private void ShowCharacterCreate()
    {
        characterCreatePanelObject.SetActive(true);
        characterCreatePanel.Created += OnCharacterCreated;
    }

    private async void OnCharacterCreated(CharacterResponse character)
    {
        characterCreatePanel.Created -= OnCharacterCreated;
        characterCreatePanelObject.SetActive(false);
        await ShowLevelSelect();
    }

    private async Task ShowLevelSelect()
    {
        battlePanel.SetActive(false);
        levelSelectPanel.SetActive(true);
        foreach (Transform child in levelListContent) Destroy(child.gameObject);

        var levels = await BattleService.ListStoryLevels();
        foreach (var level in levels)
        {
            var btn = Instantiate(levelButtonPrefab, levelListContent);
            btn.GetComponentInChildren<Text>().text = $"{level.name} — HP {level.enemyHp} — thưởng {level.rewardGold} vàng";
            btn.onClick.AddListener(() => _ = StartBattle(level.id));
        }
    }

    private async Task StartBattle(int levelId)
    {
        levelSelectPanel.SetActive(false);
        battlePanel.SetActive(true);

        var state = await BattleService.StartStory(levelId);
        Session.BattleId = state.battleId;
        boardRenderer.DrawBoard(state.board);
        BattleEvents.RaiseStateUpdated(state);
        battleHud.Render(state);
    }
}
