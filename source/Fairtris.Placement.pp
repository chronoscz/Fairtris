unit Fairtris.Placement;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Types,
  Fairtris.Arrays;


type
  TPlacement = class(TObject)
  private
    FInitialized: Boolean;
  private
    FMonitorIndex: Integer;
    FMonitorBounds: TSDL_Rect;
  private
    FWindowSize: Integer;
    FWindowBounds: TSDL_Rect;
    FWindowClient: TSDL_Rect;
  private
    FScroll: Integer;
    FFullScreen: Boolean;
  private
    procedure SetMonitorIndex(AIndex: Integer);
    procedure SetWindowSize(ASize: Integer);
    procedure SetWindowBounds(ABounds: TSDL_Rect);
    procedure SetWindowClient(AClient: TSDL_Rect);
  private
    procedure UpdateWindowBounds();
    procedure UpdateWindowClient();
    procedure UpdateWindowCursor();
    procedure UpdateWindowPlacement();
    procedure UpdateWindowProperties();
  private
    procedure UpdateMonitor();
    procedure UpdateWindow();
    procedure UpdateBuffer();
  public
    constructor Create();
  public
    procedure Initialize();
  public
    procedure Enlarge();
    procedure Reduce();
  public
    property Monitor: Integer read FMonitorIndex;
    property MonitorIndex: Integer write SetMonitorIndex;
  public
    property WindowSize: Integer read FWindowSize write SetWindowSize;
    property WindowBounds: TSDL_Rect read FWindowBounds write SetWindowBounds;
    property WindowClient: TSDL_Rect read FWindowClient write SetWindowClient;
  public
    property Scroll: Integer read FScroll write FScroll;
    property FullScreen: Boolean read FFullScreen;
  end;


var
  Placement: TPlacement;


implementation

uses
  Math,
  Controls,
  Fairtris.Window,
  Fairtris.Buffers,
  Fairtris.Settings,
  Fairtris.Utils,
  Fairtris.Constants;


constructor TPlacement.Create();
begin
  FMonitorIndex := 0;
  SDL_GetDisplayBounds(FMonitorIndex, @FMonitorBounds);

  FWindowSize := WINDOW_FULLSCREEN;

  UpdateWindowBounds();
  UpdateWindowClient();
end;


procedure TPlacement.Initialize();
begin
  FMonitorIndex := Settings.General.Monitor;
  SDL_GetDisplayBounds(FMonitorIndex, @FMonitorBounds);

  FWindowSize := Settings.General.Window;
  FScroll := Settings.General.Scroll;

  if FWindowSize <> WINDOW_FULLSCREEN then
  begin
    FWindowBounds.X := Settings.General.Left;
    FWindowBounds.Y := Settings.General.Top;
  end;

  UpdateWindow();
  UpdateBuffer();

  FInitialized := True;
end;


procedure TPlacement.SetMonitorIndex(AIndex: Integer);
begin
  FMonitorIndex := EnsureRange(AIndex, 0, SDL_GetNumVideoDisplays() - 1);
  SDL_GetDisplayBounds(FMonitorIndex, @FMonitorBounds);

  UpdateWindow();
end;


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


procedure TPlacement.SetWindowBounds(ABounds: TSDL_Rect);
begin
  FWindowBounds := ABounds;
end;


procedure TPlacement.SetWindowClient(AClient: TSDL_Rect);
begin
  FWindowClient := AClient;
end;


procedure TPlacement.UpdateWindowBounds();
var
  NewWidth, NewHeight: Integer;
begin
  case FWindowSize of
    WINDOW_NATIVE, WINDOW_ZOOM_2X, WINDOW_ZOOM_3X, WINDOW_ZOOM_4X:
    begin
      NewWidth := Ord(FWindowSize) * BUFFER_WIDTH + BUFFER_WIDTH;
      NewHeight := Ord(FWindowSize) * BUFFER_HEIGHT + BUFFER_HEIGHT;

      if FInitialized then
      begin
        FWindowBounds.X := FMonitorBounds.X + (FMonitorBounds.W - NewWidth) div 2;
        FWindowBounds.Y := FMonitorBounds.Y + (FMonitorBounds.H - NewHeight) div 2;
      end;

      FWindowBounds.W := NewWidth;
      FWindowBounds.H := NewHeight;
    end;
    WINDOW_FULLSCREEN:
      FWindowBounds := FMonitorBounds;
  end;
end;


procedure TPlacement.UpdateWindowClient();
var
  NewWidth, NewHeight: Integer;
begin
  case FWindowSize of
    WINDOW_NATIVE, WINDOW_ZOOM_2X, WINDOW_ZOOM_3X, WINDOW_ZOOM_4X:
      FWindowClient := TSDL_Rect.Create(0, 0, FWindowBounds.W, FWindowBounds.H);
    WINDOW_FULLSCREEN:
    begin
      NewHeight := Round(FWindowBounds.H * CLIENT_FILL_MULTIPLIER);
      NewWidth := Round(NewHeight * CLIENT_RATIO_LANDSCAPE);

      if NewWidth > FWindowBounds.W then
      begin
        NewWidth := Round(FWindowBounds.W * CLIENT_FILL_MULTIPLIER);
        NewHeight := Round(NewWidth * CLIENT_RATIO_PORTRAIT);
      end;

      FWindowClient.X := (FWindowBounds.W - NewWidth) div 2;
      FWindowClient.Y := (FWindowBounds.H - NewHeight) div 2;

      FWindowClient.W := NewWidth;
      FWindowClient.H := NewHeight;
    end;
  end;
end;


procedure TPlacement.UpdateWindowCursor();
begin
  if FWindowSize = WINDOW_FULLSCREEN then
    SDL_ShowCursor(SDL_DISABLE)
  else
    SDL_ShowCursor(SDL_ENABLE);
end;


procedure TPlacement.UpdateWindowPlacement();
begin
  SDL_SetWindowSize(Window.Window, FWindowBounds.W, FWindowBounds.H);
  SDL_SetWindowPosition(Window.Window, FWindowBounds.X, FWindowBounds.Y);
end;


procedure TPlacement.UpdateWindowProperties();
begin
  FFullScreen := FWindowSize = WINDOW_FULLSCREEN;
end;


procedure TPlacement.UpdateMonitor();
begin
  FMonitorIndex := SDL_GetWindowDisplayIndex(Window.Window);
  SDL_GetDisplayBounds(FMonitorIndex, @FMonitorBounds);
end;


procedure TPlacement.UpdateWindow();
begin
  UpdateWindowBounds();
  UpdateWindowClient();
  UpdateWindowCursor();
  UpdateWindowPlacement();
  UpdateWindowProperties();
end;


procedure TPlacement.UpdateBuffer();
begin
  if FWindowSize = WINDOW_FULLSCREEN then
    Buffers.Client := FWindowClient;
end;


procedure TPlacement.Enlarge();
begin
  if FScroll = SCROLL_DISABLED then Exit;

  if FWindowSize < WINDOW_FULLSCREEN then
  begin
    FWindowSize += 1;

    UpdateMonitor();
    UpdateWindow();
    UpdateBuffer();
  end;
end;


procedure TPlacement.Reduce();
begin
  if FScroll = SCROLL_DISABLED then Exit;

  if FWindowSize > WINDOW_NATIVE then
  begin
    FWindowSize -= 1;

    UpdateMonitor();
    UpdateWindow();
  end;
end;


end.

