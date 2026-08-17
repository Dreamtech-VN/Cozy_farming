using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    // Lật hình đôi: bàn 4x4 sinh từ seed server cấp, điểm = số cặp tìm được.
    public class MemoryGameScreen : MonoBehaviour
    {
        const int Size = 16, Pairs = 8;

        public Transform board;
        public GameObject cellPrefab;
        public Text headerText;
        public Button finishButton;

        [Tooltip("Tối đa 8 sprite cho 8 cặp. Bỏ trống thì dùng màu.")]
        public Sprite[] faceSprites;
        public Sprite backSprite;

        static readonly Color[] FallbackColors = {
            new Color(0.90f, 0.30f, 0.24f), new Color(0.61f, 0.35f, 0.71f), new Color(0.95f, 0.61f, 0.07f),
            new Color(0.95f, 0.85f, 0.24f), new Color(0.20f, 0.60f, 0.86f), new Color(0.35f, 0.75f, 0.45f),
            new Color(0.95f, 0.55f, 0.75f), new Color(0.45f, 0.45f, 0.85f)
        };
        static readonly Color BackColor = new Color(0.45f, 0.36f, 0.28f);

        readonly int[] cards = new int[Size];
        readonly bool[] matched = new bool[Size];
        readonly List<Button> buttons = new List<Button>();
        MinigameSession session;
        uint rngState;
        int movesLeft, pairsFound, firstPick = -1, secondPick = -1;
        bool busy, finishing;

        void Start()
        {
            finishButton.onClick.AddListener(delegate { StartCoroutine(Finish()); });
        }

        void OnEnable() { StartCoroutine(Begin()); }

        IEnumerator Begin()
        {
            finishing = false;
            busy = false;
            yield return Api.I.StartMinigame("MEMORY", delegate (MinigameSession s)
            {
                session = s;
                rngState = (uint)(s.seed & 0xFFFFFFFF);
                movesLeft = s.movesAllowed;
                pairsFound = 0;
                firstPick = secondPick = -1;
                for (int i = 0; i < Size; i++) matched[i] = false;
                Deal();
                BuildBoard();
            }, Toast.Show);
        }

        // Cùng thuật toán PRNG với các game khác nên server tái lập được ván chơi từ seed.
        double NextDouble()
        {
            unchecked
            {
                rngState += 0x6D2B79F5u;
                uint t = rngState;
                t = (t ^ (t >> 15)) * (t | 1u);
                t ^= t + (t ^ (t >> 7)) * (t | 61u);
                return (t ^ (t >> 14)) / 4294967296.0;
            }
        }

        int NextInt(int max) { return Mathf.Min((int)(NextDouble() * max), max - 1); }

        void Deal()
        {
            for (int i = 0; i < Size; i++) cards[i] = i / 2;   // 8 cặp
            for (int i = Size - 1; i > 0; i--)                 // xáo Fisher-Yates bằng seed server
            {
                int j = NextInt(i + 1);
                int tmp = cards[i];
                cards[i] = cards[j];
                cards[j] = tmp;
            }
        }

        void BuildBoard()
        {
            if (session == null) return;
            if (buttons.Count == 0)
                for (int i = 0; i < Size; i++)
                {
                    int index = i;
                    var b = Instantiate(cellPrefab, board).GetComponent<Button>();
                    b.onClick.AddListener(delegate { OnCardClicked(index); });
                    buttons.Add(b);
                }

            for (int i = 0; i < Size; i++)
            {
                bool faceUp = matched[i] || i == firstPick || i == secondPick;
                var image = buttons[i].GetComponent<Image>();
                if (!faceUp)
                {
                    if (backSprite != null) { image.sprite = backSprite; image.color = Color.white; }
                    else image.color = BackColor;
                }
                else if (faceSprites != null && cards[i] < faceSprites.Length && faceSprites[cards[i]] != null)
                {
                    image.sprite = faceSprites[cards[i]];
                    image.color = Color.white;
                }
                else image.color = FallbackColors[cards[i] % FallbackColors.Length];

                buttons[i].interactable = !matched[i] && !busy;
            }
            headerText.text = "Còn " + movesLeft + " lượt · " + pairsFound + "/" + Pairs + " cặp · dự kiến "
                            + (pairsFound * session.vangPerScore) + " Vàng";
        }

        void OnCardClicked(int index)
        {
            if (busy || finishing || movesLeft <= 0) return;
            if (matched[index] || index == firstPick) return;

            if (firstPick < 0) { firstPick = index; BuildBoard(); return; }

            secondPick = index;
            movesLeft--;
            BuildBoard();
            StartCoroutine(Resolve());
        }

        IEnumerator Resolve()
        {
            busy = true;
            yield return new WaitForSeconds(0.6f);   // cho người chơi kịp nhìn

            if (cards[firstPick] == cards[secondPick])
            {
                matched[firstPick] = true;
                matched[secondPick] = true;
                pairsFound++;
            }
            firstPick = secondPick = -1;
            busy = false;
            BuildBoard();

            if (pairsFound >= Pairs || movesLeft <= 0) StartCoroutine(Finish());
        }

        IEnumerator Finish()
        {
            if (finishing || session == null) yield break;
            finishing = true;
            finishButton.interactable = false;
            yield return Api.I.FinishMinigame(session.sessionId, pairsFound, delegate (MinigameResult r)
            {
                Toast.Show("Nhận " + r.vangReward + " Vàng cho " + r.scoreCounted + " cặp!");
                App.I.SetVang(r.vangBalance);
                ScreenManager.I.Show("S09_Lobby", true);
            }, Toast.Show);
            finishButton.interactable = true;
        }
    }
}
