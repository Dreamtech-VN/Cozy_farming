using System.Threading.Tasks;
using UnityEngine;

public static class AccountService
{
    public static async Task<AccountResponse> Register(string username, string password)
    {
        var res = await ApiClient.PostAsync<AccountResponse>("/api/auth/register", new { username, password });
        Session.UserId = res.userId;
        return res;
    }

    public static async Task<AccountResponse> Login(string username, string password)
    {
        var res = await ApiClient.PostAsync<AccountResponse>("/api/auth/login", new { username, password });
        Session.UserId = res.userId;
        return res;
    }

    // Gắn username/password vào tài khoản khách hiện tại — giữ nguyên toàn bộ dữ liệu chơi.
    public static Task<AccountResponse> UpgradeGuest(string username, string password)
    {
        return ApiClient.PostAsync<AccountResponse>("/api/auth/link/upgrade", new
        {
            userId = Session.UserId,
            username,
            password,
        });
    }

    public static Task ChangePassword(string currentPassword, string newPassword)
    {
        return ApiClient.PostAsync<object>("/api/account/change-password", new
        {
            userId = Session.UserId,
            currentPassword,
            newPassword,
        });
    }

    // devOnlyCode chỉ trả về ở môi trường dev (chưa có hệ gửi email thật) — production sẽ null.
    public static Task<ForgotPasswordResponse> ForgotPasswordRequest(string username)
    {
        return ApiClient.PostAsync<ForgotPasswordResponse>("/api/auth/forgot/request", new { username });
    }

    public static Task<AccountResponse> ForgotPasswordReset(string username, string code, string newPassword)
    {
        return ApiClient.PostAsync<AccountResponse>("/api/auth/forgot/reset", new { username, code, newPassword });
    }

    public static async Task DeleteAccount(string password)
    {
        await ApiClient.PostAsync<object>("/api/account/delete", new
        {
            userId = Session.UserId,
            password,
        });
        Session.UserId = -1;
        Session.GuestToken = "";
        PlayerPrefs.DeleteKey("guestToken");
        PlayerPrefs.Save();
    }
}
