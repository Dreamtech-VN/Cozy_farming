using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class Hud : MonoBehaviour
    {
        public static Hud I;
        public Text nameText, vangText, kcText, farmLvText, zooLvText;
        public Button backButton;

        void Awake() { I = this; }

        void Start()
        {
            if (backButton != null)
                backButton.onClick.AddListener(delegate { ScreenManager.I.Show("S09_Lobby", true); });
            App.I.OnStateChanged += Refresh;
            Refresh();
        }

        void OnDestroy()
        {
            if (App.I != null) App.I.OnStateChanged -= Refresh;
        }

        void OnEnable() { Refresh(); }

        public void Refresh()
        {
            var me = App.I != null ? App.I.Me : null;
            if (me == null || me.wallets == null) return;
            if (nameText != null) nameText.text = string.IsNullOrEmpty(me.name) ? "Khách" : me.name;
            if (vangText != null) vangText.text = "Vàng " + me.wallets.VANG.ToString("N0");
            if (kcText != null) kcText.text = "KC " + me.wallets.KC.ToString("N0");
            if (farmLvText != null) farmLvText.text = "Farm Lv" + me.farmLevel;
            if (zooLvText != null) zooLvText.text = "Zoo Lv" + me.zooLevel;
        }
    }
}
