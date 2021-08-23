program Fairtris.Main;

{$MODE OBJFPC}{$LONGSTRINGS ON}

{$RESOURCE Fairtris.Main.res}

uses
  Fairtris.Game;
begin
  Game := TGame.Create();
  try
    Game.Start();
  finally
    Game.Free();
  end;
end.

