Shader "Master/2D/Gray" {

    Properties {

        [PerRenderData] _MainTex("Sprite Texture", 2D) = "white"{}
        _Color("Tint", Color) = (1,1,1,1)
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
            float _AlphaSplitEnabled;

            fixed4 SampleSpriteTexture(float2 uv) {
                fixed4 color = tex2D(_MainTex, uv);
                color.rgb = dot(color.rgb, fixed3(0.299,0.587, 0.114));
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