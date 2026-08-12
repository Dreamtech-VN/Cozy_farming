using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using UnityEngine.Networking;

public static class ApiClient
{
    // Đổi sang địa chỉ server thật khi build (localhost chỉ dùng lúc dev trong Editor).
    public static string BaseUrl = "http://localhost:8080";

    public static async Task<T> GetAsync<T>(string path)
    {
        using var req = UnityWebRequest.Get(BaseUrl + path);
        await SendAsync(req);
        return JsonConvert.DeserializeObject<T>(req.downloadHandler.text);
    }

    public static async Task<T> PostAsync<T>(string path, object body)
    {
        string json = JsonConvert.SerializeObject(body);
        using var req = new UnityWebRequest(BaseUrl + path, "POST");
        byte[] bodyRaw = Encoding.UTF8.GetBytes(json);
        req.uploadHandler = new UploadHandlerRaw(bodyRaw);
        req.downloadHandler = new DownloadHandlerBuffer();
        req.SetRequestHeader("Content-Type", "application/json");
        await SendAsync(req);
        return JsonConvert.DeserializeObject<T>(req.downloadHandler.text);
    }

    private static async Task SendAsync(UnityWebRequest req)
    {
        var op = req.SendWebRequest();
        while (!op.isDone) await Task.Yield();

        if (req.result != UnityWebRequest.Result.Success)
        {
            // Server luôn trả lỗi dạng JSON {"error": "..."} — xem JsonHttp.java bên server.
            string message = req.downloadHandler != null ? req.downloadHandler.text : req.error;
            throw new ApiException((int)req.responseCode, message);
        }
    }
}
