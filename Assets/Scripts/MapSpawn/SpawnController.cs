using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnController : MonoBehaviour
{
    [SerializeField] float maxDistance = 100f;
    [SerializeField] Transform centerPosition;
    ObjectSpawn[] spawners;
    Transform playerTransform;
    bool spawned = false;
    // Start is called before the first frame update
    void Start()
    {
        spawners = GetComponentsInChildren<ObjectSpawn>();
        playerTransform = GameObject.FindWithTag("Player").transform;
    }

    // Update is called once per frame
    void Update()
    {
        float distance = Vector3.Distance(playerTransform.position, centerPosition.position);
        if (!spawned && distance <= maxDistance) {
            foreach (ObjectSpawn sp in spawners) {
                sp.Spawn();
            }
            spawned = true;
            return;
        }

        if (spawned && distance > maxDistance) {
            foreach (ObjectSpawn sp in spawners) {
                sp.DestroyChild();
            }
            spawned = false;
            return;
        }
    }
}
