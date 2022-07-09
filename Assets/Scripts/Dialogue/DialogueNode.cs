using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;
public class DialogueNode: ScriptableObject
{
    [SerializeField] private string text;
    [SerializeField] private List<string> children = new List<string>();
    [SerializeField] private Rect rect = new Rect(0, 0, 200, 150);
    [SerializeField] private string speaker;
    [SerializeField] private string onEnterAction;
    [SerializeField] private string onExitAction;
    [SerializeField] Condition condition;

    public string GetText() {
        return this.text;
    }

    public List<string> GetChildren() {
        return this.children;
    }

    public string GetChild()
    {
        if (this.children.Count > 0)
            return this.children[0];
        return String.Empty;
    }

    public Rect GetRect() {
        return this.rect;
    }

    public bool IsPlayerSpeaking()
    {
        return speaker == "Rufus";
    }

    public string GetSpeaker()
    {
        return speaker;
    }

    public string GetOnEnterAction()
    {
        return onEnterAction;
    }

    public string GetOnExitAction()
    {
        return onExitAction;
    }

    public bool CheckCondition(IEnumerable<IPredicateEvaluator> evaluators)
    {
        return condition.Check(evaluators);
    }

#if UNITY_EDITOR

    public void SetText(string text) {
        if (this.text != text) {
            Undo.RecordObject(this, "Update dialogue text");
            this.text = text;
            EditorUtility.SetDirty(this);
        }
        
    }
    public void SetPosition(Vector2 newPosition) {
        Undo.RecordObject(this, "Move Dialogue Node");
        this.rect.position = newPosition;
        EditorUtility.SetDirty(this);
    }

    public void AddChild (string childName) {
        Undo.RecordObject(this, "Add dialogue link");
        this.children.Add(childName);
        EditorUtility.SetDirty(this);
    }

    public void RemoveChild(string childName) {
        Undo.RecordObject(this, "Remove dialogue link");
        this.children.Remove(childName);
        EditorUtility.SetDirty(this);
    }

    public void SetSpeaker(string speaker) {
        Undo.RecordObject(this, "Change dialogue speaker");
        this.speaker = speaker;
        EditorUtility.SetDirty(this);
    }
#endif
}
