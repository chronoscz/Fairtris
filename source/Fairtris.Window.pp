{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021. All rights reversed.

  https://github.com/furious-programming/fairtris


  This unit is part of the "Fairtris" video game source code. Contains
  the game window's initialization class and stores information about
  the window and its renderer. The event loop is executed in the class
  located in the "Fairtris.Game.pp" unit.


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

unit Fairtris.Window;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  SysUtils;


{
  A class that represents the game window and stores basic information about it. It is only used to store the window
  and renderer pointers and the window handle, and to test whether the window has focus. The main event loop is
  implemented in the "TGame" class, while the "TPlacement" class is responsible for the size, position and behavior
  of the window.
}
type
  TWindow = class(TObject)
  private
    FHandle: THandle;
    FWindow: PSDL_Window;
    FRenderer: PSDL_Renderer;
  private
    function GetFocused(): Boolean;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    property Window: PSDL_Window read FWindow;
    property Renderer: PSDL_Renderer read FRenderer;
  public
    property Handle: THandle read FHandle;
    property Focused: Boolean read GetFocused;
  end;


{
  Global function to get the window pointer, if created.
}
function GetWindowInstance(): PSDL_Window;


var
  Window: TWindow;


implementation

uses
  Fairtris.Classes,
  Fairtris.Arrays,
  Fairtris.Constants;


{
  Global function to get the window pointer. The returned window pointer is only used in the unit "Fairtris.Main" to
  define the parent window for the error message box.

  Result — window pointer if the window exists, "nil" if not already created.
}
function GetWindowInstance(): PSDL_Window;
begin
  if Assigned(Window) then
    Result := Window.Window
  else
    Result := nil;
end;


{
  Constructor of the window class. Its task is to create an instance of the window and its renderer, as well as
  retrieve the window handle that is required to update the contents of the taskbar button in the "TTaskbar" class.

  If the window or renderer cannot be created, or if the window handle cannot be retrieved, an appropriate SDL
  exception is thrown.

  This constructor is called in the "TGame.CreateObjects" method.
}
constructor TWindow.Create();
var
  SysInfo: TSDL_SysWMInfo;
begin
  FWindow := SDL_CreateWindow('Fairtris', SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 0, 0, SDL_WINDOW_BORDERLESS);

  if FWindow = nil then
    raise SDLException.CreateFmt(ERROR_MESSAGE_SDL, [MESSAGE_ERROR[ERROR_SDL_CREATE_WINDOW], SDL_GetError()]);

  FRenderer := SDL_CreateRenderer(FWindow, -1, SDL_RENDERER_ACCELERATED or SDL_RENDERER_TARGETTEXTURE);

  if FRenderer = nil then
    raise SDLException.CreateFmt(ERROR_MESSAGE_SDL, [MESSAGE_ERROR[ERROR_SDL_CREATE_RENDERER], SDL_GetError()]);

  SDL_Version(SysInfo.Version);

  if SDL_GetWindowWMInfo(FWindow, @SysInfo) = SDL_TRUE then
    FHandle := SysInfo.Win.Window
  else
    raise SDLException.CreateFmt(ERROR_MESSAGE_SDL, [MESSAGE_ERROR[ERROR_SDL_CREATE_HANDLE], SDL_GetError()]);
end;


{
  Window class destructor. Its only task is to free the window and the renderer.

  This destructor is called in the "TGame.DestroyObjects" method.
}
destructor TWindow.Destroy();
begin
  SDL_DestroyWindow(FWindow);
  SDL_DestroyRenderer(FRenderer);

  inherited Destroy();
end;


{
  It is used to check if the window has focus and is able to receive input messages. This method is a "Focused"
  property getter, which is used before updating the data of the input devices in the "TGame" class.

  Result — "True" if the window is focused, "False" otherwise.
}
function TWindow.GetFocused(): Boolean;
begin
  Result := SDL_GetWindowFlags(Window) and SDL_WINDOW_INPUT_FOCUS = SDL_WINDOW_INPUT_FOCUS;
end;


end.

