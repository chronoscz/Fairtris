unit Fairtris.ControlFlow;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface


type
  TControlFlow = class(TObject)
  public
    constructor Create();
  end;


var
  ControlFlow: TControlFlow;


implementation

uses
  Fairtris.Logs,
  Fairtris.Constants;


procedure ExitProc();
begin
  if ExitCode <> 0 then
    Log.SaveToFile(LOG_FILENAME);
end;


constructor TControlFlow.Create();
begin
  AddExitProc(@ExitProc);
end;


initialization
begin
  ControlFlow := TControlFlow.Create();
end;


finalization
begin
  ControlFlow.Free();
end;


end.

