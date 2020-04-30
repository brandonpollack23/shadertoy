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

float Rectangle(vec2 uv, float ar, vec2 position, float width, float height,
                float blur_factor) {
  float left_boundary = position.x;
  float left = smoothstep(left_boundary - blur_factor,
                          left_boundary + blur_factor, uv.x);

  float right_boundary = position.x + width;
  float right = smoothstep(right_boundary - blur_factor,
                           right_boundary + blur_factor, uv.x);

  float bottom_boundary = position.y;
  float bottom = smoothstep(bottom_boundary + blur_factor,
                            bottom_boundary - blur_factor, uv.y);

  float top_boundary = position.y + height;
  float top =
      smoothstep(top_boundary + blur_factor, top_boundary - blur_factor, uv.y);

  return (left - right) * (top - bottom);
}

float FaceBase(vec2 uv, vec2 center, float ar, float size) {
  float eye_to_face_ratio = .25 / .04;
  float eye_distance = .1;
  float eye_height = .1;
  float mouth_to_face_ratio = .25 / .1;
  float mouth_height = .1;

  float circle = Circle(uv, center, ar, /*radius*/ size);
  float eye1 =
      Circle(uv, vec2(center.x - eye_distance / ar, center.y + eye_height), ar,
             /*radius*/ size / eye_to_face_ratio);
  float eye2 =
      Circle(uv, vec2(center.x + eye_distance / ar, center.y + eye_height), ar,
             /*radius*/ size / eye_to_face_ratio);

  return circle - eye1 - eye2;
}

float FaceSuprise(vec2 uv, vec2 center, float ar, float size) {
  float mouth_to_face_ratio = 2.3;
  float mouth_height = .1;

  float mouth_circle = Circle(uv, vec2(center.x, center.y - mouth_height), ar,
                              size / mouth_to_face_ratio);

  return FaceBase(uv, center, ar, size) - mouth_circle;
}

float FaceSmiley(vec2 uv, vec2 center, float ar, float size) {
  float mouth_to_face_ratio = 2.3;
  float mouth_height = .05;

  float mouth_circle = Circle(uv, vec2(center.x, center.y - mouth_height), ar,
                              size / mouth_to_face_ratio);

  vec2 mouth_rect_mask_position = vec2(
      (center.x - size / ar / mouth_to_face_ratio), (center.y - mouth_height));
  float mouth_rect_mask = Rectangle(uv, ar, mouth_rect_mask_position, size / ar,
                                    size / mouth_to_face_ratio, .001);
  float mouth = mouth_circle - mouth_rect_mask;

  return FaceBase(uv, center, ar, size) - mouth;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  float ar = iResolution.x / iResolution.y;
  vec2 uv = fragCoord / iResolution.xy;

  float face = FaceSmiley(uv, vec2(.5, .5), ar, .25);
  // float face = Rectangle(uv, ar, vec2(.5, .5), .2, .2, .001);

  vec3 color = mix(vec3(1., 0, 1.), vec3(1., 1., 0.), face);

  fragColor = vec4(color, 0.0);
}
