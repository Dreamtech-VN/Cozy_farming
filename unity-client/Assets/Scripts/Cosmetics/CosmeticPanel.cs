using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

// Gắn vào panel cosmetic. LUÔN lấy catalog/sở hữu từ server (không hardcode
// danh sách) — đúng nguyên tắc ở mục 8 UNITY_INTEGRATION.md. UnlockCosmeticHandler
// bên server hiện là hook tạm (chưa có shop/thành tựu thật) nên panel này
// không có nút "mua" — chỉ list + trang bị/tháo những gì đã sở hữu.
public class CosmeticPanel : MonoBehaviour
{
    [SerializeField] private Transform itemListContent;
    [SerializeField] private Button itemButtonPrefab;
    [SerializeField] private Text errorText;

    private HashSet<int> ownedIds = new();
    private CharacterAppearanceResponse currentAppearance;

    private async void OnEnable()
    {
        await Refresh();
    }

    public async System.Threading.Tasks.Task Refresh()
    {
        errorText.text = "";
        var catalog = await CosmeticService.GetCatalog();
        var owned = await CosmeticService.GetOwned();
        ownedIds = owned.ToHashSet();
        currentAppearance = await CosmeticService.GetAppearance();

        foreach (Transform child in itemListContent) Destroy(child.gameObject);
        foreach (var item in catalog)
        {
            bool isOwned = ownedIds.Contains(item.id);
            bool isEquipped = currentAppearance.SlotValue(item.type) == item.id;

            var btn = Instantiate(itemButtonPrefab, itemListContent);
            string state = isEquipped ? "[Đang trang bị] " : isOwned ? "" : "[Chưa sở hữu] ";
            btn.GetComponentInChildren<Text>().text = $"{state}{item.name} ({item.type})";
            btn.interactable = isOwned && !isEquipped;
            btn.onClick.AddListener(() => _ = OnEquipClicked(item));
        }
    }

    private async System.Threading.Tasks.Task OnEquipClicked(CosmeticDefResponse item)
    {
        try
        {
            currentAppearance = await CosmeticService.Equip(item.type, item.id);
            await Refresh();
        }
        catch (ApiException e)
        {
            errorText.text = $"Không trang bị được ({e.StatusCode}): {e.Message}";
        }
    }
}
