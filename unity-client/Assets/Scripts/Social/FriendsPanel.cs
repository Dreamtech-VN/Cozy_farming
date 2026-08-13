using UnityEngine;
using UnityEngine.UI;

// Panel bạn bè: danh sách bạn (kèm điểm thân mật + nút tặng quà/xoá),
// lời mời đang chờ (chấp nhận/từ chối), gửi lời mời theo userId.
public class FriendsPanel : MonoBehaviour
{
    [SerializeField] private Transform friendListContent;
    [SerializeField] private Transform requestListContent;
    [SerializeField] private Button entryButtonPrefab;
    [SerializeField] private InputField addFriendInput;
    [SerializeField] private Button addFriendButton;
    [SerializeField] private Text errorText;

    // giftId phải khớp GiftCatalog phía server (chưa có endpoint list quà — xem GiftCatalog.java)
    [SerializeField] private string defaultGiftId = "flower";

    private void OnEnable()
    {
        addFriendButton.onClick.AddListener(OnAddFriendClicked);
        _ = Refresh();
    }

    private void OnDisable()
    {
        addFriendButton.onClick.RemoveListener(OnAddFriendClicked);
    }

    public async System.Threading.Tasks.Task Refresh()
    {
        errorText.text = "";
        foreach (Transform child in friendListContent) Destroy(child.gameObject);
        foreach (Transform child in requestListContent) Destroy(child.gameObject);

        var friends = await FriendService.ListFriends();
        foreach (var friend in friends)
        {
            AddEntry(friendListContent, $"{friend.name} — thân mật {friend.intimacyPoints} (bấm để tặng quà)",
                () => _ = OnGiftClicked(friend.userId));
        }

        var requests = await FriendService.PendingRequests();
        foreach (var request in requests)
        {
            long requestId = request.id;
            AddEntry(requestListContent, $"Lời mời từ user #{request.fromUserId} (bấm để chấp nhận)",
                () => _ = OnRespondClicked(requestId, true));
        }
    }

    private void AddEntry(Transform parent, string label, UnityEngine.Events.UnityAction onClick)
    {
        var btn = Instantiate(entryButtonPrefab, parent);
        btn.GetComponentInChildren<Text>().text = label;
        btn.onClick.AddListener(onClick);
    }

    private async void OnAddFriendClicked()
    {
        if (!int.TryParse(addFriendInput.text.Trim(), out int toUserId))
        {
            errorText.text = "Nhập userId (số) của người muốn kết bạn";
            return;
        }
        try
        {
            await FriendService.SendRequest(toUserId);
            addFriendInput.text = "";
            errorText.text = "Đã gửi lời mời";
        }
        catch (ApiException e)
        {
            errorText.text = $"Không gửi được ({e.StatusCode}): {e.Message}";
        }
    }

    private async System.Threading.Tasks.Task OnRespondClicked(long requestId, bool accept)
    {
        try
        {
            await FriendService.Respond(requestId, accept);
            await Refresh();
        }
        catch (ApiException e)
        {
            errorText.text = $"Không phản hồi được ({e.StatusCode}): {e.Message}";
        }
    }

    private async System.Threading.Tasks.Task OnGiftClicked(int friendUserId)
    {
        try
        {
            var res = await FriendService.SendGift(friendUserId, defaultGiftId);
            errorText.text = $"Đã tặng quà — thân mật giờ là {res.intimacyPoints}";
            await Refresh();
        }
        catch (ApiException e)
        {
            errorText.text = $"Không tặng được ({e.StatusCode}): {e.Message}";
        }
    }
}
