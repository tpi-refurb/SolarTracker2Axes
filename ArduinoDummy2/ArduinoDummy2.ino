/* Arm dimensions( mm ) */
#define BASE_HGT 67.31      //base hight 2.65"
#define HUMERUS 146.05      //shoulder-to-elbow "bone" 5.75"
#define ULNA 187.325        //elbow-to-wrist "bone" 7.375"
#define GRIPPER 100.00          //gripper (incl.heavy duty wrist rotate mechanism) length 3.94"
 
#define ftl(x) ((x)>=0?(long)((x)+0.5):(long)((x)-0.5))  //float to long conversion
 

 
/* pre-calculations */
float hum_sq = HUMERUS*HUMERUS;
float uln_sq = ULNA*ULNA;
 

void setup()
{
  
  Serial.begin( 9600 );
  //Serial.println("Start");
  delay( 500 );
}
 
void loop()
{
 
  //zero_x();
  //line();
  circle();
 }
 
/* arm positioning routine utilizing inverse kinematics */
/* z is height, y is distance from base center out, x is side to side. y,z can only be positive */
//void set_arm( uint16_t x, uint16_t y, uint16_t z, uint16_t grip_angle )
void set_arm( float x, float y, float z, float grip_angle_d )
{
  float grip_angle_r = radians( grip_angle_d );    //grip angle in radians for use in calculations
  /* Base angle and radial distance from x,y coordinates */
  float bas_angle_r = atan2( x, y );
  float rdist = sqrt(( x * x ) + ( y * y ));
  /* rdist is y coordinate for the arm */
  y = rdist;
  /* Grip offsets calculated based on grip angle */
  float grip_off_z = ( sin( grip_angle_r )) * GRIPPER;
  float grip_off_y = ( cos( grip_angle_r )) * GRIPPER;
  /* Wrist position */
  float wrist_z = ( z - grip_off_z ) - BASE_HGT;
  float wrist_y = y - grip_off_y;
  /* Shoulder to wrist distance ( AKA sw ) */
  float s_w = ( wrist_z * wrist_z ) + ( wrist_y * wrist_y );
  float s_w_sqrt = sqrt( s_w );
  /* s_w angle to ground */
  //float a1 = atan2( wrist_y, wrist_z );
  float a1 = atan2( wrist_z, wrist_y );
  /* s_w angle to humerus */
  float a2 = acos((( hum_sq - uln_sq ) + s_w ) / ( 2 * HUMERUS * s_w_sqrt ));
  /* shoulder angle */
  float shl_angle_r = a1 + a2;
  float shl_angle_d = degrees( shl_angle_r );
  /* elbow angle */
  float elb_angle_r = acos(( hum_sq + uln_sq - s_w ) / ( 2 * HUMERUS * ULNA ));
  float elb_angle_d = degrees( elb_angle_r );
  float elb_angle_dn = -( 180.0 - elb_angle_d );
  /* wrist angle */
  float wri_angle_d = ( grip_angle_d - elb_angle_dn ) - shl_angle_d;
 
  /* Servo pulses */
  float bas_servopulse = 1500.0 - (( degrees( bas_angle_r )) * 11.11 );
  float shl_servopulse = 1500.0 + (( shl_angle_d - 90.0 ) * 6.6 );
  float elb_servopulse = 1500.0 -  (( elb_angle_d - 90.0 ) * 6.6 );
  float wri_servopulse = 1500 + ( wri_angle_d  * 11.1 );
 
  /* Set servos */
  //servos.setposition( BAS_SERVO, ftl( bas_servopulse ));
  //servos.setposition( WRI_SERVO, ftl( wri_servopulse ));
  //servos.setposition( SHL_SERVO, ftl( shl_servopulse ));
  //servos.setposition( ELB_SERVO, ftl( elb_servopulse ));
  Serial.print("X");
  Serial.print(ftl( shl_servopulse ));
  Serial.print("Y");
  Serial.println(ftl( elb_servopulse ));
}
 

 
void zero_x()
{
  for( double yaxis = 150.0; yaxis < 356.0; yaxis += 1 ) {
    set_arm( 0, yaxis, 127.0, 0 );
    delay( 10 );
  }
  for( double yaxis = 356.0; yaxis > 150.0; yaxis -= 1 ) {
    set_arm( 0, yaxis, 127.0, 0 );
    delay( 10 );
  }
}
 
/* moves arm in a straight line */
void line()
{
    for( double xaxis = -100.0; xaxis < 100.0; xaxis += 0.5 ) {
      set_arm( xaxis, 250, 100, 0 );
      delay( 10 );
    }
    for( float xaxis = 100.0; xaxis > -100.0; xaxis -= 0.5 ) {
      set_arm( xaxis, 250, 100, 0 );
      delay( 10 );
    }
}
 
void circle()
{
  #define RADIUS 80.0
  //float angle = 0;
  float zaxis,yaxis;
  for( float angle = 0.0; angle < 360.0; angle += 1.0 ) {
      yaxis = RADIUS * sin( radians( angle )) + 200;
      zaxis = RADIUS * cos( radians( angle )) + 200;
      set_arm( 0, yaxis, zaxis, 0 );
      delay( 1 );
  }
}
