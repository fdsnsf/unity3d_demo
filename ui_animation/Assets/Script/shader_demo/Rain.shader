Shader "Unlit/Rain"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("_NoiseTex", 2D) = "white" {}
		_LoopNum ("_LoopNum", Vector) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
        LOD 100

        Pass
        {
            ZWrite Off
	        Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #define HASHSCALE1 .1031
            #define PI2 6.28318530718

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float Hash12(float2 p)
            {
	            float3 p3  = frac(float3(p.xyx) * HASHSCALE1);
                p3 += dot(p3, p3.yzx + 19.19);
                return frac((p3.x + p3.y) * p3.z);
            }
            fixed2 Rains(fixed2 uv, fixed seed, fixed m) {
				float period = 5;//雨滴在格子中循环的周期
				float2 retVal  = float2(0.0,0.0);
				float aspectRatio = 4.0;//雨滴的宽高比 
				float tileNum = 5;//平铺数量
				float ySpd = 0.1;
                float ftime = _Time.x;
				uv.y += ftime * 0.0618;//加点y轴移动 =PI2 /period *0.45*0.55 / tileNum
				uv *= fixed2(tileNum * aspectRatio,tileNum);//栅格化uv
				//加点基于格子的随机值
				fixed idRand = Hash12(floor(uv));
				uv = frac(uv); 
				float2 gridUV = uv;
				uv -=0.5;//(-0.5,0.5)
				//此处uv值范围为(-0.5,0.5)
				//*0.45的原因 是让水滴在格子内游走刚好让上下两个格子之间游走，
				//从而在视觉上格子之间的水滴是可以碰撞的，从而克服格子的空间的分割感
				float t = ftime * PI2 /period;
				t += idRand * PI2;//添加Y随机值
				
				uv.y += sin(t+sin(t+sin(t)*0.55))*0.45;
				uv.y *= aspectRatio;
				//添加x轴随机偏移
				uv.x += (idRand-.5)*.6;

				float r = length(uv);
				r = smoothstep(0.2,0.1,r);
		
				//添加尾迹
				float tailTileNum = 3.0;
				float2 tailUV =uv *  float2(1.0,tailTileNum);
				tailUV.y = frac(tailUV.y) - 0.5;
				tailUV.x *= tailTileNum;
				//在雨滴上面总共有
				float rtail = length(tailUV);
				//尾迹塑形
				rtail *= uv.y * 1.5;
				rtail = smoothstep(0.2,0.1,rtail);
				//切除掉大雨滴下面的部分
				rtail *= smoothstep(0.3,0.5,uv.y);
				retVal = float2(rtail*tailUV+r*uv);
				return retVal;
			}
			
			float3 ProcessFrag(float2 _uv){
				float baseOffset = 0.1;
				float2 uv = _uv;
				uv *= float2(_ScreenParams.x/_ScreenParams.y,1.0);
				float x = (sin(_Time.y*.1)*.5+.5)*.3;
				x =x*x;
				x+= baseOffset;
				float s = sin(x);
				float c = cos(x);
				float2x2 rot = float2x2(c, -s, s, c);
				uv = mul(rot,uv);
				float moveSpd = 0.1;
				float2 rainUV = float2(0.,0.); 
				rainUV += Rains(uv,152.12,moveSpd);
				rainUV += Rains(uv*2.32, 25.23, moveSpd);
				fixed4 finalColor = tex2D(_MainTex, _uv + rainUV*2.);
				return finalColor.xyz;
			} 

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return float4(ProcessFrag(i.uv),1.0);
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
