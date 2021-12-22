using System;

[Serializable]
public class ObjectMetaData
{
    public string name;
    public string map_asset;
    public string pos;
    public string rot;
    public string scale;
}

public class ObjectMetaDataCollection
{
    public ObjectMetaData[] dataList;
}
