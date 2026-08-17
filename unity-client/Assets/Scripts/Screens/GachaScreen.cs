using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class GachaScreen : MonoBehaviour
    {
        // Sprite cho từng món ngoại hình, khớp id server trả về. Bỏ trống thì hiện tên chữ.
        [Serializable]
        public class CosmeticArt
        {
            public string id;
            public Sprite sprite;
        }

        public Text bannerNameText, costText, pityText, fragmentText, rateText;
        public Button pullOneButton, pullTenButton, ratesButton, closeRatesButton, backButton, historyButton;
        public Transform resultContent, historyContent;
        public GameObject rowPrefab, ratePanel, resultPanel, historyPanel;
        public Button closeResultButton, closeHistoryButton;
        public List<CosmeticArt> cosmeticArt = new List<CosmeticArt>();

        static readonly Dictionary<string, Color> TierColors = new Dictionary<string, Color>
        {
            {"R", new Color(0.85f, 0.85f, 0.85f)},
            {"SR", new Color(0.60f, 0.85f, 1f)},
            {"SSR", new Color(1f, 0.85f, 0.40f)},
            {"UR", new Color(1f, 0.55f, 0.85f)}
        };

        GachaBanner banner;
        bool busy;

        void Start()
        {
            pullOneButton.onClick.AddListener(delegate { StartCoroutine(DoPull(1)); });
            pullTenButton.onClick.AddListener(delegate { StartCoroutine(DoPull(10)); });
            ratesButton.onClick.AddListener(delegate { ratePanel.SetActive(true); });
            closeRatesButton.onClick.AddListener(delegate { ratePanel.SetActive(false); });
            closeResultButton.onClick.AddListener(delegate { resultPanel.SetActive(false); });
            closeHistoryButton.onClick.AddListener(delegate { historyPanel.SetActive(false); });
            historyButton.onClick.AddListener(delegate { StartCoroutine(LoadHistory()); });
            backButton.onClick.AddListener(delegate { ScreenManager.I.Show("S09_Lobby", true); });
        }

        void OnEnable()
        {
            ratePanel.SetActive(false);
            resultPanel.SetActive(false);
            historyPanel.SetActive(false);
            StartCoroutine(Load());
        }

        IEnumerator Load()
        {
            yield return Api.I.GetBanners(delegate (BannerList list)
            {
                if (list == null || list.banners == null || list.banners.Count == 0)
                {
                    bannerNameText.text = "Hiện chưa có đợt quay nào";
                    SetInteractable(false);
                    return;
                }
                banner = list.banners[0];
                bannerNameText.text = banner.name;
                costText.text = "1 lượt: " + banner.costSingle + " KC   ·   10 lượt: " + banner.costTen + " KC";
                rateText.text = BuildRateTable(banner);
                SetInteractable(true);
            }, Toast.Show);

            yield return RefreshCounters();
        }

        // Bảng tỉ lệ phải xem được ngay trong game — yêu cầu bắt buộc của các store.
        string BuildRateTable(GachaBanner b)
        {
            var text = new System.Text.StringBuilder("Tỉ lệ rơi\n\n");
            if (b.rates != null)
                foreach (var rate in b.rates) text.Append(rate.tier).Append("   ").Append(rate.percent).Append("%\n");
            text.Append("\nSau ").Append(b.pityThreshold)
                .Append(" lượt liên tiếp không ra SSR, lượt kế tiếp chắc chắn SSR trở lên.\n");
            text.Append("Quay 10 luôn có ít nhất 1 món SR trở lên.\n");
            text.Append("Trùng món đã có sẽ đổi thành mảnh: R 1 · SR 5 · SSR 20 · UR 50.\n");
            text.Append("Đủ 100 mảnh đổi được 1 món SSR tự chọn.");
            return text.ToString();
        }

        IEnumerator RefreshCounters()
        {
            yield return Api.I.GetGachaHistory(1, delegate (GachaHistory history)
            {
                if (history == null) return;
                fragmentText.text = "Mảnh: " + history.fragments;
                pityText.text = banner == null ? "" : "Tích luỹ: " + history.pity + "/" + banner.pityThreshold;
            }, delegate (string e) { });
        }

        void SetInteractable(bool on)
        {
            pullOneButton.interactable = on;
            pullTenButton.interactable = on;
            ratesButton.interactable = on;
        }

        IEnumerator DoPull(int count)
        {
            if (busy || banner == null) yield break;
            busy = true;
            SetInteractable(false);

            yield return Api.I.Pull(banner.id, count, delegate (PullBatch batch)
            {
                App.I.SetKc(batch.kcBalance);
                fragmentText.text = "Mảnh: " + batch.fragments;
                pityText.text = "Tích luỹ: " + batch.pityCounter + "/" + banner.pityThreshold;
                ShowResults(batch);
            }, Toast.Show);

            SetInteractable(true);
            busy = false;
        }

        void ShowResults(PullBatch batch)
        {
            resultPanel.SetActive(true);
            foreach (Transform child in resultContent) Destroy(child.gameObject);
            if (batch.results == null) return;
            foreach (var result in batch.results)
            {
                var row = Instantiate(rowPrefab, resultContent);
                var label = row.GetComponentInChildren<Text>();
                label.text = "[" + result.tier + "] " + result.name
                           + (result.duplicate ? "   (trùng → +" + result.fragments + " mảnh)" : "   MỚI");
                label.color = TierColors.ContainsKey(result.tier) ? TierColors[result.tier] : Color.white;
                ApplyArt(row.transform, result.cosmeticId);
            }
        }

        IEnumerator LoadHistory()
        {
            historyPanel.SetActive(true);
            foreach (Transform child in historyContent) Destroy(child.gameObject);
            yield return Api.I.GetGachaHistory(50, delegate (GachaHistory history)
            {
                if (history == null || history.pulls == null) return;
                foreach (var pull in history.pulls)
                {
                    var row = Instantiate(rowPrefab, historyContent);
                    var label = row.GetComponentInChildren<Text>();
                    label.text = When(pull.createdAt) + "  [" + pull.tier + "] " + pull.name
                               + (pull.duplicate ? "  (+" + pull.fragments + " mảnh)" : "");
                    label.color = TierColors.ContainsKey(pull.tier) ? TierColors[pull.tier] : Color.white;
                }
            }, Toast.Show);
        }

        void ApplyArt(Transform row, string cosmeticId)
        {
            var found = row.Find("Icon");
            if (found == null) return;
            var icon = found.GetComponent<Image>();
            Sprite sprite = null;
            foreach (var art in cosmeticArt) if (art.id == cosmeticId) sprite = art.sprite;
            icon.gameObject.SetActive(sprite != null);
            if (sprite != null) icon.sprite = sprite;
        }

        static string When(long epochMs)
        {
            return DateTimeOffset.FromUnixTimeMilliseconds(epochMs).ToLocalTime().ToString("dd/MM HH:mm");
        }
    }
}
