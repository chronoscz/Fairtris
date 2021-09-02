{
  Fairtris — a fair implementation of Classic Tetris®
  Copyleft (ɔ) furious programming 2021. All rights reversed.

  https://github.com/furious-programming/fairtris


  This unit is part of the "Fairtris" video game source code. Contains a
  class that controls the position and size of the game window, and an
  exclusive video mode. It also contains information about the size of
  the window and its client area, which is required to render the game
  frames properly.


  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any means.

  For more information, see "LICENSE" or "license.txt" file, which should
  be included with this distribution. If not, check the repository.
}

unit Fairtris.Placement;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Arrays;


{
  The class used to store the current size and position of the window, information about the screen area and the
  inner area of the window required to render the content, the video mode state, and responsible for modifying the
  window properties. All window operations are performed on a pointer stored in the "TWindow" class.
}
type
  TPlacement = class(TObject)
  private
    FInitialized: Boolean;
    FDeflored: Boolean;
  private
    FVideoEnabled: Boolean;
    FVideoWidth: Integer;
    FVideoHeight: Integer;
  private
    FMonitorIndex: Integer;
    FMonitorBounds: TSDL_Rect;
  private
    FWindowSize: Integer;
    FWindowBounds: TSDL_Rect;
    FWindowClient: TSDL_Rect;
  private
    procedure SetWindowSize(ASize: Integer);
  private
    procedure UpdateWindowBounds();
    procedure UpdateWindowClient();
    procedure UpdateWindowCursor();
    procedure UpdateWindowHitTest();
    procedure UpdateWindowPlacement();
  private
    procedure UpdateMonitor();
    procedure UpdateWindow();
    procedure UpdateBuffer();
    procedure UpdateVideo();
  public
    constructor Create();
  public
    procedure Initialize();
  public
    procedure EnlargeWindow();
    procedure ReduceWindow();
    procedure ExposeWindow();
  public
    procedure ToggleVideoMode();
  public
    property Deflored: Boolean read FDeflored;
  public
    property VideoEnabled: Boolean read FVideoEnabled;
    property VideoWidth: Integer read FVideoWidth;
    property VideoHeight: Integer read FVideoHeight;
  public
    property WindowSize: Integer read FWindowSize write SetWindowSize;
    property WindowBounds: TSDL_Rect read FWindowBounds;
    property WindowClient: TSDL_Rect read FWindowClient;
  end;


var
  Placement: TPlacement;


implementation

uses
  Math,
  Fairtris.Window,
  Fairtris.Buffers,
  Fairtris.Settings,
  Fairtris.Utils,
  Fairtris.Constants;


{
  Window hit-test callback, handled by the SDL system. Used to determine whether the window can be dragged with the
  left mouse button, that is, only when the window does not occupy the entire screen and the video mode is turned off.
  If the window is draggable, in addition to returning the hit-test state, the "TPlacement.ExposeWindow" method is
  also called to get and store the new window coordinates.

  AWindow — a pointer to the SDL window, always this from "TWindow.Window"
  APoint  — unused
  AData   — unused

  Result — "SDL_HITTEST_DRAGGABLE" if the window is smaller than the screen size, "SDL_HITTEST_NORMAL" otherwise

  This callback is used in the "TPlacement.UpdateWindowHitTest" method.
}
function WindowHitTest(AWindow: PSDL_Window; const APoint: PSDL_Point; AData: Pointer): TSDL_HitTestResult; cdecl;
begin
  if Placement.WindowSize = SIZE_FULLSCREEN then
    Result := SDL_HITTEST_NORMAL
  else
  begin
    Result := SDL_HITTEST_DRAGGABLE;
    Placement.ExposeWindow();
  end;
end;


{
  A class constructor to initialize the monitor data and the window size and position. The proper initialization of
  the window, based on the settings from the configuration file, can be found in the "TPlacement.Initialize" method.
  By default, the window is stretched to full screen, without using the video mode.

  This constructor is called in the "TGame.CreateObjects" method.
}
constructor TPlacement.Create();
begin
  FMonitorIndex := 0;
  SDL_GetDisplayBounds(FMonitorIndex, @FMonitorBounds);

  FWindowSize := SIZE_DEFAULT;

  UpdateWindowBounds();
  UpdateWindowClient();
