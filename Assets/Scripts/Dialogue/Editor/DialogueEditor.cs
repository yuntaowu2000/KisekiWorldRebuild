using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
using System;
public class DialogueEditor : EditorWindow {
    private Dialogue selectedDialogue = null;
    [NonSerialized] private GUIStyle nodeStyle;
    [NonSerialized] private GUIStyle playerNodeStyle;
    [NonSerialized] private DialogueNode draggingNode = null;
    [NonSerialized] private Vector2 draggingOffset;
    [NonSerialized] private DialogueNode creatingNode = null;
    [NonSerialized] private DialogueNode deletingNode = null;
    [NonSerialized] private DialogueNode linkingParentNode = null;
    private Vector2 scrollPosition;
    [NonSerialized] private bool draggingCanvas = false;
    [NonSerialized] private Vector2 draggingCanvasOffset;
    private const float canvasSize = 4000;
    private const float backgroundSize = 50;

    [MenuItem("Window/Dialogue Editor")]
    private static void ShowWindow() {
        //setting utility to be true make the window not dockable
        var window = GetWindow<DialogueEditor>();
        window.titleContent = new GUIContent("Dialogue Editor");
        GUI.changed = true;
        window.Show();
    }

    [OnOpenAsset(1)]
    public static bool OpenDialog(int instanceID, int line) {
        Dialogue obj = EditorUtility.InstanceIDToObject(instanceID) as Dialogue;
        if (obj == null) {
            return false;
        }
        ShowWindow();
        return true;
    }

    private void OnEnable() {
        Selection.selectionChanged += OnSelectionChange;
        nodeStyle = new GUIStyle();
        nodeStyle.normal.background = EditorGUIUtility.Load("node0") as Texture2D;
        nodeStyle.padding = new RectOffset(20, 20, 20, 20);
        nodeStyle.border = new RectOffset(12, 12, 12, 12);

        playerNodeStyle = new GUIStyle();
        playerNodeStyle.normal.background = EditorGUIUtility.Load("node1") as Texture2D;
        playerNodeStyle.padding = new RectOffset(20, 20, 20, 20);
        playerNodeStyle.border = new RectOffset(12, 12, 12, 12);
    }

    private void OnSelectionChange() {
        Dialogue dialogue = Selection.activeObject as Dialogue;
        if (dialogue != null) {
            selectedDialogue = dialogue;
            Repaint();
        } 
    }

    private void OnGUI() {
        if (selectedDialogue == null) {
            EditorGUILayout.LabelField("no dialogue selected");
        } else {
            ProcessEvents();
            scrollPosition = EditorGUILayout.BeginScrollView(scrollPosition);
            Rect canvas = GUILayoutUtility.GetRect(canvasSize, canvasSize);
            Texture2D backgroundTexture = Resources.Load("background") as Texture2D;
            Rect texCoords = new Rect(0, 0, canvasSize / backgroundSize, canvasSize / backgroundSize);
            GUI.DrawTextureWithTexCoords(canvas, backgroundTexture, texCoords);

            foreach (DialogueNode node in selectedDialogue.GetAllNodes())
            {
                DrawConnections(node);
            }
            foreach (DialogueNode node in selectedDialogue.GetAllNodes())
            {
                DrawNode(node);
            }
            EditorGUILayout.EndScrollView();
            if (creatingNode != null) {
                selectedDialogue.CreateNode(creatingNode);
                creatingNode = null;
            }
            if (deletingNode != null) {
                selectedDialogue.DeleteNode(deletingNode);
                deletingNode = null;
            }
        }
    }

