using System.Collections.Generic;
using UnityEngine;

// Id trang phục lúc tạo nhân vật KHÔNG có catalog thật từ server (khác hệ
// cosmetic mở rộng ở /api/cosmetics/catalog) — bảng ánh xạ id -> sprite này
// là quy ước riêng của client, tự thêm entry khi có sprite thật.
public static class OutfitAssets
{
    public static readonly Dictionary<int, Sprite> HairSprites = new();
    public static readonly Dictionary<int, Sprite> TopSprites = new();
    public static readonly Dictionary<int, Sprite> BottomSprites = new();
}
