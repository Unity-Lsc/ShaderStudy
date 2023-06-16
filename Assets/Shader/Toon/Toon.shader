Shader "Master/Toon" {
	
	//Properties��������
	//1.����ͨ��C#�ű�����ֵ
	//2.����ͨ���������ʵ�Inspector����ֵ
	Properties {
		
		//_MainTex("Texture",2D) = "white" {}
		_Diffuse("Diffuse", Color) = (1,1,1,1)

	}

	//SubShader����ƽ̨ѡ��SubShader,������е�SubShader��������,һ�����һ��Fallback(Ĭ��)
	SubShader {
	
		//Pass ����GameObject�������һ����Ⱦ
		Pass {

			Tags {"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			//�Ѷ�����ɫ�������ݴ��ݸ�ƬԪ��ɫ��
			struct v2f {
				float4 pos : SV_POSITION;
				float3 color : Color;
			};

			float4 _Diffuse;

			v2f vert (appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLight));
				o.color = ambient + diffuse;
				return o;
			}

			//ƬԪ(����)��ɫ��
			//�����ؼ�����ɫ,�������Ļ�ϻ���֡������
			//SV_Target�� ��ʾ���Shader���ڵ�����(SV��SystemValue ϵͳֵ����˼)
			//SV_Target������ؼ���,����Shader���ݵ���Դ��ȥ��
			float4 frag(v2f i) : SV_Target {
				
				// fixed4 outputColor = fixed4(i.color,1.0);
				// outputColor.r = 0;
				// return outputColor;

				return fixed4(i.color,1.0);
			
			}

			ENDCG

		}
	
	}

}