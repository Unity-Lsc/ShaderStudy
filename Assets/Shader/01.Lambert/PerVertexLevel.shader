Shader "Master/PerVertexLevel" {
	
	//Properties定义属性
	//1.可以通过C#脚本设置值
	//2.可以通过所属材质的Inspector设置值
	Properties {
		
		//_MainTex("Texture",2D) = "white" {}
		_Diffuse("Diffuse", Color) = (1,1,1,1)

	}

	//SubShader根据平台选择SubShader,如果所有的SubShader都不满足,一般会有一个Fallback(默认)
	SubShader {
	
		//Pass 控制GameObject几何体的一次渲染
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

			//把顶点着色器的数据传递给片元着色器
			struct v2f {
				//SV_POSITION描述变量存储物体顶点在屏幕坐标上的位置(裁剪空间中的顶点坐标)
				float4 pos : SV_POSITION;
				//Color告诉Shader,color存储的是顶点颜色
				float3 color : Color;
			};

			fixed4 _Diffuse;

			v2f vert (appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//o.color = fixed3(0.0,1.0,0.0);//直接设置为绿色
				o.color = _Diffuse;
				//环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				//表面法线  这里使用的是逆转置矩阵
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				//顶点到光源的方向 _WorldSpaceLightPos0表示光源的方向(只有一个光源且光源类型是平行光)
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

				//法线和光源方向的余弦值(光在此顶点的强度)
				fixed NdotL = saturate(dot(worldNormal,worldLight));
				if(NdotL > 0.9) {
					NdotL = 1;
				} else if(NdotL > 0.5) {
					NdotL = 0.6;
				} else {
					NdotL = 0;
				}
				//_LightColor0表示该Pass处理的光源颜色和强度信息
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * NdotL;
				o.color = ambient + diffuse;
				return o;
			}

			//片元(像素)着色器
			//逐像素计算颜色,输出到屏幕上或者帧缓冲里
			//SV_Target是 表示这个Shader所在的物体(SV是SystemValue 系统值的意思)
			//SV_Target是语义关键字,告诉Shader数据的来源和去向
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