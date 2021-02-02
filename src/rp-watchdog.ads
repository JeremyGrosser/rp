package RP.Watchdog is
   --  Watchdog is clocked by clk_ref
   procedure Start (Cycles : Hertz);
   procedure Reload;
end RP.Watchdog;
