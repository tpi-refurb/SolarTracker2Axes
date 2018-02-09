class Robot {
  private RobotAppearance _appearance;
  private int _robotOriginX = 0;
  private int _robotOriginY = 0;
  public Robot() {
    base = loadShape("base.obj");
    shoulder = loadShape("shoulder.obj");
    upArm = loadShape("upArm.obj");
    //end = loadShape("r4.obj");

    shoulder.disableStyle();
    upArm.disableStyle();
    this._appearance = new RobotAppearance();
  }

  public void init(int windowWidth, int windowHeight, RobotAppearance appearance) {
    this._appearance =appearance;
    this._robotOriginX = windowWidth;
    this._robotOriginY = windowHeight;
    init(windowWidth, windowHeight);
  }

  public void init(int windowWidth, int windowHeight) {
    background(_appearance.getBackColor());
    smooth();
    lights(); 
    directionalLight(51, 102, 126, -1, 0, 0);
    noStroke();
    showLabel();
    translate(windowWidth/2, windowHeight/2);
  }

  public void setBase(float x, float y) {
    rotateX(x);
    rotateY(y);
    scale(-4);
    //fill(#FFE308);
    translate(0, -35, 0);   
    shape(base);
  }

  public void setShoulder(float rotation) {
    fill(_appearance.getShoulderColor());
    translate(0, 4, 0);
    rotateY(rotation);
    shape(shoulder);
  }

  public void setArm(float position) {
    fill(_appearance.getArmColor());
    translate(0, 25, 0);
    //rotateY(PI);
    rotateX(position);
    shape(upArm);
  }

  public void setEnd(float y) {
    translate(0, 0, 50);
    if (y > 0.0) {
      rotateY(y);
    } else {
      rotateY(PI);
    }
    //shape(end);
    drawPanel(0, 0, -10);
  }

  void drawPanel(int x, int y, int z) {
    translate(x, y, z);
    fill(180);
    int depth = 2;
    box(40, 30, depth);//floor


    translate(x, y, -6);
    box(40, 2, 15);//floor
    box(2, 30, 15);//floor
    //noFill();
    translate(x, y, 4.8);
    //fill(150,0,0);
    fill(#ef7d37);
    ellipse(7, 7, 8, 8); 
    ellipse(-7, 7, 8, 8); 
    ellipse(7, -7, 8, 8); 
    ellipse(-7, -7, 8, 8);
  }

  void drawBaseFloor(boolean fill) {
    drawBaseFloor(fill, 0, -30, 0, 600, 10, 600);
  }
  void drawBaseFloor(boolean fill, int x, int y, int z, int w, int h, int b) {

    pushMatrix();
    translate(x, y, z);
    stroke(200); // Grey
    if (fill) {
      fill(#e1e8e7);
      //fill(10,0,0,128);  //color red semi-transparent
      //fill(200,0,0,50); // semi-transparent
    } else {
      noFill();
      stroke(200); // Grey
    }
    box(w, h, b);//floor  
    //floorVertLines();
    noStroke();
    popMatrix();
  }
  void floorVertLines() {
    fill(32);
    int w = width/2;
    int h = height/2;
    for (int i = 0; i <w; i+=10) {
      for (int j = 0; j < h; j+=10) {
        line(i, j, i+w, j);
        line(i, j, i, j+h);
      }
    }
    noFill();
  }
  void floorLines() {
    strokeWeight(1);
    stroke(200); // Grey
    for (int i = 0; i < width*2; i++) {      
      line(i*10, 0, i*10, height);
      line(0, i*10, width, i*10);
    }
    noStroke();
  }

  void showLabel() {
    myFont = createFont("verdana", 16);
    textFont(myFont);
    fill(0, 170, 0);
    text("Horizontal Rotation: "+shoulderRotation+" °", width-340, 40);
    text("Vertical Rotation : "+armPos+" °", width-340, 60);
    fill(#41f48c);
    text("Top:     "+aveTop, 300, 40);
    text("Down:  "+aveDown, 300, 60);
    text("Left:     "+aveLeft, 300, 80);
    text("Right:   "+aveRight, 300, 100);
    fill(#efda37);
    text("Sensors ", 20, 20);
    text("Average Direction Value ", 300, 20);
    noFill();
    myFont = createFont("verdana", 14);
    textFont(myFont);
    // draw 4 circles as sensors
    strokeWeight(4);
    stroke(#ef7d37);
    ellipse(60, 60, 60, 60); //top left sensor
    ellipse(60, 180, 60, 60);  // top right sensor
    ellipse(200, 60, 60, 60);  // bottom left sensor
    ellipse(200, 180, 60, 60);  // bottom right sensor
    // vertical and horizontal for sensor
    stroke(180);
    strokeWeight(2);
    line(2, (60+180)/2, 260, (60+180)/2);
    line((60+200)/2, 20, (60+200)/2, 240);
    noStroke();

    //sensors label
    fill(0, 170, 0);
    text("Top Left ", 30, 110);
    text("Bottom Left ", 30, 230);
    text("Top Right ", 170, 110);
    text("Bottom Right ", 170, 230);

    fill(#42e5f4);
    text(topLeftSensor, 38, 110-48);
    text(topRightSensor, 38, 230-48);
    text(bottomLeftSensor, 178, 110-48);
    text(bottomRightSensor, 178, 230-48);
    noFill();
    noStroke();
  }
  void drawAxis()
  {
    /* <a href="http://learnopengl.com/img/getting-started/coordinate_systems.png" target="_blank" rel="nofollow">http://learnopengl.com/img/getting-started/coordinate_systems.png</a>  */

    float a = 10;  

    // X right
    stroke(1, 0, 0);
    line(0, a, 0, 0, 0, 0);

    // Y up
    stroke(0, 1, 0);
    line(0, 0, 0, a, 0, 0);

    // Z forward
    stroke(0, 0, 1);
    line(0, 0, 0, 0, 0, a);
    noStroke();
  }
}