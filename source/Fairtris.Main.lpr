program Fairtris.Main;

{$MODE OBJFPC}{$LONGSTRINGS ON}

{$RESOURCE Fairtris.Main.res}

uses
  Interfaces,
  Fairtris.Game;
begin
  Game := TGame.Create();
  try
    Game.Run();
  finally
    Game.Free();
  end;
end.

