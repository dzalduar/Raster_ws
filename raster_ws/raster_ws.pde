import frames.timing.*;
import frames.primitives.*;
import frames.processing.*;

// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 2;
int s = 1;
int maxSub=3;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;
boolean subdivision = false;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

void setup() {
  //use 2^n to change the dimensions
  size(512, 512, renderer);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();

  // not really needed here but create a spinning task
  // just to illustrate some frames.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the frame instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it :)
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    public void execute() {
      spin();
    }
  };
  scene.registerTask(spinningTask);

  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow( 2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  popStyle();
  popMatrix();
}

float orient2d(Vector a, Vector b, Vector c)
{
    return ( b.x()-a.x())*(c.y()-a.y()) - (b.y()-a.y())*(c.x()-a.x() );
}
// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
void triangleRaster() {
  // frame.coordinatesOf converts from world to frame
  // here we convert v1 to illustrate the idea
  noStroke();
  if(subdivision){
    fill(255,255,0);
  }else{
    fill(255,255,255);
  }
  //fill(255,255,0);
  int widthCell= width/(int)pow(2,n);
  float sc= 1/pow(2,s);
  for(int x=-width/2; x < width/2; x=x + widthCell){
    for(int y=-width/2; y < width/2; y= y + widthCell ){
      if(subdivision){
        Vector p= new Vector(x+widthCell/2,y+widthCell/2);
        float w0 = orient2d(v2, v3, p);
        float w1 = orient2d(v3, v1, p);
        float w2 = orient2d(v1, v2, p);
        if ( w0 >= 0 && w1 >= 0 && w2 >= 0 ){
          //println("subdividir");
          int wC= widthCell/(int)pow(2,s);
          ArrayList<Vector> points = new ArrayList<Vector>();
          for(int i= x; i < x + widthCell; i= i + wC){
            for(int j= y; j < y + widthCell; j= j + wC){
              
              Vector pc= new Vector(i + wC/2, j + wC/2);
              //ellipse(frame.coordinatesOf(pc).x(),frame.coordinatesOf(pc).y(),0.05,0.05);
              float wc0 = orient2d(v2, v3, pc);
              float wc1 = orient2d(v3, v1, pc);
              float wc2 = orient2d(v1, v2, pc);
              if ( wc0 >= 0 && wc1 >= 0 && wc2 >= 0 ){                
                Vector P= new Vector(i,j);
                points.add(P);
                //rect(frame.coordinatesOf(P).x(),frame.coordinatesOf(P).y(),sc,sc);
              } 
            }
            
            int nC= widthCell/(int)pow(2,s);
            println(nC);
            nC= nC*nC;
            int fc= round((points.size()*255)/nC);
            println(fc);
            fill(255);
            for(int k=0; k < points.size(); k++ ){
              rect(frame.coordinatesOf(points.get(k)).x(),frame.coordinatesOf(points.get(k)).y(),sc,sc);
            }
        }
        

        }
      }else{
        Vector p= new Vector(x+widthCell/2,y+widthCell/2);
        float w0 = orient2d(v2, v3, p);
        float w1 = orient2d(v3, v1, p);
        float w2 = orient2d(v1, v2, p);
        if ( w0 >= 0 && w1 >= 0 && w2 >= 0 ){
          Vector P= new Vector(x,y);
          rect(frame.coordinatesOf(P).x(),frame.coordinatesOf(P).y(),1,1);
        }
      }
      
    }
  }
  //noStroke();
  //ellipse(frame.coordinatesOf(new Vector(-256,0)).x(),frame.coordinatesOf(new Vector(-256,-256)).x(),0.1,0.1);
  //rect(frame.coordinatesOf(new Vector(-128,0)).x(),frame.coordinatesOf(new Vector(-128,0)).y(),1,1);
  if (debug) {
    pushStyle();
    stroke(255, 255, 0, 125);
    point(round(frame.coordinatesOf(v1).x()), round(frame.coordinatesOf(v1).y()));
    popStyle();
  }
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
  //v1.cross(v2);
  Vector v1_v2 = Vector.subtract(v2,v1);
  Vector v2_v3 = Vector.subtract(v3,v2);
  if(v1_v2.cross(v2_v3).z()< 0){
    Vector aux= v2;
    v2= v3;
    v3= aux;
  }
  
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 0, 255);
  point(v1.x(), v1.y());
  stroke(0, 255, 0);
  point(v2.x(), v2.y());
  stroke(255,0,0);
  point(v3.x(), v3.y());
  popStyle();
}

void spin() {
  if (scene.is2D())
    scene.eye().rotate(new Quaternion(new Vector(0, 0, 1), PI / 100), scene.anchor());
  else
    scene.eye().rotate(new Quaternion(yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100), scene.anchor());
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == 'p') {
    s = s < maxSub ? s+1 : 1;
  }
  if (key == 'm') {
    s = s >1 ? s-1 : maxSub;
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
  if (key == 's')
    subdivision = !subdivision;
}