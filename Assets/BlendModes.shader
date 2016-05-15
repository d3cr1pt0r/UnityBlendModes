Shader "FX/Glass/Stained BumpDistort (no grab)" {
	Properties {
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
	}

	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Opaque" }
		Pass {
			Name "BASE"
				
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _NORMAL _ADDITIVE _MULTIPLY _DIVIDE _SUBTRACT _OVERLAY _DARKEN _LIGHTEN _DIFFERENCE _HARDLIGHT _SCREEN _COLORDODGE _COLORBURN _LINEARBURN
			#include "UnityCG.cginc"
			#include "BlendModes.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				fixed2 texcoord: TEXCOORD0;
			};

			struct v2f {
				float4 vertex : POSITION;
				fixed4 uvgrab : TEXCOORD0;
				fixed2 uvmain : TEXCOORD1;
			};

			sampler2D _GrabBlendTexture;
			sampler2D _MainTex;
			fixed4 _MainTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				#if UNITY_UV_STARTS_AT_TOP
				fixed scale = -1.0;
				#else
				fixed scale = 1.0;
				#endif
				o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
				o.uvgrab.zw = o.vertex.zw;
				o.uvmain = TRANSFORM_TEX( v.texcoord, _MainTex );
				return o;
			}

			half4 frag (v2f i) : SV_Target
			{
				fixed4 color_front = tex2D(_MainTex, i.uvmain);
				fixed4 color_back = tex2Dproj (_GrabBlendTexture, UNITY_PROJ_COORD(i.uvgrab));

				#ifdef _ADDITIVE
					return additive(color_back, color_front);
				#endif

				#ifdef _MULTIPLY
					return multiply(color_back, color_front);
				#endif

				#ifdef _DIVIDE
					return divide(color_back, color_front);
				#endif

				#ifdef _SUBTRACT
					return subtract(color_back, color_front);
				#endif

				#ifdef _OVERLAY
					return overlay(color_back, color_front);
				#endif

				#ifdef _DARKEN
					return darken(color_back, color_front);
				#endif

				#ifdef _LIGHTEN
					return lighten(color_back, color_front);
				#endif

				#ifdef _DIFFERENCE
					return difference(color_back, color_front);
				#endif

				#ifdef _HARDLIGHT
					return hard_light(color_back, color_front);
				#endif

				#ifdef _SCREEN
					return screen(color_back, color_front);
				#endif

				#ifdef _COLORDODGE
					return color_dodge(color_back, color_front);
				#endif

				#ifdef _COLORBURN
					return color_burn(color_back, color_front);
				#endif

				#ifdef _LINEARBURN
					return linear_burn(color_back, color_front);
				#endif

				return color_front;
			}
			ENDCG
		}
	}
}
