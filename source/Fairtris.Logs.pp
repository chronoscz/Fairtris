unit Fairtris.Logs;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TLog = class(TObject)
  public
    procedure AddError(const AProblem: String);
    procedure AddWarning(const AProblem: String);
    procedure AddException(const AProblem: String);
  public
    procedure SaveToFile(const AFileName: String);
  end;


var
  Log: TLog;


implementation


procedure TLog.AddError(const AProblem: String);
begin

end;


procedure TLog.AddWarning(const AProblem: String);
begin

end;


procedure TLog.AddException(const AProblem: String);
begin

end;


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

