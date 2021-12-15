using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectSpawn : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField] public string map_asset;

    void Start()
    {
        GameObject obj = Resources.Load<GameObject>(string.Format("Models/{0}", map_asset));
        Instantiate(obj, this.transform);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
