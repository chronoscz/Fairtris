program Fairtris.Main;

{$MODE OBJFPC}{$LONGSTRINGS ON}

{$IFDEF MODE_DEBUG}
  {$APPTYPE CONSOLE}
{$ENDIF}

{$RESOURCE Fairtris.Main.res}

uses
  SDL2,
  SysUtils,
  Fairtris.Window,
  Fairtris.Game,
  Fairtris.Constants;
begin
  try
    Game := TGame.Create();
    try
      Game.Run();
    finally
      Game.Free();
    end;
  except
    on Unexpected: Exception do
    begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, PChar(ERROR_TITLE), PChar(ERROR_MESSAGE), GetWindowInstance());
      Halt;
    end;
  end;
end.