end;


{
  The main method for initializing screen and window data. Its task is to rewrite the data from the properties of
  the "TSettings" object and to change the size and position of the window. If exclusive video mode has been used in
  the previous session, it is turned on.

  At the end, the appropriate flag is set so that the "TPlacement.UpdateWindowBounds" method will center the window
  on the current screen whenever its size is changed by the user.

  This method is called in the "TGame.Initialize" method, called right before entering the main game loop.
}
procedure TPlacement.Initialize();
begin
  FDeflored := Settings.General.Deflored;

  FVideoEnabled := Settings.Video.Enabled;
  FVideoWidth := Settings.Video.Width;
  FVideoHeight := Settings.Video.Height;

  FMonitorIndex := Settings.General.Monitor;
  SDL_GetDisplayBounds(FMonitorIndex, @FMonitorBounds);

  FWindowSize := Settings.General.Size;
  FWindowBounds.X := Settings.General.Left;
  FWindowBounds.Y := Settings.General.Top;

  UpdateWindow();
  UpdateBuffer();

  if FVideoEnabled then
    UpdateVideo();

  FInitialized := True;
end;


{
  It is used to resize and position the window if the new size is different than the current size. The new window
  position is determined by the area of the screen where the window is currently located. This is the setter for the "
  TPlacement.WindowSize" property and should not be invoked if exclusive video mode is enabled.

  ASize — the new window size, in the range "SIZE_NATIVE" to "SIZE_FULLSCREEN'.

  The property using this setter is mainly modified in the "TLogic.UpdateOptionsWindow" method.
}
procedure TPlacement.SetWindowSize(ASize: Integer);
begin
  if FWindowSize <> ASize then
  begin
    FWindowSize := ASize;

    UpdateMonitor();
    UpdateWindow();
    UpdateBuffer();
  end;
end;


{
  A method that updates the position and size of the window stored in the "TPlacement.FWindowBounds" field, based on
  the state of the video mode and the size index in the "TPlacement.FWindowSize" field.

  If the current window size is "SIZE_FULLSCREEN", the window bounds becomes the same as the screen area. If the video
  mode is active, the size of the area is according to the resolution of the video mode. Otherwise, the new window
  size is calculated based on the zoom factor and centered based on the resolution of the current screen, and the width
  is further increased to maintain the correct aspect ratio.

  This method is used in the "TPlacement.Create" constructor and "TPlacement.UpdateWindow" method.
}
procedure TPlacement.UpdateWindowBounds();
var
  NewWidth, NewHeight: Integer;
begin
  if FVideoEnabled then
    FWindowBounds := SDL_Rect(0, 0, FVideoWidth, FVideoHeight)
  else
  case FWindowSize of
    SIZE_NATIVE, SIZE_ZOOM_2X, SIZE_ZOOM_3X, SIZE_ZOOM_4X:
    begin
      NewWidth := Ord(FWindowSize) * BUFFER_WIDTH + BUFFER_WIDTH;
      NewWidth := Round(NewWidth * WINDOW_RATIO);

      NewHeight := Ord(FWindowSize) * BUFFER_HEIGHT + BUFFER_HEIGHT;

      if FInitialized then
      begin
        FWindowBounds.X := FMonitorBounds.X + (FMonitorBounds.W - NewWidth) div 2;
        FWindowBounds.Y := FMonitorBounds.Y + (FMonitorBounds.H - NewHeight) div 2;
      end;

      FWindowBounds.W := NewWidth;
      FWindowBounds.H := NewHeight;
    end;
    SIZE_FULLSCREEN:
      FWindowBounds := FMonitorBounds;
  end;
end;


