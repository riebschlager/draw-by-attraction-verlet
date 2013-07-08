class DynamicShapeUtil {
  public DynamicShapeUtil() {
  }
  float getAlpha(Particle p, String mode, float max) {
    if (mode == "fadeIn") {
      return map(p.age, 0, p.lifetime, 1, max);
    }
    if (mode == "fadeOut") {
      return map(p.age, 0, p.lifetime, max, 1);
    }
    if (mode == "fadeInOut") {
      if (p.age / p.lifetime < 0.5) {
        return map(p.age, 0, p.lifetime / 2, 1, max);
      }
      else {
        return map(p.age, p.lifetime / 2, p.lifetime, max, 1);
      }
    }
    return max;
  }

  float getScale(Particle p, String mode) {
    if (mode == "noise") {
      return map(noise(time), 0, 1, SHAPE_SCALE_MIN, SHAPE_SCALE_MAX);
    }
    if (mode == "scaleIn") {
      return map(p.age, 0, p.lifetime, SHAPE_SCALE_MIN, SHAPE_SCALE_MAX);
    }
    if (mode == "scaleOut") {
      return map(p.age, 0, p.lifetime, SHAPE_SCALE_MAX, SHAPE_SCALE_MIN);
    }
    if (mode == "scaleInOut") {
      if (p.age / p.lifetime < 0.5f) {
        return map(p.age, 0, p.lifetime/2, SHAPE_SCALE_MIN, SHAPE_SCALE_MAX);
      }
      else {
        return map(p.age, p.lifetime/2, p.lifetime, SHAPE_SCALE_MAX, SHAPE_SCALE_MIN);
      }
    }
    return 1f;
  }

  int getColor(Particle p, String mode, int targetColor) {
    if (mode == "fadeTo") {
      return lerpColor(p.pixel, targetColor, p.age / p.lifetime);
    }
    if (mode == "fadeFrom") {
      return lerpColor(targetColor, p.pixel, p.age / p.lifetime);
    }
    return p.pixel;
  }

  float getRotation(Particle p, String mode) {
    if (mode == "particleHeading") {
      return p.getVelocity().heading();
    }
    if (mode == "globalHeading") {
      return p.heading();
    }
    if (mode == "random") {
      return random(TWO_PI);
    }
    return 0f;
  }

  float getRotation(Particle p, String mode, float min, float max, String direction) {
    if (mode == "noise") {
      if (direction == "clockwise") return map(noise(time), 0, 1, min, max);
      else return map(noise(time), 0, 1, max, min);
    }
    if (mode == "age") {
      if (direction == "clockwise") return map(p.age / p.lifetime, 0, 1, min, max);
      else return map(p.age / p.lifetime, 0, 1, max, min);
    }
    return 0f;
  }
}

