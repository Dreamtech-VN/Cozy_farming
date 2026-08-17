using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class AchievementScreen : MonoBehaviour
    {
        public Transform achievementContent, collectionContent;
        public GameObject rowPrefab, speciesPrefab;
        public Text collectionSummaryText;

        [Tooltip("Tên sprite trùng id loài — dùng chung bộ với màn Zoo")]
        public Sprite[] animalSprites;

        void OnEnable()
        {
            StartCoroutine(LoadAchievements());
            StartCoroutine(LoadCollection());
        }

        IEnumerator LoadAchievements()
        {
            yield return Api.I.GetAchievements(delegate (AchievementList list)
            {
                foreach (Transform child in achievementContent) Destroy(child.gameObject);
                if (list == null || list.achievements == null) return;

                foreach (var item in list.achievements)
                {
                    var row = Instantiate(rowPrefab, achievementContent).GetComponent<Button>();
                    bool done = item.progress >= item.target;
                    row.GetComponentInChildren<Text>().text =
                        item.name + "   " + item.progress + "/" + item.target
                        + (item.claimed ? "   (đã nhận)"
                                        : done ? "   — NHẬN " + item.rewardVang + " Vàng"
                                               : "   " + item.rewardVang + " Vàng");
                    row.interactable = done && !item.claimed;
                    string id = item.id;
                    row.onClick.AddListener(delegate { StartCoroutine(Claim(id)); });
                }
            }, Toast.Show);
        }

        IEnumerator LoadCollection()
        {
            yield return Api.I.GetCollection(delegate (CollectionList list)
            {
                foreach (Transform child in collectionContent) Destroy(child.gameObject);
                if (list == null || list.species == null) return;

                int owned = 0;
                foreach (var entry in list.species)
                {
                    if (entry.owned) owned++;
                    var go = Instantiate(speciesPrefab, collectionContent);
                    var image = go.GetComponent<Image>();
                    if (animalSprites != null)
                        foreach (var s in animalSprites)
                            if (s != null && s.name == entry.speciesId) image.sprite = s;
                    // Chưa sở hữu thì tô tối như bóng
                    image.color = entry.owned ? Color.white : new Color(0.15f, 0.15f, 0.15f, 0.85f);

                    var label = go.GetComponentInChildren<Text>();
                    if (label != null) label.text = entry.owned ? entry.name : "???";
                }
                collectionSummaryText.text = "Bộ sưu tập: " + owned + "/" + list.species.Count + " loài";
            }, Toast.Show);
        }

        IEnumerator Claim(string achievementId)
        {
            yield return Api.I.ClaimAchievement(achievementId, delegate (AchievementClaimResult r)
            {
                Toast.Show("Nhận " + r.rewardVang + " Vàng!");
                App.I.SetVang(r.vangBalance);
            }, Toast.Show);
            yield return LoadAchievements();
        }
    }
}
