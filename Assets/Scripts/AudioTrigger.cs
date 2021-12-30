using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioTrigger : MonoBehaviour
{
    [SerializeField] AudioClip audioClip = null;
    AudioSource audioSource = null;

    private float fadeSpeed = 0.5f;

    private void Start() {
        audioSource = FindObjectOfType<AudioSource>();
    }

    IEnumerator PlayAudio() {
        if (audioSource.clip != null) {
            while (!float.Equals(audioSource.volume, 0.0f)) {
                audioSource.volume -= fadeSpeed * Time.deltaTime;
                yield return null;
            }
        }
        audioSource.Stop();
        audioSource.volume = 1.0f;
        audioSource.clip = audioClip;
        audioSource.Play();
    }

    private void OnTriggerEnter(Collider other) {
        if (other.gameObject.tag != "Player" 
        || audioClip == null
        || (audioSource.clip != null && audioSource.clip.name == audioClip.name)) return;

        StartCoroutine(PlayAudio());
    }
}
