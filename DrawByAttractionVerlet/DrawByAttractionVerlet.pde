import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

int SHAPES_PER_CLICK = 25;
float PHYSICS_DRAG = 0.75f;
float SHAPE_SCALE_MIN = 0.1f;
float SHAPE_SCALE_MAX = 5f;
float SHAPE_FILL_ALPHA = 255;
float SHAPE_STROKE_ALPHA = 255;
float PARTICLE_REPEL_RADIUS = 200;
float PARTICLE_REPEL_FORCE = -0.5f;
float PARTICLE_LIFETIME = 100f;

PGraphics canvas;
VerletPhysics2D physics;
Particle mouseParticle;
PImage sourceImage;
ArrayList<PShape> shapes = new ArrayList<PShape>();
float time;
DynamicShapeUtil dsu;
SVGLoader svgl;

void setup() {
  sourceImage = loadImage("http://img.ffffound.com/static-data/assets/6/4325489f3cf955ace68afd131e958946ed3fb206_m.jpg");
  canvas = createGraphics(300 * 18, 300 * 12);
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
  size(floor(canvas.width / 5), floor(canvas.height / 5));
  physics = new VerletPhysics2D();
  physics.setDrag(PHYSICS_DRAG);

  mouseParticle = new Particle(0, 0);
  physics.addParticle(mouseParticle);
  dsu = new DynamicShapeUtil();
  svgl = new SVGLoader();
  svgl.loadVectors(shapes, this.sketchPath + "/data/vector/", 50, "hexagon");
}

void draw() {
  physics.update();
  render();
  image(canvas, 0, 0, width, height);
}

void render() {
  mouseParticle.x = mouseX;
  mouseParticle.y = mouseY;
  canvas.beginDraw();
  canvas.noFill();
  canvas.noStroke();
  for (int i = physics.particles.size() - 1; i > 1; i--) {
    Particle p = (Particle) physics.particles.get(i);
    int c = dsu.getColor(p, "fadeFrom", 0xFFFFFFFF);
    int cx = (int) map(p.x, 0, width, 0, sourceImage.width);
    int cy = (int) map(p.y, 0, height, 0, sourceImage.height);
    cx = constrain(cx, 0, sourceImage.width - 1);
    cy = constrain(cy, 0, sourceImage.height - 1);
    //int c = sourceImage.get(cx, cy);
    int fillColor = color(red(c), green(c), blue(c), dsu.getAlpha(p, "linear", SHAPE_FILL_ALPHA));
    //int strokeColor = color(red(p.pixel), green(p.pixel), blue(p.pixel), dsu.getAlpha(p, "linear", SHAPE_STROKE_ALPHA));
    int strokeColor = color(0, 0, 0, dsu.getAlpha(p, "fadeInOut", SHAPE_STROKE_ALPHA));
    if (SHAPE_FILL_ALPHA != 0) canvas.fill(fillColor);
    if (SHAPE_STROKE_ALPHA != 0) canvas.stroke(strokeColor);
    canvas.strokeWeight(0.1);
    float mappedX = map(p.x, 0, width, 0, canvas.width);
    float mappedY = map(p.y, 0, height, 0, canvas.height);
    p.shape.resetMatrix();
    p.shape.scale(dsu.getScale(p, "scaleInOut"));
    p.shape.rotate(dsu.getRotation(p, "age", p.initialRotation, p.initialRotation + HALF_PI, p.directionality));
    canvas.shape(p.shape, mappedX, mappedY);
    p.age++;
    if (p.age > p.lifetime) physics.removeParticle(p);
  }
  canvas.endDraw();
}

void keyPressed() {
  if (key == 's') {
    canvas.save("data/output/composition-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".tif");
  }
  if (key == 'c') {
    canvas.beginDraw();
    canvas.background(255);
    canvas.endDraw();
  }
}

void mousePressed() {
  loop();
  for (int i = 0; i < SHAPES_PER_CLICK; i++) {
    Particle p = new Particle(mouseX, mouseY);
    p.shape = shapes.get((int) random(shapes.size()));
    p.pixel = sourceImage.pixels[(int) random(sourceImage.pixels.length)];
    p.targetPixel = sourceImage.pixels[(int) random(sourceImage.pixels.length)];
    p.lifetime = PARTICLE_LIFETIME;
    VerletSpring2D spring = new VerletSpring2D(mouseParticle, p, 10, 0.25f);
    physics.addBehavior(new AttractionBehavior(p, PARTICLE_REPEL_RADIUS, PARTICLE_REPEL_FORCE, 0.1f));
    physics.addParticle(p);
    physics.addSpring(spring);
  }
}

void mouseReleased() {
  noLoop();
  resetPhysics();
}

void resetPhysics() {
  time = random(1000);
  physics.particles.clear();
  physics.behaviors.clear();
  physics.clear();
}

