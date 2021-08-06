using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowToastButton : MonoBehaviour {
    [SerializeField]
    private Toast _toast;

	public void OnClick()
	{
        _toast.ShowToast("Hello World!");
    }
}