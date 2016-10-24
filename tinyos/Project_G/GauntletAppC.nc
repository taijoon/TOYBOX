
configuration GauntletAppC
{
}
implementation
{
  components MainC, GauntletC, LedsC;
  components new TimerMilliC() as Timer0;
  components new TimerMilliC() as Timer1;
  components new TimerMilliC() as Timer2;


  GauntletC -> MainC.Boot;

  GauntletC.Timer0 -> Timer0;
  GauntletC.Timer1 -> Timer1;
  GauntletC.Timer2 -> Timer2;
  GauntletC.Leds -> LedsC;
}

