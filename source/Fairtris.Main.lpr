{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021. All rights reversed.

  https://github.com/furious-programming/fairtris


  This unit is part of the "Fairtris" video game source code. It contains
  the code responsible for creating an instance of the game, its launch
  and release. Any exceptions are caught here and messages are displayed
  with information about any problems that have existed.


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

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


{
  Displays the error message in the form of a native dialog, containing the original SDL error message and a more
  user-friendly Fairtris error message. When the dialog box is closed, the program operation is terminated.

  AMessage — complete and formatted content of the error message.
}
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


{
  Displays a native dialog with a message provided by the exception object. After closing the dialog box, the program
  operation is interrupted. Only the raw exception message is delivered to this method, so the full error message must
  be extended.

  AMessage — raw exception message.
}
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


{
   The main program block in which an instance of the top-level game class is managed.

   Both the constructor and the "Run" method can throw an exception because the window or renderer cannot be created,
   or because the required files are missing. In the event of an exception, an error message is displayed and then the
   process is interrupted.
}
begin
  try
    with TGame.Create() do
    begin
      Run();
      Free();
    end;
  except
    on Error: SDLException do HandleErrorSDL(Error.Message);
    on Error: Exception    do HandleErrorUnknown(Error.Message);
  end;
end.

