using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;


[CreateAssetMenu(fileName = "New Dialog", menuName = "Dialog", order = 0)]
public class Dialog : ScriptableObject, ISerializationCallbackReceiver 
{
    [SerializeField] private List<DialogNode> nodes = new List<DialogNode>();
    [SerializeField] private Vector2 newNodeOffset = new Vector2(250f, 0);
    private Dictionary<string, DialogNode> nodeLookup = new Dictionary<string, DialogNode>();

    private void OnValidate() {
        //called when value is changed in inspector or the object is loaded
        SetupDialogNodes();
    }

    public void SetupDialogNodes()
    {
        nodeLookup.Clear();
        foreach (DialogNode node in GetAllNodes()) {
            nodeLookup[node.name] = node;
        }
    }

    public IEnumerable<DialogNode> GetAllNodes() {
        return nodes;
    }

    public IEnumerable<DialogNode> GetAllChildren(DialogNode parentNode) {
        foreach (string childId in parentNode.GetChildren()) {
            if (nodeLookup.ContainsKey(childId)) {
                yield return nodeLookup[childId];
            }
        }
    }

    public IEnumerable<DialogNode> GetPlayerChildren(DialogNode parentNode) {
        foreach (DialogNode node in GetAllChildren(parentNode)) {
            if (node.IsPlayerSpeaking()) {
                yield return node;
            }
        }
    }

    public IEnumerable<DialogNode> GetAIChildren(DialogNode parentNode)
    {
        foreach (DialogNode node in GetAllChildren(parentNode)) {
            if (!node.IsPlayerSpeaking()) {
                yield return node;
            }
        }
    }

    public DialogNode GetNode(string nodeId)
    {
        DialogNode node = null;
        nodeLookup.TryGetValue(nodeId, out node);
        return node;
    }

    public DialogNode GetRootNode() {
        return nodes[0];
    }

#if UNITY_EDITOR
    public void CreateNode(DialogNode parent)
    {
        DialogNode newNode = MakeNode(parent);
        Undo.RegisterCreatedObjectUndo(newNode, "created Dialog node");
        Undo.RecordObject(this, "Added Dialog node");
        AddNode(newNode);
    }

    private DialogNode MakeNode(DialogNode parent)
    {
        DialogNode newNode = CreateInstance<DialogNode>();
        newNode.name = System.Guid.NewGuid().ToString();
        if (parent != null)
        {
            parent.AddChild(newNode.name);
            newNode.SetPosition(parent.GetRect().position + newNodeOffset);
        }

        return newNode;
    }

    private void AddNode(DialogNode newNode)
    {
        nodes.Add(newNode);
        OnValidate();
    }

    public void DeleteNode(DialogNode nodeToDelete)
    {
        Undo.RecordObject(this, "Delete dialog");
        nodes.Remove(nodeToDelete);
        CleanDanglingChildren(nodeToDelete);
        OnValidate();
        Undo.DestroyObjectImmediate(nodeToDelete);
    }

    private void CleanDanglingChildren(DialogNode nodeToDelete)
    {
        foreach (DialogNode node in GetAllNodes())
        {
            node.RemoveChild(nodeToDelete.name);
        }
    }
#endif

    public void OnBeforeSerialize()
    {
#if UNITY_EDITOR
        if (nodes.Count == 0) {
            DialogNode newNode = MakeNode(null);
            AddNode(newNode);
        }
        if (AssetDatabase.GetAssetPath(this) != "") {
            foreach (DialogNode node in GetAllNodes()) {
                if (AssetDatabase.GetAssetPath(node) == "") {
                    AssetDatabase.AddObjectToAsset(node, this);
                }
            }
        }
#endif
    }

    public void OnAfterDeserialize()
    {
        //no need for deserialize
    }

}