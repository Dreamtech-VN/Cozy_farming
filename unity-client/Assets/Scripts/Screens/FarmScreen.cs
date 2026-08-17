using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class FarmScreen : MonoBehaviour
    {
        public Transform plotGrid, storageContent, cropPickerContent;
        public GameObject plotPrefab, rowPrefab, cropPickerPanel;
        public Button closePickerButton;

        [Tooltip("Đặt tên sprite trùng id nông sản: wheat, corn, carrot, lettuce, potato, grass, bamboo, berry")]
        public Sprite[] cropSprites;
        public Sprite sproutSprite;

        readonly List<PlotCell> cells = new List<PlotCell>();
        int pickingPlot;

        void Start()
        {
            if (closePickerButton != null)
                closePickerButton.onClick.AddListener(delegate { cropPickerPanel.SetActive(false); });
        }

        void OnEnable()
        {
            cropPickerPanel.SetActive(false);
            BuildGrid();
            RefreshStorage();
        }

        Sprite CropSprite(string cropId)
        {
            if (cropSprites != null)
                foreach (var s in cropSprites) if (s != null && s.name == cropId) return s;
            return sproutSprite;
        }

        void BuildGrid()
        {
            if (App.I.Farm == null || App.I.Farm.plots == null) return;
            while (cells.Count < App.I.Farm.plots.Count)
                cells.Add(Instantiate(plotPrefab, plotGrid).GetComponent<PlotCell>());

            for (int i = 0; i < cells.Count && i < App.I.Farm.plots.Count; i++)
            {
                var plot = App.I.Farm.plots[i];
                cells[i].Bind(plot, CropSprite(plot.cropId), sproutSprite, OnPlotClicked);
            }
        }

        void OnPlotClicked(Plot plot)
        {
            if (plot.state == "EMPTY") OpenPicker(plot.plotIndex);
            else if (plot.state == "READY") StartCoroutine(DoHarvest(plot.plotIndex));
            else Toast.Show("Còn " + PlotCell.Format((plot.readyAt - Api.I.Now) / 1000) + " nữa chín");
        }

        void OpenPicker(int plotIndex)
        {
            pickingPlot = plotIndex;
            cropPickerPanel.SetActive(true);
            foreach (Transform child in cropPickerContent) Destroy(child.gameObject);
            if (App.I.Catalog == null) return;

            foreach (var crop in App.I.Catalog.crops)
            {
                var row = Instantiate(rowPrefab, cropPickerContent).GetComponent<Button>();
                bool locked = App.I.Me.farmLevel < crop.minFarmLevel;
                row.GetComponentInChildren<Text>().text = locked
                    ? crop.name + " — Cần Farm Lv" + crop.minFarmLevel
                    : crop.name + " — " + crop.seedCost + " Vàng · " + PlotCell.Format(crop.growthSeconds);
                row.interactable = !locked;
                string cropId = crop.id;
                row.onClick.AddListener(delegate { StartCoroutine(DoPlant(cropId)); });
            }
        }

        IEnumerator DoPlant(string cropId)
        {
            cropPickerPanel.SetActive(false);
            yield return Api.I.Plant(pickingPlot, cropId, delegate (PlantResult r)
            {
                var plot = App.I.Farm.plots[r.plotIndex];
                plot.state = "GROWING";
                plot.cropId = r.cropId;
                plot.plantedAt = Api.I.Now;
                plot.readyAt = r.readyAt;
                App.I.SetVang(r.vangBalance);
                BuildGrid();
            }, Toast.Show);
        }

        IEnumerator DoHarvest(int plotIndex)
        {
            yield return Api.I.Harvest(plotIndex, delegate (HarvestResult r)
            {
                Toast.Show("Thu hoạch " + r.yield + " " + App.I.CropName(r.cropId) + " (+" + r.xp + " XP)");
                var plot = App.I.Farm.plots[plotIndex];
                plot.state = "EMPTY";
                plot.cropId = null;
                Items.Set(App.I.Farm.storage, r.cropId, Items.Qty(App.I.Farm.storage, r.cropId) + r.yield);
                BuildGrid();
                RefreshStorage();
            }, Toast.Show);
        }

        void RefreshStorage()
        {
            foreach (Transform child in storageContent) Destroy(child.gameObject);
            if (App.I.Farm == null || App.I.Farm.storage == null) return;

            foreach (var item in App.I.Farm.storage)
            {
                if (item.quantity <= 0) continue;
                var crop = App.I.Crop(item.foodId);
                long price = crop != null ? crop.sellPrice : 0;
                var row = Instantiate(rowPrefab, storageContent).GetComponent<Button>();
                row.GetComponentInChildren<Text>().text =
                    App.I.CropName(item.foodId) + " x" + item.quantity + " — Bán " + (price * item.quantity) + " Vàng";
                string foodId = item.foodId;
                int quantity = item.quantity;
                row.onClick.AddListener(delegate { StartCoroutine(DoSell(foodId, quantity)); });
            }
        }

        IEnumerator DoSell(string foodId, int quantity)
        {
            yield return Api.I.Sell(foodId, quantity, delegate (SellResult r)
            {
                Toast.Show("Bán được " + r.vangEarned + " Vàng");
                Items.Set(App.I.Farm.storage, foodId, 0);
                App.I.SetVang(r.vangBalance);
                RefreshStorage();
            }, Toast.Show);
        }
    }
}
