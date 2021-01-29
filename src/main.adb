with RP2.GPIO; use RP2.GPIO;

procedure Main is
   LED : constant GPIO_Pin := 15;
begin
   RP2.GPIO.Enable;
   Configure (LED, Output);
   loop
      Set (LED);
      Clear (LED);
   end loop;
end Main;
