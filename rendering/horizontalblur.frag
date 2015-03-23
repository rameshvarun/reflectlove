extern float width = 1280;
extern float scale = 1;

extern float offset[3] = float[]( 0.0, 1.3846153846, 3.2307692308 );
extern float weight[3] = float[]( 0.2270270270, 0.3162162162, 0.0702702703  );

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
{
	vec4 out_color = Texel(tex, tc) * weight[0];

	for (int i=1; i<3; i++) {
    float offset = offset[i] * scale / width;
    out_color += Texel(tex, tc + vec2(offset, 0.0) ) * weight[i];
    out_color += Texel(tex, tc - vec2(offset, 0.0)) * weight[i];
  }

  return vec4(out_color.rgb, 1.0);
}
