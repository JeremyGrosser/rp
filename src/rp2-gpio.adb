with RP2040_SVD.RESETS; use RP2040_SVD.RESETS;
with RP2040_SVD.SIO;    use RP2040_SVD.SIO;

package body RP2.GPIO is
   function Pin_Mask (Pin : GPIO_Pin)
      return UInt30
   is (UInt30 (Shift_Left (UInt32 (1), GPIO_Pin'Pos (Pin))));

   procedure Enable is
   begin
      if RESETS_Periph.Reset.io_bank0 then
         RESETS_Periph.RESET.io_bank0 := False;
         while not RESETS_Periph.RESET_DONE.io_bank0 loop
            null;
         end loop;
      end if;

      if RESETS_Periph.Reset.pads_bank0 then
         RESETS_Periph.RESET.pads_bank0 := False;
         while not RESETS_Periph.RESET_DONE.pads_bank0 loop
            null;
         end loop;
      end if;
   end Enable;

   procedure Configure
      (Pin       : GPIO_Pin;
       Direction : GPIO_Direction;
       Func      : GPIO_Function := SIO)
   is
      Mask : constant UInt30 := Pin_Mask (Pin);
   begin
      IO_BANK_Periph.GPIO (Pin).CTRL.FUNCSEL := Func;
      if Direction = Output then
         PADS_BANK_Periph.GPIO (Pin).OD := False;
         SIO_Periph.GPIO_OUT_CLR.GPIO_OUT_CLR := Mask;
         SIO_Periph.GPIO_OE_SET.GPIO_OE_SET := Mask;
      elsif Direction = Input then
         PADS_BANK_Periph.GPIO (Pin).IE := True;
      end if;
   end Configure;

   procedure Set
      (Pin : GPIO_Pin)
   is
   begin
      SIO_Periph.GPIO_OUT_SET.GPIO_OUT_SET := Pin_Mask (Pin);
   end Set;

   procedure Clear
      (Pin : GPIO_Pin)
   is
   begin
      SIO_Periph.GPIO_OUT_CLR.GPIO_OUT_CLR := Pin_Mask (Pin);
   end Clear;
end RP2.GPIO;
