using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MainPlayer : MonoBehaviour
{
   
    public InputField inputField;
    public static UIData data = new UIData();
    public AudioSource audioPlay;

    void Awake() {
         //inputField=this.GetComponent<InputField> ();
        audioPlay = GameObject.Find("AudioSource").GetComponent<AudioSource>();
        audioPlay.playOnAwake = false; 
        //AudioClip clip = Resources.Load<AudioClip>("/Users/sf/mp3/萤之光.mp3");
        //audioPlay.clip = clip;
    }

    // Start is called before the first frame update
    void Start()
    {
         //Debug.Log("I am alive!");
         //Debug.Log("I am alive and my name is " + myName);
        inputField = GameObject.Find("Input").GetComponent<InputField>();
        inputField.onEndEdit.AddListener(InputEnd);
        GameObject.Find("Dropdown").GetComponent<Dropdown>().onValueChanged.AddListener(DropdownClick); 

        GameObject.Find("play").GetComponent<Button>().onClick.AddListener(PlayClick);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void OutputClick(){
        Debug.Log("OutputClick!");
        output();
    }

    public void ToggleGroup_a(bool click){
        data.toggle="a";
        output();
        //Debug.Log("ToggleGroup_a click:a");
    }

    public void ToggleGroup_b(bool click){
        data.toggle="b";
        output();
        //Debug.Log("ToggleGroup_b click:b");
    }

    public void InputEnd(string inn){
        //input=inn;
        data.input=inn;
        Debug.Log("input click:"+inn);
        output();
    }

    public void DropdownClick(int value){
       data.dropDown=value;
       //Debug.Log("DropdownClick:"+value);
    }

    public void PlayClick(){
        Debug.Log("play:"+data.dropDown);
        audioPlay.Stop();
       switch (data.dropDown) {
           case 0:
                break;
           case 1:
                audioPlay.Play();
                break;

       }
    }

    private void output(){
        data.msg="";
        if (data.toggle!="") {
            data.msg+="单选框选择了"+data.toggle;
        }
        if (data.input.Length>0){
            data.msg+=" 输入框输入--"+data.input;
        }
        
        //Debug.Log(data.msg);
        GameObject.Find("output").GetComponent<Text>().text="<color=#0000ff><size=30>输出：</size></color>"+data.msg;
    }

    public void OnExitButtonClick()
    {
        Debug.Log("end");
        Application.Quit();
    }
}

public class UIData {
    public string input="";
    public string myName="";
    public string msg="";
    public string toggle="";
    public int dropDown=0;
}
