using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Video;

public class VideoPlay : MonoBehaviour
{
     //设置VideoPlayer、RawImage和当前播放视频索引参数
    private VideoPlayer videoPlayer;
    private RawImage rawImage; 
    private int currentClipIndex;
    //设置相关文本和按钮参数以及视频列表
   
    //public Button button_Close;
    public VideoClip[] videoClips;

    void Start()
    {
        //获取VideoPlayer和RawImage组件，以及初始化当前视频索引
        videoPlayer = this.GetComponent<VideoPlayer>();
        rawImage = this.GetComponent<RawImage>();
        currentClipIndex = 0;
        //设置相关按钮监听事件
        //button_Close.onClick.AddListener(OnCloseVideo);
        videoPlayer.clip = videoClips[currentClipIndex];
        videoPlayer.loopPointReached += EndReached;
    }

    void EndReached(UnityEngine.Video.VideoPlayer vp)
    {
        //vp.playbackSpeed = vp.playbackSpeed / 10.0F;
        // vp.Stop();
        currentClipIndex += 1;
         Debug.Log("EndReached currentClipIndex:"+currentClipIndex);
        if (currentClipIndex == videoClips.Length)
        {
            return;
        }
        vp.clip = videoClips[currentClipIndex];
        //vp.Play();
    }

    // Update is called once per frame
    void Update()
    {
        //if(videoPlayer.isPlaying == false){
        //    Debug.Log("videoPlayer over");
        //}
        //没有视频则返回，不播放
        if (videoPlayer.texture == null)
        {
            return;
        }
        //渲染视频到UGUI上
        rawImage.texture = videoPlayer.texture;
        /*if(videoPlayer.isPlaying == false)
        {
            currentClipIndex +=1 ;
            currentClipIndex = currentClipIndex % videoClips.Length;
            videoPlayer.clip = videoClips[currentClipIndex];
        }*/
    }
}
