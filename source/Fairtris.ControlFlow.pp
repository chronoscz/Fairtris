unit Fairtris.ControlFlow;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SysUtils;


type
  TControlFlow = class(TObject)
  private
    procedure Interrupt(AExitCode: Integer);
  public
    constructor Create();
  public
    procedure HandleError(ACode: Integer);
    procedure HandleError(ACode: Integer; const AProblem: String);
    procedure HandleWarning(ACode: Integer);
    procedure HandleException(AException: Exception);
  end;


var
  ControlFlow: TControlFlow;


implementation

uses
  Fairtris.Logs,
  Fairtris.Arrays,
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


procedure TControlFlow.Interrupt(AExitCode: Integer);
begin
  Halt(AExitCode);
end;


procedure TControlFlow.HandleError(ACode: Integer);
begin
  Log.AddError(MESSAGE_ERROR[ACode]);
  Interrupt(ACode);
end;


procedure TControlFlow.HandleError(ACode: Integer; const AProblem: String);
begin
  Log.AddError(MESSAGE_ERROR[ACode].Format([AProblem]));
  Interrupt(ACode);
end;


procedure TControlFlow.HandleWarning(ACode: Integer);
begin
  Log.AddWarning(MESSAGE_WARNING[ACode]);
end;


procedure TControlFlow.HandleException(AException: Exception);
begin
  Log.AddException(AException.ToString());
  Interrupt(ERROR_UNEXPECTED);
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

