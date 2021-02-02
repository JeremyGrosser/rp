package Runtime is
   --  crt0.S expects this symbol to exist. It is called after main returns.
   procedure OS_Exit (Status : Integer)
      with Export        => True,
           Convention    => C,
           External_Name => "exit";
end Runtime;
