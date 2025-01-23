#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform vec2 iMouse;
uniform float iTime;
uniform sampler2D iTexture;  // Background texture

out vec4 fragColor;

// Hash function for randomization
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float ripple(vec2 uv, vec2 center, float offset) {
    vec2 coord = vec2(uv.x * iResolution.x, uv.y * iResolution.y);
    vec2 centerPoint = vec2(center.x * iResolution.x, center.y * iResolution.y);
    
    float dist = length(coord - centerPoint) / iResolution.y * 8.0;
    
    // Use click position for subtle variation
    float clickSeed = hash(center * 1000.0) * 0.2;  // Reduced random influence
    float uniqueOffset = hash(vec2(offset, clickSeed)) * 3.14159;  // Half the variation
    
    // Start small and expand outward much faster
    float radius = iTime * 6.0 + offset;
    float ringWidth = 0.8;
    
    // Create very subtle asymmetry that develops slowly
    float angle = atan(coord.y - centerPoint.y, coord.x - centerPoint.x);
    float distortionAmount = smoothstep(0.0, 4.0, dist) * 0.15; // Slower development, less distortion
    float distortion = sin(angle * (1.0 + clickSeed) + uniqueOffset) * distortionAmount;
    dist += distortion;
    
    // Only show waves within the expanding ring width
    float mask = smoothstep(0.0, 0.8, radius - dist + ringWidth) * 
                 smoothstep(0.0, 0.8, ringWidth - (radius - dist));
    
    // Create tight, defined rings with minimal variation
    float wave = sin(dist * 4.0 - iTime * 3.0 + distortion * 0.2);  // Reduced distortion influence
    wave = sign(wave) * pow(abs(wave), 2.0);
    
    // Fade out more gradually
    float fadeTime = exp(-iTime * 1.5);
    float falloff = exp(-dist * 0.1) * fadeTime;
    
    return wave * falloff * mask;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / iResolution.xy;
    vec2 mouse = iMouse.xy / iResolution.xy;
    
    // Create four expanding waves with larger spread
    float height = ripple(uv, mouse, 0.0);
    height += ripple(uv, mouse, 0.8) * 0.8;
    height += ripple(uv, mouse, 1.6) * 0.6;
    height += ripple(uv, mouse, 2.4) * 0.4;
    
    // Refraction
    vec2 coord = vec2(uv.x * iResolution.x, uv.y * iResolution.y);
    vec2 mouseCoord = vec2(mouse.x * iResolution.x, mouse.y * iResolution.y);
    vec2 dir = normalize(coord - mouseCoord);
    vec2 refraction = dir * height * 0.05;
    vec2 distortedUV = uv + refraction / iResolution.xy;
    
    vec4 color = texture(iTexture, distortedUV);
    
    // Clean highlights
    float highlight = abs(height) * 0.15;
    highlight = pow(highlight, 1.4);
    fragColor = color + vec4(highlight, highlight, highlight, 0.0);
} 