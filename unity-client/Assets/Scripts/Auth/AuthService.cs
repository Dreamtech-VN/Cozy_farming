using System.Threading.Tasks;
using UnityEngine;

public static class AuthService
{
    private const string GuestTokenPrefKey = "guestToken";

    public static async Task<GuestLoginResponse> LoginAsGuest()
    {
        string savedToken = PlayerPrefs.GetString(GuestTokenPrefKey, "");
        var res = await ApiClient.PostAsync<GuestLoginResponse>(
            "/api/auth/guest", new GuestLoginRequest { guestToken = savedToken });

        PlayerPrefs.SetString(GuestTokenPrefKey, res.guestToken);
        PlayerPrefs.Save();

        Session.UserId = res.userId;
        Session.GuestToken = res.guestToken;
        return res;
    }
}
