with RP2040_SVD.SPI;
with RP.Clock;
with RP.GPIO;
with RP.SPI;

package RP.Device is
   GP0  : aliased RP.GPIO.GPIO_Point := (Pin => 0);
   GP1  : aliased RP.GPIO.GPIO_Point := (Pin => 1);
   GP2  : aliased RP.GPIO.GPIO_Point := (Pin => 2);
   GP3  : aliased RP.GPIO.GPIO_Point := (Pin => 3);
   GP4  : aliased RP.GPIO.GPIO_Point := (Pin => 4);
   GP5  : aliased RP.GPIO.GPIO_Point := (Pin => 5);
   GP6  : aliased RP.GPIO.GPIO_Point := (Pin => 6);
   GP7  : aliased RP.GPIO.GPIO_Point := (Pin => 7);
   GP8  : aliased RP.GPIO.GPIO_Point := (Pin => 8);
   GP9  : aliased RP.GPIO.GPIO_Point := (Pin => 9);
   GP10 : aliased RP.GPIO.GPIO_Point := (Pin => 10);
   GP11 : aliased RP.GPIO.GPIO_Point := (Pin => 11);
   GP12 : aliased RP.GPIO.GPIO_Point := (Pin => 12);
   GP13 : aliased RP.GPIO.GPIO_Point := (Pin => 13);
   GP14 : aliased RP.GPIO.GPIO_Point := (Pin => 14);
   GP15 : aliased RP.GPIO.GPIO_Point := (Pin => 15);
   GP16 : aliased RP.GPIO.GPIO_Point := (Pin => 16);
   GP17 : aliased RP.GPIO.GPIO_Point := (Pin => 17);
   GP18 : aliased RP.GPIO.GPIO_Point := (Pin => 18);
   GP19 : aliased RP.GPIO.GPIO_Point := (Pin => 19);
   GP20 : aliased RP.GPIO.GPIO_Point := (Pin => 20);
   GP21 : aliased RP.GPIO.GPIO_Point := (Pin => 21);
   GP22 : aliased RP.GPIO.GPIO_Point := (Pin => 22);
   GP23 : aliased RP.GPIO.GPIO_Point := (Pin => 23);
   GP24 : aliased RP.GPIO.GPIO_Point := (Pin => 24);
   GP25 : aliased RP.GPIO.GPIO_Point := (Pin => 25);
   GP26 : aliased RP.GPIO.GPIO_Point := (Pin => 26);
   GP27 : aliased RP.GPIO.GPIO_Point := (Pin => 27);
   GP28 : aliased RP.GPIO.GPIO_Point := (Pin => 28);

   SPI_0 : aliased RP.SPI.SPI_Port (0, RP2040_SVD.SPI.SPI0_Periph'Access);
   SPI_1 : aliased RP.SPI.SPI_Port (1, RP2040_SVD.SPI.SPI1_Periph'Access);

   SysTick : aliased RP.Clock.Delays (RP.Clock.SysTick);
end RP.Device;
