using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class HabitatCard : MonoBehaviour
    {
        public Text nameText;
        public Transform animalRow;
        public GameObject animalIconPrefab;   // GameObject có Image
        public Button button;

        public void Bind(Habitat habitat, Sprite[] animalSprites, System.Action<Habitat> onClick)
        {
            nameText.text = habitat.name + " (" + habitat.animals.Count + "/" + habitat.capacity + ")";

            foreach (Transform child in animalRow) Destroy(child.gameObject);
            foreach (var animal in habitat.animals)
            {
                var icon = Instantiate(animalIconPrefab, animalRow).GetComponent<Image>();
                if (animalSprites != null)
                    foreach (var s in animalSprites)
                        if (s != null && s.name == animal.speciesId) icon.sprite = s;
                // Đói thì làm mờ đi cho dễ thấy
                icon.color = animal.fed ? Color.white : new Color(1f, 0.6f, 0.6f, 1f);
            }

            button.onClick.RemoveAllListeners();
            button.onClick.AddListener(delegate { onClick(habitat); });
        }
    }
}
