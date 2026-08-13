using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

// Gắn vào panel cosmetic kiêm shop. LUÔN lấy catalog/giá/sở hữu từ server
// (không hardcode danh sách) — đúng nguyên tắc ở mục 8 UNITY_INTEGRATION.md.
// Item chưa sở hữu -> nút mua kèm giá vàng (POST /api/shop/cosmetics/buy);
// đã sở hữu -> nút trang bị.
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
        var shop = await ShopService.GetShop();
        var owned = await CosmeticService.GetOwned();
        ownedIds = owned.ToHashSet();
        currentAppearance = await CosmeticService.GetAppearance();

        foreach (Transform child in itemListContent) Destroy(child.gameObject);
        foreach (var item in shop)
        {
            bool isOwned = ownedIds.Contains(item.itemId);
            bool isEquipped = currentAppearance.SlotValue(item.type) == item.itemId;

            var btn = Instantiate(itemButtonPrefab, itemListContent);
            var label = btn.GetComponentInChildren<Text>();
            if (isEquipped)
            {
                label.text = $"[Đang trang bị] {item.name} ({item.type})";
                btn.interactable = false;
            }
            else if (isOwned)
            {
                label.text = $"Trang bị: {item.name} ({item.type})";
                btn.onClick.AddListener(() => _ = OnEquipClicked(item));
            }
            else
            {
                label.text = item.priceGold == 0
                    ? $"Nhận miễn phí: {item.name} ({item.type})"
                    : $"Mua {item.priceGold} vàng: {item.name} ({item.type})";
                btn.onClick.AddListener(() => _ = OnBuyClicked(item));
            }
        }
    }

    private async System.Threading.Tasks.Task OnBuyClicked(ShopItemResponse item)
    {
        try
        {
            await ShopService.Buy(item.itemId);
            await Refresh();
        }
        catch (ApiException e)
        {
            errorText.text = $"Không mua được ({e.StatusCode}): {e.Message}";
        }
    }

    private async System.Threading.Tasks.Task OnEquipClicked(ShopItemResponse item)
    {
        try
        {
            currentAppearance = await CosmeticService.Equip(item.type, item.itemId);
            await Refresh();
        }
        catch (ApiException e)
        {
            errorText.text = $"Không trang bị được ({e.StatusCode}): {e.Message}";
        }
    }
}