{
  Method for updating the window client area stored in the "TPlacement.FWindowClient" field, based on the state of
  the video mode or the size index from the "TPlacement.FWindowSize" field.

  If video mode is on or if the window size is "SIZE_FULLSCREEN", the window client area is calculated based on the
  current screen resolution to maintain the correct aspect ratio of the frame. Otherwise, this area is set to the same
  as the actual window size.

  Used in the "TPlacement.Create" constructor and "TPlacement.UpdateWindow" method.
}
procedure TPlacement.UpdateWindowClient();
var
  NewWidth, NewHeight: Integer;
begin
  if FVideoEnabled or (FWindowSize = SIZE_FULLSCREEN) then
  begin
    NewHeight := FWindowBounds.H;
    NewWidth := Round(NewHeight * CLIENT_RATIO_LANDSCAPE);

    if NewWidth > FWindowBounds.W then
    begin
      NewWidth := FWindowBounds.W;
      NewHeight := Round(NewWidth * CLIENT_RATIO_PORTRAIT);
    end;

    FWindowClient.X := (FWindowBounds.W - NewWidth) div 2;
    FWindowClient.Y := (FWindowBounds.H - NewHeight) div 2;

    FWindowClient.W := NewWidth;
    FWindowClient.H := NewHeight;
  end
  else
    FWindowClient := SDL_Rect(0, 0, FWindowBounds.W, FWindowBounds.H);
end;


{
  A method to show or hide the mouse cursor. If exclusive video mode is enabled or if the window size
  is "SIZE_FULLSCREEN", the cursor should be invisible. For other sizes it is shown.

  Called in the "TPlacement.UpdateWindow" method only.
}
procedure TPlacement.UpdateWindowCursor();
begin
  if FVideoEnabled or (FWindowSize = SIZE_FULLSCREEN) then
    SDL_ShowCursor(SDL_DISABLE)
  else
    SDL_ShowCursor(SDL_ENABLE);
end;


{
  Method for attaching and detaching hit-test callback to the window. If video mode is active or the window is
  stretched to full screen, the callback is detached so that the user cannot drag the window with the left mouse
  button. In other cases, the callback is set and dragging becomes available.

  This method is used in "TPlacement.UpdateWindow" method only.
}
procedure TPlacement.UpdateWindowHitTest();
begin
  if FVideoEnabled or (FWindowSize = SIZE_FULLSCREEN) then
    SDL_SetWindowHitTest(Window.Window, nil, nil)
  else
    SDL_SetWindowHitTest(Window.Window, @WindowHitTest, nil);
end;


{
  A method that updates the window size and position based on the calculated area stored in
  the "TPlacement.FWindowBounds" field. The window pointer is taken directly from the "TWindow" class.

  This method is used only in "TPlacement.UpdateWindow" method.
}
procedure TPlacement.UpdateWindowPlacement();
begin
  SDL_SetWindowSize(Window.Window, FWindowBounds.W, FWindowBounds.H);
  SDL_SetWindowPosition(Window.Window, FWindowBounds.X, FWindowBounds.Y);
end;


{
  A method of taking the index of the display and its area based on the position and size of the window, the index
  of which is taken directly from the "TWindow" class.

  Called in "TPlacement.SetWindowSize" and used in "TPlacement.EnlargeWindow" and "TPlacement.ReduceWindow" methods.
}
procedure TPlacement.UpdateMonitor();
begin
  FMonitorIndex := SDL_GetWindowDisplayIndex(Window.Window);
  SDL_GetDisplayBounds(FMonitorIndex, @FMonitorBounds);
end;


{
  A high-level method of updating all main window properties, i.e. the window and client areas, cursor visibility
  state, hit-test callback existance and the window position on the current display.

  Used in meny "TPlacement" methods, whenever an update of the window data needs to be performed.
}
procedure TPlacement.UpdateWindow();
begin
  UpdateWindowBounds();
  UpdateWindowClient();
  UpdateWindowCursor();
  UpdateWindowHitTest();
  UpdateWindowPlacement();
end;


