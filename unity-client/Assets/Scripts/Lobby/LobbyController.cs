using System.Collections.Generic;
using UnityEngine;

// Gắn vào GameObject đại diện nhân vật của mình trong sảnh (di chuyển bằng
// WASD/mũi tên — đủ cho MVP, chưa có animation/pathfinding thật). Không
// dùng art GunPow Mobi — remotePlayerPrefab là placeholder tự chọn.
public class LobbyController : MonoBehaviour
{
    [SerializeField] private float moveSpeed = 3f;
    [SerializeField] private float heartbeatInterval = 1.5f; // server coi "online" nếu heartbeat trong 15s gần nhất
    [SerializeField] private Transform remotePlayersRoot;
    [SerializeField] private GameObject remotePlayerPrefab;

    private float heartbeatTimer;
    private readonly Dictionary<int, GameObject> remoteMarkers = new();

    private void Update()
    {
        HandleMovement();

        heartbeatTimer += Time.deltaTime;
        if (heartbeatTimer >= heartbeatInterval)
        {
            heartbeatTimer = 0;
            _ = SendHeartbeatAndRefresh();
        }
    }

    private void HandleMovement()
    {
        float dx = Input.GetAxisRaw("Horizontal");
        float dy = Input.GetAxisRaw("Vertical");
        if (dx == 0 && dy == 0) return;
        transform.position += new Vector3(dx, dy, 0) * moveSpeed * Time.deltaTime;
    }

    private async System.Threading.Tasks.Task SendHeartbeatAndRefresh()
    {
        int x = Mathf.RoundToInt(transform.position.x);
        int y = Mathf.RoundToInt(transform.position.y);

        try
        {
            await LobbyService.Heartbeat(x, y);
            var players = await LobbyService.ListPlayers();
            RenderRemotePlayers(players);
        }
        catch (ApiException)
        {
            // Sảnh chỉ cập nhật "best effort" — 1 lần poll lỗi không đáng làm gián đoạn gameplay,
            // lần heartbeat kế tiếp tự thử lại.
        }
    }

    private void RenderRemotePlayers(List<LobbyPlayerView> players)
    {
        var seen = new HashSet<int>();
        foreach (var player in players)
        {
            if (player.userId == Session.UserId) continue; // không vẽ chính mình lần 2
            seen.Add(player.userId);

            if (!remoteMarkers.TryGetValue(player.userId, out var marker))
            {
                marker = Instantiate(remotePlayerPrefab, remotePlayersRoot);
                remoteMarkers[player.userId] = marker;
            }
            marker.transform.position = new Vector3(player.x, player.y, 0);
            var label = marker.GetComponentInChildren<UnityEngine.UI.Text>();
            if (label != null) label.text = player.name;
        }

        var stale = new List<int>();
        foreach (var kv in remoteMarkers)
        {
            if (!seen.Contains(kv.Key)) stale.Add(kv.Key);
        }
        foreach (var userId in stale)
        {
            Destroy(remoteMarkers[userId]);
            remoteMarkers.Remove(userId);
        }
    }

    private async void OnDisable()
    {
        try
        {
            await LobbyService.Leave();
        }
        catch (ApiException)
        {
            // thoát sảnh best-effort — không chặn việc chuyển màn hình nếu request lỗi
        }
    }
}
