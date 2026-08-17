using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class ServerCard : MonoBehaviour
    {
        public Text nameText, statusText, populationText;
        public GameObject recommendBadge;
        public Button button;

        System.Action<ServerInfo> onPick;
        ServerInfo info;

        public void Bind(ServerInfo serverInfo, System.Action<ServerInfo> handler)
        {
            info = serverInfo;
            onPick = handler;

            nameText.text = info.name;
            populationText.text = info.population == "SMOOTH" ? "Mượt" : "Đông";
            if (recommendBadge != null) recommendBadge.SetActive(info.recommended);

            bool joinable = info.status == "ONLINE";
            switch (info.status)
            {
                case "ONLINE": statusText.text = "Hoạt động"; break;
                case "FULL": statusText.text = "Đầy"; break;
                case "MAINTENANCE": statusText.text = "Bảo trì"; break;
                default: statusText.text = "Khoá"; break;
            }
            button.interactable = joinable;
            button.onClick.RemoveAllListeners();
            if (joinable) button.onClick.AddListener(delegate { onPick(info); });
        }
    }
}
