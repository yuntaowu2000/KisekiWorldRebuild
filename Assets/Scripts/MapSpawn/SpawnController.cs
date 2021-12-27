using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnController : MonoBehaviour
{
    [SerializeField] float maxDistance = 100f;
    [SerializeField] Transform centerPosition;
    ObjectSpawn[] spawners;
    Transform playerTransform;
    [SerializeField] bool spawned = false;
    // Start is called before the first frame update
    void Start()
    {
        spawners = GetComponentsInChildren<ObjectSpawn>();
        playerTransform = GameObject.FindWithTag("Player").transform;
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

    // Update is called once per frame
    void Update()
    {
        float distance = Vector3.Distance(playerTransform.position, centerPosition.position);
        if (!spawned && distance <= maxDistance) {
            StartCoroutine(ChildrenSpawn());
            spawned = true;
            return;
        }

        if (spawned && distance > maxDistance) {
            StartCoroutine(ChildrenDestroy());
            spawned = false;
            return;
        }
    }
}
