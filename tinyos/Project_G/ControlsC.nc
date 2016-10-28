
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

  components HplMsp430InterruptC, new Msp430InterruptC() as port23i;
  components HplMsp430GeneralIOC, new Msp430GpioC() as port23g;

  port23i.HplInterrupt -> HplMsp430InterruptC.Port23;
  port23g.HplGeneralIO -> HplMsp430GeneralIOC.Port23;
  ControlsP.Btn0i -> port23i;
  ControlsP.Btn0g -> port23g;

  // Center LED4
  components new Msp430GpioC() as port53g;
  components new Msp430GpioC() as port52g;
  components new Msp430GpioC() as port51g;
  components new Msp430GpioC() as port50g;
  port53g.HplGeneralIO -> HplMsp430GeneralIOC.Port53;
  ControlsP.led53g -> port53g;
  port52g.HplGeneralIO -> HplMsp430GeneralIOC.Port52;
  ControlsP.led52g -> port52g;
  port51g.HplGeneralIO -> HplMsp430GeneralIOC.Port51;
  ControlsP.led51g -> port51g;
  port50g.HplGeneralIO -> HplMsp430GeneralIOC.Port50;
  ControlsP.led50g -> port50g;
}

