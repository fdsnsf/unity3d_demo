Shader "Unlit/Demo"
{
    Properties
    {
        _Color(" Color", Color) = (1,1,1,1)
        _Value(" Value", Float) = 1
        _MainTex(" Main Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            #include "UnityCG.cginc"

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 _Color;
            float _Value;
            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;
                //return float4(uv, 0, 1);

                float4 texColor = tex2D(_MainTex, uv);
                float4 res = float4(0,0,0,0);

                //float val = pow(uv.y, 2);
                //res = val;

                /*uv -= 0.5;
                float len = length(uv);
                len = 1 - length(uv) * 2;
                //len = pow(len, _Value);
                len = step(0.001, len);
                //len = smoothstep(0, 0.3, len);
                clip(len - 0.1); 

                float deg = atan2(uv.x, -uv.y) / UNITY_TWO_PI + 0.5;
                deg = 1 - deg;
                //return deg;
                float mask = smoothstep(_Value, _Value + 0.001, deg);
                //mask = 1 - (0.3 + mask * 0.7);
                mask = 0.3 + (1 - mask) * 0.7;
                //res = mask;
                res = texColor * mask;*/

                //res.xy = uv;

                uv -= 0.5;
                float len = 1 - length(uv) * 2 ;
                float deg = atan2(uv.x, -uv.y) / UNITY_TWO_PI + 0.5;
                deg += _Time.x * 3;
                //return deg;
                float sinVal = sin(deg * UNITY_TWO_PI * 5) * 0.49 + 0.5;    
                //res = sinVal;
                //return sinVal;
                len = smoothstep(0.07, 0.8, len);
                clip(len - sinVal);

                //res = 1;
                res = texColor;
                return res;
            }
            ENDCG
        }
    }
}
