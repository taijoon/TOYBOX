
module ControlsP @safe() {
  provides {
    interface Init;
    interface Controls;
  }
  uses {
    interface GeneralIO as Led0;
    interface GeneralIO as Led1;
    interface GeneralIO as Led2;
    interface BusyWait<TMicro, uint16_t>;	
    interface GpioInterrupt as Btn0i;
    interface GeneralIO as Btn0g;
    // Center LED4
    interface GeneralIO as led53g;
    interface GeneralIO as led52g;
    interface GeneralIO as led51g;
    interface GeneralIO as led50g;
  }
}
implementation {
  command error_t Init.init() {
    atomic {
      call Btn0g.makeOutput();
      call Btn0g.clr();
      call Led0.makeOutput();
      call Led1.makeOutput();
      call Led2.makeOutput();
      call Led0.set();
      call Led1.set();
      call Led2.set();
      call BusyWait.wait(10);
      call Btn0g.makeInput();
      call Btn0i.enableRisingEdge();

      call led53g.makeOutput();
      call led53g.set();
      call led52g.makeOutput();
      call led52g.set();
      call led51g.makeOutput();
      call led51g.set();
      call led50g.makeOutput();
      call led50g.set();
    }
    return SUCCESS;
  }

  /* Note: the call is inside the dbg, as it's typically a read of a volatile
     location, so can't be deadcode eliminated */

  async command void Controls.led0On() {
    call Led0.clr();
  }

  async command void Controls.led0Off() {
    call Led0.set();
  }

  async command void Controls.led0Toggle() {
    call Led0.toggle();
  }

  async command void Controls.led1On() {
    call Led1.clr();
  }

  async command void Controls.led1Off() {
    call Led1.set();
  }

  async command void Controls.led1Toggle() {
    call Led1.toggle();
  }

  async command void Controls.led2On() {
    call Led2.clr();
  }

  async command void Controls.led2Off() {
    call Led2.set();
  }

  async command void Controls.led2Toggle() {
    call Led2.toggle();
  }

  async command uint8_t Controls.get() {
    uint8_t rval;
    atomic {
      rval = 0;
      if (!call Led0.get()) {
	rval |= LEDS_LED0;
      }
      if (!call Led1.get()) {
	rval |= LEDS_LED1;
      }
      if (!call Led2.get()) {
	rval |= LEDS_LED2;
      }
    }
    return rval;
  }

  async command void Controls.set(uint8_t val) {
    atomic {
      if (val & LEDS_LED0) {
	call Controls.led0On();
      }
      else {
	call Controls.led0Off();
      }
      if (val & LEDS_LED1) {
	call Controls.led1On();
      }
      else {
	call Controls.led1Off();
      }
      if (val & LEDS_LED2) {
	call Controls.led2On();
      }
      else {
	call Controls.led2Off();
      }
    }
  }

  command void Controls.glow(uint8_t val1, uint8_t val2) {
    int i;
    for (i = 1000; i > 0; i -= 1) {
      call Controls.set(val1);
	  call BusyWait.wait(i);
      call Controls.set(val2);
	  call BusyWait.wait(1536-i);
    }
  }  

  command void Controls.glowslow(uint8_t val1, uint8_t val2) {
    int i;
    for (i = 1536; i > 0; i -= 1) {
      call Controls.set(val1);
	  call BusyWait.wait(i);
      call Controls.set(val2);
	  call BusyWait.wait(1536-i);
    }
  }  

  void onoff() {
    int i;
    call led53g.clr();    call led52g.clr();    call led51g.clr();    call led50g.clr();
    for (i = 400; i > 0; i -= 1) {
      call BusyWait.wait(400);
    }
    call led53g.set();    call led52g.set();    call led51g.set();    call led50g.set();
    for (i = 400; i > 0; i -= 1) {
      call BusyWait.wait(400);
    }
    call led53g.clr();    call led52g.clr();    call led51g.clr();    call led50g.clr();
    for (i = 1500; i > 0; i -= 1) {
      call BusyWait.wait(1500);
    }
    call led53g.set();    call led52g.set();    call led51g.set();    call led50g.set();
  }

  void glowsline(uint8_t cnt) {
    int i, wheel = 1, speed = 0;
    for (i = 800; i > 0; i -= 1) {
      call led53g.set();
      call BusyWait.wait(i);
      call led53g.clr();
      call BusyWait.wait(800-i);
    }
    while(wheel < cnt){
      speed = 800 - ((wheel++)*90);
      for (i = speed; i > 0; i -= 1) {
        call led53g.clr();      call led52g.set();
        call BusyWait.wait(i);
        call led53g.set();      call led52g.clr();
        call BusyWait.wait(speed-i);
      }
      for (i = speed; i > 0; i -= 1) {
        call led52g.clr();      call led51g.set();
        call BusyWait.wait(i);
        call led52g.set();      call led51g.clr();
        call BusyWait.wait(speed-i);
      }
      for (i = speed; i > 0; i -= 1) {
        call led51g.clr();      call led50g.set();
        call BusyWait.wait(i);
        call led51g.set();      call led50g.clr();
        call BusyWait.wait(speed-i);
      }
//      if(cnt != 0){
        for (i = speed; i > 0; i -= 1) {
          call led50g.clr();      call led53g.set();
          call BusyWait.wait(i);
          call led50g.set();      call led53g.clr();
          call BusyWait.wait(speed-i);
        }
//      }
    }
    wheel = 1;
    cnt = cnt * 2 ;
    while(wheel++ <= cnt){
      for (i = speed; i > 0; i -= 1) {
        call led53g.clr();      call led52g.set();
        call BusyWait.wait(i);
        call led53g.set();      call led52g.clr();
        call BusyWait.wait(speed-i);
      }
      for (i = speed; i > 0; i -= 1) {
        call led52g.clr();      call led51g.set();
        call BusyWait.wait(i);
        call led52g.set();      call led51g.clr();
        call BusyWait.wait(speed-i);
      }
      for (i = speed; i > 0; i -= 1) {
        call led51g.clr();      call led50g.set();
        call BusyWait.wait(i);
        call led51g.set();      call led50g.clr();
        call BusyWait.wait(speed-i);
      }
//      if(cnt != 0){
        for (i = speed; i > 0; i -= 1) {
          call led50g.clr();      call led53g.set();
          call BusyWait.wait(i);
          call led50g.set();      call led53g.clr();
          call BusyWait.wait(speed-i);
        }
      }
    /*
    for (i = 1000; i > 0; i -= 1) {
      call led53g.clr();
      call BusyWait.wait(i);
      call led53g.set();
      call BusyWait.wait(1000-i);
    }
    */
    onoff();
  }

  void glows() {
    int i;
    for (i = 2536; i > 0; i -= 1) {
      call led53g.set();    call led52g.set();    call led51g.set();    call led50g.set();
      call BusyWait.wait(i);
      call led53g.clr();    call led52g.clr();    call led51g.clr();    call led50g.clr();
      call BusyWait.wait(2536-i);
    }
    for (i = 1536; i > 0; i -= 1) {
      call led53g.clr();    call led52g.clr();    call led51g.clr();    call led50g.clr();
      call BusyWait.wait(i);
      call led53g.set();    call led52g.set();    call led51g.set();    call led50g.set();
      call BusyWait.wait(1536-i);
    }
  }

  void line() {
    int i;
    call led53g.clr(); 
    for (i = 800; i > 0; i -= 1) 
      call BusyWait.wait(1536);
    call led53g.set();    call led52g.clr();
    for (i = 800; i > 0; i -= 1) 
      call BusyWait.wait(1536);
    call led52g.set();    call led51g.clr();
    for (i = 800; i > 0; i -= 1) 
      call BusyWait.wait(1536);
    call led51g.set();    call led50g.clr();
    for (i = 800; i > 0; i -= 1) 
      call BusyWait.wait(1536);
    call led50g.set();
  }

  command void Controls.centerLed(){
    glowsline(8);
    //onoff();
    //glows();
    //line();
  }

  async event void Btn0i.fired() {
    call Btn0i.disable();
    call Btn0g.clr();
    signal Controls.btn0Fired();
    call Btn0i.enableRisingEdge();
  }
}