    private void ProcessEvents() {
        if (Event.current.type == EventType.MouseDown && draggingNode == null) {
            draggingNode = GetNodeAtPoint(Event.current.mousePosition + scrollPosition);
            if (draggingNode != null) {
                draggingOffset = draggingNode.GetRect().position - Event.current.mousePosition;
                Selection.activeObject = draggingNode;
            } else {
                draggingCanvas = true;
                draggingCanvasOffset = Event.current.mousePosition + scrollPosition;
                Selection.activeObject = selectedDialogue;
            }
        } else if (Event.current.type == EventType.MouseDrag && draggingNode != null) {
            draggingNode.SetPosition(Event.current.mousePosition + draggingOffset);
            GUI.changed = true;
        } else if (Event.current.type == EventType.MouseUp && draggingNode != null) {
            draggingNode = null;
        } else if (Event.current.type == EventType.MouseDrag && draggingCanvas) {
            scrollPosition = draggingCanvasOffset - Event.current.mousePosition;
            GUI.changed = true;
        } else if (Event.current.type == EventType.MouseUp && draggingCanvas) {
            draggingCanvas = false;
        }
    }

    private DialogueNode GetNodeAtPoint(Vector2 mousePosition) {
        DialogueNode returnNode = null;
        foreach (DialogueNode node in selectedDialogue.GetAllNodes()) {
            if (node.GetRect().Contains(mousePosition)) {
                returnNode = node;
            }
        }
        return returnNode;
    }

    private void DrawNode(DialogueNode node)
    {
        GUIStyle style = nodeStyle;
        if (node.IsPlayerSpeaking()) {
            style = playerNodeStyle;
        }
        GUILayout.BeginArea(node.GetRect(), style);
        EditorGUI.BeginChangeCheck();
        EditorGUILayout.LabelField("ID: " + node.name, EditorStyles.whiteLabel);
        EditorGUILayout.LabelField("Text:", EditorStyles.whiteLabel);
        string newText = EditorGUILayout.TextField(node.GetText());

        if (EditorGUI.EndChangeCheck())
        {
            node.SetText(newText);
        }

        GUILayout.BeginHorizontal();
        if (GUILayout.Button("x"))
        {
            deletingNode = node;
        }
        DrawLinkButtons(node);
        if (GUILayout.Button("+"))
        {
            creatingNode = node;
        }
        GUILayout.EndHorizontal();
        EditorGUILayout.LabelField("Speaker: ", EditorStyles.whiteLabel);
        string speaker = EditorGUILayout.TextField(node.GetSpeaker());
        if (EditorGUI.EndChangeCheck())
        {
            node.SetSpeaker(speaker);
        }

        GUILayout.EndArea();
    }

    private void DrawLinkButtons(DialogueNode node)
    {
        if (linkingParentNode == null)
        {
            if (GUILayout.Button("link"))
            {
                linkingParentNode = node;
            }
        }
        else if (node == linkingParentNode)
        {
            if (GUILayout.Button("cancel"))
            {
                linkingParentNode = null;
            }
        }
        else if (linkingParentNode.GetChildren().Contains(node.name))
        {
            if (GUILayout.Button("unlink"))
            {
                linkingParentNode.RemoveChild(node.name);
                linkingParentNode = null;
            }
        }
        // else if (node.children.Contains(linkingParentNode.uniqueID))
        // {
        //     if (GUILayout.Button("unlink"))
        //     {
        //         Undo.RecordObject(selectedDialogue, "Remove dialogue link");
        //         node.children.Remove(linkingParentNode.uniqueID);
        //         linkingParentNode = null;
        //     }
        // }
        else
        {
            if (GUILayout.Button("child"))
            {
                linkingParentNode.AddChild(node.name);
                linkingParentNode = null;
            }
        }
    }

    private void DrawConnections(DialogueNode node)
    {
        Vector3 startPosition = new Vector2 (node.GetRect().xMax - 10f, node.GetRect().center.y);
        foreach (DialogueNode children in selectedDialogue.GetAllChildren(node)) {
            Vector3 endPosition = new Vector2 (children.GetRect().xMin + 10f, children.GetRect().center.y);

            Vector3 controlPointOffset = endPosition - startPosition;
            controlPointOffset.y = 0;
            controlPointOffset.x *= 0.8f;

            Handles.DrawBezier(startPosition, endPosition,
                startPosition + controlPointOffset, endPosition - controlPointOffset, 
                Color.white, null, 4f);
        }
    }
}
