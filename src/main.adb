with RP2040_SVD.RESETS;     use RP2040_SVD.RESETS;
with RP2040_SVD.PADS_BANK0; use RP2040_SVD.PADS_BANK0;
with RP2040_SVD.IO_BANK0;   use RP2040_SVD.IO_BANK0;
with RP2040_SVD.SIO;        use RP2040_SVD.SIO;
with RP2040_SVD;            use RP2040_SVD;

procedure Main is
   Pin_Mask : constant UInt30 := UInt30 (Shift_Left (UInt32 (1), 15));
begin
   RESETS_Periph.RESET.io_bank0 := False;
   RESETS_Periph.RESET.pads_bank0 := False;
   while not RESETS_Periph.RESET_DONE.io_bank0 or else
         not RESETS_Periph.RESET_DONE.pads_bank0 loop
      null;
   end loop;

   -- clear output enable
   SIO_Periph.GPIO_OE_CLR.GPIO_OE_CLR := Pin_Mask;
   -- output low
   SIO_Periph.GPIO_OUT_CLR.GPIO_OUT_CLR := Pin_Mask;
   -- output disable off
   PADS_BANK0_Periph.GPIO15.OD := False;
   -- input enable on
   PADS_BANK0_Periph.GPIO15.IE := True;
   -- function select
   IO_BANK0_Periph.GPIO15_CTRL.FUNCSEL := sio_15;

   -- output enable
   SIO_Periph.GPIO_OE_SET.GPIO_OE_SET := Pin_Mask;

   loop
      SIO_Periph.GPIO_OUT_SET.GPIO_OUT_SET := Pin_Mask;
      SIO_Periph.GPIO_OUT_CLR.GPIO_OUT_CLR := Pin_Mask;
   end loop;
end Main;
