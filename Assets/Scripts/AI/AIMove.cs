using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class AIMove : MonoBehaviour, IAction
{
    NavMeshAgent navMeshAgent;
    [SerializeField] Transform target;
    [SerializeField] float maxSpeed = 6f;
    [SerializeField] float maxNavPathLength = 40f;
    [SerializeField] float followRange = 1f;
    
    private void Awake() {
        navMeshAgent = GetComponent<NavMeshAgent>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Vector3.Distance(transform.position, target.position) > followRange) {
            MoveTo(target.transform.position, 1f);
            // Debug.Log(string.Format("out of range {0}", Vector3.Distance(transform.position, target.position)));
        } else {
            Cancel();
            transform.LookAt(target.transform);
            // Debug.Log(string.Format("in range {0}", Vector3.Distance(transform.position, target.position)));
        }

        UpdateAnimator();
    }
    public void StartMoveAction(Vector3 destination, float speedFraction)
    {
        GetComponent<ActionScheduler>().StartAction(this);
        MoveTo(destination, speedFraction);
    }

    public bool CanMoveTo(Vector3 destination)
    {
        NavMeshPath path = new NavMeshPath();
        bool hasPath = NavMesh.CalculatePath(transform.position, destination, NavMesh.AllAreas, path);
        if (!hasPath) return false;
        if (path.status != NavMeshPathStatus.PathComplete) return false;
        if (GetPathLength(path) > maxNavPathLength) return false;

        return true;
    }

    public void MoveTo(Vector3 destination, float speedFraction)
    {
        navMeshAgent.destination = destination;
        navMeshAgent.speed = maxSpeed * Mathf.Clamp01(speedFraction);
        navMeshAgent.isStopped = false;
    }

    public void Cancel()
    {
        navMeshAgent.isStopped = true;
    }

    private void UpdateAnimator()
    {
        Vector3 velocity = navMeshAgent.velocity;
        Vector3 localVelocity = transform.InverseTransformDirection(velocity);
        float speed = localVelocity.z;
        GetComponentInChildren<Animator>().SetFloat("Speed", speed);
        GetComponentInChildren<Animator>().SetFloat("MotionSpeed", 1.0f);
    }

    private float GetPathLength(NavMeshPath path)
    {
        float total = 0;
        if (path.corners.Length < 2) return total;
        for (int i = 0; i < path.corners.Length - 1; i++)
        {
            total += Vector3.Distance(path.corners[i], path.corners[i + 1]);
        }

        return total;
    }
}
