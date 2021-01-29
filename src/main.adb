with RP.GPIO; use RP.GPIO;
with RP.ROM;
with RP2040_SVD; use RP2040_SVD;
with Ada.Assertions; use Ada.Assertions;

procedure Main is
   LED : constant GPIO_Pin := 15;
   X   : UInt32 with Volatile;
begin
   RP.GPIO.Enable;
   Configure (LED, Output);
   Set (LED);

   X := RP.ROM.popcount32 (2#1110#);
   Assert (X = 3);

   loop
      Clear (LED);
      Set (LED);
   end loop;
end Main;
