#define STRIPES 9.
#define OFFSET .25
#define RATIO .1
#define CHANNEL_LOWS vec3(.5, .3, .2)
#define CHANNEL_HIGHS vec3(.9, .6, .6)

float hash(vec2 uv) {
    float f = fract(cos(sin(dot(uv, vec2(.009123898, .00231233))) * 48.512353) * 11111.5452313);
    return f;
}

float noise(vec2 uv) {
    vec2 fuv = floor(uv);
    vec4 cell = vec4(
        hash(fuv + vec2(0, 0)),
        hash(fuv + vec2(0, 1)),
        hash(fuv + vec2(1, 0)),
        hash(fuv + vec2(1, 1))
    );
    vec2 axis = mix(cell.xz, cell.yw, fract(uv.y));
    return mix(axis.x, axis.y, fract(uv.x));
}

float fbm(vec2 uv) {
    float f = 0.;
    float r = 1.;
    for (int i = 0; i < 8; ++i) {
        f += noise((uv += vec2(2. - iTime, 2.)) * r) / (r *= 2.);
    }
    return f / (1. - 1. / r);
}

void main(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    // uv divided to stripes
    vec2 stripedUv = vec2(uv.x, (floor(uv.y * STRIPES) + .5) / STRIPES);
    // scaled uv for noise sample
    vec2 noiseUv = stripedUv * 50. + iTime * 3.;
    
    // get fft ripple values
	vec3 value = texture(iChannel0, stripedUv).rgb;
    // smoothstep them between limits
    value = smoothstep(CHANNEL_LOWS, CHANNEL_HIGHS, value);
    
    // calculate the wave: fbm mixed with raw sound wave
    // weighted with ripple value
    // offset vertically by constant
    vec3 wave = 
        (
            mix(
                smoothstep(0., 1., fbm(noiseUv)),
                texture(iChannel0, vec2(uv.x, .75)).a,
                RATIO)
         	- OFFSET
        ) * value + OFFSET;
    
    // calculate line width: 2 screen pixels + slope of the wave for smoothness
    vec3 width = STRIPES * 2. / iResolution.y + abs(dFdx(wave));
    
    // draw the smooth line
    fragColor.rgb = smoothstep(width, vec3(0), abs(fract(uv.y * STRIPES) - wave));
}