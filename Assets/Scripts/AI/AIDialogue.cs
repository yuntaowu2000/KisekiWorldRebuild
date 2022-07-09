using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using TMPro;
using StarterAssets;

public class AIDialogue : MonoBehaviour, IAction
{
    private const string k_PlayerTag = "Player";
    [SerializeField] Canvas m_WorldCanvas = null;
    [SerializeField] Canvas m_DialogCanvas = null;
    [SerializeField] TMP_Text m_CharacterNameText = null;
    [SerializeField] TMP_Text m_DialogText = null;
    private Transform m_MainCameraTransform = null;
    [SerializeField] Dialogue m_Dialogue = null;
    private DialogueNode m_CurrentNode = null;
    private bool m_DialogueStarted = false;
    private bool m_InButtonPressCoolDown = false;
    private const float k_CoolDownTime = 2f;
    private float m_TimeElapsed = 0f;
    private ActionScheduler m_ActionScheduler = null;
    private ThirdPersonController m_PlayerController = null;
    // Start is called before the first frame update
    void Start()
    {
        if (m_Dialogue == null) 
            this.gameObject.SetActive(false);
        m_MainCameraTransform = Camera.main.transform;
        m_WorldCanvas.renderMode = RenderMode.WorldSpace;
        m_WorldCanvas.gameObject.SetActive(false);
        m_DialogCanvas.gameObject.SetActive(false);
        m_ActionScheduler = GetComponent<ActionScheduler>();
    }

    // Update is called once per frame
    void Update()
    {
        if (!m_DialogueStarted) return;
        if (!m_InButtonPressCoolDown && Keyboard.current.enterKey.isPressed)
        {
            UpdateUI();
            m_InButtonPressCoolDown = true;
            StartCoroutine(CoolDown());
        }
    }

    IEnumerator CoolDown()
    {
        while (m_TimeElapsed < k_CoolDownTime) 
        {
            m_TimeElapsed += Time.deltaTime;
            yield return null;
        }
        m_TimeElapsed = 0f;
        m_InButtonPressCoolDown = false;
    }

    void LateUpdate()
    {
        m_WorldCanvas.transform.forward = m_MainCameraTransform.forward;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (m_Dialogue == null) return;
        if (other.tag != k_PlayerTag) return;
        m_PlayerController = other.GetComponent<ThirdPersonController>();
        m_WorldCanvas.gameObject.SetActive(true);
    }

    private void OnTriggerExit(Collider other)
    {
        if (m_Dialogue == null) return;
        if (other.tag != k_PlayerTag) return;
        m_WorldCanvas.gameObject.SetActive(false);

        m_PlayerController.CanMove = true;
        m_PlayerController = null;
    }

    private void OnTriggerStay(Collider other)
    {
        if (m_Dialogue == null) return;
        if (other.tag != k_PlayerTag) return;
        if (Keyboard.current.fKey.isPressed)
        {
            StartDialog();
        }
    }

    private void StartDialog()
    {
        Debug.Log("Dialog started");
        m_PlayerController.CanMove = false;
        m_ActionScheduler.StartAction(this);
        m_CurrentNode = m_Dialogue.GetRootNode();
        UpdateUI();
        m_DialogCanvas.gameObject.SetActive(true);
        m_WorldCanvas.gameObject.SetActive(false);
        m_DialogueStarted = true;
    }

    private void UpdateUI()
    {
        if (m_CurrentNode != null)
        {
            m_CharacterNameText.text = m_CurrentNode.GetSpeaker();
            m_DialogText.text = m_CurrentNode.GetText();
            m_CurrentNode = m_Dialogue.GetNode(m_CurrentNode.GetChild());
        }
        else
        {
            m_ActionScheduler.StartAction(null);
            Cancel();
        }
    }
    
    public void Cancel()
    {
        m_DialogueStarted = false;
        m_WorldCanvas.gameObject.SetActive(true);
        m_DialogCanvas.gameObject.SetActive(false);
    }
}
