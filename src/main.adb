with RP2.GPIO; use RP2.GPIO;

procedure Main is
begin
   Enable;
   Configure (15, Output);
   loop
      Set (15);
      Clear (15);
   end loop;
end Main;