{
  Method for updating the client space in the back buffer manager for the purposes of rendering the game frames in
  the correct aspect ratio. Assignment occurs only when the window is stretched across the screen.

  Used mainly in the "TPlacement.Initialize" and "TPlacement.SetWindowSize" methods.
}
procedure TPlacement.UpdateBuffer();
begin
  if FVideoEnabled or (FWindowSize = SIZE_FULLSCREEN) then
    Buffers.Client := FWindowClient;
end;


{
  A method to turn low-resolution exclusive video mode on and off.

  Turns on video mode if the "TPlacement.FVideoEnabled" flag is on, hides the cursor and unplug the hit-test callback.
  Otherwise, it returns the window to its previous size and position, shows the cursor and sets a callback to allow
  the window to be dragged.

  If the video mode is turned off for the first time, the position and size of the window must be calculated, so
  the "TPlacement.FDeflored" flag is set and all window properties are computed. Otherwise, if it is a consecutive
  disabling of the video mode, the size and position are known, hence the current data is used.

  This method is used in the "TPlacement.Initialize" and "TPlacement.ToggleVideoMode" methods.
}
procedure TPlacement.UpdateVideo();
begin
  if FVideoEnabled then
  begin
    SDL_ShowCursor(SDL_DISABLE);
    SDL_SetWindowHitTest(Window.Window, nil, nil);

    SDL_SetWindowSize(Window.Window, FVideoWidth, FVideoHeight);
    SDL_SetWindowFullScreen(Window.Window, SDL_WINDOW_FULLSCREEN);
  end
  else
  begin
    SDL_SetWindowFullScreen(Window.Window, SDL_DISABLE);

    if FDeflored then
    begin
      SDL_SetWindowSize(Window.Window, FWindowBounds.W, FWindowBounds.H);
      SDL_SetWindowPosition(Window.Window, FWindowBounds.X, FWindowBounds.Y);

      SDL_ShowCursor(SDL_ENABLE);
      SDL_SetWindowHitTest(Window.Window, @WindowHitTest, nil);
    end
    else
    begin
      FDeflored := True;
      UpdateWindow();
    end;
  end;
end;


{
  This method is used to resize the window one step up if possible and if the exclusive video mode is disabled.

  It is only used in the "TGame.UpdateQueue" method when it receives a mouse wheel spin forward event.
}
procedure TPlacement.EnlargeWindow();
begin
  if FVideoEnabled then Exit;

  if FWindowSize < SIZE_LAST then
  begin
    FWindowSize += 1;

    UpdateMonitor();
    UpdateWindow();
    UpdateBuffer();
  end;
end;


{
  It is used to reduce the window size by one step if possible and if the exclusive video mode is turned off.

  It is only used in the "TGame.UpdateQueue" method when the mouse wheel is rotated backwards.
}
procedure TPlacement.ReduceWindow();
begin
  if FVideoEnabled then Exit;

  if FWindowSize > SIZE_FIRST then
  begin
    FWindowSize -= 1;

    UpdateMonitor();
    UpdateWindow();
  end;
end;


{
  The method for retrieving the current window position on the screen. It is used by hit-test callback while dragging
  the window with the left mouse button, which ensures correct data of the "TPlacement.FWindowBounds" field.

  This is IMHO the only way to update the window position, because SDL does not generate "SDL_WINDOWEVENT_MOVED" events
  while dragging the window.

  Used in "WindowHitTest" function only.
}
procedure TPlacement.ExposeWindow();
begin
  if not FVideoEnabled then
    SDL_GetWindowPosition(Window.Window, @FWindowBounds.X, @FWindowBounds.Y);
end;


{
  This method is used to toggle the low-resolution exclusive video mode. Negates the "TPlacement.FVideoEnabled" flag
  state and calls a method that performs video mode on or off.

  This method is called in the "TLogic.UpdateCommon" method only, when the special key was pressed.
}
procedure TPlacement.ToggleVideoMode();
begin
  FVideoEnabled := not FVideoEnabled;
  UpdateVideo();
end;


end.

