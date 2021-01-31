with RP2040_SVD.CLOCKS; use RP2040_SVD.CLOCKS;
with RP2040_SVD;
with System;
with HAL; use HAL;
with HAL.Time;

-- TODO: implement

package RP.Clock is
   type Delay_Timer is (SysTick);

   type Delays (Timer : Delay_Timer) is
      new HAL.Time.Delays with null record;

   --  If XOSC_Frequency = 0 then the internal ROSC is used.
   subtype XOSC_Hertz is Hertz range 0 .. 15_000_000;

   procedure Initialize
      (XOSC_Frequency : XOSC_Hertz := 0);

   --  Currently we have hardcoded PLL divider values for 12 MHz ROSC or XOSC
   --  operation. This exception is thrown if any other reference frequency is
   --  given.
   Unknown_PLL_Config : exception;

   type Clock_Id is
      (GPOUT0, GPOUT1, GPOUT2, GPOUT3, REF, SYS, PERI, USB, ADC, RTC);

   procedure Enable
      (CID : Clock_Id);

   function Frequency
      (CID : Clock_Id)
       return Hertz;
   No_Frequency_Counter : exception;

   overriding
   procedure Delay_Microseconds
      (This : in out Delays;
       Us   : Integer);

   overriding
   procedure Delay_Milliseconds
      (This : in out Delays;
       Ms   : Integer);

   overriding
   procedure Delay_Seconds
      (This : in out Delays;
       S    : Integer);

