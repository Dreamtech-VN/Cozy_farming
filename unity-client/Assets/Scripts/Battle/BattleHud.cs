using UnityEngine;
using UnityEngine.UI;

public class BattleHud : MonoBehaviour
{
    [SerializeField] private Slider playerHpBar;
    [SerializeField] private Slider enemyHpBar;
    [SerializeField] private Slider manaBar;
    [SerializeField] private Button ultimateButton;
    [SerializeField] private Text statusText;

    private void OnEnable()
    {
        BattleEvents.StateUpdated += Render;
        ultimateButton.onClick.AddListener(OnUltimateClicked);
    }

    private void OnDisable()
    {
        BattleEvents.StateUpdated -= Render;
        ultimateButton.onClick.RemoveListener(OnUltimateClicked);
    }

    public void Render(BattleStateView state)
    {
        playerHpBar.maxValue = state.playerHpMax;
        playerHpBar.value = state.playerHp;
        enemyHpBar.maxValue = state.enemyHpMax;
        enemyHpBar.value = state.enemyHp;
        manaBar.maxValue = state.manaMax;
        manaBar.value = state.mana;
        ultimateButton.interactable = state.mana >= state.manaMax && state.status == "ONGOING";

        if (state.status == "WON")
        {
            statusText.text = $"Thắng! +{state.rewardExp} EXP, +{state.rewardGold} vàng";
            ProgressionHud.RequestRefresh();
        }
        else if (state.status == "LOST")
            statusText.text = "Thua trận rồi...";
        else if (state.matched)
            statusText.text = state.critical
                ? $"Chí mạng! Sát thương {state.damageDealt}"
                : $"Sát thương {state.damageDealt}";
        else
            statusText.text = "Chọn 2 ô liền kề để đổi";
    }

    private async void OnUltimateClicked()
    {
        var result = await BattleService.UseUltimate();
        Render(result);
        BattleEvents.RaiseStateUpdated(result);
    }
}
