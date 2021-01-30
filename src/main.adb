--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with Ada.Assertions; use Ada.Assertions;
with RP2040_SVD; use RP2040_SVD;
with RP.Device;  use RP.Device;
with RP.GPIO;    use RP.GPIO;
with RP.SPI;     use RP.SPI;
with RP.ROM;     use RP.ROM;
with RP.Clock;
with PCD8544;    use PCD8544;
with Tiny_Text;
with HAL;        use HAL;
with HAL.GPIO;

procedure Main is
   LED      : GPIO_Point renames GP15;
   LCD_CS   : GPIO_Point renames GP17;
   LCD_SCK  : GPIO_Point renames GP18;
   LCD_MOSI : GPIO_Point renames GP19;
   LCD_RST  : GPIO_Point renames GP21;
   LCD_DC   : GPIO_Point renames GP20;
   use HAL.GPIO;

   LCD : PCD8544_Device
      (Port => SPI_0'Access,
       DC   => LCD_DC'Access,
       RST  => LCD_RST'Access,
       CS   => null, --  CS controlled by SPI_0
       Time => SysTick'Access);

   Text : Tiny_Text.Text_Buffer
      (Bitmap => LCD.Hidden_Buffer (1),
       Width  => LCD.Width,
       Height => LCD.Height);

   X : UInt32;
begin
   RP.GPIO.Enable;
   Configure (LED, Output);
   Set (LED);

   Configure (LCD_RST, Output);
   Configure (LCD_CS, Output, Pull_Up, SPI);
   Configure (LCD_SCK, Output, Pull_Up, SPI);
   Configure (LCD_MOSI, Output, Pull_Up, SPI);
   Configure (LCD_DC, Output, Pull_Up);

   SPI_0.Enable;

   Initialize (LCD);
   Set_Bias (LCD, 3);
   Set_Contrast (LCD, 60);
   Set_Display_Mode (LCD,
       Enable => True,
       Invert => True);
   Text.Initialize;
   Text.Put_Line ("Hello, there!");
   LCD.Update_Layers;

   Assert (rom_id = (16#4d#, 16#75#, 16#01#));
   X := popcount32 (2#1110#);
   Assert (X = 3);

   loop
      Clear (LED);
      Set (LED);
   end loop;
end Main;
