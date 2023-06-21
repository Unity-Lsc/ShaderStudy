Shader "Master/ToonHair" {
    
    Properties {

        _MainTex("Texture", 2D) = "white"{}

    }

    SubShader {

        //SubShader 使用 Tags 来告诉引擎如何以及何时将其渲染。
        Tags {"RenderType" = "Opaque"}
        LOD 100

        Pass {

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)//生成了fogCoord变量
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = (v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                //TRANSFORM_TEX 把Tilling和Offset作用在uv上
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //从顶点中输出雾效数据
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                //纹理采样
                fixed4 col = tex2D(_MainTex, i.uv);
                //将雾效应用到颜色上
                UNITY_APPLY_FOG(i.fogCoord, col);

                return col;

            }



            ENDCG

        }

    }

}
