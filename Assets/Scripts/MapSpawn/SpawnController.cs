using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnController : MonoBehaviour
{
    private const string k_PlayerTag = "Player";
    ObjectSpawn[] spawners;
    
    void Start()
    {
        spawners = GetComponentsInChildren<ObjectSpawn>();
    }

    IEnumerator ChildrenSpawn() {
        foreach (ObjectSpawn sp in spawners) {
            sp.Spawn();
            yield return null;
        }
    }

    IEnumerator ChildrenDestroy() {
        foreach (ObjectSpawn sp in spawners) {
            sp.DestroyChild();
            yield return null;
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag != k_PlayerTag) return;
        StartCoroutine(ChildrenSpawn());
    }

    void OnTriggerExit(Collider other)
    {
        if (other.tag != k_PlayerTag) return;
        StartCoroutine(ChildrenDestroy());
    }
}
