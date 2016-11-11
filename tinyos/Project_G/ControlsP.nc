
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
    // Center Btn0
    interface GpioInterrupt as Btn0i;
    interface GeneralIO as Btn0g;
    // Center Green LED4
    interface GeneralIO as green0g;
    interface GeneralIO as green1g;
    interface GeneralIO as green2g;
    interface GeneralIO as green3g;
    // Center Red LED4
    interface GeneralIO as red0g;
    interface GeneralIO as red1g;
    interface GeneralIO as red2g;
    interface GeneralIO as red3g;
    // Center Blue LED4
    interface GeneralIO as blue0g;
    interface GeneralIO as blue1g;
    interface GeneralIO as blue2g;
    interface GeneralIO as blue3g;
    // Finger Btn1,2
    interface GpioInterrupt as Btn1i;
    interface GeneralIO as Btn1g;
    interface GpioInterrupt as Btn2i;
    interface GeneralIO as Btn2g;
    /*
    // Finger LED3
    interface GeneralIO as led15g;
    interface GeneralIO as led16g;
    interface GeneralIO as led17g;
    */
  }
}
implementation {
  uint8_t centerColor = 3, fingerColor = 1;
  command error_t Init.init() {
    atomic {
      call Btn0g.makeOutput();      call Btn0g.clr();

      call Led0.makeOutput();      call Led0.set();
      call Led1.makeOutput();      call Led1.set();
      call Led2.makeOutput();      call Led2.set();

      call Btn0g.makeInput();      call Btn0i.enableRisingEdge();

      call green0g.makeOutput();      call green0g.clr();
      call green1g.makeOutput();      call green1g.clr();
      call green2g.makeOutput();      call green2g.clr();
      call green3g.makeOutput();      call green3g.clr();

      call red0g.makeOutput();      call red0g.clr();
      call red1g.makeOutput();      call red1g.clr();
      call red2g.makeOutput();      call red2g.clr();
      call red3g.makeOutput();      call red3g.clr();

      call blue0g.makeOutput();      call blue0g.clr();
      call blue1g.makeOutput();      call blue1g.clr();
      call blue2g.makeOutput();      call blue2g.clr();
      call blue3g.makeOutput();      call blue3g.clr();

      call Btn1g.makeOutput();      call Btn1g.clr();
      call Btn2g.makeOutput();      call Btn2g.clr();
      call Btn1g.makeInput();      call Btn1i.enableRisingEdge();
      call Btn2g.makeInput();      call Btn2i.enableRisingEdge();
/*
      call led15g.makeOutput();      call led15g.clr();
      call led16g.makeOutput();      call led16g.clr();
      call led17g.makeOutput();      call led17g.clr();
      */
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


  void centerLedSet(uint8_t val) {
    atomic {
      if (val & 0x01) 
        if( centerColor == 0x01 )          call green0g.set();
      else 
        if( centerColor == 0x01 )          call green0g.clr();
      if (val & 0x02) 
        if( centerColor == 0x01 )          call green1g.set();
      else 
        if( centerColor == 0x01 )          call green1g.clr();
      if (val & 0x03) 
        if( centerColor == 0x01 )          call green2g.set();
      else 
        if( centerColor == 0x01 )          call green2g.clr();
      if (val & 0x04) 
        if( centerColor == 0x01 )          call green3g.set();
      else 
        if( centerColor == 0x01 )          call green3g.clr();
    }
  }

  void centerglows(uint16_t time, uint8_t val1, uint8_t val2) {
    int i;
    for (i = time; i > 0; i -= 1) {
      centerLedSet(val1);
        call BusyWait.wait(i);
      centerLedSet(val2);
        call BusyWait.wait(time-i);
    }
  }  

  void grb(uint8_t on){
    if( on){
      if( centerColor == 0x01 ){
        call green0g.set();  call green1g.set();  call green2g.set();  call green3g.set();
	}
      else if( centerColor == 0x02){
        call red0g.set();  call red1g.set();  call red2g.set();  call red3g.set();
	}
      else if( centerColor == 0x03){
        call blue0g.set();  call blue1g.set();  call blue2g.set();  call blue3g.set();
	}
    }
    else {
      if( centerColor == 0x01){
        call green0g.clr();  call green1g.clr();  call green2g.clr();  call green3g.clr();
	}
      else if( centerColor == 0x02){
        call red0g.clr();  call red1g.clr();  call red2g.clr();  call red3g.clr();
	}
      else if( centerColor == 0x03){
        call blue0g.clr();  call blue1g.clr();  call blue2g.clr();  call blue3g.clr();
	}
    }
  }
  void onoff(uint16_t cnt) {
    int i;
    grb(0x0F);
    for (i = 1500; i > 0; i -= 1) {
      call BusyWait.wait(cnt);
    }
    grb(0);
  }

  void glowsline(uint8_t cnt) {
    int i, wheel = 1, speed = 0;
    centerglows(800, 0, 1);
    while(wheel < cnt){
      speed = 800 - ((wheel++)*90);
      for (i = speed; i > 0; i -= 1) {
        call green0g.set();      call green1g.clr();
        call BusyWait.wait(i);
        call green0g.clr();      call green1g.set();
        call BusyWait.wait(speed-i);
      }
      for (i = speed; i > 0; i -= 1) {
        call green1g.set();      call green2g.clr();
        call BusyWait.wait(i);
        call green1g.clr();      call green2g.set();
        call BusyWait.wait(speed-i);
      }
      for (i = speed; i > 0; i -= 1) {
        call green2g.set();      call green3g.clr();
        call BusyWait.wait(i);
        call green2g.clr();      call green3g.set();
        call BusyWait.wait(speed-i);
      }
//      if(cnt != 0){
        for (i = speed; i > 0; i -= 1) {
          call green3g.set();      call green0g.clr();
          call BusyWait.wait(i);
          call green3g.clr();      call green0g.set();
          call BusyWait.wait(speed-i);
        }
//      }
    }
    wheel = 1;
    cnt = cnt * 2 ;
    while(wheel++ <= cnt){
      for (i = speed; i > 0; i -= 1) {
        call green0g.clr();      call green1g.set();
        call BusyWait.wait(i);
        call green0g.set();      call green1g.clr();
        call BusyWait.wait(speed-i);
      }
      for (i = speed; i > 0; i -= 1) {
        call green1g.clr();      call green2g.set();
        call BusyWait.wait(i);
        call green1g.set();      call green2g.clr();
        call BusyWait.wait(speed-i);
      }
      for (i = speed; i > 0; i -= 1) {
        call green2g.clr();      call green3g.set();
        call BusyWait.wait(i);
        call green2g.set();      call green3g.clr();
        call BusyWait.wait(speed-i);
      }
      for (i = speed; i > 0; i -= 1) {
        call green3g.clr();      call green0g.set();
        call BusyWait.wait(i);
        call green3g.set();      call green0g.clr();
        call BusyWait.wait(speed-i);
      }
    }
    onoff(800);
    onoff(1500);
  }

  void glows() {
  /*
    int i;
    for (i = 2536; i > 0; i -= 1) {
      call led15g.clr();    call led16g.clr();    call led17g.clr();
      call BusyWait.wait(i);
      call led15g.set();    call led16g.set();    call led17g.set(); 
      call BusyWait.wait(2536-i);
    }
    for (i = 1536; i > 0; i -= 1) {
      call led15g.set();    call led16g.set();    call led17g.set();
      call BusyWait.wait(i);
      call led15g.clr();    call led16g.clr();    call led17g.clr();
      call BusyWait.wait(1536-i);
    }
    */
  }

  void line() {
    int i;
    call green0g.clr(); 
    for (i = 800; i > 0; i -= 1) 
      call BusyWait.wait(1536);
    call green0g.set();    call green1g.clr();
    for (i = 800; i > 0; i -= 1) 
      call BusyWait.wait(1536);
    call green1g.set();    call green2g.clr();
    for (i = 800; i > 0; i -= 1) 
      call BusyWait.wait(1536);
    call green2g.set();    call green3g.clr();
    for (i = 800; i > 0; i -= 1) 
      call BusyWait.wait(1536);
    call green3g.set();
  }

  command void Controls.centerLed(){
    glowsline(8);
    call Btn0i.enableRisingEdge();
  }

  command void Controls.centerColor(){
    centerColor =  (centerColor %3) + 1;
    if (centerColor == 3)
      call Controls.set(4);
    else if (centerColor == 2)
      call Controls.set(1);
    else if (centerColor == 1)
      call Controls.set(2);
    onoff(1500);
    call Btn1i.enableRisingEdge();
  }

  command void Controls.fingerLed(){
    glows();
  }

  // Center Event
  async event void Btn0i.fired() {
    call Btn0i.disable();
    call Btn0g.clr();
    signal Controls.btn0Fired();
  }

  // Center Color
  async event void Btn1i.fired() {
    call Btn1i.disable();
    call Btn1g.clr();
    signal Controls.btn1Fired();
  }

  async event void Btn2i.fired() {
    call Btn2i.disable();
    call Btn2g.clr();
    signal Controls.btn2Fired();
    call Btn2i.enableRisingEdge();
  }
}