private

   XOSC_Frequency_Stable : Hertz := 0;

   procedure Enable_XOSC
      (XOSC_Frequency : XOSC_Hertz)
	with Pre => XOSC_Frequency >= 1_000_000;

   type CLK_CTRL_AUXSRC_Field is
      (PLL_SYS, GPIN0, GPIN1, PLL_USB, ROSC, XOSC, SYS, USB, ADC, RTC, REF)
      with Size => 4;
   for CLK_CTRL_AUXSRC_Field use
      (PLL_SYS => 0,
       GPIN0   => 1,
       GPIN1   => 2,
       PLL_USB => 3,
       ROSC    => 4,
       XOSC    => 5,
       SYS     => 6,
       USB     => 7,
       ADC     => 8,
       RTC     => 9,
       REF     => 10);

	--  SRC can only be set for REF and SYS and has different meanings for both
   subtype CLK_CTRL_SRC_Field is UInt2;
   REF_SRC_ROSC : constant CLK_CTRL_SRC_Field := 0;
   REF_SRC_AUX  : constant CLK_CTRL_SRC_Field := 1;
   REF_SRC_XOSC : constant CLK_CTRL_SRC_Field := 2;
   SYS_SRC_REF  : constant CLK_CTRL_SRC_Field := 0;
   SYS_SRC_AUX  : constant CLK_CTRL_SRC_Field := 1;

   subtype CLK_CTRL_PHASE_Field is UInt2;

   type CLK_CTRL_Register is record
      AUXSRC : CLK_CTRL_AUXSRC_Field := PLL_SYS;
      SRC    : CLK_CTRL_SRC_Field := 0;
      KILL   : Boolean := False;
      ENABLE : Boolean := False;
      DC50   : Boolean := False;
      PHASE  : CLK_CTRL_PHASE_Field := 0;
      NUDGE  : Boolean := False;
   end record
      with Volatile_Full_Access, Object_Size => 32,
           Bit_Order => System.Low_Order_First;
   for CLK_CTRL_Register use record
      SRC    at 0 range 0 .. 1;
      AUXSRC at 0 range 5 .. 8;
      KILL   at 0 range 10 .. 10;
      ENABLE at 0 range 11 .. 11;
      DC50   at 0 range 12 .. 12;
      PHASE  at 0 range 16 .. 17;
      NUDGE  at 0 range 20 .. 20;
   end record;

   subtype CLK_DIV_INT_Field is UInt24;
   subtype CLK_DIV_FRAC_Field is UInt8;

   type CLK_DIV_Register is record
      INT  : CLK_DIV_INT_Field := 1;
      FRAC : CLK_DIV_FRAC_Field := 0;
   end record
      with Volatile_Full_Access, Object_Size => 32,
           Bit_Order => System.Low_Order_First;
   for CLK_DIV_Register use record
      INT  at 0 range 8 .. 31;
      FRAC at 0 range 0 .. 7;
   end record;

   subtype CLK_SELECTED_Field is UInt32;
   function CLK_SELECTED_Mask (SRC : CLK_CTRL_SRC_Field)
      return CLK_SELECTED_Field;

   type CLK_Register is record
      CTRL     : CLK_CTRL_Register;
      DIV      : CLK_DIV_Register;
      SELECTED : CLK_SELECTED_Field;
   end record
      with Size => (3 * 32);
   for CLK_Register use record
      CTRL     at 0 range 0 .. 31;
      DIV      at 0 range 32 .. 63;
      SELECTED at 0 range 64 .. 95;
   end record;


   type CLK_Array is array (Clock_Id) of CLK_Register;

   type CLOCKS_Peripheral is record
      CLK                  : aliased CLK_Array;
      CLK_SYS_RESUS_CTRL   : aliased CLK_SYS_RESUS_CTRL_Register;
      CLK_SYS_RESUS_STATUS : aliased CLK_SYS_RESUS_STATUS_Register;
      --  Reference clock frequency in kHz
      FC0_REF_KHZ          : aliased FC0_REF_KHZ_Register;
      --  Minimum pass frequency in kHz. This is optional. Set to 0 if you are
      --  not using the pass/fail flags
      FC0_MIN_KHZ          : aliased FC0_MIN_KHZ_Register;
      --  Maximum pass frequency in kHz. This is optional. Set to 0x1ffffff if
      --  you are not using the pass/fail flags
      FC0_MAX_KHZ          : aliased FC0_MAX_KHZ_Register;
      --  Delays the start of frequency counting to allow the mux to settle\n
      --  Delay is measured in multiples of the reference clock period
      FC0_DELAY            : aliased FC0_DELAY_Register;
      --  The test interval is 0.98us * 2**interval, but let's call it 1us *
      --  2**interval\n The default gives a test interval of 250us
      FC0_INTERVAL         : aliased FC0_INTERVAL_Register;
      --  Clock sent to frequency counter, set to 0 when not required\n Writing
      --  to this register initiates the frequency count
      FC0_SRC              : aliased FC0_SRC_Register;
      --  Frequency counter status
      FC0_STATUS           : aliased FC0_STATUS_Register;
      --  Result of frequency measurement, only valid when status_done=1
      FC0_RESULT           : aliased FC0_RESULT_Register;
      --  enable clock in wake mode
      WAKE_EN0             : aliased WAKE_EN0_Register;
      --  enable clock in wake mode
      WAKE_EN1             : aliased WAKE_EN1_Register;
      --  enable clock in sleep mode
      SLEEP_EN0            : aliased SLEEP_EN0_Register;
      --  enable clock in sleep mode
      SLEEP_EN1            : aliased SLEEP_EN1_Register;
      --  indicates the state of the clock enable
      ENABLED0             : aliased ENABLED0_Register;
      --  indicates the state of the clock enable
      ENABLED1             : aliased ENABLED1_Register;
      --  Raw Interrupts
      INTR                 : aliased INTR_Register;
      --  Interrupt Enable
      INTE                 : aliased INTE_Register;
      --  Interrupt Force
      INTF                 : aliased INTF_Register;
      --  Interrupt status after masking & forcing
      INTS                 : aliased INTS_Register;
   end record
     with Volatile;

   for CLOCKS_Peripheral use record
      CLK 						at 16#00# range 0 .. 959;
      CLK_SYS_RESUS_CTRL   at 16#78# range 0 .. 31;
      CLK_SYS_RESUS_STATUS at 16#7C# range 0 .. 31;
      FC0_REF_KHZ          at 16#80# range 0 .. 31;
      FC0_MIN_KHZ          at 16#84# range 0 .. 31;
      FC0_MAX_KHZ          at 16#88# range 0 .. 31;
      FC0_DELAY            at 16#8C# range 0 .. 31;
      FC0_INTERVAL         at 16#90# range 0 .. 31;
      FC0_SRC              at 16#94# range 0 .. 31;
      FC0_STATUS           at 16#98# range 0 .. 31;
      FC0_RESULT           at 16#9C# range 0 .. 31;
      WAKE_EN0             at 16#A0# range 0 .. 31;
      WAKE_EN1             at 16#A4# range 0 .. 31;
      SLEEP_EN0            at 16#A8# range 0 .. 31;
      SLEEP_EN1            at 16#AC# range 0 .. 31;
      ENABLED0             at 16#B0# range 0 .. 31;
      ENABLED1             at 16#B4# range 0 .. 31;
      INTR                 at 16#B8# range 0 .. 31;
      INTE                 at 16#BC# range 0 .. 31;
      INTF                 at 16#C0# range 0 .. 31;
      INTS                 at 16#C4# range 0 .. 31;
   end record;

   CLOCKS_Periph : aliased CLOCKS_Peripheral
      with Import, Address => RP2040_SVD.CLOCKS_Base;

end RP.Clock;
