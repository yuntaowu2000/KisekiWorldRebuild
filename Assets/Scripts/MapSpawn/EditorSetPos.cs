using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class EditorSetPos : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField] private string jsonName = "";
    [SerializeField] private bool ready = false;
    [SerializeField] private bool finished = false;

    [SerializeField] GameObject objectSpawner = null;

    // Update is called once per frame
    void Update()
    {
        if (!ready) {
            finished = false;
            return;
        }
        if (finished) return;
        ObjectMetaData metaData = ImportJson<ObjectMetaData>(string.Format("Json/{0}", jsonName));

        for (int i = 0; i < metaData.name.Length; i++) {
            string curr_name = metaData.name[i];
            string curr_asset = metaData.map_asset[i];
            Vector3 pos = StringToVec(metaData.pos[i]);
            Vector3 rot = StringToVec(metaData.rot[i]);
            Vector3 scale = StringToVec(metaData.scale[i]);

            GameObject curr_spawner = Instantiate(objectSpawner, this.transform);
            curr_spawner.name = curr_name;
            curr_spawner.transform.localPosition = pos;
            curr_spawner.transform.localRotation = Quaternion.Euler(rot);
            curr_spawner.transform.localScale = scale;

            ObjectSpawn objsp = curr_spawner.GetComponent<ObjectSpawn>();
            objsp.map_asset = curr_asset;
        }
        finished = true;
    }

    private Vector3 StringToVec(string stringVal) {
        string[] tmp = stringVal.Split(',');
        return new Vector3(float.Parse(tmp[0]), float.Parse(tmp[1]), float.Parse(tmp[2]));
    }

    public static T ImportJson<T>(string path)
    {
        TextAsset textAsset = Resources.Load<TextAsset>(path);
        return JsonUtility.FromJson<T>(textAsset.text);
    }
}
