unit Fairtris.Logs;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TLog = class(TObject)
  end;


var
  Log: TLog;


implementation


initialization
begin
  Log := TLog.Create();
end;


finalization
begin
  Log.Free();
end;


end.

