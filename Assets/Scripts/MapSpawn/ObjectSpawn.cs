using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectSpawn : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField] public string map_asset;
    GameObject instantiatedObj = null;

    public void Spawn() {
        GameObject obj = Resources.Load<GameObject>(string.Format("Models/{0}", map_asset));
        if (obj == null) return;
        instantiatedObj = Instantiate(obj, this.transform);
    }

    public void DestroyChild() {
        if (instantiatedObj != null) {
            Destroy(instantiatedObj);
            instantiatedObj = null;
        }
    }
}
