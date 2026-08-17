using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class LeaderboardScreen : MonoBehaviour
    {
        public Transform content;
        public GameObject rowPrefab;
        public Button zooTabButton, farmTabButton;
        public Text titleText;

        string type = "zoo";

        void Start()
        {
            zooTabButton.onClick.AddListener(delegate { Switch("zoo"); });
            farmTabButton.onClick.AddListener(delegate { Switch("farm"); });
        }

        void OnEnable() { StartCoroutine(Load()); }

        void Switch(string newType)
        {
            type = newType;
            StartCoroutine(Load());
        }

        IEnumerator Load()
        {
            titleText.text = type == "zoo" ? "Xếp hạng Sở thú" : "Xếp hạng Nông trại";
            zooTabButton.interactable = type != "zoo";
            farmTabButton.interactable = type != "farm";

            yield return Api.I.GetLeaderboard(type, delegate (Leaderboard board)
            {
                foreach (Transform child in content) Destroy(child.gameObject);
                if (board == null || board.rows == null) return;
                foreach (var row in board.rows)
                {
                    var item = Instantiate(rowPrefab, content).GetComponent<Button>();
                    bool isMe = App.I.Me != null && row.playerId == App.I.Me.playerId;
                    item.GetComponentInChildren<Text>().text =
                        "#" + row.rank + "  " + row.name
                        + "   Zoo Lv" + row.zooLevel + " · Farm Lv" + row.farmLevel
                        + "   " + row.score + " XP" + (isMe ? "   ← bạn" : "");
                    item.interactable = false;
                }
            }, Toast.Show);
        }
    }
}
