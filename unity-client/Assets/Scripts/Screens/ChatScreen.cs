using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class ChatScreen : MonoBehaviour
    {
        // Người chơi ráp sprite cho sticker/GIF ở đây, khớp theo id trong catalog của server.
        [Serializable]
        public class StickerArt
        {
            public string id;
            public Sprite sprite;
        }

        public Text titleText, banText, partnerText;
        public Button worldTabButton, privateTabButton, sendButton, stickerButton, gifButton, voiceButton, backButton;
        public InputField messageInput;
        public Transform messageContent, pickerContent, emojiContent;
        public GameObject rowPrefab, pickerCellPrefab, pickerPanel;
        public ScrollRect messageScroll;

        public GameObject actionPanel;
        public Text actionTitleText;
        public Button actionPrivateButton, actionMuteButton, actionBlockButton, actionReportButton, actionCloseButton;

        public List<StickerArt> stickerArt = new List<StickerArt>();

        static readonly string[] Emojis = { "🐰", "🐼", "🌾", "🌻", "💰", "❤️", "😄", "😢", "👍", "🎉" };
        const float PollSeconds = 3f;

        static int pendingPartnerId;
        static string pendingPartnerName;

        ChatCatalogDto catalog;
        AudioSource speaker;
        readonly List<ChatMessage> shown = new List<ChatMessage>();
        readonly Dictionary<string, AudioClip> voiceCache = new Dictionary<string, AudioClip>();
        string channel = "WORLD";
        string pickerType = "";
        int partnerId;
        string partnerName = "";
        long sinceId;
        ChatMessage selected;

        // Mở thẳng khung chat riêng với một người (gọi từ màn bạn bè / bảng xếp hạng).
        public static void OpenPrivate(int playerId, string name)
        {
            pendingPartnerId = playerId;
            pendingPartnerName = name;
            ScreenManager.I.Show("S37_Chat", true);
        }

        void Start()
        {
            speaker = gameObject.AddComponent<AudioSource>();
            worldTabButton.onClick.AddListener(delegate { SwitchChannel("WORLD"); });
            privateTabButton.onClick.AddListener(delegate { SwitchChannel("PRIVATE"); });
            sendButton.onClick.AddListener(delegate { StartCoroutine(SendText()); });
            stickerButton.onClick.AddListener(delegate { TogglePicker("STICKER"); });
            gifButton.onClick.AddListener(delegate { TogglePicker("GIF"); });
            voiceButton.onClick.AddListener(delegate { StartCoroutine(ToggleVoice()); });
            backButton.onClick.AddListener(delegate { ScreenManager.I.Show("S09_Lobby", true); });
            actionCloseButton.onClick.AddListener(delegate { actionPanel.SetActive(false); });
            actionPrivateButton.onClick.AddListener(OpenSelectedPrivate);
            actionMuteButton.onClick.AddListener(delegate { StartCoroutine(Relation("MUTE")); });
            actionBlockButton.onClick.AddListener(delegate { StartCoroutine(Relation("BLOCK")); });
            actionReportButton.onClick.AddListener(delegate { StartCoroutine(Report()); });
            BuildEmojiBar();
        }

        void OnEnable()
        {
            actionPanel.SetActive(false);
            pickerPanel.SetActive(false);
            if (pendingPartnerId > 0)
            {
                partnerId = pendingPartnerId;
                partnerName = pendingPartnerName;
                pendingPartnerId = 0;
                channel = "PRIVATE";
            }
            Reset();
            StartCoroutine(Poll());
        }

        void OnDisable()
        {
            StopAllCoroutines();
            ChatVoice.Cancel();
        }

        void SwitchChannel(string next)
        {
            channel = next;
            Reset();
            if (next == "PRIVATE" && partnerId <= 0) StartCoroutine(ShowFriendPicker());
        }

        void Reset()
        {
            sinceId = 0;
            shown.Clear();
            foreach (Transform child in messageContent) Destroy(child.gameObject);
            titleText.text = channel == "WORLD" ? "Chat thế giới" : "Chat riêng";
            partnerText.text = channel == "PRIVATE" ? "Đang nhắn với " + partnerName : "";
            worldTabButton.interactable = channel != "WORLD";
            privateTabButton.interactable = channel != "PRIVATE";
        }

        IEnumerator Poll()
        {
            while (true)
            {
                yield return Fetch();
                yield return new WaitForSeconds(PollSeconds);
            }
        }

        // Chưa chọn ai thì dùng ngay khung tin nhắn để liệt kê bạn bè cho chọn.
        IEnumerator ShowFriendPicker()
        {
            partnerText.text = "Chọn một người bạn để nhắn riêng";
            yield return Api.I.GetFriends(delegate (FriendsView view)
            {
                if (view == null || view.friends == null) return;
                foreach (var friend in view.friends)
                {
                    var row = Instantiate(rowPrefab, messageContent).GetComponent<Button>();
                    row.GetComponentInChildren<Text>().text = friend.name;
                    int id = friend.playerId;
                    string name = friend.name;
                    row.onClick.AddListener(delegate
                    {
                        partnerId = id;
                        partnerName = name;
                        Reset();
                    });
                }
            }, Toast.Show);
            if (messageContent.childCount == 0) partnerText.text = "Chưa có bạn bè — kết bạn ở màn Bạn bè trước nhé";
        }

        IEnumerator Fetch()
        {
            if (channel == "PRIVATE" && partnerId <= 0) yield break;
            if (catalog == null) yield return Api.I.GetChatCatalog(delegate (ChatCatalogDto c) { catalog = c; }, delegate (string e) { });

            string wanted = channel;
            Action<ChatFeed> apply = delegate (ChatFeed feed)
            {
                if (feed == null || wanted != channel) return;
                ShowBan(feed.ban);
                if (feed.messages == null) return;
                foreach (var message in feed.messages)
                {
                    if (message.id > sinceId) sinceId = message.id;
                    AddRow(message);
                }
            };
            if (channel == "WORLD") yield return Api.I.GetWorldChat(sinceId, apply, delegate (string e) { });
            else yield return Api.I.GetPrivateChat(partnerId, sinceId, apply, delegate (string e) { });
        }

        void ShowBan(ChatBan ban)
        {
            bool banned = ban != null && ban.banned;
            banText.gameObject.SetActive(banned);
            if (banned) banText.text = "Bạn đang bị cấm chat: " + ban.reason;
            messageInput.interactable = !banned;
            sendButton.interactable = !banned;
            stickerButton.interactable = !banned;
            gifButton.interactable = !banned;
            voiceButton.interactable = !banned;
        }

        void AddRow(ChatMessage message)
        {
            shown.Add(message);
            var row = Instantiate(rowPrefab, messageContent).GetComponent<Button>();
            row.GetComponentInChildren<Text>().text = Describe(message);

            var icon = FindIcon(row.transform);
            var art = message.type == "STICKER" || message.type == "GIF" ? SpriteFor(message.refId) : null;
            if (icon != null)
            {
                icon.gameObject.SetActive(art != null);
                if (art != null) icon.sprite = art;
            }

            var captured = message;
            row.onClick.AddListener(delegate { OnRowClicked(captured); });
            if (messageScroll != null) StartCoroutine(ScrollToBottom());
        }

        string Describe(ChatMessage message)
        {
            string who = message.channel == "SYSTEM" ? "[Hệ thống]" : message.senderName;
            string body;
            if (message.deleted) body = message.text;
            else if (message.type == "STICKER") body = "[sticker] " + NameOf(catalog != null ? catalog.stickers : null, message.refId);
            else if (message.type == "GIF") body = "[gif] " + NameOf(catalog != null ? catalog.gifs : null, message.refId);
            else if (message.type == "VOICE") body = "[ghi âm] bấm để nghe";
            else body = message.text;
            return who + ": " + body;
        }

        string NameOf(List<StickerDef> defs, string id)
        {
            if (defs != null)
                foreach (var def in defs) if (def.id == id) return def.name;
            return id;
        }

        Sprite SpriteFor(string id)
        {
            foreach (var art in stickerArt) if (art.id == id) return art.sprite;
            return null;
        }

        Image FindIcon(Transform row)
        {
            var found = row.Find("Icon");
            return found != null ? found.GetComponent<Image>() : null;
        }

        IEnumerator ScrollToBottom()
        {
            yield return null;
            messageScroll.verticalNormalizedPosition = 0f;
        }

        void OnRowClicked(ChatMessage message)
        {
            if (message.type == "VOICE" && !message.deleted) { StartCoroutine(PlayVoice(message.refId)); return; }
            if (message.channel == "SYSTEM" || (App.I.Me != null && message.senderId == App.I.Me.playerId)) return;
            selected = message;
            actionTitleText.text = message.senderName;
            actionPanel.SetActive(true);
        }

        // ---------- Gửi ----------
        IEnumerator SendText()
        {
            string text = messageInput.text.Trim();
            if (text.Length == 0) yield break;
            yield return Send("TEXT", text, null);
        }

        IEnumerator Send(string type, string text, string refId)
        {
            sendButton.interactable = false;
            yield return Api.I.SendChat(channel, channel == "PRIVATE" ? partnerId : 0, type, text, refId,
                delegate (ChatSendResult result)
                {
                    messageInput.text = "";
                    if (!string.IsNullOrEmpty(result.notice)) Toast.Show(result.notice);
                    StartCoroutine(Fetch());
                }, Toast.Show);
            sendButton.interactable = true;
        }

        void BuildEmojiBar()
        {
            if (emojiContent == null) return;
            foreach (var emoji in Emojis)
            {
                var button = Instantiate(pickerCellPrefab, emojiContent).GetComponent<Button>();
                button.GetComponentInChildren<Text>().text = emoji;
                string captured = emoji;
                button.onClick.AddListener(delegate { messageInput.text += captured; });
            }
        }

        void TogglePicker(string type)
        {
            if (pickerPanel.activeSelf && pickerType == type) { pickerPanel.SetActive(false); return; }
            StartCoroutine(FillPicker(type));
        }

        IEnumerator FillPicker(string type)
        {
            if (catalog == null) yield return Api.I.GetChatCatalog(delegate (ChatCatalogDto c) { catalog = c; }, Toast.Show);
            if (catalog == null) yield break;

            pickerType = type;
            pickerPanel.SetActive(true);
            foreach (Transform child in pickerContent) Destroy(child.gameObject);
            var defs = type == "STICKER" ? catalog.stickers : catalog.gifs;
            if (defs == null) yield break;
            foreach (var def in defs)
            {
                var cell = Instantiate(pickerCellPrefab, pickerContent).GetComponent<Button>();
                cell.GetComponentInChildren<Text>().text = def.name;
                var art = SpriteFor(def.id);
                var icon = FindIcon(cell.transform);
                if (icon != null)
                {
                    icon.gameObject.SetActive(art != null);
                    if (art != null) icon.sprite = art;
                }
                string id = def.id;
                string kind = type;
                cell.onClick.AddListener(delegate
                {
                    pickerPanel.SetActive(false);
                    StartCoroutine(Send(kind, null, id));
                });
            }
        }

        // ---------- Ghi âm ----------
        IEnumerator ToggleVoice()
        {
            if (ChatVoice.IsRecording)
            {
                int durationMs;
                var wav = ChatVoice.Stop(out durationMs);
                voiceButton.GetComponentInChildren<Text>().text = "Ghi âm";
                if (wav == null || durationMs < 500) { Toast.Show("Đoạn ghi âm quá ngắn"); yield break; }
                yield return Api.I.UploadVoice(wav, durationMs,
                    delegate (VoiceMeta meta) { StartCoroutine(Send("VOICE", null, meta.voiceId)); }, Toast.Show);
                yield break;
            }

            if (!ChatVoice.Start()) { Toast.Show("Máy không có micro hoặc chưa cấp quyền"); yield break; }
            voiceButton.GetComponentInChildren<Text>().text = "Dừng";
            Toast.Show("Đang ghi âm, tối đa " + ChatVoice.MaxSeconds + " giây");
        }

        IEnumerator PlayVoice(string voiceId)
        {
            AudioClip clip;
            if (!voiceCache.TryGetValue(voiceId, out clip))
            {
                yield return Api.I.DownloadVoice(voiceId, delegate (byte[] data)
                {
                    clip = ChatVoice.DecodeWav(data, voiceId);
                    voiceCache[voiceId] = clip;
                }, Toast.Show);
            }
            if (clip != null) speaker.PlayOneShot(clip);
        }

        // ---------- Hành động trên tin ----------
        void OpenSelectedPrivate()
        {
            if (selected == null) return;
            partnerId = selected.senderId;
            partnerName = selected.senderName;
            channel = "PRIVATE";
            actionPanel.SetActive(false);
            Reset();
        }

        IEnumerator Relation(string mode)
        {
            if (selected == null) yield break;
            int target = selected.senderId;
            yield return Api.I.SetChatRelation(target, mode, delegate (ChatRelations r)
            {
                Toast.Show(mode == "MUTE" ? "Đã ẩn tin của người này" : "Đã chặn người này");
                actionPanel.SetActive(false);
                Reset();
            }, Toast.Show);
        }

        IEnumerator Report()
        {
            if (selected == null) yield break;
            yield return Api.I.ReportMessage(selected.id, "Người chơi báo cáo",
                delegate (OkResult r) { Toast.Show("Đã gửi báo cáo cho quản trị viên"); actionPanel.SetActive(false); },
                Toast.Show);
        }
    }
}
