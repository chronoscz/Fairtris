program Fairtris.Main;

{$MODE OBJFPC}{$LONGSTRINGS ON}

{$IFDEF MODE_DEBUG}
  {$APPTYPE CONSOLE}
{$ENDIF}

{$RESOURCE Fairtris.Main.res}

uses
  SysUtils,
  Fairtris.Game;
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
      Flow.HandleException(Unexpected);
  end;
end.

