program Fairtris.Main;

{$MODE OBJFPC}{$LONGSTRINGS ON}

{$IFDEF MODE_DEBUG}
  {$APPTYPE CONSOLE}
{$ENDIF}

{$RESOURCE Fairtris.Main.res}

uses
  Fairtris.Game;
begin
  Game := TGame.Create();
  try
    Game.Run();
  finally
    Game.Free();
  end;
end.

