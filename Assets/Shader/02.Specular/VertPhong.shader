Shader "Specular/VertPhong" {
    
    Properties {
        _Diffuse("Diffuse", Color) = (1,1,1,1)
        _Specular("Specular", Color) = (1,1,1,1)
        _Gloss("Gloss", Range(8.0,256)) = 20
    }

    SubShader {

        Pass {
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            //#include "UnityCG.cginc"

            fixed4 _Diffuse;
            fixed4 _Specular;
            half _Gloss;

            struct av2 {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR;
            };

            v2f vert(av2 v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //获取环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //计算世界空间下的法线
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                //获得光照的方向
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                //计算漫反射
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
                //计算反射方向(公式中的r)
                fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
                //计算照相机的方向(公式中的v)
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
                //计算高光反射
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);

                o.color = ambient + diffuse + specular;
                return o;

            }

            fixed4 frag(v2f i) :SV_Target {
                return fixed4(i.color, 1);
            }


            ENDCG

        }

    }

    Fallback "Specular"

}
