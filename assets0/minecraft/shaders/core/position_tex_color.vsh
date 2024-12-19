#version 150

#define HEIGHT 1080

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

uniform vec2 ScreenSize;
uniform sampler2D Sampler0;

out vec2 texCoord0;
out vec4 vertexColor;
out vec2 Pos;
flat out float isGui;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    const vec2[4] corners = vec2[4](vec2(-1), vec2(-1, 1), vec2(1), vec2(1, -1));

    Pos.x = atan(ModelViewMat[0][2], ModelViewMat[0][0]);
    Pos.y = -1999;

    vertexColor = Color;
    isGui = 0;
    if (texelFetch(Sampler0, ivec2(0), 0).a == 254 / 255.0)
    {
        isGui = 1;
        Pos.y = (ModelViewMat * vec4(1)).z;
        vertexColor = vec4(1);
        vec2 texSize = textureSize(Sampler0, 0);
        if (Pos.y != -1999)
        {
            gl_Position = vec4(corners[gl_VertexID % 4], 0.5, 1.0);
            texSize.y = HEIGHT;
        }

        float texRatio = texSize.x / texSize.y;
        float ScrRatio = ScreenSize.y / ScreenSize.x;
        float RatioRatio = ScrRatio * texRatio;

        if (RatioRatio < 1)
            texCoord0 = (gl_Position.xy * vec2(1, RatioRatio) * vec2(0.5, -0.5) + 0.5);
        else
            texCoord0 = (gl_Position.xy * vec2(1 / RatioRatio, 1) * vec2(0.5, -0.5) + 0.5);
    }
    else
        texCoord0 = UV0;
}
