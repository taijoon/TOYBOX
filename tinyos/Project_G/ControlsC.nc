
configuration ControlsC {
  provides interface Controls;
}
implementation {
  components ControlsP, PlatformLedsC;
  components BusyWaitMicroC;

  Controls = ControlsP;

  ControlsP.Init <- PlatformLedsC.Init;
  ControlsP.Led0 -> PlatformLedsC.Led0;
  ControlsP.Led1 -> PlatformLedsC.Led1;
  ControlsP.Led2 -> PlatformLedsC.Led2;
  ControlsP.BusyWait ->BusyWaitMicroC;

  // Center ---------------------------------------------------------------
  // Center Btn
  components HplMsp430InterruptC, new Msp430InterruptC() as port20i;
  components HplMsp430GeneralIOC, new Msp430GpioC() as port20g;

  port20i.HplInterrupt -> HplMsp430InterruptC.Port20;
  port20g.HplGeneralIO -> HplMsp430GeneralIOC.Port20;
  ControlsP.Btn0i -> port20i;
  ControlsP.Btn0g -> port20g;

  // Center Green LED4
  components new Msp430GpioC() as port53g;
  components new Msp430GpioC() as port52g;
  components new Msp430GpioC() as port51g;
  components new Msp430GpioC() as port50g;
  port53g.HplGeneralIO -> HplMsp430GeneralIOC.Port53;
  ControlsP.green0g -> port53g;
  port52g.HplGeneralIO -> HplMsp430GeneralIOC.Port52;
  ControlsP.green1g -> port52g;
  port51g.HplGeneralIO -> HplMsp430GeneralIOC.Port51;
  ControlsP.green2g -> port51g;
  port50g.HplGeneralIO -> HplMsp430GeneralIOC.Port50;
  ControlsP.green3g -> port50g;
  // Center Red LED4
  components new Msp430GpioC() as port25g;
  components new Msp430GpioC() as port17g;
  components new Msp430GpioC() as port16g;
  components new Msp430GpioC() as port15g;
  port25g.HplGeneralIO -> HplMsp430GeneralIOC.Port25;
  ControlsP.red0g -> port25g;
  port17g.HplGeneralIO -> HplMsp430GeneralIOC.Port17;
  ControlsP.red1g -> port17g;
  port16g.HplGeneralIO -> HplMsp430GeneralIOC.Port16;
  ControlsP.red2g -> port16g;
  port15g.HplGeneralIO -> HplMsp430GeneralIOC.Port15;
  ControlsP.red3g -> port15g;
  // Center Blue LED4
  components new Msp430GpioC() as port37g;
  components new Msp430GpioC() as port36g;
  components new Msp430GpioC() as port35g;
  components new Msp430GpioC() as port34g;
  port37g.HplGeneralIO -> HplMsp430GeneralIOC.Port37;
  ControlsP.blue0g -> port37g;
  port36g.HplGeneralIO -> HplMsp430GeneralIOC.Port36;
  ControlsP.blue1g -> port36g;
  port35g.HplGeneralIO -> HplMsp430GeneralIOC.Port35;
  ControlsP.blue2g -> port35g;
  port34g.HplGeneralIO -> HplMsp430GeneralIOC.Port34;
  ControlsP.blue3g -> port34g;
  // Center ---------------------------------------------------------------
  // Finger Btn
  components new Msp430InterruptC() as port23i;
  components new Msp430GpioC() as port23g;
  components new Msp430InterruptC() as port21i;
  components new Msp430GpioC() as port21g;

  port23i.HplInterrupt -> HplMsp430InterruptC.Port23;
  port23g.HplGeneralIO -> HplMsp430GeneralIOC.Port23;
  ControlsP.Btn1i -> port23i;
  ControlsP.Btn1g -> port23g;
  port21i.HplInterrupt -> HplMsp430InterruptC.Port21;
  port21g.HplGeneralIO -> HplMsp430GeneralIOC.Port21;
  ControlsP.Btn2i -> port21i;
  ControlsP.Btn2g -> port21g;
/*
  // Finger LED3
  components new Msp430GpioC() as port15g;
  components new Msp430GpioC() as port16g;
  components new Msp430GpioC() as port17g;
  port15g.HplGeneralIO -> HplMsp430GeneralIOC.Port15;
  ControlsP.led15g -> port15g;
  port16g.HplGeneralIO -> HplMsp430GeneralIOC.Port16;
  ControlsP.led16g -> port16g;
  port17g.HplGeneralIO -> HplMsp430GeneralIOC.Port17;
  ControlsP.led17g -> port17g;
  */
}

