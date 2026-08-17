using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class ShopScreen : MonoBehaviour
    {
        public Transform itemContent, packContent;
        public GameObject rowPrefab;
        public Button itemTabButton, packTabButton;
        public Text titleText, noteText;

        bool showPacks;
        ShopCatalogDto catalog;

        void Start()
        {
            itemTabButton.onClick.AddListener(delegate { Switch(false); });
            packTabButton.onClick.AddListener(delegate { Switch(true); });
        }

        void OnEnable()
        {
            showPacks = false;
            StartCoroutine(Load());
        }

        void Switch(bool packs)
        {
            showPacks = packs;
            Redraw();
        }

        IEnumerator Load()
        {
            yield return Api.I.GetShop(delegate (ShopCatalogDto c) { catalog = c; Redraw(); }, Toast.Show);
        }

        void Redraw()
        {
            if (catalog == null) return;
            itemTabButton.interactable = showPacks;
            packTabButton.interactable = !showPacks;
            titleText.text = showPacks ? "Nạp Kim Cương" : "Cửa hàng";
            noteText.text = showPacks
                ? "Bản thử nghiệm: nạp giả lập, chưa trừ tiền thật."
                : "Vàng và Kim Cương tách riêng — không quy đổi qua lại.";

            itemContent.parent.parent.gameObject.SetActive(!showPacks);
            packContent.parent.parent.gameObject.SetActive(showPacks);

            if (!showPacks)
            {
                foreach (Transform child in itemContent) Destroy(child.gameObject);
                if (catalog.items == null) return;
                foreach (var item in catalog.items)
                {
                    var row = Instantiate(rowPrefab, itemContent).GetComponent<Button>();
                    string money = item.currency == "KC" ? item.price + " KC" : item.price + " Vàng";
                    row.GetComponentInChildren<Text>().text = item.name + " — " + money + "\n" + item.description;
                    string id = item.id;
                    row.onClick.AddListener(delegate { StartCoroutine(Buy(id)); });
                }
            }
            else
            {
                foreach (Transform child in packContent) Destroy(child.gameObject);
                if (catalog.kcPacks == null) return;
                foreach (var pack in catalog.kcPacks)
                {
                    var row = Instantiate(rowPrefab, packContent).GetComponent<Button>();
                    row.GetComponentInChildren<Text>().text =
                        pack.name + " — " + pack.kcAmount + " KC   (" + pack.priceVnd.ToString("N0") + "đ)";
                    string id = pack.id;
                    row.onClick.AddListener(delegate { StartCoroutine(Topup(id)); });
                }
            }
        }

        IEnumerator Buy(string itemId)
        {
            yield return Api.I.Purchase(itemId, 1, delegate (PurchaseResult r)
            {
                Toast.Show("Đã mua! Xem trong Kho đồ.");
                if (App.I.Me != null && App.I.Me.wallets != null)
                {
                    App.I.Me.wallets.VANG = r.vangBalance;
                    App.I.Me.wallets.KC = r.kcBalance;
                }
                App.I.Changed();
            }, Toast.Show);
        }

        IEnumerator Topup(string packId)
        {
            yield return Api.I.Topup(packId, delegate (TopupResult r)
            {
                Toast.Show("Đã nạp " + r.kcAdded + " Kim Cương");
                if (App.I.Me != null && App.I.Me.wallets != null) App.I.Me.wallets.KC = r.kcBalance;
                App.I.Changed();
            }, Toast.Show);
        }
    }
}
