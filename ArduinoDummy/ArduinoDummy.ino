
int leftRightPos = 0;         // set a variable to store the servo position
const int numReadings = 10;   // set a variable for the number of readings to take
int index = 0;                // the index of the current reading
int total = 0;                // the total of all readings
int average = 0;              // the average
unsigned long pulseTime = 0;  // variable for reading the pulse
unsigned long distance = 0;   // variable for storing distance

/* setup the pins, servo and serial port */
void setup() {
  // initialize the serial port:
  Serial.begin(9600);  
} 

/* begin rotating the servo and getting sensor values */
void loop() {
  for(leftRightPos = 0; leftRightPos < 360; leftRightPos++) {  // going left to right.
    
      for (index = 0; index<=numReadings;index++) {            // take x number of readings from the sensor and average them      
       // delayMicroseconds(50);                                 // wait 50 microseconds for it to return     
        pulseTime = random(0,10);                    // calculate time for signal to return
        distance = pulseTime/58;                               // convert to centimetres
        total = total + distance;                              // update total
        delay(10);
      }
    average = total/numReadings;                               // create average reading

    if (index >= numReadings)  {                               // reset the counts when at the last item of the array
      index = 0;
      total = 0;
    }
    Serial.print("X");                                         // print leading X to mark the following value as degrees
    Serial.print(leftRightPos);                                // current servo position
    Serial.print("Y");                                         // preceeding character to separate values
    Serial.println(average);                                   // average of sensor readings
  }
  /*
  start going right to left after we got to 180 degrees
  same code as above
  */
  for(leftRightPos = 360; leftRightPos > 0; leftRightPos--) {  // going right to left
   
    for (index = 0; index<=numReadings;index++) {      
      //delayMicroseconds(50);
     
      pulseTime =random(0,10); 
      distance = pulseTime/58;
      total = total + distance;
      delay(10);
    }
    average = total/numReadings;
    if (index >= numReadings)  {
      index = 0;
      total = 0;
    }
    Serial.print("X");
    Serial.print(leftRightPos);
    Serial.print("Y");
    Serial.println(average);
   }
   delay(800);
}
