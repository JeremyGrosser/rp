with RP2040_SVD.RESETS; use RP2040_SVD.RESETS;
with RP2040_SVD.SIO;    use RP2040_SVD.SIO;

package body RP.GPIO is
   function Pin_Mask (Pin : GPIO_Pin)
      return GPIO_Pin_Mask
   is (GPIO_Pin_Mask (Shift_Left (UInt32 (1), GPIO_Pin'Pos (Pin))));

   procedure Enable is
   begin
      if RESETS_Periph.RESET.io_bank0 then
         RESETS_Periph.RESET.io_bank0 := False;
         while not RESETS_Periph.RESET_DONE.io_bank0 loop
            null;
         end loop;
      end if;

      if RESETS_Periph.RESET.pads_bank0 then
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
      Mask : constant GPIO_Pin_Mask := Pin_Mask (Pin);
   begin
      IO_BANK_Periph.GPIO (Pin).CTRL.FUNCSEL := Func;
      PADS_BANK_Periph.GPIO (Pin).IE := True;
      if Direction = Output then
         PADS_BANK_Periph.GPIO (Pin).OD := False;
         SIO_Periph.GPIO_OUT_CLR.GPIO_OUT_CLR := Mask;
         SIO_Periph.GPIO_OE_SET.GPIO_OE_SET := Mask;
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

   function Get
      (Pin : GPIO_Pin)
      return Boolean
   is ((SIO_Periph.GPIO_IN.GPIO_IN and Pin_Mask (Pin)) /= 0);

end RP.GPIO;
