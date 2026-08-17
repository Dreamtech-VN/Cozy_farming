using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class BarnScreen : MonoBehaviour
    {
        [Serializable]
        public class LivestockArt
        {
            public string id;
            public Sprite sprite;
        }

        public Text slotText, storageText, emptyText;
        public Transform animalContent, buyContent;
        public GameObject rowPrefab, buyPanel;
        public Button feedButton, openBuyButton, closeBuyButton, backButton;
        public List<LivestockArt> livestockArt = new List<LivestockArt>();

        BarnView barn;

        void Start()
        {
            feedButton.onClick.AddListener(delegate { StartCoroutine(FeedAll()); });
            openBuyButton.onClick.AddListener(delegate { ShowBuyList(); });
            closeBuyButton.onClick.AddListener(delegate { buyPanel.SetActive(false); });
            backButton.onClick.AddListener(delegate { ScreenManager.I.Show("S10_Farm", true); });
        }

        void OnEnable()
        {
            buyPanel.SetActive(false);
            StartCoroutine(Load());
        }

        IEnumerator Load()
        {
            yield return Api.I.GetBarn(delegate (BarnView view) { barn = view; Redraw(); }, Toast.Show);
        }

        void Redraw()
        {
            if (barn == null) return;
            int count = barn.animals != null ? barn.animals.Count : 0;
            slotText.text = "Chuồng: " + count + "/" + barn.maxAnimals;
            emptyText.gameObject.SetActive(count == 0);

            foreach (Transform child in animalContent) Destroy(child.gameObject);
            if (barn.animals != null)
                foreach (var animal in barn.animals) AddAnimalRow(animal);

            storageText.text = BuildStorageLine();
        }

        void AddAnimalRow(BarnAnimal animal)
        {
            var row = Instantiate(rowPrefab, animalContent).GetComponent<Button>();
            var label = row.GetComponentInChildren<Text>();
            label.text = animal.name + "   " + StateLabel(animal);
            label.color = animal.state == "READY" ? new Color(0.65f, 0.95f, 0.6f) : Color.white;
            ApplyArt(row.transform, animal.speciesId);

            long id = animal.id;
            bool ready = animal.state == "READY";
            row.onClick.AddListener(delegate
            {
                if (ready) StartCoroutine(Collect(id));
                else Toast.Show("Chưa có sản phẩm để thu");
            });
        }

        string StateLabel(BarnAnimal animal)
        {
            if (animal.state == "HUNGRY") return "· đang đói (cần " + animal.foodQty + " " + FoodName(animal.foodId) + ")";
            if (animal.state == "READY") return "· có " + animal.productQty + " " + FoodName(animal.productId) + " — bấm để thu";
            long left = Math.Max(0, animal.readyAt - Api.I.Now) / 1000;
            return "· còn " + (left / 60) + "p" + (left % 60) + "s";
        }

        string FoodName(string id)
        {
            var catalog = App.I.Catalog;
            if (catalog != null)
            {
                if (catalog.crops != null) foreach (var c in catalog.crops) if (c.id == id) return c.name;
                if (catalog.products != null) foreach (var p in catalog.products) if (p.id == id) return p.name;
            }
            return id;
        }

        string BuildStorageLine()
        {
            if (barn.storage == null || barn.storage.Count == 0) return "Kho nông trại trống";
            var text = new System.Text.StringBuilder("Kho: ");
            foreach (var stack in barn.storage) text.Append(FoodName(stack.foodId)).Append(" x").Append(stack.quantity).Append("   ");
            return text.ToString();
        }

        void ShowBuyList()
        {
            buyPanel.SetActive(true);
            foreach (Transform child in buyContent) Destroy(child.gameObject);
            var catalog = App.I.Catalog;
            if (catalog == null || catalog.livestock == null) return;

            foreach (var def in catalog.livestock)
            {
                var row = Instantiate(rowPrefab, buyContent).GetComponent<Button>();
                bool locked = App.I.Me != null && App.I.Me.farmLevel < def.minFarmLevel;
                row.GetComponentInChildren<Text>().text = def.name + "   " + def.cost + " Vàng   "
                    + "· ăn " + def.foodQty + " " + FoodName(def.foodId)
                    + " → " + def.productQty + " " + FoodName(def.productId) + " sau " + (def.productSeconds / 60) + " phút"
                    + (locked ? "   [cần Farm Lv" + def.minFarmLevel + "]" : "");
                ApplyArt(row.transform, def.id);

                string id = def.id;
                row.interactable = !locked;
                row.onClick.AddListener(delegate { StartCoroutine(Buy(id)); });
            }
        }

        void ApplyArt(Transform row, string speciesId)
        {
            var found = row.Find("Icon");
            if (found == null) return;
            var icon = found.GetComponent<Image>();
            Sprite sprite = null;
            foreach (var art in livestockArt) if (art.id == speciesId) sprite = art.sprite;
            icon.gameObject.SetActive(sprite != null);
            if (sprite != null) icon.sprite = sprite;
        }

        IEnumerator Buy(string speciesId)
        {
            yield return Api.I.BuyLivestock(speciesId, delegate (BarnBuyResult result)
            {
                App.I.SetVang(result.vangBalance);
                barn.animals = result.animals;
                buyPanel.SetActive(false);
                Redraw();
            }, Toast.Show);
        }

        IEnumerator FeedAll()
        {
            feedButton.interactable = false;
            yield return Api.I.FeedLivestock(delegate (BarnFeedResult result)
            {
                Toast.Show("Đã cho " + result.fedCount + " con ăn");
                barn.animals = result.animals;
                barn.storage = result.storage;
                Redraw();
            }, Toast.Show);
            feedButton.interactable = true;
        }

        IEnumerator Collect(long animalId)
        {
            yield return Api.I.CollectLivestock(animalId, delegate (BarnCollectResult result)
            {
                Toast.Show("Thu được " + result.quantity + " " + FoodName(result.productId));
                barn.animals = result.animals;
                barn.storage = result.storage;
                Redraw();
            }, Toast.Show);
        }
    }
}
