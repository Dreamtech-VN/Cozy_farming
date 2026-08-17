using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class InventoryScreen : MonoBehaviour
    {
        public Transform content, plotPickerContent;
        public GameObject rowPrefab, plotPickerPanel;
        public Button closePickerButton;
        public Text emptyText;

        string pendingItemId;

        void Start()
        {
            if (closePickerButton != null)
                closePickerButton.onClick.AddListener(delegate { plotPickerPanel.SetActive(false); });
        }

        void OnEnable()
        {
            plotPickerPanel.SetActive(false);
            StartCoroutine(Load());
        }

        IEnumerator Load()
        {
            yield return Api.I.GetInventory(delegate (InventoryList list)
            {
                foreach (Transform child in content) Destroy(child.gameObject);
                int count = list != null && list.items != null ? list.items.Count : 0;
                emptyText.gameObject.SetActive(count == 0);
                if (count == 0) return;

                foreach (var item in list.items)
                {
                    var row = Instantiate(rowPrefab, content).GetComponent<Button>();
                    row.GetComponentInChildren<Text>().text =
                        item.name + " x" + item.quantity + "\n" + item.description;
                    string id = item.itemId;
                    string type = item.type;
                    row.onClick.AddListener(delegate { OnUse(id, type); });
                }
            }, Toast.Show);
        }

        void OnUse(string itemId, string type)
        {
            // Vật phẩm giục cây cần chọn ô đang trồng trước khi dùng.
            if (type == "GROW_BOOST")
            {
                pendingItemId = itemId;
                OpenPlotPicker();
                return;
            }
            StartCoroutine(Use(itemId, -1));
        }

        void OpenPlotPicker()
        {
            plotPickerPanel.SetActive(true);
            foreach (Transform child in plotPickerContent) Destroy(child.gameObject);

            bool any = false;
            if (App.I.Farm != null && App.I.Farm.plots != null)
                foreach (var plot in App.I.Farm.plots)
                {
                    if (plot.state != "GROWING") continue;
                    any = true;
                    var row = Instantiate(rowPrefab, plotPickerContent).GetComponent<Button>();
                    long left = (plot.readyAt - Api.I.Now) / 1000;
                    row.GetComponentInChildren<Text>().text =
                        "Ô " + (plot.plotIndex + 1) + " — " + App.I.CropName(plot.cropId)
                        + " còn " + PlotCell.Format(left);
                    int index = plot.plotIndex;
                    row.onClick.AddListener(delegate { StartCoroutine(Use(pendingItemId, index)); });
                }

            if (!any)
            {
                var row = Instantiate(rowPrefab, plotPickerContent).GetComponent<Button>();
                row.GetComponentInChildren<Text>().text = "Không có ô nào đang trồng";
                row.interactable = false;
            }
        }

        IEnumerator Use(string itemId, int plotIndex)
        {
            plotPickerPanel.SetActive(false);
            yield return Api.I.UseItem(itemId, plotIndex, delegate (UseItemResult r)
            {
                Toast.Show(r.effect);
                if (r.farmStorage != null && App.I.Farm != null) App.I.Farm.storage = r.farmStorage;
            }, Toast.Show);

            // Ô đất có thể vừa đổi trạng thái — nạp lại nông trại cho khớp
            yield return Api.I.GetFarm(delegate (FarmView f) { App.I.Farm = f; App.I.Changed(); }, delegate (string e) { });
            yield return Load();
        }
    }
}
