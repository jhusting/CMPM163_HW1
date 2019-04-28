Shader "Custom/Texture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Shininess("Shininess", Float) = 10 //Shininess
		_SpecColor("Specular Color", Color) = (1, 1, 1, 1) //Specular highlights color
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode" = "ForwardAdd" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
    
            #include "UnityCG.cginc"

			uniform float4 _LightColor0; //From UnityCG
			uniform float4 _SpecColor;
			uniform float _Shininess;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;

            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float3 vertexInWorldCoords : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
				o.normal = v.normal; //Normal 

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float3 P = i.vertexInWorldCoords.xyz;
				float3 N = normalize(i.normal);
				float3 V = normalize(_WorldSpaceCameraPos - P);
				float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
				float3 H = normalize(L + V);

				float3 Kd = tex2D(_MainTex, i.uv).rgb;
				float3 Ka = UNITY_LIGHTMODEL_AMBIENT.rgb; //Ambient light
				float3 Ks = _SpecColor.rgb; //Color of specular highlighting
				float3 Kl = _LightColor0.rgb; //Color of light

				//AMBIENT LIGHT 
				float3 ambient = Ka;

				//DIFFUSE LIGHT
				float diffuseVal = max(dot(N, L), 0);
				float3 diffuse = Kd * Kl * diffuseVal;

				//SPECULAR LIGHT
				float specularVal = pow(max(dot(N,H), 0), _Shininess);

				if (diffuseVal <= 0) 
				{
					specularVal = 0;
				}

				float3 specular = Ks * Kl * specularVal;

				//FINAL COLOR OF FRAGMENT
				return float4(ambient + diffuse + specular, 1.0);
            }
            ENDCG
        }
    }
}
