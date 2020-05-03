using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Kiseki.SceneManagement {
    public class Portal : MonoBehaviour
    {
        enum DestinationIdentifier {
            A,B,C,D,E,F
        }
        [SerializeField] DestinationIdentifier destination;
        [SerializeField] Transform spawnPoint;
        [SerializeField] string sceneToLoad = "Rolent";
        // Start is called before the first frame update
        void Start()
        {
            
        }

        // Update is called once per frame
        void Update()
        {
            
        }

        private void OnTriggerEnter(Collider other) {
            if (other.tag == "Player") {
                Debug.Log("start teleport");
                StartCoroutine(Teleport());
            }
        }

        private IEnumerator Teleport() {
            DontDestroyOnLoad(this.gameObject);
            yield return SceneManager.LoadSceneAsync(sceneToLoad);
            Portal otherPortal = GetDestPortal();
            UpdatePlayerTransform(otherPortal);
            Destroy(this.gameObject);
        }

        private Portal GetDestPortal() {
            Portal[] portals = FindObjectsOfType<Portal>();
            foreach (Portal p in portals) {
                if (p == this || p.destination != this.destination) continue;
                return p;
            }
            return null;
        }

        private void UpdatePlayerTransform(Portal otherPortal) {
            Transform player = GameObject.FindWithTag("Player").transform;
            player.position = otherPortal.spawnPoint.position;
            player.rotation = otherPortal.spawnPoint.rotation;
        }
    }
}

