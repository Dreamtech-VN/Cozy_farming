using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class SocialScreen : MonoBehaviour
    {
        public Transform friendContent, requestContent;
        public GameObject rowPrefab;
        public InputField searchInput;
        public Button addButton;
        public Text helpsLeftText, sectionFriendText, sectionRequestText;

        void Start()
        {
            addButton.onClick.AddListener(delegate { StartCoroutine(SendRequest()); });
        }

        void OnEnable() { StartCoroutine(Load()); }

        IEnumerator Load()
        {
            yield return Api.I.GetFriends(Redraw, Toast.Show);
        }

        void Redraw(FriendsView view)
        {
            if (view == null) return;
            helpsLeftText.text = "Lượt giúp còn lại hôm nay: " + view.helpsLeftToday;
            sectionFriendText.text = "Bạn bè (" + (view.friends != null ? view.friends.Count : 0) + ")";
            sectionRequestText.text = "Lời mời (" + (view.incoming != null ? view.incoming.Count : 0) + ")";

            foreach (Transform child in friendContent) Destroy(child.gameObject);
            if (view.friends != null)
                foreach (var friend in view.friends)
                {
                    var row = Instantiate(rowPrefab, friendContent).GetComponent<Button>();
                    row.GetComponentInChildren<Text>().text =
                        friend.name + "  · Farm Lv" + friend.farmLevel + " · Zoo Lv" + friend.zooLevel
                        + " · hấp dẫn " + friend.zooAppeal + "   [Thăm]";
                    int id = friend.playerId;
                    row.onClick.AddListener(delegate { VisitFriendScreen.Open(id); });
                }

            foreach (Transform child in requestContent) Destroy(child.gameObject);
            if (view.incoming != null)
                foreach (var request in view.incoming)
                {
                    var row = Instantiate(rowPrefab, requestContent).GetComponent<Button>();
                    row.GetComponentInChildren<Text>().text = request.name + "  muốn kết bạn — bấm để đồng ý";
                    int id = request.playerId;
                    row.onClick.AddListener(delegate { StartCoroutine(Accept(id)); });
                }

            if (view.outgoing != null)
                foreach (var pending in view.outgoing)
                {
                    var row = Instantiate(rowPrefab, requestContent).GetComponent<Button>();
                    row.GetComponentInChildren<Text>().text = "Đã gửi lời mời cho " + pending.name + " — bấm để huỷ";
                    int id = pending.playerId;
                    row.onClick.AddListener(delegate { StartCoroutine(Remove(id)); });
                }
        }

        IEnumerator SendRequest()
        {
            string name = searchInput.text.Trim();
            if (name.Length < 2) { Toast.Show("Nhập tên người chơi"); yield break; }
            addButton.interactable = false;
            yield return Api.I.SendFriendRequest(name, delegate (FriendsView v)
            {
                Toast.Show("Đã gửi lời mời cho " + name);
                searchInput.text = "";
                Redraw(v);
            }, Toast.Show);
            addButton.interactable = true;
        }

        IEnumerator Accept(int friendId)
        {
            yield return Api.I.AcceptFriend(friendId, Redraw, Toast.Show);
        }

        IEnumerator Remove(int friendId)
        {
            yield return Api.I.RemoveFriend(friendId, Redraw, Toast.Show);
        }
    }
}
