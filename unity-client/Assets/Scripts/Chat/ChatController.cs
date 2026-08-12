using UnityEngine;
using UnityEngine.UI;

// Gắn vào panel chat sảnh chung (1 kênh duy nhất, poll định kỳ — server
// không đẩy tin nhắn về). lastSeenId dùng id tăng dần, KHÔNG dùng mốc thời
// gian (máy client/server có thể lệch giờ).
public class ChatController : MonoBehaviour
{
    [SerializeField] private float pollInterval = 2f;
    [SerializeField] private Transform messageListContent;
    [SerializeField] private Text messageEntryTemplate; // để inactive sẵn trong scene
    [SerializeField] private InputField messageInput;
    [SerializeField] private Button sendButton;
    [SerializeField] private Text errorText;

    private long lastSeenId;
    private float pollTimer;

    private async void OnEnable()
    {
        lastSeenId = 0;
        sendButton.onClick.AddListener(OnSendClicked);
        await PollOnce();
    }

    private void OnDisable()
    {
        sendButton.onClick.RemoveListener(OnSendClicked);
    }

    private void Update()
    {
        pollTimer += Time.deltaTime;
        if (pollTimer >= pollInterval)
        {
            pollTimer = 0;
            _ = PollOnce();
        }
    }

    private async System.Threading.Tasks.Task PollOnce()
    {
        try
        {
            var messages = await ChatService.GetRecent(lastSeenId);
            foreach (var message in messages)
            {
                AppendMessage(message);
                if (message.id > lastSeenId) lastSeenId = message.id;
            }
        }
        catch (ApiException)
        {
            // poll lỗi 1 lần không đáng báo lỗi cho người chơi — lần kế tiếp tự thử lại.
        }
    }

    private void AppendMessage(ChatMessageResponse message)
    {
        var entry = Instantiate(messageEntryTemplate, messageListContent);
        entry.gameObject.SetActive(true);
        entry.text = $"{message.senderName}: {message.text}";
    }

    private async void OnSendClicked()
    {
        string text = messageInput.text.Trim();
        if (text.Length == 0) return;

        sendButton.interactable = false;
        try
        {
            messageInput.text = "";
            await ChatService.Send(text);
            await PollOnce();
        }
        catch (ApiException e)
        {
            errorText.text = $"Không gửi được ({e.StatusCode}): {e.Message}";
        }
        finally
        {
            sendButton.interactable = true;
        }
    }
}
