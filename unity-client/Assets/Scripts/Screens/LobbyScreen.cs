using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class LobbyScreen : MonoBehaviour
    {
        public Button farmButton, zooButton, minigameButton, missionButton, checkinButton, logoutButton;
        public Button socialButton, rankButton, mailButton, achievementButton, shopButton, inventoryButton, processingButton, memoryButton, chatButton, settingsButton;
        public GameObject farmDot, zooDot, missionDot, mailDot;
        public Text reminderText;

        void Start()
        {
            farmButton.onClick.AddListener(delegate { ScreenManager.I.Show("S10_Farm", true); });
            zooButton.onClick.AddListener(delegate { ScreenManager.I.Show("S20_Zoo", true); });
            minigameButton.onClick.AddListener(delegate
            {
                MinigameScreen.NextGameType = "MATCH3";
                ScreenManager.I.Show("S40_Minigame", true);
            });
            missionButton.onClick.AddListener(delegate { ScreenManager.I.Show("S30_Missions", true); });
            checkinButton.onClick.AddListener(delegate { StartCoroutine(DoCheckin()); });
            if (logoutButton != null) logoutButton.onClick.AddListener(delegate { StartCoroutine(DoLogout()); });
            if (socialButton != null) socialButton.onClick.AddListener(delegate { ScreenManager.I.Show("S24_Social", true); });
            if (rankButton != null) rankButton.onClick.AddListener(delegate { ScreenManager.I.Show("S36_Leaderboard", true); });
            if (mailButton != null) mailButton.onClick.AddListener(delegate { ScreenManager.I.Show("S33_Mail", true); });
            if (achievementButton != null)
                achievementButton.onClick.AddListener(delegate { ScreenManager.I.Show("S35_Achievements", true); });
            if (shopButton != null) shopButton.onClick.AddListener(delegate { ScreenManager.I.Show("S30_Shop", true); });
            if (inventoryButton != null)
                inventoryButton.onClick.AddListener(delegate { ScreenManager.I.Show("S32_Inventory", true); });
            if (processingButton != null)
                processingButton.onClick.AddListener(delegate { ScreenManager.I.Show("S34_Processing", true); });
            if (memoryButton != null)
                memoryButton.onClick.AddListener(delegate { ScreenManager.I.Show("S41_Memory", true); });
            if (chatButton != null) chatButton.onClick.AddListener(delegate { ScreenManager.I.Show("S37_Chat", true); });
            if (settingsButton != null)
                settingsButton.onClick.AddListener(delegate { ScreenManager.I.Show("S39_Settings", true); });
        }

        void OnEnable() { RefreshDots(); }

        public void RefreshDots()
        {
            ShowReminders();
            if (farmDot != null) farmDot.SetActive(App.I.HasReadyCrop());
            if (zooDot != null) zooDot.SetActive(App.I.ZooNeedsAttention());
            if (missionDot != null) missionDot.SetActive(App.I.HasClaimableMission());
            if (mailDot != null) StartCoroutine(CheckMail());
        }

        // Gộp mọi việc đang chờ thành một dòng nhắc, đỡ phải mở từng màn để xem.
        void ShowReminders()
        {
            if (reminderText == null) return;
            var items = Notifications.Pending();
            reminderText.text = items.Count == 0 ? "Mọi thứ đều ổn" : items[0].text
                + (items.Count > 1 ? "  (+" + (items.Count - 1) + " việc khác)" : "");
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
            if (focus)
            {
                OsNotifications.CancelAll();
                if (gameObject.activeInHierarchy) StartCoroutine(Refresh());
                return;
            }
            // Rời game: hẹn nhắc lúc cây chín sớm nhất.
            long readyAt = Notifications.NextCropReadyAt();
            if (readyAt > 0) OsNotifications.ScheduleCropReady(readyAt);
        }

        IEnumerator Refresh()
        {
            yield return Api.I.GetSnapshot(delegate (Snapshot s) { App.I.Apply(s); RefreshDots(); }, delegate (string e) { });
        }
    }
}
