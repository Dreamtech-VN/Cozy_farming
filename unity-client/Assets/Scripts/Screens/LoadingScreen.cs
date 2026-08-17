using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class LoadingScreen : MonoBehaviour
    {
        public Image progressBar;
        public Text tipText;

        static readonly string[] Tips = {
            "Thú được cho ăn mới hút khách tham quan.",
            "Cỏ khô rẻ và lớn nhanh — hợp để nuôi cừu.",
            "Zoo chỉ tích tiền tối đa 8 tiếng, nhớ vào thu thường xuyên!",
            "Đăng ký tài khoản để không mất tiến độ khi đổi máy."
        };

        void OnEnable()
        {
            if (tipText != null) tipText.text = Tips[Random.Range(0, Tips.Length)];
            StartCoroutine(Load());
        }

        IEnumerator Load()
        {
            SetProgress(0.1f);
            if (App.I.Catalog == null)
                yield return Api.I.GetCatalog(delegate (Catalog c) { App.I.Catalog = c; }, Toast.Show);

            SetProgress(0.6f);
            bool done = false;
            yield return Api.I.GetSnapshot(delegate (Snapshot s) { App.I.Apply(s); done = true; }, Toast.Show);

            SetProgress(1f);
            if (done) ScreenManager.I.Show("S09_Lobby", true);
        }

        void SetProgress(float value)
        {
            if (progressBar != null) progressBar.fillAmount = value;
        }
    }
}
