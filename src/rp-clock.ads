with HAL.Time;

-- TODO: implement

package RP.Clock is
   type Delay_Timer is (SysTick);

   type Delays (Timer : Delay_Timer) is
      new HAL.Time.Delays with null record;

   type Clock_Generator is
      (clk_gpout0, clk_gpout1, clk_gpout2, clk_gpout3,
       clk_ref, clk_sys, clk_peri, clk_usb, clk_adc, clk_rtc);

   procedure Enable
      (Gen : Clock_Generator);

   overriding
   procedure Delay_Microseconds
      (This : in out Delays;
       Us   : Integer);

   overriding
   procedure Delay_Milliseconds
      (This : in out Delays;
       Ms   : Integer);

   overriding
   procedure Delay_Seconds
      (This : in out Delays;
       S    : Integer);
end RP.Clock;
