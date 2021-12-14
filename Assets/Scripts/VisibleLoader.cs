using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VisibleLoader : MonoBehaviour
{
    // Start is called before the first frame update
    MeshRenderer meshRenderer;
    MeshCollider meshCollider;
    void Start()
    {
        meshRenderer = gameObject.GetComponentInChildren<MeshRenderer>();
        meshCollider = gameObject.GetComponent<MeshCollider>();
    }

    // Update is called once per frame
    void Update()
    {
        if (meshRenderer == null) return;
        if (meshCollider == null) return;
        if (meshRenderer.isVisible && !meshRenderer.enabled) {
            meshRenderer.enabled = true;
            meshCollider.enabled = true;
        } else if (!meshRenderer.isVisible && meshRenderer.enabled) {
            meshRenderer.enabled = false;
            meshCollider.enabled = false;
        }
    }
}
