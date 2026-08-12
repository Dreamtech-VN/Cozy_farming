using System;
using UnityEngine;

// Gắn vào tilePrefab cùng 1 Collider2D (BoxCollider2D là đủ) để OnMouseDown nhận click.
public class BoardTile : MonoBehaviour
{
    public Action OnClicked;

    private void OnMouseDown() => OnClicked?.Invoke();
}
