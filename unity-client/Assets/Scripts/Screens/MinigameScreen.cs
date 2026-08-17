using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class MinigameScreen : MonoBehaviour
    {
        const int Size = 6, Kinds = 5;

        public Transform board;
        public GameObject cellPrefab;    // Button có Image
        public Text headerText;
        public Button finishButton;

        [Tooltip("Đúng 5 sprite trái cây. Bỏ trống thì dùng 5 màu khác nhau.")]
        public Sprite[] fruitSprites;

        static readonly Color[] FallbackColors = {
            new Color(0.90f, 0.30f, 0.24f), new Color(0.61f, 0.35f, 0.71f), new Color(0.95f, 0.61f, 0.07f),
            new Color(0.95f, 0.85f, 0.24f), new Color(0.20f, 0.60f, 0.86f)
        };

        readonly int[] cells = new int[Size * Size];
        readonly List<Button> buttons = new List<Button>();
        MinigameSession session;
        uint rngState;
        int movesLeft, lines, selected = -1;
        bool finishing;

        void Start()
        {
            finishButton.onClick.AddListener(delegate { StartCoroutine(Finish()); });
        }

        void OnEnable() { StartCoroutine(Begin()); }

        IEnumerator Begin()
        {
            finishing = false;
            yield return Api.I.StartMinigame(delegate (MinigameSession s)
            {
                session = s;
                rngState = (uint)(s.seed & 0xFFFFFFFF);
                movesLeft = s.movesAllowed;
                lines = 0;
                selected = -1;
                for (int i = 0; i < cells.Length; i++) cells[i] = NextInt(Kinds);
                BuildBoard();
            }, Toast.Show);
        }

        // mulberry32 — phải khớp từng phép toán với server/client web, dùng double chứ không phải float
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

        void BuildBoard()
        {
            if (session == null) return;
            if (buttons.Count == 0)
                for (int i = 0; i < cells.Length; i++)
                {
                    int index = i;
                    var b = Instantiate(cellPrefab, board).GetComponent<Button>();
                    b.onClick.AddListener(delegate { OnCellClicked(index); });
                    buttons.Add(b);
                }

            for (int i = 0; i < cells.Length; i++)
            {
                var image = buttons[i].GetComponent<Image>();
                if (fruitSprites != null && cells[i] < fruitSprites.Length && fruitSprites[cells[i]] != null)
                {
                    image.sprite = fruitSprites[cells[i]];
                    image.color = Color.white;
                }
                else image.color = FallbackColors[cells[i] % FallbackColors.Length];

                buttons[i].transform.localScale = selected == i ? Vector3.one * 1.15f : Vector3.one;
            }
            headerText.text = "Còn " + movesLeft + " lượt · " + lines + " hàng · dự kiến "
                            + (lines * session.vangPerLine) + " Vàng";
        }

        void OnCellClicked(int index)
        {
            if (movesLeft <= 0 || finishing) return;
            if (selected < 0) { selected = index; BuildBoard(); return; }

            int a = selected, b = index;
            selected = -1;
            bool adjacent = (Mathf.Abs(a - b) == 1 && a / Size == b / Size) || Mathf.Abs(a - b) == Size;
            if (!adjacent) { BuildBoard(); return; }

            Swap(a, b);
            movesLeft--;
            if (Resolve() == 0) Swap(a, b);   // không ăn thì trả lại, vẫn mất lượt
            BuildBoard();
            if (movesLeft <= 0) StartCoroutine(Finish());
        }

        void Swap(int a, int b)
        {
            int tmp = cells[a];
            cells[a] = cells[b];
            cells[b] = tmp;
        }

        int Resolve()
        {
            int total = 0;
            for (int pass = 0; pass < 10; pass++)
            {
                var kill = new HashSet<int>();
                int found = 0;

                for (int r = 0; r < Size; r++)
                    for (int c = 0; c < Size - 2; c++)
                    {
                        int i = r * Size + c;
                        if (cells[i] == cells[i + 1] && cells[i] == cells[i + 2])
                        {
                            found++;
                            int cc = c;
                            while (cc < Size && cells[r * Size + cc] == cells[i]) { kill.Add(r * Size + cc); cc++; }
                            c = cc;
                        }
                    }

                for (int c = 0; c < Size; c++)
                    for (int r = 0; r < Size - 2; r++)
                    {
                        int i = r * Size + c;
                        if (cells[i] == cells[i + Size] && cells[i] == cells[i + 2 * Size])
                        {
                            found++;
                            int rr = r;
                            while (rr < Size && cells[rr * Size + c] == cells[i]) { kill.Add(rr * Size + c); rr++; }
                            r = rr;
                        }
                    }

                if (found == 0) break;
                total += found;

                for (int c = 0; c < Size; c++)
                {
                    var column = new List<int>();
                    for (int r = Size - 1; r >= 0; r--)
                        if (!kill.Contains(r * Size + c)) column.Add(cells[r * Size + c]);
                    while (column.Count < Size) column.Add(NextInt(Kinds));
                    for (int r = Size - 1, k = 0; r >= 0; r--, k++) cells[r * Size + c] = column[k];
                }
            }
            lines += total;
            return total;
        }

        IEnumerator Finish()
        {
            if (finishing || session == null) yield break;
            finishing = true;
            finishButton.interactable = false;
            yield return Api.I.FinishMinigame(session.sessionId, lines, delegate (MinigameResult r)
            {
                Toast.Show("Nhận " + r.vangReward + " Vàng cho " + r.linesCounted + " hàng!");
                App.I.SetVang(r.vangBalance);
                ScreenManager.I.Show("S09_Lobby", true);
            }, Toast.Show);
            finishButton.interactable = true;
        }
    }
}
