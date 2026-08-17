using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class ServerSelectScreen : MonoBehaviour
    {
        public Transform content;
        public GameObject cardPrefab;   // prefab có ServerCard

        void OnEnable() { StartCoroutine(Load()); }

        IEnumerator Load()
        {
            foreach (Transform child in content) Destroy(child.gameObject);
            yield return Api.I.GetServers(delegate (ServerList list)
            {
                if (list == null || list.servers == null) return;
                foreach (var info in list.servers)
                {
                    var card = Instantiate(cardPrefab, content).GetComponent<ServerCard>();
                    card.Bind(info, Pick);
                }
            }, Toast.Show);
        }

        void Pick(ServerInfo info) { StartCoroutine(Select(info)); }

        IEnumerator Select(ServerInfo info)
        {
            yield return Api.I.SelectServer(info.id, delegate (Profile profile)
            {
                App.I.Me = profile;
                App.I.Changed();
                ScreenManager.I.Show(string.IsNullOrEmpty(profile.name) ? "S07_CharacterCreate" : "S08_Loading");
            }, Toast.Show);
        }
    }
}
