﻿//Rotation matrices taken from Wikipedia page (https://en.wikipedia.org/wiki/Rotation_matrix)
Shader "Custom/VertexRotation"
{
    Properties
    {
        _Speed ("Speed", Float) = 1.0
        _HiClass ("Hello", Float) = 1.0
    }
    SubShader
    {
      

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            
            uniform float _Speed;
           
            
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;  
                float3 normal : NORMAL;
                float timeVal : Float;
            };
            
            
            float3x3 getRotationMatrixX (float theta) {
                
                float s = -sin(theta);
                float c = cos(theta);
                return float3x3(1, 0, 0, 0, c, -s, 0, s, c);
            }
            
            float3x3 getRotationMatrixY (float theta) {
                
                float s = -sin(theta);
                float c = cos(theta);
                return float3x3(c, 0, s, 0, 1, 0, -s, 0, c) ;
            }
            
            float3x3 getRotationMatrixZ (float theta) {
                
                float s = -sin(theta);
                float c = cos(theta);
                return float3x3(c, -s, 0, s, c, 0, 0, 0, 1);
            }
            
            
            v2f vert (appdata v)
            {
                v2f o;
                
                const float PI = 3.14159;
               
                float rad = fmod(_Time.y * _Speed, PI*2.0); //Loop counterclockwise
                
				// Get x rot matrix for rad radians
                float3x3 rotationMatrixX = getRotationMatrixX(rad);
                
				// rotate vertex position via previous rotation matrix
                float3 rotatedVertex = mul(rotationMatrixX, v.vertex.xyz);

				// Repeat the same process, but rotating along Y axis
				float3x3 rotationMatrixY = getRotationMatrixY(rad);
				rotatedVertex = mul(rotationMatrixY, rotatedVertex);
                
                float4 newPos = float4( rotatedVertex, 1.0 );
               
                o.vertex = UnityObjectToClipPos(newPos);
                o.normal = v.normal;
               
                return o;
            }

           
            float4 normalToColor (float3 n) {
                return float4( (normalize(n) + 1.0) / 2.0, 1.0) ;
            }
           

            fixed4 frag (v2f i) : SV_Target
            {
                return normalToColor(i.normal);
            }
            ENDCG
        }
    }
}
