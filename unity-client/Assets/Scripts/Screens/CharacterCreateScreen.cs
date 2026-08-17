using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class CharacterCreateScreen : MonoBehaviour
    {
        [System.Serializable]
        public class Look
        {
            public string id = "farmer_1";
            public Sprite sprite;
            public Color tint = Color.white;
        }

        [Tooltip("Thêm/bớt ngoại hình ở đây. Server chỉ lưu id, không quan tâm hình.")]
        public Look[] looks;
        public Image preview;
        public Button prevButton, nextButton, randomButton, startButton;
        public InputField nameInput;
        public Text errorText, lookNameText;

        static readonly string[] FirstParts = { "Nông", "Bé", "Cô", "Anh", "Chú" };
        static readonly string[] LastParts = { "Vui", "Xinh", "Bí Ngô", "Cà Rốt", "Mây" };

        int index;

        void Start()
        {
            prevButton.onClick.AddListener(delegate { Move(-1); });
            nextButton.onClick.AddListener(delegate { Move(1); });
            randomButton.onClick.AddListener(RandomName);
            startButton.onClick.AddListener(delegate { StartCoroutine(Create()); });
            Move(0);
        }

        void OnEnable()
        {
            if (errorText != null) errorText.text = "";
            Move(0);
        }

        void Move(int delta)
        {
            if (looks == null || looks.Length == 0) return;
            index = (index + delta + looks.Length) % looks.Length;
            var look = looks[index];
            if (preview != null)
            {
                if (look.sprite != null) preview.sprite = look.sprite;
                preview.color = look.tint;
            }
            if (lookNameText != null) lookNameText.text = look.id;
        }

        void RandomName()
        {
            nameInput.text = FirstParts[Random.Range(0, FirstParts.Length)] + " "
                           + LastParts[Random.Range(0, LastParts.Length)] + " " + Random.Range(1, 99);
        }

        IEnumerator Create()
        {
            errorText.text = "";
            string name = nameInput.text.Trim();
            if (name.Length < 2) { errorText.text = "Tên phải từ 2 ký tự"; yield break; }

            string avatar = looks != null && looks.Length > 0 ? looks[index].id : "farmer_1";
            startButton.interactable = false;
            yield return Api.I.CreateCharacter(name, avatar,
                delegate (Profile profile)
                {
                    App.I.Me = profile;
                    App.I.Changed();
                    ScreenManager.I.Show("S08_Loading");
                },
                delegate (string e) { errorText.text = e; });   // 409 trùng tên hiện ở đây, không đóng screen
            startButton.interactable = true;
        }
    }
}
