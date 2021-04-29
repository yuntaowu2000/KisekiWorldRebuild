using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MapSelector : MonoBehaviour
{
    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1)) {
            SceneManager.LoadScene("Grancel");
        } else if (Input.GetKeyDown(KeyCode.Alpha2)) {
            SceneManager.LoadScene("Crossbell");
        } else if (Input.GetKeyDown(KeyCode.Alpha3)) {
            SceneManager.LoadScene("Heimdallr");
        }
    }
}
