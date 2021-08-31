unit Fairtris.Placement;

{$MODE OBJFPC}{$LONGSTRINGS ON}

interface

uses
  SDL2,
  Fairtris.Arrays;


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
    procedure SetMonitorIndex(AIndex: Integer);
    procedure SetWindowSize(ASize: Integer);
    procedure SetWindowBounds(ABounds: TSDL_Rect);
    procedure SetWindowClient(AClient: TSDL_Rect);
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
    property Monitor: Integer read FMonitorIndex;
    property MonitorIndex: Integer write SetMonitorIndex;
  public
    property WindowSize: Integer read FWindowSize write SetWindowSize;
    property WindowBounds: TSDL_Rect read FWindowBounds write SetWindowBounds;
    property WindowClient: TSDL_Rect read FWindowClient write SetWindowClient;
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


constructor TPlacement.Create();
begin
  FMonitorIndex := 0;
  SDL_GetDisplayBounds(FMonitorIndex, @FMonitorBounds);

  FWindowSize := SIZE_DEFAULT;

  UpdateWindowBounds();
  UpdateWindowClient();
end;


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


procedure TPlacement.UpdateWindowCursor();
begin
  if FVideoEnabled or (FWindowSize = SIZE_FULLSCREEN) then
    SDL_ShowCursor(SDL_DISABLE)
  else
    SDL_ShowCursor(SDL_ENABLE);
end;


procedure TPlacement.UpdateWindowHitTest();
begin
  if FVideoEnabled or (FWindowSize = SIZE_FULLSCREEN) then
    SDL_SetWindowHitTest(Window.Window, nil, nil)
  else
    SDL_SetWindowHitTest(Window.Window, @WindowHitTest, nil);
end;


procedure TPlacement.UpdateWindowPlacement();
begin
  SDL_SetWindowSize(Window.Window, FWindowBounds.W, FWindowBounds.H);
  SDL_SetWindowPosition(Window.Window, FWindowBounds.X, FWindowBounds.Y);
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
  UpdateWindowHitTest();
  UpdateWindowPlacement();
end;


procedure TPlacement.UpdateBuffer();
begin
  if FVideoEnabled or (FWindowSize = SIZE_FULLSCREEN) then
    Buffers.Client := FWindowClient;
end;


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


procedure TPlacement.ExposeWindow();
begin
  if not FVideoEnabled then
    SDL_GetWindowPosition(Window.Window, @FWindowBounds.X, @FWindowBounds.Y);
end;


procedure TPlacement.ToggleVideoMode();
begin
  FVideoEnabled := not FVideoEnabled;
  UpdateVideo();
end;


end.

