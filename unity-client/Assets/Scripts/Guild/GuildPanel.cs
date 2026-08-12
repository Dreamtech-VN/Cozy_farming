using UnityEngine;
using UnityEngine.UI;

// Gắn vào panel Guild. Có guild -> hiện thông tin + danh sách thành viên +
// nút rời guild. Chưa có -> hiện danh sách guild + nút vào.
public class GuildPanel : MonoBehaviour
{
    [SerializeField] private GameObject noGuildView;
    [SerializeField] private Transform guildListContent;
    [SerializeField] private Button guildListButtonPrefab;

    [SerializeField] private GameObject myGuildView;
    [SerializeField] private Text myGuildNameText;
    [SerializeField] private Transform memberListContent;
    [SerializeField] private Text memberEntryTemplate;
    [SerializeField] private Button leaveButton;

    [SerializeField] private Text errorText;

    private void OnEnable()
    {
        leaveButton.onClick.AddListener(OnLeaveClicked);
        _ = Refresh();
    }

    private void OnDisable()
    {
        leaveButton.onClick.RemoveListener(OnLeaveClicked);
    }

    public async System.Threading.Tasks.Task Refresh()
    {
        errorText.text = "";
        var myGuild = await GuildService.GetMyGuildOrNull();
        if (myGuild != null)
        {
            ShowMyGuild(myGuild);
        }
        else
        {
            await ShowGuildList();
        }
    }

    private async System.Threading.Tasks.Task ShowGuildList()
    {
        myGuildView.SetActive(false);
        noGuildView.SetActive(true);
        foreach (Transform child in guildListContent) Destroy(child.gameObject);

        var guilds = await GuildService.ListGuilds();
        foreach (var guild in guilds)
        {
            var btn = Instantiate(guildListButtonPrefab, guildListContent);
            btn.GetComponentInChildren<Text>().text =
                $"[{guild.tag}] {guild.name} ({guild.memberCount}/{guild.maxMembers})";
            btn.onClick.AddListener(() => _ = OnJoinClicked(guild.id));
        }
    }

    private async System.Threading.Tasks.Task OnJoinClicked(int guildId)
    {
        try
        {
            await GuildService.Join(guildId);
            await Refresh();
        }
        catch (ApiException e)
        {
            errorText.text = $"Không vào được guild ({e.StatusCode}): {e.Message}";
        }
    }

    private void ShowMyGuild(GuildInfoResponse guild)
    {
        noGuildView.SetActive(false);
        myGuildView.SetActive(true);
        myGuildNameText.text = $"[{guild.tag}] {guild.name} — {guild.memberCount}/{guild.maxMembers} thành viên";

        foreach (Transform child in memberListContent) Destroy(child.gameObject);
        foreach (var member in guild.members)
        {
            var entry = Instantiate(memberEntryTemplate, memberListContent);
            entry.gameObject.SetActive(true);
            entry.text = $"User #{member.userId} — {member.role}";
        }
    }

    private async void OnLeaveClicked()
    {
        try
        {
            await GuildService.Leave();
            await Refresh();
        }
        catch (ApiException e)
        {
            errorText.text = $"Không rời được guild ({e.StatusCode}): {e.Message}";
        }
    }
}
