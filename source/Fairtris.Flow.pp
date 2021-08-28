unit Fairtris.Flow;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SysUtils;


type
  TFlow = class(TObject)
  public
    procedure HandleError(ACode: Integer);
    procedure HandleError(ACode: Integer; const AProblem: String);
    procedure HandleWarning(ACode: Integer);
    procedure HandleException(AException: Exception);
  end;


var
  Flow: TFlow;


implementation

uses
  SDL2,
  Fairtris.Logs,
  Fairtris.Arrays,
  Fairtris.Constants;


procedure TFlow.HandleError(ACode: Integer);
begin
  Log.AddError(MESSAGE_ERROR[ACode]);
  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, PChar(ERROR_TITLE), PChar(ERROR_MESSAGE), nil);

  Halt(ACode);
end;


procedure TFlow.HandleError(ACode: Integer; const AProblem: String);
begin
  Log.AddError(MESSAGE_ERROR[ACode].Format([AProblem]));
  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, PChar(ERROR_TITLE), PChar(ERROR_MESSAGE), nil);

  Halt(ACode);
end;


procedure TFlow.HandleWarning(ACode: Integer);
begin
  Log.AddWarning(MESSAGE_WARNING[ACode]);
end;


procedure TFlow.HandleException(AException: Exception);
begin
  Log.AddException(AException.ToString());
  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, PChar(ERROR_TITLE), PChar(ERROR_MESSAGE), nil);

  Halt(ERROR_UNEXPECTED);
end;


initialization
begin
  Flow := TFlow.Create();
end;


finalization
begin
  Flow.Free();
end;


end.

