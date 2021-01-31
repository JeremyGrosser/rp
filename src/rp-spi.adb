with RP2040_SVD.RESETS; use RP2040_SVD.RESETS;
with RP2040_SVD.SPI; use RP2040_SVD.SPI;
with RP.Clock;
with HAL; use HAL;

package body RP.SPI is
   procedure Enable
      (This : in out SPI_Port)
   is
   begin
      RP.Clock.Enable (RP.Clock.PERI);

      if RESETS_Periph.RESET.spi.Arr (This.Num) then
         RESETS_Periph.RESET.spi.Arr (This.Num) := False;
         while not RESETS_Periph.RESET_DONE.spi.Arr (This.Num) loop
            null;
         end loop;
      end if;

      --  clk_peri   := clk_sys
      --  fSSPCLK    := clk_peri
      --  fSSPCLKOUT := fSSPCLK / (CPSDVSR * (1 + SCR);

      This.Periph.SSPCR0 :=
         (DSS    => 2#0111#, --  8 bits
          FRF    => 0,       --  Motorola format
          SCR    => 0,
          SPO    => False,
          SPH    => False,
          others => <>);

      This.Periph.SSPCR1 :=
         (MS     => False,   --  Master
          SSE    => False,
          others => <>);

      This.Periph.SSPCPSR.CPSDVSR := 0;
   end Enable;

   overriding
   function Data_Size
      (This : SPI_Port)
      return SPI_Data_Size
   is
   begin
      return Data_Size_8b;
   end Data_Size;

   overriding
   procedure Transmit
      (This    : in out SPI_Port;
       Data    : SPI_Data_8b;
       Status  : out SPI_Status;
       Timeout : Natural := 1000)
   is
   begin
      for D of Data loop
         while not This.Periph.SSPSR.TNF loop
            null;
         end loop;
         This.Periph.SSPDR.DATA := SSPDR_DATA_Field (D);
      end loop;

      while not This.Periph.SSPSR.TFE loop
         null;
      end loop;
      Status := Ok;
   end Transmit;

   overriding
   procedure Transmit
      (This    : in out SPI_Port;
       Data    : SPI_Data_16b;
       Status  : out SPI_Status;
       Timeout : Natural := 1000)
   is
   begin
      Status := Err_Error;
   end Transmit;

   overriding
   procedure Receive
      (This    : in out SPI_Port;
       Data    : out SPI_Data_8b;
       Status  : out SPI_Status;
       Timeout : Natural := 1000)
   is
   begin
      for I in Data'Range loop
         while not This.Periph.SSPSR.RNE loop
            null;
         end loop;
         Data (I) := UInt8 (This.Periph.SSPDR.DATA);
      end loop;
      Status := Ok;
   end Receive;

   overriding
   procedure Receive
      (This    : in out SPI_Port;
       Data    : out SPI_Data_16b;
       Status  : out SPI_Status;
       Timeout : Natural := 1000)
   is
      pragma Unreferenced (Data);
   begin
      Status := Err_Error;
   end Receive;

end RP.SPI;
