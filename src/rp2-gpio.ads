with RP2040_SVD.IO_BANK0;   use RP2040_SVD.IO_BANK0;
with RP2040_SVD.PADS_BANK0; use RP2040_SVD.PADS_BANK0;
with RP2040_SVD;            use RP2040_SVD;
with System;

package RP2.GPIO is
   subtype GPIO_Pin is Integer range 0 .. 29;

   type GPIO_Direction is (Input, Output);

   type GPIO_Function is
      (SPI, UART, I2C, PWM, SIO, PIO_0, PIO_1, CLOCK, USB, None);

   for GPIO_Function use
      (SPI   => 1,
       UART  => 2,
       I2C   => 3,
       PWM   => 4,
       SIO   => 5,
       PIO_0 => 6,
       PIO_1 => 7,
       CLOCK => 8,
       USB   => 9,
       None  => 31);

   procedure Enable;

   procedure Configure
      (Pin       : GPIO_Pin;
       Direction : GPIO_Direction;
       Func      : GPIO_Function := SIO);

   procedure Set
      (Pin : GPIO_Pin);

   procedure Clear
      (Pin : GPIO_Pin);

private

   type GPIO_CTRL_Register is record
      FUNCSEL : GPIO_Function := None;
      OUTOVER : GPIO0_CTRL_OUTOVER_Field := NORMAL;
      OEOVER  : GPIO0_CTRL_OEOVER_Field := NORMAL;
      INOVER  : GPIO0_CTRL_INOVER_Field := NORMAL;
      IRQOVER : GPIO0_CTRL_IRQOVER_Field := NORMAL;
   end record
      with Size      => 32,
           Bit_Order => System.Low_Order_First,
           Volatile_Full_Access;

   for GPIO_CTRL_Register use record
      FUNCSEL at 0 range 0 .. 4;
      OUTOVER at 0 range 8 .. 9;
      OEOVER  at 0 range 12 .. 13;
      INOVER  at 0 range 16 .. 17;
      IRQOVER at 0 range 28 .. 29;
   end record;

   --  The svd2ada generated binding for IO_BANK doesn't use arrays,
   --  which is annoying. We partially reimplement it here.
   type GPIO_Register is record
      STATUS : aliased GPIO0_STATUS_Register;
      CTRL   : aliased GPIO_CTRL_Register;
   end record
      with Bit_Order => System.Low_Order_First,
           Size => 64;

   for GPIO_Register use record
      STATUS at 0 range 0 .. 31;
      CTRL   at 4 range 0 .. 31;
   end record;

   type INTR_Register is record
      LEVEL_LOW_0  : Boolean := False;
      LEVEL_HIGH_0 : Boolean := False;
      EDGE_LOW_0   : Boolean := False;
      EDGE_HIGH_0  : Boolean := False;
      LEVEL_LOW_1  : Boolean := False;
      LEVEL_HIGH_1 : Boolean := False;
      EDGE_LOW_1   : Boolean := False;
      EDGE_HIGH_1  : Boolean := False;
   end record
      with Size      => 8,
           Bit_Order => System.Low_Order_First,
           Volatile_Full_Access;

   for INTR_Register use record
      LEVEL_LOW_0  at 0 range 0 .. 0;
      LEVEL_HIGH_0 at 0 range 1 .. 1;
      EDGE_LOW_0   at 0 range 2 .. 2;
      EDGE_HIGH_0  at 0 range 3 .. 3;
      LEVEL_LOW_1  at 0 range 4 .. 4;
      LEVEL_HIGH_1 at 0 range 5 .. 5;
      EDGE_LOW_1   at 0 range 6 .. 6;
      EDGE_HIGH_1  at 0 range 7 .. 7;
   end record;

   type GPIO_Registers is array (GPIO_Pin) of GPIO_Register;
   type INTR_Registers is array (0 .. GPIO_Pin'Last / 2) of INTR_Register;

   type IO_BANK is record
      GPIO : aliased GPIO_Registers;
      INTR : aliased INTR_Registers;
   end record;

   type PADS_BANK_GPIO_Registers is array (GPIO_Pin) of RP2040_SVD.PADS_BANK0.GPIO_Register;

   type PADS_BANK is record
      VOLTAGE_SELECT : aliased VOLTAGE_SELECT_Register;
      GPIO           : aliased PADS_BANK_GPIO_Registers;
      SWCLK          : aliased SWCLK_Register;
      SWD            : aliased SWD_Register;
   end record;

   IO_BANK_Periph : aliased IO_BANK
      with Import, Address => IO_BANK0_Base;
   PADS_BANK_Periph : aliased PADS_BANK
      with Import, Address => PADS_BANK0_Base;
end RP2.GPIO;
