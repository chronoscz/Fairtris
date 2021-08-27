unit Fairtris.ControlFlow;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SysUtils;


type
  TControlFlow = class(TObject)
  public
    constructor Create();
  public
    procedure HandleError(AErrorCode: Integer);
    procedure HandleWarning(AWarningCode: Integer);
    procedure HandleException(AException: Exception);
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


procedure TControlFlow.HandleError(AErrorCode: Integer);
begin

end;


procedure TControlFlow.HandleWarning(AWarningCode: Integer);
begin

end;


procedure TControlFlow.HandleException(AException: Exception);
begin

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

