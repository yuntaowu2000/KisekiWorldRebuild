using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using StarterAssets;

public class Teleport : MonoBehaviour
{
    [SerializeField] Transform center;

    // Update is called once per frame
    void Update()
    {
        if (Keyboard.current.rKey.isPressed) {
            GameObject player = GameObject.FindWithTag("Player");
            // player.GetComponent<Collider>().enabled = false;
            player.GetComponent<ThirdPersonController>().enabled = false;
            player.transform.position = center.position;
            player.transform.rotation = center.rotation;
            // player.GetComponent<Collider>().enabled = true;
            player.GetComponent<ThirdPersonController>().enabled = true;
        }
    }
}
