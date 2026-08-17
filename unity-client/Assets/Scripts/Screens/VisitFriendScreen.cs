using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class VisitFriendScreen : MonoBehaviour
    {
        public static VisitFriendScreen I;

        public Text titleText, statusText;
        public Transform plotGrid, habitatRow;
        public GameObject plotPrefab, habitatPrefab;
        public Button helpButton, backButton;

        [Tooltip("Dùng chung sprite với màn Farm/Zoo — kéo vào cho khớp")]
        public Sprite[] cropSprites, animalSprites;
        public Sprite sproutSprite;

        static int pendingFriendId = -1;
        int friendId;

        void Awake() { I = this; }

        void Start()
        {
            helpButton.onClick.AddListener(delegate { StartCoroutine(Help()); });
            backButton.onClick.AddListener(delegate { ScreenManager.I.Show("S24_Social", true); });
        }

        // Gọi từ danh sách bạn: mở screen kèm id cần xem.
        public static void Open(int id)
        {
            pendingFriendId = id;
            ScreenManager.I.Show("S26_VisitFriend", true);
        }

        void OnEnable()
        {
            if (pendingFriendId > 0) friendId = pendingFriendId;
            StartCoroutine(Load());
        }

        Sprite CropSprite(string cropId)
        {
            if (cropSprites != null)
                foreach (var s in cropSprites) if (s != null && s.name == cropId) return s;
            return sproutSprite;
        }

        IEnumerator Load()
        {
            yield return Api.I.VisitFriend(friendId, delegate (VisitView view)
            {
                titleText.text = "Nông trại của " + view.name;
                statusText.text = "Farm Lv" + view.farmLevel + " · Zoo Lv" + view.zooLevel
                                + " · hấp dẫn " + view.totalAppeal
                                + (view.isOpen ? " · Zoo đang mở" : " · Zoo đóng cửa");
                helpButton.gameObject.SetActive(view.canHelp);

                foreach (Transform child in plotGrid) Destroy(child.gameObject);
                if (view.plots != null)
                    foreach (var plot in view.plots)
                    {
                        var cell = Instantiate(plotPrefab, plotGrid).GetComponent<PlotCell>();
                        // Vườn bạn chỉ để xem — bấm không làm gì
                        cell.Bind(plot, CropSprite(plot.cropId), sproutSprite, delegate (Plot p) { });
                    }

                foreach (Transform child in habitatRow) Destroy(child.gameObject);
                if (view.habitats != null)
                    foreach (var habitat in view.habitats)
                        Instantiate(habitatPrefab, habitatRow).GetComponent<HabitatCard>()
                            .Bind(habitat, animalSprites, delegate (Habitat h) { });
            }, Toast.Show);
        }

        IEnumerator Help()
        {
            helpButton.interactable = false;
            yield return Api.I.HelpFriend(friendId, delegate (HelpResult r)
            {
                Toast.Show("Đã giúp bạn! +" + r.vangEarned + " Vàng (còn " + r.helpsLeftToday + " lượt hôm nay)");
                App.I.SetVang(r.vangBalance);
                helpButton.gameObject.SetActive(false);
            }, Toast.Show);
            helpButton.interactable = true;
        }
    }
}
