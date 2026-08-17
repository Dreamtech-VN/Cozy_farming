using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class LobbyScreen : MonoBehaviour
    {
        public Button farmButton, zooButton, minigameButton, missionButton, checkinButton, logoutButton;
        public GameObject farmDot, zooDot, missionDot;

        void Start()
        {
            farmButton.onClick.AddListener(delegate { ScreenManager.I.Show("S10_Farm", true); });
            zooButton.onClick.AddListener(delegate { ScreenManager.I.Show("S20_Zoo", true); });
            minigameButton.onClick.AddListener(delegate { ScreenManager.I.Show("S40_Minigame", true); });
            missionButton.onClick.AddListener(delegate { ScreenManager.I.Show("S30_Missions", true); });
            checkinButton.onClick.AddListener(delegate { StartCoroutine(DoCheckin()); });
            if (logoutButton != null) logoutButton.onClick.AddListener(delegate { StartCoroutine(DoLogout()); });
        }

        void OnEnable() { RefreshDots(); }

        public void RefreshDots()
        {
            if (farmDot != null) farmDot.SetActive(App.I.HasReadyCrop());
            if (zooDot != null) zooDot.SetActive(App.I.ZooNeedsAttention());
            if (missionDot != null) missionDot.SetActive(App.I.HasClaimableMission());
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
