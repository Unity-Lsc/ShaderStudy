Shader "Master/PerVertexLevel" {
	
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
				//SV_POSITION���������洢���嶥������Ļ�����ϵ�λ��(�ü��ռ��еĶ�������)
				float4 pos : SV_POSITION;
				//Color����Shader,color�洢���Ƕ�����ɫ
				float3 color : Color;
			};

			fixed4 _Diffuse;

			v2f vert (appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//o.color = fixed3(0.0,1.0,0.0);//ֱ������Ϊ��ɫ
				o.color = _Diffuse;
				//������
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				//���淨��  ����ʹ�õ�����ת�þ���
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				//���㵽��Դ�ķ��� _WorldSpaceLightPos0��ʾ��Դ�ķ���(ֻ��һ����Դ�ҹ�Դ������ƽ�й�)
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

				//���ߺ͹�Դ���������ֵ(���ڴ˶����ǿ��)
				fixed NdotL = saturate(dot(worldNormal,worldLight));
				if(NdotL > 0.9) {
					NdotL = 1;
				} else if(NdotL > 0.5) {
					NdotL = 0.6;
				} else {
					NdotL = 0;
				}
				//_LightColor0��ʾ��Pass����Ĺ�Դ��ɫ��ǿ����Ϣ
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * NdotL;
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