package body Runtime is
   procedure OS_Exit
      (Status : Integer)
   is
      pragma Unreferenced (Status);
   begin
      null;
   end OS_Exit;
end Runtime;
