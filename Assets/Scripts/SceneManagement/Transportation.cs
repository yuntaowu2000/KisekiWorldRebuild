using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityStandardAssets.Characters.ThirdPerson;
using UnityEngine.SceneManagement;
using UnityEngine.EventSystems;
using Kiseki.Core;

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
        [SerializeField] FollowCamera cameraControl;

        [SerializeField] Transform spawnPoint;
        void Start()
        {   
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
                if (Input.GetKeyDown(KeyCode.Escape) && transportationUI.enabled == true) 
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
                    other.GetComponent<Collider>().enabled = false;
                    other.GetComponent<ThirdPersonUserControl>().enabled = false;
                    Transportation otherPortal = GetDestStation();
                    UpdatePlayerTransform(otherPortal);
                    other.GetComponent<Collider>().enabled = true;
                    other.GetComponent<ThirdPersonUserControl>().enabled = true;
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
                Cursor.visible = !Cursor.visible;
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
                Transform player = GameObject.FindWithTag("Player").transform;
                player.position = other.spawnPoint.position;
                player.rotation = other.spawnPoint.rotation;
            }
        }

    }

}
