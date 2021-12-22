using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class EditorSetPos : MonoBehaviour
{
    private enum gameType {Sen, Kuro};
    [SerializeField] private gameType type;
    private string game = "";
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
        
        game = (type == gameType.Sen) ? "sen" : "kuro";

        ObjectMetaDataCollection metaDataCollection = ImportJson<ObjectMetaDataCollection>(string.Format("Json/{0}/{1}", game,jsonName));
        ObjectMetaData[] metaData = metaDataCollection.dataList;

        for (int i = 0; i < metaData.Length; i++) {
            string curr_name = metaData[i].name;
            string curr_asset = string.Format("{0}/{1}", game, metaData[i].map_asset.Split('.')[0]);
            Vector3 pos = StringToVec(metaData[i].pos);
            pos = new Vector3(-pos[0], pos[1], pos[2]);
            Vector3 rot = StringToVec(metaData[i].rot);
            rot = new Vector3(rot[0] / Mathf.PI * 180, -rot[1] / Mathf.PI * 180, rot[2] / Mathf.PI * 180);
            Vector3 scale = StringToVec(metaData[i].scale);

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
        string finalizedStr = "{\"dataList\": " + textAsset.text + "}";
        return JsonUtility.FromJson<T>(finalizedStr);
    }
}
