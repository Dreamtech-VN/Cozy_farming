using System;
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class MissionsScreen : MonoBehaviour
    {
        public Transform content;
        public GameObject rowPrefab;   // Button có Text bên trong
        public Button dailyTabButton, weeklyTabButton, eventTabButton;
        public Text emptyText;

        string tab = "DAILY";

        void Start()
        {
            if (dailyTabButton != null) dailyTabButton.onClick.AddListener(delegate { Switch("DAILY"); });
            if (weeklyTabButton != null) weeklyTabButton.onClick.AddListener(delegate { Switch("WEEKLY"); });
            if (eventTabButton != null) eventTabButton.onClick.AddListener(delegate { Switch("EVENT"); });
        }

        void OnEnable() { StartCoroutine(Load()); }

        void Switch(string next)
        {
            tab = next;
            Redraw();
        }

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
            if (dailyTabButton != null) dailyTabButton.interactable = tab != "DAILY";
            if (weeklyTabButton != null) weeklyTabButton.interactable = tab != "WEEKLY";
            if (eventTabButton != null) eventTabButton.interactable = tab != "EVENT";

            foreach (Transform child in content) Destroy(child.gameObject);
            int shown = 0;
            foreach (var mission in App.I.Missions)
            {
                // Nhiệm vụ cũ của server chưa có scope thì coi như nhiệm vụ ngày.
                string scope = string.IsNullOrEmpty(mission.scope) ? "DAILY" : mission.scope;
                if (scope != tab) continue;
                shown++;

                var row = Instantiate(rowPrefab, content).GetComponent<Button>();
                bool done = mission.progress >= mission.target;
                row.GetComponentInChildren<Text>().text =
                    mission.name + "  " + mission.progress + "/" + mission.target
                    + (mission.claimed ? "  — Đã nhận" : (done ? "  — NHẬN " : "  — ") + Reward(mission))
                    + Deadline(mission);
                row.interactable = done && !mission.claimed;
                string missionId = mission.id;
                row.onClick.AddListener(delegate { StartCoroutine(DoClaim(missionId)); });
            }

            if (emptyText != null)
            {
                emptyText.gameObject.SetActive(shown == 0);
                emptyText.text = tab == "EVENT" ? "Hiện chưa có sự kiện nào" : "Chưa có nhiệm vụ";
            }
        }

        static string Reward(Mission mission)
        {
            string text = mission.rewardVang + " Vàng";
            if (mission.rewardKc > 0) text += " + " + mission.rewardKc + " KC";
            return text;
        }

        static string Deadline(Mission mission)
        {
            if (mission.endsAt <= 0) return "";
            long left = mission.endsAt - Api.I.Now;
            if (left <= 0) return "";
            long hours = left / 3600000;
            return hours >= 24 ? "   (còn " + (hours / 24) + " ngày)" : "   (còn " + hours + " giờ)";
        }

        IEnumerator DoClaim(string missionId)
        {
            yield return Api.I.ClaimMission(missionId, delegate (ClaimResult r)
            {
                Toast.Show("Nhận " + r.rewardVang + " Vàng" + (r.rewardKc > 0 ? " + " + r.rewardKc + " KC" : ""));
                App.I.SetVang(r.vangBalance);
                if (r.rewardKc > 0) App.I.SetKc(r.kcBalance);
            }, Toast.Show);
            yield return Load();
        }
    }
}
