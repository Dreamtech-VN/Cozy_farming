using System;
using UnityEngine;
using UnityEngine.UI;

// Gắn vào panel tạo nhân vật (Giai đoạn 3). hairId/topId/bottomId để mặc
// định 0 — chưa có catalog trang phục thật cho bước tạo nhân vật (khác hệ
// cosmetic mở rộng), server chấp nhận số nguyên tự do, xem OutfitAssets.cs.
public class CharacterCreatePanel : MonoBehaviour
{
    [SerializeField] private InputField nameInput;
    [SerializeField] private Toggle femaleToggle; // off = nam (0), on = nữ (1)
    [SerializeField] private Button createButton;
    [SerializeField] private Text errorText;

    [SerializeField] private int hairId = 0;
    [SerializeField] private int topId = 0;
    [SerializeField] private int bottomId = 0;

    public event Action<CharacterResponse> Created;

    private void OnEnable()
    {
        errorText.text = "";
        createButton.onClick.AddListener(OnCreateClicked);
    }

    private void OnDisable()
    {
        createButton.onClick.RemoveListener(OnCreateClicked);
    }

    private async void OnCreateClicked()
    {
        string name = nameInput.text.Trim();
        if (name.Length < 2 || name.Length > 20)
        {
            errorText.text = "Tên nhân vật phải từ 2-20 ký tự";
            return;
        }

        createButton.interactable = false;
        try
        {
            int gender = femaleToggle.isOn ? 1 : 0;
            var character = await CharacterService.Create(name, gender, hairId, topId, bottomId);
            Created?.Invoke(character);
        }
        catch (ApiException e)
        {
            errorText.text = $"Không tạo được nhân vật ({e.StatusCode}): {e.Message}";
        }
        finally
        {
            createButton.interactable = true;
        }
    }
}
