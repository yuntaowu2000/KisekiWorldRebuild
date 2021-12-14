using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using StarterAssets;
using UnityEngine.SceneManagement;
using UnityEngine.EventSystems;
using Kiseki.Core;
using UnityEngine.InputSystem;

namespace Kiseki.SceneManagement {
    public class Transportation : MonoBehaviour
    {
        // Start is called before the first frame update
        enum Type {Airport, TrainStation, Portal, InScenePortal};
        enum DestinationIdentifier {A, B, C, D, E, F, G};

        [SerializeField] Type type;
        [SerializeField] DestinationIdentifier destinationIdentifier;
        [SerializeField] string sceneToLoad;
        [SerializeField] Canvas transportationUI;
        ThirdPersonController cameraControl;

        [SerializeField] Transform spawnPoint;
        [SerializeField] GameObject playerPrefab;
        void Start()
        {   
            if (cameraControl == null) {
                cameraControl = FindObjectOfType<ThirdPersonController>();
            }
            if (transportationUI != null) 
            {
                transportationUI.enabled = false;
            }
        }

        // Update is called once per frame
        void Update()
        {
            if (transportationUI != null) 
            {
                if (Keyboard.current.escapeKey.isPressed && transportationUI.enabled == true) 
                {
                    transportationUI.enabled = false;
                }
            }

        }

        void OnTriggerEnter(Collider other) {
            if (other.tag == "Player") {
                Debug.Log("Player entered");
                SetUI();
                SetCameraStatus();
                if (type == Type.InScenePortal)
                {
                    other.GetComponentInChildren<Collider>().enabled = false;
                    other.GetComponentInChildren<ThirdPersonController>().enabled = false;
                    Transportation otherPortal = GetDestStation();
                    UpdatePlayerTransform(otherPortal);
                    other.GetComponentInChildren<Collider>().enabled = true;
                    other.GetComponentInChildren<ThirdPersonController>().enabled = true;
                } else {
                    StartCoroutine(Transport());
                }

            }
        }

        private void SetUI() {
            //enable/disable the UI to select destination
            if (transportationUI != null) 
            {
                transportationUI.enabled = !transportationUI.enabled;
            }
        }

        private void SetCameraStatus() {
            //set the camera/cursor to disabled if the camera/cursor is enabled
            //set the camera/cursor to enabled if the camera/cursor is disabled
            if (cameraControl != null) 
            {
                cameraControl.enabled = !cameraControl.enabled;
                if (Cursor.lockState == CursorLockMode.Locked) {
                    Cursor.lockState = CursorLockMode.None;
                } else {
                    Cursor.lockState = CursorLockMode.Locked;
                }
            }
        }
        
        public void SetDestination() {
            //get the name of the button and set it as destination scene
            sceneToLoad = EventSystem.current.currentSelectedGameObject.name;
        }

        private IEnumerator Transport() {
            DontDestroyOnLoad(this.gameObject);
            while (sceneToLoad == null || sceneToLoad == "") {
                yield return null;
            }
            if (sceneToLoad == "Crossbell") sceneToLoad = "NewCrossbell";
            Debug.Log(sceneToLoad);
            yield return SceneManager.LoadSceneAsync(sceneToLoad);
            Transportation other = GetDestStation();
            UpdatePlayerTransform(other);
            Destroy(this.gameObject);
        }

        private Transportation GetDestStation() {
            Transportation[] portals = FindObjectsOfType<Transportation>();
            foreach (Transportation p in portals) {
                if (p.gameObject == this.gameObject 
                || p.type != this.type 
                || p.destinationIdentifier != this.destinationIdentifier) continue;
                
                return p;
            }
            return null;
        }

        private void UpdatePlayerTransform(Transportation other) {
            if (other != null) {
                GameObject player = GameObject.FindWithTag("Player");
                if (player == null) {
                    player = Instantiate(playerPrefab, other.spawnPoint.position, other.spawnPoint.rotation);
                } else {
                    player.transform.position = other.spawnPoint.position;
                    player.transform.rotation = other.spawnPoint.rotation;
                }
            }
        }

    }

}
