#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform vec2 iMouse;
uniform float iTime;
uniform sampler2D iTexture;  // Background texture

out vec4 fragColor;

float ripple(vec2 uv, vec2 center) {
    // Scale coordinates to maintain circular shape
    vec2 coord = vec2(uv.x * iResolution.x, uv.y * iResolution.y);
    vec2 centerPoint = vec2(center.x * iResolution.x, center.y * iResolution.y);
    
    float dist = length(coord - centerPoint) / iResolution.y * 30.0;
    // Sombrero function: sin(r)/r creates natural wave propagation
    return sin(dist - iTime * 5.0) / (dist + 1.0) * exp(-dist * 0.1) * exp(-iTime * 1.5);
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / iResolution.xy;
    vec2 mouse = iMouse.xy / iResolution.xy;
    
    // Calculate ripple height using sombrero function
    float height = ripple(uv, mouse);
    
    // Calculate refraction in screen space
    vec2 coord = vec2(uv.x * iResolution.x, uv.y * iResolution.y);
    vec2 mouseCoord = vec2(mouse.x * iResolution.x, mouse.y * iResolution.y);
    vec2 dir = normalize(coord - mouseCoord);
    vec2 refraction = dir * height * 0.15;
    vec2 distortedUV = uv + refraction / iResolution.xy;
    
    // Sample the background with refraction
    vec4 color = texture(iTexture, distortedUV);
    
    // Add very subtle highlights based on height gradient
    float highlight = abs(height) * 0.12;
    fragColor = color + vec4(highlight, highlight, highlight, 0.0);
} 