using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Kiseki.Core {
    public class FollowCamera : MonoBehaviour
    {
        // Start is called before the first frame update
        [SerializeField] GameObject target;
        [Tooltip("degree to rotate the camera")][SerializeField] int degree = 10;
        [SerializeField] float maxFOV = 60f;
        [SerializeField] float minFOV = 25f;
        [SerializeField] float maxYangle = 45f;
        [SerializeField] float minYangle = -10f;
        [SerializeField] float sensitivity = 10f;
        float currentX = 0.0f;
        float currentY = 0.0f;

        void Start()
        {
            Cursor.visible = false;
            Camera.main.fieldOfView = 40f;
        }

        // // Update is called once per frame
        // private void Update()
        // {   
        //     Cursor.visible = false;
        //     currentX += Input.GetAxis("Mouse X") * degree;
        //     currentY += Input.GetAxis("Mouse Y") * degree;
        //     currentY = Mathf.Clamp(currentY, minYangle, maxYangle);
        // }
        // void LateUpdate()
        // {
        //     transform.position = target.transform.position;
        //     RotateCamera();
        //     ZoomCamera();
        // }

        // private void RotateCamera()
        // {
        //     transform.rotation = Quaternion.Euler(currentY, currentX, 0);
        // }

        // private void ZoomCamera()
        // {
        //     float fov = Camera.main.fieldOfView - Input.GetAxis("Mouse ScrollWheel") * sensitivity;
        //     Camera.main.fieldOfView = Mathf.Clamp(fov, minFOV, maxFOV);
        // }

    }
}
