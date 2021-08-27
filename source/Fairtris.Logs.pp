unit Fairtris.Logs;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TLog = class(TObject)
  public
    procedure SaveToFile(const AFileName: String);
  end;


var
  Log: TLog;


implementation


procedure TLog.SaveToFile(const AFileName: String);
begin

end;


initialization
begin
  Log := TLog.Create();
end;


finalization
begin
  Log.Free();
end;


end.

