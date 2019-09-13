/*
  X12.017 Quad Driver Test
  Drive the motor forward and backwards through 270 degrees
  at constant speed.
 */
#include <FreqPeriodCounter.h>

const byte counterPin = 2; // This should be connected to the data output of the fan, blue wire
const byte counterInterrupt = 0;  // This is the interrupt ID for the counting of the fan data
const byte VentPin = 3; 

const int LED = 13;
const int DIR_A =9; // pin for CW/CCW, all motors share this

void pwm25kHzBegin() {
  TCCR2A = 0;                               // TC2 Control Register A
  TCCR2B = 0;                               // TC2 Control Register B
  TIMSK2 = 0;                               // TC2 Interrupt Mask Register
  TIFR2 = 0;                                // TC2 Interrupt Flag Register
  TCCR2A |= (1 << COM2B1) | (1 << WGM21) | (1 << WGM20);  // OC2B cleared/set on match when up/down counting, fast PWM
  TCCR2B |= (1 << WGM22) | (1 << CS21);     // prescaler 8
  OCR2A = 79;                               // TOP overflow value (Hz)
  OCR2B = 0;
}
FreqPeriodCounter counter(counterPin, micros);
void counterISR()
{ counter.poll();
}

void pwmDuty(byte ocrb) {
  OCR2B = ocrb;                             // PWM Width (duty)
}


const int STEP_A = 4; // pin for f(scx)
const int STEP_B = 8;
const int STEP_C = 6;
const int STEP_D = 7;

const int STEP_E = 10;
const int STEP_F = 11;
const int STEP_G = 12;
const int STEP_H = 14;
#define STEPPER_COUNT 8
//Pins for the steppers:
const int steppers[STEPPER_COUNT] = {4,8,6,7,10,11,12,14};
//Estimated location of steppers, in STEPS
int stepper_location[STEPPER_COUNT] = {0,0,0,0,0,0,0,0};
//Target location of steppers, in STEPS
int stepper_target[STEPPER_COUNT] = {0,0,0,0,0,0,0,0};
//Relative starting location (0 or 1) 1:left, 2:right, 0: no parking
const int stepper_park[STEPPER_COUNT] = {1,1,1,0,1,1,2,1};

int stepper_max_angle[STEPPER_COUNT] = {360-90,360-90,360-90,360*2,180+90,140,140,180+90};


const int RESET =5; // pin for RESET
const int DELAY = 700;//450; // μs between steps
int ANGLE = 140; // of 315 available
int RANGE = ANGLE * 3 * 4;
int steps = 0;
bool forward = true;

// pull RESET low to reset, high for normal operation.

// This functions parks all needles
void park(){

  for(int stepper_index=0; stepper_index<STEPPER_COUNT; stepper_index+=1){
    if(stepper_park[stepper_index]==0){
      continue;
    }
    Serial.print("parking ");Serial.println(stepper_index);
    digitalWrite(DIR_A, stepper_park[stepper_index]==2);
    delayMicroseconds(1);  // not required
    digitalWrite(LED, stepper_park[stepper_index]==2);
    for(int stepit=0; stepit<stepper_max_angle[stepper_index]*3*4 + 10; stepit++){
        digitalWrite(steppers[stepper_index], LOW);
        delayMicroseconds(1);  // not required
        digitalWrite(steppers[stepper_index], HIGH);
        delayMicroseconds(450);
    }
    digitalWrite(steppers[stepper_index], LOW);
  
}}


void setup() {
  Serial.begin(9600);
  Serial.println("ON");
  pinMode(DIR_A, OUTPUT);

  pinMode(VentPin,OUTPUT);
  pinMode(counterPin,INPUT_PULLUP);
  pwm25kHzBegin();
  attachInterrupt(counterInterrupt, counterISR, CHANGE);
  
  
  pinMode(STEP_A, OUTPUT);
  pinMode(STEP_B, OUTPUT);
  pinMode(STEP_C, OUTPUT);
  pinMode(STEP_D, OUTPUT);
   pinMode(STEP_E, OUTPUT);
  pinMode(STEP_F, OUTPUT);
  pinMode(STEP_G, OUTPUT);
  pinMode(STEP_H, OUTPUT);
  
  pinMode(LED, OUTPUT);
  pinMode(RESET, OUTPUT);

  digitalWrite(RESET, LOW);
  digitalWrite(LED, HIGH);
  digitalWrite(STEP_A, LOW);
  digitalWrite(STEP_B, LOW);
  digitalWrite(STEP_C, LOW);
  digitalWrite(STEP_D, LOW);
    digitalWrite(STEP_E, LOW);
  digitalWrite(STEP_F, LOW);
  digitalWrite(STEP_G, LOW);
  digitalWrite(STEP_H, LOW);
  digitalWrite(DIR_A, HIGH);

  
  delay(1);  // keep reset low min 1ms
  digitalWrite(RESET, HIGH);


  // Position to ends...
    
  park();
  
}

// The motor steps on rising edge of STEP
// The step line must be held low for at least 450ns
// which is so fast we probably don't need a delay,
// put in a short delay for good measure.

void loop() {

  counter.poll();
  // Find start bit:
  if(Serial.available()>=4){
    int c = 0;
    while(c!=134 && Serial.available()>0){
      c = Serial.read();
      if(c!=134){
        //Serial.print("REJECTED:");Serial.print(c);Serial.println(" NOT 134");
      } else {
        //Serial.print("ACCEPTED:");Serial.print(c);Serial.println(" 134");
        break;
      }
    }
    
    if(Serial.available()>=3){
   
      int stepper = Serial.read(); //-48;
      //Serial.println(stepper);
      int target = (int)Serial.read();
      //Serial.println(target);
      target = (int)Serial.read() + 256*target;
      //Serial.println(target);
      
      if(stepper==99){
        //SET PWM DUTY
        pwmDuty(min(target,79));
      }else if (stepper==98){
        //READ FAN SPEED:
         if(counter.ready()){
            Serial.println(counter.hertz());
         } else {
            Serial.println("None");
         }
      } else if(target<0 || target>stepper_max_angle[stepper] || stepper<0 || stepper>=STEPPER_COUNT){
        //Serial.print("ERR:RANGE:");
        //Serial.println(target);
      } else {
        stepper_target[stepper] = target* 3 * 4;
        //Serial.print("STEP "); Serial.print(stepper); 
        //Serial.print(":");Serial.println(target* 3 * 4);
      }
      
      //Serial.print("AVAIL:");Serial.print(Serial.available());
  
    }
  }


  int waited=0;
  for(int stepper_index=0; stepper_index<STEPPER_COUNT; stepper_index+=1){

    if(stepper_target[stepper_index]==stepper_location[stepper_index]){
      continue;
    }
    int diff = stepper_target[stepper_index] - stepper_location[stepper_index];
    
    int dir = 1-2*(diff<0);
    //Serial.print(diff);Serial.print("\t");Serial.println(dir);
    
    int actuation_dir = dir;
    if(stepper_park[stepper_index]==2){
      actuation_dir *= -1;
    }
    stepper_location[stepper_index]+=dir;
    digitalWrite(DIR_A,  actuation_dir==1);
    digitalWrite(LED, HIGH);
    
    digitalWrite(steppers[stepper_index], LOW);
    delayMicroseconds(1);  // not required
    waited+=1;
    digitalWrite(steppers[stepper_index], HIGH);
    delayMicroseconds(1);  // not required
    waited+=1;
    digitalWrite(steppers[stepper_index], LOW);
    
 
  }  delayMicroseconds(DELAY - waited);
  



}
