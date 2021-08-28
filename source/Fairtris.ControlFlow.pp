unit Fairtris.ControlFlow;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SysUtils;


type
  TControlFlow = class(TObject)
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
  SDL2,
  Fairtris.Logs,
  Fairtris.Arrays,
  Fairtris.Constants;


procedure TControlFlow.HandleError(ACode: Integer);
begin
  Log.AddError(MESSAGE_ERROR[ACode]);
  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, PChar(ERROR_TITLE), PChar(ERROR_MESSAGE), nil);

  Halt(ACode);
end;


procedure TControlFlow.HandleError(ACode: Integer; const AProblem: String);
begin
  Log.AddError(MESSAGE_ERROR[ACode].Format([AProblem]));
  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, PChar(ERROR_TITLE), PChar(ERROR_MESSAGE), nil);

  Halt(ACode);
end;


procedure TControlFlow.HandleWarning(ACode: Integer);
begin
  Log.AddWarning(MESSAGE_WARNING[ACode]);
end;


procedure TControlFlow.HandleException(AException: Exception);
begin
  Log.AddException(AException.ToString());
  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, PChar(ERROR_TITLE), PChar(ERROR_MESSAGE), nil);

  Halt(ERROR_UNEXPECTED);
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

