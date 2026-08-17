using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class PlotCell : MonoBehaviour
    {
        public Image cropImage, progressBar, readyGlow;
        public Text timerText;
        public Button button;

        Plot plot;
        System.Action<Plot> onClick;

        public void Bind(Plot p, Sprite cropSprite, Sprite sproutSprite, System.Action<Plot> handler)
        {
            plot = p;
            onClick = handler;
            button.onClick.RemoveAllListeners();
            button.onClick.AddListener(delegate { onClick(plot); });
            Redraw(cropSprite, sproutSprite);
        }

        Sprite crop, sprout;

        void Redraw(Sprite cropSprite, Sprite sproutSprite)
        {
            crop = cropSprite;
            sprout = sproutSprite;

            bool empty = plot.state == "EMPTY";
            bool ready = plot.state == "READY";
            if (cropImage != null)
            {
                cropImage.gameObject.SetActive(!empty);
                if (!empty)
                {
                    var sprite = ready ? crop : sprout;
                    if (sprite != null) cropImage.sprite = sprite;
                    cropImage.color = ready ? Color.white : new Color(0.6f, 0.85f, 0.5f, 1f);
                }
            }
            if (readyGlow != null) readyGlow.gameObject.SetActive(ready);
            if (progressBar != null) progressBar.gameObject.SetActive(plot.state == "GROWING");
            if (timerText != null) timerText.gameObject.SetActive(plot.state == "GROWING");
        }

        void Update()
        {
            if (plot == null || plot.state != "GROWING") return;
            long now = Api.I.Now;
            long total = plot.readyAt - plot.plantedAt;
            long left = plot.readyAt - now;
            if (left <= 0)
            {
                plot.state = "READY";           // tự đổi hình, không cần gọi server
                Redraw(crop, sprout);
                return;
            }
            if (progressBar != null && total > 0) progressBar.fillAmount = 1f - (float)left / total;
            if (timerText != null) timerText.text = Format(left / 1000);
        }

        public static string Format(long sec)
        {
            if (sec >= 3600) return (sec / 3600) + "h" + ((sec % 3600) / 60) + "p";
            if (sec >= 60) return (sec / 60) + "p" + (sec % 60) + "s";
            return sec + "s";
        }
    }
}
