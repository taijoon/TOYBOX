
#include "Leds.h"

interface Controls {

  async command void led0On();

  async command void led0Off();

  async command void led0Toggle();

  async command void led1On();

  async command void led1Off();

  async command void led1Toggle();

 
  async command void led2On();

  async command void led2Off();

  async command void led2Toggle();

  async command uint8_t get();

  async command void set(uint8_t val);

  command void glow(uint8_t val1, uint8_t val2);
  
  command void glowslow(uint8_t val1, uint8_t val2);
 
  command void centerLed();

  event void btn0Fired();
}
