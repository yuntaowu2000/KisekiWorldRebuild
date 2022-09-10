using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
public class DialogModificationProcessor : UnityEditor.AssetModificationProcessor
{
    private static AssetMoveResult OnWillMoveAsset(string sourcePath, string destinationPath) 
    {
        Dialog Dialog = AssetDatabase.LoadMainAssetAtPath(sourcePath) as Dialog;
        if (Dialog == null) 
        {
            return AssetMoveResult.DidNotMove;
        }

        if (Path.GetDirectoryName(sourcePath) != Path.GetDirectoryName(destinationPath)) 
        {
            return AssetMoveResult.DidNotMove;
        }

        Dialog.name = Path.GetFileNameWithoutExtension(destinationPath);

        return AssetMoveResult.DidNotMove;
    }
}

