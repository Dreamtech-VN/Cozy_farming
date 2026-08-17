using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class MailScreen : MonoBehaviour
    {
        public Transform content;
        public GameObject rowPrefab;
        public InputField giftcodeInput;
        public Button redeemButton, claimAllButton;
        public Text emptyText;

        void Start()
        {
            redeemButton.onClick.AddListener(delegate { StartCoroutine(Redeem()); });
            claimAllButton.onClick.AddListener(delegate { StartCoroutine(ClaimAll()); });
        }

        void OnEnable() { StartCoroutine(Load()); }

        IEnumerator Load()
        {
            yield return Api.I.GetMails(delegate (MailList list)
            {
                foreach (Transform child in content) Destroy(child.gameObject);
                int count = list != null && list.mails != null ? list.mails.Count : 0;
                emptyText.gameObject.SetActive(count == 0);
                if (count == 0) return;

                foreach (var mail in list.mails)
                {
                    var row = Instantiate(rowPrefab, content).GetComponent<Button>();
                    string reward = "";
                    if (mail.rewardVang > 0) reward += "  +" + mail.rewardVang + " Vàng";
                    if (mail.rewardKc > 0) reward += "  +" + mail.rewardKc + " KC";
                    if (!string.IsNullOrEmpty(mail.rewardFoodId) && mail.rewardFoodQty > 0)
                        reward += "  +" + App.I.CropName(mail.rewardFoodId) + " x" + mail.rewardFoodQty;

                    row.GetComponentInChildren<Text>().text =
                        mail.title + reward + (mail.claimed ? "   (đã nhận)" : "   — bấm để nhận");
                    row.interactable = !mail.claimed;
                    long id = mail.id;
                    row.onClick.AddListener(delegate { StartCoroutine(Claim(id)); });
                }
            }, Toast.Show);
        }

        IEnumerator Claim(long mailId)
        {
            yield return Api.I.ClaimMail(mailId, delegate (MailClaimResult r)
            {
                Toast.Show("Đã nhận quà!");
                App.I.SetVang(r.vangBalance);
                if (App.I.Me != null && App.I.Me.wallets != null) App.I.Me.wallets.KC = r.kcBalance;
                App.I.Changed();
            }, Toast.Show);
            yield return Load();
        }

        IEnumerator ClaimAll()
        {
            claimAllButton.interactable = false;
            yield return Api.I.ClaimAllMails(delegate (ClaimAllResult r)
            {
                Toast.Show(r.claimed > 0 ? "Đã nhận " + r.claimed + " thư" : "Không có thư nào để nhận");
            }, Toast.Show);
            claimAllButton.interactable = true;
            yield return Api.I.GetMe(delegate (Profile p) { App.I.Me = p; App.I.Changed(); }, delegate (string e) { });
            yield return Load();
        }

        IEnumerator Redeem()
        {
            string code = giftcodeInput.text.Trim();
            if (code.Length < 3) { Toast.Show("Nhập mã quà tặng"); yield break; }
            redeemButton.interactable = false;
            yield return Api.I.RedeemGiftcode(code, delegate (RedeemResult r)
            {
                Toast.Show(r.message);
                giftcodeInput.text = "";
            }, Toast.Show);
            redeemButton.interactable = true;
            yield return Load();
        }
    }
}
