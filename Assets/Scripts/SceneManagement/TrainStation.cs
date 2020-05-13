using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using UnityEngine.EventSystems;
using Kiseki.Core;

namespace Kiseki.SceneManagement {
    public class TrainStation : MonoBehaviour
    {
        // Start is called before the first frame update
        string sceneToLoad;
        [SerializeField] Canvas trainstationUI;
        [SerializeField] FollowCamera cameraControl;

        [SerializeField] Transform spawnPoint;
        void Start()
        {
            trainstationUI.enabled = false;
        }

        // Update is called once per frame
        void Update()
        {
            if (Input.GetKeyDown(KeyCode.Escape) && trainstationUI.enabled == true) {
                trainstationUI.enabled = false;
            }
        }

        void OnTriggerEnter(Collider other) {
            if (other.tag == "Player") {
                Debug.Log("Player entered");
                SetUI();
                SetCameraStatus();
                StartCoroutine(Transport());
            }
        }

        private void SetUI() {
            //enable/disable the UI to select destination
            trainstationUI.enabled = !trainstationUI.enabled;
        }

        private void SetCameraStatus() {
            //set the camera/cursor to disabled if the camera/cursor is enabled
            //set the camera/cursor to enabled if the camera/cursor is disabled
            cameraControl.enabled = !cameraControl.enabled;
            Cursor.visible = !Cursor.visible;
        }
        
        public void SetDestination() {
            //get the name of the button and set it as destination scene
            sceneToLoad = EventSystem.current.currentSelectedGameObject.name;
        }

        private IEnumerator Transport() {
            DontDestroyOnLoad(this.gameObject);
            while (sceneToLoad == null) {
                yield return null;
            }
            Debug.Log(sceneToLoad);
            yield return SceneManager.LoadSceneAsync(sceneToLoad);
            TrainStation otherStation = GetDestStation();
            UpdatePlayerTransform(otherStation);
            Destroy(this.gameObject);
        }

        private TrainStation GetDestStation() {
            TrainStation[] portals = FindObjectsOfType<TrainStation>();
            foreach (TrainStation p in portals) {
                if (p == this) continue;
                return p;
            }
            return null;
        }

        private void UpdatePlayerTransform(TrainStation otherStation) {
            if (otherStation != null) {
                Transform player = GameObject.FindWithTag("Player").transform;
                player.position = otherStation.spawnPoint.position;
                player.rotation = otherStation.spawnPoint.rotation;
            }
        }

    }

}
