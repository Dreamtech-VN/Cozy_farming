using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class MissionsScreen : MonoBehaviour
    {
        public Transform content;
        public GameObject rowPrefab;   // Button có Text bên trong

        void OnEnable() { StartCoroutine(Load()); }

        IEnumerator Load()
        {
            yield return Api.I.GetMissions(delegate (MissionList list)
            {
                if (list != null && list.missions != null) App.I.Missions = list.missions;
                Redraw();
            }, Toast.Show);
        }

        void Redraw()
        {
            foreach (Transform child in content) Destroy(child.gameObject);
            foreach (var mission in App.I.Missions)
            {
                var row = Instantiate(rowPrefab, content).GetComponent<Button>();
                bool done = mission.progress >= mission.target;
                row.GetComponentInChildren<Text>().text =
                    mission.name + "  " + mission.progress + "/" + mission.target
                    + (mission.claimed ? "  — Đã nhận" : done ? "  — NHẬN " + mission.rewardVang + " Vàng"
                                                             : "  — " + mission.rewardVang + " Vàng");
                row.interactable = done && !mission.claimed;
                string missionId = mission.id;
                row.onClick.AddListener(delegate { StartCoroutine(DoClaim(missionId)); });
            }
        }

        IEnumerator DoClaim(string missionId)
        {
            yield return Api.I.ClaimMission(missionId, delegate (ClaimResult r)
            {
                Toast.Show("Nhận " + r.rewardVang + " Vàng");
                App.I.SetVang(r.vangBalance);
            }, Toast.Show);
            yield return Load();
        }
    }
}
