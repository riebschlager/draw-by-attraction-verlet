class Particle extends VerletParticle2D {

  PShape shape;
  int pixel;
  int targetPixel;
  float age;
  float lifetime;
  String directionality;
  float initialRotation;

  public Particle(float _x, float _y) {
    super(_x, _y);
    age = 0f;
    directionality = (random(1) > 0.5) ? "clockwise" : "counterclockwise";
    initialRotation = random(TWO_PI);
  }
}

