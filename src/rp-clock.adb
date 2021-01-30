with RP2040_SVD.CLOCKS; use RP2040_SVD.CLOCKS;

package body RP.Clock is
   procedure Enable
      (Gen : Clock_Generator)
   is
   begin
      case Gen is
         when clk_peri =>
            CLOCKS_Periph.CLK_PERI_CTRL.ENABLE := True;
         when others =>
            null; -- TODO: clock config
      end case;
   end Enable;

   overriding
   procedure Delay_Microseconds
      (This : in out Delays;
       Us   : Integer)
   is
   begin
      null;
   end Delay_Microseconds;

   overriding
   procedure Delay_Milliseconds
      (This : in out Delays;
       Ms   : Integer)
   is
   begin
      null;
   end Delay_Milliseconds;

   overriding
   procedure Delay_Seconds
      (This : in out Delays;
       S    : Integer)
   is
   begin
      null;
   end Delay_Seconds;
end RP.Clock;
