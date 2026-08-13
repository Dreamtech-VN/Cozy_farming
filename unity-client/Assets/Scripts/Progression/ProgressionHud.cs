using UnityEngine;
using UnityEngine.UI;

// Gắn vào 1 GameObject luôn active trong Canvas — hiện vàng/kim cương/level.
// Gọi ProgressionHud.RequestRefresh() sau mỗi hành động đổi tiền/exp
// (thắng trận, mua shop, nhận thư...) để cập nhật ngay thay vì đợi poll.
public class ProgressionHud : MonoBehaviour
{
    [SerializeField] private float refreshInterval = 10f;
    [SerializeField] private Text goldText;
    [SerializeField] private Text diamondText;
    [SerializeField] private Text levelText;

    private static ProgressionHud instance;
    private float timer;

    private void OnEnable()
    {
        instance = this;
        _ = Refresh();
    }

    private void OnDisable()
    {
        if (instance == this) instance = null;
    }

    private void Update()
    {
        timer += Time.deltaTime;
        if (timer >= refreshInterval)
        {
            timer = 0;
            _ = Refresh();
        }
    }

    public static void RequestRefresh()
    {
        if (instance != null) _ = instance.Refresh();
    }

    private async System.Threading.Tasks.Task Refresh()
    {
        if (!Session.IsLoggedIn) return;
        try
        {
            var wallet = await ProgressionService.GetWallet();
            var level = await ProgressionService.GetLevel();
            goldText.text = $"Vàng: {wallet.gold}";
            diamondText.text = $"KC: {wallet.diamond}";
            levelText.text = $"Lv.{level.level} ({level.exp} exp)";
        }
        catch (ApiException)
        {
            // best-effort, lần refresh sau tự thử lại
        }
    }
}
