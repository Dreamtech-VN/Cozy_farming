using UnityEngine;

public class BoardRenderer : MonoBehaviour
{
    [SerializeField] private Sprite[] gemSprites = new Sprite[6]; // kéo 6 sprite vào Inspector, ĐÚNG THỨ TỰ index 0-5
    [SerializeField] private GameObject tilePrefab;
    [SerializeField] private Transform boardRoot;

    private GameObject[,] tiles = new GameObject[8, 8];
    private int selectedRow = -1;
    private int selectedCol = -1;

    public void DrawBoard(int[][] board)
    {
        for (int r = 0; r < board.Length; r++)
        {
            for (int c = 0; c < board[r].Length; c++)
            {
                int colorIndex = board[r][c]; // 0-5
                if (tiles[r, c] == null)
                {
                    tiles[r, c] = Instantiate(tilePrefab, boardRoot);
                    int capturedRow = r, capturedCol = c;
                    var tile = tiles[r, c].AddComponent<BoardTile>();
                    tile.OnClicked = () => OnTileClicked(capturedRow, capturedCol);
                }
                tiles[r, c].transform.localPosition = new Vector3(c, -r, 0);
                tiles[r, c].GetComponent<SpriteRenderer>().sprite = gemSprites[colorIndex];
            }
        }
    }

    private async void OnTileClicked(int r, int c)
    {
        if (selectedRow < 0)
        {
            selectedRow = r;
            selectedCol = c;
            return;
        }

        int r1 = selectedRow, c1 = selectedCol;
        selectedRow = -1;
        selectedCol = -1;
        if (r1 == r && c1 == c) return;

        var result = await BattleService.Swap(r1, c1, r, c);
        DrawBoard(result.board);
        BattleEvents.RaiseStateUpdated(result);
    }
}
