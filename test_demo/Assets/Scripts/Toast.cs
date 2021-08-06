using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Toast : MonoBehaviour {
    private const string ANIMATOR_TRIGGER_SHOW = "show";
    private const string ANIMATOR_TRIGGER_HIDE = "hide";

    [SerializeField]
    private Animator _animator;
    [SerializeField]
    private Text _textContent;

	public void ShowToast(string content)
	{
        _textContent.text = content;
		_animator.SetTrigger(ANIMATOR_TRIGGER_SHOW);
        StartCoroutine(Co_AutoHide());
    }

	private void Hide()
	{
        _animator.SetTrigger(ANIMATOR_TRIGGER_HIDE);
    }

	private IEnumerator Co_AutoHide()
	{
        yield return new WaitForSeconds(2.0f);
        Hide();
    }
}
