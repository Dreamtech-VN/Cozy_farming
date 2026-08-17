using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class WalletScreen : MonoBehaviour
    {
        public Text vangText, kcText, emptyText;
        public Transform listContent;
        public GameObject rowPrefab;
        public Button backButton, moreButton;

        const int PageSize = 20;

        // Mã lý do server ghi trong sổ cái → chữ người chơi đọc được. Thiếu mã nào thì hiện nguyên mã.
        static readonly Dictionary<string, string> ReasonNames = new Dictionary<string, string>
        {
            {"STARTER", "Quà khởi đầu"}, {"SEED", "Mua hạt giống"}, {"SELL_PRODUCE", "Bán nông sản"},
            {"BUILD_HABITAT", "Xây chuồng"}, {"BUY_ANIMAL", "Mua thú"}, {"BUY_DECOR", "Mua trang trí"},
            {"ZOO_REVENUE", "Doanh thu sở thú"}, {"MISSION", "Nhiệm vụ"}, {"CHECKIN", "Điểm danh"},
            {"ACHIEVEMENT", "Thành tựu"}, {"MINIGAME", "Minigame"}, {"MAIL", "Hộp thư"},
            {"SHOP_BUY", "Mua ở cửa hàng"}, {"TOPUP_MOCK", "Nạp Kim Cương"},
            {"FRIEND_HELP", "Giúp bạn"}, {"FRIEND_HELPED", "Bạn bè ghé giúp"}
        };

        long nextCursor;
        bool loading;

        void Start()
        {
            backButton.onClick.AddListener(delegate { ScreenManager.I.Show("S09_Lobby", true); });
            moreButton.onClick.AddListener(delegate { StartCoroutine(LoadPage()); });
        }

        void OnEnable()
        {
            nextCursor = 0;
            foreach (Transform child in listContent) Destroy(child.gameObject);
            StartCoroutine(LoadPage());
        }

        IEnumerator LoadPage()
        {
            if (loading) yield break;
            loading = true;
            moreButton.interactable = false;

            yield return Api.I.GetWallet(nextCursor, PageSize, delegate (WalletView view)
            {
                if (view == null) return;
                vangText.text = "Vàng: " + view.vang.ToString("N0");
                kcText.text = "Kim Cương: " + view.kc.ToString("N0");
                if (view.entries != null)
                    foreach (var entry in view.entries) AddRow(entry);

                nextCursor = view.nextCursor;
                moreButton.gameObject.SetActive(nextCursor > 0);
                emptyText.gameObject.SetActive(listContent.childCount == 0);
            }, Toast.Show);

            moreButton.interactable = true;
            loading = false;
        }

        void AddRow(LedgerEntry entry)
        {
            var row = Instantiate(rowPrefab, listContent);
            var label = row.GetComponentInChildren<Text>();
            string sign = entry.amount >= 0 ? "+" : "";
            string currency = entry.currency == "KC" ? "KC" : "Vàng";
            string reason = ReasonNames.ContainsKey(entry.reason) ? ReasonNames[entry.reason] : entry.reason;
            label.text = When(entry.createdAt) + "  " + reason
                       + "   " + sign + entry.amount.ToString("N0") + " " + currency
                       + "   (còn " + entry.balanceAfter.ToString("N0") + ")";
            label.color = entry.amount >= 0 ? new Color(0.65f, 0.95f, 0.6f) : new Color(1f, 0.7f, 0.65f);
        }

        static string When(long epochMs)
        {
            return System.DateTimeOffset.FromUnixTimeMilliseconds(epochMs).ToLocalTime().ToString("dd/MM HH:mm");
        }
    }
}
