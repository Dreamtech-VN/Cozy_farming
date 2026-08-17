using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class ZooScreen : MonoBehaviour
    {
        public Transform habitatGrid, buildContent, deliverContent, speciesContent;
        public GameObject habitatPrefab, rowPrefab, managePanel, habitatPanel;
        public Button actionButton, manageButton, feedButton, closeManageButton, closeHabitatButton;
        public Button marketButton, closeMarketButton;
        public Text statusText, actionText, habitatTitle, ratingText;
        public GameObject marketPanel;
        public Transform marketContent;

        [Tooltip("Đặt tên sprite trùng id loài: rabbit, sheep, monkey, giraffe, elephant, panda")]
        public Sprite[] animalSprites;

        Habitat selected;

        void Start()
        {
            manageButton.onClick.AddListener(OpenManage);
            feedButton.onClick.AddListener(delegate { StartCoroutine(DoFeed()); });
            if (closeManageButton != null) closeManageButton.onClick.AddListener(delegate { managePanel.SetActive(false); });
            if (closeHabitatButton != null) closeHabitatButton.onClick.AddListener(delegate { habitatPanel.SetActive(false); });
            if (marketButton != null) marketButton.onClick.AddListener(delegate { StartCoroutine(OpenMarket()); });
            if (closeMarketButton != null) closeMarketButton.onClick.AddListener(delegate { marketPanel.SetActive(false); });
        }

        void OnEnable()
        {
            managePanel.SetActive(false);
            habitatPanel.SetActive(false);
            if (marketPanel != null) marketPanel.SetActive(false);
            Redraw();
        }

        // Bảng điều khiển: cho người chơi thấy vì sao doanh thu cao hay thấp (spec §29.18).
        IEnumerator LoadReport()
        {
            yield return Api.I.GetZooReport(delegate (ZooReport report)
            {
                if (report == null || ratingText == null) return;
                ratingText.text = "Hạng " + report.stars.ToString("0.0") + "★  (" + report.rating + "/100)"
                    + "\nKhách: " + report.visitorsPerHour + "/giờ · sức chứa " + report.capacity
                    + "\nThu " + report.grossPerHour + " − vận hành " + report.maintenancePerHour
                    + " = " + report.netPerHour + " Vàng/giờ";
            }, delegate (string e) { });
        }

        IEnumerator OpenMarket()
        {
            marketPanel.SetActive(true);
            foreach (Transform child in marketContent) Destroy(child.gameObject);
            yield return Api.I.GetEmergencyMarket(delegate (MarketList list)
            {
                if (list == null || list.items == null) return;
                foreach (var item in list.items)
                {
                    var row = Instantiate(rowPrefab, marketContent).GetComponent<Button>();
                    row.GetComponentInChildren<Text>().text =
                        item.name + "  ·  " + item.price + " Vàng/cái  — bấm để mua 10";
                    string foodId = item.foodId;
                    row.onClick.AddListener(delegate { StartCoroutine(BuyFood(foodId, 10)); });
                }
            }, Toast.Show);
        }

        IEnumerator BuyFood(string foodId, int quantity)
        {
            yield return Api.I.BuyEmergencyFood(foodId, quantity, delegate (MarketResult result)
            {
                Toast.Show("Đã mua " + result.quantity + " vào kho Zoo (-" + result.spent + " Vàng)");
                App.I.SetVang(result.vangBalance);
                if (App.I.Zoo != null) App.I.Zoo.warehouse = result.warehouse;
                marketPanel.SetActive(false);
                Redraw();
            }, Toast.Show);
        }

        void Redraw()
        {
            var zoo = App.I.Zoo;
            if (zoo == null) return;

            statusText.text = (zoo.isOpen ? "Đang mở cửa" : "Đóng cửa")
                + "\nHấp dẫn: " + zoo.totalAppeal
                + " · No: " + Mathf.RoundToInt((float)zoo.foodCoverage * 100) + "%"
                + "\nChờ thu: " + zoo.pendingVang + " Vàng";

            foreach (Transform child in habitatGrid) Destroy(child.gameObject);
            if (zoo.habitats != null)
                foreach (var habitat in zoo.habitats)
                    Instantiate(habitatPrefab, habitatGrid).GetComponent<HabitatCard>()
                        .Bind(habitat, animalSprites, OpenHabitat);

            actionText.text = zoo.isOpen ? "Thu " + zoo.pendingVang + " Vàng" : "Mở cửa đón khách";
            actionButton.onClick.RemoveAllListeners();
            bool isOpen = zoo.isOpen;
            actionButton.onClick.AddListener(delegate { StartCoroutine(isOpen ? DoCollect() : DoOpen()); });
            StartCoroutine(LoadReport());
        }

        IEnumerator DoOpen()
        {
            yield return Api.I.OpenZoo(delegate (ZooView z) { App.I.Zoo = z; Redraw(); }, Toast.Show);
        }

        IEnumerator DoCollect()
        {
            yield return Api.I.Collect(delegate (CollectResult r)
            {
                Toast.Show("Thu được " + r.vangEarned + " Vàng (+" + r.zooXp + " XP)");
                App.I.SetVang(r.vangBalance);
            }, Toast.Show);
            yield return ReloadZoo();
        }

        // ---- Panel quản lý: xây chuồng + chuyển thức ăn ----
        void OpenManage()
        {
            managePanel.SetActive(true);

            foreach (Transform child in buildContent) Destroy(child.gameObject);
            if (App.I.Catalog != null)
                foreach (var type in App.I.Catalog.habitatTypes)
                {
                    var row = Instantiate(rowPrefab, buildContent).GetComponent<Button>();
                    bool locked = App.I.Me.zooLevel < type.minZooLevel;
                    row.GetComponentInChildren<Text>().text = locked
                        ? type.name + " — Cần Zoo Lv" + type.minZooLevel
                        : type.name + " — " + type.cost + " Vàng · " + type.capacity + " chỗ";
                    row.interactable = !locked;
                    string typeId = type.id;
                    row.onClick.AddListener(delegate { StartCoroutine(DoBuildHabitat(typeId)); });
                }

            foreach (Transform child in deliverContent) Destroy(child.gameObject);
            if (App.I.Farm != null && App.I.Farm.storage != null)
                foreach (var item in App.I.Farm.storage)
                {
                    if (item.quantity <= 0) continue;
                    var row = Instantiate(rowPrefab, deliverContent).GetComponent<Button>();
                    row.GetComponentInChildren<Text>().text =
                        "Chuyển " + App.I.CropName(item.foodId) + " x" + item.quantity + " sang Zoo";
                    string foodId = item.foodId;
                    int qty = item.quantity;
                    row.onClick.AddListener(delegate { StartCoroutine(DoDeliver(foodId, qty)); });
                }
        }

        IEnumerator DoBuildHabitat(string typeId)
        {
            managePanel.SetActive(false);
            yield return Api.I.BuyHabitat(typeId, delegate (BuyResult r) { App.I.SetVang(r.vangBalance); }, Toast.Show);
            yield return ReloadZoo();
        }

        IEnumerator DoDeliver(string foodId, int quantity)
        {
            managePanel.SetActive(false);
            yield return Api.I.Deliver(foodId, quantity, delegate (DeliverResult r)
            {
                App.I.Farm.storage = r.farmStorage;
                Toast.Show("Đã chuyển sang kho Zoo");
            }, Toast.Show);
            yield return ReloadZoo();
        }

        // ---- Panel chi tiết chuồng ----
        void OpenHabitat(Habitat habitat)
        {
            selected = habitat;
            habitatPanel.SetActive(true);
            habitatTitle.text = habitat.name + " (" + habitat.animals.Count + "/" + habitat.capacity + ")";

            foreach (Transform child in speciesContent) Destroy(child.gameObject);
            if (App.I.Catalog == null) return;

            foreach (var species in App.I.Catalog.species)
            {
                var row = Instantiate(rowPrefab, speciesContent).GetComponent<Button>();
                bool locked = App.I.Me.zooLevel < species.minZooLevel;
                string diet = "";
                foreach (var d in species.diet) diet += (diet.Length > 0 ? ", " : "") + App.I.CropName(d);
                row.GetComponentInChildren<Text>().text = locked
                    ? species.name + " — Cần Zoo Lv" + species.minZooLevel
                    : species.name + " [" + species.rarity + "] hấp dẫn " + species.appeal
                      + " · ăn " + diet + " — " + species.cost + " Vàng";
                row.interactable = !locked;
                string speciesId = species.id;
                row.onClick.AddListener(delegate { StartCoroutine(DoBuyAnimal(speciesId)); });
            }
        }

        IEnumerator DoBuyAnimal(string speciesId)
        {
            habitatPanel.SetActive(false);
            yield return Api.I.BuyAnimal(selected.id, speciesId,
                delegate (BuyResult r) { App.I.SetVang(r.vangBalance); }, Toast.Show);
            yield return ReloadZoo();
        }

        IEnumerator DoFeed()
        {
            habitatPanel.SetActive(false);
            yield return Api.I.Feed(selected.id,
                delegate (FeedResult r) { Toast.Show("Đã cho " + r.animalsFed + " con ăn"); }, Toast.Show);
            yield return ReloadZoo();
        }

        IEnumerator ReloadZoo()
        {
            yield return Api.I.GetZoo(delegate (ZooView z) { App.I.Zoo = z; App.I.Changed(); Redraw(); }, Toast.Show);
        }
    }
}
