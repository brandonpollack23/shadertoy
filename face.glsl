#define PI 3.14159

float Circle(vec2 uv, vec2 center, float ar, float radius, float blur_factor) {
  uv -= center;
  uv.x *= ar;
  float distance = length(uv);
  return smoothstep(radius, radius - blur_factor, distance);
}

float Circle(vec2 uv, vec2 center, float ar, float radius) {
  return Circle(uv, center, ar, radius, .005);
}

vec2 Orbit(vec2 center, float ar, float radius, float angle) {
  return center + radius * vec2(cos(angle) / ar, sin(angle));
}

float Face(vec2 uv, vec2 position, float ar, float size) {
  float eye_to_face_ratio = .25 / .04;
  float eye_distance = .1;
  float eye_height = .1;

  float circle = Circle(uv, position, ar, /*radius*/ size);
  float eye1 = Circle(
      uv, vec2(position.x - eye_distance / ar, position.y + eye_height), ar,
      /*radius*/ size / eye_to_face_ratio);
  float eye2 = Circle(
      uv, vec2(position.x + eye_distance / ar, position.y + eye_height), ar,
      /*radius*/ size / eye_to_face_ratio);

  return circle - eye1 - eye2;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  float ar = iResolution.x / iResolution.y;
  vec2 uv = fragCoord / iResolution.xy;

  float face = Face(uv, vec2(.5, .5), ar, .25);

  vec3 color = mix(vec3(1., 0, 1.), vec3(1., 1., 0.), face);
  fragColor = vec4(color, 0.0);
}
