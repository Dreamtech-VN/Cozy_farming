using System.Collections.Generic;
using UnityEngine;

namespace MyZoo
{
    public class ScreenManager : MonoBehaviour
    {
        public static ScreenManager I;

        [Tooltip("Để trống thì tự tìm GameObject tên 'Screens'")]
        public Transform screensRoot;
        [Tooltip("Để trống thì tự tìm GameObject tên 'HUD'")]
        public GameObject hud;

        readonly List<GameObject> screens = new List<GameObject>();

        void Awake()
        {
            I = this;

            if (screensRoot == null)
            {
                var found = GameObject.Find("Screens");
                if (found == null)
                {
                    Debug.LogError("Không thấy GameObject tên 'Screens'. Chạy menu MyZoo → Dựng scene, "
                                 + "hoặc gán thủ công vào ô Screens Root.");
                    return;
                }
                screensRoot = found.transform;
            }
            if (hud == null) hud = GameObject.Find("HUD");

            foreach (Transform child in screensRoot) screens.Add(child.gameObject);
        }

        public void Show(string screenName, bool showHud = false)
        {
            bool found = false;
            foreach (var s in screens)
            {
                bool match = s.name == screenName;
                s.SetActive(match);
                found = found || match;
            }
            if (!found) Debug.LogError("Không tìm thấy screen '" + screenName + "' — sai tên GameObject?");
            if (hud != null) hud.SetActive(showHud);
        }
    }
}
