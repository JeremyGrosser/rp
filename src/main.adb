--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with Ada.Assertions; use Ada.Assertions;
with Runtime;
with RP2040_SVD; use RP2040_SVD;
with RP.GPIO;    use RP.GPIO;
with RP.ROM;     use RP.ROM;

procedure Main is
   LED : constant GPIO_Pin := 25;
   X   : UInt32 with Volatile;
begin
   RP.GPIO.Enable;
   Configure (LED, Output);
   Set (LED);

   Assert (rom_id = (16#4d#, 16#75#, 16#01#));
   X := popcount32 (2#1110#);
   Assert (X = 3);

   loop
      Clear (LED);
      Set (LED);
   end loop;
end Main;
