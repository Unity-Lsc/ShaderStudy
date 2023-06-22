//4方向颜色渐变
Shader "Master/2D/4Gradient" {

    Properties {

        [PerRenderData] _MainTex("Sprite Texture", 2D) = "white"{}
        _Color("Tint", Color) = (1,1,1,1)

        //4个点的颜色值
        _LeftTopColor("LeftTopColor", Color) = (1,1,1,1)
        _LeftBottomColor("LeftBottomColor", Color) = (1,1,1,1)
        _RightTopColor("RightTopColor", Color) = (1,1,1,1)
        _RightBottomColor("RightBottomColor", Color) = (1,1,1,1)

        [MaterialToggle] PixelSnap("Pixel Snap", float) = 0
    }

    SubShader {

        Tags {
            "Queue"= "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }

        Cull Off//关闭剔除
        Lighting Off
        ZWrite Off//关闭深度写入
        Blend One OneMinusSrcAlpha

        Pass {

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_PIXELSNAP_ON
            #include "UnityCG.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            fixed4 _Color;

            v2f vert(appdata_t i) {
                v2f o;
                o.vertex = UnityObjectToClipPos(i.vertex);
                o.texcoord = i.texcoord;
                o.color = i.color * _Color;
                #ifdef PIXELSNAP_ON
                    o.vertex = UnityPixelSnap(o.vertex);
                #endif
                return o;
            }

            sampler2D _MainTex;
            sampler2D _AlphaTex;
            fixed4 _LeftTopColor;
            fixed4 _LeftBottomColor;
            fixed4 _RightTopColor;
            fixed4 _RightBottomColor;
            float _AlphaSplitEnabled;

            fixed4 SampleSpriteTexture(float2 uv) {
                fixed4 color = tex2D(_MainTex, uv);
                
                fixed4 leftTop2RightTopColor = lerp(_LeftTopColor, _RightTopColor, uv.x);
                fixed4 leftBotton2RightBottomColor = lerp(_LeftBottomColor, _RightBottomColor, uv.x);
                fixed4 bottom2TopColor = lerp(leftBotton2RightBottomColor, leftTop2RightTopColor, uv.y);
                color = bottom2TopColor * color;

#if UNITY_TEXTURE_ALPHASPLIT_ALLOWED
                if(_AlphaSplitEnabled)
                    color.a = tex2D(_AlphaTex, uv).r;
#endif
                return color;
            }

            fixed4 frag(v2f i) : SV_Target {
                fixed4 c = SampleSpriteTexture(i.texcoord) * i.color;
                c.rgb *= c.a;
                return c;
            }

            ENDCG

        }

    }

}