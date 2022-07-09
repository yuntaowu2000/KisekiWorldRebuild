using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
using System;


[CreateAssetMenu(fileName = "New Dialogue", menuName = "Dialogue", order = 0)]
public class Dialogue : ScriptableObject, ISerializationCallbackReceiver {
    [SerializeField] private List<DialogueNode> nodes = new List<DialogueNode>();
    [SerializeField] private Vector2 newNodeOffset = new Vector2(250f, 0);
    private Dictionary<string, DialogueNode> nodeLookup = new Dictionary<string, DialogueNode>();

    private void OnValidate() {
        //called when value is changed in inspector or the object is loaded
        nodeLookup.Clear();
        foreach (DialogueNode node in GetAllNodes()) {
            nodeLookup[node.name] = node;
        }
    }

    public IEnumerable<DialogueNode> GetAllNodes() {
        return nodes;
    }

    public IEnumerable<DialogueNode> GetAllChildren(DialogueNode parentNode) {
        foreach (string childId in parentNode.GetChildren()) {
            if (nodeLookup.ContainsKey(childId)) {
                yield return nodeLookup[childId];
            }
        }
    }

    public IEnumerable<DialogueNode> GetPlayerChildren(DialogueNode parentNode) {
        foreach (DialogueNode node in GetAllChildren(parentNode)) {
            if (node.IsPlayerSpeaking()) {
                yield return node;
            }
        }
    }

    public IEnumerable<DialogueNode> GetAIChildren(DialogueNode parentNode)
    {
        foreach (DialogueNode node in GetAllChildren(parentNode)) {
            if (!node.IsPlayerSpeaking()) {
                yield return node;
            }
        }
    }

    public DialogueNode GetNode(string nodeId)
    {
        DialogueNode node = null;
        nodeLookup.TryGetValue(nodeId, out node);
        return node;
    }

    public DialogueNode GetRootNode() {
        return nodes[0];
    }

#if UNITY_EDITOR
    public void CreateNode(DialogueNode parent)
    {
        DialogueNode newNode = MakeNode(parent);
        Undo.RegisterCreatedObjectUndo(newNode, "created dialogue node");
        Undo.RecordObject(this, "Added dialogue node");
        AddNode(newNode);
    }

    private DialogueNode MakeNode(DialogueNode parent)
    {
        DialogueNode newNode = CreateInstance<DialogueNode>();
        newNode.name = System.Guid.NewGuid().ToString();
        if (parent != null)
        {
            parent.AddChild(newNode.name);
            newNode.SetPosition(parent.GetRect().position + newNodeOffset);
        }

        return newNode;
    }

    private void AddNode(DialogueNode newNode)
    {
        nodes.Add(newNode);
        OnValidate();
    }

    public void DeleteNode(DialogueNode nodeToDelete)
    {
        Undo.RecordObject(this, "Delete dialog");
        nodes.Remove(nodeToDelete);
        CleanDanglingChildren(nodeToDelete);
        OnValidate();
        Undo.DestroyObjectImmediate(nodeToDelete);
    }

    private void CleanDanglingChildren(DialogueNode nodeToDelete)
    {
        foreach (DialogueNode node in GetAllNodes())
        {
            node.RemoveChild(nodeToDelete.name);
        }
    }

    public void OnBeforeSerialize()
    {
        if (nodes.Count == 0) {
            DialogueNode newNode = MakeNode(null);
            AddNode(newNode);
        }
        if (AssetDatabase.GetAssetPath(this) != "") {
            foreach (DialogueNode node in GetAllNodes()) {
                if (AssetDatabase.GetAssetPath(node) == "") {
                    AssetDatabase.AddObjectToAsset(node, this);
                }
            }
        }
    }

    public void OnAfterDeserialize()
    {
        //no need for deserialize
    }
#endif
}