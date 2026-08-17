using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace MyZoo
{
    public class Toast : MonoBehaviour
    {
        public static Toast I;
        public Text label;

        CanvasGroup group;

        void Awake()
        {
            I = this;
            group = GetComponent<CanvasGroup>();
            if (group == null) group = gameObject.AddComponent<CanvasGroup>();
            group.alpha = 0;
        }

        public static void Show(string message)
        {
            if (I == null || I.label == null) { Debug.Log(message); return; }
            I.StopAllCoroutines();
            I.StartCoroutine(I.Run(message));
        }

        IEnumerator Run(string message)
        {
            label.text = message;
            group.alpha = 1;
            yield return new WaitForSeconds(2.5f);
            while (group.alpha > 0)
            {
                group.alpha -= Time.deltaTime * 2f;
                yield return null;
            }
        }
    }
}
