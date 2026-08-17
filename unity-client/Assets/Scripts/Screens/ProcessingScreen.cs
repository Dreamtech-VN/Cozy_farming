using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class ProcessingScreen : MonoBehaviour
    {
        public Transform slotContent, recipeContent;
        public GameObject rowPrefab;
        public Text summaryText;

        readonly List<Text> slotTimers = new List<Text>();
        readonly List<long> slotReadyAt = new List<long>();

        void OnEnable() { StartCoroutine(Load()); }

        IEnumerator Load()
        {
            yield return Api.I.GetProcessing(Redraw, Toast.Show);
        }

        void Redraw(ProcessingView view)
        {
            if (view == null) return;
            slotTimers.Clear();
            slotReadyAt.Clear();

            int used = view.slots != null ? view.slots.Count : 0;
            summaryText.text = "Lò chế biến: " + used + "/" + view.maxSlots;

            foreach (Transform child in slotContent) Destroy(child.gameObject);
            if (view.slots != null)
                foreach (var slot in view.slots)
                {
                    var row = Instantiate(rowPrefab, slotContent).GetComponent<Button>();
                    var label = row.GetComponentInChildren<Text>();
                    row.interactable = slot.ready;
                    long id = slot.id;
                    row.onClick.AddListener(delegate { StartCoroutine(Collect(id)); });

                    if (slot.ready) label.text = slot.name + " — XONG, bấm để thu";
                    else
                    {
                        label.text = slot.name + " — đang làm...";
                        slotTimers.Add(label);
                        slotReadyAt.Add(slot.readyAt);
                    }
                }

            foreach (Transform child in recipeContent) Destroy(child.gameObject);
            if (App.I.Catalog == null || App.I.Catalog.recipes == null) return;

            foreach (var recipe in App.I.Catalog.recipes)
            {
                var row = Instantiate(rowPrefab, recipeContent).GetComponent<Button>();
                bool locked = App.I.Me.farmLevel < recipe.minFarmLevel;
                int have = Items.Qty(view.storage, recipe.inputFoodId);
                bool enough = have >= recipe.inputQty;

                row.GetComponentInChildren<Text>().text = locked
                    ? recipe.name + " — Cần Farm Lv" + recipe.minFarmLevel
                    : recipe.name + " — cần " + recipe.inputQty + " " + App.I.CropName(recipe.inputFoodId)
                      + " (có " + have + ") · " + PlotCell.Format(recipe.seconds);
                row.interactable = !locked && enough && used < view.maxSlots;
                string id = recipe.id;
                row.onClick.AddListener(delegate { StartCoroutine(Start(id)); });
            }
        }

        void Update()
        {
            for (int i = 0; i < slotTimers.Count; i++)
            {
                long left = (slotReadyAt[i] - Api.I.Now) / 1000;
                if (left <= 0) { slotTimers[i].text = "Xong! Mở lại màn này để thu"; continue; }
                slotTimers[i].text = "Đang làm... còn " + PlotCell.Format(left);
            }
        }

        IEnumerator Start(string recipeId)
        {
            yield return Api.I.StartProcessing(recipeId, delegate (ProcessStartResult r)
            {
                Toast.Show("Đã cho vào lò");
                if (App.I.Farm != null) App.I.Farm.storage = r.storage;
            }, Toast.Show);
            yield return Load();
        }

        IEnumerator Collect(long slotId)
        {
            yield return Api.I.CollectProcessing(slotId, delegate (ProcessCollectResult r)
            {
                Toast.Show("Thu được " + r.quantity + " " + App.I.CropName(r.outputFoodId));
                if (App.I.Farm != null) App.I.Farm.storage = r.storage;
                App.I.Changed();
            }, Toast.Show);
            yield return Load();
        }
    }
}
