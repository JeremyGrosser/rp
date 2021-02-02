--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with Pico;
with RP.Device;
with RP.GPIO;    use RP.GPIO;
with RP.SPI;     use RP.SPI;
with RP.ROM;     use RP.ROM;
with RP.Watchdog;
with RP.SysTick;
with RP.Clock;
with RP;

with HAL.GPIO;   use HAL.GPIO;
with HAL;        use HAL;
with HAL.Bitmap;

with PCD8544;    use PCD8544;
with Tiny_Text;
with Runtime;

procedure Main is
   LED      : RP.GPIO.GPIO_Point renames Pico.GP15;
   LCD_CS   : RP.GPIO.GPIO_Point renames Pico.GP17;
   LCD_SCK  : RP.GPIO.GPIO_Point renames Pico.GP18;
   LCD_MOSI : RP.GPIO.GPIO_Point renames Pico.GP19;
   LCD_RST  : RP.GPIO.GPIO_Point renames Pico.GP21;
   LCD_DC   : RP.GPIO.GPIO_Point renames Pico.GP20;

   LCD : PCD8544_Device
      (Port => RP.Device.SPI_0'Access,
       DC   => LCD_DC'Access,
       RST  => LCD_RST'Access,
       CS   => null, --  CS controlled by SPI_0
       Time => RP.Device.SysTick'Access);

   Text : Tiny_Text.Text_Buffer
      (Bitmap => LCD.Hidden_Buffer (1),
       Width  => LCD.Width,
       Height => LCD.Height);
begin
   RP.Clock.Initialize (XOSC_Frequency => 12_000_000);
   RP.Watchdog.Enable;

   RP.GPIO.Enable;
   Configure (LED, Output);
   Set (LED);

   Configure (LCD_RST, Output, Pull_Down);
   Clear (LCD_RST);
   Configure (LCD_CS, Output, Pull_Up, SPI);
   Configure (LCD_SCK, Output, Pull_Up, SPI);
   Configure (LCD_MOSI, Output, Pull_Up, SPI);
   Configure (LCD_DC, Output, Pull_Up);

   RP.Device.SPI_0.Enable;
   RP.SysTick.Enable;

   Initialize (LCD);
   LCD.Initialize_Layer
      (Layer  => 1,
       Mode   => HAL.Bitmap.M_1,
       X      => 0,
       Y      => 0,
       Width  => LCD.Width,
       Height => LCD.Height);

   Set_Bias (LCD, 3);
   Set_Contrast (LCD, 60);
   Set_Display_Mode (LCD,
       Enable => True,
       Invert => True);

   Text.Initialize;
   Text.Put_Line ("Hello, there!");
   LCD.Update_Layers;

   loop
      RP.Watchdog.Reload;
      Toggle (LED);
      RP.Device.SysTick.Delay_Milliseconds (100);
   end loop;
end Main;
