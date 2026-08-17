using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class LobbyScreen : MonoBehaviour
    {
        public Button farmButton, zooButton, minigameButton, missionButton, checkinButton, logoutButton;
        public Button socialButton, rankButton, mailButton, achievementButton;
        public GameObject farmDot, zooDot, missionDot, mailDot;

        void Start()
        {
            farmButton.onClick.AddListener(delegate { ScreenManager.I.Show("S10_Farm", true); });
            zooButton.onClick.AddListener(delegate { ScreenManager.I.Show("S20_Zoo", true); });
            minigameButton.onClick.AddListener(delegate { ScreenManager.I.Show("S40_Minigame", true); });
            missionButton.onClick.AddListener(delegate { ScreenManager.I.Show("S30_Missions", true); });
            checkinButton.onClick.AddListener(delegate { StartCoroutine(DoCheckin()); });
            if (logoutButton != null) logoutButton.onClick.AddListener(delegate { StartCoroutine(DoLogout()); });
            if (socialButton != null) socialButton.onClick.AddListener(delegate { ScreenManager.I.Show("S24_Social", true); });
            if (rankButton != null) rankButton.onClick.AddListener(delegate { ScreenManager.I.Show("S36_Leaderboard", true); });
            if (mailButton != null) mailButton.onClick.AddListener(delegate { ScreenManager.I.Show("S33_Mail", true); });
            if (achievementButton != null)
                achievementButton.onClick.AddListener(delegate { ScreenManager.I.Show("S35_Achievements", true); });
        }

        void OnEnable() { RefreshDots(); }

        public void RefreshDots()
        {
            if (farmDot != null) farmDot.SetActive(App.I.HasReadyCrop());
            if (zooDot != null) zooDot.SetActive(App.I.ZooNeedsAttention());
            if (missionDot != null) missionDot.SetActive(App.I.HasClaimableMission());
            if (mailDot != null) StartCoroutine(CheckMail());
        }

        IEnumerator CheckMail()
        {
            yield return Api.I.GetMails(delegate (MailList list)
            {
                bool hasUnclaimed = false;
                if (list != null && list.mails != null)
                    foreach (var m in list.mails) if (!m.claimed) hasUnclaimed = true;
                mailDot.SetActive(hasUnclaimed);
            }, delegate (string e) { });
        }

        IEnumerator DoCheckin()
        {
            checkinButton.interactable = false;
            yield return Api.I.Checkin(delegate (CheckinResult r)
            {
                Toast.Show("Điểm danh ngày " + r.streak + ": +" + r.rewardVang + " Vàng");
                App.I.SetVang(r.vangBalance);
            }, Toast.Show);   // 409 = hôm nay nhận rồi
            checkinButton.interactable = true;
        }

        IEnumerator DoLogout()
        {
            yield return Api.I.Logout(delegate (OkResult r) { }, delegate (string e) { });
            Api.I.ClearSession();
            ScreenManager.I.Show("S02_Login");
        }

        void OnApplicationFocus(bool focus)
        {
            if (focus && gameObject.activeInHierarchy) StartCoroutine(Refresh());
        }

        IEnumerator Refresh()
        {
            yield return Api.I.GetSnapshot(delegate (Snapshot s) { App.I.Apply(s); RefreshDots(); }, delegate (string e) { });
        }
    }
}
