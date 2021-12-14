using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.InputSystem;

public class MapSelector : MonoBehaviour
{
    // Update is called once per frame
    void Update()
    {
        if (Keyboard.current.digit1Key.isPressed) {
            SceneManager.LoadScene("Grancel");
        } else if (Keyboard.current.digit2Key.isPressed) {
            SceneManager.LoadScene("NewCrossbell");
        } else if (Keyboard.current.digit3Key.isPressed) {
            SceneManager.LoadScene("Heimdallr");
        }
    }
}
