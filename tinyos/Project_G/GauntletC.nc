
#include "Timer.h"

module GauntletC @safe()
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Timer<TMilli> as Timer1;
  uses interface Timer<TMilli> as Timer2;
  uses interface Leds;
  uses interface Boot;
  uses interface Controls;
}
implementation
{
  task void loop1(){
    while(1) {
      call Controls.glow(0,1);
      call Controls.glow(1,0);
      call Controls.glow(0,2);
      call Controls.glow(2,0);
      //call Controls.glow(0,4);
      //call Controls.glow(4,0);
    }
  }

  task void loop2(){
      call Leds.glow(0,1);
      call Leds.glow(1,2);
      call Leds.glow(2,4);
      call Leds.glow(4,2);
      call Leds.glow(2,1);
      call Leds.glow(1,0);
  }

  task void centerLed(){
    call Controls.centerLed();
  }

  task void centerColor(){
    call Controls.centerColor();
  }

  event void Boot.booted()
  {
    //call Timer0.startOneShot( 2000 );
    //call Timer0.startPeriodic( 2000 );
    //call Timer1.startPeriodic( 500 );
    //call Timer2.startPeriodic( 1000 );
  }

  event void Timer0.fired()
  {
    post loop1();
  }
  
  event void Timer1.fired()
  {
    call Leds.led1Toggle();
  }
  
  event void Timer2.fired()
  {
    call Leds.led2Toggle();
  }

  async event void Controls.btn0Fired() {
    post centerLed();
  }

  async event void Controls.btn1Fired() {
    post centerColor();
  }

  async event void Controls.btn2Fired() {
    call Controls.fingerLed();
  }
}

