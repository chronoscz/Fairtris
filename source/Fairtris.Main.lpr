program Fairtris.Main;

{$MODE OBJFPC}{$LONGSTRINGS ON}

{$RESOURCE Fairtris.Main.res}

uses
  SDL2,
  SysUtils,
  Fairtris.Window,
  Fairtris.Game,
  Fairtris.Classes,
  Fairtris.Constants;

  procedure HandleErrorSDL(const AMessage: String);
  begin
    SDL_ShowSimpleMessageBox(
      SDL_MESSAGEBOX_ERROR,
      PChar(ERROR_TITLE),
      PChar(AMessage),
      GetWindowInstance()
    );
    Halt;
  end;

  procedure HandleErrorUnknown(const AMessage: String);
  begin
    SDL_ShowSimpleMessageBox(
      SDL_MESSAGEBOX_ERROR,
      PChar(ERROR_TITLE),
      PChar(ERROR_MESSAGE_UNKNOWN.Format([AMessage])),
      GetWindowInstance()
    );
    Halt;
  end;

begin
  try
    Game := TGame.Create();
  except
    on Error: SDLException do HandleErrorSDL(Error.Message);
    on Error: Exception    do HandleErrorUnknown(Error.Message);
  end;

  try
    Game.Run();
    Game.Free();
  except
    on Error: SDLException do HandleErrorSDL(Error.Message);
    on Error: Exception    do HandleErrorUnknown(Error.Message);
  end;
end.

