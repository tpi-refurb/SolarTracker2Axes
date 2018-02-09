import processing.serial.*;
Serial serial;
Robot robot;
RobotAppearance rAppearance;
PFont myFont; 
PShape base, shoulder, upArm, loArm, end;
float rotX, rotY;
float posX=1, posY=50, posZ=50;
float alpha, beta, gamma;

float armPos = 0;
float shoulderRotation = 0;
String topLeftSensor="0";
String topRightSensor ="0";
String bottomLeftSensor ="0";
String bottomRightSensor ="0";

String aveTop="0";
String aveDown ="0";
String aveLeft ="0";
String aveRight ="0";
boolean shiftOn = false;
boolean started = false;

void setup() {
  size(960, 660, OPENGL);
  robot = new Robot();
  rAppearance= new RobotAppearance();
  myFont = createFont("verdana", 14);
  textFont(myFont);
  println(Serial.list()); // Use this to print connected serial devices
  //serial = new Serial(this, Serial.list()[0], 115200); // Set this to your serial port obtained using the line above
  serial = new Serial(this, "COM1", 9600); // Set this to your serial port obtained using the line above
  serial.bufferUntil('\n'); // Buffer until line feed
}

void draw() { 
  writePos();


  robot.init(width, height);
  //showLabel();  
  //println(rotX+"   "+-rotY);
  robot.setBase(rotX, -rotY);
  robot.drawBaseFloor(false);
  robot.drawAxis();
  robot.setShoulder(shoulderRotation);
  robot.setArm(armPos);
  robot.setEnd(0);
}

void mouseWheel(MouseEvent e) {
  float v = e.getCount();
  if (e.isShiftDown()) {
    shoulderRotation  -= (v * 0.01);
  } else {
    armPos -= (v * 0.01);
  }
}

void mouseDragged() {
  rotY -= (mouseX - pmouseX) * 0.01;
  rotX -= (mouseY - pmouseY) * 0.01;
}

void keyPressed() {
  if (key=='r') {
    print("RESET");
    robot.setBase(0.0, -0.0);
  }
  if (key=='s') {
    started = true;
  }
}

void serialEvent (Serial serial) {

  try {
    //String buffer = serial.readStringUntil('\n'); // read the serial port until a new line
    //if (buffer != null) {  // if theres data in between the new lines
    /*
        buffer = trim(buffer); // get rid of any whitespace just in case
     println(buffer);
     String getX = buffer.substring(1, buffer.indexOf("H")); // get the value of the servo position
     String getV = buffer.substring(buffer.indexOf("H")+1, buffer.length()); // get the value of the sensor reading
     
     shoulderRotation = Float.parseFloat(getX)* 0.01; // set the values to variables
     armPos = Float.parseFloat(getV)* 0.01;
     
     //shoulderRotation = Float.parseFloat(getX); // set the values to variables
     //armPos = Float.parseFloat(getV);
     
     println("BASE: "+ shoulderRotation);
     println("VERT: "+ armPos);
     */
    if (started) {
      String v = serial.readStringUntil('\t'); 
      String h = serial.readStringUntil('\t');

      serial.readStringUntil('\t'); // Ignore extra tab

      topLeftSensor = serial.readStringUntil('\t');
      topRightSensor = serial.readStringUntil('\t');
      bottomLeftSensor = serial.readStringUntil('\t');
      bottomRightSensor = serial.readStringUntil('\t');

      serial.readStringUntil('\t'); // Ignore extra tab

      aveTop = serial.readStringUntil('\t');
      aveDown = serial.readStringUntil('\t');
      aveLeft = serial.readStringUntil('\t');
      aveRight = serial.readStringUntil('\t');

      shoulderRotation = Float.parseFloat(v)* 0.01; // set the values to variables
      armPos = Float.parseFloat(h)* 0.01;
      if (armPos >0) {
        armPos = armPos* -1;
      }
    }
    //}
  }
  catch (Exception e) {
    //closePort();
  }
  finally {
    serial.clear(); // Clear buffer
  }
}
void stop() {
  closePort();
}
void closePort() {
  serial.stop();
  serial = null;
}